module Jekyll
  class VersionReporter < Generator
	safe true
		
	def generate(site)
		site.posts.each do |post|
			#to create a destination and to create html pages with post_name
			#placing all the converted srt to html in _include/converted_srt folder
			converted_file_name=post.url.split("/").last+".html";
			destination=site.source+"/_includes/converted_srt";

			
			if (post.srt_url.to_s != '')
				read_file_name='./subtitles/srt/'+post.srt_url;
			###
				File.open(File.join(destination, converted_file_name), 'w') do |write_file|
					write_file.write('<div id="transcript">');
					write_file.write("\n");
					File.open(read_file_name, "r") do |read_file|
					count=1 
						line_no="";
						start_time="";
						end_time="";
						line_data="";

						read_file.each_line do |line|
							case count
							  when 1
								line_no= line.strip
								count += 1

							  when 2
								start_time=split_time(line,"start"," --> ")
								end_time=split_time(line,"end"," --> ")
								count += 1

							  when 3
								line_data= line.strip
								count += 1

							  else
								write_file.write('  <span id="line'+line_no+'" start="'+start_time+'" end="'+end_time+'" onclick="transcript_seek(this.getAttribute(\'start\'))">');
									write_file.write("\n");
									write_file.write('  '+line_no+'   '+line_data);
									write_file.write("\n  </span><br>\n");
								count=1
							end
						end
					end
					write_file.write("</div>")
				end
			###
			end
		end
	end

	private
	#this function takes parameters[time_part(first/last),spliting delimiter]
	# it returns the time in seconds
	def split_time(line,time_part,delimiter)
	if time_part == "start"
	  part=line.split(" --> ").first
	else 
	  part=line.split(" --> ").last
	end
	time=part.split(",").first
	ss=time.split(":").last
	if dt = DateTime.parse(time) rescue false
	  seconds = dt.hour*3600+dt.min*60+ss.to_i
	end
	seconds.to_s
	end

  end
end