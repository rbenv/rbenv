#!/usr/bin/env bash
#
# Generating rvm self documents
#

# uncomment for debugging
#set -x

# checking system requirements
[[ `which asciidoc 2> /dev/null` ]] || (echo "'asciidoc' is not installed on your system, exiting..."; exit 1)
[[ `which docbook2man 2> /dev/null` ]] || (echo "'docbook2x' is not installed on your system, exiting..."; exit 1)

DIRNAME=$(dirname $0)
rvm_base_dir=$(cd $DIRNAME/../; pwd)
rvm_docs_src_dir=${rvm_base_dir}/docs
rvm_tmp_dir=${rvm_base_dir}/tmp
rvm_docs_target_man_dir=${rvm_base_dir}/man

\mkdir -p ${rvm_tmp_dir}
\mkdir -p ${rvm_docs_target_man_dir}

echo "Starting doc generation run through."

# processing manpages
find ${rvm_docs_src_dir} -type f -name *.txt | while read rvm_manpage_file; do

    # trying to detect manpage name automatically
    # (just for fun, I don't think, that rvm will ever have more then one manpage :)
    # The name of the generated manpage is initially specified within the source file in asciidoc format,
    # so we'll do some simple parsing
    # We assume, that it will be specified at one of the 3 (three) first lines
    # of the source file.

    # it should be something like 'RVM(1)'
    rvm_manpage_name_full="$(head -n 3 < "$rvm_manpage_file" | \grep -o '^[^(]*[(][^)]*[)]$')"

    if [[ -z "${rvm_manpage_name_full}" ]]; then
      echo "Unable to detect manpage name, stopping build process..." 1>&2
      exit 1
    fi

    # we need smth like 'rvm.1'
    rvm_manpage_name="$(echo "$rvm_manpage_name_full" | sed "s|(|.|;s|)||" | tr '[[:upper:]]' '[[:lower:]]')"
    # we need '1'
    rvm_manpage_name_part=$(echo "$rvm_manpage_name" | cut -d '.' -f 2)
    # So, the manpage directory will be the following:
    rvm_manpage_dir="$rvm_docs_target_man_dir/man$rvm_manpage_name_part"
    mkdir -p "$rvm_manpage_dir"

    echo "Generating manpage format from source file for $rvm_manpage_name"
    a2x -d manpage -f manpage -D "$rvm_manpage_dir" "$rvm_manpage_file" > /dev/null 2>&1
    if [[ "$?" -gt 0 ]]; then
      echo "Unable to generate manpage for $rvm_manpage_name_full"
    else
      \rm -f "$( echo "$rvm_manpage_file" | sed 's/.txt$/.xml/')"
      # compression is optional, but gzip check added for neatness
      if command -v gzip >/dev/null 2>&1; then
        echo "gzip compressing the manpage"
        gzip < "$rvm_manpage_dir/$rvm_manpage_name" > "$rvm_manpage_dir/$rvm_manpage_name.gz"
      fi
    fi
done

# vim: ft=sh
