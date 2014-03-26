REBAR:="./rebar"

.PHONY: all test clean

all:
	$(REBAR) get-deps compile

compile: all

test:
	$(REBAR) skip_deps=true eunit

clean:
	$(REBAR) clean
	rm -rf ebin
	rm -rf .eunit
