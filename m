Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB82C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 07:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 851FB6109D
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 07:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhIGHfy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Sep 2021 03:35:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24704 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230286AbhIGHfx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Sep 2021 03:35:53 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1876EHhS017556;
        Tue, 7 Sep 2021 07:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=4QiF3YRC25HycA+3wIdu0dZbmG0t5OKdBrQHCkJPub4=;
 b=TTj38ZM6i+1u3pvjvKghVxusWdxu0NkzEs/Z6nz2K/T2+mPwasCHV7qY2MOn3ULNYRcH
 B0vR5DxNFqT59+LIYPwKfhLO1WKrkNFKYyygHALBHCXi7Q1ESSjKwMgPF4J1MgUYKcci
 3Q8OvK1jN3hDN+eZ3bV/lSTz+mKIR6iXTP0XB/xrYSgoDZpmQVutJ5kR7Cmti22c3Mt9
 eWHN8+sRUJwIrJmTC/YZnnFyQaLRwO0+a+R9dKhcFOBUE1jhK+HUChH44FSuMD8vZLn5
 olwsmbYC983guwYcV7DK9AHgAZEFUy7KUYGHYWvT0yc+KBabhGMUM4evx2TmjAwHLxJb xQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=4QiF3YRC25HycA+3wIdu0dZbmG0t5OKdBrQHCkJPub4=;
 b=yzfoHWQKzzmuiJSQrJtojEFI0r2p3AI6WP6Evoo7IBl3QqKp7I1S7wGVxkYy9czFw4t8
 lna+sb93y8svUuCk7NjxRCgd+pWwT2FD7AjDy67TaKvtUt16LNQ54NsxCwLD4Hzs45pz
 XA+4VrQTBx9N0koazyZ6UsI5WamuB04Dd4iJhqB4+3ODnvjwT+raQPI2Be/V8u1B5S1c
 0XDNBFPuuN5KoBFatqKRkn+HGF6N7Jrk4y6HyDRUEjLW+wkH80121o+URAWwwWCXGZst
 shULpckqyto6j7SyMUuICEc7J8cobr034H4Ah/bFoaHqVIPqe+wS8p7O6KdwCI7VrkQN Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3awq29gxn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 07:34:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1877TxJo125674;
        Tue, 7 Sep 2021 07:34:36 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3av0m44u0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Sep 2021 07:34:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+pcPj241vqN9kMbupbqyCmBCQNfAVJnBXkx9VBho21zpsB6iA6iDOyT388UanjEFoycPkrJ4Q0d+R7TyXeXz4wOJB+5gw+YaEOfLwfz8NKleFlhG+J2SQPOmZcReuVE2bZH3E19axQT6HuvL+7rv4+7tV3INku4S4uYxkiYwNvDRUnlVYYSog6PVAgPHz3EbNgzeA+q9tW4MgVAom3efQ4WRkLcGnfWJUBNqJUeDW04wux6ikqfFr6Per8oi7CjiyUvd2ULuIQAtGKFnRotXKZm7zvyMICuVnxaytSGUFD241cCQBf/7LOvNik46VRn7FxhVL2kqew+6Bu6C02U2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=4QiF3YRC25HycA+3wIdu0dZbmG0t5OKdBrQHCkJPub4=;
 b=Q8IYpIbr+JrPXRpH/YczfZ7Fejnoi/3vG2+qGWSqPVas0LvcuEzzu+lWuvdS5e8pShgTQLVyMX2Fc/D1LSWgtzHWVCy0+bFGvqmSz5x/ALx8NJNwx+zRJ5z823eybX4tC8uAL1+bVrSm1VPGT4euOEP76crRs20vEOtgeO8TaLiHYwfneoS9k0Dmz3KrXwR/Rv8KhTnCjO9wB+h8MuNVHD2NWaPEPV4B6T3SJtBnCaKMdiUDmHIchmQCki0N7d5UI4Y6bktEnO3/Z7lNuojNIDmbTjFuos8w1rz2IK4w5+c3+CJwbxqwFHP72qv/4rtvly8ODnuCJV/PbG7+2JivgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QiF3YRC25HycA+3wIdu0dZbmG0t5OKdBrQHCkJPub4=;
 b=HQb34cpX1yJSbLufsOddhvYes+2ClAVxHaLibOkh92Vqzynv+Bsn1s5AdLbPPcClUDHdmV9NFiN4CfikFcWKbGDv8jHCcwH6z7Vc6Vk0taKWpYtQtZnTcb6HBZbL+/DZAxttMKUlZ1YxwcwPZWvLIhWAJKgjsC0zuOK9TNe0j30=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1775.namprd10.prod.outlook.com
 (2603:10b6:301:a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Tue, 7 Sep
 2021 07:34:35 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 07:34:35 +0000
Date:   Tue, 7 Sep 2021 10:34:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ksmbd: remove unnecessary conditions
Message-ID: <20210907073428.GD18254@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0040.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZR0P278CA0040.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 07:34:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 061cb216-65d1-4e13-f876-08d971d1f0c9
X-MS-TrafficTypeDiagnostic: MWHPR10MB1775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1775400635A71E0F7E81C10D8ED39@MWHPR10MB1775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ei4rNiKHapd55hySPkQSeVyK4qBPWcoW9TQnf0e4n5F4k8RYOdn7y0MwJT6HUQaGrf3ayWhCH0j8Ls5jdJ5DwY62ToroKAfzgjsSXIxq3MaIcDTDaCrHFJPI3vjh15AXTuW7FP2I8qMbwRHhUdywVOpaKodQMfwZKWuH2yPL0H5HnDllOjUX/bVtm7HEMKWS7VVL1Mauxw+NuLXTgxsb7Q1BZm35X0eC13Due/UQml+0FLO1IUUt1oXaeZ+Mu9lwvGTo1kJMVg84gZ8OfVJaXTE5R6nUuft6FoB0GTDD0Y63Cd9a3vVXLZyYDh4Y6Z2aMQHN/5u5go46G5gU/Y5VJOHdVKiMG+Ef1IWkTY2I6yphHu/DDVNmOm3SJTAAl0c+8ObJh8hgZTMAM+sEkW5xLTK0uBIZe/OntT1TxUYkWqviek6fjsRCrBT806iWhf5lHrrg19CQN16BcJlxTtrB7uEc6CCxqYipYy9b2xIa92jnXNXxa84Iuqjoj0kfAz+jyX+ZvCdwlhmDR/0uV0XID8T6zwXuQqn6WFgukp/mnfMeOnr8B4n6vwMaPMLoBbrRjif5M8iYXH/fKty1MBhy3UJeM4XQ6nuw3kgU+Jq0sXG0AWP1DNYY/72bi5xYd7qNx6BqWIJBHpsOwWpwcYKB9BXI8D04bAzbItJtCVEiyFq0WkJgHx24tKu/7USkiKWL6l/PR5YTCSIHz3ny7Z17Yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(86362001)(54906003)(38350700002)(38100700002)(66556008)(66476007)(66946007)(5660300002)(508600001)(55016002)(9686003)(6666004)(4326008)(52116002)(2906002)(6496006)(33656002)(44832011)(9576002)(186003)(8936002)(8676002)(26005)(6916009)(83380400001)(33716001)(956004)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GS6O0MjvX8K7OWpYhwEtVXuWeIyNAMYVFIQcwNcbDJc15bl16YU7NRV1fs9h?=
 =?us-ascii?Q?gonAB/hCfBHZHe42jZYbUKzO0zS9kDaKkPNccIXn0U+IuaWW47hrAdpBxsIg?=
 =?us-ascii?Q?Zd3cJkSlmpC33mxRSGEP8ezrwp5sXtcVlpGTg0megiSStNAbScYd3wrEFI8s?=
 =?us-ascii?Q?mpl3Ohmk7wbXSScFOUiC2mjuFylufH61deC37vRCZhMKPAVzJJBWMSo0hGVK?=
 =?us-ascii?Q?hR63LMpk5z5OLBWCS3tdJFCyFAEF9ocD6btck1wiuU0bAw/QO6GmyhfojKGJ?=
 =?us-ascii?Q?WnMj/Jz26HcZ4Ap62PZKCaM3fek1f9XKcZErKZel9PGtkiR/4PfwBL10K5OM?=
 =?us-ascii?Q?5t3B0KGgFYKJnp2YnOvejb20K+WWQhzVxUyCy2TewUdpC3IZFFay9xPGrhWX?=
 =?us-ascii?Q?bzN2M6NFqGvn+9L7sr71qrKyFOQPZ9IpB3BIwsY3x05MgeJYbKlZmM0mKCn3?=
 =?us-ascii?Q?oN/ReS4f0eM5GpCCUCb3vB/6g62Q0Po05o1DmEJJy/q7lU8v9gTJgzVmtCUU?=
 =?us-ascii?Q?gdcrbZYJkYxha8Y31H2755oWna2PAXpKFjBA/MI9bXbq8dj3nmxZT309Rb0Q?=
 =?us-ascii?Q?sVHWT8G+l/38yd/Cn2uuHrvqKuvbhtKbzsauzoK6pJsf+bkAFxPwX8RurOCc?=
 =?us-ascii?Q?wIJHK9VjWUC2R/JPi2lPkhkugZoqPrcM5B+6i7s0lMkP9TYSknovYXp+XLrP?=
 =?us-ascii?Q?LeEzBlRFiyOhfpbxlsOEw0iBRWSIt9dLHQyV5lbIU93lzVnN6VjViFnWB15j?=
 =?us-ascii?Q?CqXmoospx3DzHwBYyOPOK+PiMhi9G4F+LOKspxCBwoqyXykLiVZBWJJseNve?=
 =?us-ascii?Q?haQ75nMiL1v4rp0lusUZdjhiMeuSF+szx+4opiTGjFOeneTZpUAZfrtDBV8D?=
 =?us-ascii?Q?f784a7T3PEcPLpiJX1lT7mU19xu2nBl1hb2Rmr9wJT6bZoH2j9MyEQO+wC1G?=
 =?us-ascii?Q?IUDRQry0kiZDq5dPdi5Gw/NrDFQQIQcgHcZknACC7oStryXeczjofUAoz/Zr?=
 =?us-ascii?Q?3v3sHbQlBwy9Dbqe4IFcNTRe9TJFi8KINNNeoiOfJAnLSk2Sj6Qme2m3in95?=
 =?us-ascii?Q?G5Sm0235pZCRPN8p8TEoDTOEoDXyU/NeidRZ7zdOQFPsafoibJ2E2qWx/JBz?=
 =?us-ascii?Q?sjZehVtELSC97+Cs1V9LI0+rQKUqkkswcOoeM8qQ+8cMUo06l/aZKLwwTy3+?=
 =?us-ascii?Q?ZvJD/B8u8R/lMCFycbUIXhWGVfEGkdIDd2z31mPbuxBPv1DjwITmM9gQVdZa?=
 =?us-ascii?Q?vI9NmqnlIhrcHc3UE9ABgGloQvFPMxVYHt0Yj2gJOudpke5q7/lJdkRqkaAL?=
 =?us-ascii?Q?ej9iH5eIfFNv2twD9cAaF03W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061cb216-65d1-4e13-f876-08d971d1f0c9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 07:34:35.4255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGSlzQq1P8y9VOrWbgJAeOxIzZfvjzIDiMZto9uOpu6gq9ORDXKqePjWF84+kHuL1bChTvMYVn55xvtw3IyhGkinxA9uYQshonIOH3OJjf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1775
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10099 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109070049
X-Proofpoint-ORIG-GUID: Xb2EBrtBVuOResRgzVL9tNL8RvDPjCzR
X-Proofpoint-GUID: Xb2EBrtBVuOResRgzVL9tNL8RvDPjCzR
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

uid_t are unsigned so they can't be less than zero.  Remove the
conditions since they are always true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/ksmbd/smbacl.c | 48 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 16da99a9963c..0a95cdec8c80 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -274,38 +274,34 @@ static int sid_to_id(struct user_namespace *user_ns,
 		uid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		if (id >= 0) {
-			/*
-			 * Translate raw sid into kuid in the server's user
-			 * namespace.
-			 */
-			uid = make_kuid(&init_user_ns, id);
-
-			/* If this is an idmapped mount, apply the idmapping. */
-			uid = kuid_from_mnt(user_ns, uid);
-			if (uid_valid(uid)) {
-				fattr->cf_uid = uid;
-				rc = 0;
-			}
+		/*
+		 * Translate raw sid into kuid in the server's user
+		 * namespace.
+		 */
+		uid = make_kuid(&init_user_ns, id);
+
+		/* If this is an idmapped mount, apply the idmapping. */
+		uid = kuid_from_mnt(user_ns, uid);
+		if (uid_valid(uid)) {
+			fattr->cf_uid = uid;
+			rc = 0;
 		}
 	} else {
 		kgid_t gid;
 		gid_t id;
 
 		id = le32_to_cpu(psid->sub_auth[psid->num_subauth - 1]);
-		if (id >= 0) {
-			/*
-			 * Translate raw sid into kgid in the server's user
-			 * namespace.
-			 */
-			gid = make_kgid(&init_user_ns, id);
-
-			/* If this is an idmapped mount, apply the idmapping. */
-			gid = kgid_from_mnt(user_ns, gid);
-			if (gid_valid(gid)) {
-				fattr->cf_gid = gid;
-				rc = 0;
-			}
+		/*
+		 * Translate raw sid into kgid in the server's user
+		 * namespace.
+		 */
+		gid = make_kgid(&init_user_ns, id);
+
+		/* If this is an idmapped mount, apply the idmapping. */
+		gid = kgid_from_mnt(user_ns, gid);
+		if (gid_valid(gid)) {
+			fattr->cf_gid = gid;
+			rc = 0;
 		}
 	}
 
-- 
2.20.1

