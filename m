Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5504AC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 14:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 268C061108
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 14:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhDIOEP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:04:15 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20630 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232615AbhDIOEN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 10:04:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617977039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=SB6KviDhcx53AnzLwQ2xPf+peWlbiUuU2jREOWRjobA=;
        b=cSCt2zcgXi0phYF+elMKfSFGhPlHhT00InQQ9sVh35sdbxYcCez5O2wzOEeTFASl8FHsMB
        Cj2TFRkwYkYi1by+wktyIrE8Cdk/g4uHJUh9luDGaVyZNzu7u1l7ZnnzpWyzeYShHTN/z/
        fKPHEiG4dumJhwfHuOVgARqwNtlOhQI=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-GEYG4E4BOGWeKPHc-VQ1rw-1; Fri, 09 Apr 2021 16:03:43 +0200
X-MC-Unique: GEYG4E4BOGWeKPHc-VQ1rw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht/L9j52DlHGLgq2XSYb9NBXgdOsXT1N0702W/iyjd9js63wMLDl3s1HHT0Fo9cGtBKXqxHfUoKqaNDvgvKcCpTgQvEgycm7KMwdjSs7e9Gbg7nNkEka+gGxgDlxc2TIx1MwRy0iBhyQBRyuyLLa0YV5XVI/gw2jcijHjS9Ru1hgl2/g2s5r2zmCZ0eqoMcfLDd3G79RHrDjVIXrWPvp4ADfrLog9xxTbsULWJluQ3iRMa7JgkrrgIBi42N7juAuUkvORUqhi8WIg25R5vyETkEqxmzcv3y+psdwuzoC9F2nqob0XScticspaI5Wmq0bG4o4kH6OJ0toyirCDWRO3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SB6KviDhcx53AnzLwQ2xPf+peWlbiUuU2jREOWRjobA=;
 b=LIc4eMhkt6IUKwyyzkoFjxf1TynbNPOubmHPl7Be1z0yj0DhLuOWU29Q23664TGQNLMlYvYYM00lC5mVX6V3BzKoDX8+N6fNOnW+YN9auT3qBFi6DPJu00Di15W/3DR/nbV4oz9miEUUlb4zlWKgu24lqyOdUqOfOxXlGTQ83C2Ecx711g5STnNYhK4wVmwlf6A5LJzV1JcqmndTVdaZUtkCveUkdoMsVadd270SUPO3TLyQmswvsX0uvACUuU8j0X+V4YvA8bgtFsiK0FFB+DcbltaBkVmnP3rEnnf4HX1BYjrIQBjwRLmOIN5E0adP6vgSLehmXcPMDClRdgbnnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 14:03:42 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.035; Fri, 9 Apr 2021
 14:03:41 +0000
From:   =?utf-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH v1] smb2: fix use-after-free in smb2_ioctl_query_info()
Date:   Fri, 09 Apr 2021 16:03:39 +0200
Message-ID: <87tuof3684.fsf@suse.com>
Content-Type: multipart/mixed; boundary="=-=-="
X-Originating-IP: [2003:fa:705:3046:69ee:cad4:97e6:ea8f]
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3046:69ee:cad4:97e6:ea8f) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 14:03:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24752bd0-990e-45db-b47f-08d8fb6047f9
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB29117B2B7842EDD86591C0B4A8739@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zuvjNDJaPsK4jXzOsxBZZhsR9FsUWT7i6W4yD7kBLjaYMMZuEUFM6h1G1ZN6EnQg/3atRcPIGYbcB4JLEvrz3wyxFec5f1yp+gXOCRdWbfbXDUDvG0g1fU7tZum0YO5tAtFiTLpt2qMruQrcB6yf+4jTqXiPVIQvHmCu7Bn5XQNGat+jiaqAdxquSyuEqMEnHJspCoVmJ2oFTYfMwXKJChco7z8BZ27nCrZKtIYsBGo8Fq60569XpHeKWQrscq3NCS0xOtGaI/5RzPEbPQYH0Qe/5iuEPglT3X89ViuQdnRwze/o65m7OXqictmwhy4X89PFyFOV2vUNuiv3TPXkOlH+dXH0T1m1RBwDEsroUtIkfmoVyhXW/0rcbpdojnetZrpUlW+tEe9lYoVOu2r4xJkKgR0G07Py1Pt7o0WupTpr75IFL6zB8cnu9u+qn0nHLWni+oFp2BbLjk3f0G+LQGZQ4znjFLctEtjOgvOx63ASCqoNaX99Uow7FW+dSDZHOd2AbfqCW63lmlJmUwsU2xXiurTyDKWD+p0/RbcF4bjbo0MS9xqFLk/taMrE1VRSJWaHZozMcKevPa/VtFbBjkvDyB1hyX0ovz+5QWf/PGmN65YOOq6C+twyQn9pYRuG4uETAw04HUtZz5vDiCw6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(136003)(376002)(39840400004)(52116002)(8676002)(478600001)(33964004)(186003)(6486002)(16526019)(66946007)(2616005)(6916009)(66476007)(6496006)(5660300002)(235185007)(316002)(66556008)(66576008)(8936002)(2906002)(36756003)(83380400001)(86362001)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UkRXYAgKtIXqLj8OsNifQwrnwEVYCxCWXwpAkmYUgfPg5jnTfBXelju+olUs?=
 =?us-ascii?Q?1b5KqJ3f+HJ/crBBwZ/FypxAeSN51fAQgBU1VvqzcfHhI6gJ0IXC5ZTWCf7N?=
 =?us-ascii?Q?fNQVPXwcQzk20phYEBeGhQtJpIuXjkM9Udaq85t5nOP8/h9zfLHcVdS324JT?=
 =?us-ascii?Q?9bosVC3XpGToPNxP9Qo2frKakcwVnlZ9S2dreHojokxEkQgIUUd/uiJWZOnK?=
 =?us-ascii?Q?0yU9fpgL/S2eMyRfqG0sirlOaikArvMLFqGIt8+LRFcY0NWGod/VsFXWfEIL?=
 =?us-ascii?Q?1cPcipe1Zhxrnc+IHSuwIfIrWmwOj9uqengo2U+372TEB+kw4HXbdAqxdAoy?=
 =?us-ascii?Q?7x7MG6sGHNH1zRye/awFF3NzIJIEc2AeAREtnCfmhR32O3t9f9qctTGPAHec?=
 =?us-ascii?Q?eVZGUBED4D8xPuY2Dfyd+KCWqvklLdf/S7/k45DSf9tBoeHakXlztm0NrWhw?=
 =?us-ascii?Q?ldu+3hJKhz7e/caKj9QHkpnc6PMGTVkuA3oaPXxWrGxWTIO9hBdBKfo+Il6o?=
 =?us-ascii?Q?1PQ6WSdhOpUHh2/yxNRndZQg0dMf0wEcAn3FVGaR0AMyklGalTSYAqPOYVsW?=
 =?us-ascii?Q?sAq1x9RR6I08FeykQvWJzA8Gve6wei8JM8LdaqhPbTQ4mnT3ITBtf5QN3PQ/?=
 =?us-ascii?Q?36P1YHSUfztoskmnmYO6crcHXUtH71NmLRsyCXO0Cv3LMTH8BXrhb4qoVNOo?=
 =?us-ascii?Q?No3n2Yjpn2YzY4iEenwiAcMX8/UvORdpf2c4q4ClJvCE4DWKKsIgPEM7pR8U?=
 =?us-ascii?Q?/pQ9FqUXz6tttIjXhkwfXypvEyfM1YFMYwXZCPcUE9jRA7pJil7YqLlwSVTn?=
 =?us-ascii?Q?EGrtpN1Yz8G5X6gTFZsc4g/P8wR2+rzvtDYaYVqrnF9r9Rd9PcThLTf1hFCl?=
 =?us-ascii?Q?0nXnR+d+WS83NRaelccJNxCHwSv7Iqmdmp+l7LVSJzhUojwFsVssW2DRc6Kj?=
 =?us-ascii?Q?N3LAwOAxGpOIB1ci8Q8J/jf3eTeNg/pbzJNvyF0pjmiRGMDF73mwkIfsGFcp?=
 =?us-ascii?Q?yztr0op1Baw6Io2AqOF4MWZmTsX9vywpPZ5N3xiVf17T/6yiBHFgbFOe8xK8?=
 =?us-ascii?Q?BKNlbhcjtalOs/n+Ns9tZoT1ljTrMlNS3O3izMOqHBZRwzHRmvEDHcMM32dz?=
 =?us-ascii?Q?lpnAylpkdOfw5yK82UcapgJcWaNbyjGZnp0wkooYiMaDm+yuX/k7OrkezAI0?=
 =?us-ascii?Q?/8jcziKnF2pt/NEIj0F6zUI0U+oMp5El3aIrQ0NmWU96BSjwpTKfeGjreYX+?=
 =?us-ascii?Q?h6HR1qx4pppc4Cb6fkcjxJ7fbgDpwrqRU0sxO4MCGftv/W13/Ang+JESTmSd?=
 =?us-ascii?Q?OCWD1FjRoX2CRts21CGhi/vWoRyjuvyALfPdJTa1p3lSxvDk8a8Nkkh8C+Ls?=
 =?us-ascii?Q?p4QFHVcrPu1HcnFYXhxCWQvdszKp?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24752bd0-990e-45db-b47f-08d8fb6047f9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 14:03:41.7803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OAqk5sGC0FI+UL1uqZ5kwAztaHK2ESQzWSIfr8qGnC48g5NuYjxoY/NQJn6/Ykx8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi,

Ronnie, I think there are some memory issues (use-after-free) in the
smb2_ioctl_query_info() code path.

I have a fix to get rid of the KASAN splat. I've reordered the kfree()
calls but also replaced the SMB2_xxxx_free() to simply freeing the SMB
small buf.

It could be leaking the other rqst[i]->rq_iov[] though, I'm not sure if
there are extra stuff we need to free that is not in the vars buf. Can
you take a look?

See attached patch.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-smb2-fix-use-after-free-in-smb2_ioctl_query_info.patch

From 47619d3e1e319ca9900f656a5dce25d0c563cebe Mon Sep 17 00:00:00 2001
From: Aurelien Aptel <aaptel@suse.com>
Date: Fri, 9 Apr 2021 15:47:01 +0200
Subject: [PATCH] smb2: fix use-after-free in smb2_ioctl_query_info()

* rqst[1,2,3] is allocated in vars
* each rqst->rq_iov is also allocated in vars or using pooled memory

SMB2_open_free, SMB2_ioctl_free, SMB2_query_info_free are iterating on
each rqst after vars has been freed (use-after-free), and they are
freeing the kvec a second time (double-free).

How to trigger:

* compile with KASAN
* mount a share

$ smbinfo quota /mnt/foo
Segmentation fault
$ dmesg

 ==================================================================
 BUG: KASAN: use-after-free in SMB2_open_free+0x1c/0xa0
 Read of size 8 at addr ffff888007b10c00 by task python3/1200

 CPU: 2 PID: 1200 Comm: python3 Not tainted 5.12.0-rc6+ #107
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.org 04/01/2014
 Call Trace:
  dump_stack+0x93/0xc2
  print_address_description.constprop.0+0x18/0x130
  ? SMB2_open_free+0x1c/0xa0
  ? SMB2_open_free+0x1c/0xa0
  kasan_report.cold+0x7f/0x111
  ? smb2_ioctl_query_info+0x240/0x990
  ? SMB2_open_free+0x1c/0xa0
  SMB2_open_free+0x1c/0xa0
  smb2_ioctl_query_info+0x2bf/0x990
  ? smb2_query_reparse_tag+0x600/0x600
  ? cifs_mapchar+0x250/0x250
  ? rcu_read_lock_sched_held+0x3f/0x70
  ? cifs_strndup_to_utf16+0x12c/0x1c0
  ? rwlock_bug.part.0+0x60/0x60
  ? rcu_read_lock_sched_held+0x3f/0x70
  ? cifs_convert_path_to_utf16+0xf8/0x140
  ? smb2_check_message+0x6f0/0x6f0
  cifs_ioctl+0xf18/0x16b0
  ? smb2_query_reparse_tag+0x600/0x600
  ? cifs_readdir+0x1800/0x1800
  ? selinux_bprm_creds_for_exec+0x4d0/0x4d0
  ? do_user_addr_fault+0x30b/0x950
  ? __x64_sys_openat+0xce/0x140
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fdcf1f4ba87
 Code: b3 66 90 48 8b 05 11 14 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 13 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffef1ce7748 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00000000c018cf07 RCX: 00007fdcf1f4ba87
 RDX: 0000564c467c5590 RSI: 00000000c018cf07 RDI: 0000000000000003
 RBP: 00007ffef1ce7770 R08: 00007ffef1ce7420 R09: 00007fdcf0e0562b
 R10: 0000000000000100 R11: 0000000000000246 R12: 0000000000004018
 R13: 0000000000000001 R14: 0000000000000003 R15: 0000564c467c5590

 Allocated by task 1200:
  kasan_save_stack+0x1b/0x40
  __kasan_kmalloc+0x7a/0x90
  smb2_ioctl_query_info+0x10e/0x990
  cifs_ioctl+0xf18/0x16b0
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 Freed by task 1200:
  kasan_save_stack+0x1b/0x40
  kasan_set_track+0x1c/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0xe5/0x110
  slab_free_freelist_hook+0x53/0x130
  kfree+0xcc/0x320
  smb2_ioctl_query_info+0x2ad/0x990
  cifs_ioctl+0xf18/0x16b0
  __x64_sys_ioctl+0xb9/0xf0
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 The buggy address belongs to the object at ffff888007b10c00
  which belongs to the cache kmalloc-512 of size 512
 The buggy address is located 0 bytes inside of
  512-byte region [ffff888007b10c00, ffff888007b10e00)
 The buggy address belongs to the page:
 page:0000000044e14b75 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7b10
 head:0000000044e14b75 order:2 compound_mapcount:0 compound_pincount:0
 flags: 0x100000000010200(slab|head)
 raw: 0100000000010200 ffffea000015f500 0000000400000004 ffff888001042c80
 raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff888007b10b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888007b10b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff888007b10c00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                    ^
  ffff888007b10c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888007b10d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2ops.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f703204fb185..2ad24a37e571 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1763,18 +1763,14 @@ smb2_ioctl_query_info(const unsigned int xid,
 	}
 
  iqinf_exit:
-	kfree(vars);
-	kfree(buffer);
-	SMB2_open_free(&rqst[0]);
-	if (qi.flags & PASSTHRU_FSCTL)
-		SMB2_ioctl_free(&rqst[1]);
-	else
-		SMB2_query_info_free(&rqst[1]);
-
-	SMB2_close_free(&rqst[2]);
+	cifs_small_buf_release(rqst[0].rq_iov[0].iov_base);
+	cifs_small_buf_release(rqst[1].rq_iov[0].iov_base);
+	cifs_small_buf_release(rqst[2].rq_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	kfree(vars);
+	kfree(buffer);
 	return rc;
 
 e_fault:
-- 
2.30.0


--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

--=-=-=--

