Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8122C433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 17:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EF216196E
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 17:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCVRfQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:35:16 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:54296 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232108AbhCVRer (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Mar 2021 13:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616434485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NwOCOQ1aQY4JU1pDWOdBOi5IMkB60nhVxW+ZvTeHH6E=;
        b=gOA7SU6z8k7I/zf2UZeLrFvWmElQSpSHqui7/0u2WFgg0+fH5qjTftGzCm7Gd+ovMRHjgT
        5nHMI75DWW9rNpperjoTm9/NwWeTY2rwpmuN5Ma8fGzvILJWXxdTLNq7MAz6U7j61n/YLK
        qZXC7EKFu9bB5CkmVoQf7YdEf4qrvHg=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-QuNrte2JPXaVpNgy5jAWtA-1; Mon, 22 Mar 2021 18:34:44 +0100
X-MC-Unique: QuNrte2JPXaVpNgy5jAWtA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DE9eVc2ZZ3vwno/GV/5gAsuIMPuHLWCKkRixo/ZBHrHr7wQxjIFqxhe5DpaOTcTdRjKVm2UX7v3ymkLy5nAC1Gea8tEVYWlMtRGDeJy7xTvgbHLhsI1cC4uqC2LKW0KvDvIFJVHgmjJIfUHIO6MrIU8ds2IoCz3B0oIeybum8ubDGDKMuRrAn5B93sArXTOP90fWxixZCUoZ1SWEvCDm5ieTbfz5Wjo4Zp+PzIxDQ9VSlcJk8YXKMiagBPKN2o1YpU6/EMEugOWX1jCUlAQGXVfCMFPvRu5wOfqhmqitNMYRPNZqsrBt4YQ5vRBH+AyuW2JGylbz9eNX/sTOasYB/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSEUBtoNwGroGAI1ylbEUxLu/mZBXfesCkFs3hqQuYM=;
 b=ZktnKw7OCnvDOtZXvLUFj44HhFQusGTGtHrNvZKN7rOZLpdUD2Jfh5hyaQC+WRZVBHVXs743J5JDTtBCfGdhmSCwp0SAtef75X1NRy2BDeuOWhoQuzFT/9iF7Efq7ydAmuOUMiuois5YX6p8TdaFnTTkBkdbZCx2MZK7gdoplkfXWQC7kce/8oLWa5x+rVcwUXB+ezC07LcJkiNxCgdr0lgDvYLwTJIKcsgoFeEigNNFi0iDKMLu8A4/CaUivv9CsOPHjkGv9hFU3nvX3u31wGpuT/d68nX2mBgzpwoIgpx8suz3Wr5cYaYHEXpq9zqn5CpZRiLE7X9+v2VLhWIWaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6909.eurprd04.prod.outlook.com (2603:10a6:803:13d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 17:34:43 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Mon, 22 Mar 2021
 17:34:43 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] Documentation/admin-guide/cifs: document open_files and dfscache
Date:   Mon, 22 Mar 2021 18:34:37 +0100
Message-ID: <20210322173437.31220-1-aaptel@suse.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:700:2815:b96b:85ea:1f90:5f2c]
X-ClientProxiedBy: ZR0P278CA0075.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2815:b96b:85ea:1f90:5f2c) by ZR0P278CA0075.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 17:34:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeb064ca-8c03-466a-d5f3-08d8ed58c75c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6909:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6909BDFBF135813C06E4A018A8659@VI1PR04MB6909.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UjMQ3zweStRrlexD6IohSrB/2KIfvh0TKzuT6UBzNaHOTkwRXKHVYVztRKfz?=
 =?us-ascii?Q?lUandWro/TbrErODGgdwbrrinpde1r8rE6u3ORhyoy12GLODjODPcjEuQCg/?=
 =?us-ascii?Q?p/F81sqSIrLhR7n3K3m6VPs3rUfUxfFp91bOTQqCCfFNvyHIEO4X/kjTNJ0a?=
 =?us-ascii?Q?okK09W0rM4Et1AIJCEv5wlCKpnOT4jxGy9Kl6H2CO69f9fy5/kDTDk4X8iFs?=
 =?us-ascii?Q?PJ7j4ZT8UmdTSR4Nrb8hgmUmEGzVDWwVvdOiyddQ7UHOAMB/nodF16vn039m?=
 =?us-ascii?Q?ohHncgWDmGGa7JFWaVaDhoe79TKvq2sFMSIe2W+GiQpZ4lhPI7g+N3NFh5mg?=
 =?us-ascii?Q?byjKyuKyxc3UEIDFH0d8HOJmKNPZWEZur9JveSMQ/DmFQ07S7yqJQqM68VWJ?=
 =?us-ascii?Q?stbwo50uwxkKSV+InFjDdEl/exP6H+ZtWR4sdJlwD3p4dBWdoaKF7iM86DS+?=
 =?us-ascii?Q?9nOBGBjdjbuCoEwA8Vd6Cl2We8pvmLLyKYXngLXGoUesVzBiFeD7STPgn7dc?=
 =?us-ascii?Q?vLOQMywLZMXKTzkOH5XBQifAGYTwg/8pC8VtCKf7vVIvdvSX9ULoMw1Zzune?=
 =?us-ascii?Q?xltWw9cVHMIEmnfZDVPCouq24JMF37sFR1spqHe38HoZfzlZJPM5J/oi5ftW?=
 =?us-ascii?Q?Fb20UVJvrVv5BnXETFlDOlq4KJXJ0U1wZlVutc0X3NLg7lWifxkCuf7HiOST?=
 =?us-ascii?Q?NF2QYddDcfKu8hCq7PFu+rOdWX1A6kZvnhNe7/8uRxxeQw6qO6+w67REhx7F?=
 =?us-ascii?Q?uiIMeq7rHHWPWp4sfoLxyzhogfhXNm1W14kK7IhdqLS3RmmtyvNg8dmMMUyS?=
 =?us-ascii?Q?6UnfobbunOumFLsBdRu3GjqU3DaGfzojV4OOhMERvVZcGMR4rBpbmdETSiPh?=
 =?us-ascii?Q?d4AdJrDYw4uC7pJV9AbqbW+f19qlStxUVodNaV7ubOo5T/zkaQkmMCFa4hz4?=
 =?us-ascii?Q?GSvGSQLGrdr4ceGFlmUv6+3Kr0JdXVT1XKcFMRmiOhU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(136003)(396003)(366004)(346002)(39860400002)(376002)(86362001)(83380400001)(186003)(1076003)(16526019)(2616005)(2906002)(6916009)(107886003)(6666004)(36756003)(4326008)(316002)(5660300002)(66476007)(6496006)(66556008)(66946007)(38100700001)(52116002)(6486002)(8676002)(8936002)(478600001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Dyi61uO5sGYOYbSDL+5mLVdWpWBREVKlfqiwBtmf9cb6VTy8CObK679eS/F9?=
 =?us-ascii?Q?MN3CYBo/GHBWwl/yUvpciziJAVy0ZtfepIWHc+IVEgWojqRN7caMWaVa9VMp?=
 =?us-ascii?Q?1C8jFElu/UFt3VI4EHXgiyL+6/94wsqAUmWPsUE0NC2sNOPb4lY6RtyOD0Nu?=
 =?us-ascii?Q?yiCC5D+YM/TtaDs7ymyipGPQfiClFUCPcB6FAx8NanUcrCNn4b/jnmCPhMVR?=
 =?us-ascii?Q?qpm20FL+POlNwN69LdosgV20uu1r+L7+fJGYyzhbqIFfLg2BdPN4QRStU5FN?=
 =?us-ascii?Q?kk3QnDWbp3q46z+WH0swrrNodGqWDcaI76LsDpITAEoN7T7nnaN0sovpaZlm?=
 =?us-ascii?Q?NTDkcXykks4MVNDzH/Rih9EoYSgYgsn+cqTN73xqhMIchCKMqzanM3a9DDUw?=
 =?us-ascii?Q?r1vAJSCtAV+ocf0bGVbdVBS1br7dhNUpDoyYnraonNsCNSzOur3s4wYvxrEH?=
 =?us-ascii?Q?wgNtZKboyfegUh1SeWNTypq+glM/c9RGQJPvl6kBHJ96SvqhHgCGiLseHzK2?=
 =?us-ascii?Q?+BWgLCxM+RvVoG3toeTy2Q3YJwyz6FpRmZDqm8Vlu0J54slfuljriCqkMlIV?=
 =?us-ascii?Q?K/zHj/zJU9DajHmvQBPaDepcnaUtK1qEvE+J1epkwXEbfzQVgrmvFiX1PFOi?=
 =?us-ascii?Q?nlzx81DKAtDqj9QVdR9cenaI5dXiU1xgjem+SFWbz9eOP8Sqg2IlhvrXAnfP?=
 =?us-ascii?Q?vDWUlTEuvcrB1QI65QnP1/dOe/MXmW4SpSePugqbyWPlEYxjdu02NmyV+Py9?=
 =?us-ascii?Q?m2c2ETQDdHF/XBNJ1VvE9ASFErztUy4z386Zh9sA7NXFuDQc/T9hjFCWqiMJ?=
 =?us-ascii?Q?pPxWbLoYy5Ex8wFhx2nYu9v+1Ap63T/IhiJDvDRBFTtVLBgY3xZDNQfe7SWh?=
 =?us-ascii?Q?ykFC/LkaeaWZWNf9kaxZsulGyAPzq1du5lMmv/to2AARss1H+G0HQterZKyp?=
 =?us-ascii?Q?EWAvDYkwPEaM6uX04u6L0m7vwtyK8RnmOp8GQLI1PIIyPvwzcVjuwXWYrqwO?=
 =?us-ascii?Q?rW5U2Z/E54QBI9nxYvPp4Dm9XUyi7jNlEEsa8R0z05U0ZPmnUW7MOv0w5JXr?=
 =?us-ascii?Q?5uBrCQfCqfaN6QRgoKiDGU8Ra2UfRghIKWbxdfo8q+0a0nsnjYasPmwR9yaz?=
 =?us-ascii?Q?b/sCETDwsUprCT5WzrxUFHDclsK72LsPhivgLHmgqpXICzYLyKhRieYzEr3v?=
 =?us-ascii?Q?jWn3+N18fPxF/q3gYc8HGJ2D3oAevkS22Okl0za2V2/PPdwMJlqU0mkx8zG1?=
 =?us-ascii?Q?QEn41S2wws5BxlxhPJ6fS486UaxAJjdQ1Ij/qtsldhSyQfRDH9tPksgBdE9a?=
 =?us-ascii?Q?COBbRUocp/wdE28s5VfPLuBrQE+qfQ1pEeKmsvwVuZm6/vpzDFG8+FD8oMU0?=
 =?us-ascii?Q?HObSciuxm+Z1kagPHzqBfAvL+zRM?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb064ca-8c03-466a-d5f3-08d8ed58c75c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 17:34:43.1989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2iOANEkI2rwGy26tcnhR7B6E5GEVHm4kaKw8msNefIB1hqCZra4vef0pPUGg+uI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6909
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

Add missing documentation for open_files and dfscache /proc files.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 Documentation/admin-guide/cifs/usage.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin=
-guide/cifs/usage.rst
index 13783dc68ab7..f170d8820258 100644
--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -714,6 +714,7 @@ DebugData		Displays information about active CIFS sessi=
ons and
 			version.
 Stats			Lists summary resource usage information as well as per
 			share statistics.
+open_files		List all the open file handles on all active SMB sessions.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=20
 Configuration pseudo-files:
@@ -794,6 +795,8 @@ LinuxExtensionsEnabled	If set to one then the client wi=
ll attempt to
 			support and want to map the uid and gid fields
 			to values supplied at mount (rather than the
 			actual values, then set this to zero. (default 1)
+dfscache		List the content of the DFS cache.
+			If set to 0, the client will clear the cache.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
=20
 These experimental features and tracing can be enabled by changing flags i=
n
--=20
2.30.0

