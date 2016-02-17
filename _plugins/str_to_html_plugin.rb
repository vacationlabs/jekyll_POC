# REVIEW - Fix the filename of this plugin. Why is the class called
# VersionReporter? Shouldn't it be called SRTConverter or something

# REVIEW - fix your editor settings to indent using TWO SPACES (not tabs) and
# re-indent this file. Use this setting for ALL Ruby code in the future.

module Jekyll
  class VersionReporter < Generator
	safe true
		
	def generate(site)
		site.posts.each do |post|
			#to create a destination and to create html pages with post_name
			#placing all the converted srt to html in _include/converted_srt folder


			# REVIEW - this will break if the post permalink format is changed. Read
			# all possibilities at http://jekyllrb.com/docs/permalinks/
			converted_file_name=post.url.split("/").last+".html";
			destination=site.source+"/_includes/converted_srt";


			# REVIEW -- is it the srl **url** or srt **filename** ?
			if (post.srt_url.to_s != '') # REVIEW -- See if .blank? works
				# REVIEW - why the trailing semi-colon. Ruby doesn't need it. Also,
				# use File.join, else all this path manipulation using strings might
				# fail in Windows.
				read_file_name='./subtitles/srt/'+post.srt_url; 
			###
				File.open(File.join(destination, converted_file_name), 'w') do |write_file|
					# REVIEW -- rewrite this code to use a Liquid template. You can
					# manually instatiate a Liquid template and render it while passing
					# it a hash
					write_file.write('<div id="transcript">');
					write_file.write("\n");
					File.open(read_file_name, "r") do |read_file|
					count=1 
						line_no="";
						start_time="";
						end_time="";
						line_data="";


						# REVIEW -- read the SRT file specification at
						# https://en.wikipedia.org/wiki/SubRip#SubRip_text_file_format
						# This parser will fail for multi-line subtitles. You should use a
						# state-machine (or probably stack) to build this parser.
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
	# REVIEW -- badly constructed function. Why doesn't it take the `line`,
	# split it into start & end time and return BOTH? It can be called thus:
	# 
	# (start_time, end_time) = split_time(line)
	#
	# Btw, delimiter is not being used in your function
	

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