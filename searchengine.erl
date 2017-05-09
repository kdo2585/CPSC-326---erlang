-module(searchengine).
	-export([tokenize/1]).
        -export([inputKV/0]).
	-export([createKV/2]).
	-export([createmap/0]).
	-export([comment_relevance/2]).
	-export([comment_length/1]).
	-export([add_comment_data/3]).
	-export([start/0]).
	-export([sort/1]).
	-export([store_comments/2]).
	-export([read/1]).
		% sort example:
		% val -> score = 1, comments = 2, user_rate = 3
		% (val, [{upvotes/score,  comment,  user rate}])
		% lists:keysort(3,[{1500,what,5},{1000,climate,2},{2000,gas,3},{100,trump,1}]).
		%{string, relevance, score, length}


		sort(Rank)-> 
			lists:keysort(3,[Rank]).
			
		tokenize(String) ->
			string:tokens(String, " ").
	
		inputKV()-> 
			 tokenize( io:get_line("Enter keywords and values(1-6), separated by spaces: ")).

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
		
		add_comment_data(Id,R,L)-> [{Id,R,L}].
		
		read(File) ->
				{ok,Binary} = file:read_file(File),
				Lines = string:tokens(erlang:binary_to_list(Binary),"\n").

		store_comments([],Map)->
				[];
		
		store_comments(ComLists, Map)->
			Id = lists:nth(1,ComLists), 
			R=comment_relevance(Id, Map), 
			L=comment_length(Id),
			lists:append(add_comment_data(Id,R,L), store_comments(lists:nthtail(1,ComLists),Map)).

		start()->
			R = read(test),
			M=createmap(),
			S = store_comments(R, M),
			G = io:get_line("How do you want to sort? (L = length, R= relevant)"),
			if
				G == "L\n" ->
					X = 2;
				true ->
					X = 3
			end,

			lists:keysort(X,S),

			%S="oranges apples sock tickle the flying oranges",
			%Q=string:tokens(string:to_lower(S)," "),

			
			%spawn(parse, comment_relevance, [U,M]),
			%spawn(parse, comment_relevance,[T,M]),
			%comment_relevance(Q,M).
		