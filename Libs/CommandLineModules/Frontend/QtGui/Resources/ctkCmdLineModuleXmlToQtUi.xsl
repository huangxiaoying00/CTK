<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
  xmlns:err="http://www.w3.org/2005/xqt-errors"
  xmlns:ctk="http://www.commontk.org"
  exclude-result-prefixes="xs xdt err fn">

  <xsl:output method="xml" indent="yes"/>
  
   <!--
  ===================================================================
    Defaults for XSL parameter bindings
  ===================================================================
  -->
  
  <!--
  ########################################################################
  ****************************   IMPORTANT   *****************************
  *                                                                      *
  * Please update the documentation in ctkCmdLineModuleFrontendQtGui.h   *
  * when making changes to (or adding/removing) XSL parameters (names    *
  * or default values)                                                   *
  *                                                                      *
  ########################################################################
  -->
  
  <xsl:param name="disableReturnParameter">true</xsl:param>
  
  <xsl:param name="executableWidget">QWidget</xsl:param>
  <xsl:param name="parametersWidget">ctkCollapsibleGroupBox</xsl:param>
  <xsl:param name="booleanWidget">QCheckBox</xsl:param>
  <xsl:param name="integerWidget">QSpinBox</xsl:param>
  <xsl:param name="floatingWidget">QDoubleSpinBox</xsl:param>
  <xsl:param name="vectorWidget">QLineEdit</xsl:param>
  <xsl:param name="enumWidget">QComboBox</xsl:param>
  <xsl:param name="imageInputWidget">ctkPathLineEdit</xsl:param>
  <xsl:param name="imageOutputWidget">ctkPathLineEdit</xsl:param>
  <xsl:param name="fileInputWidget">ctkPathLineEdit</xsl:param>
  <xsl:param name="fileOutputWidget">ctkPathLineEdit</xsl:param>
  <xsl:param name="directoryWidget">ctkPathLineEdit</xsl:param>
  <xsl:param name="pointWidget">ctkCoordinatesWidget</xsl:param>
  <xsl:param name="unsupportedWidget">QLabel</xsl:param>
    
  <xsl:param name="booleanValueProperty">checked</xsl:param>
  <xsl:param name="integerValueProperty">value</xsl:param>
  <xsl:param name="floatValueProperty">value</xsl:param>
  <xsl:param name="pointValueProperty">coordinates</xsl:param>
  <xsl:param name="regionValueProperty">coordinates</xsl:param>
  <xsl:param name="imageValueProperty">currentPath</xsl:param>
  <xsl:param name="fileValueProperty">currentPath</xsl:param>
  <xsl:param name="directoryValueProperty">currentPath</xsl:param>
  <xsl:param name="geometryValueProperty">currentPath</xsl:param>
  <xsl:param name="vectorValueProperty">text</xsl:param>
  <xsl:param name="enumerationValueProperty">currentEnumeration</xsl:param>

  
  <!--
  ===================================================================
    Utility XSLT 2.0 functions
  ===================================================================
  -->

  <!-- Map xml parameter element names (types) to the proper QtDesigner UI element. -->
  <xsl:function name="ctk:mapTypeToQtDesigner">
    <xsl:param name="cliType"/>
    <xsl:choose>
      <xsl:when test="$cliType='boolean'">bool</xsl:when>
      <xsl:when test="$cliType='integer'">number</xsl:when>
      <xsl:when test="$cliType='float'">double</xsl:when>
      <xsl:when test="$cliType=('point', 'region', 'image', 'file', 'directory', 'geometry', 'integer-vector', 'double-vector', 'float-vector', 'string-vector', 'integer-enumeration', 'double-enumeration', 'float-enumeration', 'string-enumeration')">string</xsl:when>
      <xsl:otherwise><xsl:value-of select="$cliType"/></xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- Map xml parameter element names (types) to the Qt widget property containing
       the current value. The property value type should match the (Qt) C++ type
       (or be convertible to it). -->
  <xsl:function name="ctk:mapTypeToQtValueProperty">
    <xsl:param name="cliType"/>
    <xsl:choose>
      <xsl:when test="$cliType='boolean'"><xsl:value-of select="$booleanValueProperty"/></xsl:when>
      <xsl:when test="$cliType='integer'"><xsl:value-of select="$integerValueProperty"/></xsl:when>
      <xsl:when test="$cliType='float'"><xsl:value-of select="$floatValueProperty"/></xsl:when>
      <xsl:when test="$cliType='double'"><xsl:value-of select="$floatValueProperty"/></xsl:when>
      <xsl:when test="$cliType='point'"><xsl:value-of select="$pointValueProperty"/></xsl:when>
      <xsl:when test="$cliType='region'"><xsl:value-of select="$regionValueProperty"/></xsl:when>
      <xsl:when test="$cliType='image'"><xsl:value-of select="$imageValueProperty"/></xsl:when>
      <xsl:when test="$cliType='file'"><xsl:value-of select="$fileValueProperty"/></xsl:when>
      <xsl:when test="$cliType='directory'"><xsl:value-of select="$directoryValueProperty"/></xsl:when>
      <xsl:when test="$cliType='geometry'"><xsl:value-of select="$geometryValueProperty"/></xsl:when>
      <xsl:when test="$cliType='integer-vector'"><xsl:value-of select="$vectorValueProperty"/></xsl:when>
      <xsl:when test="$cliType='double-vector'"><xsl:value-of select="$vectorValueProperty"/></xsl:when>
      <xsl:when test="$cliType='float-vector'"><xsl:value-of select="$vectorValueProperty"/></xsl:when>
      <xsl:when test="$cliType='string-vector'"><xsl:value-of select="$vectorValueProperty"/></xsl:when>
      <xsl:when test="$cliType='integer-enumeration'"><xsl:value-of select="$enumerationValueProperty"/></xsl:when>
      <xsl:when test="$cliType='double-enumeration'"><xsl:value-of select="$enumerationValueProperty"/></xsl:when>
      <xsl:when test="$cliType='float-enumeration'"><xsl:value-of select="$enumerationValueProperty"/></xsl:when>
      <xsl:when test="$cliType='string-enumeration'"><xsl:value-of select="$enumerationValueProperty"/></xsl:when>
      <xsl:otherwise>value</xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--
  ===================================================================
    Default templates for suppressing output if no more specific template exists
  ===================================================================
  -->

  <!-- suppress text and attribute nodes not covered in subsequent template rule -->
  <xsl:template match="text()|@*"/>
  
  <!-- suppress elements not covered in "connections" mode -->
  <xsl:template match="*" mode="connections"/>

  <!-- suppress elements not covered in "signals" mode -->
  <xsl:template match="*" mode="signals"/>

  <!--
  ===================================================================
    Utility templates
  ===================================================================
  -->

  <xsl:template match="parameters/label">
    <property name="title">
      <string><xsl:value-of select="text()"/></string>
    </property>
  </xsl:template>

  <!-- Add a tooltip property to a widget -->
  <xsl:template match="description">
    <property name="toolTip">
      <string><xsl:value-of select="text()"/></string>
    </property>
  </xsl:template>

  <!-- Set the default value by generating a Qt widget specific property which holds
       the current value -->
  <xsl:template match="default">
    <property name="{ctk:mapTypeToQtValueProperty(name(..))}">
      <xsl:element name="{ctk:mapTypeToQtDesigner(name(..))}"><xsl:value-of select="text()"/></xsl:element>
    </property>
  </xsl:template>

  <!-- Set Qt widget (spinbox) specific properties for applying constraints of scalar parameters -->
  <xsl:template match="constraints/*[name()=('minimum','maximum')]">
    <property name="{name()}">
      <xsl:element name="{ctk:mapTypeToQtDesigner(name(../..))}"><xsl:value-of select="text()"/></xsl:element>
    </property>
  </xsl:template>
  <xsl:template match="constraints/step">
    <property name="singleStep">
      <xsl:element name="{ctk:mapTypeToQtDesigner(name(../..))}"><xsl:value-of select="text()"/></xsl:element>
    </property>
  </xsl:template>

  <!-- A named template which will be called from each parameter (integer, float, image, etc.) element.
       It assumes that it will be called from an enclosing Qt grid layout element and adds a label item -->
  <xsl:template name="gridItemWithLabel">
    <item  row="{position()-1}" column="0">
      <widget class="QLabel">
        <property name="sizePolicy">
          <sizepolicy hsizetype="Fixed" vsizetype="Preferred">
            <horstretch>0</horstretch>
            <verstretch>0</verstretch>
          </sizepolicy>
        </property>
        <property name="text">
          <string><xsl:value-of select="./label"/></string>
        </property>
      </widget>
    </item>
  </xsl:template>

  <!-- A named template for adding properties common to all Qt widgets -->
  <xsl:template name="commonWidgetProperties">
    <xsl:apply-templates select="description"/> <!-- tooltip -->
    <xsl:if test="@hidden='true'"> <!-- widget visibility -->
      <property  name="visible">
        <bool>false</bool>
      </property>
    </xsl:if>
    <!-- disable simple return parameter -->
    <xsl:if test="index/text()='1000' and channel/text()='output' and $disableReturnParameter='true'">
      <property name="enabled">
        <bool>false</bool>
      </property>
    </xsl:if>
    <property name="parameter:valueProperty"> <!-- property name containing current value -->
      <string><xsl:value-of select="ctk:mapTypeToQtValueProperty(name())"/></string>
    </property>

    <!-- add additional (optional) information as properties -->
    <xsl:apply-templates select="default"/>
    <xsl:apply-templates select="constraints"/>
  </xsl:template>
  
  <!-- A named template for creating a QtDesigner stringlist property -->
  <xsl:template name="createQtDesignerStringListProperty">
    <property name="nameFilters">
      <stringlist>
      <xsl:for-each select="tokenize(@fileExtensions, ',')">
        <string><xsl:value-of select="normalize-space(.)"/></string>
      </xsl:for-each>
      </stringlist>
    </property>
  </xsl:template>

  <!--
  ===================================================================
    Match elements from the XML description
  ===================================================================
  -->
  <!-- start matching at 'executable' element -->
  <xsl:template match="/executable">
    <xsl:variable name="moduleTitle"><xsl:value-of select="title"/></xsl:variable>
    <ui version="4.0" >
      <class><xsl:value-of select="translate(normalize-space($moduleTitle), ' ', '')"/></class>
      <widget class="{$executableWidget}" name="executable:{normalize-space($moduleTitle)}">
        <layout class="QVBoxLayout">

          <!-- This will generate QGroupBox items with the specific widgets -->
          <xsl:apply-templates select="parameters"/>

          <!-- Add a spacer at the bottom -->
          <item>
            <spacer name="verticalSpacer">
              <property name="orientation">
                <enum>Qt::Vertical</enum>
              </property>
            </spacer>
          </item>
        </layout>
      </widget>
      <connections>
        <xsl:apply-templates mode="connections" select="parameters/*"/>
      </connections>
    </ui>
  </xsl:template>

  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Parameters (default: ctkCollapsibleGroupBox)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->
  <!-- Match the 'parameters' element and create the parameter groups (QGroupBox) -->
  <xsl:template match="parameters">
    <xsl:variable name="groupLabel"><xsl:value-of select="label"/></xsl:variable>
    <item>
      <widget class="{$parametersWidget}" name="paramGroup:{$groupLabel}">
        <xsl:apply-templates select="./label"/>
        <xsl:apply-templates select="./description"/>
        <property name="checked">
          <bool><xsl:value-of select="not(@advanced)"></xsl:value-of></bool>
        </property>
        <layout class="QVBoxLayout" name="paramContainerLayout:{$groupLabel}">
          <item>
            <widget class="QWidget" name="paramContainer:{$groupLabel}">
              <layout class="QGridLayout">
                <xsl:apply-templates select="./description/following-sibling::*"/>
              </layout>            
            </widget>
          </item>
        </layout>
      </widget>
    </item>
  </xsl:template>

  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    BOOLEAN parameter (default: QCheckbox)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/boolean">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$booleanWidget}"  name="parameter:{name}">
        <xsl:call-template name="commonWidgetProperties"/>
        <property name="text">
         <string/>
        </property>
      </widget>
    </item>
  </xsl:template>

  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INTEGER parameter (default: QSpinBox)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/integer">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$integerWidget}"  name="parameter:{name}">
        <xsl:if test="not(constraints)">
          <property name="minimum">
            <number>-999999999</number>
          </property>
          <property name="maximum">
            <number>999999999</number>
          </property>
        </xsl:if>
        <xsl:call-template name="commonWidgetProperties"/>
      </widget>
    </item>
  </xsl:template>

  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DOUBLE, FLOAT parameter (default: QDoubleSpinBox)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/*[name()=('double','float')]">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$floatingWidget}"  name="parameter:{name}">
        <property name="decimals">
          <number>6</number>
        </property>
        <xsl:if test="not(constraints)">
          <property name="minimum">
            <double>-999999999</double>
          </property>
          <property name="maximum">
            <double>999999999</double>
          </property>
        </xsl:if>
        <xsl:call-template name="commonWidgetProperties"/>
      </widget>
    </item>
  </xsl:template>
  
  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    STRING, INTEGER-VECTOR, DOUBLE-VECTOR, FLOAT-VECTOR, STRING-VECTOR parameter (default: QLineEdit)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/*[name()=('string', 'integer-vector', 'float-vector', 'double-vector', 'string-vector')]">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$vectorWidget}"  name="parameter:{name}">
        <xsl:call-template name="commonWidgetProperties"/>
      </widget>
    </item>
  </xsl:template>
  
  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    INTEGER-ENUMERATION, DOUBLE-ENUMERATION, FLOAT-ENUMERATION, STRING-ENUMERATION parameter (default: QComboBox)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/*[name()=('integer-enumeration', 'float-enumeration', 'double-enumeration', 'string-enumeration')]">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$enumWidget}"  name="parameter:{name}">
        <xsl:call-template name="commonWidgetProperties"/>
        <xsl:for-each select="element">
          <item>
            <property name="text">
              <string><xsl:value-of select="text()"/></string>
            </property>
          </item>
        </xsl:for-each>
      </widget>
    </item>
  </xsl:template>
  
  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMAGE parameter (default: ctkPathLineEdit)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/*[name()=('image')]">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <xsl:choose>
        <xsl:when test="channel = 'input'">
          <widget class="{$imageInputWidget}"  name="parameter:{name}">
            <xsl:call-template name="commonWidgetProperties"/>
            <xsl:call-template name="createQtDesignerStringListProperty"/>
            <property name="filters">
              <set>ctkPathLineEdit::Files,ctkPathLineEdit::Readable</set>
            </property>
          </widget>
        </xsl:when>
        <xsl:otherwise>
          <widget class="{$imageOutputWidget}"  name="parameter:{name}">
            <xsl:call-template name="commonWidgetProperties"/>
            <xsl:call-template name="createQtDesignerStringListProperty"/>
            <property name="filters">
              <set>ctkPathLineEdit::Files,ctkPathLineEdit::Writable</set>
            </property>
          </widget>
        </xsl:otherwise>
      </xsl:choose>
    </item>
  </xsl:template>

  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    FILE, GEOMETRY parameter (default: ctkPathLineEdit)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/*[name()=('file', 'geometry')]">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <xsl:choose>
        <xsl:when test="channel = 'input'">
          <widget class="{$fileInputWidget}"  name="parameter:{name}">
            <xsl:call-template name="commonWidgetProperties"/>
            <xsl:call-template name="createQtDesignerStringListProperty"/>
            <property name="filters">
              <set>ctkPathLineEdit::Files,ctkPathLineEdit::Readable</set>
            </property>
          </widget>
        </xsl:when>
        <xsl:otherwise>
          <widget class="{$fileOutputWidget}"  name="parameter:{name}">
            <xsl:call-template name="commonWidgetProperties"/>
            <xsl:call-template name="createQtDesignerStringListProperty"/>
            <property name="filters">
              <set>ctkPathLineEdit::Files,ctkPathLineEdit::Writable</set>
            </property>
          </widget>
        </xsl:otherwise>
      </xsl:choose>
    </item>
  </xsl:template>

  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DIRECTORY parameter (default: ctkPathLineEdit)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/directory">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$directoryWidget}"  name="parameter:{name}">
        <xsl:call-template name="commonWidgetProperties"/>
        <property name="filters">
          <set>ctkPathLineEdit::Dirs</set>
        </property>
      </widget>
    </item>
  </xsl:template>
  
  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    POINT, REGION parameter (default: ctkCoordinatesWidget)
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->

  <xsl:template match="parameters/*[name()=('point', 'region')]">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$pointWidget}"  name="parameter:{name}">
        <xsl:call-template name="commonWidgetProperties"/>
      </widget>
    </item>
  </xsl:template>
  
  <!--
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NOT IMPLEMENTED YET
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  -->
  
  <xsl:template match="parameters/*" priority="-1">
    <xsl:call-template name="gridItemWithLabel"/>
    <item  row="{position()-1}" column="1">
      <widget class="{$unsupportedWidget}"  name="{name}">
        <property name="text">
          <string>&lt;html&gt;&lt;head&gt;&lt;meta name="qrichtext" content="1" /&gt;&lt;style type="text/css"&gt;p, li { white-space: pre-wrap; }&lt;/style&gt;&lt;/head&gt;&lt;body&gt;&lt;p style="margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"&gt;&lt;span style=" color:#ff0000;">Element '<xsl:value-of select="name()"/>' not supported yet.&lt;/span&gt;&lt;/p&gt;&lt;/body&gt;&lt;/html&gt;</string>
        </property>
        <property name="textFormat">
         <enum>Qt::RichText</enum>
        </property>
      </widget>
    </item>
  </xsl:template>

  <!-- EXTRA TRANSFORMATIONS -->

</xsl:stylesheet>
