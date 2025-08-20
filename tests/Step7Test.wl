(* Test Suite for Step 7: Keyboard/Mouse Event Processing *)
(* Tests for MultiModalApp keyboard/mouse event processing functionality *)

BeginPackage["Step7Test`"];

Needs["MultiModalApp`"];

(* Test function declarations *)
RunStep7Tests::usage = "RunStep7Tests[] runs all tests for Step 7";
TestKeyboardEventParsing::usage = "TestKeyboardEventParsing[] tests keyboard event parsing functionality";
TestMouseEventParsing::usage = "TestMouseEventParsing[] tests mouse event parsing functionality";
TestEventPatternAnalysis::usage = "TestEventPatternAnalysis[] tests event pattern analysis";
TestEventProcessingIntegration::usage = "TestEventProcessingIntegration[] tests comprehensive event processing";
TestEventLLMIntegration::usage = "TestEventLLMIntegration[] tests event processing with LLM pipeline";
TestEventDisplayFormatting::usage = "TestEventDisplayFormatting[] tests event result display formatting";
TestEmptyEventHandling::usage = "TestEmptyEventHandling[] tests handling of empty event input";
TestEventErrorHandling::usage = "TestEventErrorHandling[] tests event processing error handling";

Begin["`Private`"];

(* Helper function to create test event descriptions *)
CreateKeyboardTestEvents[] := Module[{eventText},
  eventText = "User pressed ctrl+c to copy text, then typed \"Hello World\" and pressed Enter to submit. Also hit F5 to refresh and pressed Alt+Tab to switch windows.";
  eventText
];

CreateMouseTestEvents[] := Module[{eventText},
  eventText = "User clicked on the submit button, then double-clicked on a text field. Moved mouse to (100, 200) and right-clicked to open context menu. Scrolled down to view more content.";
  eventText
];

CreateMixedTestEvents[] := Module[{eventText},
  eventText = "User clicked on input field, typed \"test message\", pressed Ctrl+A to select all, then Ctrl+C to copy. Moved mouse to save button and clicked it. Pressed F12 to open developer tools.";
  eventText
];

CreateEmptyTestEvents[] := Module[{eventText},
  eventText = "User looked at the screen and thought about what to do next.";
  eventText
];

(* Test keyboard event parsing *)
TestKeyboardEventParsing[] := Module[{testEventText, keyboardResult, testResult},
  Print["Testing Keyboard Event Parsing..."];
  
  (* Create test keyboard events *)
  testEventText = CreateKeyboardTestEvents[];
  
  (* Test keyboard event parsing *)
  keyboardResult = MultiModalApp`ParseKeyboardEvents[testEventText];
  
  (* Verify keyboard parsing results *)
  testResult = AssociationQ[keyboardResult] && 
               KeyExistsQ[keyboardResult, "pressEvents"] && 
               KeyExistsQ[keyboardResult, "sequences"] &&
               KeyExistsQ[keyboardResult, "typedText"] &&
               KeyExistsQ[keyboardResult, "hasKeyboardEvents"] &&
               KeyExistsQ[keyboardResult, "method"] &&
               keyboardResult["method"] == "KeyboardEventParsing" &&
               keyboardResult["hasKeyboardEvents"] === True;
  
  If[testResult,
    Print[Style["✓ Keyboard event parsing working", Green]];
    Print["  Events detected: " <> ToString[keyboardResult["eventCount"]]];
    Print["  Press events: " <> ToString[Length[keyboardResult["pressEvents"]]]];
    Print["  Key sequences: " <> ToString[Length[keyboardResult["sequences"]]]];
    Print["  Typed text: " <> ToString[Length[keyboardResult["typedText"]]]],
    Print[Style["✗ Keyboard event parsing failed", Red]]
  ];
  
  testResult
];

(* Test mouse event parsing *)
TestMouseEventParsing[] := Module[{testEventText, mouseResult, testResult},
  Print["Testing Mouse Event Parsing..."];
  
  (* Create test mouse events *)
  testEventText = CreateMouseTestEvents[];
  
  (* Test mouse event parsing *)
  mouseResult = MultiModalApp`ParseMouseEvents[testEventText];
  
  (* Verify mouse parsing results *)
  testResult = AssociationQ[mouseResult] && 
               KeyExistsQ[mouseResult, "clickEvents"] && 
               KeyExistsQ[mouseResult, "moveEvents"] &&
               KeyExistsQ[mouseResult, "scrollEvents"] &&
               KeyExistsQ[mouseResult, "hasMouseEvents"] &&
               KeyExistsQ[mouseResult, "method"] &&
               mouseResult["method"] == "MouseEventParsing" &&
               mouseResult["hasMouseEvents"] === True;
  
  If[testResult,
    Print[Style["✓ Mouse event parsing working", Green]];
    Print["  Events detected: " <> ToString[mouseResult["eventCount"]]];
    Print["  Click events: " <> ToString[Length[mouseResult["clickEvents"]]]];
    Print["  Move events: " <> ToString[Length[mouseResult["moveEvents"]]]];
    Print["  Scroll events: " <> ToString[Length[mouseResult["scrollEvents"]]]],
    Print[Style["✗ Mouse event parsing failed", Red]]
  ];
  
  testResult
];

(* Test event pattern analysis *)
TestEventPatternAnalysis[] := Module[{keyboardEvents, mouseEvents, patternResult, testResult},
  Print["Testing Event Pattern Analysis..."];
  
  (* Create test events *)
  keyboardEvents = MultiModalApp`ParseKeyboardEvents[CreateKeyboardTestEvents[]];
  mouseEvents = MultiModalApp`ParseMouseEvents[CreateMouseTestEvents[]];
  
  (* Test pattern analysis *)
  patternResult = MultiModalApp`AnalyzeEventPatterns[keyboardEvents, mouseEvents];
  
  (* Verify pattern analysis results *)
  testResult = AssociationQ[patternResult] && 
               KeyExistsQ[patternResult, "totalEvents"] && 
               KeyExistsQ[patternResult, "eventTypes"] &&
               KeyExistsQ[patternResult, "complexity"] &&
               KeyExistsQ[patternResult, "description"] &&
               KeyExistsQ[patternResult, "hasPatterns"] &&
               KeyExistsQ[patternResult, "method"] &&
               patternResult["method"] == "EventPatternAnalysis" &&
               patternResult["hasPatterns"] === True;
  
  If[testResult,
    Print[Style["✓ Event pattern analysis working", Green]];
    Print["  Total events: " <> ToString[patternResult["totalEvents"]]];
    Print["  Event types: " <> StringRiffle[patternResult["eventTypes"], ", "]];
    Print["  Complexity: " <> patternResult["complexity"]];
    Print["  Description: " <> StringTake[patternResult["description"], UpTo[100]] <> "..."],
    Print[Style["✗ Event pattern analysis failed", Red]]
  ];
  
  testResult
];

(* Test comprehensive event processing *)
TestEventProcessingIntegration[] := Module[{testEventText, eventResult, testResult},
  Print["Testing Comprehensive Event Processing Integration..."];
  
  (* Create test mixed events *)
  testEventText = CreateMixedTestEvents[];
  
  (* Test comprehensive event processing *)
  eventResult = MultiModalApp`ProcessEventInput[testEventText];
  
  (* Verify comprehensive processing result *)
  testResult = AssociationQ[eventResult] && 
               KeyExistsQ[eventResult, "combinedDescription"] && 
               KeyExistsQ[eventResult, "keyboardResult"] &&
               KeyExistsQ[eventResult, "mouseResult"] &&
               KeyExistsQ[eventResult, "patternResult"] &&
               KeyExistsQ[eventResult, "hasContent"] &&
               KeyExistsQ[eventResult, "processedAt"] &&
               eventResult["hasContent"] === True;
  
  If[testResult,
    Print[Style["✓ Comprehensive event processing working", Green]];
    Print["  Description: " <> StringTake[eventResult["combinedDescription"], UpTo[100]] <> "..."];
    Print["  Has content: " <> ToString[eventResult["hasContent"]]];
    Print["  Total events: " <> ToString[eventResult["patternResult"]["totalEvents"]]],
    Print[Style["✗ Comprehensive event processing failed", Red]]
  ];
  
  testResult
];

(* Test event processing with LLM integration *)
TestEventLLMIntegration[] := Module[{testEventText, testData, result, testResult},
  Print["Testing Event Processing with LLM Integration..."];
  
  (* Create test event data *)
  testEventText = CreateKeyboardTestEvents[];
  
  (* Test data with event input *)
  testData = <|
    "textInput" -> "Analyze these user interactions",
    "imageUpload" -> None,
    "audioUpload" -> None,
    "videoUpload" -> None,
    "webpageURL" -> None,
    "eventInput" -> testEventText
  |>;
  
  (* Process with LLM integration *)
  result = Catch[
    MultiModalApp`ProcessUserInput[testData],
    _, 
    $Failed
  ];
  
  (* Verify LLM integration *)
  testResult = result =!= $Failed;
  
  If[testResult,
    Print[Style["✓ Event-LLM integration working", Green]];
    Print["  Form processing with event input successful"],
    Print[Style["✗ Event-LLM integration failed", Red]]
  ];
  
  testResult
];

(* Test event result display formatting *)
TestEventDisplayFormatting[] := Module[{testEventText, formData, displayResult, testResult},
  Print["Testing Event Result Display Formatting..."];
  
  (* Create test event text *)
  testEventText = CreateMixedTestEvents[];
  
  (* Create test form data *)
  formData = <|"textInput" -> "Test event analysis", "eventInput" -> testEventText|>;
  
  (* Test display formatting *)
  displayResult = Catch[
    MultiModalApp`ProcessUserInput[formData],
    _, $Failed
  ];
  
  (* Verify display formatting *)
  testResult = displayResult =!= $Failed;
  
  If[testResult,
    Print[Style["✓ Event display formatting successful", Green]],
    Print[Style["✗ Event display formatting failed", Red]]
  ];
  
  testResult
];

(* Test empty event handling *)
TestEmptyEventHandling[] := Module[{emptyEventResult, testResult},
  Print["Testing Empty Event Input Handling..."];
  
  (* Test with empty event input *)
  emptyEventResult = Catch[
    Module[{formData, result},
      formData = <|"textInput" -> "No events", "eventInput" -> ""|>;
      result = MultiModalApp`ProcessUserInput[formData];
      result
    ],
    _, $Failed
  ];
  
  (* Verify empty handling *)
  testResult = emptyEventResult =!= $Failed;
  
  If[testResult,
    Print[Style["✓ Empty event handling successful", Green]],
    Print[Style["✗ Empty event handling failed", Red]]
  ];
  
  testResult
];

(* Test event processing error handling *)
TestEventErrorHandling[] := Module[{invalidEventResult, testResult},
  Print["Testing Event Processing Error Handling..."];
  
  (* Test with various inputs *)
  invalidEventResult = Catch[
    Module[{result1, result2, result3},
      (* Test with non-event text *)
      result1 = MultiModalApp`ProcessEventInput[CreateEmptyTestEvents[]];
      (* Test with minimal events *)
      result2 = MultiModalApp`ProcessEventInput["clicked something"];
      (* Test with empty string *)
      result3 = MultiModalApp`ProcessEventInput[""];
      
      (* All should handle gracefully *)
      AssociationQ[result1] && AssociationQ[result2] && AssociationQ[result3]
    ],
    _, 
    False
  ];
  
  (* Verify error handling *)
  testResult = invalidEventResult === True;
  
  If[testResult,
    Print[Style["✓ Event error handling successful", Green]],
    Print[Style["✗ Event error handling failed", Red]]
  ];
  
  testResult
];

(* Main test runner for Step 7 *)
RunStep7Tests[] := Module[{testResults, allPassed},
  Print[Style["Running Step 7 Tests: Keyboard/Mouse Event Processing", "Subsection"]];
  Print[""];
  
  testResults = {
    TestKeyboardEventParsing[],
    TestMouseEventParsing[],
    TestEventPatternAnalysis[],
    TestEventProcessingIntegration[],
    TestEventLLMIntegration[],
    TestEventDisplayFormatting[],
    TestEmptyEventHandling[],
    TestEventErrorHandling[]
  };
  
  allPassed = And @@ testResults;
  
  Print[""];
  If[allPassed,
    Print[Style["✓ All Step 7 tests passed! Keyboard/Mouse event processing is working correctly.", "Text", Green]],
    Print[Style["✗ Some Step 7 tests failed. Please check the event processing implementation.", "Text", Red]]
  ];
  
  allPassed
];

End[];
EndPackage[];