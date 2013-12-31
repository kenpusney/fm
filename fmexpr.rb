^IClass >
	+^dump(dvr:Driver):string
	+^parse()

FMClass <AClass.IClass >
	@prop:X/r
	+dump(dvr:Driver):string
	+parse()
	+inherit/is_a(cls:self)
	+composed_by/has_a(cls:self,name:symbol)

	=create(str:string/c):A;

FMDriver >
	@info:Hash/w
	+^dump():string


##
# =============================
#
#     FM as a language
#
# =============================
##



