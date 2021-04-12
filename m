Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CF6C433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Apr 2021 16:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D3AC61350
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Apr 2021 16:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbhDLQCL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:02:11 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:28708 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238937AbhDLQCK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 12 Apr 2021 12:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618243311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nmhZOuSQwEhsXB2FchtYeMVWvjWn0FI4HoRC6A0lFMg=;
        b=LZf83hAFX6hzTaWHmZPx10C1rEnyogklx013GXrZk3aQhWgQtiHUESHq50Q6d6xoOdRdp1
        oUd63C1xs2lQbXXlUeEq5FaZYpLTkiaDckBuov7SGagPbZoV6RMYvrNUoR938AleOfvat1
        iquUQd4VroxjvD3Z/E7bj97HFdkTy4w=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-GQ5arQAuOIykL8Q5w5cVqw-1; Mon, 12 Apr 2021 18:01:50 +0200
X-MC-Unique: GQ5arQAuOIykL8Q5w5cVqw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/HatqlqFsaXvSzCLCnjD2JFbJxF5SQGjUZN772OjHn51VNfJmbxCKIPk12XeKOiFkuUbhe+xmR4Wm5oWrvnu2oOH4tUgAMJvIFhIcrO4+Dlz8+AKpTD/zdybaOdL4+tXQNG0UgnpKKUPhYQGv7gN7liB4/H/BvENLoPvcERU/6tGzNUi9tUSsjAyKmMIbvyG9+IBcZLdtRQxkh9hJuV7LxpgzCN6Fzo8YZ0z1e/YhrmbrKvpvLrMsvcFekDXbsQ3X+luXVZUZ9U8xMaENnKSTIm60pub9p61wEiz9f625HbFTSCfdb3BmSK06SNnRNk9bf/H8aJsIETH4BrZ5IATQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lpF33TaxW5o7xGpXavlDFh55Ak3L0hIUJ1jFWfIR/2g=;
 b=mUHKVVrxlL4Ew6+LfUBn/Y+ciDJoSZcYPP2Ad4bWnpkwgKRk53vNAeYEQZaJxN+KLOBvWsPKHIBZ9GR8HLqLGEiHKqKrF9sCLmeYDhln3wce+XbxOXok8S0im2Q9zTF5cErfsvS4YEb1vAvS16E/nSOVU6tHgdICfocS/U4tTRa2JiQliUckTvXdAP/cah0xSQ2xc+T+i9PfLTM78531qkPi+90A+xRHAdJEjCXcti1Mtjkdj9lKsM0xNXF8juthjQeilen1sYLLcpenM0C6NOL6/9AAF8NEb/aX6Dk8rxilXvOLcS35kiYyeg0YzxJ0HJfl58fSrhyB4Bo97McRKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2400.eurprd04.prod.outlook.com (2603:10a6:800:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 16:01:48 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:01:48 +0000
From:   =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
CC:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v1] cifs: remove old dead code
Date:   Mon, 12 Apr 2021 18:01:43 +0200
Message-ID: <20210412160143.7412-1-aaptel@suse.com>
X-Mailer: git-send-email 2.30.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [2003:fa:703:389:f439:5b5b:3992:60b2]
X-ClientProxiedBy: ZR0P278CA0023.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::10) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:703:389:f439:5b5b:3992:60b2) by ZR0P278CA0023.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 16:01:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb30007-a6ab-44a4-20b2-08d8fdcc470c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2400:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0401MB24002CDB9690FC6C726D4AC1A8709@VI1PR0401MB2400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PTwEv03CbdC/Kq/AnOseJSS+SjQwt6/Tpsv35opHW5zDl/f6uNFoUW1nIY5BDpUucwUCgXwLg5YlsZseNS5FkVWQ2CacU1Pm0kbPvfOR8YFKhZ6ctGPaotL/Eh3dK6cbXGpu1x+SRtJZhA1V9PAL6c6BVXvaVsgwAAeEDmU8RJ4abrb/TwMsQGLrBQcfX6sdWXvZDcQFgoA0HOiRSsYhGbJiaSyRdPW+w+Aex2gj6zo4/VF9PUuYDGW4CBn/NUm5Oh+fvtfbHP98Co4Q74ZpPxtI9efPMcaET0on4x3KmWSuuqhRkPHk/qEX8bx6lx/pdF57RaOa+ezTFO/bmNLyhb8EsQkXg9ka8WJX/SkUBkhIM2zt1KQlaFXzD5EpPdL4cFmy8kt957RGEioISOgl043KrJM878Z6g4y5B5eibKhy4E4AQ7fXAL5+JYacbpFMiJ0UeZjgOIa3e5V6h5/iMMTwriEJMWr3TmdG/p8jkFjR+g0U8A67paLPyRkerK6DUElwOGQaZK/3CnqUjVH8QIZ6NIknMPyJyJyVUXmZx+D++4fa0x9StIj68D5psv/0uKua5q40NgHEhfoviRBlG5H3mmjTs0uvEWcscBk1QP2pxMAaDGBi+5RG7Bllu/N+jKaNQprtMoXbjZR9298I5zUCZhbxUd5oaFmpqIx117F7Mr16SR5mn1Tl1xOTqmphUYVuXKYNFWGpv5qq0ARduEDSaZJMrPZeqhrzTv42YNZDiDHQ8Qz1y4tr713TSOYHJhkrO4l1QjkQSfbhLZYgPYz4O7S89HIrF54t67gVim3tKl4ZT66pxzkJA3tnDz3RhHz1JE7WWHsB7zPFyALA8KttmHky7rEpa9tD+fdVjVuQ52uMDBmc3PlnpIVsWsKi9G1ZH5gQ+DhU4hRd2G5Wr6fvNLylkD55JAXl923LcAEcQrMJj6MqyUxk040BvqVXkAg
 wjOaEaM/GxOlL2hVSiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:OSPM;SFS:(366004)(396003)(136003)(376002)(39860400002)(346002)(6666004)(6916009)(36756003)(86362001)(107886003)(478600001)(52116002)(6496006)(1076003)(38100700002)(66476007)(66556008)(4326008)(16526019)(186003)(66946007)(6486002)(5660300002)(2906002)(316002)(8676002)(2616005)(8936002)(83380400001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p8npbVjchcENybPCrPONWhaB4vegpHJgVoiUhElnCtoh5ml+56i8TMCJNeeh?=
 =?us-ascii?Q?iB6AozHQSBqe0baRo+RtSa5ussJLOPlf69l6tIHDqoOzvXBjzr1beiDk1lD0?=
 =?us-ascii?Q?JAcPnkc4dJDCp+oYECcyGUa5AsR5dR4+fT50sJA7erefXJVGNW0Hwn8dX2CI?=
 =?us-ascii?Q?587vYu/mlBmhk2UeU++WJaAIR0Cfb4l6+XcmgjOrDU4G8XD0HlTHdbsyRngI?=
 =?us-ascii?Q?giDOSAn8a3IkvntmI1RZR9m1xJ4g10bC8FfWdLcnmzS6njaJplUKubIEMK2p?=
 =?us-ascii?Q?BUE+AP7vWkv4w4LTz8cvabHCN2cuRWE+G8Yh3Tw8k8E6uhJMGdpfB/0aIKyi?=
 =?us-ascii?Q?uh9ntLdRn4JzAMaDkUnXjsNBwctJptRbGcBIs0M9DCtVKp4OUx77nVPgV4H3?=
 =?us-ascii?Q?qp2tSMDCq4Yqq0XbtoFpWE9B96S4YLU+odCCi1TOLb+xL+QoFsKPclx/W+A/?=
 =?us-ascii?Q?Aqf0F3Jv3T4l8yQnvpzSV6Tw1BiIVkO2kqAVtEMW8JHEIt5PItDMl6Gs7rSK?=
 =?us-ascii?Q?kdquSBBPb90WHgKxPmE5pUvazoVdgjf460lRhGhoeaUmx5vDQuKK/Y88BAqm?=
 =?us-ascii?Q?UoxbLOZuYcluI8AbnjjBs7BtvqeNCy7kkQhDgTfG8CURyzXjEi0eqxPtPzQv?=
 =?us-ascii?Q?n2XLILCdKlbPJ1MJcSj/jgOuiffo4UbJ36UQS6ieQu9HsxYtgK/4ZaFqLIUf?=
 =?us-ascii?Q?ZYngU1AJ/39XfaHHt8SA/71xEU5IxZKyvASlEcV33s9i7iJW6Tbn46/UpE4d?=
 =?us-ascii?Q?6ULW5033NFkkEqa4VAh7zgVIOEeAwOYZeH9hLk3JjbU5sdTASHGM0kChDOcq?=
 =?us-ascii?Q?4/D0AZ6v5zFIPjap5ykffn1HXVEeLrTf+7n+AxTC2MD2lnzVvW7l39u2Mu40?=
 =?us-ascii?Q?9Y4v+oXZ/oaDfFluybqDVgA4+48U2IExBHhVsrRKl9s1puJIMmFNFI4E7m8T?=
 =?us-ascii?Q?LUyhcu7SxyEAcoernm3Y+dzk/bay8QsMShlgH3u0daON4XlgC6lSacr1RGtm?=
 =?us-ascii?Q?05W3nuvb3L86z1Tg12YI1QgTtNtAhf+hSFNJiWNS7CTsTxjf4hweJRaKT36E?=
 =?us-ascii?Q?oy7WaRL/K3Q/KOZRZ6L9CCNBkBcDPdJVpeTEgk2eOyZ3SL9FJyZhtzw0bx8p?=
 =?us-ascii?Q?vnWoW2e3qGXAgAwH5c1xCaZDoJ33uDnwYskFjKwI5Q7hQNSbBKzjQUJwdPYo?=
 =?us-ascii?Q?PLOFY1W6Wvq7pC1j4gadYnVAr6fL/V1l1jqMxTmoDIJeyktzbRmq3ZGkg/Zs?=
 =?us-ascii?Q?QNyLsSBk4xJenWB3gSN4ifck2NeRVfxqHkPGbMS2ak6dj9Cf0c3Kv0izUZIe?=
 =?us-ascii?Q?M/BMfhga681HT9Q6SaVhSAJWEdW/FP06MgQqUi+JKZbjIN8qIr9xoNO5UQxe?=
 =?us-ascii?Q?IUhYHoE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb30007-a6ab-44a4-20b2-08d8fdcc470c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:01:48.1137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLFRRG+IzDjlAVhqRUdpGC3ceaCLFa3PwaeTd5Je2lnYOG1chGsXEEShSx7DaceL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2400
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

While reviewing a patch clarifying locks and locking hierarchy I
realized some locks were unused.

This commit removes old data and code that isn't actually used
anywhere, or hidden in ifdefs which cannot be enabled from the kernel
config.

* The uid/gid trees and associated locks are left-overs from when
  uid/sid mapping had an extra caching layer on top of the keyring and
  are now unused.
  See commit faa65f07d21e ("cifs: simplify id_to_sid and sid_to_id mapping =
code")
  from 2012.

* cifs_oplock_break_ops is a left-over from when slow_work was remplaced
  by regular workqueue and is now unused.
  See commit 9b646972467f ("cifs: use workqueue instead of slow-work")
  from 2010.

* CIFSSMBSetAttrLegacy is SMB1 cruft dealing with some legacy
  NT4/Win9x behaviour.

* Remove CONFIG_CIFS_DNOTIFY_EXPERIMENTAL left-overs. This was already
  partially removed in 392e1c5dc9cc ("cifs: rename and clarify CIFS_ASYNC_O=
P and CIFS_NO_RESP")
  from 2019. Kill it completely.

* Another candidate that was considered but spared is
  CONFIG_CIFS_NFSD_EXPORT which has an empty implementation and cannot
  be enabled by a config option (although it is listed but disabled with
  "BROKEN" as a dep). It's unclear whether this could even function
  today in its current form but it has it's own .c file and Kconfig
  entry which is a bit more involved to remove and might make a come
  back?

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsfs.c    |  4 ----
 fs/cifs/cifsglob.h  | 17 ---------------
 fs/cifs/cifsproto.h | 11 ----------
 fs/cifs/cifssmb.c   | 50 ---------------------------------------------
 fs/cifs/inode.c     |  9 --------
 5 files changed, 91 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1b65ff9e9189..8dc2306c9092 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1526,10 +1526,6 @@ init_cifs(void)
 	int rc =3D 0;
 	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
-#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
-	INIT_LIST_HEAD(&GlobalDnotifyReqList);
-	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
-#endif /* was needed for dnotify, and will be needed for inotify when VFS =
fix */
 /*
  *  Initialize Global counters
  */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dec0620ccca4..107e1eebaba4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1827,13 +1827,6 @@ GLOBAL_EXTERN struct list_head		cifs_tcp_ses_list;
  */
 GLOBAL_EXTERN spinlock_t		cifs_tcp_ses_lock;
=20
-#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
-/* Outstanding dir notify requests */
-GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
-/* DirNotify response queue */
-GLOBAL_EXTERN struct list_head GlobalDnotifyRsp_Q;
-#endif /* was needed for dnotify, and will be needed for inotify when VFS =
fix */
-
 /*
  * Global transaction id (XID) information
  */
@@ -1877,19 +1870,9 @@ extern unsigned int cifs_min_small;  /* min size of =
small buf pool */
 extern unsigned int cifs_max_pending; /* MAX requests at once to server*/
 extern bool disable_legacy_dialects;  /* forbid vers=3D1.0 and vers=3D2.0 =
mounts */
=20
-GLOBAL_EXTERN struct rb_root uidtree;
-GLOBAL_EXTERN struct rb_root gidtree;
-GLOBAL_EXTERN spinlock_t siduidlock;
-GLOBAL_EXTERN spinlock_t sidgidlock;
-GLOBAL_EXTERN struct rb_root siduidtree;
-GLOBAL_EXTERN struct rb_root sidgidtree;
-GLOBAL_EXTERN spinlock_t uidsidlock;
-GLOBAL_EXTERN spinlock_t gidsidlock;
-
 void cifs_oplock_break(struct work_struct *work);
 void cifs_queue_oplock_break(struct cifsFileInfo *cfile);
=20
-extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
 extern struct workqueue_struct *decrypt_wq;
 extern struct workqueue_struct *fileinfo_put_wq;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 75ce6f742b8d..10c84a8159d7 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -358,11 +358,6 @@ extern int CIFSSMBSetFileDisposition(const unsigned in=
t xid,
 				     struct cifs_tcon *tcon,
 				     bool delete_file, __u16 fid,
 				     __u32 pid_of_opener);
-#if 0
-extern int CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon,
-			char *fileName, __u16 dos_attributes,
-			const struct nls_table *nls_codepage);
-#endif /* possibly unneeded function */
 extern int CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 			 const char *file_name, __u64 size,
 			 struct cifs_sb_info *cifs_sb, bool set_allocation);
@@ -504,12 +499,6 @@ extern int generate_smb311signingkey(struct cifs_ses *=
);
 extern int calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
 #endif /* CIFS_WEAK_PW_HASH */
-#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* unused temporarily */
-extern int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
-			const int notify_subdirs, const __u16 netfid,
-			__u32 filter, struct file *file, int multishot,
-			const struct nls_table *nls_codepage);
-#endif /* was needed for dnotify, and will be needed for inotify when VFS =
fix */
 extern int CIFSSMBCopy(unsigned int xid,
 			struct cifs_tcon *source_tcon,
 			const char *fromName,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c279527aae92..7fcc0fc4e68b 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5917,56 +5917,6 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct ci=
fs_tcon *tcon,
 	return rc;
 }
=20
-/* Can not be used to set time stamps yet (due to old DOS time format) */
-/* Can be used to set attributes */
-#if 0  /* Possibly not needed - since it turns out that strangely NT4 has =
a bug
-	  handling it anyway and NT4 was what we thought it would be needed for
-	  Do not delete it until we prove whether needed for Win9x though */
-int
-CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon, char *fileN=
ame,
-		__u16 dos_attrs, const struct nls_table *nls_codepage)
-{
-	SETATTR_REQ *pSMB =3D NULL;
-	SETATTR_RSP *pSMBr =3D NULL;
-	int rc =3D 0;
-	int bytes_returned;
-	int name_len;
-
-	cifs_dbg(FYI, "In SetAttrLegacy\n");
-
-SetAttrLgcyRetry:
-	rc =3D smb_init(SMB_COM_SETATTR, 8, tcon, (void **) &pSMB,
-		      (void **) &pSMBr);
-	if (rc)
-		return rc;
-
-	if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
-		name_len =3D
-			ConvertToUTF16((__le16 *) pSMB->fileName, fileName,
-				       PATH_MAX, nls_codepage);
-		name_len++;     /* trailing null */
-		name_len *=3D 2;
-	} else {
-		name_len =3D copy_path_name(pSMB->fileName, fileName);
-	}
-	pSMB->attr =3D cpu_to_le16(dos_attrs);
-	pSMB->BufferFormat =3D 0x04;
-	inc_rfc1001_len(pSMB, name_len + 1);
-	pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
-	rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
-	if (rc)
-		cifs_dbg(FYI, "Error in LegacySetAttr =3D %d\n", rc);
-
-	cifs_buf_release(pSMB);
-
-	if (rc =3D=3D -EAGAIN)
-		goto SetAttrLgcyRetry;
-
-	return rc;
-}
-#endif /* temporarily unneeded SetAttr legacy function */
-
 static void
 cifs_fill_unix_set_info(FILE_UNIX_BASIC_INFO *data_offset,
 			const struct cifs_unix_set_info_args *args)
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f2df4422e54a..2a73ae04b741 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2961,12 +2961,3 @@ cifs_setattr(struct user_namespace *mnt_userns, stru=
ct dentry *direntry,
 	/* BB: add cifs_setattr_legacy for really old servers */
 	return rc;
 }
-
-#if 0
-void cifs_delete_inode(struct inode *inode)
-{
-	cifs_dbg(FYI, "In cifs_delete_inode, inode =3D 0x%p\n", inode);
-	/* may have to add back in if and when safe distributed caching of
-	   directories added e.g. via FindNotify */
-}
-#endif
--=20
2.30.0

