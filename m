Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB50C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 13:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiHANDd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 09:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbiHANDc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 09:03:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB6521811
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 06:03:31 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271An4L6023352;
        Mon, 1 Aug 2022 13:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=KuXO24P+ePEwcDAniSJ6U+DlfZjZiw68ioHccXtcTSY=;
 b=as+lCYNgniWLec7H4L408At8EL36MUfg9wwevGqsgmtuypNXhA/KKsnYIJulW81pkmU4
 dwQ/FQe/Wjd6yZ55qQrrlZ4YiimfbmS811Bfr58lA4uL2ZsoE3gpxyjpRafpmMH4vrUr
 xADbj4VpFhoX+GqAE9/jq82spbwRycibvBrTyg3qMONe5C0Kqs4Hgcw+PvB7t2hkew2v
 1P0uBsuSFZHT3+Tgb/JitWojRhO122waH/t55+165Si6QLjpmgyQAqLZ/9LCQRZxq8A4
 ZmpSNmH7KM0TPubEcAFRZTK5nvSpc7I1jGcSYN/3JWWbLRI4LtM5oAk/r+Cn6oA1PBuD pQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmue2kkbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 13:03:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271Ce4v7030852;
        Mon, 1 Aug 2022 13:03:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu3191tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 13:03:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2nmI9n751hjtrsbFA1FfhQpPxApOIhtGihQF87FCLPhVsxyWXOc3RZI7mS3mh+ROSeRW7gPO9u+V4iQBjQq7sbgoK8RJ7DCFS2+talc+5s+57xWcYNGKC/aK2nW2cVZEgu87KcG9MoRq5CNkbx3DIBiSplVxWbSWovNwxCFPIRXtijV/yQ6SXFHt+kjVfNEruO/V9jlrJ43Koqg5O4RexH0a7mXyLL4ynSzgRRhyG+z+ALQ+go6fcqG2jQozd/ikWw0Nflzqd4ZXd+0D42xUFHVC02cboChQruqWjb2ZoCaoeHmhoszUgGjddz9FDCWhhW76McCaClffUCUbX4Zkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KuXO24P+ePEwcDAniSJ6U+DlfZjZiw68ioHccXtcTSY=;
 b=D9P7e78PcWkZaHe3aB+UN6/KDQn6yHJ8ZP4qDoiSY/z8ZrHuVFqJPKXTWUjpPJQkWGTMHlyO25Wm+fiC7fA3UM8kb9lGcXrm7+hsSB0sYjtlERqyfPdsz21fhghDiczYBzxyam9r4uJhdvdsNoDA0QBQPpD3E9V703TXe1W/eAm7vj8ZfEh1aEAC1vBUgT+dHob+nJqNYsadbAf5nSyiKbeHuRRqepKXZh6IYbY3FEDfv0PORULkRAMdQJFtByqQu1w9lL4bdnfN0eaimKY6hJ31Jyo1a2YbslFcKWsiOBfvUzNn7HDZfZ4moU15dP4Ap46r+QI+nA34z6cGBTwS7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KuXO24P+ePEwcDAniSJ6U+DlfZjZiw68ioHccXtcTSY=;
 b=t0KxhyH74jeysTTu5M4ABPyapW/N5YL5k8pFvgWaRgFT/MEaJN7vaS2HyVfLBXyFiw7HxahIxUN3SKDEIrdEWRdC4dFpDE6HkDv21dX2W8pbwnFK7dIZL2+20msxJHMulhEjIo6C+LFb/rkKvqg4TPibs0Xt9xyGFTs+k4fvJlA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB2036.namprd10.prod.outlook.com
 (2603:10b6:404:101::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 13:03:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 13:03:26 +0000
Date:   Mon, 1 Aug 2022 16:03:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     sprasad@microsoft.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: avoid use of global locks for high contention data
Message-ID: <YufPFRNZtOSbuVY+@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0101.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 464224c4-1a5e-41f9-747b-08da73be393c
X-MS-TrafficTypeDiagnostic: BN6PR10MB2036:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ej1au+nZgAEaYyTtxnAaFJYiunUoW0V9urPEqAY14XV5IjAt+l1fzYUJ1RsKTdVbmADee4uX0oRYIfsc69n0Pk0c1AWSjXBOBzl1doxCADshDfO3/C3ISJv6IE4deslJA+MoLh8rdgSjYozbifhJpR8IXBH7wzq8rEIyzii/KKyZvv+QjWEsIFI5AC/ivlQ6ZtLa8bHIjd8N59lG/jVT/YrApMrYgSm7v0LJ8VLOaLv2bkmTedLH6hRAEqLKC9bXj4ksifv+3iXW9D/GTaidUUWtwJdc4Z2hiuLBoUSFjobcy+4A7VvcZx+MLMXmkrb8n8eYnivXXQtfJNVlJnInVBA4m0U/kyzE3qUN6odlHOvmmZyAiaZ2zbWGsZBwoUYQJOEgqbqAtm5eOpO9PvlXkN4lab1Aqq4fxfYNCSa5ANTAQUa2hYCwXY9vi8lwoyoh8JylFMiLG4XA9aFSbIHNkCq75TkFplBtOYtKOZZH1X4TlkUmiYvhbpKgSbcpzRt4M/5/48znPm5dbB6uBfWWYLLQG1rr8tF2zQbiq3CVGk/1XjWbCJRvK0UXQeWz+1Qy9DFA2QZaW7IvLpmrwcvPKuJgFbqUPbSZMrHKNKyuk85qo9B2Q3e7rMQ8QTbUFsR1VitYBGYXO68ZuSCoApKb0vRD/4Dv1aJ7lCy5elaKlCTp+9Rf7jWKwILdyLOhlYpBOVSBNG5A157NwScqPLlwscJdTXowZLCTY+FS1z253n1xHON2UxoD4REMibbDoluMjFlKDICUy8djmJh46yecruwjahyI2oJsEnamZMLQDYXOLYKhHi+zI+zEiNJjVlZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(396003)(39860400002)(346002)(136003)(376002)(6506007)(9686003)(6512007)(52116002)(186003)(26005)(38350700002)(38100700002)(83380400001)(5660300002)(8936002)(44832011)(66556008)(66476007)(41300700001)(4326008)(66946007)(2906002)(33716001)(478600001)(6486002)(6666004)(8676002)(6916009)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q9PDPDsUNbLaNpy4aYgfF3MIZkS+hi+BsxWGjK6q/QyijqEVFj8ZAiNURT0D?=
 =?us-ascii?Q?gV0WGpSFo7mm3J+S6ucM0mfLJgcO4UIcwvjVRQZdiAduaz3smuKSxvqFffCD?=
 =?us-ascii?Q?yhOy+RM7JKhSxAN1S+YAnzYqvgxVB9Mid0mtvyYojF0BrV1BcfBTItMIGX92?=
 =?us-ascii?Q?IbI6nUTCnwuoHO+gqK95ViFtj9Y6gf19V2E8N4ILR38cLsQJRDRE+oqWLK50?=
 =?us-ascii?Q?/FdweXXfFZLDwVxGkBuCHzb4yzs7ujfHjzLDmUkAXb6qTyQwT3rdUQiPPrt6?=
 =?us-ascii?Q?Fz7kQxw+hpLlYrQ1bwhokA5yARccVVUCMpbqwncdpb20JLtxhg6zpVhh+vk9?=
 =?us-ascii?Q?uV/wAqCR2/KT3k1f5Lb7icbCS5r8mEpPNVzvTupidgYD6/vJRdgblgvtu7wY?=
 =?us-ascii?Q?9x/MReKbXhfTrgsgMHo4pJEq1nhsOJBC/rr47qKmYfQmmpOpV9IrE5GBDnd8?=
 =?us-ascii?Q?9wg25kY8u+J3kjYC8xAtO8YW8j8vT9tR37vasSBGlBzzrnsD66Ui2R4UASN+?=
 =?us-ascii?Q?5nIV126A5afO9Dn2AuBFe/QwHZahm+z+hxdNQbyLk9AQvTV/glsRjgoZeLyL?=
 =?us-ascii?Q?h7aHYrpBBx2V32osVtzHBSOi5gLtoHeFlqct02Rgxww8VLDHPETQ8yzQyyYU?=
 =?us-ascii?Q?SB0d3VSFKykTd1EM1Z/uyHeZVRTFoNIqhUFBjp41RdR62UQPiIIsGIZyOaAx?=
 =?us-ascii?Q?u9jYzNzzmGllGgon360Ouh7k3g3VXwW85GH/41JXbCM1/XvDeDWljApR1cHT?=
 =?us-ascii?Q?pZYN0RoIVljoNWl9+o+1McIN08l7BvkSY0L798ZnOc8WpXJRRTLnxhl8quCs?=
 =?us-ascii?Q?B2+/Ok2T9WpAZdCzWeGqVurJvmjysX3uLRH+sH7xIY0S/5G2wlPzFRHGckhF?=
 =?us-ascii?Q?HeuKSB5sgjhU54jx11HoZ1LPo1zXoDASBZsT3IqgxHUUvwnXRCSXXLePN73+?=
 =?us-ascii?Q?A9+RmBE1iA0mHd/zVNWw10vvp43j26cLehLhq4qEceNe5rpuOZLXXbmzuIAU?=
 =?us-ascii?Q?a3JtqiuYxeIm3aZe/jBhgz8s+jAoL8HZjdHQQ+WxpPoqWgD/XOgdW42xq9d3?=
 =?us-ascii?Q?s+uGVEAwa/c5S5te3k3Fhd6TgJXLVbLmxg8yllHmafgoyvU+pNlkSJ/HAC8O?=
 =?us-ascii?Q?ll1BHoftQ7sxA1/4HbuD8mEHVKVTHveTnOyoG2PpuMcyhGGPmTpcjpe8Vf0g?=
 =?us-ascii?Q?+wXbPOUCU5NwDRynQdzUA5ck5YcBHgGSX7vlOJ0psDB6K69tHckf4L7pU9G3?=
 =?us-ascii?Q?3CYBABkPMcr+g8U5F367s/gLbH4juATJ9g1P0IPyrLEJIyGR1pBV1c5zEpL2?=
 =?us-ascii?Q?2oRTXzYjt+hVlCBvIzAp+qbznkS7ZH3lk9fov+L7weZsZBcV8Xy7rS2K8mGB?=
 =?us-ascii?Q?F/r16H5uRbIxsi4iZrmKRkT3n3Hmi38686b3+nKjUfzYTOdy/Flvb6vdfJbV?=
 =?us-ascii?Q?wCeO1OU0m3U7pvWLPJ48F5TFgkxaQG3pt5nALXEfZhzCfz8Ip0e1yuuYQSJK?=
 =?us-ascii?Q?FYW2Oyyb3JKvl8uYbYqQVHYZlcXGVfYm/+3agEDU0Zh5Qb9HBP9a9yalizf+?=
 =?us-ascii?Q?zkF2PNstty/Nmvh06WLL2wzEFoL6Km45pAiFW+QUpRJ1PI7NJXg0A9usWopJ?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 464224c4-1a5e-41f9-747b-08da73be393c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 13:03:26.9308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uZ5D6ViUj2Mwo6T6O7fkWu+zfJhGfpxxKpzyYSGKTn0/S0dPtK2CionqaRKC7Sjy24E5XDvSUhCDIeN/5aOaQVrMNvigV8I7MeK3W8wNU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB2036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_07,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=768 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208010065
X-Proofpoint-ORIG-GUID: y0wtDf9PD1cAqcFBvm8Td-luyNi0RDuE
X-Proofpoint-GUID: y0wtDf9PD1cAqcFBvm8Td-luyNi0RDuE
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Shyam Prasad N,

The patch fe67bd563ec2: "cifs: avoid use of global locks for high
contention data" from Jul 27, 2022, leads to the following Smatch
static checker warning:

fs/cifs/connect.c:4641 cifs_tree_connect()
warn: inconsistent returns '&tcon->tc_lock'.
  Locked on  : 4587
  Unlocked on: 4641

fs/cifs/connect.c
  4570  int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const struct nls_table *nlsc)
  4571  {
  4572          int rc;
  4573          struct TCP_Server_Info *server = tcon->ses->server;
  4574          const struct smb_version_operations *ops = server->ops;
  4575          struct super_block *sb = NULL;
  4576          struct cifs_sb_info *cifs_sb;
  4577          struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
  4578          char *tree;
  4579          struct dfs_info3_param ref = {0};
  4580  
  4581          /* only send once per connect */
  4582          spin_lock(&tcon->tc_lock);
                           ^^^^^^^^^^^^^

  4583          if (tcon->ses->ses_status != SES_GOOD ||
  4584              (tcon->status != TID_NEW &&
  4585              tcon->status != TID_NEED_TCON)) {
  4586                  spin_unlock(&tcon->ses->ses_lock);
                                     ^^^^^^^^^^^^^^^^^^^
Originally this used to take a lock and then unlock it again but now it
unlocks a different lock.

  4587                  return 0;
  4588          }
  4589          tcon->status = TID_IN_TCON;
  4590          spin_unlock(&tcon->tc_lock);
  4591  

regards,
dan carpenter
