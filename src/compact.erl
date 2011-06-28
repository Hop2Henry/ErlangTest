%% Author: Administrator
%% Created: Jun 27, 2011
%% Description: TODO: Add description to compact
-module(compact).

-include_lib("eunit/include/eunit.hrl").
-export([compact/2,request/1]).

-define(RS1, [ [{key, 1}, {price, 99}, {gds, s}, {flight, "US232"}], [{key, 2}, {price, 100}, {gds, s}, {flight, "AA238"}],
			   [{key, 4}, {price, 66}, {gds, w}, {flight, "UA232"}]]).
-define(RS2, [ [{key, 1}, {price, 98}, {gds, w}, {flight, "US232"}], [{key, 2}, {price, 99}, {gds, w}, {flight, "AA238"}],
			   [{key, 3}, {price, 98}, {gds, w}, {flight, "UA232"}],  [{key, 4}, {price, 98}, {gds, w}, {flight, "UA232"}]]).


compact(First,[Head|[]]) ->
	case find(Head,First) of
		skip -> [];
		Other ->[find(Head,First)]
	end;
	
compact(First,[Head|Next]) ->
	case find(Head,First) of
		skip -> compact(First,Next);
		Other ->[find(Head,First)]++ compact(First,Next)
	end.

%% get a new ticket or the one has lower price 
find(Tkt,[Element|[]]) ->
	[Key,Price,Gds,_] = Tkt,
    case lists:member(Key, Element)of
		false -> Tkt;
		true -> displace(Tkt,Element)
	end;
find(Tkt,[Element|Next])->	
	[Key,Price,Gds,_] = Tkt,
	case lists:member(Key, Element)of
		false -> find(Tkt,Next);
		true -> displace(Tkt,Element)
	end.

%% if the new price is lower, displace the old one.
displace(NewTkt,OldTkt)->
	[Key1,{price,Val1},Gds1,_] = NewTkt,
	[Key2,{price,Val2},Gds2,_] = OldTkt,

	case Val1 < Val2 of
  		true -> [Key1,{price,Val1},Gds1];
		false -> skip
	end.
	

request(Flag) ->	
	case Flag of
		sabre -> ?RS1;
		wspan -> compact(request(sabre),?RS2);
		Other -> "error:no result"
	end.
	%%io:fwrite("New list: ~p ~n", [Difference]).

test_list() ->
	F = [[a,b,c],a,b,c]++[e] ++ [].
  
%%%------------------------------------------------------------------------------------
%%% Tests
%%%------------------------------------------------------------------------------------


compact_test() ->
	 [
     ?assert(length(request(wspan)) > 0),
	 ?assertEqual([[a,b,c],a,b,c,e],test_list())
	 ].

	




