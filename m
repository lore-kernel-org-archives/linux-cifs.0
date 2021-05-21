Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F10EC4707D
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3080A613E4
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 15:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237382AbhEUPVN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 11:21:13 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:44561 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231446AbhEUPVM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 May 2021 11:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621610387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=sQ1y+MtdP6D5qcve6qMqEdoxEpBopMjw0zXtO5NVna4=;
        b=CsUKmHbtRrQln4Lsi/BiOy7deM3e4RiK/FvMH/sAWDZgC+KxYGgTuyDMuWcBsiPKWoVA1a
        fhyRAblelrvvcZr+iBpJlwsT1e2RP0uXPMGQYvlWtOymLk51Pp9sPaNgd9IV1X2izVu67I
        vs/N2f35tvpocKklNR2NwnXSXFlmmGA=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-21-b4oreCGeNn6RRTxMyN9ZFA-1; Fri, 21 May 2021 17:19:46 +0200
X-MC-Unique: b4oreCGeNn6RRTxMyN9ZFA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6iMMO8IXkR2R8QVIXLfhq+e9haM5mmJMI3E1sH/ytv+wJ5VSztKddoNtYVXTI8AInlnf4pTcI5SRcVXTc0ehhXzP8PEWTbHAJHM+bzudVvDs5gv82W38uAadhn2sQF5u9Ts8CS4qijmMklVmLx/IR5aeCkKu7zFqQLUDqGunGWJnnKcfuWyr4hHTertAmfs6wk6Ylav3abBKB8DRpHqysCur/UxwAMUMSY8ggsrE3EDVWHlZM6tiYFiSqrnaOHcwXTGscGhv7w7LhDmr3AuVLTmhcJDV39GZeovCVMPn1pyjNLstlxabHCdX7c29mk9v40VMB79bB4vOSCM7/h7zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTk4RF0eR25ew/VR8qnKBzSwoXYF274uVj1uodwlIzI=;
 b=oUZofeSKwK3YZfLH85YUU11MzkGltsnHKDJ7x/8T+68pyIHPx+frMBii4HAUFq+N4RenL7xv+XZPmUfzaYeT/xEE3GQkAWmDmXA2DOr/8UkXBcra313PDDRb1BqJUkpNANvvBksL7vaqUr3C44C0R60fIyLxQHMtiODrMYAgIz56nC9loVqSa739vmKNctZCe3Kds4gUBXhXwWySutatvH0PiumvQ3sIdrwh/c9P8rQitSyQZofJp6MfHVr+gpyhkubkotH5EN1/54cpkxhzYrMCmJTVrHf/0SrWZVI1OfCkXaDaYYUzYjBULf3qYJ9g7Po93KPymARsfsPjIqhWyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7453.eurprd04.prod.outlook.com (2603:10a6:800:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Fri, 21 May
 2021 15:19:44 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 15:19:44 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, metze@samba.org,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1 0/2] Change CIFS_FULL_KEY_DUMP ioctl to return variable size keys
Date:   Fri, 21 May 2021 17:19:26 +0200
Message-ID: <20210521151928.17730-1-aaptel@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 15:19:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f225dd36-986b-4ada-50d2-08d91c6bdc9a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7453317506CF8BCFF676B9FAA8299@VE1PR04MB7453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FojTbF7zU+ijcqLoiJWCPEfqVz6g/6iRKcs9ctw1KX0MF+vmG3WVdIbXqw614P8c/iZGJZZ9akBpRQEbRSmm5fRvPkcYrvpODhdHsHG7iHNVm7+NgHCEseykUHqXIAoXs5TXMU0yFeQOHFgt+93MuZ+aAH23pIA06kmfIzJNi+INxJI1JL5n9wA/LYG2rtE0SCYemWW8OCkJktrrRXhcVSZAga6lLUfHF1HeHurM++100dWRVg+ae3RvYFjkx2CqWR2xbbH3i4qiEsCjjOEiUDQE6dP4riG8ZZm9i6CZLpT8JO/+FyN6fc8J8Dw5FOGgSufOTr53lvmZPqW5mNk0DvX0n3EhjYGfGmjKkxHc/cXymcb8DVBSakpzEknnn3enKz4dy8KJHXgw4PvGxot7YegaMOKVouR5N9gEWFCsk5xo3jaVM0fc3lgRkCqZEvul5OAadKS+D7kgUzaiTsIFYOCF8mOn4j0ZgsowdPk9rtsx8YHNNA+ctFkVQAA8VH2J8VyV9JoJD5yDC+cPLnjzng2HbiBGrl3kBk4IX0CtcusVYsBlR3PagZOaPoSeg54mOhfYiSM6u/ausl3vwpAxcsiIrNcqIJGGXNfWOkrwwsHRz3k5db2PUb5oS9GFqR+u/4JP/JnTuFENr9grFTTeY2XlnQ/4Jb1frpHGB/UsUS10e5Cu1p66rEVbXqxGXvr4aNM9jRGIJIKPvQS/AQcG/FgEyXuGFiJGjTG4TV5hIFzWSbIVWW09/TWRRWONoFstAoKTpNnaH0kg3surXPzAjY3dIuLJLnRKlarMQ2uiBfGkkIjRvA/jFJ0e9meF+bBH/IRFDQiqq6q04kzYgkddgiVWPnkaIrFcNbXIgT8JbaixZxTEIiqmfN5eMpK/2DsNS3ZJOdgEsk47xAKLHsgrg2B7DbtXMz7C0hjtROr6Ih2ZzZD9iM6qEizD6vBLEqgkVRz
 lp31GO5eh2KcKG1wzyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(316002)(1076003)(66476007)(66556008)(8936002)(52116002)(6486002)(6496006)(186003)(8676002)(16526019)(2616005)(4744005)(86362001)(66946007)(5660300002)(83380400001)(6916009)(6666004)(2906002)(478600001)(38100700002)(36756003)(107886003)(4326008)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NpgjPWQw/lsTchJqBd6lJ4a+oPE7krP319WQkbSqbje6wqdwo6/eTFYUAdi/?=
 =?us-ascii?Q?gk9g6Py0Nx9BfaEMTal4zGf6Om+tNisqFlDNZc0dv0tw6D1axzxR56hP6jAP?=
 =?us-ascii?Q?Pwq9KLvR0HLaMAHdEi+r2vzuAa2uAlTNwVIHyxKad9z5TG3Hu4ghajouH1Z8?=
 =?us-ascii?Q?rGLZRO5u3bnXDoiZMTfYFpbm6UTDAfnT+rOZatyte/5uQeHPlE6GOfaMz3PK?=
 =?us-ascii?Q?bFOgSEj6of98Wx3VYgsDEfEXws3CtUOG/XbLCQwMMn92zDRJ+SsMli5nMWc6?=
 =?us-ascii?Q?yLIwjtEC0d5Na5pWLbN9ixNhUev7wyt4QmKS4I7ZOdcr7o55RtpuUwRhm4V+?=
 =?us-ascii?Q?Jcz9zWyWBVKJCVvfVlFVfbISa0hfjmg7HURXR6Bs/KYw/XYY4YrbH9mYhdQE?=
 =?us-ascii?Q?1WnTZgZDIO8f4zx72nNfEOtVCiqhGwXZmGNXz4D4glWI2tjFLYpEz/w7zz9K?=
 =?us-ascii?Q?jK4LgF0sxSMYxQrT7qRqMH1VTMJ4ZkjIheDlhtz3NReKvw8kegwgUSCVEkhg?=
 =?us-ascii?Q?2eJHEVTP35G/DNogIREdZTcq/Cie7yQsSc3tQqq/DhCmidX+a2rKX0NqRfqA?=
 =?us-ascii?Q?S60AtomZL/RsueHZf+xFhOuPaQVyKm50vKGHD88QH57TRWe3FevEesZRbbwW?=
 =?us-ascii?Q?9Z4nViHJCkFCHpBFDf2oOnk2CZya1JpqsBd2KEh0tfXRji4GRXbZre05mFrZ?=
 =?us-ascii?Q?bLM4yaP21I56rksz7NKdbZCEMVEQ8XKvKi8Q96dAJmkkMk9xW4cbBIacsaPf?=
 =?us-ascii?Q?+c+/0dra6cbKSKh7Gb6gK4YN8ljXM879UUKOdBwLvCG+ChbOzshNCpDueg8e?=
 =?us-ascii?Q?enDIae9n2ei0/gZ4N7MKoYvofuY0mlTSZD5b1h1eRMYsfXhbR+4nZdpmHOm4?=
 =?us-ascii?Q?VVmExVJ26VOMy/klTWkBi334PrEUApYMvNtNmb1SITVf2i6d6hOh3G6AVZ39?=
 =?us-ascii?Q?nJ0spUc3QNLoAwfP8NjwNPcAKG7gwrtdKNNpYhI8UviwOxAq9HkHn9ZPjczM?=
 =?us-ascii?Q?LZO0kyeT3OL6Hv0So3Fp6KQ46/0K3UCe9o8V9iNo8h1nxt3iHO2dJVQ0Xth3?=
 =?us-ascii?Q?s2UQ6VhlWYmeiod9kXAgv6YdeNgGIxumEvOFhm7neGy3c9mIQLOPjkmaA0nl?=
 =?us-ascii?Q?JkzXaFcbd8XpTk3JGQIeVcIWYFJI0MEJGKLz4oGe0ASrkbmT349CCmzeCwHG?=
 =?us-ascii?Q?uiU5tYk6FEOwlF+R1ze6LUqTZA0k1UJ6LlijYDqZpClrvqY4k7fC1JJ5eD6G?=
 =?us-ascii?Q?D9MZHkx8w0VqYYu2YyVw3dEA5EcOtDRKZGXFKfQfts7HfHfFk/bkQLwBkfrb?=
 =?us-ascii?Q?tzfHtrmKaC6ydMnxu/pvLXT/J57pk4owLdJqTdO9gZ95t8EddDofgzK9zsUW?=
 =?us-ascii?Q?dUMYWXo=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f225dd36-986b-4ada-50d2-08d91c6bdc9a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 15:19:43.9084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEV60hlMEyvaYz4uhUyzITRfPa07NrCLI42tLc3xit1rGKQXwsMg7ktLPsxmHGVy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7453
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

This patchset changes the CIFS_FULL_KEY_DUMP ioctl to return variable
size keys to userspace while keeping the same ioctl number.

This version of the ioctl should be future proof if we ever add more
cipher types or bigger keys.

This also fixes the build error for ARM related to get_user() being
undefined.

I have tested this for AES-128 and AES-256.

I have a separate patch for the smbinfo utility to make use of this
new ioctl that I will send in a separate thread.

Aurelien Aptel (2):
  cifs: set server->cipher_type to AES-128-CCM for SMB3.0
  cifs: change format of CIFS_FULL_KEY_DUMP ioctl

 fs/cifs/cifs_ioctl.h |  25 ++++++--
 fs/cifs/cifspdu.h    |   3 +-
 fs/cifs/ioctl.c      | 143 +++++++++++++++++++++++++++++++------------
 fs/cifs/smb2pdu.c    |   7 +++
 4 files changed, 133 insertions(+), 45 deletions(-)

--=20
2.31.1

