Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5955AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 10:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiFBKwc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 06:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbiFBKwb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 06:52:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079CBD9EB0;
        Thu,  2 Jun 2022 03:52:28 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252AOga7008735;
        Thu, 2 Jun 2022 10:52:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=g6gPqMEmdk+gtR1TwrOMRh0WiHJukuXeoBMiK1KlaDE=;
 b=qm0h0g/R3sye464En0a9SH8M+5ak9v1scJJpdHf7+84rwZmb2vIg1D1sgWQB/Wx4FCqi
 4Gs5a/4445N7LFscDi+XydwB9wskC4FM65D+D3lFAzF7kseN4TtokloF4rPl+5/SNo52
 t0ayO75+FgpDFXnt3PKju0hELWGqlutVrQ1iDSu0zXDikMPFFfeLBbNXzrSZakjJU4+O
 sYXd52oBiqruj9CJWg7qMLS7fQ7sB3Pf0H5uvrEO0UZT4sMm53DGn4aivopX/seP0lvu
 ELH2HyZHxK+mWM6otwpoppG646JfsIFWNz8eHeF2KKIkTY9ZNfqbtyrMYFPPDST3Xb0t Fg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xt6gv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 10:52:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 252AoBBx023639;
        Thu, 2 Jun 2022 10:52:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p4s50c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 10:52:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIByqt0GRr1iof+yrUmdMQGs32STJay9zPhUBLxyggwb3JUgZegD4/gEKN0D91dupSgfiLOvnu89PLuil4N4VQjxG20Q6M6S7bzL4ob+K5uUm+wXNd02lYUQjhhwx/sxFcDll+1Spy2kjMaU6Mahby8JdPsZO2xF1fF3HR5MS2ZtuS6WvPoyP+iAFEaQpfK3B/YR9lnavk8nWigwC9DYC+44mImWMy5DGuIRmJg9sxrEEo5H1uT2aqz+6OIT80LwJofdd/+5bqw7/XjmtRnzUlKjvpR0KfW9n5JdfXBIw2dM3NzfkRwbOQBA+qd97e45LWc55ylDvBU6fAoQBAOnKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6gPqMEmdk+gtR1TwrOMRh0WiHJukuXeoBMiK1KlaDE=;
 b=Rex/k6QMDBOK/Xf2g+KviGwnbPbTQRLjkYhMLrjyYFpdW4FuJE0tE4bMDnFEQNKojCOcj+iGk8JWSgM4m1JpuNLUOylcqKbHMU7sxng4lsyAR+QISU+KLtysdVZA+2kXlHh174AQGzYRPFfYTuzltGYQqBePE/TsYquJ5vbkUh+WEo+DyXf0kFC2oHoclG+INMoQiw4xvVRvsPYbZ3XnCnH5XnoS4eryXZ7D06TfPOAHiA1zUWB2+PrUuIqddl+SR0TlCYtrZCXZlv+hx8D88nabkEt2Ou0THUWbukIb/C0gVZmwO0orOcGWtw8RMh0ZbOUfes8o0plCZiwl14Xy/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g6gPqMEmdk+gtR1TwrOMRh0WiHJukuXeoBMiK1KlaDE=;
 b=xMhx9bT5OzuA3dk9blRF8N852ckdXrRZKVz5Ni6qCDwEsDL6ACjjOPAPOj5ZGWEO5dQedWr/lIloLw/zJGHrrENQO0h3L+GKPVE+wTBc2fG9GeBlTsDCeeH1QWnWRA56zZYWlwVQg4cUR1FBlmsYiaQ6T9eHfK6eKTcM4l3/QqU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1549.namprd10.prod.outlook.com
 (2603:10b6:300:26::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 10:52:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Thu, 2 Jun 2022
 10:52:06 +0000
Date:   Thu, 2 Jun 2022 13:51:55 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <sfrench@samba.org>, Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: clean up a type in ksmbd_vfs_stream_write()
Message-ID: <YpiWS/WQr2qMidvA@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0166.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 415942f3-489d-4381-b0a5-08da4485eeb0
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB154959555FCB4110206396B28EDE9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5P4jCBeG1IL9o4z+rkZxsnuY7pN11h14AlyaWx7+dLWHD/YM0DOscOJ7UJO02VAzD0BFB/O0SmD5tkeED70jZiGqy/bk2DRgFNhf5zVwZH6fqYufOX0w8o/eR5fCB/kq0v14FZINTHc6z8KX2Jc7vJccdXcRhSB1GDY8vEitOeGR5D1R2BzB5veO3r588RW/QT3C4cN2UnWfNzWKqF0fKst83gry1gyPYm8tKuvKvy3deDmgcllsg3Cr2+7YjUavmwM0F0UruqVWn9KCCnVw+ZYEWDGDwXr/A5T5Q3rD89fXBIDN2ouHFarCfIBckkmVd/wU4XjC1CTiufqiXHBLHrl6Fd6VpxAHTIwD0MUYN3RvexfG2hbBtU3B3B4vqpyV1lzQdMv61I3VOjr42w8r+0UzGy4dEQrM3OFLKii7x6uo0/ZjVC0iZZBY2+i9uCa6LZDbtY5elNHqO1zr241Ziw2IFSQHQC3zgF7lpNHdc1XqVvkJD2WxYtEu4yeOWbpUrdlJa9yK7tTdbe+lZ8+yEgiz6UviXEz7Xlp6yKCJxM+oY5XWczhJfsTXxFxEkMA6ytYJ1Kt519FS+kVS8KtuXxZOCeXwI048h+x6lO5SdTxOOWj2qI5I4kyWg8uPc0CwIpmIOxjl5h/T+VK7z01WF7d2A0dYPmlpS0MDHz+XrT4zVuooz/MHUu6zvPVuBrpwCLbFihj9pQwpy0OgMH84QA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(38100700002)(33716001)(508600001)(38350700002)(6666004)(2906002)(8676002)(5660300002)(44832011)(186003)(83380400001)(54906003)(26005)(9686003)(316002)(66556008)(6512007)(66476007)(4326008)(86362001)(8936002)(6486002)(6506007)(66946007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tlVkIpeSi0g6KYSB0GyX2/pZH0TxZMiPxqRjcSUH82eXtq8vgF/GA2HshbGW?=
 =?us-ascii?Q?liWpQJqVeW9HTIeopkcr0pkJxNeqG7bMYIoB4ExYPmB+VMLCqKOcU7ay2klF?=
 =?us-ascii?Q?X+PHNGWod4hgHjpUwPuQK2gke1OnPdAPRus4+QN9XHQWydVf1OZ36QJ6uykV?=
 =?us-ascii?Q?r//CFxuaQgUrpCiiuPhGaSl05aQuMO+oOVIcD+P+uyfKwYKFpBHkaPiZx3aQ?=
 =?us-ascii?Q?7tKePpi/eybWtjxxMNmbgtwl7hFV+KqPwtjhTycHQurRPv2h6JrqcrtOSidf?=
 =?us-ascii?Q?FNMPuigYGA22uYERZSfwlENdzm1vAHh8B1YEvL8IqIp4IyuBj7aaHSVtl3cz?=
 =?us-ascii?Q?jGPxJQBs5FE1hZomQVMVsv5KaFYBtPik+gxX+Fh/RDthQ/y5yg4f/kSvm5GR?=
 =?us-ascii?Q?WpOKZnx7lvLphuAPw8BonzAnIBTR0e6pCEM/g5sh6IMUlmgJ1heCFYCfwKia?=
 =?us-ascii?Q?9qaTrai8/B45zw6eFjcaIq8Kg8PuJ7BvohCvzRCYv20ATj3wDFKV9lXtwZzp?=
 =?us-ascii?Q?B05cey9RaE9sL2u8YU637C5e+EAt3Yu6qka6toL21aALoUc9x1rgOwctMKQt?=
 =?us-ascii?Q?dqbKlGeTB45Q0BpDDAh204RWb8uij7FzXgeXJIJ0z3jlPqU2JNHVqcM4Y9q+?=
 =?us-ascii?Q?Tn3EI6k9yshxiDE5E7qiSURBAYkHtpD78inkbkGtXy1HmQCd0ONDU5OENBp7?=
 =?us-ascii?Q?+4iH2+U4aBk/HzZBbkPIfDpycZSzvTsPHxw9KBnQx1LBwu48JLsgD1aWHvZk?=
 =?us-ascii?Q?HBGz04qF6SU1kc2nZtlMRTJ7f9wZD9YuZmK0hEEuTgDCzib/WCQ/9Dlf3Sta?=
 =?us-ascii?Q?mCbGer03QyO7H1Qn2p23Nn+svXLIU7wDRLvXPDPo7wSFPz1TumF6VMzdLGBg?=
 =?us-ascii?Q?g68qMY+WBHCIy46wWDZKK/tncsVBCGmaaYWmh+VRpyetTnCPeDUsJ0W2zmO1?=
 =?us-ascii?Q?VQlOe7TFpFZGWGBnrHAShbBNipOFiSjqOvSiCMMQhrPf6h4+QxtTcW3vl+/n?=
 =?us-ascii?Q?IUeax3cksqAoqZ0XR72IV2UbxNb5JlspEjyT7QtCOm5zRnJLhyf22ji2ZFgW?=
 =?us-ascii?Q?OLxfRyZ3GbS3EGaDtzxdlmHMK3GLzV9M5DGDjWaLjjFTDIBf8SLYoeOfiM4S?=
 =?us-ascii?Q?HLB6t4K6MmFCiI1EL+xTPCZOVVQGobRFfrbBPPsfUm/PVYJUJhgrC9f4+dlS?=
 =?us-ascii?Q?pCZbsACwCUK6YnyFKVsoRDvyP5ozCBwAtVZEtGsvw5qQYN+ZMG+iKEfbr0FG?=
 =?us-ascii?Q?Ly3omigNMWd7+Cbge7YddepdTZo6xqOlH2c/VOZ2U+EjcEsfxb4mPMLgo/eO?=
 =?us-ascii?Q?neMkSr8dZnuRU8MtgHUAcKLppvH+iejCwX1aPPAVQScI2vlYzoVexXjrwCqU?=
 =?us-ascii?Q?KEJSLsfDeL4czZFwgauV6ZY7r2S4nNZcHjs4/pe2OSfUosmmbCGXHPHzgTDd?=
 =?us-ascii?Q?5o+QLdbL00L6ux4Xx34UGpp92q1xXE3lE+fmcK9m2u8vkXmDtDh2vxft8hL4?=
 =?us-ascii?Q?znoiyX5wrFpJZpFTin/gTv+K4svyh+lxQMxx6L12Rn3PwwMX10Xxa65lasxW?=
 =?us-ascii?Q?gWY3APldG65a2TzapNJOSzQ9x1SNGpQrkyQFhFWq9cTIu+94yw/remBLhIAB?=
 =?us-ascii?Q?IktLe0W0vBEj4r0iYqULk5d737jbMr0GvE9lsv8pMEkRG/OUSWbsYUfOuGr4?=
 =?us-ascii?Q?civcci4Vwd+gYhSalqFhoj4nI0DcpdE+9hFqrQJ4eeeDPJzfVgpXuVBHNPpX?=
 =?us-ascii?Q?ppbTI4zNWumY3drnNltweytqnVgPOxc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415942f3-489d-4381-b0a5-08da4485eeb0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 10:52:05.9273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZZvz0uy3F2shITJJ8fTwtbJ0u8s/CGnys6COasLHABsXR43ivY2Vx6v/3KdGBl/rtk6Pq3tDFEHXsSVM/5So10mZj1XqHL/xoePKiNJSkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-02_02:2022-06-02,2022-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020046
X-Proofpoint-GUID: dZ9A5hTuwABGJ-x9CoO-rVVOKT3h46Rm
X-Proofpoint-ORIG-GUID: dZ9A5hTuwABGJ-x9CoO-rVVOKT3h46Rm
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The existing code works fine because ksmbd_vfs_getcasexattr() isn't
going to return values greater than INT_MAX.  But it's ugly to do
the casting and using a ssize_t makes everything cleaner.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index dcdd07c6efff..efdc35717f6d 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -411,7 +411,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 {
 	char *stream_buf = NULL, *wbuf;
 	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
-	size_t size, v_len;
+	ssize_t v_len;
+	size_t size;
 	int err = 0;
 
 	ksmbd_debug(VFS, "write stream data pos : %llu, count : %zd\n",
@@ -428,9 +429,9 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				       fp->stream.name,
 				       fp->stream.size,
 				       &stream_buf);
-	if ((int)v_len < 0) {
+	if (v_len < 0) {
 		pr_err("not found stream in xattr : %zd\n", v_len);
-		err = (int)v_len;
+		err = v_len;
 		goto out;
 	}
 
-- 
2.35.1

