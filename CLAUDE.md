# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a multi-modal LLM assistant built entirely in Wolfram Language, designed as a web application for Wolfram Cloud. The system processes video, audio, images, user interactions, and web pages through a hierarchical LLM architecture using Wolfram Language 14.3's LLMGraph functionality.

## Development Commands

### Running Tests and Implementation

```mathematica
(* Execute current implementation with tests - Step 8 is latest *)
Get["RunStep8.wl"]

(* Run individual step tests *)
Get["tests/Step1Test.wl"]
Step1Test`RunStep1Tests[]

Get["tests/Step2Test.wl"] 
Step2Test`RunStep2Tests[]

Get["tests/Step3Test.wl"]
Step3Test`RunStep3Tests[]

Get["tests/Step4Test.wl"]
Step4Test`RunStep4Tests[]

Get["tests/Step5Test.wl"]
Step5Test`RunStep5Tests[]

Get["tests/Step6Test.wl"]
Step6Test`RunStep6Tests[]

Get["tests/Step7Test.wl"]
Step7Test`RunStep7Tests[]

Get["tests/Step8Test.wl"]
Step8Test`RunStep8Tests[]

(* Test LLM functionality manually *)
MultiModalApp`InitializeMasterLLM[]
MultiModalApp`ProcessTextWithLLM[<|"textInput" -> "Hello AI assistant"|>]

(* Test advanced LLM hierarchy (Step 8) *)
MultiModalApp`InitializeLLMHierarchy[]
MultiModalApp`ProcessWithLLMGraph[<|"textInput" -> "Test hierarchical processing"|>]

(* Deploy to Wolfram Cloud *)
MultiModalApp`DeployApp[]
```

### Development Workflow

1. **Load Package**: `Get["src/MultiModalApp.wl"]`
2. **Run Tests**: Execute step-specific test files using `RunStep{N}.wl`
3. **Validate**: All tests must pass before proceeding to next step
4. **Deploy**: Use `MultiModalApp`DeployApp[]` for cloud deployment

### Step Execution Pattern

Each step follows a standardized execution pattern via `RunStep{N}.wl` files:

```mathematica
(* Example: RunStep8.wl *)
Get["src/MultiModalApp.wl"];           (* Load main package *)
Get["tests/Step1Test.wl"];             (* Load all test packages *)
(* ... load other test files ... *)

(* Sequential validation: Each step tests all previous steps first *)
step1Passed = Step1Test`RunStep1Tests[];
If[step1Passed,
  step2Passed = Step2Test`RunStep2Tests[];
  (* ... continue through all steps ... *)
];

(* Only proceed if all foundation steps pass *)
If[allPreviousStepsPassed,
  stepNPassed = StepNTest`RunStepNTests[];
  (* Display results and next steps *)
];
```

This ensures **incremental validation** - each step verifies all previous functionality still works.

## Architecture Overview

### Core Package Structure

- **`src/MultiModalApp.wl`**: Main package containing all functionality across implementation steps
- **`tests/Step{N}Test.wl`**: Comprehensive test suites for each implementation step  
- **`RunStep{N}.wl`**: Step runners that load packages, run tests, and provide progress feedback
- **`Step{N}ValidationReport.md`**: Generated validation reports with detailed test results and status

### File Organization

```
SaherApp/
├── src/
│   └── MultiModalApp.wl          # Main application package with all functions
├── tests/
│   ├── Step1Test.wl              # Web infrastructure tests
│   ├── Step2Test.wl              # LLM integration tests  
│   ├── Step3Test.wl              # Image processing tests
│   ├── Step4Test.wl              # Audio processing tests
│   ├── Step5Test.wl              # Video processing tests
│   ├── Step6Test.wl              # Web content processing tests
│   ├── Step7Test.wl              # Event processing tests
│   └── Step8Test.wl              # Advanced LLM architecture tests
├── RunStep1.wl through RunStep8.wl  # Step execution scripts
└── CLAUDE.md                     # This documentation file
```

### Multi-Modal Processing Pipeline

The system follows a standardized input → text conversion → LLM processing workflow:

1. **Input Acquisition**: Video, audio, images, keyboard/mouse events, webpage content
2. **Text Standardization**: All inputs converted to text (OCR, speech-to-text, object identification)
3. **LLM Orchestration**: Master-Slave LLM hierarchy using LLMGraph
4. **Response Generation**: Formatted output with conversation context

### LLM Architecture

- **Master LLM** (`$MasterLLMConfig`): Central coordinator interfacing with users
- **Slave LLMs**: Specialized models for domain-specific tasks
- **LLMGraph Orchestration**: Manages parallel execution and conditional logic
- **Tools Integration**: Access to Wolfram computational functions
- **Memory Management**: Conversation history and context retention

### Key Functions by Implementation Step

**Step 1 - Web Infrastructure**:
- `CreateWebInterface[]`: FormPage with multi-modal inputs
- `ProcessUserInput[data]`: Form data processing with validation
- `DeployApp[]`: Wolfram Cloud deployment

**Step 2 - LLM Integration**:
- `InitializeMasterLLM[]`: LLM configuration and testing
- `CreateLLMPrompt[inputData]`: Multi-modal prompt construction
- `ProcessTextWithLLM[inputData]`: LLM processing with error handling
- `FormatLLMResponse[response]`: Response formatting for web display

**Step 3 - Image Processing**:
- `ProcessImageInput[image]`: Comprehensive image analysis with OCR and object recognition
- `ExtractTextFromImage[image]`: OCR text extraction using TextRecognize
- `IdentifyImageObjects[image]`: Object identification using ImageIdentify

**Step 4 - Audio Processing**:
- `ProcessAudioInput[audio]`: Comprehensive audio analysis with speech-to-text and metadata
- `TranscribeAudioToText[audio]`: Speech-to-text conversion using SpeechRecognize
- `ExtractAudioMetadata[audio]`: Audio properties extraction (duration, sample rate, channels)

**Step 5 - Video Processing**:
- `ProcessVideoInput[video]`: Comprehensive video analysis with transcription and frame analysis
- `TranscribeVideoToText[video]`: Video audio transcription (framework ready for advanced libraries)
- `ExtractVideoMetadata[video]`: Video properties extraction (size, duration, dimensions, format)
- `AnalyzeVideoFrames[video]`: Key frame analysis and scene description (framework ready)

**Step 6 - Web Content Processing**:
- `ProcessWebpageInput[url]`: Comprehensive webpage analysis with content extraction and parsing
- `FetchWebpageContent[url]`: Webpage content fetching with timeout protection
- `ParseHTMLContent[html]`: HTML parsing and text extraction with title and metadata
- `ValidateURL[url]`: URL format validation and accessibility checking

**Step 7 - Keyboard/Mouse Event Processing**:
- `ProcessEventInput[eventData]`: Comprehensive event analysis with keyboard and mouse pattern recognition
- `ParseKeyboardEvents[eventText]`: Keyboard event parsing from text descriptions
- `ParseMouseEvents[eventText]`: Mouse event parsing and interaction tracking
- `AnalyzeEventPatterns[events]`: User interaction pattern analysis and complexity assessment

**Step 8 - Advanced LLM Architecture (Master-Slave Setup)**:
- `InitializeLLMHierarchy[]`: Initialize Master-Slave LLM architecture with specialized roles
- `CreateSpecializedSlaves[]`: Create specialized slave LLMs for different domains (text, image, audio, video, web, event)
- `BuildLLMGraph[inputData]`: Build LLMGraph for orchestrated multi-modal processing
- `DelegateTasks[tasks]`: Delegate tasks to appropriate specialized slave LLMs
- `ProcessWithLLMGraph[inputData]`: Process input through complete LLMGraph hierarchy
- `CoordinateSlaveResponses[responses]`: Coordinate and synthesize responses from multiple slave LLMs

**Future Steps**:
- Steps 9-12: LLMGraph tools integration, memory management, RAG implementation
- Steps 13-16: Advanced features (async processing, modularity, error handling, security)
- Steps 17-20: Testing and optimization

## Testing Strategy

### Test Structure
Each step has comprehensive tests covering:
- **Unit Tests**: Individual function validation
- **Integration Tests**: Component interaction verification
- **User Acceptance Tests**: End-to-end functionality
- **Error Handling**: Service unavailability scenarios

### Test Execution Pattern
```mathematica
(* All step tests follow this pattern *)
testResults = {TestFunction1[], TestFunction2[], ...};
allPassed = And @@ testResults;
```

### Current Test Coverage

**Step 1 Tests** (`Step1Test`):
- Web interface creation
- Input processing validation
- Deployment readiness
- Multi-modal input handling

**Step 2 Tests** (`Step2Test`):
- LLM initialization
- Prompt creation
- Text processing analysis
- LLM-form integration
- Response formatting
- Multi-modal prompt generation
- Empty input handling

**Step 3 Tests** (`Step3Test`):
- Image OCR text extraction
- Object recognition
- Comprehensive image processing
- Image-LLM integration
- Display formatting
- Empty image handling
- Error handling

**Step 4 Tests** (`Step4Test`):
- Audio metadata extraction
- Speech-to-text transcription
- Comprehensive audio processing
- Audio-LLM integration
- Display formatting
- Empty audio handling
- Error handling
- Multi-modal audio integration

**Step 5 Tests** (`Step5Test`):
- Video metadata extraction
- Video transcription framework
- Video frame analysis framework
- Comprehensive video processing
- Video-LLM integration
- Display formatting
- Empty video handling
- Error handling

**Step 6 Tests** (`Step6Test`):
- URL validation and format checking
- Webpage content fetching
- HTML content parsing and text extraction
- Comprehensive webpage processing
- Webpage-LLM integration
- Display formatting
- Empty URL handling
- Error handling

**Step 7 Tests** (`Step7Test`):
- Keyboard event parsing and analysis
- Mouse event parsing and interaction tracking
- User interaction pattern recognition
- Event complexity assessment
- Event-LLM integration
- Display formatting
- Empty event handling
- Error handling

**Step 8 Tests** (`Step8Test`):
- LLM hierarchy initialization
- Specialized slave LLM creation (text, image, audio, video, web, event slaves)
- LLMGraph construction and orchestration
- Task delegation to appropriate slaves
- LLMGraph processing framework
- Slave response coordination and synthesis
- Hierarchical integration with multi-modal pipeline
- Advanced error handling across LLM architecture

## Implementation Notes

### Package Loading Pattern
```mathematica
BeginPackage["PackageName`"];
(* Usage declarations *)
Begin["`Private`"];
(* Implementation *)
End[];
EndPackage[];
```

### Error Handling Strategy
- LLM service failures gracefully handled with fallback messages
- Test functions use `Catch[..., _, $Failed]` pattern
- All functions include validation and meaningful error output

### Deployment Considerations
- Uses `FormPage` for web interface generation
- `CloudDeploy` with public permissions for web access
- LLM configuration supports both Wolfram and external models
- File uploads supported for images, audio, video formats

### Development Progress Tracking
- Each step must pass all tests before advancement
- Git commits required after successful step completion
- Step runners provide clear status feedback and next steps
- Progress tracked through validation reports

## Current Status

✅ **Step 1**: Basic Web App Infrastructure - Complete
✅ **Step 2**: Text Processing & Master LLM Integration - Complete  
✅ **Step 3**: Image Processing with OCR & Object Recognition - Complete
✅ **Step 4**: Audio Processing with Speech-to-Text - Complete
✅ **Step 5**: Video Processing with Transcription & Frame Analysis - Complete
✅ **Step 6**: Web Content Processing & Scraping - Complete
✅ **Step 7**: Keyboard/Mouse Event Processing - Complete
🔄 **Step 8**: Advanced LLM Architecture (Master-Slave Setup) - Current

The system now handles all major multi-modal inputs (text, image, audio, video, web content, and user events) through a comprehensive web interface with testing infrastructure. Step 8 introduces advanced LLM architecture with Master-Slave hierarchy using LLMGraph orchestration for specialized domain processing. Steps 9-20 will add tools integration, memory management, RAG, async processing, security, and optimization.