(* Step 2 Runner: Text Processing & Master LLM Integration *)
(* Execute and test Step 2 implementation *)

(* Load the main app package *)
Get["src/MultiModalApp.wl"];

(* Load the test packages *)
Get["tests/Step1Test.wl"];
Get["tests/Step2Test.wl"];

Print[Style["Multi-Modal LLM App - Step 2 Implementation", "Title"]];
Print["Implementing text processing and Master LLM integration..."];
Print[""];

(* First verify Step 1 is still working *)
Print[Style["Verifying Step 1 Foundation...", "Subsection"]];
step1Passed = Step1Test`RunStep1Tests[];

Print[""];

If[step1Passed,
  (* If Step 1 passed, run Step 2 tests *)
  Print[Style["Running Step 2 Tests...", "Subsection"]];
  step2Passed = Step2Test`RunStep2Tests[];
  
  Print[""];
  
  If[step2Passed,
    (* If both steps passed *)
    Print[Style["Step 2 Implementation Complete!", "Subsection", Green]];
    Print[""];
    Print["New capabilities added:"];
    Print["• Master LLM initialization and configuration"];
    Print["• Enhanced text input processing and analysis"];
    Print["• Multi-modal prompt creation for LLM"];
    Print["• LLM response generation and formatting"];
    Print["• Intelligent form processing with AI responses"];
    Print["• Error handling for LLM service unavailability"];
    Print[""];
    Print["To test LLM functionality manually:"];
    Print[Style["MultiModalApp`InitializeMasterLLM[]", "Code"]];
    Print[Style["MultiModalApp`ProcessTextWithLLM[<|\"textInput\" -> \"Hello AI\"|>]", "Code"]];
    Print[""];
    Print["To deploy with LLM integration:"];
    Print[Style["MultiModalApp`DeployApp[]", "Code"]];
    Print[""];
    Print["✅ Ready to proceed to Step 3: Image Processing with OCR & Object Recognition"];,
    
    (* If Step 2 failed *)
    Print[Style["Step 2 Implementation Issues Found!", "Subsection", Red]];
    Print["Please review and fix Step 2 issues before proceeding."];
  ];,
  
  (* If Step 1 failed *)
  Print[Style["Step 1 Foundation Issues Found!", "Subsection", Red]];
  Print["Please fix Step 1 issues before Step 2 can be tested."];
];

(* Summary of current capabilities *)
Print[""];
Print[Style["Current Multi-Modal LLM App Status:", "Subsection"]];
Print["✅ Step 1: Basic Web App Infrastructure"];
If[step1Passed && step2Passed,
  Print["✅ Step 2: Text Processing & Master LLM Integration"],
  Print["🔄 Step 2: In Progress - Text Processing & Master LLM Integration"]
];
Print["Step 3: Image Processing (Next)"];
Print["Steps 4-20: Remaining implementations"];