g_PluginInfo =
{
	Name = "ParticleTrails",
	Version = "2",
	Date = "2017-03-26",
	SourceLocation = "https://github.com/mathiascode/ParticleTrails",
	Description = [[Plugin for Cuberite that creates particle trails behind players.]],

	Commands =
	{
		["/particletrails"] =
		{
			Alias = { "/particletrail", "/trail", },
			Handler = HandleParticleTrailsCommand,
			Permission = "particletrails",
			HelpString = "Creates a particle trail behind you"
		},
	},
}
