Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B150C43334
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Jul 2022 11:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiGLLEB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Jul 2022 07:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiGLLDv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Jul 2022 07:03:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083CD2E68F
        for <linux-cifs@vger.kernel.org>; Tue, 12 Jul 2022 04:03:50 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CA8D2s027947;
        Tue, 12 Jul 2022 11:03:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=fTTiSLHYMEpr5Oa1VpCpeHZA5GQk5B7wMNkvjjMomgQ=;
 b=gI0XKwgCeBQCuLRppDoeTweyzEyt515YUlffkwy15R/eGYrA02Vl8ZNz/2ctS1t8nWkf
 wBjqq65jo/p0RDuX9pz15jArRdi5X+hi333wgm0mJy0N+w1X8OLC/JJ2KlGAekvJ55Me
 dJhTPzp2L7zVKA3LMn3JaRvL1f3QRsEi5Agr5/MzvbPVYIXHyudZo/s+8rHytZG/sQZI
 YhErgo1KwwM7Jy/u5JnuDq6ZZxEP1Zkids6L+UzB/fQFb7AO+Hcqhe0UpNSaKmsG74x+
 5Yn2l8pDp3omluJ9vQM7ayaiLZSA9eJbk2wzcb8+NF8u+f56L8Ei1HLPYquqH/e72C35 Tw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71rfxcnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:03:49 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26CB0kR9010352;
        Tue, 12 Jul 2022 11:03:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7043303e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jul 2022 11:03:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KogLe+Jd1K0sbWg+p8HTKZ50QX/4JO5kKVumNRaGMDngg8F7oeOzTdVbAk1vcCe6lNOKcp2zyzgLbZPQ19eVlFHlEKwFw67A7CRO5pykT2vhB41PP3QPKDjuKve+Xg9OJg7afsFU+lxQxIeboeY/npcgcI6TbL7pKterkJ3rg3SYNUOoCXZFG+9cPHBTWKUX67bIHfjYZQ0yraz2rpboOxorYOCvIDN5x5cBw0FiFVt+tHTBKs3/0/Pf0SyaH8O1ZHRi89GoZSXXmdZWTwOYQYxE8XTTK+MGRnGjDtcZPR51Z2v/HwW0qMvPAlr4qE2r/Cmv1drMO1lpBEu23OGZbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTTiSLHYMEpr5Oa1VpCpeHZA5GQk5B7wMNkvjjMomgQ=;
 b=cD8kzLvihJEXcF1CE8fZOWtOA1E43br4pGTk+7Bz482xBcTI8698VDWatyK8gEgGl63ocv9VUzA3YRervuromSF4vhnD7v0aDMcnhrom2gWsu1LJF379cV+1PoUiHf0crXXOgDp22Xtq+9olSTkZIm6PD1BEnd1EOr4Gs4OCUjHBEPxAIF+StfoV7Txrz4ZItH+CtTY/ORUzHcY1pp/syQafQQW4KdBPP1czhvckFROLDoJRCCkLiIcuiy/uBV13WGuflBMd6928PizvYoXEZj85HjiZj+LpEd8i1oMG7Idu/5sZyLCwboJdDCb5ABAvYNaT52dkQO1D+3+NwSQfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTTiSLHYMEpr5Oa1VpCpeHZA5GQk5B7wMNkvjjMomgQ=;
 b=poSNjWL8WPiz4MUQcR8CieQsjwawO7ZpPVn7mnX/l3/ldFGiKQG1npKGH/CVd2qBh0UjZLZ1VFgfUBSLeAnLKyvvXLbn4B8ttOQvluKETxexJ2hiqYJ3zf7cPLt1zVu9U9uSP3C3tzerWq5k+nfFg/m/ebxkCZbBqAW1QXlqh7I=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN6PR10MB2686.namprd10.prod.outlook.com
 (2603:10b6:805:46::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Tue, 12 Jul
 2022 11:03:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 11:03:46 +0000
Date:   Tue, 12 Jul 2022 14:03:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     pshilov@microsoft.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] CIFS: Fix splice read for non-cached files
Message-ID: <Ys1VBuMKjFzjth4Y@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0134.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 436f764d-8fa1-4da3-f5db-08da63f6313c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2686:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jvp5PvyC0zt7H/6HNqqHaXlsc9q15T9bvOkhek/HFL45pVP7GO4GxI+KcMNaU1fUZpKzCFdKp6OycgiqpGkMWsuQ/t2cwuUwGgZU+T7oZvUa4Sri7eWP4MY6bq9HbpM16e3As/W4HNNMJAehoQN0pT6SqUoMvwWALY17CRE6YVJLYWRmQ2mAItwmguv8DXNH+rK5pOF9ktw8vUSbwO6ny8U4+2e8D0bI39aBs0NscxLeHqH/DyeUGWcl6unFlYbTmWQ++2wU4lY0GGJ4LpYkizqmI6wuqhqXF1oe4IhfnU73v7zyPNDea/sknvMlk2wT01DsouyvYhiIjrSOP3p6wdIF7jxn8XRiRxcLTI/0Ebp/6aXKJTiQTvRRuKW7QfUMTOb3k2ZAaHZEphOVKNm1Sc0IhthL1HtzyO85W5+NSwMWduGcpAQOovkze+uuTNUlG2kMZ6q6gOO7ifhicPJehdkwp6gE1HGj0vvRLmytVydq4JrX1dSLptY85i4gaaRlb9101069gZcZucUUPnIR+Gwept3iWjN4mOrx6Ozi27gw0Km4kap2WUCVwNoaf/KDR8wJjHnhO66AsmzJVVC2ujIJMn7/ADaL+5h3inN9LQJC0pF/FbCafW0C/aPxd7f3USYHCLf/W6cIScL2RhbKcPE5N3IqTSWWq4zRUy/CeOr24D1CGJX42RfugBJq/I5OYHv/6akZmf/MG411tVfa4OikYitPPvZ9fpjd5lTGof3YNZL71msLBHrnJ/SU29jCTPXv/0lTmIEBpRjyboPTTtd6aE4ptdwWrAJX1rU96mIlfUmz0WpASz6VbgynHQDA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(396003)(376002)(136003)(366004)(66946007)(5660300002)(4326008)(41300700001)(66476007)(6916009)(8676002)(83380400001)(6486002)(66556008)(8936002)(6666004)(316002)(33716001)(6506007)(478600001)(2906002)(44832011)(86362001)(38100700002)(9686003)(186003)(6512007)(38350700002)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g+Rm2OmdVrGcCxA9cjA7AhkVzQJ2rhNV2o4OULGOUYNVuWVNsGQhohQ8eAIp?=
 =?us-ascii?Q?mGCuqU3/apDx5oFPQfLxm0b1Eor8XnVU6DdLi4iMf85X6OjO4r7gOJcwKRUN?=
 =?us-ascii?Q?fXejMCPYW/BrLdPPf12bL4dWEjixUM6shdEiLSUiSIiOSVGaiQg578+GKjYl?=
 =?us-ascii?Q?myORcC6C0qxjQDNkbh07gOI4r4vZaVLkgHjrlsDTZw+CD+JfIptPdBD7Qian?=
 =?us-ascii?Q?bIu0ISmfAluicQC1dFsLJEq7s9YBJmkOFeZk5RtL1eRDus5+3hndCsG0Xljw?=
 =?us-ascii?Q?006qafxa6IKMuLXXLpQuBBmwDr01r8C4HWZIGDqEAGa5VROKe4U7o/++Scsi?=
 =?us-ascii?Q?YZrxcANquH7sfHQUSvecJcmhyL/QWDk3FtmIjQoV2fJCVNeriXDN5MsbXc6X?=
 =?us-ascii?Q?j3erl6G5Q0fTY92mGM0Zu38t4hC7gD09nXjEWHcd+FsK/i4CIdOJSGoaJ6Jp?=
 =?us-ascii?Q?hMbavrI1fyrQhZVhe32A5o7xWIn+QmaZ3G5Uz6OCa8lZHcnNTej/0Qs5PL1K?=
 =?us-ascii?Q?hZOso3C3J9lXW0Xo8adrrF5LmcWeZImqqwjIDylsqc8fmGMxWhNzGco2T+TP?=
 =?us-ascii?Q?RDXDnxxtS6CvTEOITBeDISca24pbEYNtSPy5AEy9K2Z16afwFsVZkc21O3+a?=
 =?us-ascii?Q?Td0Vh3CYJHATkKVXMpnv0l+oiD0R2Oc3JJ7T8f+bV2XqSpP1zIR9bfXnXAGO?=
 =?us-ascii?Q?N/hnvVaKxk1BGi80Sr5JHrtaSAaNsNhQEWF7aUFhE1klMWerE6RJdJ/4ola+?=
 =?us-ascii?Q?GZJdMUQ8kAwBqaEUVILvqC7yEZIjCSKGs+viF/lKTqEuJ+jjJzj1pBl3x9Or?=
 =?us-ascii?Q?C16xtEmVFhpNrXIgn+shZhCX8ldoDJZctqxI836254o1FUFrNJE7rIhuieY8?=
 =?us-ascii?Q?xl5BM5r584xFkMxL5gCy0jk+GNRF9dYrN+O0oYfrhBlb0487gXU6fRtLI8+8?=
 =?us-ascii?Q?NfCvSWPZDG/WFrdAHHqLifkCyGqz3qkGVzdsENxp53YAx9NzbBbBoEXdmUx1?=
 =?us-ascii?Q?L+9VtQ83xzNcYbg/U/BRyHukIE7Ati4E5TPDQtJEnPKvA1jaw3i+E42ogQMf?=
 =?us-ascii?Q?30Rxoxa8tRCuceyFBMq2mw4dnJwVX/2EuMPppTB4bw6YFSt5akSLegxJZjrF?=
 =?us-ascii?Q?/8EjvklXg7Wm3qSwCQps/6vYEoj7tGcszdJeBA08iKYoRIAtZ7DcHKCCVNan?=
 =?us-ascii?Q?5qgONIBGyfW2nBPvjnmG8H/Ys6tYFLxr/I6OhiOnwGRhW1I/eZ7gQw057pQ6?=
 =?us-ascii?Q?m18abX5c4lhxwTIui+pCU2HAoXRDWakki6qdjKc9AeOPLSXcyso/KRIc6AxJ?=
 =?us-ascii?Q?UtYmocjhql1kYcmR/gfC+NoZA5kOpLm0jupa4eYEdBhVIdpo85aBZT4U4XjD?=
 =?us-ascii?Q?onmwsT3D4czNU1sJZWBXatL+wXZCLfNUABjIqhNbv1n50rROGMi0uOdUx+QD?=
 =?us-ascii?Q?9hqcvet4LKGadBKs7TC2tMl6dAli6AAMdM7HhybACGP19ifKs+ExtuNf19y6?=
 =?us-ascii?Q?gBN4NC+ExzggigAHamefOtFFm4/d7zbkuYSLI4tKNqAd9F2ByFBWO+QSYtXP?=
 =?us-ascii?Q?O3F0WMgdmCLXakcRQ2Q6aNsqmJr1NDes5teiq2eOC+stjeKvODwCRHn/p1iH?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436f764d-8fa1-4da3-f5db-08da63f6313c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 11:03:46.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wfJYBta2aoPmnxuazpQirPvVmBwgiQd7JW3SY5xWa6DtpeqZ4F6tTplO45iVrr9kRs2Ge/6CWrlUUqb7L2Fi7wyRzDFvZeViDvlEt1pxYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2686
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-12_08:2022-07-12,2022-07-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=860 mlxscore=0
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207120042
X-Proofpoint-GUID: nGtTXG41WpK4W_OuY-i0phLIWbzU_d7z
X-Proofpoint-ORIG-GUID: nGtTXG41WpK4W_OuY-i0phLIWbzU_d7z
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Pavel Shilovsky,

The patch 9c25702cee14: "CIFS: Fix splice read for non-cached files"
from Jan 19, 2017, leads to the following Smatch static checker
warning:

	lib/iov_iter.c:293 append_pipe()
	warn: sleeping in atomic context

fs/cifs/file.c
  3524  static int
  3525  cifs_readdata_to_iov(struct cifs_readdata *rdata, struct iov_iter *iter)
  3526  {
  3527          size_t remaining = rdata->got_bytes;
  3528          unsigned int i;
  3529  
  3530          for (i = 0; i < rdata->nr_pages; i++) {
  3531                  struct page *page = rdata->pages[i];
  3532                  size_t copy = min_t(size_t, remaining, PAGE_SIZE);
  3533                  size_t written;
  3534  
  3535                  if (unlikely(iov_iter_is_pipe(iter))) {
  3536                          void *addr = kmap_atomic(page);

Should this be atomic?

  3537  
  3538                          written = copy_to_iter(addr, copy, iter);

Smatch complains that copy_to_iter() can sleep so it leads to a sleeping
in atomic warning.  The call tree is:

cifs_readdata_to_iov() <- disables preempt
-> copy_to_iter()
   -> _copy_to_iter()
      -> copy_pipe_to_iter()
         -> append_pipe() the push_anon() function does a sleeping alloc

  3539                          kunmap_atomic(addr);
  3540                  } else
  3541                          written = copy_page_to_iter(page, 0, copy, iter);
  3542                  remaining -= written;
  3543                  if (written < copy && iov_iter_count(iter) > 0)
  3544                          break;
  3545          }
  3546          return remaining ? -EFAULT : 0;
  3547  }

regards,
dan carpenter
