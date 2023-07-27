mv nvchad/lua/custom custom
rm -rf nvchad
git clone https://github.com/NvChad/NvChad nvchad --depth 1
mv custom nvchad/lua/custom
rm -rf nvchad/.git nvchad/.github
rm nvchad/.gitignore
