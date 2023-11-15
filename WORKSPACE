workspace(name = "js_image_layer_repro")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "com_grail_bazel_toolchain",
    sha256 = "56906a00c996bacf899315e132076642bd5f46333607efce8ad6f8e857c6f8cd",
    strip_prefix = "bazel-toolchain-0a9feb723796f6eb9e9947ccffa629964ec4680f",
    urls = ["https://github.com/grailbio/bazel-toolchain/archive/0a9feb723796f6eb9e9947ccffa629964ec4680f.tar.gz"],
    patch_args = ["-p1"],
    patches = ["//:com_grail_bazel_toolchain.patch"],
)

_SYSROOT_LINUX_BUILD_FILE = """
# The sysroot is already significantly pruned.
srcs = glob(["**"])

# Uncomment these lines to examine the size of the sysroot.
#print (len(srcs))
#[print(f) for f in srcs]

filegroup(
    name = "sysroot",
    srcs = srcs,
    visibility = ["//visibility:public"],
)
"""

_SYSROOT_DARWIN_BUILD_FILE = """
srcs = glob(
    # Significantly cut down on the sysroot size by only including the headers we need.
    # It's ok to expand this as needed, but there are definitely headers/libs in the sysroot
    # that we should be building from source instead, so please ask for feedback before editing!
    include = [
        "usr/include/*.h",
        "usr/include/_types/**",
        "usr/include/arm/**",
        "usr/include/arpa/**",
        "usr/include/bsm/**",
        "usr/include/dispatch/**",
        "usr/include/libkern/**",
        "usr/include/mach/**",
        "usr/include/mach_debug/**",
        "usr/include/machine/*.h",
        "usr/include/malloc/**",
        "usr/include/net/**",
        "usr/include/netinet*/**",
        "usr/include/os/**",
        "usr/include/pthread/**",
        "usr/include/secure/**",
        "usr/include/sys/**",
        "usr/include/uuid/**",
        "usr/include/xlocale/**",
        "usr/include/FSEvents/**",
        "usr/include/CoreFoundation/**",
        # Most libs should be built from source, but grab the few libs we do want from the system.
        "usr/lib/libc.tbd",
        "usr/lib/libc++*",
        "usr/lib/libcharset*",
        "usr/lib/libiconv.tbd",
        "usr/lib/libm.tbd",
        "usr/lib/libobjc.tbd",
        "usr/lib/libresolv*",
        "usr/lib/libpthread.tbd",
        "usr/lib/libSystem*",
        "System/Library/Frameworks/CoreFoundation.framework/CoreFoundation.tbd",
        "System/Library/Frameworks/Foundation.framework/Foundation.tbd",
    ],
    exclude = [
        # Don't use system zlib, we build our own.
        "usr/include/zlib.h",
    ],
)

# Uncomment these lines to examine the size of the sysroot.
#print (len(srcs))
#[print(f) for f in srcs]

filegroup(
    name = "sysroot",
    srcs = srcs,
    visibility = ["//visibility:public"],
)
"""

http_archive(
    name = "org_chromium_sysroot_linux_arm64",
    build_file_content = _SYSROOT_LINUX_BUILD_FILE,
    sha256 = "63dfb6585e58f6e11cd2323d52c9099a5122beca2fddd0d9beda7e869a3b8f67",
    urls = ["https://github.com/DavidZbarsky-at/sysroot-min/releases/download/v0.0.19/debian_bullseye_arm64_sysroot.tar.xz"],
)

http_archive(
    name = "org_chromium_sysroot_linux_x86_64",
    build_file_content = _SYSROOT_LINUX_BUILD_FILE,
    sha256 = "4e8f85b2f349eb95e28e845183c135fddef58c02f14559065f5818a7e9216971",
    urls = ["https://github.com/DavidZbarsky-at/sysroot-min/releases/download/v0.0.19/debian_bullseye_amd64_sysroot.tar.xz"],
)

http_archive(
    name = "sysroot_darwin_universal",
    build_file_content = _SYSROOT_DARWIN_BUILD_FILE,
    sha256 = "11870a4a3d382b78349861081264921bb883440a7e0b3dd4a007373d87324a38",
    strip_prefix = "sdk-macos-11.3-ccbaae84cc39469a6792108b24480a4806e09d59/root",
    urls = ["https://github.com/hexops-graveyard/sdk-macos-11.3/archive/ccbaae84cc39469a6792108b24480a4806e09d59.tar.gz"],
)

load("@com_grail_bazel_toolchain//toolchain:rules.bzl", "llvm_toolchain")

LLVM_VERSION = "17.0.2"

STATIC_CLANG_VERSION = "17.0.2-8"

llvm_toolchain(
    name = "llvm_toolchain",
    llvm_version = LLVM_VERSION,
    sha256 = {
        "darwin-aarch64": "bb5144516c94326981ec78c8b055c85b1f6780d345128cae55c5925eb65241ee",
        "darwin-x86_64": "800ec8401344a95f84588815e97523a0ed31fd05b6ffa9e1b58ce20abdcf69f1",
        "linux-aarch64": "49eec0202b8cd4be228c8e92878303317f660bc904cf6e6c08917a55a638917d",
        "linux-x86_64": "0c5096c157e196a04fc6ac58543266caef0da3e3c921414a7c279feacc2309d9",
    },
    stdlib = {
        "darwin-aarch64": "builtin-libc++",
        "darwin-x86_64": "builtin-libc++",
        "linux-aarch64": "stdc++",
        "linux-x86_64": "stdc++",
    },
    sysroot = {
        "darwin-aarch64": "@sysroot_darwin_universal//:sysroot",
        "darwin-x86_64": "@sysroot_darwin_universal//:sysroot",
        "linux-aarch64": "@org_chromium_sysroot_linux_arm64//:sysroot",
        "linux-x86_64": "@org_chromium_sysroot_linux_x86_64//:sysroot",
    },
    urls = {
        "darwin-aarch64": ["https://github.com/dzbarsky/static-clang/releases/download/v%s/darwin_arm64_minimal.tar.xz" % STATIC_CLANG_VERSION],
        "darwin-x86_64": ["https://github.com/dzbarsky/static-clang/releases/download/v%s/darwin_amd64_minimal.tar.xz" % STATIC_CLANG_VERSION],
        "linux-aarch64": ["https://github.com/dzbarsky/static-clang/releases/download/v%s/linux_arm64_minimal.tar.xz" % STATIC_CLANG_VERSION],
        "linux-x86_64": ["https://github.com/dzbarsky/static-clang/releases/download/v%s/linux_amd64_minimal.tar.xz" % STATIC_CLANG_VERSION],
    },
)

load("@llvm_toolchain//:toolchains.bzl", "llvm_register_toolchains")

llvm_register_toolchains()
