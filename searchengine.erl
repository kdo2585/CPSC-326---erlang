-module(searchengine).
	-export([tokenize/1]).
        -export([inputKV/0]).
	-export([createKV/2]).
	-export([createmap/0]).
	-export([comment_relevance/2]).
	-export([comment_length/1]).
	-export([add_comment_data/4]).
	-export([get_all_lines/1]).
	-export([readlines/1]).
	-export([start/0]).

		tokenize(String) ->
			string:tokens(String, " ").
	
		inputKV()-> 
			 tokenize( io:get_line("Enter keywords and values(1-6), separated by spaces ")).

		createKV([],Map) -> 
			Map;

	        createKV(List, Map)-> 
			Map1=  #{lists:nth(1,List) =>element(1,string:to_integer(lists:nth(1,lists:nthtail(1,List))))}, 
			Map2 = maps:merge(Map1,Map), 
			createKV(lists:nthtail(2,List), Map2) .

		createmap()->
			createKV(inputKV(),	#{}).
		
		
		
		comment_relevance([],Map)-> 0;
		
		comment_relevance(String,Map)-> 
								List=tokenize(String),
								case maps:is_key(lists:nth(1,List),Map) of 
									true -> element(2,maps:find(lists:nth(1,List),Map)) + comment_relevance(lists:nthtail(1,List),Map); 
									false->comment_relevance(lists:nthtail(1,List),Map)
								end.
		
		comment_length(String)-> length(tokenize(String)).
		
		add_comment_data(Id,R,L,S)-> {Id,R,L,S}.

		readlines(parse_test_file.txt)->
				{ok,Device} = file:open(parse_test_file.txt,[read]),
				try get_all_lines(Device)
					after file:close(Device)
				end.
		
		get_all_lines(Device)->
				case io:get_line(Device,"") of
					eof->[];
					Line->Line++get_all_lines(Device)
				end.

		start()->
			
			S="oranges apples sock tickle the flying oranges",
			Q=string:tokens(string:to_lower(S)," "),
			M=createmap(),
			
			%spawn(parse, comment_relevance, [U,M]),
			%spawn(parse, comment_relevance,[T,M]),
			comment_relevance(Q,M).
		
		

		
		
		