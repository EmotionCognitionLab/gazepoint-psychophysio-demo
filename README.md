# gazepoint-psychophysio-demo
A series of pupillometry experiments using Gazepoint GP3 eye-tracking 
hardware. These apps offer a convenient way to conduct simple pupillometry experiments.

The apps in this toolbox includes a user interface that connects/disconnects and 
starts/stops control of the GP3 eye-tracker and the experiment. The code for the user interface and back-end are Matlab-based.

## Use Cases
I've personally used these apps in a class lecture to demonstrate to students how a pupillometry experiments can be conducted. 
These apps are also useful when designing new pupillometry studies. I often stress over small design details, but with these apps, you can quickly iterate through variations in your experiments and observe how they affect the pupillary response.

Some of my random ponderings:
- **How long does it take for a pupillary response to a certain audio to return to baseline levels?** This could be important to know in choosing a sufficiently long inter-stimulus interval so that the pupillary response from a prior stimuli does not interfere with the next. To figure this out, pilot your audio file with the Sounds App, noting the duration it takes for the pupillary response to return to baseline.
- **Does the same auditory cue affect older and younger adults differently?** Use the Two Tones App to compare the pupillary response of older versus younger adults to tones of varying pitches and/or durations.
- **I have several audio files and want to know which elicits the greatest pupillary response.** Use the Sounds App to compare pupillary responses to each audio file.
- **What is the optimal inter-digit interval in a digit span task?** Use the Digit Span app and vary the Digit Interval to see how it affects the pupillary response during the encoding period.

This could be a possible approach to systematically test changes to your experiments to help you make informed design decisions.

## Hardware
1. Gazepoint GP3 Eye-tracker and its provided accessories
2. A Windows PC that is compatible with your Gazepoint hardware
3. Headphones (optional)

## Software
1. Matlab (ver 9.6.0.1099231 (R2019a) Update 1) - This is the version that was used when developing this toolbox. No guarantees that the toolbox is stable with future or past Matlab versions.
2. Matlab Dependency - Instrument Control Toolbox
3. Gazepoint Control

## Installation
1. Install the Gazepoint applications from [their website](https://www.gazept.com/downloads/ "gazepoint download page") using the credentials provided with your Gazepoint hardware purchase.
2. Download this gazepoint-psychophysio-toolbox onto your local machine.

## Experiment Set-up
These are suggested guidelines for setting up a pupillometry experiment without 
any computer-presented visual stimuli.

Attach some sort of fixation point at eye-level. This could be a print-out of a fixation cross taped to a wall or a poster placed on the table.
The eye-tracker should be placed on a table about 20 cm in front of the fixation point. The subject should sit about 80 cm in front of the fixation cross and 60 cm in front of the eye-tracker.  Acceptable operating distance between the participant and the eye-tracker is 50 cm to 80 cm. 

## Usage
1. Launch the Gazepoint Control program.
2. Run GazepointDemo_menu.mlapp to launch the main menu. Select the experiment you want to run from the list:

![Main Menu](AppFiles/MainMenu.PNG)

3. After launching your selected experiment, modify your experiment configuration if you wish to do so.
4. Establish connections with the Gazepoint Control program (press the "connect" button).
5. When you and your participant are ready, start the experiment run (press "start experiment").
6. If you wish to cancel experiment prematurely, press the "stop experiment" button (note that this is a little buggy if you do so while sound out is playing).
7. After completing the experiment run, you can find the raw data files saved in the output folder. You can also interact with the plot by hovering over the axis and using the Matlab plotting toolbar.
8. Once you're finished using the app, close the window or or press the "return" back arrow to return to the main menu.

### Sounds App
Presents any audio file and measures a participant's pupillary response to the auditory stimuli.

Configuration Options:
- Any audio file (.wav or .mp3) - to load in your audio file, put your audio in the ../Stimuli/Sounds sub-folder and click the refresh button next to the selec audio file drop-down menu.
- The ear that the audio is presented
- Durations of the baseline and post-audio periods

![Sounds App](AppFiles/Sounds.PNG)

### Two Tones App
Presents two tones as cues for participant to perform certain tasks. Records participant's pupillary response during baseline, task event, and post-task event. The task can be anything that does not require participant to avert gaze (e.g., a isometric exercise or cold pressor task).

Configuration Options:
* The frequency (Hz) and duration (s) of the two tones
* The ear that the audio is presented
* Durations of the baseline, task, and post-task periods

![Two Tones App](AppFiles/TwoTones.PNG)

### Looming App
Presents a looming, receding, or constant tone to the participant.

Configuration Options:
* The frequency (Hz) and duration (s) of the two tones
* The type of tone (looming, receding, or constant)
* The ear that the audio is presented
* Durations of the baseline, task, and post-task periods

![Looming App](AppFiles/Looming.PNG)

### Digit Span App
Presents a string of digits to the participant. Participant recalls verbally after a delay.

Configuration Options:
* Trial load or the number of digits presented
* Durations for the baseline, delay, and recall periods
* Interval between the tone onset of each digit

![Digit Span App](AppFiles/DigitSpan.PNG)