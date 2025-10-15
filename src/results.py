#!/usr/bin/env python

import sys
from pathlib import Path
from robot.api import ExecutionResult, ResultVisitor
from robot.result.model import TestCase, TestSuite, StatusMixin, Keyword


class MarkdownPrinter(ResultVisitor):

    def __init__(self, roots: list[str]):
        self.roots = list(map(Path, roots))
        self.indent = 0

    def start_suite(self, suite: TestSuite):
        if len(suite.suites) > 0:
            return

        self.start_collapsed(self.get_status_emoji(suite), self.truncate_path(suite.source))
        self.print(f'Test suite took `{suite.elapsed_time}` to execute')

    def end_suite(self, suite: TestSuite):
        if len(suite.suites) > 0:
            return

        self.end_collapsed()

    def visit_test(self, test: TestCase):
        self.start_collapsed_li(self.get_status_emoji(test), test.name)
        self.print(f'Test took `{test.elapsed_time}` to execute')
        if test.failed:
            self.print(f'Test case failed with: `{test.message}`')
        self.print_body(test)
        self.end_collapsed_li()


    def get_status_emoji(self, obj: StatusMixin) -> str:
        if obj.status == StatusMixin.PASS:
            return ':white_check_mark:'
        if obj.status == StatusMixin.FAIL:
            return ':x:'
        return ':fast_forward:'

    def truncate_path(self, path: Path) -> Path:
        for root in self.roots:
            if path.is_relative_to(root):
                return path.relative_to(root)
        return path

    def print_body(self, keyword: Keyword):
        for child in self.get_keywords(keyword):
            self.start_collapsed_li(self.get_status_emoji(child), child)
            self.print_body(child)
            self.end_collapsed_li()

    def get_keywords(self, test: TestCase) -> list[Keyword]:
        return [child for child in test.body if isinstance(child, Keyword)]

    def print(self, *args, **kwargs):
        print(' ' * (self.indent * 2), end='')
        print(*args, **kwargs)

    def start_collapsed_li(self, *args, **kwargs):
        self.print('- <details><summary>')
        self.indent += 1
        self.print(*args, **kwargs)
        self.print('</summary>', end='\n\n')

    def start_collapsed(self, *args, **kwargs):
        self.print('<details><summary>')
        self.print(*args, **kwargs)
        self.print('</summary>', end='\n\n')

    def end_collapsed_li(self):
        self.end_collapsed()
        self.indent -= 1

    def end_collapsed(self):
        self.print('</details>', end='\n\n')


if __name__ == '__main__':
    result = ExecutionResult(sys.argv[1])
    result.visit(MarkdownPrinter(sys.argv[2:]))
