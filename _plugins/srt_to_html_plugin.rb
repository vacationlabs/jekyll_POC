module Jekyll
  class SRTConverter < Generator
    safe true
      
    def generate(site)
      site.posts.each do |post|
        # site.posts takes all the post, and we dont want that.
        # so this if condition will filters out only the post of support
        # only srt_ is present is support
        if (post.url.split("/")[1] == 'support')
          #to create a destination and to create html pages with post_name
          #placing all the converted srt to html in _include/converted_srt folder

          # REVIEW - this will break if the post permalink format is changed. Read
          # all possibilities at http://jekyllrb.com/docs/permalinks/
          #=> none of the post will have any other extension, cuz i have specified
          #   slug in _config.yml file
          converted_file_name=post.url.split("/").last+".html"
          # if a use File.join to the above it add a extra /
          destination=File.join(site.source,"/_includes/converted_srt")

          if (post.srt_file_name.to_s != '') # REVIEW -- See if .blank? works
                                              #=> .blank? doesnt work
            read_file_name=File.join('./subtitles/srt/',post.srt_file_name)
            ###
            File.open(File.join(destination, converted_file_name), 'w') do |write_file|
              # REVIEW -- rewrite this code to use a Liquid template. You can
              # manually instatiate a Liquid template and render it while passing
              # it a hash
              template="  <span id='line{{l_no}}' start='{{start}}' end='{{end}}' onclick=\"transcript_seek(this.getAttribute('start'))\">\n  {{l_no}}  {{content}}\n  </span></br>\n"
              
              write_file.write('<div id="transcript">')
              write_file.write("\n")
              File.open(read_file_name, "r") do |read_file|
                count=1 
                line_no=""
                start_time=""
                end_time=""
                line_data=""

                # REVIEW -- read the SRT file specification at
                # https://en.wikipedia.org/wiki/SubRip#SubRip_text_file_format
                # This parser will fail for multi-line subtitles. You should use a
                # state-machine (or probably stack) to build this parser.
                #=> modified the code to work for multi-lines subtitle
                read_file.each_line do |line|
                  case count
                    when 1
                    line_no= line.strip
                    count += 1

                    when 2
                    (start_time, end_time) = split_time(line)
                    count += 1

                    when 3
                    line_data=line.strip
                    count += 1

                    when 4
                      if(line.strip == '')
                        #write_file.write(Liquid::Template.parse(template).render({'l_no' => line_no,'start' => start_time, 'end' => end_time,'content' =>line_data}))
                        write_file.write('  <span id="line'+line_no+'" start="'+start_time+'" end="'+end_time+'" onclick="transcript_seek(this.getAttribute(\'start\'))">')
                        write_file.write("\n")
                        write_file.write('  '+line_no+'   '+line_data)
                        write_file.write("\n  </span><br>\n")
                        line_data=""
                        count=1
                      else
                        line_data=line_data+"<br> "+line
                        count=4
                      end
                      
                  end # end of case
                end # end of read each line loop
              end # end of reading from the file loop
              write_file.write('</div>')
            end # end of writing in the file loop
            ###
          end
        end # end of if(post.url.split("/")[1] == 'support')
      end # end of site.posts.each
    end # end of generate function

    private
    #this function will take the full line 
    # and returns the start and end time
    def split_time(line)
      str_part=line.split(" --> ").first
      end_part=line.split(" --> ").last

      str_seconds=get_time_in_seconds(str_part)
      end_seconds=get_time_in_seconds(end_part)
    return str_seconds.to_s,end_seconds.to_s
    end

    # this function will take the time_part and return time in seconds
    def get_time_in_seconds(time_part)
      time=time_part.split(",").first
      ss=time.split(":").last
      if dt = DateTime.parse(time) rescue false
        seconds = dt.hour*3600+dt.min*60+ss.to_i
      end
    return seconds.to_s
    end

  end
end