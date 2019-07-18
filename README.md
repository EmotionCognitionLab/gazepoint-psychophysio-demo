# gazepoint-psychophysio-demo
A series of pupillometry experiments using Gazepoint GP3 eye-tracking 
hardware. This toolbox is meant to be a convenient way to iterate through 
variations in experiment design. For example, if you want to know which of
5 negative auditory stimuli elicits the greatest pupillary response before
deciding on the one the include in your study, you may quickly pilot these
sounds using the Sounds App to make informed design decisions.

Includes a user interface for simple connect/disconnect and 
start/stop control of the GP3 eye-tracker and the experiment. The 
experimenter user interface and back-end are Matlab-based.

## Hardware
1. Gazepoint GP3 Eye-tracker and its provided accessories
2. A Windows PC that is compatible with your Gazepoint hardware
3. Headphones (optional)

## Software
1. Matlab (ver 9.6.0.1099231 (R2019a) Update 1) - This is the version that was used when testing this toolbox. No guarantees that the toolbox is stable with future or past Matlab versions.
2. Matlab Dependency - Instrument Control Toolbox
3. Gazepoint Control

## Installation
1. Install the Gazepoint applications from [their website](https://www.gazept.com/downloads/ "gazepoint download page") using the credentials provided with your Gazepoint hardware purchase.
2. Download this gazepoint-psychophysio-toolbox onto your local machine.

## Experiment Set-up
These are suggested guidelines for setting up a pupillometry experiment without 
any computer-presented visual stimuli.

Attach some sort of fixation point at eye-level. This could be a print-out of a fixation cross taped to a wall or a poster placed on the table.
The eye-tracker should be placed about 20 cm in front of the fixation point. The subject should sit about 80 cm in front of the fixation cross and 60 cm in front of the eye-tracker.  Acceptable operating distance between the participant and the eye-tracker is 50 cm to 80 cm. 

## Usage
These apps are simple pupillometry experiments with some configurable
options.

### Sounds App
Presents any audio file and measures a participant's pupillary response to the auditory stimuli.
User Configurations:
* Any audio file (.wav or .mp3) - to load in your audio file, put your audio in the ../Stimuli/Sounds sub-folder and click the refresh button next to the selec audio file drop-down menu.
* The ear that the audio is presented
* Durations of the baseline and post-audio periods

### Two Tones App
Presents two tones as cues for participant to perform certain tasks. Records participant's pupillary response during baseline, task event, and post-task event. The task can be anything that does not require participant to avert gaze (e.g., a isometric exercise or cold pressor task).
User Configurations:
* The frequency (Hz) and duration (s) of the two tones
* The ear that the audio is presented
* Durations of the baseline, task, and post-task periods

### Looming App
Presents a looming, receding, or constant tone to the participant.
User Configurations:
* The frequency (Hz) and duration (s) of the two tones
* The type of tone (looming, receding, or constant)
* The ear that the audio is presented
* Durations of the baseline, task, and post-task periods