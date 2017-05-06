-module(parse).
	-export([tokenize/1]).
        -export([inputKV/0]).
	-export([createKV/2]).
	-export([createmap/0]).
	-export([comment_relevance/2]).


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

		comment_relevance([],Map)-> 
			0;
		
		comment_relevance(List,Map)-> case maps:is_key(lists:nth(1,List),Map) of 
			true -> element(2,maps:find(lists:nth(1,List),Map)) + comment_relevance(lists:nthtail(1,List),Map); 
			false->comment_relevance(lists:nthtail(1,List),Map)
			end.
		
		start()->
			S="oranges apples sock tickle the flying oranges",
			U=string:tokens(string:to_lower(S)," "),
			M=createmap(),
			comment_relevance(U,M).
		
		

		
		
		