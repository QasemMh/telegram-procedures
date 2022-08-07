/*
PROCEDURE CountReportChannelReject;
PROCEDURE ReportChannelReject;
PROCEDURE CountReportChannelReject;
PROCEDURE ReportChannelReject;
PROCEDURE CountReportChannelAccept;
PROCEDURE ReportChannelAccept;
PROCEDURE FilterChannelReportByType(T_R_CH in varchar);
PROCEDURE CountReportPost;
PROCEDURE ReportPostAndInfo(P_id in int);
*/

--Create a new Package

CREATE or REPLACE PACKAGE report_channel_package IS

   PROCEDURE insert_report(p_user_id int, p_channel_id int, p_report_type varchar2,
    p_report_text varchar2,p_is_accept int);
    PROCEDURE update_report(p_rid int, p_is_accept int);
    PROCEDURE delete_report(p_rid int);
    PROCEDURE Get_All_Reports(p_limit, p_count);
    PROCEDURE Get_All_channel_Reports(p_channel_id int);
    PROCEDURE Filter_By_Type(p_type varchar2);
    PROCEDURE Count_Channel_Report(p_type varchar2);

    

END report_channel_package;



--body of the package
CREATE or REPLACE PACKAGE body  report_channel_package IS

   

END report_channel_package;
