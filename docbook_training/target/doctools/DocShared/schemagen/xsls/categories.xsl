<?xml version="1.0" ?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.1" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:lookup="http://www.broadjump.com/lookup">

	
<!-- 
This stylesheet is for specifying categories for database tables and for listing all the tables you wish to include in your schema reference. Tables that are not listed in this file will not appear in the generated reference. 
-->

<!-- You can have as many categories as you like. Each should follow this format:

<lookup:subject-area  name="Category One">TABLE1,
TABLE2
</lookup:subject-area>

Notice that the list of tables in each category is comma-delimited. 

IF, after you rebuild, YOU SEE ONLY ONE TABLE IN A SUBJECT AREA, you might have done a line-delimited list, in which case you only get the last table listed in the subject area.

Each category must have a unique name, and the set of tables listed in each category will be stored inside a section with a title equal to the name attribute given here.

-->
	

	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Views-category1">WEIRD,MARKEDFLOWS,CSRSESSION, CSRSESSION, DEVICEEXECUTIONPARAMETERS, NOtABLEatall, CSRSESSION, MARKEDFLOWS
	
	
	
	</lookup:subject-area>
	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Views-category2-ONE-ITEM">MARKEDFLOWS</lookup:subject-area> 
	
	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Auditing">DATASOURCEEXECPARAMETER,
        DATASOURCEEXECUTION,
	EXECUTIONAUDITCONFIGPROP,
	MODELELEMENTEXECUTION,
	OPERATIONEXECPARAMETER,
	OPERATIONEXECUTION,
	TESTMODULEEXECPARAMETER,
	TESTMODULEEXECUTION,
	WEBSERVICECALL
  </lookup:subject-area>

  <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Auto property discovery">MODEL_PROPERTY_TREE</lookup:subject-area>

	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Configuration management">MVPCONFIGACKNOWLEDGEMENT,
        MVPCONFIGURATIONLOCK,
	MVPCONFIGURATIONS,
        MVPENVIRONMENTPROPERTIES,
	MVPRESOURCELOCALES,
	MVPRESOURCES,
	SMPRESOURCES,
	SYSTEMREADONLY
  </lookup:subject-area>
  <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Core services">APPLICATIONSERVER,
        CONFIGURATIONITEM,
	DATABASETABLESPACE,
        HIBERNATE_UNIQUE_KEY,
	PARPENGINES,
        VERSION_INFO
 </lookup:subject-area>
	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Dashboard Console">APP_ALARM,
	APP_ALARM_LOG,
 	COUNTER,
    COUNTER,
	COUNTER_STATUS,
	DASHBOARD_APPSERVER,
	DASHBOARD_CONFIGURATION,
	DASHBOARD_DATA_LEVEL_ONE,
	DASHBOARD_DATA_LEVEL_TWO,
	DASHBOARD_DATA_LEVEL_ZERO,
	JOBSCHEDULER_HEARTBEAT,
        SNAPSHOT,
	SNAPSHOT_DATA,
	SNAPSHOT_JOB_LOG
 </lookup:subject-area>
 <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Endpoint operations">ASYNCOPERATIONMESSAGEARG,
	ASYNCOPERATIONRESULT,
	ENDPOINT,
	ENDPOINTMANAGEMENT,
	ENDPOINTMANAGERTYPE,
	EPATTRIBUTE,
	EPCAPABILITYGROUP,
	EPMANUFACTURER,
	EPMODEL,
	EPPLATFORM,
	PARPCONTEXTATTRIBUTES
 </lookup:subject-area>
 <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Event logging">EXTERNALEVENTDATA,
 	EVENTLOG,
 	SMPSESSION,
 	SUBSCRIBER
 </lookup:subject-area>

<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="KMP">FACTMETADATA,
        SUBJECTMETADATA,
        VALIDATED_CONTENT,
        VALIDATIONJOB_PROJECT,
        VALIDATION_ERRORS,
        VALIDATION_JOB
 </lookup:subject-area>
	
 <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Licensing">LICENSEPROPERTY
 </lookup:subject-area>
 <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Modeling">ECOACTIONPARAMETER,
	ECOBLUEPRINT,
	ECODATASOURCESIMULATION,
	ECODBPARAM,
	ECOEVALUATEDACTION,
	ECOEVALUATEDCONSTRAINT,
	ECOEVALUATEDERR,
	ECOGLOSSARY,
	ECOMODEL,
	ECOMODELHISTORY,
	ECOMODELOVERLAY,
	ECOOVERLAYEVALUATION,
	ECOOVERLAYRESULT</lookup:subject-area>
	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="MORSE">
		ACCOUNTS,
		ACCOUNT_PROPERTIES,
		ENDPOINTS,
		ENDPOINT_PROPERTIES,
		ENDPOINT_SERVICE_ACTIVATIONS,
		EP_SERVICE_ACT_PROPERTIES,
		MORSEEVENT,
		MORSEEVENTDATA,
		MORSEUSER,
		OPTIMALSETTING,
		OPTIMALSETTINGVALUE,
        SERVICES,
		SERVICE_PROPERTIES,
		SUB_OPTIMALSETTINGS,
		SUBSCRIPTIONS,
		SUBSCRIPTION_PROPERTIES,
		SUB_SERVICES,
		TENANTADMINISTRATORS,
		TENANTADMINS_PROPERTIES
	</lookup:subject-area>
	
	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Reporting">AUDITRECORDS,
		REPORT,
		REPORT_ETL_LOG,
		REPORT_ETL_TASK,
		REPORT_GROUP 
	</lookup:subject-area>
	
	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Resolution reporting">ATTRIBUTE,
		COMPONENT,
		ISESSION,
		MODEL,
		MODEL_RESOLUTION,
		MODEL_RESULT,
		RESULT
	</lookup:subject-area>
	
	
 <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="System alerts">SYSTEM_ALERT,
	SYSTEM_ALERT_DISMISSAL
 </lookup:subject-area>

	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Throttling">NBIPOLICYCONFIGURATION,
	SOUTHBOUNDTHROTTLING,
	TESTMODULEPOLICY,
	THROTTLINGENABLED,
    THROTTLINGUNIT
 </lookup:subject-area>

	<lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Workflows">CAPTURED_DICTIONARY,
	DISPLAYSTEPTRANSITIONLATENCY,	
    JBPM4_DEPLOYMENT,
	JBPM4_DEPLOYPROP,
	JBPM4_EXECUTION,
    JBPM4_HIST_ACTINST,
	JBPM4_HIST_PROCINST,
	JBPM4_LOB,
	JBPM4_PROPERTY,
	MILESTONE_EXECUTIONS,
	MILESTONE_EXECUTION_CRITERIA,
	MOTV_JBPM4_PROC_CTX,
	MOTV_JBPM4_PROC_CTX_ATTR,
    POEM_CONTENT,
    POEM_CONTENT_SVG,
    POEM_EXPORT,
	POEM_FLOW_MAPPING,
	POEM_IDENTITY,
	POEM_INTERACTION,
	POEM_REPRESENTATION,
	POEM_REPRESENTATION_LOCKS,
	POEM_SCHEMA_INFO,
	POEM_SETTING,
	POEM_STRUCTURE,
	POEM_SUBJECT,
	POEM_TAG_DEFINITION,
	POEM_TAG_RELATION,
    WORKFLOW_EXECUTIONS,
    WORKFLOW_EXEC_USER_ROLES,
    WORKFLOW_REPORT,
    WORKFLOW_REPORT_DATA,
    WORKFLOW_STEP_REPORT
</lookup:subject-area>
 <lookup:subject-area xmlns:lookup="http://www.broadjump.com/lookup" name="Reserved for future use">BUSINESS_RULES,
        JBPM4_HIST_DETAIL,
	JBPM4_HIST_TASK,
	JBPM4_HIST_VAR,
        JBPM4_ID_GROUP,
	JBPM4_ID_MEMBERSHIP,
	JBPM4_ID_USER,
        JBPM4_JOB,
	JBPM4_PARTICIPATION,
	JBPM4_SWIMLANE,
	JBPM4_TASK,
	JBPM4_VARIABLE,
	LAC_ALLOCATION,
	OPERATION_ARGUMENTS,
	POEM_COMMENT,
	POEM_FRIEND,
	POEM_MODEL_RATING,
	POEM_PLUGIN,
	PROPERTY_METADATA,
	PROPERTY_METADATA_VALUES,
    SBICONNPARAMS,
	SBIMETHODPARAMS,
	SERVICE_PROFILE_OPERATIONS,
	SERVICE_PROFILE_PROPERTIES,
	SERVICE_PROFILES,
	SERVICEPROFILEOPRUNLOG,
	SERVICEPROFILERUNLOG,
	SBIPOLICIES,
	SG_PROPERTIES,
	SUBHISTORYLOG_PROPERTIES,
	SUBRPTNS_SRVCPROFS,
	SUBSCRIPTION_DEVID_PARAMS,
	SUBSCRIPTION_DEVIDS,
	SUBSCRIPTION_GROUP,
	SUBSCRIPTION_HISTORY_LOG,
	UBS_ENTERPRISE,
	UBS_ENTERPRISE_GROUP,
	UBS_ENTERPRISE_GROUPSITE,
	WEBSERVICECALLPARAMETER
 </lookup:subject-area> 

</xsl:stylesheet>

