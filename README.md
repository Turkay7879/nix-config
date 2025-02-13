# Nix-Darwin Configuration
## Running Steps
 1. Install Xcode command line tools via:
```bash
xcode-select --install
```
 2. Install Nix package manager via:
```bash
sh <(curl -L https://nixos.org/nix/install)
```
 3. Clone this repo to home folder (After cloning, switch to x86_64 branch in case of Intel/AMD).
 4. Open Settings app. Follow **Privacy & Security** > **App Management** > Add "Terminal" app here to give required permission.
   >  Do not forget to quit and reopen Terminal app here, in order for new permissions to take effect.
 5. Finally, run following command to start installing apps:
```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix-config#mbp
```
