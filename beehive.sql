-- Grouping the total number of student by tutor, status, and timestamp 
SELECT
    c1.WBT AS work_based_tutor,
    c1.COND_RAG AS condition_rag,
    COUNT(*) AS student_count,
    LAG(COUNT(*), 1) OVER (
        PARTITION BY c1.WBT, c1.COND_RAG
        ORDER BY CONVERT(DATE, '01 ' + c1.SNAPSHOT_PERIOD, 113)
    ) AS student_count_previous_month,
    c1.SNAPSHOT_PERIOD AS monthyear_name
FROM 
    USER_TAB_OWNER.UT_PEOPLE_BS_CASELOAD_RAG AS c1
LEFT OUTER JOIN (
    SELECT DISTINCT 
        WBT, 
        COND_RAG 
    FROM USER_TAB_OWNER.UT_PEOPLE_BS_CASELOAD_RAG
) AS c2 ON c1.WBT = c2.WBT AND c1.COND_RAG = c2.COND_RAG
WHERE
    c1.WBT NOT IN ('Maria Tomkinson', 'Billy Gilchrist', 'Gavin Smith', 'Terence O''Brien')
    AND c1.STATUS NOT IN ('Achiever', 'Completed', 'Withdrawn') 
GROUP BY
    c1.WBT, 
    c1.COND_RAG, 
    c1.SNAPSHOT_PERIOD;
-- Grouping the total number of students by apprenticeship standard, status and timestamp
SELECT
	REPLACE(c1.APPRENTICESHIP_STANDARD, 'Apprenticeship Standard - ', '') AS apprenticeship_standard,
	c1.COND_RAG AS condition_rag,
	COUNT(*) AS student_count,
	c1.SNAPSHOT_PERIOD AS monthyear_name
FROM
	USER_TAB_OWNER.UT_PEOPLE_BS_CASELOAD_RAG AS c1
	LEFT OUTER JOIN (
	SELECT DISTINCT
		APPRENTICESHIP_STANDARD,
		COND_RAG
	FROM
		USER_TAB_OWNER.UT_PEOPLE_BS_CASELOAD_RAG
	) AS c2 ON c1.APPRENTICESHIP_STANDARD = c2.APPRENTICESHIP_STANDARD 
	AND c1.COND_RAG = c2.COND_RAG
WHERE
	c1.WBT NOT IN ('Maria Tomkinson', 'Billy Gilchrist', 'Gavin Smith', 'Terence O''Brien')
	AND c1.STATUS NOT IN ('Achievers', 'Completed', 'Withdrawn')
GROUP BY
	c1.APPRENTICESHIP_STANDARD,
	c1.COND_RAG,
	c1.SNAPSHOT_PERIOD