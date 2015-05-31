#!/usr/bin/env python
'''processaudio

This comand line script manages the process of handling video and audio normalization for posting to public sites. 

Usage: 
	processaudio video <VIDEO_FILE> [<NOISE_FILE>] [--working_directory <WORKING_DIRECst_intro_files <PODCAST_INTRO_FILES>]
			[--podcast_outro_files <PODCAST_OUTRO_FILES>] [--keep_old_files]
'''
from docopt import docopt
from subprocess import call
import logging
import time

arguments = docopt(__doc__, version='podcast-processor 0.1')

if arguments['--debug']:
    level = logging.DEBUG
else:
    level = logging.INFO

working_directory = arguments.get('--working_directory', '/media')

file_timestamp = time.strftime("%Y%m%d-%H%M%S")

logging.basicConfig(format='%(asctime)s %(levelname)s:%(message)s', level=level)

file_map = {}

def rip_audio_from_video(video_file_path, raw_audio_file_path=None): 
	if raw_audio_file_path == None: 
		raw_audio_file_path = 'raw_audio-' + file_timestamp + '.mp3'
	rip_cmd = ['ffmpeg', '-i', video_file_path, '-b:a', arguments.get('--video_rip_bitrate', '256') + 'K', '-vn', raw_audio_file_path]
	if call(rip_cmd, shell=True) == 0: 
		return raw_audio_file_path
	else: 
		raise Exception('Non-zero output for rip_audio_from_file for command: ' + ' '.join(rip_cmd))

if arguments.get('<VIDEO_FILE>', None):
	audio_file = rip_audio_from_video(arguments.get('<VIDEO_FILE>', None))
	arguments['--audio_file'] = audio_file

def normalize_audio(input_file, output_file, noise_file=None):
	file_params = ['sox', input_file, output_file]
	if noise_file != None: 
		file_params.append('noisered')
		file_params.append(noise_file)