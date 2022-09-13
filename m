Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C52C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 22:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiIMWUB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIMWT6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 18:19:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129EF67462
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 15:19:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8pt8irI2UGBh22mJpvb83U7ub1KAqyoMylzVzBQTefjrr3ZbkTlU/yvDKBEox79pizrpjumlTFUIp8Rnp3pk2MutZyuLLyCShTIecEsK4bsjVObuP80aeeYSI4+rg5IygjxGXfIOXVdAHW4b31ItYInAfrA4a1KUBUtwKcbYOgRUE5ztZbKQFzjH9Qlg8WPL/lNqtHyO/UB9xctoAj8PhrBJ5YxeG8EtvwRjBkvt4OR8+FIIg5WtX7F682akttrcbpJegLgcFvI7pue4TK/vaSJUHrI8trGcmftJH+zVJjHekpXhHHcMs5w6igQof471K0g1zUBKpZdxloP5JnfhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1awBvjJcIY9fyo8Cq/++72dqXQ1Aa9ecuKIxN8HY8Zk=;
 b=U8/cfOGiHqQACT0i/jr5GwljOEd3dMkeVN9eX5Fgop5TqCxf4zuh+DSwd7m0xZGHDelCYeLaJcMk6iucD0IvTdstFqtQzbrjEY57LgPFgKJ9WpRTdqLL/01c6TLUaU27Sr4IAuAUlV/fMOHPVAApTsSxmxf0onNtxBy9llsCQn93E2GU3C2UkB3qaJ0VMcntRKo8xsYSN6b0C0AFymOsRUdlUi1rgVe1cl5roPv7PpTQdhKrHHX+KibmNWIFaTzeR6hmsQT7HHaSUluy1G7sLSRxjdVUQqgfTPA59qURpTlDsGAAbh09yLP2+SEV/1XEvCtX4EMedhiabSq+T/m4AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4573.prod.exchangelabs.com (2603:10b6:805:eb::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.16; Tue, 13 Sep 2022 22:19:53 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 22:19:53 +0000
From:   Tom Talpey <tom@talpey.com>
To:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, senozhatsky@chromium.org,
        bmt@zurich.ibm.com, Tom Talpey <tom@talpey.com>
Subject: [RFC PATCH 0/6] Reduce SMBDirect RDMA SGE counts and sizes
Date:   Tue, 13 Sep 2022 22:19:31 +0000
Message-Id: <cover.1663103255.git.tom@talpey.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4573:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a921ba-954e-4a53-73d7-08da95d614f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EgyOO6kzpApD2+uOx1Unu/BysszHQ0TrS4Af/OVIsAcnhZNQsySmRRJMK/gJoFh9mIKuPLBdHwPvrjVMK7Z5LRwqYAQzh8tOEClXA6ZJWcR0qgCPbv18fcI8ae17EOku/OmIGfi9NJNaIHpHK990t/P3aOpgn6Oi4qrViwgC+GxnmnzARpTymFYI3cokxag3JtSM+ZJCFsMNFEYGAbr/B2ri3bEl1c3DkGRJEzKJ96vyOwnQhKzOCbDVI+C4YW6YRnVqNdDh4czYx+ejHn6Qr7kEZ5IkEb0/HKNQcL3tWcUhnT/XczkkfMfrJDeQDuHiE7myAhwYR29LOc0VqxjcJe58Bsh+j2nM82qMWZy+luCjR8MVf1vq+6iz2bE9p3mh+go2i26S4MFF97NbovrYcxOExwhxJrTW1VwnoO5Dna2sGXM6R/zQJsRbgDN1hYzxeUuUppB7ncESr15YHYoCOMXbL0EzBeB9D9sV7AtxPitKWnipLzcO1zKKI/fNmHbTpS6g82KNDKHU4wNBZsZK8lqsPhHlS545kigCDIASF0Ommk7L6jQGs70MNgUlGRvpv2HU/uE/SxncJ/z0EKI320wqyAwfJwAbuRmpjIPMSASaQ89825W9Iw1qAd7iBt5f9u04FJ5HD+lIdwXw66PvSZfsZAyAFwsyQdES1QUAjdN1Qti4dh98jSvfMpYkrwIuwaZYdzAy45kxvvjEcc4/SlpmDL0Y+jBQisdhWBdwuHgQ2VfDgkRVzBuZOgs3OrPq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(376002)(396003)(39830400003)(451199015)(38350700002)(107886003)(6486002)(8676002)(8936002)(6666004)(41300700001)(66556008)(6512007)(66476007)(2616005)(186003)(2906002)(52116002)(478600001)(86362001)(6506007)(5660300002)(36756003)(26005)(4326008)(38100700002)(66946007)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aXBAv33jOD3m9gkq3fmm8lIyWBg3/Bv/+nxZRa3e3XCzvdjXAKCrkh2njEm1?=
 =?us-ascii?Q?wXGGyM7xr1JwXXYjFfhVQqG6NjOueyrzF3e8kQZ5XXUW3zEaM01Z7zdE1NYD?=
 =?us-ascii?Q?9zoHirZql7vje8Z0VLubvW9+PGk35+ke4BBKUyrGT37iyBVAE89+RRTYHw61?=
 =?us-ascii?Q?pIN/H42EvbD/keHUK/A5rEQxtgZyMU1PtXvOriD3guST9OPiDl0dQbpxUwxW?=
 =?us-ascii?Q?NDMPHmVNPhoRo2sy4lEb8F8Eyj1U8oGXYX69zek4qWicUyS30F6VEbe/+0uE?=
 =?us-ascii?Q?1RdPmCPsrFpqX8yotmJJMSBCDN/KV8m3uuJERp738+y7YmuhYzZKKJTdgzvN?=
 =?us-ascii?Q?qbRDFJS9lK+3C/RMOw0odRm9lxGzdxV4BXuRMaSkkpYXkk+gDN1cy6KOYw0I?=
 =?us-ascii?Q?psY2ElTDOTIeKkyvjJ7rc+68ZBkAjvpNRZHxPi9Ygu6wf9ChUEngqKIn4eVU?=
 =?us-ascii?Q?vkuoIG8N4uJ1dGHgZ++nNT0U6mH9xy6k858RMVTj/RqDsT5A24YwwmDAAf1A?=
 =?us-ascii?Q?xQLcgbNlkYZ/zvdB+9Xcp9U9L//zg2ggpv+u31OetiMV2mZOd2CBWXkuWcuN?=
 =?us-ascii?Q?LMYwVDaQQ/Fi7DmZKEkg8Q4d3ARjyOT9/2amHHWYkKb+itHAFFImF6MEoGer?=
 =?us-ascii?Q?Kqi2hdzvxLX17Ty29jmvVEz9r4/yDCJaAvgdpyCP4RUPLXe/+RIEflR71/Ds?=
 =?us-ascii?Q?KvrSPbE6FYs8B+KMZSeI+MGbG5copSGfO3WJ0jNBxDkjWshL8E2oKlMvmw1G?=
 =?us-ascii?Q?c2WmRRvhLGQ9oSTMJBMbvarsschIMU+Q60udxc7fM/2rFtTU87C/sitWL11G?=
 =?us-ascii?Q?2kTWQUVRFt9Z+Rz6pdYNiZRhVlZSQA//CxL7gY3cpskSqc3iLc5xxKHA5VOR?=
 =?us-ascii?Q?JNvWrAc4rA3Or5iy9nv3jbgsapY8zseyaOsiElZdxaA22+kKzfpnC4NNDnbg?=
 =?us-ascii?Q?SoHScAi/0Lew4XM3pavIMsTFPuaWY5YUowb/Uw24HWcciG5Mi/WPBm0ZHwqi?=
 =?us-ascii?Q?RVbjYmiNLJfQw57KHUvXdgkS830aD+WjNFXlX8mJ8X4m1cfkB2wYil3DdR3m?=
 =?us-ascii?Q?hhTpuYS2wkcPG9Ar3uN7SzGNS+b6qNuB/jhTOo6w1b3H+UR8mwJDFbQRn2xY?=
 =?us-ascii?Q?fqcaHkdE+/XJpjc30RbYJjvywumq8RX24DOj2Mj/i+LFP0F1FM9m1KHe4KGo?=
 =?us-ascii?Q?R8zMc4Y+5r1h4ElsscHINNEFoIBN0Aj9fdKIKcCvlvV7m37frf8JbrFyRNiB?=
 =?us-ascii?Q?6fMdSPOU6zCUIZ+uUiw+CvQypgLHo5fEbLTGMBpOlhF0Oef6lVk+ebHM2fU5?=
 =?us-ascii?Q?xJIEp7jm5OJqjVdirOCjhDNwkjx4048b30+u+hEw0m3LP4ZBWD+SzG0kyY9H?=
 =?us-ascii?Q?JgT2tzfcl7hSmJepW3awekirIZenCWmqyNEZ1SoI3/XYMH6/F6MUfeyWUbaM?=
 =?us-ascii?Q?+bmEhvEecYt+r/u6BSeWacnPodh2FBYa/wdkvmdXBlkbGTN3XzqfnzK6jDw8?=
 =?us-ascii?Q?PWAMpAWl0V765JiEgQThTy6PAa3qvjs4vnxeiaCVyBJLKrZgDhn1IF9NcVn6?=
 =?us-ascii?Q?Lohvu6gozwlgu31S4JJ66BoKbSE4R6jBxKMmtcmr?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a921ba-954e-4a53-73d7-08da95d614f9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 22:19:53.5497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+RR4KIHhakAbaogLqvv/CF5OFHNS+zcKecVtYo3my1lqqD22rL5rbJMjbpgi6On
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4573
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
implementations.

The current maximum values (16 SGEs and 8192 bytes) cause failures on the
SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
and for debug sanity, reformat client-side logging to more clearly show
addresses, lengths and flags in the appropriate base.

Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general,
and to be tested with XFStests here at SMB3 IOLab this week.

Tom Talpey (6):
  Decrease the number of SMB3 smbdirect client SGEs
  Decrease the number of SMB3 smbdirect server SGEs
  Reduce client smbdirect max receive segment size
  Reduce server smbdirect max send/receive segment sizes
  Handle variable number of SGEs in client smbdirect send.
  Fix formatting of client smbdirect RDMA logging

 fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
 fs/cifs/smbdirect.h       |  14 ++-
 fs/ksmbd/transport_rdma.c |   6 +-
 3 files changed, 109 insertions(+), 138 deletions(-)

-- 
2.34.1

