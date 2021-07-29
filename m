Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD05C4338F
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jul 2021 14:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA9160EB2
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Jul 2021 14:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234881AbhG2OQR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Jul 2021 10:16:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16478 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234459AbhG2OQP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 29 Jul 2021 10:16:15 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TEBMwn004061;
        Thu, 29 Jul 2021 14:15:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=W1eB7t22CELpSkU2gfjx4dmYVuFjBoAir3UDqFeeNck=;
 b=mXIadY6un0LUKosG73s1wkzdW91cNk9daXGlpxfsDJLSfkD0CyFzq0T+U8TYi+26leVu
 pLMhdJWUxlsLMhd348kGoitY5oWdlimkPBrdBAWUJUx/kcDH5rTWkEgEBPL3flCtcYJO
 pZ3TqSqI2wT7mG8vu8kqty4WblgKbXFFsDd4eBYj3P5PwHdMjq1aJVyvckf/nowlCkU3
 +CdnTr6d5l7nV6J5ooZ2GNX9Bx6yp2gpoeABlm2Us8DrbedQsTBr2S+qHZfDpkD354RF
 EGujCHo4VyYOGk4yjFcDa2AtaVTAvcgjdGCZvrg2WcygvL7b1oY+8BP4Q8hF6DWrEvM8 Vw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=W1eB7t22CELpSkU2gfjx4dmYVuFjBoAir3UDqFeeNck=;
 b=R7qk/PTmEK36Zxycbo8pr16N5RSLN3mKeXsqUDLC/zTQTfTT+v7jgxGhCXUiTnbH8Ur3
 fP2KEjQvNtPobHa3RHeuIB1eKoItNlp/PVZAmgY2QwfW1w9Ly2eMyhoRB5vv5VPGakjo
 UsA6eTLz5VYa3TwLAKtZ4nYi3W8I360Y+7jbUAMHn6/dsju4PcGzSbJlIE2FNDp61zgn
 TuIUlUy6OaXf8qXzKT3A43rRJQyRa+04XZbYjPxzDVnB+dOrKWCe/FNQWX16C2822Agn
 HQBOOdNuLSCgvyAfZRMCxocGuLWDOYrCReHlrvIGkvrrYpuIIWlNPkCxG0YA7WsY8sS6 VA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3cdpt210-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:15:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16TEFma9060626;
        Thu, 29 Jul 2021 14:15:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 3a234ejx0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:15:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/n0dvH0bCM6p+A6GMl5hfln1I+RP98600LwdG4zkTGVjKzWy4cfD2VAxb9bdPpxf4wwh+DqQXKvAorHfwRpojxAPyR2IRKR2WtEbpd7aHZaS08igX1x1z4v9cG6AAslS2Q6yKTLO7BSJEef7lomgIhGoOQv1ybKKqjgbsvboLu6Wwjf+vYlRGyoVAgGvJ1b+/HO/93f9Zc+dR4XEQEocOXgg91x7ZB/eRfKM92E+WPG4dpGY+IXr43uONvhQidODGmf598QMOEDcxoWw9/+1iYB0+lr+5PKy7jtJs3DXk1zPFby4J4GqAxC9/qyUbU3JNW2XZlkNv8KTxjC50w1rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1eB7t22CELpSkU2gfjx4dmYVuFjBoAir3UDqFeeNck=;
 b=mUbtb6iwbfZyXn1/rE9d+mmfH0fge0ZEDzDniAxI2c8VNSkzMa5xpnwXaOjfBeWCPEYlGi+UqarPHR+VVrmbuKmJfnQe/LrX3eASXTuAlegIzkrimgr01Pykmt6b0OYIaGLQsCpNSJVY6Gjw94XT1oWgn5f9rLphZTw3hpo4KglBIZdVxaGXaXXjJsj9m+WGAoBc+SbgxkSbhZCU3Ot0D6bbrmq4opNZaUNOZWPgrVLKrsHq6HP3/ZesLTq1FM7G0r9mw+PrkUxFm3VXQXA6+hWQPvYW9XZPA5YZtyVqhsJwT01E71c0vnr84WyC1Ksy/Nd88pVDV0Ce+WIM8a5AWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1eB7t22CELpSkU2gfjx4dmYVuFjBoAir3UDqFeeNck=;
 b=IjmcjUyQwIDT9UUK8UjSmxX+hnf4S74B3P9ExOLRbsJM/nfitVleTivFmDQZHB/Vz6vD0IZhOs/wrgJ55O1XQENpaVwkF56Um3BSj1JEEIjTiuuoi5R4+3iDmR4XXp4wUBxzGLJD0PBhRLkBAQ+dAAY0WLlX+B1kOl8iO1dpC2E=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1293.namprd10.prod.outlook.com
 (2603:10b6:300:21::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Thu, 29 Jul
 2021 14:15:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4352.032; Thu, 29 Jul 2021
 14:15:46 +0000
Date:   Thu, 29 Jul 2021 17:15:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: fix an oops in error handling in smb2_open()
Message-ID: <20210729141534.GB1267@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0104.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0104.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 14:15:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0ef2883-f18f-4f50-a766-08d9529b5be5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1293D00EFA1228E763A2AB278EEB9@MWHPR10MB1293.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMdqdBLCe22x/5AD5CdjZo4Z7rLVxOfz1WK7O2YUYNA/mC8TMNXbP4kb+Q0MjWB26WPvWKlYn/jRbsTdZOU+Wqj7IUVQj9z0rzfYhnAeqGh2W4DyD85Q3OpqLBQ/7lTJXyY85tGkmJCxSrbI2cLxKhHA39fRIWXMM9C/6JKNug3e6Zfth0M4HOd5m/szwgl257HpuaOzdkmELf/cmw6aSq8QdxIB3dWUum2eSEsrZMGcBr6QiY4dqOdPsHPTOac3rsHNANjHC+j1F/D1x+x/+NxHjRe91j0ZxLtX3pJ8phKJ0IjO3Btl+36YAIcUUlCFLy+vPNnq6yKMrJ4I3VRcl2s0sGYtVwIQ4bwUbq/qXgC/rm2lmxpBnjbzPGnLDF/ZHCyHqIRAg9fOyK6KDPhahS6P9gEIQ1ZIW2It69wUJByWbLq3E54slbfGXr6o4Y63wCi5Ke/K/O/tUlG1QM41aO2MSuthb5kTdE3a4DfKwSaRR83AYcWTLEqjIi/iH+jd3vAWbIRjaqUDw7CEb1zEpcF9hq0QgKBck9OJAVO+E3W85ssIwtXeHK/eQL+OjloAtGfGW3FWS8kXhqiWoxh2xTL+bkJZDJmVANFi1Fhu4NHITPVB/Q4BGOvUlnZMkwkevMwyyhMWrdsMIqPZv4TkEwl6cTxl4xeJwd+V2G0DIfjgyhr/J2ySJloZEHUpGZV+AZkLbnZLXV84sqcLv1AqoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(376002)(136003)(396003)(9576002)(6666004)(6496006)(86362001)(4744005)(478600001)(33716001)(44832011)(8676002)(186003)(2906002)(26005)(66946007)(9686003)(66476007)(4326008)(5660300002)(1076003)(316002)(66556008)(55016002)(33656002)(6916009)(54906003)(956004)(38100700002)(52116002)(38350700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IwbgGEgM8MghL+hmWaxpZKnh0GyBoQh6QFAu0CYX4/BuGnC6RpFE6Z5tfUU6?=
 =?us-ascii?Q?5p8+GMjtrgfwoSS0aW9iBXSKogueU+M3r7UpcNFf+dV4oMV/ekp6x4nSJoKj?=
 =?us-ascii?Q?M/jBNiPVot5rwn/86s0VlF5V7/2TRc2YJCVAK+Baouq8fNvQiNKz8MyU+8Jg?=
 =?us-ascii?Q?fGO+1Da0NpgttsTOJ1oUnNZdldc+MqT5BaA/ql0QZr7Pa3bs7P2n65ScZ8UA?=
 =?us-ascii?Q?4ZcWHAu3Q7ey8TIz4kjc7vbbMU2pBHxB884TOF2Zmqwj07NOvuQjQQGRrPui?=
 =?us-ascii?Q?VRycg7H6mbqBdrAgTrZ0pS6yfKUcmpmm8tI3zngEXzJozu7mlH5XBywWVaUl?=
 =?us-ascii?Q?UcUuEaYPCyUDfiiTG4COuIjOx++cjyT44uEY/OHFNNxPqcoM5wH+erLIKH8k?=
 =?us-ascii?Q?TRx8XoldYvvZnhWNXRKQ3XlUxnLbw8lTsBU67kn67XJZWnJ/pnPbbr9dXjZL?=
 =?us-ascii?Q?+LGvQghCZTD7El6AjDToryUJm2psSuYjuFd6GIeMW/QyLifjFi1/L22lQQRy?=
 =?us-ascii?Q?oup6wf2eZzrYYmX9grJ7qBFE4C2w/bQUm2gBJi026xRChu9HHB9Xn/tyDZiA?=
 =?us-ascii?Q?quUSMw+GQgYU4NA1/78CQ93Y271349OoBdIozGdXVJeiZ3iLjT3EVj5FJf6H?=
 =?us-ascii?Q?89a5AFP/fC5lUjM+JcZaN4QEtXRD4l39L5T986tarDfRv9EXMat8cy/PLg5g?=
 =?us-ascii?Q?Ib4BvP9t6RnnUwLeId8u8xpaqvGbMqKxA1hQ329BQrfUKdGw4tpb9xzHVZXv?=
 =?us-ascii?Q?8qsIsfmy5MY5jqFap4dFxRE2owN1cR7aMJ+lQkBM2S93hGrGkVvjJTwCFq2P?=
 =?us-ascii?Q?Qr0V1sMo2YAsC2MWFH3mCAhIyAb3bYx+LaKd/grYZ0YcUWFQA6Jm9j9UGdTu?=
 =?us-ascii?Q?RsII53715Z6xvsV32BN/Mc9rR0n3t1a+FdvG7we3448gn2Le0rWegCP5n69o?=
 =?us-ascii?Q?wHtVUd4m7yt0fdqGUJIb88IpVkA2Alkc7crcAh86rwWGQ9qlrrAapTQ+hUDo?=
 =?us-ascii?Q?/Z9mEeNcYjBTRZ+I0Jzg6gnMfbo1Lk4suChygFgba7xv9K9cyZ+VLZuEv1eg?=
 =?us-ascii?Q?236cga7A2dR9iUwLevFrx837rE0B3dfrvy9gb2gnurC21V3Sy0W5amUOS/vK?=
 =?us-ascii?Q?J8bwMlvnZNRDS2E6UDax9gGm3d+KPhkefRTUNedbhIHnZgmZH284Mf7eqa4p?=
 =?us-ascii?Q?3NDN69WbjAE7Ze45LftxZEjtENrilH4uP6mDFoOuZK7s/uGrSNfO4slnTVGV?=
 =?us-ascii?Q?isIOtfSu4KORpmqTMnMVEyD1Yt/AJkVp544tLPrYoD1hugCCSt8rp34VO3AD?=
 =?us-ascii?Q?4vqIxhGbYyz5J3zzhfxIFaN1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0ef2883-f18f-4f50-a766-08d9529b5be5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 14:15:46.6140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3ipDSSKz0Ib0ZPRTmSLrmhhNHq7GKLQmF9W35zjKk1tm0Py/Lf3+ZvIrhi2L2ArrTxtIL2C0Vk/wLGNpwKgiZn6NvHpaWo0VqxSBdmits0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1293
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290090
X-Proofpoint-GUID: oGnSK1VwjKscJRygvb-rP6nJkfHn9bxK
X-Proofpoint-ORIG-GUID: oGnSK1VwjKscJRygvb-rP6nJkfHn9bxK
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If smb2_get_name() then "name" is an error pointer.  In the clean up
code, we try to kfree() it and that will lead to an Oops.  Set it to
NULL instead.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index c1a594599431..7e3cdd1b5b41 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2462,6 +2462,7 @@ int smb2_open(struct ksmbd_work *work)
 			rc = PTR_ERR(name);
 			if (rc != -ENOMEM)
 				rc = -ENOENT;
+			name = NULL;
 			goto err_out1;
 		}
 
-- 
2.20.1

