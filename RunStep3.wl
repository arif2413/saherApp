(* Step 3 Runner: Image Processing with OCR & Object Recognition *)
(* Execute and test Step 3 implementation *)

(* Load the main app package *)
Get["src/MultiModalApp.wl"];

(* Load the test packages *)
Get["tests/Step1Test.wl"];
Get["tests/Step2Test.wl"];
Get["tests/Step3Test.wl"];

Print[Style["Multi-Modal LLM App - Step 3 Implementation", "Title"]];
Print["Implementing image processing with OCR and object recognition..."];
Print[""];

(* First verify Steps 1 and 2 are still working *)
Print[Style["Verifying Step 1 Foundation...", "Subsection"]];
step1Passed = Step1Test`RunStep1Tests[];

Print[""];

If[step1Passed,
  (* If Step 1 passed, check Step 2 *)
  Print[Style["Verifying Step 2 LLM Integration...", "Subsection"]];
  step2Passed = Step2Test`RunStep2Tests[];
  
  Print[""];
  
  If[step2Passed,
    (* If Steps 1-2 passed, run Step 3 tests *)
    Print[Style["Running Step 3 Tests...", "Subsection"]];
    step3Passed = Step3Test`RunStep3Tests[];
    
    Print[""];
    
    If[step3Passed,
      (* If all steps passed *)
      Print[Style["Step 3 Implementation Complete!", "Subsection", Green]];
      Print[""];
      Print["New capabilities added:"];
      Print["• Image OCR text extraction using TextRecognize"];
      Print["• Object recognition using ImageIdentify"];
      Print["• Comprehensive image analysis combining OCR and object detection"];
      Print["• Integration with LLM pipeline for intelligent image understanding"];
      Print["• Enhanced web interface showing detailed image processing results"];
      Print["• Error handling for image processing failures"];
      Print[""];
      Print["To test image processing manually:"];
      Print[Style["testImage = Import[\"path/to/image.jpg\"]", "Code"]];
      Print[Style["MultiModalApp`ProcessImageInput[testImage]", "Code"]];
      Print[""];
      Print["To deploy with image processing:"];
      Print[Style["MultiModalApp`DeployApp[]", "Code"]];
      Print[""];
      Print["✅ Ready to proceed to Step 4: Audio Processing with Speech-to-Text"];,
      
      (* If Step 3 failed *)
      Print[Style["Step 3 Implementation Issues Found!", "Subsection", Red]];
      Print["Please review and fix Step 3 issues before proceeding."];
    ];,
    
    (* If Step 2 failed *)
    Print[Style["Step 2 LLM Integration Issues Found!", "Subsection", Red]];
    Print["Please fix Step 2 issues before Step 3 can be tested."];
  ];,
  
  (* If Step 1 failed *)
  Print[Style["Step 1 Foundation Issues Found!", "Subsection", Red]];
  Print["Please fix Step 1 issues before Steps 2-3 can be tested."];
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
  Print["Step 3: Image Processing with OCR & Object Recognition (In Progress)"]
];
Print["Step 4: Audio Processing (Next)"];
Print["Steps 5-20: Remaining implementations"];