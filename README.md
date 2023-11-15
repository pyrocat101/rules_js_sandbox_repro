```sh
pnpm install --frozen-lockfile
# will pass
bazel test --test_output=all //repro:repro_test

rm -rf node_modules
bazel clean
# will fail
bazel test --test_output=all //repro:repro_test
```
