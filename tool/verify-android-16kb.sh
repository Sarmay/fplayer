#!/usr/bin/env bash

set -euo pipefail

APK_PATH=${1:-}
if [ -z "$APK_PATH" ] || [ ! -f "$APK_PATH" ]; then
    echo "Usage: $0 path/to/app.apk" >&2
    exit 1
fi

ANDROID_NDK=${ANDROID_NDK:-${ANDROID_NDK_HOME:-}}
if [ -z "$ANDROID_NDK" ]; then
    echo "ANDROID_NDK must point to Android NDK r28 or newer" >&2
    exit 1
fi

READELF=
for CANDIDATE in "$ANDROID_NDK"/toolchains/llvm/prebuilt/*/bin/llvm-readelf*; do
    if [ -x "$CANDIDATE" ]; then
        READELF=$CANDIDATE
        break
    fi
done
if [ -z "$READELF" ]; then
    echo "llvm-readelf was not found under $ANDROID_NDK/toolchains/llvm/prebuilt" >&2
    exit 1
fi

ANDROID_SDK=${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}
ANDROID_BUILD_TOOLS_VERSION=${ANDROID_BUILD_TOOLS_VERSION:-35.0.0}
ZIPALIGN="$ANDROID_SDK/build-tools/$ANDROID_BUILD_TOOLS_VERSION/zipalign"
if [ ! -x "$ZIPALIGN" ]; then
    echo "zipalign was not found at $ZIPALIGN" >&2
    exit 1
fi

if ! ARCHIVE_ENTRIES=$(unzip -Z1 "$APK_PATH"); then
    echo "Unable to list APK entries: $APK_PATH" >&2
    exit 1
fi
if ! grep -q '^lib/' <<< "$ARCHIVE_ENTRIES"; then
    echo "APK does not contain native libraries" >&2
    exit 1
fi

EXPECTED_ABIS_CSV=${FPLAYER_EXPECTED_ABIS:-arm64-v8a,armeabi-v7a,x86_64}
REQUIRED_LIBRARY_ABIS_CSV=${FPLAYER_REQUIRED_LIBRARY_ABIS:-$EXPECTED_ABIS_CSV}
IFS=',' read -r -a ABIS <<< "$EXPECTED_ABIS_CSV"
IFS=',' read -r -a REQUIRED_LIBRARY_ABIS <<< "$REQUIRED_LIBRARY_ABIS_CSV"
REQUIRED_LIBRARIES=(libijkffmpeg.so libijkplayer.so libijksdl.so)

EXPECTED_ABIS=$(printf '%s\n' "${ABIS[@]}" | sed '/^$/d' | LC_ALL=C sort -u)
ACTUAL_ABIS=$(
    printf '%s\n' "$ARCHIVE_ENTRIES" |
        awk -F/ '$1 == "lib" && NF >= 3 && $2 != "" { print $2 }' |
        LC_ALL=C sort -u
)
if [ "$ACTUAL_ABIS" != "$EXPECTED_ABIS" ]; then
    echo "Unexpected ABI set in APK" >&2
    echo "Expected:" >&2
    printf '%s\n' "$EXPECTED_ABIS" >&2
    echo "Actual:" >&2
    printf '%s\n' "$ACTUAL_ABIS" >&2
    exit 1
fi

for REQUIRED_ABI in "${REQUIRED_LIBRARY_ABIS[@]}"; do
    REQUIRED_ABI_FOUND=0
    for ABI in "${ABIS[@]}"; do
        if [ "$REQUIRED_ABI" = "$ABI" ]; then
            REQUIRED_ABI_FOUND=1
            break
        fi
    done
    if [ "$REQUIRED_ABI_FOUND" -ne 1 ]; then
        echo "Required core ABI is not present in expected ABI set: $REQUIRED_ABI" >&2
        exit 1
    fi
done

for ABI in "${ABIS[@]}"; do
    case "$ABI" in
        arm64-v8a) EXPECTED_MACHINE=AArch64 ;;
        armeabi-v7a) EXPECTED_MACHINE=ARM ;;
        x86) EXPECTED_MACHINE='Intel 80386' ;;
        x86_64) EXPECTED_MACHINE='Advanced Micro Devices X86-64' ;;
        *) echo "Unsupported ABI in verifier: $ABI" >&2; exit 1 ;;
    esac

    REQUIRE_CORE_LIBRARIES=0
    for REQUIRED_ABI in "${REQUIRED_LIBRARY_ABIS[@]}"; do
        if [ "$ABI" = "$REQUIRED_ABI" ]; then
            REQUIRE_CORE_LIBRARIES=1
            break
        fi
    done
    if [ "$REQUIRE_CORE_LIBRARIES" -eq 1 ]; then
        for LIBRARY in "${REQUIRED_LIBRARIES[@]}"; do
            ELF_RELATIVE_PATH="lib/$ABI/$LIBRARY"
            if ! grep -Fxq "$ELF_RELATIVE_PATH" <<< "$ARCHIVE_ENTRIES"; then
                echo "Missing native library: lib/$ABI/$LIBRARY" >&2
                exit 1
            fi
        done
    fi

    ELF_COUNT=0
    ELF_ENTRIES=$(
        printf '%s\n' "$ARCHIVE_ENTRIES" |
            awk -v prefix="lib/$ABI/" \
                'index($0, prefix) == 1 && $0 ~ /\.so$/ { print }'
    )
    while IFS= read -r ELF_RELATIVE_PATH; do
        if [ -z "$ELF_RELATIVE_PATH" ]; then
            continue
        fi
        ELF_COUNT=$((ELF_COUNT + 1))
        if ! ELF_METADATA=$(
            unzip -p "$APK_PATH" "$ELF_RELATIVE_PATH" |
                "$READELF" -hW -lW -
        ); then
            echo "Unable to inspect native library: $ELF_RELATIVE_PATH" >&2
            exit 1
        fi
        ELF_MACHINE=$(
            printf '%s\n' "$ELF_METADATA" |
                awk -F: '/Machine:/ { sub(/^[[:space:]]+/, "", $2); print $2; exit }'
        )
        if [ "$ELF_MACHINE" != "$EXPECTED_MACHINE" ]; then
            echo "Invalid machine $ELF_MACHINE in $ELF_RELATIVE_PATH; expected $EXPECTED_MACHINE" >&2
            exit 1
        fi

        LOAD_ALIGNMENTS=$(
            printf '%s\n' "$ELF_METADATA" |
                awk '$1 == "LOAD" { print $NF }'
        )
        if [ -z "$LOAD_ALIGNMENTS" ]; then
            echo "No LOAD segments found in $ELF_RELATIVE_PATH" >&2
            exit 1
        fi

        while IFS= read -r ALIGNMENT; do
            ALIGNMENT_VALUE=$((ALIGNMENT))
            if (( ALIGNMENT_VALUE < 16384 || ALIGNMENT_VALUE % 16384 != 0 )); then
                echo "Invalid LOAD alignment $ALIGNMENT in $ELF_RELATIVE_PATH" >&2
                exit 1
            fi
        done <<< "$LOAD_ALIGNMENTS"

        echo "Verified ELF alignment: $ELF_RELATIVE_PATH"
    done <<< "$ELF_ENTRIES"

    if [ "$ELF_COUNT" -eq 0 ]; then
        echo "No native libraries found for ABI: $ABI" >&2
        exit 1
    fi
done

"$ZIPALIGN" -c -P 16 -v 4 "$APK_PATH"
echo "Verified 16KB ELF and APK alignment: $APK_PATH"
