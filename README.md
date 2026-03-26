# ADS-B Signal Decoder using MATLAB & RTL-SDR

## Description
This is a MATLAB-based software project designed to process Automatic Dependent Surveillance-Broadcast (ADS-B) signals. It reads raw radio frequency signals captured via a Software-Defined Radio (RTL-SDR), detects the packets, and decodes them to extract vital aircraft information such as the ICAO address and Flight ID. This project was developed as part of practical radar systems and digital signal processing experiments.

## Features
* **Raw Signal Parsing:** Reads and processes complex I/Q samples from `.dat` files recorded by an RTL-SDR receiver.
* **Signal Processing:** Performs resampling and threshold-based filtering for pulse position modulation (PPM) detection.
* **Preamble Detection:** Accurately identifies the start of an ADS-B message to ensure valid data packet capture.
* **Data Decoding:** Extracts the payload and decodes the 6-bit character representations to retrieve the aircraft's Flight ID.
* **CRC Validation:** Implements Cyclic Redundancy Check (CRC) to verify data integrity and ensure the received messages are error-free.

## File Structure
* `loadFile.m`: A function to read raw bytes from the RTL-SDR recording file and convert them into complex numbers for MATLAB processing.
* `adsbDecod.m`: The core function that searches for the preamble, filters packets with Downlink Format `DF=17` and Type Code `TC=4`, validates errors using CRC, and extracts the ICAO address.
* `decode_id.m`: A helper function that decodes the Flight ID payload using the standard ADS-B character mapping table.
* `main.m` *(Main Script)*: The execution script that loads the data, resamples it, applies a detection threshold, plots the signal for visualization, and triggers the decoding functions.

## Prerequisites
* **MATLAB**: Developed and tested on recent MATLAB versions.
* **Communications Toolbox**: Required to utilize the `comm.CRCDetector` object.
* **Data**: Raw signal data files (`.dat` format) recorded via RTL-SDR at a 3.2 MHz sampling rate.

## Usage
1. Place your raw RTL-SDR data file (e.g., `adsb_3.2M_3.dat`) in the root directory of the project.
2. Open MATLAB and run the `main.m` script.
3. The script will generate plots for signal visualization and output the extracted valid messages, including the ICAO address, Flight ID, and CRC status (ok/err), directly to the Command Window.

## Author
**[ghader ali / G-ALI007]**
