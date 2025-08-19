(* Step 6 Runner: Web Content Processing & Scraping *)
(* Execute and test Step 6 implementation *)

(* Load the main app package *)
Get["src/MultiModalApp.wl"];

(* Load the test packages *)
Get["tests/Step1Test.wl"];
Get["tests/Step2Test.wl"];
Get["tests/Step3Test.wl"];
Get["tests/Step4Test.wl"];
Get["tests/Step5Test.wl"];
Get["tests/Step6Test.wl"];

Print[Style["Multi-Modal LLM App - Step 6 Implementation", "Title"]];
Print["Implementing web content processing & scraping..."];
Print[""];

(* First verify Steps 1-5 are still working *)
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
      (* If Steps 1-3 passed, check Step 4 *)
      Print[Style["Verifying Step 4 Audio Processing...", "Subsection"]];
      step4Passed = Step4Test`RunStep4Tests[];
      
      Print[""];
      
      If[step4Passed,
        (* If Steps 1-4 passed, check Step 5 *)
        Print[Style["Verifying Step 5 Video Processing...", "Subsection"]];
        step5Passed = Step5Test`RunStep5Tests[];
        
        Print[""];
        
        If[step5Passed,
          (* If Steps 1-5 passed, run Step 6 tests *)
          Print[Style["Running Step 6 Tests...", "Subsection"]];
          step6Passed = Step6Test`RunStep6Tests[];
          
          Print[""];
          
          If[step6Passed,
            (* If all steps passed *)
            Print[Style["Step 6 Implementation Complete!", "Subsection", Green]];
            Print[""];
            Print["New capabilities added:"];
            Print["• URL validation and format checking"];
            Print["• Webpage content fetching with timeout protection"];
            Print["• HTML content parsing and text extraction"];
            Print["• Comprehensive webpage processing combining validation, fetching, and parsing"];
            Print["• Integration with LLM pipeline for intelligent webpage understanding"];
            Print["• Enhanced web interface showing detailed webpage processing results"];
            Print["• Robust error handling for network failures and invalid URLs"];
            Print[""];
            Print["To test webpage processing manually:"];
            Print[Style["MultiModalApp`ProcessWebpageInput[\"https://www.example.com\"]", "Code"]];
            Print[""];
            Print["To deploy with web content processing:"];
            Print[Style["MultiModalApp`DeployApp[]", "Code"]];
            Print[""];
            Print["✅ Ready to proceed to Step 7: Keyboard/Mouse Event Processing"];,
            
            (* If Step 6 failed *)
            Print[Style["Step 6 Implementation Issues Found!", "Subsection", Red]];
            Print["Please review and fix Step 6 issues before proceeding."];
          ];,
          
          (* If Step 5 failed *)
          Print[Style["Step 5 Video Processing Issues Found!", "Subsection", Red]];
          Print["Please fix Step 5 issues before Step 6 can be tested."];
        ];,
        
        (* If Step 4 failed *)
        Print[Style["Step 4 Audio Processing Issues Found!", "Subsection", Red]];
        Print["Please fix Step 4 issues before Steps 5-6 can be tested."];
      ];,
      
      (* If Step 3 failed *)
      Print[Style["Step 3 Image Processing Issues Found!", "Subsection", Red]];
      Print["Please fix Step 3 issues before Steps 4-6 can be tested."];
    ];,
    
    (* If Step 2 failed *)
    Print[Style["Step 2 LLM Integration Issues Found!", "Subsection", Red]];
    Print["Please fix Step 2 issues before Steps 3-6 can be tested."];
  ];,
  
  (* If Step 1 failed *)
  Print[Style["Step 1 Foundation Issues Found!", "Subsection", Red]];
  Print["Please fix Step 1 issues before Steps 2-6 can be tested."];
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
  Print["Step 4: Audio Processing with Speech-to-Text"]
];
If[step1Passed && step2Passed && step3Passed && step4Passed && step5Passed,
  Print["✅ Step 5: Video Processing with Transcription & Frame Analysis"],
  Print["Step 5: Video Processing with Transcription & Frame Analysis"]
];
If[step1Passed && step2Passed && step3Passed && step4Passed && step5Passed && step6Passed,
  Print["✅ Step 6: Web Content Processing & Scraping"],
  Print["Step 6: Web Content Processing & Scraping (In Progress)"]
];
Print["Step 7: Keyboard/Mouse Event Processing (Next)"];
Print["Steps 8-20: Remaining implementations"];