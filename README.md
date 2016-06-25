# Welcome to IVR system
Adhearsion framework is integrated with asterisk.

#Asterisk

Edit `extensions.conf` to include the following:

```
[your_context_name]
exten => _.,1,AGI(agi:async)

[adhearsion-redirect]
exten => 1,1,AGI(agi:async)
```

and setup a user in `manager.conf` with read/write access to `all`.

##Configuration

In `config/adhearsion.rb` you'll need to set the VoIP platform you're using, along with the correct credentials. You'll find example config there, so follow the comments.

## Ready, set, go!

Start your new app with "ahn start". You'll get a lovely console and should be presented with the SimonGame when you call in.


More detail is available in the [deployment documentation](http://adhearsion.com/docs/best-practices/deployment).

Check out [the Adhearsion website](http://adhearsion.com) for more details of where to go from here.

### Testing

We are using rspec for testing.