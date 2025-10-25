# My Linux Toolset

This is my own personal Linux toolset, made easily installable via Earthly.

# Usage
1. Install [Earthly](https://earthly.dev/get-earthly/).
  ```bash
  sudo /bin/sh -c 'wget https://github.com/earthly/earthly/releases/latest/download/earthly-linux-amd64 -O /usr/local/bin/earthly && chmod +x /usr/local/bin/earthly && /usr/local/bin/earthly bootstrap --with-autocomplete'
  ```
2. Clone this repository:
   ```bash
   git clone git@github.com:navarrotech/my-linux.git
    cd my-linux
    ```
3. Build the image with Earthly (test run):
  ```bash
  earthly +base
  ```
4. Install for real by commenting out all "FROM" images and uncommenting the "LOCALLY" line in the Earthfile, then run:
  ```bash
  sudo earthly +base
  ```

## Notes
- Ubuntu and RHEL install stuff is untested currently
