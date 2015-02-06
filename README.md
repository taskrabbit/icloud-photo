# ICloudPhoto::Sync

So you want to send photos to your photo stream on iCloud. I looked for an API and couldn't find one.
So I made this mess. It uses AppleScript to launch iPhoto and then puppeteers it until the photos are in iPhoto.

It is being used in the [Dashing on Apple TV](https://github.com/bleonard/dashing_on_appletv) sample.

## Setup

Open iPhoto and click on "iCloud" on the side. Sign if if necesssary.

NOTE: this is meant to have total control over this iCloud account. It should be a new account for your dashboard, not your personal one. It may delete you photos.

Import a photo, select "Share...", and share it to the iCloud album(s) you want to use (just to make the album). In the sample, it is called "dashboard."

The first time you run it, you'll likely need to allow some accessibility access to iPhoto from the Applescript. Follow the given instructions.

You should see it succeed after a few times of that. When iPhoto closes itself, that means it worked.

## Usage

```ruby
require 'icloud-photo'

cloud = ICloudPhoto::Sync.new("screenshots")

# put the sampletv image in the dashboard album
cloud.add("dashboard", ["sampletv"])
cloud.upload!
```

Then don't touch the keyboard!
