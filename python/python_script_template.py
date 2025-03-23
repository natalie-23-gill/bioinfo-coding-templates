#!/usr/bin/env python3

"""
Project: [Project Name]
Author: [Your Name]

Script Goal: [Brief description of the script's purpose]

Usage: [Example usage instructions]
"""

import argparse
import sys


def main(arguments):
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument('infile', help="Input file", type=argparse.FileType('r'))
    parser.add_argument('-o', '--outfile', help="Output file",
                        default=sys.stdout, type=argparse.FileType('w'))

    args = parser.parse_args(arguments)

    try:
        # Example processing: Read input and write to output
        data = args.infile.read()
        args.outfile.write(data)
    finally:
        args.infile.close()
        if args.outfile != sys.stdout:
            args.outfile.close()

    return 0  # Return success code


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))