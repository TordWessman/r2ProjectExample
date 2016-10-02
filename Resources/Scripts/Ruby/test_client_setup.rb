require 'colors'
require 'output'
require 'scriptbase'

class MainClass  < ScriptBase

	def setup
			
		core = @go.robot.get("core")

		audio_factory = @go.robot.get("audio_factory")
		tts = audio_factory.create_espeak("es");	
		tts.start
		core.add_device tts

		mp3 = audio_factory.create_mp3_player("mp3");	
		mp3.start
		core.add_device mp3

		OP::msg "Test SETUP DONE!"

	end

	def stop
		@should_run = false
	end

	def should_run
		return @should_run
	end

	def loop
		return true
	end


end

self.main_class = MainClass.new(self)
