# Contributing to Linprog

Thank you for considering contributing to Linprog! This document outlines the guidelines for contributing to the project, including how to report bugs, suggest improvements, and submit code changes.

## Bug Reports

### Where to Find Known Issues

We are using GitHub Issues for our public bugs. We keep a close eye on this and try to make it clear when we have an internal fix in progress. Before filing a new task, try to make sure your problem does not already exist.

### Reporting New Issues

If you encounter any bugs or issues with Linprog, please submit a detailed bug report. Your report should include the following information:

- Steps to reproduce the bug
- Expected behavior
- Actual behavior
- Error messages (if any)

Bug reports should be submitted via the Issues tab on the `linprog` GitHub repository.

## Feature Requests

If you have an idea for a new feature or improvement to Linprog, please submit a feature request. Your request should include the following information:

- Description of the new feature or improvement
- Rationale for why the feature or improvement is needed
- Any relevant use cases or examples
- Any potential drawbacks or limitations

Feature requests should be submitted via the Issues tab on the `linprog` GitHub repository.

## Branch Organization

Submit all changes directly to the main branch. We do not use separate branches for development or for upcoming releases. We do our best to keep main in good shape, with all tests passing.

Code that lands in main must be compatible with the latest stable release. It may contain additional features, but no breaking changes. We should be able to release a new minor version from the tip of main at any time.

## Contributing Code

### Part A: getting access to the repositories

If you would like to contribute code to Linprog, the first you need to do is to have a user on GitHub. If you do not have one, the section [How to create a user on GitHub](https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github) explains how to do it.

### Part B: Submitting your contributions

1. Fork the repository that is relevant to your contribution.
2. Clone your forked repository to your local machine.
3. Make your changes in fork version, directly to the main branch. We do not use separate branches for development or for upcoming releases. We do our best to keep main in good shape, with all tests passing.
4. Any significant changes should be accompanied by tests.
5. All contributions must be licensed *BSD 2-Clause*.
6. Submit a pull request to original repository of Linprog project.

Before submitting a pull request, please locally run your code against provided tests to ensure that it meets our standards.

## Testing/Debugging

You can find the instructions on how to run/create tests for Linprog [here](./../tests/README.md#usage) and how to run/create benchmarks [here](./../benchmarking/README.md).

### How the contributions are processed?

Our maintainers estimate usefulness and significance of every contribution received, fetch & pull actual state of `main` branch to your code, run CI pipelines and accept/reject depending on the result.

If the actual state of `main` branch cannot be merged automatically with your contribution (unable to resolve conflicts automatically/on our own), your contribution will be reverted so you can update its actual state and submit it again.

## License

By contributing to Linprog, you agree that your contributions will be licensed under its [BSD 2-Clause]().

[BSD 2-Clause]: https://opensource.org/license/bsd-2-clause

## Conclusion

Thank you for your interest in contributing to Linprog! We value all contributions, big and small. If you have any questions or concerns, please do not hesitate to reach out to us via the Issues tab on the linprog GitHub repository.
