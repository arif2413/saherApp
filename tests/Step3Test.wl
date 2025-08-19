(* Test Suite for Step 3: Image Processing with OCR & Object Recognition *)
(* Tests for MultiModalApp image processing functionality *)

BeginPackage["Step3Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep3Tests::usage = "RunStep3Tests[] runs all tests for Step 3";
TestImageOCR::usage = "TestImageOCR[] tests OCR text extraction from images";
TestObjectRecognition::usage = "TestObjectRecognition[] tests object identification in images";
TestImageProcessingIntegration::usage = "TestImageProcessingIntegration[] tests comprehensive image processing";
TestImageLLMIntegration::usage = "TestImageLLMIntegration[] tests image processing with LLM pipeline";
TestImageDisplayFormatting::usage = "TestImageDisplayFormatting[] tests image result display formatting";

Begin["`Private`"];

(* Helper function to create test images *)
CreateTestImageWithText[] := Rasterize[
  Style["SAMPLE TEXT FOR OCR TESTING", "Title", FontSize -> 24], 
  ImageSize -> {400, 100}, Background -> White
];

CreateTestObjectImage[] := Rasterize[
  Graphics[
    {Red, Disk[{0, 0}, 1], Blue, Rectangle[{-0.5, -0.5}, {0.5, 0.5}]},
    ImageSize -> {200, 200}
  ]
];

(* Test OCR text extraction *)
TestImageOCR[] := Module[{testImage, ocrResult, testResult},
  Print["Testing Image OCR Text Extraction..."];
  
  (* Create test image with text *)
  testImage = CreateTestImageWithText[];
  
  (* Test OCR extraction *)
  ocrResult = MultiModalApp`ExtractTextFromImage[testImage];
  
  (* Verify OCR result structure *)
  testResult = AssociationQ[ocrResult] && 
               KeyExistsQ[ocrResult, "extractedText"] && 
               KeyExistsQ[ocrResult, "hasText"] &&
               KeyExistsQ[ocrResult, "method"] &&
               ocrResult["method"] == "TextRecognize";
  
  If[testResult,
    Print[Style["✓ Image OCR extraction working", Green]];
    Print["  Extracted text: " <> ToString[ocrResult["extractedText"]]],
    Print[Style["✗ Image OCR extraction failed", Red]]
  ];
  
  testResult
];

(* Test object recognition *)
TestObjectRecognition[] := Module[{testImage, objectResult, testResult},
  Print["Testing Image Object Recognition..."];
  
  (* Create test image with geometric objects *)
  testImage = CreateTestObjectImage[];
  
  (* Test object identification *)
  objectResult = MultiModalApp`IdentifyImageObjects[testImage];
  
  (* Verify object recognition result structure *)
  testResult = AssociationQ[objectResult] && 
               KeyExistsQ[objectResult, "primaryObject"] && 
               KeyExistsQ[objectResult, "confidence"] &&
               KeyExistsQ[objectResult, "method"] &&
               objectResult["method"] == "ImageIdentify";
  
  If[testResult,
    Print[Style["✓ Image object recognition working", Green]];
    Print["  Identified: " <> objectResult["primaryObject"] <> 
          " (confidence: " <> ToString[objectResult["confidence"]] <> ")"],
    Print[Style["✗ Image object recognition failed", Red]]
  ];
  
  testResult
];

(* Test comprehensive image processing *)
TestImageProcessingIntegration[] := Module[{testImage, processResult, testResult},
  Print["Testing Comprehensive Image Processing..."];
  
  (* Create test image with text *)
  testImage = CreateTestImageWithText[];
  
  (* Test comprehensive processing *)
  processResult = MultiModalApp`ProcessImageInput[testImage];
  
  (* Verify comprehensive processing result *)
  testResult = AssociationQ[processResult] && 
               KeyExistsQ[processResult, "combinedDescription"] && 
               KeyExistsQ[processResult, "ocrResult"] &&
               KeyExistsQ[processResult, "objectResult"] &&
               KeyExistsQ[processResult, "hasContent"] &&
               KeyExistsQ[processResult, "processedAt"];
  
  If[testResult,
    Print[Style["✓ Comprehensive image processing working", Green]];
    Print["  Description: " <> processResult["combinedDescription"]],
    Print[Style["✗ Comprehensive image processing failed", Red]]
  ];
  
  testResult
];

(* Test image processing with LLM integration *)
TestImageLLMIntegration[] := Module[{testImage, testData, result, testResult},
  Print["Testing Image Processing with LLM Integration..."];
  
  (* Create test image *)
  testImage = CreateTestImageWithText[];
  
  (* Test data with image *)
  testData = <|
    "textInput" -> "What do you see in this image?",
    "imageUpload" -> testImage,
    "audioUpload" -> None,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process with LLM integration *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify result includes image processing *)
  testResult = Head[result] === Column && Length[result[[1]]] > 0;
  
  If[testResult,
    Print[Style["✓ Image processing with LLM integration working", Green]],
    Print[Style["✗ Image processing with LLM integration failed", Red]]
  ];
  
  testResult
];

(* Test image result display formatting *)
TestImageDisplayFormatting[] := Module[{testImage, testData, result, testResult},
  Print["Testing Image Result Display Formatting..."];
  
  (* Create test image *)
  testImage = CreateTestImageWithText[];
  
  (* Test data with image *)
  testData = <|
    "textInput" -> "",
    "imageUpload" -> testImage,
    "audioUpload" -> None,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process and check formatting *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify proper formatting (basic structure check) *)
  testResult = Head[result] === Column;
  
  If[testResult,
    Print[Style["✓ Image display formatting working", Green]],
    Print[Style["✗ Image display formatting failed", Red]]
  ];
  
  testResult
];

(* Test empty image handling *)
TestEmptyImageHandling[] := Module[{result, testResult},
  Print["Testing Empty Image Handling..."];
  
  (* Test data with no image *)
  testData = <|
    "textInput" -> "",
    "imageUpload" -> None,
    "audioUpload" -> None,
    "videoUpload" -> None,
    "webpageURL" -> None
  |>;
  
  (* Process with no image *)
  result = MultiModalApp`ProcessUserInput[testData];
  
  (* Verify graceful handling *)
  testResult = Head[result] === Column;
  
  If[testResult,
    Print[Style["✓ Empty image handling working", Green]],
    Print[Style["✗ Empty image handling failed", Red]]
  ];
  
  testResult
];

(* Test image processing error handling *)
TestImageErrorHandling[] := Module[{testImage, ocrResult, objectResult, testResult},
  Print["Testing Image Processing Error Handling..."];
  
  (* Test with a simple graphic converted to image *)
  testImage = Rasterize[Graphics[Circle[]], ImageSize -> {100, 100}];
  
  (* Test OCR and object recognition (should handle gracefully) *)
  ocrResult = Catch[MultiModalApp`ExtractTextFromImage[testImage], _, None];
  objectResult = Catch[MultiModalApp`IdentifyImageObjects[testImage], _, None];
  
  (* Verify error handling doesn't crash and returns valid associations *)
  testResult = (ocrResult =!= None && AssociationQ[ocrResult]) && 
               (objectResult =!= None && AssociationQ[objectResult]);
  
  If[testResult,
    Print[Style["✓ Image processing error handling working", Green]],
    Print[Style["✗ Image processing error handling failed", Red]]
  ];
  
  testResult
];

(* Run all Step 3 tests *)
RunStep3Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 3 Tests: Image Processing with OCR & Object Recognition", "Subsection"]];
  Print["=" <> StringRepeat["=", 70]];
  
  (* Run individual tests *)
  testResults = {
    TestImageOCR[],
    TestObjectRecognition[],
    TestImageProcessingIntegration[],
    TestImageLLMIntegration[],
    TestImageDisplayFormatting[],
    TestEmptyImageHandling[],
    TestImageErrorHandling[]
  };
  
  (* Check if all tests passed *)
  allPassed = And @@ testResults;
  
  Print["=" <> StringRepeat["=", 70]];
  
  If[allPassed,
    Print[Style["✓ ALL STEP 3 TESTS PASSED", "Text", Green, Bold]];
    Print["Step 3 is ready for deployment and Step 4 implementation."],
    Print[Style["✗ SOME STEP 3 TESTS FAILED", "Text", Red, Bold]];
    Print["Please fix issues before proceeding to Step 4."]
  ];
  
  Print[""];
  Print["Test Summary:"];
  Print["- Image OCR: " <> If[testResults[[1]], "PASS", "FAIL"]];
  Print["- Object Recognition: " <> If[testResults[[2]], "PASS", "FAIL"]];
  Print["- Image Processing Integration: " <> If[testResults[[3]], "PASS", "FAIL"]];
  Print["- Image LLM Integration: " <> If[testResults[[4]], "PASS", "FAIL"]];
  Print["- Display Formatting: " <> If[testResults[[5]], "PASS", "FAIL"]];
  Print["- Empty Image Handling: " <> If[testResults[[6]], "PASS", "FAIL"]];
  Print["- Error Handling: " <> If[Length[testResults] >= 7 && testResults[[7]], "PASS", "FAIL"]];
  
  allPassed
];

End[];
EndPackage[];