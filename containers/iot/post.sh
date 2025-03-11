#!/bin/sh

# Sleep for a while before things get started
sleep 3

# Register a printer
lpadmin -p MyPrinter -E -v file:///tmp/fake_printer_output -m raw
lpoptions -d MyPrinter
echo "Test Print Job" | lp -d MyPrinter -t "secret"