#!/usr/bin/env ruby
# encoding: utf-8

require 'mechanize'

AVV_FROM_TO="http://fahrplan.avv.de/master.php?&script=inquiry/service&apikey=avvmobil&path=%2Fhome%2FconnectionSearchForm"
AVV_FROM="http://fahrplan.avv.de/master.php?&script=inquiry/service&apikey=avvmobil&path=%2Fhome%2FdepartureSearchForm"

city = "aachen"
departure = "am hügel"

def help
  f = File.basename $0
  puts <<-EOF
usage:
  #{f} [from-city] from-stop [to-city] to-stop
  #{f} from-stop

  When no city is specified, Aachen is assumed.

Options:
  -t | --time\tJourney start time
  EOF
end

def departure_list(city, departure, start_at)
  a = Mechanize.new
  a.get(AVV_FROM) do |page|
    result_page = page.form_with(:action => 'http://fahrplan.avv.de/master.php') do |f|
      f.dep_city    = city
      f.dep_station = departure
      f.time = start_at if start_at
    end.submit

    departure = result_page.search('span.blueText b').text
    puts departure
    puts '-'*departure.size

    results = result_page.search('table.departure tr')
    results.each do |row|
      if row.text =~ /ab\nLinie/
        #puts "Uhrzeit\tLinie\tFahrtziel"
        #puts "-------------------------"
        next
      end
      res = []
      row.search('td').each do |col|
        res << col.text
      end
      puts res*"\t"
    end
  end
end

def from_to_list(departure, start_city, target, target_city=nil, start_at=nil)
  target_city = start_city if target_city.nil?

  a = Mechanize.new
  a.get(AVV_FROM_TO) do |page|
    result_page = page.form_with(:action => 'http://fahrplan.avv.de/master.php') do |f|
      f.dep_city    = start_city
      f.dep_station = departure
      f.arr_city    = target_city
      f.arr_station = target
      f.time = start_at if start_at
    end.submit

    text = result_page.search('span.blueText').text.gsub("\n", ' ')
      .strip.gsub(/  +/, ' ')
    puts text
    puts '-'*text.size

    results = result_page.search('table.verbindungsuebersicht tr')
    results.each do |row|
      if row.text =~ /Linie\(n\)/
        puts "Linie\tab\tUm.\tan"
        puts "-----------------------------"
        next
      end
      res = []
      tds = row.search('td')
      next if tds.size == 1 || tds.size == 0
      tds.each do |col|
        t = col.text.chomp.strip
        next if t =~ /Details/
        res << t
      end
      puts res*"\t"
    end
  end
end

start_at=nil
if d = ARGV.index('--time') || d = ARGV.index('-t')
  if ARGV[d+1]
    start_at = ARGV[d+1]

    ARGV.delete_at(d)
    ARGV.delete_at(d)
  else
    "Da fehlt aber was."
    exit 1
  end
end

if ARGV.empty? || ARGV.include?('-h') || ARGV.include?('--help')
  help
  exit 1
end

case ARGV.size
when 1 then
  departure_list('aachen', ARGV[0], start_at)
when 2 then
  from_to_list(ARGV[0], 'aachen', ARGV[1], 'aachen', start_at)
when 3 then
  from_to_list(ARGV[1], ARGV[0], ARGV[2], 'aachen', start_at)
when 4 then
  from_to_list(ARGV[1], ARGV[0], ARGV[3], ARGV[2], start_at)
else
  puts "Keine Ahnung, was zu tun ist."
end
