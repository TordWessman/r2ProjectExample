# r2ProjectExample

Contains example projects for r2Project

TestClient - Simple implementation of a client with basic setup.

---- Known Errors ----
Source file `Settings/CoreConfigurationTemplate.cs' could not be found
You will have to force the compilation of the CoreConfiguration (and possibly other like AudioConfiguration) templates.

In order to use the mp3-player:
* Compile the the r2Project/Src/Audio/Native/r2mp3 files (see )
* Uncomment the line bellow in Resources/Scripts/Ruby/test_client_setup.rb

		#mp3 = audio_factory.create_mp3_player("mp3");	
		#mp3.start
		#core.add_device mp3

In order to use the speech synteziser:
* Compile the the r2Project/Src/Audio/Native/r2espeak files (see )
* Uncomment the line bellow in Resources/Scripts/Ruby/test_client_setup.rb

		#tts = audio_factory.create_espeak("tts");	
		#tts.start
		#core.add_device tts

