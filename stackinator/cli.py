import argparse
import os
import sys

from . import VERSION

def make_argparser():
    parser = argparse.ArgumentParser(
        description=(
            "stackinator - a tool for configuriing software stacks at CSCS"
        )
    )
    parser.add_argument(
        "--version", action="version", version=f"stackinator version {VERSION}"
    )

    subparsers = parser.add_subparsers(dest='command')

    # Subparser for adding a cluster
    add_cluster = subparsers.add_parser('cluster-add', help='add cluster configuration')
    add_cluster.add_argument('path', help='the path with the cluster configuration', type=str)

    # Subparser for listing available clusters
    list_cluster = subparsers.add_parser('cluster-list', help='list available clusters')

    # Subparser for configure-cache
    configure_cache = subparsers.add_parser('configure-cache')
    configure_cache.add_argument(
        "-k", "--key", required=False, type=str,
        help="path to the gpg key used to sign packages - required to update the cache.")
    configure_cache.add_argument(
        "-p", "--cache-path", required=False, type=str,
        help="path to the build cache - if provided without a key the cache will be read only.")
    configure_cache.add_argument("-d", "--disable", action="store_true",
        help="disable the build cache")
    configure_cache.add_argument("--read-only", action="store_true",
        help="force a read only cache")
    configure_cache.add_argument('recipe', help="the path of the recipe to configure")

    return parser

def cli():
    try:
        parser = make_argparser()
        args = parser.parse_args()
        print(args)
        return 0
    except Exception as e:
        print(str(e))
        return 1


