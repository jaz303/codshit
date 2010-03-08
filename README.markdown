codshit
=======

&copy; 2010 Jason Frame [ [jason@onehackoranother.com](mailto:jason@onehackoranother.com) / [@jaz303](http://twitter.com/jaz303) ]  
Released under the MIT License.

**codshit** n.
nonsense or go nowhere conversation, specifically conversations where all parties are loaded.

Codshit is a DSL for generating language based on a bunch of rules. The idea/syntax was inspired by (i.e. stolen from) http://eigenclass.org/hiki/language-generator. I suspect it could be useful for generating masses of semi-sensible test data for social media websites but I found it a lot more entertaining just to generate random insults.

Storyteller Example
-------------------

    require 'codshit'

    g = Codshit::Generator.new do |g|
  
      # default non-terminal is main, can be set with "start :whatever"
      main.is :salutation, " ", :name, " let me tell you a story... ", :story
  
      # choice
      salutation.is "hello" | "awrite" | "sup" | "word"
  
      # procs are captured and are stable for the duration of the evaluation
      name.is { ("jason" | "john" | "alice" | "bob" | ["old " | "young ", "man" | "woman"]).to_text }
  
      insult.is "dickhead" | "bawbag" | "fucknut" | "scrotum"
  
      venue.is "cinema" | "club" | "mall"
      attacked.is "punched" | "kicked" | "bit" | "poked"
      target.is "head" | "ass" | "balls" | "face" | "leg" | "arm"
  
      story_venue.is { :venue }
  
      # choice
      story.define do
        is "so there i was at the ", :story_venue, " when some ", :insult, " comes up to me and calls me a ", :insult, " so i ", :attacked, " that little ", :insult, " in the ", :target, ". i swear, that's the last time i'm ever going to the ", :story_venue, " again."
        is "i went into a maze and ", :maze, :maze_cons
        is "on second thoughts i can't be fucked."
      end
  
      # recursion
      maze.is "went forward" | "went left" | "went right" | "went back" | "sat down for a rest"
      maze_cons.is " then ", ([:maze, :maze_cons] | [:maze, :maze_cons] | [:maze, :maze_cons] | "found the exit" | "died of starvation")
  
    end

    puts g.generate

Possible output:

    word young man let me tell you a story... so there i was at the cinema when some dickhead comes up to me and calls me a bawbag so i poked that little scrotum in the arm. i swear, that's the last time i'm ever going to the club again.
    
Our how about:

    sup alice let me tell you a story... i went into a maze and sat down for a rest then went left then went back then sat down for a rest then went forward then went left then went left then died of starvation
    
Applications in the Decision Making Process
-------------------------------------------

You could even use codshit to pick your next pet-project:

    g = Codshit::Generator.new do |g|

      main.is "a ", :project_type, " written in ", :implementation_language

      project_type.is :project_involving_parser | "CMS" | "templating language" | "web framework" | "key-value store"

      project_involving_parser.is ["templating engine" | :programming_language, " parsed using ", :parser]
      parser.is "regular expressions and blind faith" | "SableCC" | ["a buggy hand-written lexer" | "Ragel" | "flex", " and ", "a dubious hand-crafted recursive descent parser" | "lemon" | "bison" | "peg/leg"]

      programming_language.is :typing, ", ", :compiled, " language"
      typing.is "dynamic" | "statically-typed"
      compiled.is "compiled" | "interpreted"

      implementation_language.is :language | ["an implementation of ", :language, " running on the ", :virtual_machine]

      language.is "PHP" | "Java" | "Ruby" | "Python" | "Scala" | "Erlang" | "Javascript" | "CLOS" | "Haskell" | "Factor" | "OCaml" | "IO" | "Ioke" | "Potion"
      virtual_machine.is "JVM" | "CLR"

    end

    puts g.generate

Generates:

    a statically-typed, compiled language parsed using Ragel and a dubious hand-crafted recursive descent parser written in an implementation of Ioke running on the CLR

Have fun! xxx