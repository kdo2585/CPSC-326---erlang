-module(parse).
	-export([tokenize/1]).
        -export([inputKV/0]).
	-export([createKV/2]).
	-export([createmap/0]).
	-export([score_relevance/2]).


	%-export([start/0]).

		tokenize(String) ->
			string:tokens(String, " ").
	
		inputKV()-> 
			 tokenize( io:get_line("Enter keywords and values, separated by spaces ")).

		createKV([],Map) -> 
			Map;

	        createKV(List, Map)-> 
			Map1=  #{lists:nth(1,List) =>element(1,string:to_integer(lists:nth(1,lists:nthtail(1,List))))}, 
			Map2 = maps:merge(Map1,Map), 
			createKV(lists:nthtail(2,List), Map2) .

		createmap()->
			createKV(inputKV(),	#{}).

		score_relevance([],Map)-> 
			0;
		
		score_relevance(List,Map)-> case maps:is_key(lists:nth(1,List),Map) of 
			true -> element(2,maps:find(lists:nth(1,List),Map))+score_relevance(lists:nthtail(1,List),Map); 
			false->score_relevance(lists:nthtail(1,List),Map)
			end.
		
		


		
		
		