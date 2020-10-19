IN=c64gs-keyboard-case.scad
OPENSCAD=openscad -o $@ ${IN}

all: stls/c64gs-kb-case-bottom-centerport.stl stls/c64gs-kb-case-bottom-leftport.stl stls/c64gs-kb-case-bottom-maxport.stl stls/c64gs-kb-case-top-centerport.stl stls/c64gs-kb-case-top-leftport.stl stls/c64gs-kb-case-top-maxport.stl

stls:
	mkdir -p stls

stls/c64gs-kb-case-bottom-leftport.stl: stls ${IN}
	${OPENSCAD} -DDO_RENDER_TOP=false

stls/c64gs-kb-case-top-leftport.stl: stls ${IN}
	${OPENSCAD} -DDO_RENDER_BOTTOM=false

stls/c64gs-kb-case-bottom-maxport.stl: stls ${IN}
	${OPENSCAD} -DDO_RENDER_TOP=false -DPORT_POS='"max"' -DPORT_WIDTH=90

stls/c64gs-kb-case-top-maxport.stl: stls ${IN}
	${OPENSCAD} -DDO_RENDER_BOTTOM=false -DPORT_POS='"max"' -DPORT_WIDTH=90

stls/c64gs-kb-case-bottom-centerport.stl: stls ${IN}
	${OPENSCAD} -DDO_RENDER_TOP=false -DPORT_POS='"center"'

stls/c64gs-kb-case-top-centerport.stl: stls ${IN}
	${OPENSCAD} -DDO_RENDER_BOTTOM=false -DPORT_POS='"center"'
