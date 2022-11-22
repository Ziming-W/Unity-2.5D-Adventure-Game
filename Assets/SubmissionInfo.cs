
// This class contains metadata for your submission. It plugs into some of our
// grading tools to extract your game/team details. Ensure all Gradescope tests
// pass when submitting, as these do some basic checks of this file.
public static class SubmissionInfo
{
    // TASK: Fill out all team + team member details below by replacing the
    // content of the strings. Also ensure you read the specification carefully
    // for extra details related to use of this file.

    // URL to your group's project 2 repository on GitHub.
    public static readonly string RepoURL = "https://github.com/COMP30019/project-2-ikun";
    
    // Come up with a team name below (plain text, no more than 50 chars).
    public static readonly string TeamName = "iKun";
    
    // List every team member below. Ensure student names/emails match official
    // UniMelb records exactly (e.g. avoid nicknames or aliases).
    public static readonly TeamMember[] Team = new[]
    {
        new TeamMember("Yaofei Liu", "yaofeil@student.unimelb.edu.au"),
        new TeamMember("Ziming Wang", "zimiwang@student.unimelb.edu.au"),
        new TeamMember("Yihang Li", "yihang3@student.unimelb.edu.au"),
        // Remove the following line if you have a group of 3
        new TeamMember("Kailun Zhang", " kkzhang@student.unimelb.edu.au"), 
    };

    // This may be a "working title" to begin with, but ensure it is final by
    // the video milestone deadline (plain text, no more than 50 chars).
    public static readonly string GameName = "Kun Kun’s Bizarre Adventure";

    // Write a brief blurb of your game, no more than 200 words. Again, ensure
    // this is final by the video milestone deadline.
    public static readonly string GameBlurb = 
@"Throughout the Magicland, a legend is told. On a distant island, a rotten tree of taken stood, turning villiges into inferno, animals into bloodthirsty monsters. To end the era of calamity and bring peace to mankind. Young Kun Kun must take the adventure. 
_Kun Kun’s Bizarre Adventure_ is a 2.5D parkour platformer game. you will be role-playing Kunkun and take an advanture on a magic land. Defeat all enemies on the way, and finally challenge the ultimate boss to bring peace to this land.  
";
    
    // By the gameplay video milestone deadline this should be a direct link
    // to a YouTube video upload containing your video. Ensure "Made for kids"
    // is turned off in the video settings. 
    public static readonly string GameplayVideo = "https://www.youtube.com/watch?v=BIWlkeQ0PZA";
    
    // No more info to fill out!
    // Please don't modify anything below here.
    public readonly struct TeamMember
    {
        public TeamMember(string name, string email)
        {
            Name = name;
            Email = email;
        }

        public string Name { get; }
        public string Email { get; }
    }
}
