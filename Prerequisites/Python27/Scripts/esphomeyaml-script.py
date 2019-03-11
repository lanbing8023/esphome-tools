#!F:\all\esphome-tools\DoNotModifyThisFolder\Python27\python.exe
# EASY-INSTALL-ENTRY-SCRIPT: 'esphome==1.11.2','console_scripts','esphomeyaml'
__requires__ = 'esphome==1.11.2'
import re
import sys
from pkg_resources import load_entry_point

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(
        load_entry_point('esphome==1.11.2', 'console_scripts', 'esphomeyaml')()
    )
