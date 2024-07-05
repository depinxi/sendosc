newoption {
	trigger = "location",
	description = "Build scripts location directory",
	value = "path",
	default = path.join ("scripts", os.get(), _ACTION)
}

newoption {
	trigger = "targetdir",
	description = "Binary target directory",
	value = "path",
	default = path.join ("output", "%{cfg.name}")
}



workspace "sendosc"

	configurations { "Release", "Debug" }
	location (_OPTIONS["location"])
	objdir (path.join (_OPTIONS["targetdir"], "obj"))
	targetdir (_OPTIONS["targetdir"])

	project "ip"
		kind "StaticLib"
		language "C++"
		targetdir (path.join(_OPTIONS["targetdir"], "lib"))
		files { "./vendor/oscpack/ip/*.*" }
		includedirs { 
			"./vendor/oscpack", 
			"./vendor/oscpack/ip" 
		}
		filter { "system:windows" }
			files { "./vendor/oscpack/ip/win32/*.*" }
		filter { "system:not windows" }
			files { "./vendor/oscpack/ip/posix/*.*" }
		filter { }
		
	project "oscpack"
		kind "StaticLib"
		language "C++"
		targetdir (path.join(_OPTIONS["targetdir"], "lib"))
		files { "./vendor/oscpack/osc/*.*" }

	project "sendosc"
		kind "ConsoleApp"
		language "C++"
		targetdir (path.join(_OPTIONS["targetdir"], "bin"))
		includedirs {"./vendor/oscpack"}
		files { "sendosc.cpp" }
		links { "ip", "oscpack" }
	
