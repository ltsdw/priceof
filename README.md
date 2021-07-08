# priceof

A simple application that uses Yahoo Finance API
![Screenshot-07-07-2021_23-18-07](https://user-images.githubusercontent.com/44977415/124851793-bc29b000-df92-11eb-8471-f7a4445f4864.png)

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
