<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/kulbhushanchand/BioNES">
    <img src="docs/assets/images/logo.svg" alt="Logo" width="120" height="120">
  </a>
  <h2 align="center">Biofeedback Nintendo Entertainment System (BioNES)</h2>
  <p align="center">
    A plug-and-play MATLAB based tool to use NES games for multimodal biofeedback      
  <br />
    <a href="https://kulbhushanchand.github.io/BioNES/"><strong>Explore the docs »</strong></a>
    <br />
  </p>
</p>

---
<br />

## Table of Contents

- [About the Project](#about-the-project)
  - [Built with](#built-with)
  - [Features](#features)
  - [Why this tool?](#why-this-tool)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation and Running](#installation-and-running)
- [Usage](#usage)
  - [Examples](#examples)
- [Documentation](#documentation)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgment](#acknowledgment)
- [Citation](#citation)

## About the project
![screenshot](docs/assets/images/BioNes.jpg)

BioNES (Biofeedback Nintendo Entertainment System) is an open-source plug-and-play MATLAB-based tool to use NES games for multimodal biofeedback. It can be used to deliver the HRV biofeedback via any game designed for the NES system. It can receive real-time heartbeat interval (RR) values from Arduino + ear-clip PPG sensor (or any sensor capable to send real-time heart rate pulses to Arduino). After the acquisition, it computes real-time heart rate and heart rate variability (HRV), biofeedback parameters and then sends feedback to the FCEUX emulator which is used to play the NES game.
Besides in-game biofeedback, it also offers real-time data visualization in time-series plots and local saving of data for offline analysis. This tool can benefit the researchers (especially from biofeedback or physiological measurement domain) or hobbyist, who want to quickly deploy a biofeedback system, want to explore the NES games for biofeedback, or just want to record the physiological signals.

### Built with

- GUI is built using the `Guide` tool in [MATLAB-v2017b](https://in.mathworks.com/products/matlab.html). 
- [Arduino](https://www.arduino.cc/) Mega board for hardware.
- [Grove ear-clip sensor](https://wiki.seeedstudio.com/Grove-Ear-clip_Heart_Rate_Sensor/) for photoplethysmograph (PPG) data acquisition.
- [FCEUX](https://github.com/TASVideos/fceux) emulator to play NES game.
- [Super Mario Bros.](https://www.mariowiki.com/Super_Mario_Bros.) game for feedback.

### Features

- Plug and play biofeedback system for SMB game (using other NES games may need minor changes).
- Data acquisition sampling rate of 10 Hz to acquire RR intervals from Arduino. 
- Feedback is displayed at a fixed refresh rate at 60 Hz.
- Real-time data visualization (in time-series plot).
- Local saving of data in `.mat` format for offline analysis.
- Screenshot of current GUI for reference purpose.
- 3 independent modes of working.
  - Data acquisition only
  - Gameplay without biofeedback
  - Gameplay with biofeedback

### Why this tool?

Biofeedback therapy has potential benefits for managing stress. However, traditional biofeedback is an expensive and monotonous process. To increase the engagement in biofeedback sessions, video games can be used. But the problem is the limited availability of affordable video-game-based biofeedback solutions.
BioNES is developed keeping in mind the cost-effectiveness and ease of use to deliver biofeedback while simultaneously providing reliability as a research tool and flexibility to allow researchers/developers to modify as per their needs. The efficacy of BioNES is validated using observational study and the paper is currently under review in a reputed journal.


<!-- GETTING STARTED -->
## Getting started

### Prerequisites

- [MATLAB](https://in.mathworks.com/products/matlab.html)  

>`MATLAB-ver2017b` was used to develop the BioNES. It was also tested with `ver2015b` and `ver2018b` for backward and forward compatibility respectively.  

- [Arduino](https://www.arduino.cc/) hardware board.   
- [Grove ear-clip sensor](https://wiki.seeedstudio.com/Grove-Ear-clip_Heart_Rate_Sensor/).
- [FCEUX](https://github.com/TASVideos/fceux).
- NES game ROM file. This version of BioNES uses the Super Mario Bros. game without any modification, for other NES games you have to make minor changes to the `BioNES.lua` file.  

### Installation and running

1. Download the [latest stable release](https://github.com/kulbhushanchand/BioNES/releases) and extract contents into your MATLAB working directory. Alternatively, you can also download the latest code from the [repository](https://github.com/kulbhushanchand/BioNES).
2. Open `BioNES.m` in MATLAB.
3. Connect Arduino board to PC with USB cable. Upload `BioNES.ino` sketch to Arduino board.
4. Connect the ear-clip sensor to the Arduino board.
4. Run `BioNES.m` and wait for the GUI to appear.
5. In the GUI select the `COM` port for the Arduino and press the `Connect` button. 
6. After a successful connection, appropriate settings can be selected.
7. Select the biofeedback checkbook (if biofeedback gameplay is needed) and press the `Connect` button in the `Game` panel. The `FCEUX` window will open with the pre-configured settings. 
8. Start the acquisition from the `Start/Stop` button in the `Control` panel.
9. The acquisition runs till a set time or can be stopped manually.
10. After successful completion, the information panel shows various statistics related to the acquisition.
11. Finally, the data can be saved for offline processing.


<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples, and demos work well in this space. You may also link to more resources.  
*For more examples, please refer to the [Documentation](https://kulbhushanchand.github.io/BioNES/)*.


### Examples

To be added.


<!-- DOCUMENTATION -->
## Documentation

The documentation is available at https://kulbhushanchand.github.io/BioNES/


<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/kulbhushanchand/BioNES/issues) for a list of proposed features (and known issues).


<!-- CONTRIBUTING -->
## Contributing

Any contributions you make are greatly appreciated. You can contribute to this project in the following ways :

- Add new functionality
- Review code
- Raise issues about bugs/features/doubts
- Proof-read the documentation
- Cite if used in a publication
- Star on GitHub
- Share with others

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/kulbhushanchand/BioNES/blob/master/CODE_OF_CONDUCT.md). By contributing to this project you agree to abide by its terms.


<!-- LICENSE -->
## License

This project is distributed under the `GPLv3` License. See [LICENSE](https://github.com/kulbhushanchand/BioNES/blob/master/LICENSE) for more information.


## Citation

To be filled

```
citation
```


<!-- ACKNOWLEDGMENTS -->
## Acknowledgment

I would like to thank my PhD supervisor [Prof. Arun Khosla](https://www.nitj.ac.in/index.php/nitj_cinfo/Faculty/38) at Dr B R Ambedkar National Institute of Technology for his guidance and kind support. I also want to acknowledge the open-source tools used in some parts of this project.

- [FCEUX](https://github.com/TASVideos/fceux) is used as an NES emulator.
- [drawio-desktop](https://github.com/jgraph/drawio-desktop) is used to create the logo and diagrams.


<!-- CONTACT -->
## Contact

[Kulbhushan Chand](https://kulbhushanchand.github.io/about/)