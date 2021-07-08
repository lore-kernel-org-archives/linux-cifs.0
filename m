Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC3DC07E9C
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 11:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885AF6142C
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 11:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhGHLdv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 07:33:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31380 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231569AbhGHLdv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 07:33:51 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 168BMYBv011549;
        Thu, 8 Jul 2021 11:31:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=1p0clg7iwdnW3JB+fKEPtdq6VHI9zUfT0OwMjtV0Ers=;
 b=IzJOovmxl9xVgWwUQzRfkHYEcMBGQ+BiPARwAnHxm2t7BnIB2iDRfNlACzB1ErSblEEi
 +7S4vpLYw4JXbd3OaGR4D6Lq0cq1vcA3z5q9sTUGOSS/A4Xb92KLhTjisIad68TU80CE
 VgqxTulghddywTWJgMxdycjPiLqNztM5pD1Kn0l6WUqw0rmnKhEoN37Z/7FQ6DykYfXH
 TyGK1l8ElH8T8FkDDokbKruxOWTKMs/YNU6pU4Sj2dmNcvWR8hUg05w77xkQNe06rXTz
 LU48JUDvueLGTJF3uRgmVZh7B0+xtJwd8ymBsLkBCxH7175/c8d8fqRKIAxF8uupRxws 0w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nbsxt8q6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 11:31:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 168BUUiA095764;
        Thu, 8 Jul 2021 11:31:06 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3020.oracle.com with ESMTP id 39jfqch02d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 11:31:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JphbygL3p757Ll3MXhdlSwSrejf9eqMKdeFkiEOOZkjLm/YCZWkoBEJ9ZboKkiSf2u7SZNxZyhiMNOQWayGTRwh/Mf1glyVuHpoV496zfgZNOb9T50kH8DFT7Yzp7NPWBqGZGYUfDJZVEQG13Y6V0vIUTfwRqPW64gqNub/I/90OyshfqtkH2p1aXK4g0vLXmSrUqhAwlR3Z01jMVMj2sArK9TlyWM93FcYZfLXfUGiLWoz5+w58hFgtcJTzLPQqEQpKNE9DB+ujGigWGVDUOj8lqK2IrPxZBhx1sCXizzDPYbIJDRW0ZCGv6Qfy/YXsviHq08m+3PVOiQ919IsqWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1p0clg7iwdnW3JB+fKEPtdq6VHI9zUfT0OwMjtV0Ers=;
 b=jds4LgfFWxZfmhtELcfJNJ/kcKfgz3wXjMhFLhd40PbNBGoIvqG+l9RBsIOelBuvCUcwInJFcR5zVoMDRVn8BGS6RU8bOy+8SWdgXn9YvN6LPrB9ADma22FGi4MksMDoy8+EhcKecDWFrpOUqPSJ0fxKv6fDwMLTDq+7u/8adHWWlC53SHfrGlPkfTnhet5yut2eaNhd9V6xbuvGi7cFvyclg6cCtquowCrM0YMwhZ88ptTDHjXE43fTa5yoXY3ZcAZb6xE4hpS0nLbTpTLm1R5lgws+IQF+wHtn02SCqin1qHGuLfkWDzM0Vw6KgMaxqlelXALBXpoJKRTm6SaO4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1p0clg7iwdnW3JB+fKEPtdq6VHI9zUfT0OwMjtV0Ers=;
 b=IL6/MclInJk8A+TXr4WpUVaeK/Q+Dzwc3+Whgcfw4QhrIJDaHfZrIYXXpi0ee3fvNhf2PtyXwrYLl7k5VgZX3NNtdCOv2F2Ymvp8wHXgsA7iGoVZ5UY4PzVe+8HuN94Rt/w41DB8nVfHUIltlMLSain/bf5lVdNsdO8eLtpu3TU=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1903.namprd10.prod.outlook.com
 (2603:10b6:300:10b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Thu, 8 Jul
 2021 11:31:04 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 11:31:04 +0000
Date:   Thu, 8 Jul 2021 14:30:46 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: add server-side procedures for SMB3
Message-ID: <YObh5kJIG4LoHkFx@mwanda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: JN2P275CA0034.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::22)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mwanda (102.222.70.252) by JN2P275CA0034.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Thu, 8 Jul 2021 11:31:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97f0133d-e57c-40c1-da71-08d94203deaa
X-MS-TrafficTypeDiagnostic: MWHPR10MB1903:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1903DD9A6BADEAC3A9C8C9508E199@MWHPR10MB1903.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qESpcpjoIMmCfCrZYQlP5lbFYdufpo1/BilBzEgws6LtEFI2jndNssKQj6AMXfFhUo52ZaRz+qt2oZvwGIvr2XIvO6+HoWJaN/S3YNTy6nMJdF4KDZ3qfXiW4SC+c6uE7Z655Ukpiu+3CZbSLN7A/dyTUmjGgJvF32r/M+sM3ol9y/lnrRr0A8mPfeM1r6KBSPQVUcsBPx5VwL2q5PctzPPh8EPcz5rpHubfMjdZx7uwoz/8BbAF0jW+1QPg/aFPkxstr++LT9aQZdKokdlLYRFrBdEdEyzqgDG1MKcYhCFsLfCGic9KSj0X+2SESMakWMXHxS2vAIiYMfD9MzHjFLq+VDJ6wbGlLWSo8MUQkBbzUemAMD95+htzJDAXz/Fg9Y0ILFgM9PZK5dPDPL30LN5QAeUXEJs5BAVzlv+kK7VKDKXEmc3V3jrS9YmCkkSDJ52K1brDzZX7UOySEb3Njc9qYNpNww4EHWou1CzOIKNs1XtBy76dZONsFWmo9M8Bi5n53mEhUMuJ8gcu959fqXkO5auRnJHIRQWuIiqP8k5bVXkBxl0GlD3bR8XIp2TnYTtOjkAyPBrRQ0Y3XW8cthiFWlZvpI653evPEyD/UcKsPYzG4LaUx571vt+PDi2COZS2yufGo0BWxJ7v+PnsIvjAL52PGhU3Nh0SAhhbI9TdK79WUOYF7Efvl49IeTJVoPsRmHson+OMHaD3NVLz+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(33716001)(2906002)(86362001)(66476007)(83380400001)(8676002)(186003)(316002)(52116002)(478600001)(38100700002)(38350700002)(6496006)(9576002)(26005)(8936002)(5660300002)(4326008)(55016002)(6666004)(6916009)(66556008)(956004)(66946007)(44832011)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UZl17EBX9SWU7nUHH9eKUsKm9oKlFbfw3xEYqCdqtqatj056z/WSjJKsevOW?=
 =?us-ascii?Q?S88RKh1e6AM5Uqika7z49KDgOKme59fbdAcSMP4K1/Z7Mr2eCFzzaSATATFq?=
 =?us-ascii?Q?VIb0M21Oxq+TZPA/JXmk81PapO4UrvAi62mkvw/ax2MpXNKE668Fly1BzdWX?=
 =?us-ascii?Q?TAbEoDJdssBlt58nMYLC0hu1om+1+HXpL/XwenVeDQs00NKl6g50a5x43QCN?=
 =?us-ascii?Q?lceiuhikVFg1QY46smiDjpDPPDqLf4ursInb04akQqXMj4k0Bjg2OF52Js6b?=
 =?us-ascii?Q?WDpSDpWEtVd7n9ohuByU/zpQTnDiw8d0wj42MCDm9uzF07QbksvIwljdiGVq?=
 =?us-ascii?Q?7OJaOK8Qz5tuH3fMiXX9fQKrtR16cB/7i1b/+cn6dMnVU+0omFOO9KrOQLdN?=
 =?us-ascii?Q?FUFoAenORs/Lp8N6J4a8OLyBT5C30DWyUhWBo4i0/U3iBT9XRpJpjcK0uSAC?=
 =?us-ascii?Q?qKZ6gAoLjdxxRlqBaSaMTw9+VSAHmoCRevfr4dJr4iCkgdBFi6PNelfAnpXC?=
 =?us-ascii?Q?w0sD53bIvl9+izq7MEKEf4tN1hLKPQUXZF/VH7mHwxrJj5zEkHtkMTLTdZF2?=
 =?us-ascii?Q?/cta3CLOgIHLj+UYg7S+1Lcy2HltJULuf1sm8cTGvDt5smas+958QlNvvt17?=
 =?us-ascii?Q?TEm+C1kGqnPvrzX0MiWU8U/BxC5GQzyj0NAgzryhi4wIx63F9ecKmDgDAIKj?=
 =?us-ascii?Q?se6IpKObmW0uwkoSVlbl+8OxauiLzqGeze5dF3RoQ2Rhsf1MXge9nJx0bB0S?=
 =?us-ascii?Q?iRULgFs7GR1O6KwjRG4TnSf2oq9jCs+4NhxTOsL5PRYvOwgCuqwn+zFvq8f3?=
 =?us-ascii?Q?SLyHqubkdHa3czvQ3TGuKSKTSBAxA4viQq2BYr+IQRhBSKAhEVr5+W0boCN2?=
 =?us-ascii?Q?90s8OjwgTHMElVPF4h4xSIH7qH7EL/AfwytoKQiYbgsJb953MU/q2WyVgHz8?=
 =?us-ascii?Q?oVY7uLgQPldCBoOp0+LHjy4IOpHV6346EA3udhRw/g+wypKPLLuipjJIrXO9?=
 =?us-ascii?Q?ErvguEKAz+cJQZjzVrzBNkqQipq2J7dstX0zD8ln+FU2rq3I3xx8NDCiuWAy?=
 =?us-ascii?Q?KlzoQsC6xKi42Zw4b31td2VWmeChvltF2kdPzZS7e7gRWiUYnmysMJa7rQzp?=
 =?us-ascii?Q?1x0r6lVqGxhv4UWy0/BpJkCuUgRDaYKZQQbO8ix1g+LEr6epn0SeSjPjhWIH?=
 =?us-ascii?Q?lgAOIbkEExOziilGz5EqMfGJdcG0EQEpPk8vF/3RCTM55dCsSeZAZwuYExEY?=
 =?us-ascii?Q?/zWkI2Tp1gP0LnFvznbJMBAhioivigKdI9MhpEz/tKzNsZEeNzyyLyk8ohhH?=
 =?us-ascii?Q?CSrvEctyu18E1ucrvmrTRBsX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f0133d-e57c-40c1-da71-08d94203deaa
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 11:31:04.2467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LqMI+ADFcmup2e7i5P8YDX+lfsHOuI0dNyg4IDXrGH5oxdlqt1OJlQcWDOwVKuu8O8fggiaziN8foRZnW2sAOGonIui0E1clA5WgAU9a4cw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1903
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10038 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 adultscore=0 mlxlogscore=434
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107080064
X-Proofpoint-ORIG-GUID: mePe4DkpPfr24NAkC7RAJnccUfvuk6pO
X-Proofpoint-GUID: mePe4DkpPfr24NAkC7RAJnccUfvuk6pO
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch e2f34481b24d: "cifsd: add server-side procedures for SMB3"
from Mar 16, 2021, leads to the following static checker warning:

	fs/ksmbd/smb2pdu.c:2329 smb2_create_sd_buffer()
	warn: 'context' is an error pointer or valid

fs/ksmbd/smb2pdu.c
  2317  static int smb2_create_sd_buffer(struct ksmbd_work *work,
  2318                                   struct smb2_create_req *req,
  2319                                   struct path *path)
  2320  {
  2321          struct create_context *context;
  2322          int rc = -ENOENT;
  2323  
  2324          if (!req->CreateContextsOffset)
  2325                  return rc;
  2326  
  2327          /* Parse SD BUFFER create contexts */
  2328          context = smb2_find_context_vals(req, SMB2_CREATE_SD_BUFFER);

The comments for smb2_find_context_vals() says that it returns NULL on
error but really it never returns NULL.

When a function returns both error pointers and NULL, then NULL means
the feature has been deliberately disabled.  Or another use might be
if "p = get_next();" and get_next() will return -ENOMEM if there is an
allocation error but NULL when there aren't any more items.  In other
words NULL is a sort of success.

It's better to always write error handling instead of success handling
because normally the error handling is shorter (cleanup and return an
error code) but the success case path is more involved.  Also it results
in everything being less indented.  Also preserve the error code.

	if (IS_ERR(context))
		return PTR_ERR(context);

	ksmbd_debug(SMB, "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");

  2329          if (context && !IS_ERR(context)) {
  2330                  struct create_sd_buf_req *sd_buf;
  2331  
  2332                  ksmbd_debug(SMB,
  2333                              "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
  2334                  sd_buf = (struct create_sd_buf_req *)context;
  2335                  rc = set_info_sec(work->conn, work->tcon,
  2336                                    path, &sd_buf->ntsd,
  2337                                    le32_to_cpu(sd_buf->ccontext.DataLength), true);
  2338          }
  2339  
  2340          return rc;
  2341  }

regards,
dan carpenter
