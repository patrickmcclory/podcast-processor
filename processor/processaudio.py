#!/usr/bin/env python
from docopt import docopt
from subprocess import call
import logging

arguments = docopt(__doc__, version='podcast-processor 0.1')

if arguments['--debug']:
    level = logging.DEBUG
else:
    level = logging.INFO

working_directory = arguments.get('--working_directory', '/media')

logging.basicConfig(format='%(asctime)s %(levelname)s:%(message)s', level=level)

def normalize_audio(input_file, output_file, noise_file=None):
	file_params = ['sox', input_file, output_file]
	if noise_file != None: 
		file_params.append('noisered')
		file_params.append(noise_file)