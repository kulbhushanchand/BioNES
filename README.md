<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/kulbhushanchand/BioNES">
    <img src="docs/assets/images/logo.svg" alt="Logo" width="120" height="120">
  </a>
  <h2 align="center">Biofeedback Nintendo Entertainment System (BioNES)</h2>
  <p align="center">
    A tool to deliver multimodal biofeedback with NES games   
  </p>
</p>

---
<br />

## Table of Contents

- [About The Project](#about-the-project)
  - [Built with](#built-with)
  - [Why another acquisition program?](#why-another-acquisition-program)
  - [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation and Running](#installation-and-running)
- [Usage](#usage)
  - [Examples](#examples)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgment](#acknowledgment)

## About The Project

![screenshot](docs/assets/images/screenshot1.jpg)

AfDaq (Arduino Firmata Data Acquisition) is an open-source plug and play MATLAB based tool for biofeedback and arduino based instruments, which offers the capabilities of multi-channel real-time data acquisition, visualization, manipulation, and local saving of data for offline analysis.  
The researchers (especially from biofeedback or physiological measurement domain) or hobbyist, who are using MATLAB and want to acquire data from Arduino or to control Arduino based instruments can use this tool. The software tool, data, and analysis that support the findings of this study are released as open-source to support the replicability and reproducibility of research.

### Built With

This GUI tool is built using `Guide` tool in [MATLAB-v2017b](https://in.mathworks.com/products/matlab.html). For the hardware any [Arduino](https://www.arduino.cc/) compatible board can be used which is supported by MATLAB.

### Why another acquisition program?

Researchers in the biofeedback domain or working on Arduino based instruments often require a quick-to-deploy system to acquire real-time data from Arduino and for further analysis transfer the data in MATLAB. For this the MATLAB has provided [MATLAB Support Package for Arduino Hardware](https://in.mathworks.com/help/supportpkg/arduinoio/) which ease the data acquisition need from Arduino compatible hardware by automatically updating firmata code on arduino board and providing functions for data acquisition. However, the currently its use in physiological research is limited due to severe timing jitter associated during data acquisition. 

This software tool aims to reduce the timing jitter and provides precise time stamps during data acquisition.

### Features

- Plug and play system (no need to separately upload any code on arduino board).
- Real-time multi-channel data acquisition from supported digital or analog channels.
- Sampling rate of - 
  - 10 Hz when using all 5 channels simultaneously
  - 40 Hz when using single channel acquisition.
- Real-time data visualization (in scroll plot) and data manipulation (with custom functions).
- Local saving of data in `.xlsx` format for offline analysis.
- Screenshot of current GUI for reference purpose.


<!-- GETTING STARTED -->
## Getting Started

The working with AfDaq is straightforward process. Make sure you have prerequisites available and follow the steps below.

### Prerequisites

- [MATLAB]() 
>`MATLAB-ver2017b` was used to develop the AfDaq. It was also tested with `ver2015b` and `ver2018b` for backward and forward compatibility respectively. It may not work with `ver20xx and before` due to the unavailability of compatible `MATLAB Support Package for Arduino Hardware`. 
- [MATLAB Support Package for Arduino Hardware]()
- [Arduino](https://www.arduino.cc/) compatible hardware board. 
>For the list of supported board, visit documentation [here]().

### Installation and Running

1. Download the [latest stable release]() and extract contents into your MATLAB working directory. Alternatively, you can also download the latest code from the [repository]().
2. Open `AfDaq.m` in MATLAB.
3. Connect Arduino board to PC with USB cable. If board is pre-configured with Firmata code by MATLAB, a message is shown in the command window.
4. Run `AfDaq.m` and wait for the GUI to appear.
5. In the GUI select the `COM` port for the arduino and press `Connect` button. If the Arduino is not pre-configured with Firmata code by MATLAB, it may take few minutes (It's a one time process OR if the board is re-flashed outside).
6. After successful connection, appropriate settings can be selected and acquisition is manually started.
7. The acquisition runs till set time or can be stopped manually.
8. After successful completion, information panel show various statistics related to acquisition.
9. Data can be saved for offline processing.


<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

### Examples





<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/kulbhushanchand/AfDaq/issues) for a list of proposed features (and known issues).


<!-- CONTRIBUTING -->
## Contributing

Any contributions you make are greatly appreciated. You can **report a bug**, **request a feature** or **ask any question** by creating an issue on this repository. In case you would like to add your changes to this repository, you can follow the easy steps below -

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the GPLv3 License. See [LICENSE](https://github.com/kulbhushanchand/AfDaq/blob/master/LICENSE) for more information.


<!-- CONTACT -->
## Contact

[Kulbhushan Chand](https://kulbhushanchand.github.io/about/)


<!-- ACKNOWLEDGMENTS -->
## Acknowledgment

- [drawio-desktop](https://github.com/jgraph/drawio-desktop)


## How to cite?

The project is an open data, open code, and replicable research.  
- The code is available at [GitHub repository](https://github.com/kulbhushanchand/AfDaq).  
- The code, data, and analysis-scripts that support the findings of the study are available at [OSF Repository](https://doi.org/10.17605/OSF.IO/VCTJM).

The paper explaining the design and development, and usage of this work in multimodal biofeedback is published in xxxx. You can cite this work (by citing the paper published for this work) as below -

