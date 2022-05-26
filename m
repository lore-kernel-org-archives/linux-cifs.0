Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F288C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 10:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiEZKVR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 06:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232742AbiEZKVP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 06:21:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D355FAF
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 03:21:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QAGnfi019131;
        Thu, 26 May 2022 10:21:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=wIzADPzJ9MyuEuYVkiWMNVaX2GRVhzCmy8S7LZAHAEY=;
 b=0RpHjGfD5mLUjOQ7Ag8O4STAsIcrQwgB9YNeOzNG9AVEtaUf6Grx1PEGEBJyf/9TCC86
 4BonZexa5TT1wZymMfff2KJpnpKeI6vhQFPrruqqLJbyPZqWKZP2c2nPwxxGTdRbvPgf
 4w0lqHt1HBnbe91l6MqS8N2EDXiDO2nfrlD4N1wVE4vVIxPbMLJtog5HwDm9vgw6RcWd
 X83dzciNuhbnaCB6oUr+gFf+AoqjuvTsEG9njNdTm1hxfXbEyzqTUTebCs/LwB6nk6q5
 wMWh/8d/SzVIHcmxrGHm2/3FgPrHDTrU/ccHVocgyflBbh+uybDnZcqJXNlFdEX3wYY0 CA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tavgga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 10:21:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24QAL3Nb014782;
        Thu, 26 May 2022 10:21:08 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wrbkev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 10:21:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ks6WFx4639YGKM2tRieGDEuVLJCvCZdLWBl6Sy0MR5s4fiRTW95Vb1qblKDT1RNUdeQTgC6RZqwIyStAlo32oVQ/5piVGYr9ubP47XcccykXiDETHkNrfMPXj04n9tQPNJosnw06vK+rC7HoJrZUf2L7cAMnU4bd8JfMT7JgZmHktEIVyUfKtuGt5vzmh0vK4mVetlVCIRNmZ8aJsubsxeAs6U2UIM9EazScSTdXGHbffnuyDTniwCVe6husjom23Avh/fi/n+ES7ADxfaHobWipLaGfdo/gQd4WMCCQasM3/0gkYNPpc9HilWm7kkjw/wtDJQIca5tWyVQSrIXJzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wIzADPzJ9MyuEuYVkiWMNVaX2GRVhzCmy8S7LZAHAEY=;
 b=L+7JQQcvt+Dsdrcmf51KFm2dxATU24Zaed64mvDwkPDVnPwXBti0RRSwg/K3KXlfNh2bgsdg1JxfcpA8J9ltTS+56PVlzI2emskpr/5xMuTzFTc4G0h0oqEknoAtkH4XIoB/nkY/NNFdRNhzNs6d0qgGEfKj0KCOWdpseREhgjV4CKaEwgO5U/mpIl9cPT0vOO4zF+UeNax+RY1I4NWFvp5uv3F9YhC6YbnysPDyO34OBkxL6neqPjwOQmzP7YmM0iwa1wCGuEHSF495mk0Rb1h8w9AeqhXRcLW/WbOUWy8pF0BbT5SSO/9I2lYCHLzXuSAZFsGe5S/Cs7mpigHaYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIzADPzJ9MyuEuYVkiWMNVaX2GRVhzCmy8S7LZAHAEY=;
 b=q0eh8Ke2EUIPHMGXUIqYQ3Oh2jJH9jqUewvr9VlLuVcW2fpz/HiDXr1ejC/jNBKYJa6SkPN5bkyhifO8tlc3IUfXR6XlTioCf217CmSbtxFIyo2vSKtR+lXSyfbLFu/9xUL5Wm6oEmGML6aH7ULu1rd89Eov5VouB75CWsMCXI8=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by BL3PR10MB6211.namprd10.prod.outlook.com
 (2603:10b6:208:3bf::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 10:21:06 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::414d:9b62:3839:f00e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::414d:9b62:3839:f00e%6]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 10:21:05 +0000
Date:   Thu, 26 May 2022 13:20:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: cache the dirents for entries in a cached
 directory
Message-ID: <Yo9UiM/eFdyd3HZk@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b036dfa-2724-4ee0-e3cc-08da3f01716c
X-MS-TrafficTypeDiagnostic: BL3PR10MB6211:EE_
X-Microsoft-Antispam-PRVS: <BL3PR10MB62113B7947212B60B6C6CE368ED99@BL3PR10MB6211.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/uFtSlI+ebqT1bX0G0fZC73eZGOEYeX8zX+0G1zY1MOseHSlyN8LBatpyIYxK/gZO5eN1R2qFhEFE1of/vP0DTvsZs6B6eVx3cggmCJGz71VsEKX8T9k0k5Ne8A0puJvyf0sV/UYtzD0GP78tbC0Mf9vC+P8Ez+J//bljw3biRob/yOl5Y6IQ5bOaFfbDYo0rJvZGp+4Nt1hfMncaJR63QCHS6slxis9M60QddbLyws9pQ4XNJueuwAzkKW9xuP0oCRlymN1cd7FbLvDe1/bWxx5B0J3i5dxb6U6jHVU0SYtRMFB+hUIZBEGkrA1nRRq+h0QrhsR4caMCZ+LhjSSdrv4Dx/8BNzWK9Lf2+MhTvV4jBN8QA79dWGCe58l2Ml+jvoEexyN1ln854yoKyGvuI3jaQo0CfFEkNPACTqwbVMjJZ2uRu+0/xkf26m/cs5Hqg+LwuVtJqxzkGyXu+qhsm1J4qEucxgmBdkjOkUO+858A4hly5xmJCsQfffwvrBn/McHy4KZlM7KCOTvcBvbtYhpQCmjtRk9sMN2cxdDG9Zw3xQQr4SgzDE4CNw2k4u2IJwqI2OU+pj9sbzjO+Ey/BEUchzTMBYYhYAhP01f7rGe7e9Dxsgj75Ag/6wvPn9jDaajx6zjyrLirDituIkLbzaf5I65LX0NWZIY/z65Xo977Nbad0cDDk8zEoqUqTTE7tNhRxiWK7Jr1Khs1fCsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(8676002)(508600001)(6916009)(316002)(66946007)(4326008)(66476007)(66556008)(33716001)(86362001)(9686003)(6512007)(52116002)(26005)(6506007)(6666004)(38100700002)(38350700002)(5660300002)(186003)(4744005)(8936002)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cBGjb/CwgdesKapYliz0rsL5t2I+3N28Vqb07c0+bu9RZYXLjJwZGyWNqDhq?=
 =?us-ascii?Q?ICPhP9WHnP1aOQ0H0wLn/8+nik3I5wtymATJ/DgXb8BaDOtzdZ5d14CjOhgi?=
 =?us-ascii?Q?qFkBAUqF6PiUR94cBVkL5appLBu+AWMk6SKIvqYzqRb1eJbpOZaMYqGTy2u6?=
 =?us-ascii?Q?J1QpC/bkspmZ/0v7HV65E/0qyd5wheApau5lPGikLC1aI/ZTuSis4MN4VXi0?=
 =?us-ascii?Q?b0sWNq8c+bI1Ishgd0f4gsfXzlXG9lTILyV20VYQXBisqnlXSrm0STJPGfe+?=
 =?us-ascii?Q?GlcoqSyeGTm97LzxWJ8nKEdXk72KGIZvFo3QWa8wRrRkQY8BuoeMW8VId68n?=
 =?us-ascii?Q?xmGTYza9LNJ+Rc0nou5vy56Vwup6cUOGhdGYXkBx3Gd6WJoRpZybu/rrvz/k?=
 =?us-ascii?Q?LvxAJ6BqXT8BR/MOX0ci3N84depk2PADdbanW7diNnUE5n/NdasGUqDmZKVV?=
 =?us-ascii?Q?VwqheDV6NSeXqukbPtWIlDDo4S8bRsbqY2rWRXSTNGmM6i6gXAGxP57U02+1?=
 =?us-ascii?Q?nZTBT23P9iInyNwNZc//fXyDYOguysphmUk6Ctw15DYUswlRnfACHR31f27Y?=
 =?us-ascii?Q?Db8S5K4Mk0dcSqG+Nr8KROQXpKzp6pID8+hb+Ol5j9eN/rPqesgwWZB6lmM3?=
 =?us-ascii?Q?8WU1dZ/lHfgwyw4XdAE2bavEB5b2bEh3IzhC0AxHQjQK69IKxyiJGZK5Gnt0?=
 =?us-ascii?Q?5vpMBdDaf9uEsmGElzmRSA0Tpova7o/Ju3xBLJEyJP5jBlOCuIzjYSAm+83/?=
 =?us-ascii?Q?QbrGN5zaNRvpuVw04cP9JbKBHpFkVZy4/roiKNhWmSxvA+HASaB0Y7K9I37Q?=
 =?us-ascii?Q?yn+2PAm15+nTU727Mg2G/TH3VoYGjrWU9oQlCDimv746OBnLAd5upDFJxduJ?=
 =?us-ascii?Q?g4hQ/PMutY1QV+LPwtmZSsSVJ35fbGUjAfYenRYs2irqGrtw8ti6g/Z9ryhe?=
 =?us-ascii?Q?49LeLxluqs5JI4P5KNifo6bf4jzja+H0JQJtmnhFlLnRE6yzot4uYpky8rO5?=
 =?us-ascii?Q?IYyb4n/ddHDHy5dH5nRKq0OX7VP5LIi/ndHqdsGL7eiN45uOTKh7dg9B1WDB?=
 =?us-ascii?Q?uzH6db4IpOZnebkRtknx6oCLpsxjEEazFKOeASQssLzp7Udb/UBup5VwHVmW?=
 =?us-ascii?Q?j7vX9iRnOA/NTtn0+3brydzunKOyLxUY2FZfx6gM57K3tfFz7pVosgG3AX2a?=
 =?us-ascii?Q?mSTNrOs77/zISS/kifaa/rj9patsadr72ItGdiAN06BkAAWivvrSTEOL0b8+?=
 =?us-ascii?Q?WKpFMvsW2WezpdVS9KDqsYdwvMVzug//1CmOQU+AW9fDOBenruWWQ7tEVPY0?=
 =?us-ascii?Q?oDWsIk9jVHlnOsRQSOH9emaLMLp506BZM8VoZkgVbrGRmUO6VmbpJ5Eur8b+?=
 =?us-ascii?Q?pLwBYF5hEoKXS0zvAstH5/MczieT4b4vxmYU8P+d+cootWIg9BhKFw5H/lrG?=
 =?us-ascii?Q?NlxefEuRIEAZcJ3ZLR/mL3tNlU6DzYAyY9+eyBL7cZ/GOLLC6gTgCHqS6qWn?=
 =?us-ascii?Q?C2soCa4l+XE1gJKS+hC4qfnfx9fkxv3GzbspY3i1oDDIEJgXeul5iLULWxpm?=
 =?us-ascii?Q?Cs0c8H+kYjn3CNC8BwEAsu+pvTdraM2Cf6kppr6tKfvOktXoD4p3s+BIf/NX?=
 =?us-ascii?Q?XUeVfpGbI3rnKNTzaPGAEvNxrfLBIQ0DDvNGWDPPdY5Gbs+LwrFDBmXKq5s5?=
 =?us-ascii?Q?zbz1DPytLlfOaa7t54OXh82cwlTCmToGB5yCRg3/5Fe0rNlzSoxZoHX1Kpqv?=
 =?us-ascii?Q?MIOh+HF+FlD6cIzcAEs+008/sdgAa1M=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b036dfa-2724-4ee0-e3cc-08da3f01716c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 10:21:05.8856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kC/L63kHqf0mVsiwb2kSgezDwLvmiKHsZjoNB2LkEuWW97qlIgj/kzs77yZN+UXOd5vDB3PhvWHE4yOU0lfTtw9kpw9nb2yjfHx4I3gfWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6211
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_03:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=705 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205260051
X-Proofpoint-GUID: Li_ecFWNtlgdz6FG4v3rLKaINSP3p3TN
X-Proofpoint-ORIG-GUID: Li_ecFWNtlgdz6FG4v3rLKaINSP3p3TN
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie Sahlberg,

This is a semi-automatic email about new static checker warnings.

The patch d87c48ce4d89: "cifs: cache the dirents for entries in a
cached directory" from May 10, 2022, leads to the following Smatch
complaint:

    fs/cifs/readdir.c:1108 cifs_readdir()
    warn: variable dereferenced before check 'cfid' (see line 1093)

fs/cifs/readdir.c
  1092		 */
  1093		if (cfid->dirents.is_valid) {
  1094			if (!dir_emit_dots(file, ctx)) {
  1095				mutex_unlock(&cfid->dirents.de_mutex);
  1096				goto rddir2_exit;
  1097			}
  1098			emit_cached_dirents(&cfid->dirents, ctx);
  1099			mutex_unlock(&cfid->dirents.de_mutex);
  1100			goto rddir2_exit;
  1101		}
  1102		mutex_unlock(&cfid->dirents.de_mutex);
                             ^^^^^^^^
The patch introduces these dereferences

  1103	
  1104		/* Drop the cache while calling initiate_cifs_search and
  1105		 * find_cifs_entry in case there will be reconnects during
  1106		 * query_directory.
  1107		 */
  1108		if (cfid) {
                    ^^^^
and the NULL check.

  1109			close_cached_dir(cfid);
  1110			cfid = NULL;

regards,
dan carpenter
