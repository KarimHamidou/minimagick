# MiniMagick

A ruby wrapper for ImageMagick or GraphicsMagick command line.

Tested on the following Rubies: MRI 1.8.7, 1.9.2, 1.9.3, REE, JRuby, Rubinius.

[![Build Status](https://secure.travis-ci.org/minimagic/minimagick.png)](http://travis-ci.org/minimagic/minimagick)

## Installation

Add the gem to your Gemfile:

```ruby
gem "mini_magick"
```

## Why?

I was using RMagick and loving it, but it was eating up huge amounts
of memory. A simple script like this...

```ruby
Magick::read("image.jpg") do |f|
  f.write("manipulated.jpg")
end
```

...would use over 100MB of Ram. On my local machine this wasn't a
problem, but on my hosting server the ruby apps would crash because of
their 100MB memory limit.


## Solution!

Using MiniMagick the ruby processes memory remains small (it spawns
ImageMagick's command line program mogrify which takes up some memory
as well, but is much smaller compared to RMagick)

MiniMagick gives you access to all the commandline options ImageMagick
has (Found here http://www.imagemagick.org/script/mogrify.php)


## Examples

Want to make a thumbnail from a file...

```ruby
image = MiniMagick::Image.open("input.jpg")
image.resize "100x100"
image.write  "output.jpg"
```

Want to make a thumbnail from a blob...

```ruby
image = MiniMagick::Image.read(blob)
image.resize "100x100"
image.write  "output.jpg"
```

Got an incoming IOStream?

```ruby
image = MiniMagick::Image.read(stream)
```

Want to make a thumbnail of a remote image?

```ruby
image = MiniMagick::Image.open("http://www.google.com/images/logos/logo.png")
image.resize "5x5"
image.format "gif"
image.write "localcopy.gif"
```

Need to combine several options?

```ruby
image = MiniMagick::Image.open("input.jpg")
image.combine_options do |c|
  c.sample "50%"
  c.rotate "-90>"
end
image.write "output.jpg"
```

Want to composite two images? Super easy! (Aka, put a watermark on!)

```ruby
image = Image.open("original.png")
result = image.composite(Image.open("watermark.png", "jpg")) do |c|
  c.gravity "center"
end
result.write "my_output_file.jpg"
```

Want to manipulate an image at its source (You won't have to write it
out because the transformations are done on that file)

```ruby
image = MiniMagick::Image.new("input.jpg")
image.resize "100x100"
```

Want to get some meta-information out?

```ruby
image = MiniMagick::Image.open("input.jpg")
image[:width]               # will get the width (you can also use :height and :format)
image["EXIF:BitsPerSample"] # It also can get all the EXIF tags
image["%m:%f %wx%h"]        # Or you can use one of the many options of the format command
```

For more on the format command see
http://www.imagemagick.org/script/command-line-options.php#format

## Windows Users

When passing in a blob or IOStream, Windows users need to make sure they read the file in as binary.

```ruby
# This way works on Windows
buffer = StringIO.new(File.open(IMAGE_PATH,"rb") { |f| f.read })
MiniMagick::Image.read(buffer)

# You may run into problems doing it this way
buffer = StringIO.new(File.read(IMAGE_PATH))
```

## Using GraphicsMagick

Simply set

```ruby
MiniMagick.processor = :gm
```

And you are sorted.

# Requirements

You must have ImageMagick or GraphicsMagick installed.
