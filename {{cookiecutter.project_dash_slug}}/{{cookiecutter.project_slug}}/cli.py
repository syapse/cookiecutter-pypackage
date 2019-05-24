# -*- coding: utf-8 -*-

"""Console script for {{cookiecutter.project_slug}}."""
import sys
import click
import {{cookiecutter.project_slug}}
from decouple import config

USER = config("USER")


@click.command()
def main():
    """Console script for {{cookiecutter.project_slug}}."""
    click.echo(
        f"Hello, {USER}! Replace this message by putting your code into "
        f"{{cookiecutter.project_slug}}.cli.main")


if __name__ == "__main__":
    sys.exit(main())  # pragma: no cover
