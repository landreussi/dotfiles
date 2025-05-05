# Didn't found a better way to do so, Git submodules was ignoring custom folder once `nvchad` repository does so,
# and home manager couldn't copy only custom folder into `.config/nvim`.
# Don't throw rocks in me please, this is quite a convenient way to update nvchad.
mv nvchad/lua/custom custom
rm -rf nvchad
git clone https://github.com/NvChad/NvChad nvchad --depth 1 --branch v2.0 --single-branch
mv custom nvchad/lua/custom
rm -rf nvchad/.git nvchad/.github
rm nvchad/.gitignore
