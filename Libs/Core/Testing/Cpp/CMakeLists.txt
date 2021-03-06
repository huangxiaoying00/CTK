# Dummy plugin used by ctkAbstractPluginFactoryTest1
add_definitions( -DCTKDummyPlugin)

ctkMacroBuildLib(
  NAME "CTKDummyPlugin"
  EXPORT_DIRECTIVE "CTK_DUMMY_EXPORT"
  SRCS ctkDummyPlugin.h ctkDummyPlugin.cpp
  MOC_SRCS "ctkDummyPlugin.h"
  TARGET_LIBRARIES ${CTK_BASE_LIBRARIES}
  LIBRARY_TYPE "SHARED"
  )
get_target_property(ctkDummyPluginPATH "CTKDummyPlugin" LOCATION)
remove_definitions(-DCTKDummyPlugin)

set(KIT ${PROJECT_NAME})

#
# Test sources
#
set(KITTests_SRCS
  ctkAbstractFactoryTest1.cpp
  ctkAbstractLibraryFactoryTest1.cpp
  ctkAbstractObjectFactoryTest1.cpp
  ctkAbstractPluginFactoryTest1.cpp
  ctkAbstractQObjectFactoryTest1.cpp
  ctkBackTraceTest.cpp
  ctkBooleanMapperTest.cpp
  ctkCallbackTest1.cpp
  ctkCheckableModelHelperTest1.cpp
  ctkCommandLineParserTest1.cpp
  ctkErrorLogModelTest1.cpp
  ctkErrorLogModelEntryGroupingTest1.cpp
  ctkErrorLogModelTerminalOutputTest1.cpp
  ctkErrorLogModelTest4.cpp
  ctkErrorLogFDMessageHandlerWithThreadsTest1.cpp
  ctkErrorLogQtMessageHandlerWithThreadsTest1.cpp
  ctkErrorLogStreamMessageHandlerWithThreadsTest1.cpp
  ctkExceptionTest.cpp
  ctkHighPrecisionTimerTest.cpp
  ctkHistogramTest1.cpp
  ctkLinearValueProxyTest.cpp
  ctkLoggerTest1.cpp
  ctkModelTesterTest1.cpp
  ctkModelTesterTest2.cpp
  ctkUtilsCopyDirRecursivelyTest1.cpp
  ctkUtilsQtHandleToStringTest1.cpp
  ctkUtilsTest.cpp
  ctkUtilsTest1.cpp
  ctkUtilsTest2.cpp
  ctkUtilsTest3.cpp
  ctkUtilsTest4.cpp
  ctkDependencyGraphTest1.cpp
  ctkDependencyGraphTest2.cpp
  ctkPimplTest1.cpp
  ctkScopedCurrentDirTest1.cpp
  ctkSingletonTest1.cpp
  ctkTransferFunctionTest1.cpp
  ctkTransferFunctionRepresentationTest1.cpp
  ctkTransferFunctionRepresentationTest2.cpp
  ctkWorkflowTest1.cpp
  ctkWorkflowTest2.cpp
  ctkWorkflowTest3.cpp
  )

if(HAVE_BFD)
  list(APPEND KITTests_SRCS
    ctkBinaryFileDescriptorTest1.cpp
    )
endif()

include_directories(
  ${CMAKE_SOURCE_DIR}/Libs/Testing
  ${CMAKE_CURRENT_BINARY_DIR}
  )

create_test_sourcelist(Tests ${KIT}CppTests.cpp
  ${KITTests_SRCS}
  #EXTRA_INCLUDE TestingMacros.h
  )

set(TestsToRun ${Tests})
remove(TestsToRun ${KIT}CppTests.cpp)

set(LIBRARY_NAME ${PROJECT_NAME})

#
# Tests Helpers sources
#
set(Tests_Helpers_SRCS
  ctkBranchingWorkflowStep.h
  ctkExampleDerivedWorkflowStep.cpp
  ctkExampleDerivedWorkflowStep.h
  ctkExampleWorkflowStepUsingSignalsAndSlots.cpp
  ctkExampleWorkflowStepUsingSignalsAndSlots.h
  ctkSingletonTestHelper.cpp
  ctkSingletonTestHelper.h
  )

set(Tests_Helpers_MOC_SRCS
  ctkExampleWorkflowStepUsingSignalsAndSlots.h
  )

set(Tests_Helpers_MOC_CPP)
QT4_WRAP_CPP(Tests_Helpers_MOC_CPP ${Tests_Helpers_MOC_SRCS})
QT4_GENERATE_MOCS(
  ctkBooleanMapperTest.cpp
  ctkLinearValueProxyTest.cpp
  ctkUtilsTest.cpp
  )

if(HAVE_BFD)
  add_executable(ctkBinaryFileDescriptorTestHelper ctkBinaryFileDescriptorTestHelper.cpp)
endif()

if(WIN32)
  add_definitions( /D _CRT_SECURE_NO_WARNINGS)
endif()

#
# Test executable
#
add_executable(${KIT}CppTests ${Tests} ${Tests_Helpers_SRCS} ${Tests_Helpers_MOC_CPP})
target_link_libraries(${KIT}CppTests ${LIBRARY_NAME} ${CTK_BASE_LIBRARIES} CTKDummyPlugin)

if(UNIX AND NOT APPLE)
  target_link_libraries(${KIT}CppTests rt)
endif()


#
# Add Tests
#

SIMPLE_TEST( ctkAbstractFactoryTest1 )
SIMPLE_TEST( ctkAbstractLibraryFactoryTest1 ${ctkDummyPluginPATH} )
SIMPLE_TEST( ctkAbstractObjectFactoryTest1 )
SIMPLE_TEST( ctkAbstractPluginFactoryTest1 ${ctkDummyPluginPATH} )
SIMPLE_TEST( ctkAbstractQObjectFactoryTest1 )
SIMPLE_TEST( ctkBackTraceTest )
if(HAVE_BFD)
  SIMPLE_TEST( ctkBinaryFileDescriptorTest1 $<TARGET_FILE:ctkBinaryFileDescriptorTestHelper> )
endif()
SIMPLE_TEST( ctkBooleanMapperTest )
SIMPLE_TEST( ctkCallbackTest1 )
SIMPLE_TEST( ctkCheckableModelHelperTest1 )
SIMPLE_TEST( ctkCommandLineParserTest1 )
SIMPLE_TEST( ctkDependencyGraphTest1 )
SIMPLE_TEST( ctkDependencyGraphTest2 )
SIMPLE_TEST( ctkErrorLogModelTest1 )
SIMPLE_TEST( ctkErrorLogModelEntryGroupingTest1 )
SIMPLE_TEST( ctkErrorLogModelTerminalOutputTest1 --test-launcher $<TARGET_FILE:${KIT}CppTests>)
SIMPLE_TEST( ctkErrorLogModelTest4 )
SIMPLE_TEST( ctkErrorLogFDMessageHandlerWithThreadsTest1 )
SIMPLE_TEST( ctkErrorLogQtMessageHandlerWithThreadsTest1 )
SIMPLE_TEST( ctkErrorLogStreamMessageHandlerWithThreadsTest1 )
SIMPLE_TEST( ctkExceptionTest )
SIMPLE_TEST( ctkHighPrecisionTimerTest )
SIMPLE_TEST( ctkHistogramTest1 )
SIMPLE_TEST( ctkLinearValueProxyTest )
SIMPLE_TEST( ctkLoggerTest1 )
set_property(TEST ctkLoggerTest1 PROPERTY PASS_REGULAR_EXPRESSION "logger.debug\nlogger.info\nlogger.trace\nlogger.warn\nlogger.error\nlogger.fatal")
SIMPLE_TEST( ctkModelTesterTest1 )
SIMPLE_TEST( ctkModelTesterTest2 )
SIMPLE_TEST( ctkPimplTest1 )
SIMPLE_TEST( ctkScopedCurrentDirTest1 )
SIMPLE_TEST( ctkSingletonTest1 )
SIMPLE_TEST( ctkTransferFunctionTest1 )
SIMPLE_TEST( ctkTransferFunctionRepresentationTest1 )
SIMPLE_TEST( ctkTransferFunctionRepresentationTest2 )
SIMPLE_TEST( ctkUtilsCopyDirRecursivelyTest1 )
SIMPLE_TEST( ctkUtilsQtHandleToStringTest1 )
SIMPLE_TEST( ctkUtilsTest )
SIMPLE_TEST( ctkUtilsTest1 )
SIMPLE_TEST( ctkUtilsTest2 )
SIMPLE_TEST( ctkUtilsTest3 )
SIMPLE_TEST( ctkUtilsTest4 )
SIMPLE_TEST( ctkWorkflowTest1 )
SIMPLE_TEST( ctkWorkflowTest2 )
SIMPLE_TEST( ctkWorkflowTest3 )
