# Generate a PEM key

```bash
ssh-keygen -m PEM
```

Then copy the <key-name>.pub content in *key_pair.tf* in *public_key* section

**IMPORTANT:** Give to <key-name> private key propper permissions

```bash
chmod 600 <priv-key-name>
```
