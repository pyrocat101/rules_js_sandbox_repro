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
        },
        **kwargs
    )
