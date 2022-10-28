Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22128ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 10:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiJ1KjX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 06:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiJ1Kis (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 06:38:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F631C812C
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:38:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29S9ZLZR002277;
        Fri, 28 Oct 2022 10:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=gb5k+n64nIB/pu47Y1SpGRBykaaWao6gScieWbQBlhU=;
 b=scRfG/nDWt7/HCYXVMd7bsdoxNvkIZRVXA4dJFsLMBZ9SnOyECsGckfrF+hgm6XNwdTW
 AYmGO5pbHUgefjSmj67SZj9x4GkpeXchpdDepO0QwKzVxEEUU48KJkKF2IPkOmqBCdZn
 TjKGAUEK8WqFoRAclvrIYssS5tEnQM9EeD9qBLl62lmR5yF3YJRQ/PXeruimwVHDkW3F
 G2GyXNnFIP8m55bjY/qcPA/bPWaoY9Y9GGrxw6DxXQaAeohla78k8lpQw2/2mz9V8c8M
 IYqplluLkHOPkkwnrg7vi2Mu7ft1jpAN2QhcxQR4DhOmFyG/lUA0zdGiF19C4V7odXeT xg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0ammmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 10:38:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29S79EZx017431;
        Fri, 28 Oct 2022 10:38:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaghengj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 10:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8/6G6o0/XKcoBBTOPsywnTOL6KAjV6nBSgbWAQWEViA4/yZvH7O81uQrJxQBzsmcFpwmsJ3RCGJrPvPBRqat9O8qtFWyj0epzifdsOEJ+sYm/gpu93ALZ1KAu+pIOKgQUQovVo0Uy9hrMMUwNZpeEujkv7nOfAXPwF+/SD7HOdkRmDSWx1f8PrRMQ+9yBokffLtH+Q/PmNJpqO4W9B4jYq/gg/WsBNp32rg9GC71UitE/LEI8euLpeQ6sqM6YoC2oonXdjKn8FKwkb55Og+/0P9A0chdDIBn3D4OSuboYkQkiIaA3eyllb+7iqRAS3qs0VxZt3/Tgvwj6PpM9yHIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gb5k+n64nIB/pu47Y1SpGRBykaaWao6gScieWbQBlhU=;
 b=SwPZQQKxi9o8hO88hHuEWuOhY2FwK5NJr0RF5ECUZs+m27Y3K2+3Ixd5RjejcY//DZaZyO09adJWwE96KeqHA3k7BkXhEHTBKzw3VCiSxa2Icvuz1EeoYmT+wqnUoUDUx2yQgXQZ8ig/+LrumNFXs2//OiiBhDFuV+sFM5HQh42whqJyb1yTG8cLe9gybx0vPLrPA/ZdL/CNeXPNQtn9Hgw6glDNBMgGVEd1OPigHt6D3gJEMRsfFqTEZVGXdQdogDRvweGpCHAZuxQtGPzi4SWYvhe4w2sr9lcP1UTk8Pt4oZGuoYUusZMlNk7zfN9rbRapAy4/2O/ZwDawE6GKhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gb5k+n64nIB/pu47Y1SpGRBykaaWao6gScieWbQBlhU=;
 b=OsmQxe8EgIBWON2niFKmzuw6uKna/1ZL/eA0axV0J7Z7rcQsGmeEWe70CLW2KLJD1cHC6NBNnkgC6bZStZbWNqmlGw+9LmlJ12ldnfX8ZTEvssRzcnAh2W340i6uJQ1kGh3rfscd4COlRX2LsKnuc+lw0VxBld8z5xa24hTtMoU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB4823.namprd10.prod.outlook.com
 (2603:10b6:408:12d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 28 Oct
 2022 10:38:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 10:38:37 +0000
Date:   Fri, 28 Oct 2022 13:38:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     brauner@kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: implement set acl method
Message-ID: <Y1uxJVwln0+gTaFz@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR2P278CA0020.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:46::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|BN0PR10MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: 1965779c-358a-4aae-12bd-08dab8d0923c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yu9je7cWTeqNl6hBNx+/RzjReIjavFaDIwH3jGss/T1cojURKSBcFShJU2pzDYLbbROjjytvo+DDvsU3upN8YAa3oj8jsSd2CQ03zyi0fmjrrFX0Q6yLzj3CBsGScEhTx27UpgGYuMp42qBL0w+3BRKbBhZfSvPx30oUe48Cfy0zjH5J/f1sfTzeF3JC1QZignp57yowSkI1DN6CmYYRtfvxtUvwMv4xC+6punlq7/WCiW0FeW0fzBu16giQkSsLm9ZPmvMJPDAX5v89X/n7Kmw384popJydA4dPKulT4xzNomx1DgOz4QSI7sPUIwjOl1dcFAT24rVdiZ2Bd3dT7XD1zESfs1bqCEfiiK79nFtn1AwkZ/hsaD5arAICaLxhmV4eVGI5ycn4H1CMTyz0R7qxGJhvk3oPE8EO8ENr6s6/FxDKkm8dnKw8MnfvUsv9hDuMkCIneMDdsHoqJKnnQy+qFX7vek8+57JHAi5hek/4ATSbQGZGOXSu6/3/B+dlWOGPh+K7J2L/2oktmNvfu3FFhTyHvGRl21KgoMsvnFZVpH5XqhvafQfgUqbgCYqG7Vbn36lNezu+8LWZ2hlk9r1cGsTrUIegVjYHskhLd5W6ltbfdrv4Rc8PQIv17Asb7XNiJSfk/k2bh691WjK2n8plypXR9X2l0PRmcL2Env/FPBj5d53MFfIpmELLtZQ7g+V7Yu/WEUu1QSUaYbOF6IDvZiICLnmE3LCVsqAo72A5Tpev4wlIqpFyDkKK7CaG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(66946007)(6506007)(4326008)(66476007)(8676002)(83380400001)(2906002)(4744005)(44832011)(41300700001)(6512007)(9686003)(26005)(5660300002)(186003)(66556008)(8936002)(478600001)(86362001)(38100700002)(6486002)(316002)(6666004)(33716001)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?okGR8JPn1MbZamaY0nDMcXkhwuq9EZMnmVCuEYI9bIcYRB6XZHJLddARwnI6?=
 =?us-ascii?Q?XouxALTDvtWe36FJP+w3c4A/dfYduBIAAvvmwopCU3TywNYkBgfG06GgMFAT?=
 =?us-ascii?Q?cuw8MUk/9EOlaLAeD0do6cD7o5m2omtiWse89jtHDzRwHUaugBYssWvHQCsx?=
 =?us-ascii?Q?jSnq+irajNjYi8ypCVmzCSMl4G1TyvCXvvwyFXCmYweGqC+JQUJ0EJihJFJV?=
 =?us-ascii?Q?0g3sXqsj0pEDGCiKIOxpjT2pl4sKKQtvsFzEqMyeLMW0tVVzaIuv6PFYZyTR?=
 =?us-ascii?Q?kiQFiCcTbNW9eEAcvqNTqArVy847k4nzZ0x0LLbIL77RdNDEniZDjyerSQJs?=
 =?us-ascii?Q?2OIfmRMT3nkCSyUS1h+HfGBcNAJIlgXrieNXBmp0nACTIm4hxn4/S1VYnvXf?=
 =?us-ascii?Q?/yAErhsHWm3xJrj6uEApF0E78tepkC9vQbGxL9OE7W2nweMoWAGlK7bTi/88?=
 =?us-ascii?Q?VDcP6xBoZaPWc/yE3w+t6xSUsNcQJUa1dgrlr6gx/+2ATiJAL+f1Oev0Q4G/?=
 =?us-ascii?Q?tIj+YZLZ/A7+9GsfhZKx7wbci/6Bv0uzqKq0zolhv19BMllJmJRXijCmj2zF?=
 =?us-ascii?Q?ahx0lMTCJ+MD67MygRH4SFJQsPz+t8K97RxMspr+qQzbZb9vMrE8T84T3Tam?=
 =?us-ascii?Q?FRoj1gu4xh8B02nHs56rgx6V/41XHsiBEkjUQe13NM6CORwRgRBbQzlN/SBV?=
 =?us-ascii?Q?wbNiK/PD6SxCHb1YlKdsacty3e4RGp4NAktHePgmnWGDFyQ//zo2xmFL5zu5?=
 =?us-ascii?Q?p4+XPgNYOFMu9vrhz3o/6CDNCkuzhQL2NLGiRDAtOAdA9D9/MRBQVFu4csY+?=
 =?us-ascii?Q?JlbDmYV/Ic6ygfS/YQGBD4raPxT586XwfrfjHwkSnaPeSDSsYR09ppAwd8w0?=
 =?us-ascii?Q?wpkd9q7djpMaKIpOdCjY+Y/64QINWhmAMNjgxx96xYtkkhnpLPfYzdHB8qCZ?=
 =?us-ascii?Q?aPD06ojXBcyY4FKPahDr6MrI8VFTBUTsxydDbp+sdjzXXMfCFnr7WTZ9akbZ?=
 =?us-ascii?Q?QWzzb8SSS9aUuXu7B/kj0n2Da4vwtj8QOgq2827ryA5f45J4i2vCIbhGqxgn?=
 =?us-ascii?Q?Zdi+R9cKDA3NUZa9H3Au2VMq7s9QvZzMlzGQCCNslf+C4CiMGMQOQFMJmQ5A?=
 =?us-ascii?Q?rcXiOqmAn15ESS1Tt+onwEq1Qj37bWoKgFnuDpm139fcjeHy0AWCdbjZ5JmY?=
 =?us-ascii?Q?kF3M4FuwfMEkYkhCB1Ftuaf7+LN7X0sSlWaHbUoq8Lp11imXcZUKsAneUUmE?=
 =?us-ascii?Q?wDmYbY8N154oAPpmLDQW9kDUsuWPydJSCENNQ24rNbcJCN0SQAIlyBmAlB+D?=
 =?us-ascii?Q?eBB/CpxwnBh3YN7OoUgYOiUV0aTgfs3VUFOEglas0jhmk/B12BHf01vgsGgV?=
 =?us-ascii?Q?7JpbJ4lK12wwABgjHBAPuqv+RZxj58BCHTwIjy0zf77vJv/rlDb3i34Zdh5m?=
 =?us-ascii?Q?xjyavl5jY8RE2B3hFFLtY3HX8uUTw6o0IqXZb+l1b6EH8Go/3JnR+Ka1TuUx?=
 =?us-ascii?Q?RIExXSAmi7Q4zKF2fdCpKtHYULvEg23UkxUfeOK53xHjA4kG2ypsGAr7EK1v?=
 =?us-ascii?Q?mXht0XNKg/CuSxevpA8RiyJkGWqGAA6XaTCXAelYWyPN96eTNi548kl618Wg?=
 =?us-ascii?Q?2A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1965779c-358a-4aae-12bd-08dab8d0923c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 10:38:37.3715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HuBVHOm2DjqoabV/iVn2s+k+qkBiEeMNmfZjTGtTC4FIWuNMfX65op65ABsZR8ctw6jKhRc0MXv2/jwkzC0ubfcoLhOT1uqkjsXelKg6YaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_05,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=338 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280066
X-Proofpoint-GUID: Byra8CbyZ3ciWUr8RchXzzzLGLhXyrFC
X-Proofpoint-ORIG-GUID: Byra8CbyZ3ciWUr8RchXzzzLGLhXyrFC
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Christian Brauner,

This is a semi-automatic email about new static checker warnings.

The patch dc1af4c4b472: "cifs: implement set acl method" from Sep 22,
2022, leads to the following Smatch complaint:

    fs/cifs/cifsacl.c:1781 cifs_set_acl()
    warn: variable dereferenced before check 'acl' (see line 1773)

fs/cifs/cifsacl.c
  1772			returns as xattrs */
  1773		if (posix_acl_xattr_size(acl->a_count) > CIFSMaxBufSize) {
                                         ^^^
I looked at the callers and "acl" can definitely be NULL at this point.
I feel like it would be nice to check it earlier and goto out directly,
but I don't know what a NULL acl is for...

  1774			cifs_dbg(FYI, "size of EA value too large\n");
  1775			rc = -EOPNOTSUPP;
  1776			goto out;
  1777		}
  1778	
  1779		switch (type) {
  1780		case ACL_TYPE_ACCESS:
  1781			if (!acl)
                            ^^^^
Too late.  And later on there is another check as well.

  1782				goto out;
  1783			if (sb->s_flags & SB_POSIXACL)

regards,
dan carpenter
