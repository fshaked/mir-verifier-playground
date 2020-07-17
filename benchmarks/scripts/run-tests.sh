#!/usr/bin/env bash

: ${TIMEOUT:=45s}

run_test()
{
    local -r exp="$1"
    local -r file="$2"

    test="${file#tests/}"
    test="${test%.rs}"

    timeout "$TIMEOUT" cargo crux-test --test "$test"
    case "$?" in
        124)
            # The test timed out
            killall crux-mir
            eval "${exp}_timeout+=('$file')"
            ;;
        0)
            # The test succeeded
            eval "${exp}_pass+=('$file')"
            ;;
        *)
            # The test failed
            eval "${exp}_fail+=('$file')"
    esac
}


for file in tests/*.rs ; do
    case "$(sed -En 's/.*@expect (.+)$/\1/p' "$file")" in
        error)
            run_test error "$file"
            ;;
        overflow)
            run_test overflow "$file"
            ;;
        reachable)
            run_test reachable "$file"
            ;;
        verified)
            run_test verified "$file"
            ;;
        *)
            echo "Unknown @expect case"
            exit 1
    esac
done

echo
echo "=========================================================================="
echo "'@expect error' tests:"
if [[ "${#error_pass[@]}" -gt 0 ]] ; then
    echo "exit code == 0 (should be empty):"
    printf "  %s\n" "${error_pass[@]}"
    echo
fi
if [[ "${#error_fail[@]}" -gt 0 ]] ; then
    echo "exit code != 0:"
    printf "  %s\n" "${error_fail[@]}"
    echo
fi
if [[ "${#error_timeout[@]}" -gt 0 ]] ; then
    echo "timed out (should be empty):"
    printf "  %s\n" "${error_timeout[@]}"
    echo
fi

echo "=========================================================================="
echo "'@expect overflow' tests:"
if [[ "${#overflow_pass[@]}" -gt 0 ]] ; then
    echo "exit code == 0 (should be empty):"
    printf "  %s\n" "${overflow_pass[@]}"
    echo
fi
if [[ "${#overflow_fail[@]}" -gt 0 ]] ; then
    echo "exit code != 0:"
    printf "  %s\n" "${overflow_fail[@]}"
    echo
fi
if [[ "${#overflow_timeout[@]}" -gt 0 ]] ; then
    echo "timed out (should be empty):"
    printf "  %s\n" "${overflow_timeout[@]}"
    echo
fi

echo "=========================================================================="
echo "'@expect reachable' tests:"
if [[ "${#reachable_pass[@]}" -gt 0 ]] ; then
    echo "exit code == 0 (should be empty):"
    printf "  %s\n" "${reachable_pass[@]}"
    echo
fi
if [[ "${#reachable_fail[@]}" -gt 0 ]] ; then
    echo "exit code != 0:"
    printf "  %s\n" "${reachable_fail[@]}"
    echo
fi
if [[ "${#reachable_timeout[@]}" -gt 0 ]] ; then
    echo "timed out (should be empty):"
    printf "  %s\n" "${reachable_timeout[@]}"
    echo
fi

echo "=========================================================================="
echo "'@expect verified' tests:"
if [[ "${#verified_pass[@]}" -gt 0 ]] ; then
    echo "exit code == 0:"
    printf "  %s\n" "${verified_pass[@]}"
    echo
fi
if [[ "${#verified_fail[@]}" -gt 0 ]] ; then
    echo "exit code != 0 (should be empty):"
    printf "  %s\n" "${verified_fail[@]}"
    echo
fi
if [[ "${#verified_timeout[@]}" -gt 0 ]] ; then
    echo "timed out (should be empty):"
    printf "  %s\n" "${verified_timeout[@]}"
fi
