#!/bin/sh
lpadmin -p MyPrinter -E -v file:///tmp/fake_printer_output -m raw
lpoptions -d MyPrinter