# priceof

A simple application that uses Yahoo Finance API
![Screenshot-07-07-2021_21-11-32](https://user-images.githubusercontent.com/44977415/124843269-233e6900-df81-11eb-9730-c419ef3787e0.png)

# Dependencies

Check the [Haskell Platform](https://www.haskell.org/platform/) for instruction to install [Cabal](https://www.haskell.org/cabal/)

# Install
```
git clone https://github.com/ltsdw/priceof.git
cd priceof
make
sudo make install
```

To run it without installing:
```
./build/priceof btc-usd
```

# Usage
```
priceof btc-usd usdjpy=x usdeur=x
```

# Uninstall

```
sudo make uninstall
```
