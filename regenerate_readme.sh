#!/bin/sh

# Navigate to the repository root
cd $(git rev-parse --show-toplevel)

mkdir -p tmp

fetch_file_from_branch() {
	local file_path=$1
	local default_branch=$2
	
	local branch_name=$(git rev-parse --abbrev-ref HEAD)

	# Try to fetch the file from the current branch
	local status_code=$(curl -o "./tmp/${file_path}" -s -w "%{http_code}" "https://raw.githubusercontent.com/cubert-hyperspectral/cuvis.sdk/${branch_name}/readme/${file_path}")
	
	# If the file was not found (HTTP 404), fetch it from the default branch
    if [ "$status_code" -eq 404 ]; then
		echo "Retry with fallback"
		status_code=$(curl -o "./tmp/${file_path}" -s -w "%{http_code}" "https://raw.githubusercontent.com/cubert-hyperspectral/cuvis.sdk/${default_branch}/readme/${file_path}")
    fi
	
	if [ "$status_code" -eq 404 ]; then
		echo "could not load file ${file_path}"
		exit 1
	fi
}

fetch_file_from_branch "logo.md" "main"
fetch_file_from_branch "header.md" "main"
fetch_file_from_branch "footer.md" "main"

cat tmp/logo.md > README.md
printf "# cuvis.c\n" >> README.md
cat tmp/header.md >> README.md
printf "\n" >> README.md
cat README.in >> README.md
cat tmp/footer.md >> README.md

rm tmp/*
rmdir tmp
