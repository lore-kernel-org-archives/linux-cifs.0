Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74764C07E95
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 10:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A5D361C92
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jul 2021 10:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhGGKO6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 06:14:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:39170 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231195AbhGGKO6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 06:14:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167A6nGW032693;
        Wed, 7 Jul 2021 10:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=5LvUyHqmx37/u8y/79y+jaFZadVz8g4mgsLDkEacsTo=;
 b=gZFRSZfswqCWLbJ9GSkEFx+8GQ+ONB8pC94euxZ5FFsOePRgGV3bfEnyeXj6gFxivXG4
 DUXc4nQGB3Pr575kS6+hWBNE0tHnhPP22RSjx2gIlX4aiiDnNJV4XKkSWqzb/N9RlFIw
 ghwAj4TIhRclCLXdlNkBVev7po12yoFBe1YLHUVbTb4dEa84uq0/CpcWhlZa7ShaKSS2
 lJgrsF/Nhg+Ap6sOf2SiOxrGARC268BYjOMMGh/8McjjtOpY/1Ec7W+qi6pE2lNePYtf
 RMnqauuxMKVZD1F3LxrZJJV/lP2BRSCd3ZDJq5XIVVyUEpxA7aS47wUglnIrT9LSC5AQ 6Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39m2smku41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:12:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167AAWoQ034454;
        Wed, 7 Jul 2021 10:12:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 39jdxjwac3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Jul 2021 10:12:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N00KE+mKggh//8UaMxQBr0FiJ1GqxNIPR8wuL8BK1SWHEAkslUCT5+bCtb9v7KiVYQ6DKtxIODZurfxKkV/V+eowlSBkPi5WDgy3vVlPHsGzpP9kMAAigCrKPLiY+lISa0Sq1azENVSOihUvjnLw8N5/TmqpASYG8g8ezkFJ4g9Lp63r2eS2lUOEyOxbivxyfGVAoI+71NA4pZDn7ArP+jMFkTDLqm+oxS8+o7/VV1H5xIJi0CQKKQ7ZlIDFOuPXLGgo2h4K1eucOZ/fnYPYLytAb/YLqPUXFgP0e2J9AExXUSiK1ZtEcsR4GVTHX9aojPJF7w3nq7Ju/uX7/GA3gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LvUyHqmx37/u8y/79y+jaFZadVz8g4mgsLDkEacsTo=;
 b=frAOlg8/kWezQ4MU7O79Vxc8VJSOjqo9jOMHBROnK4wHGB12Q+0WYSnUopXij/BrWk17oztRa0nJm6eU9T0bEUCwEybIngalqFqGDvvvjYKQwXlPbFGk8funCuucpFvq+dybZRGw6v9Qe3GubAQEq9R+Zq6VX1kqM5CRKDbsLfrTwR4izmdgvWM/4t7uFxrfMQ6QgVSSFf6opWmgkiw/8TPb/AcfvH7aHBVebgTqpsfugRCGjK3X/IfI0rebk20To4KfiwoCf0tAsNgk1/DZxr6eQJyEiq6s0xOVoTVt4i2MMvZphqEv3wKtfhItpBEBb7U6PqjL02JiDruP2+Oo5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LvUyHqmx37/u8y/79y+jaFZadVz8g4mgsLDkEacsTo=;
 b=yrNdlqSDGMUHuTxO8TUmTJ4ptSn4I1KuVUG/FUBuK2nqqCNY4MPonkemzirM+qDV98qnQVy8ldicrDj6xOZWRnqM1Hs/cj4MP6Z7hY7xgqhRNBKIf235U1lNjSYUZQ57UlWvwsyF+P8Q+JB1I5RAAjBSfWIYmqQhhsX6zr4d56k=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1821.namprd10.prod.outlook.com
 (2603:10b6:300:107::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Wed, 7 Jul
 2021 10:12:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4287.033; Wed, 7 Jul 2021
 10:12:11 +0000
Date:   Wed, 7 Jul 2021 13:11:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: add file operations
Message-ID: <YOV96UFhrII4qwXg@mwanda>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: JNAP275CA0027.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::17)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mwanda (102.222.70.252) by JNAP275CA0027.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Wed, 7 Jul 2021 10:12:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc410a7c-d8d6-4606-3568-08d9412faf7f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1821:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1821DEEE9584D07A665CF9508E1A9@MWHPR10MB1821.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MgsKDaFm+sTFMLz4uhLtMJjFIbBAjfFXMI9w253/hD2THTcp/+2WtBhtrgg5tU4FTAWR329RVeXOvvr/RrO1fKu2sSSWURjdvJsEkc3ha5wkcVa6O39m6Svd5JH395yl4LTXgQsSzQ+Np6fArouoWAzGfD/zC8Flj1VkUN9dEmxuLt434HGt02omlvmHeDDINALw5OkAwe0WpjFEzRH1DpuC9pJlwChK9+k+SLPim9QpLorFyHB34dV+STM8/kY44Yhy9uaAnoAupEQkrD27fzly22YB5TnwJ4+qkVljB+oTswTnmuzk1fO4ZoQo3CO7Nrp4OS/IKC8251aYv5sUm2ECtOwkv3kDVRckubO/33hR9DA7bl5rR4uxrQTXjD1erDmR5py7Wq29KGL2zoUs2dQozCxQr4sLUl+uQqyWnauw8/ODaI1tbNU+zEWJGp+ri7tzU9xjWzDXC81hoqErQb7uM79fY78GVdhVFaf+crTq4swgmAvXyBdH4zHKf/yo2UgubGiGolWuKwR2HlQYLUG1woQ9oNffljy1vjF3f62KXApQc4f9weKDUpGg1oxB/hsXea6WM9wqBi9HwH+FwXq7pamYDikBCxTSClGAzDn3Hr9adAe1gHJfW3JocxZkrL1k20T62DNBXRWEhXqUWTsWCMJywY+t3w/FKsFjYD/agXqyaxJO8icEXowQQZ3wbw1WLItjaTW+985nwS+Ezw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(55016002)(2906002)(8676002)(4744005)(9686003)(52116002)(9576002)(4326008)(38100700002)(38350700002)(6496006)(6666004)(316002)(66946007)(44832011)(6916009)(5660300002)(478600001)(186003)(33716001)(956004)(8936002)(86362001)(26005)(66476007)(83380400001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CdG3MupuNGlIMl8I+sV9rgV+3rTh/x5xa/t5aSWwoselYwFCqBJAaTqmGn79?=
 =?us-ascii?Q?oRfXC0SRy4jvRZTxNFOmYGSWHdGhbNumtCAMEkPrSJWmz9OjcJeiePzEQOnJ?=
 =?us-ascii?Q?5dx/rs7bbfKuANCmgpCvMzmwgG+Q3lizQMcwMb1OnUHubMHVkkMueHVPF4qJ?=
 =?us-ascii?Q?+w0lrOLNvlXNH9D8pbL1SvDgDCGdiX1+2kadTkbw2MrBm13K6ynNjhRSMhP1?=
 =?us-ascii?Q?HRctomTRi1wd76pO8LRMmkbjssRInRr8z0fLOGsO5Ob4/mopPdB/CMpQNkX1?=
 =?us-ascii?Q?rC5cvc232rEKh7hMo6Y8fJDTF9rA8gyAaN0E0jiTVYeVAUhlyOe2pYUxTr6b?=
 =?us-ascii?Q?An7cdwNzbo5lso++6lEaUwxpBv2rkHQ5auPEy8M4zH5gvX1KLUgBIOS+IXWz?=
 =?us-ascii?Q?2vAs1xSyAXEytllQ8SJylyO/yjj4xV07jFxsrx+wX6EFk5/t4c5Vvf+ynqIi?=
 =?us-ascii?Q?tRK2qyyd7KyBpPrnRw4nDwFjxSsg9CKf+BjkpfSYiFWQMozB6TOtBGPC6xn6?=
 =?us-ascii?Q?W2b8wJn7tFJRRj3omRGpD+ZWmG9ukwqi7rmlWbXuSCjpJveg2NBMLPXE7mV2?=
 =?us-ascii?Q?gJqisL1LZ6Qq41qLzcRo24A/5oIUS05wNnnioLlDPY6e7lApRyzMqWDf8GkM?=
 =?us-ascii?Q?HLA/+qczCiOtEeoUSKcdD5yALlnK1gB4ZzYW0dHfLS1hzYDD5UkJPqlKa/Tm?=
 =?us-ascii?Q?YGtuU0ByHn48rHq3TP1pSq3EGxlQvjq0r7B3fbzP3txw+Xob1tIxFQbCFP98?=
 =?us-ascii?Q?sF3lZ7XajRqUFNuQ4YBgm9y3Qh+NuOEh7TQvTAw8DUirwoXmI47arB3rIyZo?=
 =?us-ascii?Q?k4WIaFXDqQlGw/SMbVr2GjS6Bb1hLWKWeQzxHFvUMV8OdOIgDwUtRSai8U1r?=
 =?us-ascii?Q?51u6X+DutO8yzhL3Hs0j6E95mnGV5Hu27qlwqDejE2Zgb7Bm5vLRJulCAuSn?=
 =?us-ascii?Q?saPaqmhrVm2G1cNr3XLOHdfcxw5i6MznEKuEVv3V0HUE0R6PlWozfkI8C9Ui?=
 =?us-ascii?Q?fUIwoL4Jim+VJVc4u6bR1gL/ctCa5SLjRmstD2d2Bnvg6kw096FpMAi4GDMU?=
 =?us-ascii?Q?yaHAOv1VA12BubaR4UTqZka8t4yVd7uZUsByF+3ob/Q7dKyT8yInScVRzlpE?=
 =?us-ascii?Q?6fqkXYy70Mb9tBDEcDFORUD853pcw+0MTk7QTmiQuzT/4/EDo/PJ4oLF5raG?=
 =?us-ascii?Q?YEjOBxqaihbVquLW2HkD0OTnlz9A3ligiQom3C9uReVas1HpzWO+SNxBvHlK?=
 =?us-ascii?Q?WOUeW86zXVMryEVTjhMZD3kgiIvQAVvhRrPJa/8B3kX6dP+Or3juYGmTlbGA?=
 =?us-ascii?Q?DoRZlfW0h2S0T7Q/0QZ5EClS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc410a7c-d8d6-4606-3568-08d9412faf7f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 10:12:11.7521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNa2FfTDFmA8uHM2Zy4oGI8qluvfbc8HdnGLUOSSIUEgD3WZKfXr+fr1OyWHSddwWzMRGr5EvVhYAbaONXera02QZgX7btlKuTvv6UC9Vh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1821
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=594 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070060
X-Proofpoint-GUID: 88b4ubZpqcmn470d2UTca47zxbPUU3oq
X-Proofpoint-ORIG-GUID: 88b4ubZpqcmn470d2UTca47zxbPUU3oq
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch f44158485826: "cifsd: add file operations" from Mar 16,
2021, leads to the following static checker warning:

	fs/ksmbd/vfs_cache.c:661 ksmbd_file_table_flush()
	warn: was expecting a 64 bit value instead of '0'

fs/ksmbd/vfs_cache.c
   653  int ksmbd_file_table_flush(struct ksmbd_work *work)
   654  {
   655          struct ksmbd_file       *fp = NULL;
   656          unsigned int            id;
   657          int                     ret;
   658  
   659          read_lock(&work->sess->file_table.lock);
   660          idr_for_each_entry(work->sess->file_table.idr, fp, id) {
   661                  ret = ksmbd_vfs_fsync(work, fp->volatile_id, KSMBD_NO_FID);

TBH, I'm not sure what's triggering this warning, but ksmbd_vfs_fsync()
takes a u64 and fp->volatile_id is a u32.  The ksmbd_lookup_fd_slow()
function takes a u32 so passing a u64 value seems like it would lead to
a bug.  And smb2_flush() passes a u64 so this seems buggy.

   662                  if (ret)
   663                          break;
   664          }
   665          read_unlock(&work->sess->file_table.lock);
   666          return ret;
   667  }

regards,
dan carpenter
