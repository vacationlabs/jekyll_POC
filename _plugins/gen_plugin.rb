module Reading
  class Generator < Jekyll::Generator

    def generate(site)
      site.posts.each do |post|
        post1 = post.to_s
        #puts post1.class
        post2 = post1.split("\n")
        if post2[0][0] == "/"
        e  element_arr=[]
          File.open(post2[0], "r") do |f|
            count=1
            data=[]
            f.each_line do |line|
              case count
                when 1
                  data=[]
                  line_no= line.strip
                  count += 1
                  data.push(line_no)

                when 2
                  part1=line.split(" --> ").first
                  part2=line.split(" --> ")
                  part2 = part2[1]
                  start_time=part1.split(",").first
                  end_time=part2.split(",").first
                  #hh=time.split(":").first
                  #start_mm=start_time.split(":").second
                  start_ss=start_time.split(":")
                  start_ss=start_ss[2]
                  #end_mm=end_time.split(":").second
                  end_ss=end_time.split(":")
                  end_ss=end_ss[2]

                  if dt = DateTime.parse(start_time) rescue false
                    start_seconds = dt.hour*3600+dt.min*60+start_ss.to_i
                  end
                  if dt = DateTime.parse(end_time) rescue false
                    end_seconds = dt.hour*3600+dt.min*60+end_ss.to_i
                  end
                  count += 1
                  data.push(start_seconds)
                  data.push(end_seconds)
                  #puts data

                when 3
                  line_data= line.strip
                  count += 1
                  data.push(line_data)

                else
                  element_arr.push(data)  #
                  count=1
              end

            end
          end
          puts element_arr
          #post2[0].
          File.write("/home/wolfgang/g/jekyll/subtitles/Array Subs/Basic_Details.srt",element_arr)
        end
        #puts post[0]
      end
    end

  end


end
