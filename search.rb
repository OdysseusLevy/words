#!/usr/bin/ruby
require 'optparse'

$expression = "(.*)"

opt_parser = OptionParser.new do |opts|

	opts.banner = "Looks up all possible scrabble words"
    opts.separator "Usage: search.rb [options] letters"

    opts.on('-s', '--startswith expression', 'Starts with expression') do |expression|
    	$expression = "^" + expression + $expression
    end
    opts.on('-e', '--endswith expression', 'Ends with expression') do |expression|
    	$expression = $expression + expression + "$"
    end
    opts.on('-c', '--contains expression', 'Contains expression') do |expression|

    	if ($expression.start_with?('^'))
    		$expression = $expression + expression +  "(.*)"
    	elsif ($expression.end_with?('$'))
    		$expression = "(.*)" + expression + $expression
    	else
    		$expression = expression
    	end
    end
	opts.on('-r', '--regex expression', 'Ruby Regular expression') do |expression|
		$expression = "(.*)" + expression + "(.*)"
	end	
end

opt_parser.parse!

$letters = ARGV[0].dup

if (not $letters)
	puts "Please specify letters to use"
	puts opt_parser
	fail 
end

$letters.strip!
$letters.downcase!

if ($expression == "(.*)")
	$expression = nil
end

puts "expression: #{$expression}"

$letterMap = Hash.new(0)

$letters.chars.each do |ch|
	$letterMap[ch] = $letterMap[ch] + 1
end

puts $letterMap

def isMatch(word)

	if ($expression )
		if (not (/#{$expression}/ =~ word))
			return false
		end
	end

	wordMap = Hash.new(0)
	word.chars.each do |ch|

		wordMap[ch] = wordMap[ch] + 1
		#puts "char #{ch} wordMap[#{ch}]: #{wordMap[ch]}; #{$letterMap[ch]}"
		if (wordMap[ch] > $letterMap[ch])			
			return false
		end
	end

	return true
end

File.foreach( 'dict.txt' ) do |word|
  word.strip!
  if (isMatch(word))
  	puts word
  end
end