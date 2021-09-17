Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85593C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 13:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6808260F6B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Sep 2021 13:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhIQNVQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Sep 2021 09:21:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30006 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235500AbhIQNVP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 17 Sep 2021 09:21:15 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HCbfwI019315
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 13:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=br60kDl/MJcF74lu9mSmxVuojzafnu9+mlp1EwOFVVI=;
 b=rEzgn3Wtwf2T3aET2/ydVcsrORjjuJZdQmv+V5FjH9zcvJMaDI48b+R4I6eKtFjaCNr7
 8ktRpfKA8FkI0Jnwfhwx7qfD3s6ErvbjHwpX4NSBp+CVljLRnVok2D7Sm3T5tcqYyLr2
 Bl90GSyn3U3IL/JZHV8okdVKKZm5Lb/kHHa+H7YWbJzgceaSu5nK+0zZLmh/kCNJICZm
 y68TKjRvyLQhFZHPMgq/WJ4gZV6M4WERiOBDtRW5UtTQq9e8sJWdXTBKmjZYoxmppS8u
 DxYlPIzIaul0Q4qIs3dpYxAcQhVrWjpmJW0JXGJ7+8ZvzJvm6SSuqBoAmfRIAeQiICzs iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=br60kDl/MJcF74lu9mSmxVuojzafnu9+mlp1EwOFVVI=;
 b=Ok7F9q8UjyM5Ooj0d+zU+M8yxDwqEvFAraCplSGW+yM4tS4pj3Ee7xbIXabXoJzPN6Nf
 YCwBwjZgqaZoToZ6hCfTatlCvlTSwcC3GZGkJEfVEoD/oHa1IrrfuTdHG40PSo7tBSXa
 VrI5nqzM7CACCh+eiRw2hsdGsP549eJnffjvzLDiryDydftpMRFX2ssIZELMlu0O10be
 McE+o9HGAr6hADYwnwVGtEZ0YGa9kxuIY96LRye+/EgO0ph2kMO2fsi22TWDd3RUGEZ7
 ye4Li9XLDCD6q7tnKp4I3IKilJaF6NkSVx7MqGap9XaTMOamwIodkq03ybxUWUSjbreR WA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b4px892db-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 13:19:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18HDAiSm159977
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 13:19:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by aserp3030.oracle.com with ESMTP id 3b0jghmvhy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-cifs@vger.kernel.org>; Fri, 17 Sep 2021 13:19:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DGNaXqWzpgwmGDiKdFXXo9ttNG2v8tZSVJcv2pF+uwtMUm+oSL7QiOPNgEHwMAha5GKtl7znBVylIlljj1RVMtPnvdjqRStabBGsiOt442fxULxswKH0f0UbJMCerkomdxL2ghZ3N6rip0fH0BT54rviyzsRTouqD3dKb43aqPyGEsBUf0uekrNubhNQZPFGC5H1z+fTopjXP2GVONE4KF/ypFuNtRzX7HHsWNHn0DuKdlY9wdMfihZ6F0124tAUDr/izXPEEYgXqnZBZVXfbv0LK5eG4Ovpgf/ufzgjlj1hIt3XRSlLQTy/KSjlY0d202xypKRhk8wauTNPU1OtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=br60kDl/MJcF74lu9mSmxVuojzafnu9+mlp1EwOFVVI=;
 b=ExjTMZ1E5SEijjqwO+1Yx8WxU5JPZlwDMNuSwN1D5bxjTZTWqYIC1DsTx4eVCIvEn+a3jtzSGlyYBbjdQA4ccpSuISoQtR0cWQO4mVsYl71OZKH2pOHni9ok7Yk9Q+c2siZYJPNWe5V5Ub5eZFy7ibhZGsYZGMfWw0iWva0NkyKtX4x7ByaE6Mh8G0Z2MUFpAgCJZnzt6d5xY2DO9MVVDtLkpxi/lvEbgo0ZAn+AGebGwQe2+YEZGsLO+AJbwv0LbUf3Iqsuu6FUemhtiZZe0hTFlj9eUQ5GXXCGSApwUtOTLOrbhoIwL58Es6F+QU1ivZVcIeSOH4Hm4S93xeCOZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=br60kDl/MJcF74lu9mSmxVuojzafnu9+mlp1EwOFVVI=;
 b=ZQdB147jrtj88f2RaiiAY29IroFU/Xggo7JJlYHe0siJeeH2h0w1deSG5F47nqkfMj1Cpx/YraQSV2VuqWoJccgZtckiALTHE68wyl+MxTeHcRbxdJSPFU1qMJ0FqXaOqE7X41BYFjP52lc821rtdaAxSvCKP7ZFeHpwjFUk4hg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1997.namprd10.prod.outlook.com
 (2603:10b6:300:110::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Fri, 17 Sep
 2021 13:19:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 13:19:49 +0000
Date:   Fri, 17 Sep 2021 16:19:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     linux-cifs@vger.kernel.org
Subject: [bug report] CIFS: Move get_next_mid to ops struct
Message-ID: <20210917131939.GA31672@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZRAP278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by ZRAP278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Fri, 17 Sep 2021 13:19:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7236358e-ed27-45a9-e0f5-08d979ddd35c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB19978901C22F229AD0D80C768EDD9@MWHPR10MB1997.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ny9FXqi7hNck/8aMxlE+7cpFqhrqrUEJir3zrnnO+V/rzVGkdFQ3U3sOkjjG/i8GL9YsBPuzU0aAiRDbI2T5nwuFJQ7wTWCuJiGVHRZ51NhWcORi0vveVodHDopJxr4w+YMYUbIUCF38hV3hxb79WQMAspCcrT50Ohd6YDaofD4hhUHCecMiuiv+t6dFtI3rXjs3SHLSuP5onchJWpgK+iiCsrdSk5DdpJ1UiiSY/ZodmodTVDJvPFodbOE0TQx1ds6jYZesODxzxh16vPzcR+w3QxS3D5e49DNE72g/nsGnW6fmVwYgISkl9J9L7rmICOp/dU3zhQ3mLDq4iWj8R7tgcv/wHwwIiE5CUdlGKS841s+aIohDZppMk89rSZTiK0MPykOk4DuYCx/Gt89DONJtBsN2BScooobgnq0TO60p0/KsTeO1u7yDCHr1ykzI8m6pM+CyBix9om9vZRkQOevdRwtPJZhVtmxmw35fCOXCFupTioeTROy8XVW1zianhwxlyVv1A5H/TDdiAu6ENfab9DTeQqgDQ1QJTUBZOzXMHphA4mAQT5Vj11TErrqw8kl4D8B8fYqDj7aI9MlgAKR0u4OeS1XeKMVi525aVLPU2rigD3vVT/kjKwhIbmDOebCRdKf3Gr57CeYmyJlcKl/SBoibm8zSCBXjsYb+/ZLp6tenRgHik9IciUoVV05ptL3HaBPUkFSLQSB9I5MhZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(66556008)(44832011)(66574015)(66476007)(6666004)(66946007)(5660300002)(86362001)(9686003)(186003)(6916009)(26005)(316002)(8936002)(6496006)(83380400001)(956004)(33716001)(33656002)(2906002)(9576002)(38350700002)(38100700002)(8676002)(508600001)(55016002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A6XYPM9CW1cXBlL3Cubm38gkP8HupywyyPHjH8j92GOne0u2IwCyYezgP7rl?=
 =?us-ascii?Q?H8hHKD9I/hDdEtNsZQgi4T6Jyz+Cb01lV0XcTZvt1Pgiy5mswBaEmbh6jomp?=
 =?us-ascii?Q?yJbeGtBbUXywPNQL7AJVh5MjYgI+uTcri2P7H1adkioMKQ+MQm2DGwbdQgt7?=
 =?us-ascii?Q?mViF/1t5Jg6oAwTgzIfy17Awj8zrS2WudpyAljJbRwl428pHIeywmhp+61wD?=
 =?us-ascii?Q?gtLmFWK9afXMIG3gGDRTPeLkni++hy0lTCzc2FqoXPXzNGxrXnd0bezGcfEO?=
 =?us-ascii?Q?1epXJsNz+ah6jmSBnBRbLxcR451oGIGj0zQxO79ryWoPVocI+Q21FWyCEZPe?=
 =?us-ascii?Q?GKQG6WmqgF40KmWt0ImL8Cg3kaDIIQSl5O9dQUCeVkSnvVUoZWhj3bpTLu9r?=
 =?us-ascii?Q?47CY+QwPSRcSFOJoqdpcVUN8AQpoksAjvj+Tl4tMApg1jKbo8qoco9Yd8QOx?=
 =?us-ascii?Q?scbbjg6jdkxkUuq51yHA6ZKzechcSXTynYVfV1ZIUBJCQfq0QFG4FWDqVMd/?=
 =?us-ascii?Q?51cdooXqWlVLFabfsJabhB8/D5Nj+4FeuM/Mj7JztH7yOiXHutKjrVibGjRo?=
 =?us-ascii?Q?43aBLCcxlWAN/2MfEpL1e5bfKcxfynCZt1k1QZQx21xnZwuVnmCrSQRtAJ3u?=
 =?us-ascii?Q?983eXsI6zq641w2GgABGpHLl1ai61nqAQTqoiQGIR36w2USNRXoG0wXAwrLt?=
 =?us-ascii?Q?pW5aDo0DQzmXpt53yLNTXmYjHy5X6MXUvyaoWKwL6JWlc8A8PF3jPefwjFIn?=
 =?us-ascii?Q?k8bEz4Az/kOn+3+Pe/5uenUA34GRUG1smRSPKZR0vHwFvIDEWU8wipavGEl7?=
 =?us-ascii?Q?8GrF1SCWIzv57f7JAwMg8I9yE0iLkfVKTOSLnna9CfWqTk5S1NwieW0IKUWJ?=
 =?us-ascii?Q?d/+KZj6MH0CN+rfM2MOQd78n13sPA1Hh5+oDicmDyEsEyua2SNQBtgf3Y8zt?=
 =?us-ascii?Q?1Y0Q/IOyVYFtKf2zj0dLqhwDdwoSwdXmZqIzN61st5rHBca7bQeaxenm3+fJ?=
 =?us-ascii?Q?+vtiBYL5LieObqX09z6qVg+RpzC2hKqXRnsbc6ChD8SaHYhicuyTscq74nCv?=
 =?us-ascii?Q?ng8vJo6xPbQiJa42V6ahevtmdcpqNzaM2p94d7GxylLYEmttwWS1piy26mVg?=
 =?us-ascii?Q?ZrxiCT3UaSLJly2LvYz6urRpCE3NFqZIBoHmQyaT4JE10SUC1U/Dq/phBsYo?=
 =?us-ascii?Q?Fpk261kFCgpu7IJO6CvGajXJ+3o/RVRAgAtlfUxp7xi2WzM8JT7/QXoBJ3vT?=
 =?us-ascii?Q?u7F8PXK94kol+IigbnWRBFU9CZ+vcZQICdR+4oqH/u3XzmCmaO8VOI0Kx5gS?=
 =?us-ascii?Q?q4KwWSV+gOcVeLNLb6rB8RGW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7236358e-ed27-45a9-e0f5-08d979ddd35c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 13:19:49.1627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvOsUaNAMRPnLVf95N67wnMIYTU80Z7ywOVsRD8xOCzkD+FzgzGclqkq02F0BnedlQeYI0R/XBH9tROoo4RyvwRRsoCJnPkL9N3MfUAw3qQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1997
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10109 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=987 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170085
X-Proofpoint-GUID: TtdI3gYKiP4LYZ6E5HHsxzn9YGaaKVZN
X-Proofpoint-ORIG-GUID: TtdI3gYKiP4LYZ6E5HHsxzn9YGaaKVZN
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Samba Devs,

This is a semi-automatic email about new static checker warnings.

The patch 88257360605f: "CIFS: Move get_next_mid to ops struct" from
May 23, 2012, leads to the following Smatch complaint:
        ^^^^
(nine years ago.  :P)

    fs/smbfs_client/misc.c:273 header_assemble()
    warn: variable dereferenced before check 'treeCon->ses->server' (see line 267)

fs/smbfs_client/misc.c
   251          buffer->Protocol[3] = 'B';
   252          buffer->Command = smb_command;
   253          buffer->Flags = 0x00;   /* case sensitive */
   254          buffer->Flags2 = SMBFLG2_KNOWS_LONG_NAMES;
   255          buffer->Pid = cpu_to_le16((__u16)current->tgid);
   256          buffer->PidHigh = cpu_to_le16((__u16)(current->tgid >> 16));
   257          if (treeCon) {
   258                  buffer->Tid = treeCon->tid;
   259                  if (treeCon->ses) {
   260                          if (treeCon->ses->capabilities & CAP_UNICODE)
   261                                  buffer->Flags2 |= SMBFLG2_UNICODE;
   262                          if (treeCon->ses->capabilities & CAP_STATUS32)
   263                                  buffer->Flags2 |= SMBFLG2_ERR_STATUS;
   264  
   265                          /* Uid is not converted */
   266				buffer->Uid = treeCon->ses->Suid;
   267				buffer->Mid = get_next_mid(treeCon->ses->server);
                                                           ^^^^^^^^^^^^^^^^^^^^
Dereferenced

   268			}
   269			if (treeCon->Flags & SMB_SHARE_IS_IN_DFS)
   270				buffer->Flags2 |= SMBFLG2_DFS;
   271			if (treeCon->nocase)
   272				buffer->Flags  |= SMBFLG_CASELESS;
   273			if ((treeCon->ses) && (treeCon->ses->server))
                                               ^^^^^^^^^^^^^^^^^^^^
Checked too late.

   274				if (treeCon->ses->server->sign)
   275					buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;

regards,
dan carpenter
