(* Step 1 Runner: Basic Web App Infrastructure *)
(* Execute and test Step 1 implementation *)

(* Load the main app package *)
Get["src/MultiModalApp.wl"];

(* Load the test package *)
Get["tests/Step1Test.wl"];

Print[Style["Multi-Modal LLM App - Step 1 Implementation", "Title"]];
Print["Setting up basic Wolfram Cloud web app infrastructure..."];
Print[""];

(* Run the tests *)
testsPassed = Step1Test`RunStep1Tests[];

Print[""];

If[testsPassed,
  (* If tests passed, show deployment example *)
  Print[Style["Step 1 Implementation Complete!", "Subsection", Green]];
  Print[""];
  Print["To deploy the app to Wolfram Cloud, run:"];
  Print[Style["MultiModalApp`DeployApp[]", "Code"]];
  Print[""];
  Print["Current capabilities:"];
  Print["• Web form interface for multi-modal input"];
  Print["• Text input processing"];
  Print["• File upload handling (images, audio, video)"];
  Print["• URL input processing"];
  Print["• Basic form validation and response"];
  Print[""];
  Print["Ready to proceed to Step 2: Text Processing & Master LLM Integration"];,
  
  (* If tests failed *)
  Print[Style["Step 1 Implementation Issues Found!", "Subsection", Red]];
  Print["Please review and fix the issues before proceeding."];
];

(* Optional: Create a demonstration of the interface *)
Print[""];
Print["To see the web interface structure, run:"];
Print[Style["MultiModalApp`CreateWebInterface[]", "Code"]];