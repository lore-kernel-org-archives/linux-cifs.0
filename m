Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045D4C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 20:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB94E60F6B
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 20:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhIUUfp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 16:35:45 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30370 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234906AbhIUUfo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 16:35:44 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LJlL6V031162;
        Tue, 21 Sep 2021 20:33:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=K/sD2odGUF5+kewVlMu+VqsNY7yYT+Deof3trgpNscE=;
 b=WWLdFOex2YfDVc60BG5lcDYdU3VWrs3GXN15T2DzypnDph+eit0OJvKyrN2a7g+iF+33
 8Cn21gTiUPRcvaGVzZcagKkAm25dvEW6Q1O0cyuEzhdZPiXYqKdsiv07AUo+8o3sn73G
 Zd9pHgSHSA/0K8FhQIiBUvVi9Mp7OlEX7DpwlUXwONcqTI6eMnMBhW12ztntbc6wVJWc
 Ax59BmRIEtdRKI6ygb/2VYXe9ePJm1UDRRZb2ThaqkwE/725ohR6UOyR16Hfv/+3ewf4
 tonbsrsgDPQl3zoOaLJjlN7qVCqfhbf/BpLmcMpIFf8NkI6wcrPAdY8iumoGKf+SHgGH rw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b783evh3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 20:33:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18LKUxeQ061951;
        Tue, 21 Sep 2021 20:33:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3030.oracle.com with ESMTP id 3b565emc4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 20:33:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9WIKDXWcSycVpveLPtmuCeURNtqQxVCkpmuK+h4a2nYkaFVd/sNjyl4JuJujIb0XGSfOnriZ3eRxWxNaGByckKDOlMnUQFA86+kC/qvLFvVrmu5ZtJSJJ/PAEFWaH0jVWBnak078DabZOae3VDkMVrEiuqxo1etjRzB1OWxadsF8zACPzWUGOIsBC6mLyahxKZcYrURJrTkPPy3xUTGWt2qyTnDfu9FDM87//0AgJ42mMbB/V0N+zUDDUQc1jEeI71SGsi2tN4PUg7trp0TPfVcQXHaTYMrZP6KoIsR6c4Rjq1868kaYoZDDYdtOO3dgiBRQry4Md/THWN9iqHrRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=K/sD2odGUF5+kewVlMu+VqsNY7yYT+Deof3trgpNscE=;
 b=lZHBPamDpfmahuWlwZVIEqEz9xucu2tR2d3LuoP/vIZY9TvO675IRLt9QIDhFgK3nnZA6CbeR6AJ/e3aVg5Sohe0lLdU9JjNHXPFgVd+na5XFFUgAA7A+F9hYx9H8Rqj2suic1MyX4LzmAtd8i4ZV0PSYKZ6XV4kjhLah30KGxZNTedJP+j5vo3arxksKIgqikH+PD6kqNX9rQaH6/T2hCQ9RGhJRLNuHntWg+ewCkZ0aELKXZnxw9YxR4A0u6JOIUFHZYUYZQnHJ/4ipyOx8pI/BDy7cZiaLoiWjKPjSIgNwgIik+EdddgokLHNT2hcnCIAP+ldsvfYc267Rxcl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K/sD2odGUF5+kewVlMu+VqsNY7yYT+Deof3trgpNscE=;
 b=J7PVkfm36GoG6Y5mv0sa/IjdD6GR0M5PMZy50ak3NujB4de2zsYvyM0QsVsEeJA2Aek24H28hunOho/sL/Sh+68CykgYG8STsvhbq0D9DdF0p49VsIy+mir2DQj4HJY3yqDaDFk4cyUjo00frunIOcOSgcu8T5nKktgWhE6hNSc=
Authentication-Results: samba.org; dkim=none (message not signed)
 header.d=none;samba.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2255.namprd10.prod.outlook.com
 (2603:10b6:301:2f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Tue, 21 Sep
 2021 20:33:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 20:33:45 +0000
Date:   Tue, 21 Sep 2021 23:33:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] smbfs_client: fix a sign extension bug
Message-ID: <20210921203335.GB16529@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0083.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Tue, 21 Sep 2021 20:33:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bd9e695-a916-4665-0d0a-08d97d3f1bf9
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2255:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2255E99914792A72402B11038EA19@MWHPR1001MB2255.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tE1wdFGLft5UI5tPl+8Qva2p9yMGiaMULjgYHWkqsXVAWyqKM5cH1ijCLaUuWMgVfBS3X5wPy5UDmApeb8AHDweuR+kVFzzAFbi00xQTQzFfGmCE8ytPauYZ1h1BJNJXLU4UDvTe1Zuu4Ma7IFJol5DxQFVYoSdSK/kcWMmrd3U+hhp5ek+2OvPmLbjfxdzpCutAuPB3qqJXx/9WK8JJ3L/B9pNJy+mQfJqqwM5cf2SOd9UH6zliZUYJT2K4b3NDz40Au4YN696atFmpsidg/r0C7EyIFNX2odHPJqyOz9pS25IYwzboOhRDf3Hvphf8NVMZXGt3pDyDH2uSL6aV5xaEuIJ+QW0rDdz79QFhpI79k2gZRZ7CfuWrsucNtkkGXIdca/G/6dtxELXGDMWXcccNLnxZ0pIJUGTCXsRsIafFwgwVSrrdcpantHGCFXMrAQ2xn5LjSl776iJzWFFMP6/dWdjsqHPvFGaE65F3hLdkVbay5u8StuF6aG2dfM7V8pPMPK2aHByh0paulYHjSdg4q0Tx82XxCTLuB7e7UpIbiKq0VpTi8AtZbQUYc45alvZGpJhgphgpXkGLYAjfoE/QXlye3O3RAIngG/ipKWFuVLvRlJ3xyuWbc5NL8WbiToIkf0ZhkbQamLn3vLrrzTsTIXFEbl1ThaE6RT1yAu61mUtpmJUqCvAeKD0kryVYFdCidMR5XYSrceubtQIkfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(52116002)(38100700002)(956004)(316002)(38350700002)(6496006)(26005)(66556008)(66946007)(66476007)(9686003)(2906002)(33716001)(83380400001)(86362001)(33656002)(8936002)(1076003)(9576002)(55016002)(5660300002)(186003)(6666004)(4326008)(44832011)(8676002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L+MPF7U0jQqSv0I/KBuqQdKzVrHIdHe2RKJTB6n9sLOpa1LMjOKavWl09lk7?=
 =?us-ascii?Q?rnLDxG2lsfqZ4VSLG6ZKjoNCmXWbBUESo1ti/Ume9oJFkXHuSzCX1gjVemCD?=
 =?us-ascii?Q?oEs8+nQx8CkWEQTwmdwTD2rSP9zpnJp711C+ETyf1ClBkG7IZ8bSiHwDmiib?=
 =?us-ascii?Q?rjgreTYnKDPE+fN2xvaWXJMkjWAhaEynKwhE/g6ThmKXdVFAawMQ8qX0LAzd?=
 =?us-ascii?Q?KwpcItTmRvJB50Z0B3ZAyRCUCOSbNI/GeSgzFkP5/dhGjSZZAY+1YE68UMzH?=
 =?us-ascii?Q?EOMHpm52ugJnH6ZGNf5BWwDZgAOVSESQmB6p9TH/Vj/JAB1wizzGL52oIEvu?=
 =?us-ascii?Q?FCFj2yakpJTCi5sSrwg58GKFwW10M0uAL3HrsIoxMD3jEy4+As81533qNM27?=
 =?us-ascii?Q?rPNyyL23CYU8C6USpw1/+1cV50XYhigWqCVpxCk6VB8BqkfL73a7zySm0hF4?=
 =?us-ascii?Q?0w2KbvJaTV4/yl/B5iSCv8JA6jTU1bR1xiT8DUvu0CGYP2ewsWj13yHddkhO?=
 =?us-ascii?Q?6eplnq9KYee0WPXz8tcHYUrrNCylAMc3R94/2lKBDI/cI1jnUa8wDAyFCnHx?=
 =?us-ascii?Q?JR7nQfkKfNSrbR4zSU8jd15jIV8X9iitvlbFWUwmuuarRiKe9guZtd/2MVC7?=
 =?us-ascii?Q?GFazOGYRgcVVrSrSmDb37YltSS3ohLQItletoXjn2actlbij50cTRVnOXl8W?=
 =?us-ascii?Q?batW+FR9ADCscNyMXVKfsQZwFK0+YZrYdugibCfCHrEQv5/GK7LGE4c+FjCB?=
 =?us-ascii?Q?HUXnwIMn2M5YpWvg71bj4nDyPmVwGHYwmh2N5O3y7wNVhTy0Ga0M2EaM0ueQ?=
 =?us-ascii?Q?F+deCygp0iaeaa+ujMwBV6t79ExBf8Ukb5YzA7fXSop4ntuMQzJAXM/iNY2m?=
 =?us-ascii?Q?qjImusVj2ZDhnZnCZs+bJEWNfUHIYoV3ic/q70HCEm/DndPjwoRBcFMFAXrK?=
 =?us-ascii?Q?VS2s2sOHo+4xq/2COHAdfhTmivdUthp49HvGWgnAK9nf8ODTXWcamCumymdz?=
 =?us-ascii?Q?Whg3ewFZRHp+CqGstqhY7fyN8c2lbZ81PDGX1B51WGzTlOHy+rxfQQy4t84D?=
 =?us-ascii?Q?NuBR8MrGMAhkFOk+cPArDLt7+LvWS6MWpGQW8T99sYrTsh1GHxJQ5zxw31W1?=
 =?us-ascii?Q?yMDSqG5e6ECqRjwq/0d5jZsAdbqJr6yFUd2aWpUeQBqtxqQjkgZzmNzw5O3/?=
 =?us-ascii?Q?AjALkVBlmyLddPLzxw5pWfi8W/eOWmixe5s9pj/83BSL4C7dgIdpZoImxqRy?=
 =?us-ascii?Q?D98/QYOl/lN5UIzJcaYpSI5Ymjd0At744XVeplBtZes3XKRjrLrzrIGqkT4I?=
 =?us-ascii?Q?VbWEpvkFfLiNea0vJFGdybBP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd9e695-a916-4665-0d0a-08d97d3f1bf9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 20:33:45.8052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: brlr0WJHIkzaWABGhHVS2KayktvZY+QVUc891y3rk3SpOCPRDMrNbq3GxypNuJ6I1hogd8sWqHWvqpUzU3VXDqSsSMPNFjTo85jIaLG+yv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2255
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109210121
X-Proofpoint-GUID: dHWymI3de1cCT_XDNyi9f2TlpkPmyPAx
X-Proofpoint-ORIG-GUID: dHWymI3de1cCT_XDNyi9f2TlpkPmyPAx
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The problem is the mismatched types between "ctx->total_len" which is
an unsigned int, "rc" which is an int, and "ctx->rc" which is a
ssize_t.  The code does:

	ctx->rc = (rc == 0) ? ctx->total_len : rc;

We want "ctx->rc" to store the negative "rc" error code.  But what
happens is that "rc" is type promoted to a high unsigned int and
'ctx->rc" will store the high positive value instead of a negative
value.

The fix is to change "rc" from an int to a ssize_t.

Fixes: c610c4b619e5 ("CIFS: Add asynchronous write support through kernel AIO")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/smbfs_client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smbfs_client/file.c b/fs/smbfs_client/file.c
index 4d10c9343890..7db9ddb3381f 100644
--- a/fs/smbfs_client/file.c
+++ b/fs/smbfs_client/file.c
@@ -3111,7 +3111,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct dentry *dentry = ctx->cfile->dentry;
-	int rc;
+	ssize_t rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
 	cifs_sb = CIFS_SB(dentry->d_sb);
-- 
2.20.1

