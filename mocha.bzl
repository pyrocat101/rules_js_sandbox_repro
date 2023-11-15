"""Cold-brew mocha tests served to you on demand."""

load("@npm//:mocha/package_json.bzl", "bin")

def mocha_test(name, tests, args = [], data = [], env = {}, **kwargs):
    bin.mocha_test(
        name = name,
        args = [
            "--reporter",
            "mocha-junit-reporter",
            "--reporter",
            "spec",
        ] + [
            native.package_name() + "/" + test
            for test in tests
        ] + args,
        data = data + [
            "//:node_modules/mocha-junit-reporter",
        ],
        env = env | {
            "MOCHA_FILE": "$$XML_OUTPUT_FILE",
            # Put our PWD first so we can avoid so many useless syscalls and optimally look up first-party code.
            "NODE_PATH": "$$PWD",
        },
        **kwargs
    )
