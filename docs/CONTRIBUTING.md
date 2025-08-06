# Contributing to linprog

Thank you for considering contributing to linprog! This document outlines the guidelines for contributing to the project, including how to report bugs, suggest improvements, and submit code changes.

Please note that by contributing to this project, you are agreeing to the terms set out in the [Developer Certificate of Origin (DCO)]. To ensure this, we require that every commit should be signed with `--signoff` option. This will provide us your credentials, such as name and email.

[Developer Certificate of Origin (DCO)]: https://developercertificate.org/

## Bug Reports

### Where to Find Known Issues

We are using GitHub Issues for our public bugs. We keep a close eye on this and try to make it clear when we have an internal fix in progress. Before filing a new task, try to make sure your problem doesn’t already exist.

### Reporting New Issues

If you encounter any bugs or issues with linprog, please submit a detailed bug report. Your report should include the following information:

- Steps to reproduce the bug
- Expected behavior
- Actual behavior
- Error messages (if any)
- Screenshots (if applicable)

Bug reports should be submitted via the Issues tab on the `linprog` Gitlab repository.

## Feature Requests

If you have an idea for a new feature or improvement to the Energy4Life website, please submit a feature request. Your request should include the following information:

- Description of the new feature or improvement
- Rationale for why the feature or improvement is needed
- Any relevant use cases or examples
- Any potential drawbacks or limitations

Feature requests should be submitted via the Issues tab on the `linprog` GitHub repository.

## Branch Organization

Submit all changes directly to the main branch. We don’t use separate branches for development or for upcoming releases. We do our best to keep main in good shape, with all tests passing.

Code that lands in main must be compatible with the latest stable release. It may contain additional features, but no breaking changes. We should be able to release a new minor version from the tip of main at any time.

## Contributing Code

### Part A: getting access to the repositories

If you would like to contribute code to linprog, the first you need to do is to have a user on GitHub. If you don't have one, the section [How to create a user on GitHub](https://docs.github.com/en/get-started/start-your-journey/creating-an-account-on-github) explains how to do it.

### Part B: Submitting your contributions

1. Fork the repository that is relevant to your contribution.
2. Clone your forked repository to your local machine.
3. Make your changes in fork version, directly to the main branch. We don’t use separate branches for development or for upcoming releases. We do our best to keep main in good shape, with all tests passing.
4. Any significant changes should be accompanied by tests.
5. All contributions must be licensed ?AGPL v3.?
6. Submit a pull request to original repository of Energy4Life project.

Before submitting a pull request, please locally run your code against any available tests to ensure that it meets our standards.

<!-- ## Testing/Debugging -->

<!-- For the moment, the project relies on some outdated packages, which can have conflicts with the environment on contributor's host. Thus, for testing purposes, we recommend to use the Dockerised version of project, [here] you can find the instructions on how you can deploy it.

Otherwise, both frontend and backend repos are provided with README files with the instructions for local run.

[here]: https://gitlab.com/uniluxembourg/fstm/open/e4l/lu.uni.e4l.platform.documentation/-/blob/master/Dockerised.md -->

### How the contributions are processed?

Our maintainers estimate usefulness and significance of every contribution received, fetch & pull actual state of `main` branch to your code, run CI pipelines and accept/reject depending on the result.

If the actual state of `main` branch cannot be merged automatically with your contribution (unable to resolve conflicts automatically/on our own), your contribution will be reverted so you can update its actual state and submit it again.

<!-- ## Prerequisites

Here you can find more detailed instructions concerning working on contributions for Energy4Life project:

- Back-end: [lu.uni.e4l.platform.api.dev]
- Front-end: [lu.uni.e4l.platform.frontend.dev]

[lu.uni.e4l.platform.api.dev]: https://gitlab.com/uniluxembourg/fstm/open/e4l/lu.uni.e4l.platform.api.dev/-/blob/master/README.md
[lu.uni.e4l.platform.frontend.dev]: https://gitlab.com/uniluxembourg/fstm/open/e4l/lu.uni.e4l.platform.frontend.dev/-/blob/master/README.md

## Code Style

The Energy4Life website is built on Java Spring and ReactJS. We follow the coding standards set out by the Java and ReactJS communities, respectively.

- Java code should be formatted using the Google Java Style Guide
- ReactJS code should be formatted using the Prettier code formatter -->

## ?License?

By contributing to Energy4Life (e4l), you agree that your contributions will be licensed under its [AGPL v3 license][].

[AGPL v3 license]: https://www.gnu.org/licenses/agpl-3.0.en.html

## Conclusion

Thank you for your interest in contributing to linprog! We value all contributions, big and small. If you have any questions or concerns, please don't hesitate to reach out to us via the Issues tab on the linprog GitHub repository.
