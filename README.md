# AuthSecureX
AuthSecureX is a library utilizing TEA (Tiny Encryption Algorithm) and XCBC for secure key-based authentication. It includes scripts for 128-bit secret keys, HTTP-based version checks, and cryptographic validation. Suitable for secure applications and can be adapted as a membership registration system.


## Features
- Utilizes 128-bit and 64-bit secret keys for secure data encryption.
- Implements TEA (Tiny Encryption Algorithm) for encryption and XCBC for authentication.
- HTTP-based version checks and time synchronization using APIs.
- Stores authentication data in an INI file for future reference.

## Getting Started

### Prerequisites
- **AutoHotkey**: The code is written using AutoHotkey, so make sure to have it installed on your system. You can download it from [AutoHotkey's official website](https://www.autohotkey.com/).

### Installation
1. **Clone the Repository**:

2. **Open the Script**: Once cloned, you can open the main script file (e.g., `auth_script.ahk`) using AutoHotkey to run or edit.

### Usage
- **Authentication Process**:
  1. The script fetches the current time from an online API (`worldtimeapi.org`) and version information from GitHub.
  2. The user needs to input their PC ID through the input box.
  3. The script calculates the authentication data using the secret keys and generates a unique code for the machine.
  4. The generated authentication code is stored in the INI file (`Alone.ini`).

## Code Explanation
- **Secret Keys**: The script uses three different sets of secret keys (`k0, k1, k2, k3`, `l0, l1`, `m0, m1`) to perform encryption.
- **TEA Function**: This function performs 32 rounds of data encryption using the secret keys.
- **XCBC Function**: Implements XCBC for cryptographic message authentication.
- **HTTP Requests**: The script uses `WinHttpRequest` to interact with external APIs for time and version information.

## Example
Here is an example of how the authentication process works:
1. The script will prompt you to enter your PC ID.
2. The generated authentication code will be displayed and copied to your clipboard.

## Contributing
Contributions are welcome! If you have ideas for improvements, feel free to fork the repository and submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

## Acknowledgments
- The TEA and XCBC algorithms used in this project are standard cryptographic tools used to enhance security.
- Thanks to the developers of AutoHotkey for making scripting and automation easy.

