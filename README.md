# Video Annotation
Quickly annotate videos with bounding boxes for use in training object detectors and trackers. Keyboard commands for ease of navigation.

## Paths
- Make sure ```video-annotation``` is your root folder in MATLAB, and add all subfolders to path.
- Videos go in ```data/videos```
- Bounding boxes will be saved in ```data/positive_examples```

## Setup
Use ```convert_to_MAT.m``` to convert your video file to a matfile. Make sure to configure the correct paths

## Annotation
The main file is ```KeyboardAnnotationSimple.m```, which contains usage instructions.

### Navigation Commands
- ```g```: move forward a frame in the video 
- ```f```: move backward a frame in the video
- ```q```: quit
- ```t```: Track: If the current frame has a bounding box, This command will track the bounding box for the next k frames. If there is no bounding box in the current frame, then this command erases all the subsequent frames contiguous to the current one. You can change k by typing:
    - ```1```: changes k to 10 
    - ```2```: changes k to 20
    - ```3```: changes k to 30
    - ```4```: changes k to 40
    - ```5```: changes k to 50
    - ```6```: changes k to 60
    - ```7```: changes k to 70
    - ```8```: changes k to 80
    - ```9```: changes k to 90
- ```a```: Annotate: Clicking onto the image counts as erasing the bounding box.
