(* Step 4 Runner: Audio Processing with Speech-to-Text *)
(* Execute and test Step 4 implementation *)

(* Load the main app package *)
Get["src/MultiModalApp.wl"];

(* Load the test packages *)
Get["tests/Step1Test.wl"];
Get["tests/Step2Test.wl"];
Get["tests/Step3Test.wl"];
Get["tests/Step4Test.wl"];

Print[Style["Multi-Modal LLM App - Step 4 Implementation", "Title"]];
Print["Implementing audio processing with speech-to-text..."];
Print[""];

(* First verify Steps 1-3 are still working *)
Print[Style["Verifying Step 1 Foundation...", "Subsection"]];
step1Passed = Step1Test`RunStep1Tests[];

Print[""];

If[step1Passed,
  (* If Step 1 passed, check Step 2 *)
  Print[Style["Verifying Step 2 LLM Integration...", "Subsection"]];
  step2Passed = Step2Test`RunStep2Tests[];
  
  Print[""];
  
  If[step2Passed,
    (* If Steps 1-2 passed, check Step 3 *)
    Print[Style["Verifying Step 3 Image Processing...", "Subsection"]];
    step3Passed = Step3Test`RunStep3Tests[];
    
    Print[""];
    
    If[step3Passed,
      (* If Steps 1-3 passed, run Step 4 tests *)
      Print[Style["Running Step 4 Tests...", "Subsection"]];
      step4Passed = Step4Test`RunStep4Tests[];
      
      Print[""];
      
      If[step4Passed,
        (* If all steps passed *)
        Print[Style["Step 4 Implementation Complete!", "Subsection", Green]];
        Print[""];
        Print["New capabilities added:"];
        Print["• Audio speech-to-text transcription using SpeechRecognize"];
        Print["• Audio metadata extraction (duration, sample rate, channels)"];
        Print["• Comprehensive audio analysis combining transcription and metadata"];
        Print["• Integration with LLM pipeline for intelligent audio understanding"];
        Print["• Enhanced web interface showing detailed audio processing results"];
        Print["• Error handling for audio processing failures"];
        Print[""];
        Print["To test audio processing manually:"];
        Print[Style["testAudio = Import[\"path/to/audio.mp3\"]", "Code"]];
        Print[Style["MultiModalApp`ProcessAudioInput[testAudio]", "Code"]];
        Print[""];
        Print["To deploy with audio processing:"];
        Print[Style["MultiModalApp`DeployApp[]", "Code"]];
        Print[""];
        Print["✅ Ready to proceed to Step 5: Video Processing with Transcription & Analysis"];,
        
        (* If Step 4 failed *)
        Print[Style["Step 4 Implementation Issues Found!", "Subsection", Red]];
        Print["Please review and fix Step 4 issues before proceeding."];
      ];,
      
      (* If Step 3 failed *)
      Print[Style["Step 3 Image Processing Issues Found!", "Subsection", Red]];
      Print["Please fix Step 3 issues before Step 4 can be tested."];
    ];,
    
    (* If Step 2 failed *)
    Print[Style["Step 2 LLM Integration Issues Found!", "Subsection", Red]];
    Print["Please fix Step 2 issues before Steps 3-4 can be tested."];
  ];,
  
  (* If Step 1 failed *)
  Print[Style["Step 1 Foundation Issues Found!", "Subsection", Red]];
  Print["Please fix Step 1 issues before Steps 2-4 can be tested."];
];

(* Summary of current capabilities *)
Print[""];
Print[Style["Current Multi-Modal LLM App Status:", "Subsection"]];
Print["✅ Step 1: Basic Web App Infrastructure"];
If[step1Passed && step2Passed,
  Print["✅ Step 2: Text Processing & Master LLM Integration"],
  Print["Step 2: Text Processing & Master LLM Integration"]
];
If[step1Passed && step2Passed && step3Passed,
  Print["✅ Step 3: Image Processing with OCR & Object Recognition"],
  Print["Step 3: Image Processing with OCR & Object Recognition"]
];
If[step1Passed && step2Passed && step3Passed && step4Passed,
  Print["✅ Step 4: Audio Processing with Speech-to-Text"],
  Print["Step 4: Audio Processing with Speech-to-Text (In Progress)"]
];
Print["Step 5: Video Processing (Next)"];
Print["Steps 6-20: Remaining implementations"];