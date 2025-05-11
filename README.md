<p align="center">
  <img src="https://raw.githubusercontent.com/username/catfish/main/assets/catfish_logo.png" alt="CatFish Logo" width="200"/>
</p>

<h1 align="center">🐱 CatFish 🎣</h1>

<p align="center">
  <em>A cat-themed URL masking tool for cybersecurity education</em>
</p>

<p align="center">
  <a href="https://github.com/username/catfish/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/Version-1.1-green.svg" alt="Version"></a>
  <a href="#"><img src="https://img.shields.io/badge/Bash-5.0+-orange.svg" alt="Bash"></a>
  <a href="#"><img src="https://img.shields.io/badge/Platform-Linux%20%7C%20MacOS-lightgrey.svg" alt="Platform"></a>
  <a href="#"><img src="https://img.shields.io/badge/Educational-Purposes%20Only-red.svg" alt="Educational"></a>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#disclaimer">Disclaimer</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#license">License</a>
</p>

## 🧶 Overview

**CatFish** is a purr-fect tool designed for educational purposes in cybersecurity training. It demonstrates how URL masking techniques work, helping security professionals understand potential phishing vectors and develop better protection strategies.

The tool allows creating masked URLs that appear legitimate at first glance but actually redirect to a different destination. This is a common technique used in phishing attacks, and understanding it is crucial for cybersecurity students and professionals.

## ✨ Features

<img align="right" width="250" src="https://raw.githubusercontent.com/username/catfish/main/assets/catfish_paw.png"/>

- 🔗 **URL Masking**: Create deceptive URLs that look legitimate
- 🌐 **Multiple URL Shorteners**: Support for is.gd, TinyURL, and Bitly
- 🖼️ **QR Code Generation**: Create QR codes for masked URLs
- 🧩 **Pre-defined Templates**: Common phishing scenarios ready to use
- 🔍 **URL Reputation Checking**: Verify URL safety with Google Safe Browsing API
- 📊 **Usage Statistics**: Track your URL creation history
- 📋 **Clipboard Support**: Easy copying of generated URLs
- 📱 **URL Preview**: See how links appear in different contexts
- 🔄 **Auto-updates**: Keep your CatFish fresh with automatic updates

# 🚀 Installation
### Clone the repository
```bash
git clone [https://github.com/username/catfish.git](https://github.com/username/catfish.git)
```
### Navigate to the directory
```bash
cd catfish
```
### Make the script executable
```bash
chmod +x catfish.sh
```
### Run CatFish
```bash
./catfish.sh
```


### Dependencies

CatFish automatically checks for and prompts to install required dependencies:

- `curl`: For URL shortening and web requests
- `qrencode`: For QR code generation (optional)
- `xclip`/`xsel`: For clipboard functionality (optional)

## 🎮 Usage

### Basic Usage

```bash
./catfish.sh
```

Follow the interactive prompts to create your masked URL.

### Command Line Arguments

```bash
./catfish.sh -u http://example.com -m https://facebook.com -w cute-kittens -q -s
```

Options:
- `-h, --help`: Show help message
- `-u, --url URL`: Specify the phishing URL
- `-m, --mask URL`: Specify the mask domain
- `-w, --words WORDS`: Specify the bait words
- `-q, --qr`: Generate QR code
- `-s, --save`: Save URL to history


## 📸 Screenshots
## ⚠️ Disclaimer
**CatFish** is designed for **EDUCATIONAL PURPOSES ONLY**.
This tool is meant to demonstrate how URL masking works to help cybersecurity students, professionals, and organizations understand and defend against phishing techniques. The author and contributors are not responsible for any misuse or damage caused by this program.
**Always use responsibly and only with proper authorization.**
Unauthorized use of URL masking techniques for phishing attacks or any malicious purpose is illegal and unethical.
## 🌟 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📜 License
Distributed under the MIT License. See `LICENSE` for more information.
## 🐾 Acknowledgements
- All the cybersecurity educators who inspire ethical hacking education
- The feline community for their natural phishing abilities
- The open-source community for their continuous support and contributions


Made with 😺 by a cybersecurity student
