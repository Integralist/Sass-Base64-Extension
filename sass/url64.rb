require 'base64'
require 'sass'
require 'image_optim' # https://github.com/toy/image_optim

=begin
    This script has been modified from: https://github.com/eighttrackmind/SASS-Base64
    Removed redundant code and implemented fix for IE8**
    
    **IE8 has a 32k limit on data uri's so we need to ensure no image that is larger than 32k is inlined.

    __FILE__ => "./url64.rb"
    root     => "/Users/markmcdonnell/Desktop/BBC"
=end
         
module Sass::Script::Functions
    def url64(image)
        assert_type image, :String

        # compute file/path/extension
        
        # from the current directory /sass/ (which is one level down from root) I'd expect ../ to take me up to the root
        # i don't know why but to find base path we need to set it one level higher than expected?
        base_path = '../../'

        root = File.expand_path(base_path, __FILE__)
        path = image.to_s[1, image.to_s.length-2]
        fullpath = File.expand_path(path, root)
        absname = File.expand_path(fullpath)
        ext = File.extname(path)

        # optimize image
        if ext == '.gif' || ext == '.jpg' || ext == '.png'
            # homebrew link to pngcrush is outdated so need to avoid pngcrush for now
            # also homebrew doesn't support pngout so we ignore that too!
            # The following links show the compression settings...
            # https://github.com/toy/image_optim/blob/master/lib/image_optim/worker/advpng.rb
            # https://github.com/toy/image_optim/blob/master/lib/image_optim/worker/optipng.rb            
            image_optim = ImageOptim.new(:pngcrush => false, :pngout => false, :advpng => {:level => 4}, :optipng => {:level => 7}) 
            
            # we can lose the ! and the method will save the image to a temp directory, otherwise it'll overwrite the original image
            image_optim.optimize_image!(fullpath)
        end

        # base64 encode the file
        file = File.open(fullpath, 'rb') # read mode & binary mode
        filesize = File.size(file) / 1000 # seems to report the size as being 1kb smaller than it actually is (so if our limit is 32kb for IE8 then we need our limit to be 31kb)
        text = file.read
        file.close

        if filesize < 31 # we're avoiding IE8 32kb data uri size restriction
            text_b64 = Base64.encode64(text).gsub(/\r/,'').gsub(/\n/,'')
            contents = 'url(data:image/' + ext[1, ext.length-1] + ';base64,' + text_b64 + ')'
        else
            contents = 'url(' + image.to_s + ')' # if larger than 32kb then we'll just return the original image path url
        end

        Sass::Script::String.new(contents)
    end

    declare :url64, :args => [:string]
end