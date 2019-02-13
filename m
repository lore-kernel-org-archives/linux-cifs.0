Return-Path: <SRS0=5rUr=QU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD0DC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Feb 2019 23:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8253120700
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Feb 2019 23:44:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frLV4UFn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393150AbfBMXnS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Feb 2019 18:43:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43984 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393102AbfBMXnS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Feb 2019 18:43:18 -0500
Received: by mail-pl1-f193.google.com with SMTP id f90so1999907plb.10
        for <linux-cifs@vger.kernel.org>; Wed, 13 Feb 2019 15:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=kHXUtzIRHJyz1moPDbYu6/qRSms020m4qVF9OgsZ1Tg=;
        b=frLV4UFn/Hl132OOP48K0Z6JHGW0l/304TPisrtCgymvEIl/3H8weyst+oCX7qQonC
         Y0l200sAQrloH+yRdMk+scgT4bGVggR1EMoxXYlZVh1M4+Gv5Gu2EkrK4MmRj7mMdKzq
         IgGfXo4z9SRArS0b0jt0wNRhmyFgJu0c29OAnCG4v3b/u6x5KC2BbzztxLMl8cDZp2bY
         Sh7IjKqGkhNY5mzOSRgsgdtRnpYuCBfnUmvNql7Ta1tgu29b+465shhFnE26LHov5/EX
         9Byn7sj4IBZww82U3F9Nmkuk2jnEwcgWfGEPFFE1MtyV4Tw1vobwR3tsPNMMYhVTfMnJ
         nPJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=kHXUtzIRHJyz1moPDbYu6/qRSms020m4qVF9OgsZ1Tg=;
        b=S0i5uPdfqTeNyzXlx69GCTckIa4BCP1s3QdzSPMsTxzCWd00DAIcIxjQJAIG0hKxmW
         /Bxja8P3mdsShBynsceWNvGL1gHp0ZVXPHIaypd3yCzLWZOtZiKcbSo+DPLMwwhiN25F
         6EXE8c2BSQuNj/AbViHK3JfKjU1dvCIsbeYYUyhfFUlkD2nqnTuXq48TK+hU66v6/QBu
         OoqUZC+gxQDI1Yqv2/xWRr10AdujreuN66DSa4Bd3tR44qapR88e/2DzkMkaXFiv4w8v
         HSpajrplSEk5Fu800RbncrOO/uwf1TUF45H35R7NMGzQfBk1LK6130du0LUfEJXA0U8P
         Speg==
X-Gm-Message-State: AHQUAuaDTm83ADnXoUHaGfSbFosnsA5CXk/AaB9y/CZ8ylyhkClieg5O
        a3OWR6tsvkLa6iuA4TdYQjYEiYk=
X-Google-Smtp-Source: AHgI3IYiV8/X63Rliix41nE6HNarQgKAAkujcT09ll+vlj0CdoDDGWBdihP2VY7RqQzkJFEAQBkExA==
X-Received: by 2002:a17:902:e990:: with SMTP id ct16mr818596plb.201.1550101397248;
        Wed, 13 Feb 2019 15:43:17 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:b:a183:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id o1sm549528pgn.63.2019.02.13.15.43.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Feb 2019 15:43:16 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH] CIFS: Do not reset lease state to NONE on lease break
Date:   Wed, 13 Feb 2019 15:43:08 -0800
Message-Id: <1550101388-19431-1-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently on lease break the client sets a caching level twice:
when oplock is detected and when oplock is processed. While the
1st attempt sets the level to the value provided by the server,
the 2nd one resets the level to None unconditionally.
This happens because the oplock/lease processing code was changed
to avoid races between page cache flushes and oplock breaks.
The commit c11f1df5003d534 ("cifs: Wait for writebacks to complete
before attempting write.") fixed the races for oplocks but didn't
apply the same changes for leases resulting in overwriting the
server granted value to None. Fix this by properly processing
lease breaks.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/smb2misc.c | 17 ++++++++++++++---
 fs/cifs/smb2ops.c  | 15 ++++++++++++---
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b8b58f..58700d2 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -517,7 +517,6 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 	__u8 lease_state;
 	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
-	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_pending_open *open;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
@@ -537,13 +536,25 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		cifs_dbg(FYI, "lease key match, lease break 0x%x\n",
 			 le32_to_cpu(rsp->NewLeaseState));
 
-		server->ops->set_oplock_level(cinode, lease_state, 0, NULL);
-
 		if (ack_req)
 			cfile->oplock_break_cancelled = false;
 		else
 			cfile->oplock_break_cancelled = true;
 
+		set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
+
+		/*
+		 * Set or clear flags depending on the lease state being READ.
+		 * HANDLE caching flag should be added when the client starts
+		 * to defer closing remote file handles with HANDLE leases.
+		 */
+		if (lease_state & SMB2_LEASE_READ_CACHING_HE)
+			set_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
+				&cinode->flags);
+		else
+			clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
+				  &cinode->flags);
+
 		queue_work(cifsoplockd_wq, &cfile->oplock_break);
 		kfree(lw);
 		return true;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1995bbe..e560e60 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2641,6 +2641,15 @@ smb2_downgrade_oplock(struct TCP_Server_Info *server,
 }
 
 static void
+smb21_downgrade_oplock(struct TCP_Server_Info *server,
+		       struct cifsInodeInfo *cinode, bool set_level2)
+{
+	server->ops->set_oplock_level(cinode,
+				      set_level2 ? SMB2_LEASE_READ_CACHING_HE :
+				      0, 0, NULL);
+}
+
+static void
 smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 		      unsigned int epoch, bool *purge_cache)
 {
@@ -3693,7 +3702,7 @@ struct smb_version_operations smb21_operations = {
 	.print_stats = smb2_print_stats,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb2_downgrade_oplock,
+	.downgrade_oplock = smb21_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb2_negotiate_wsize,
@@ -3791,7 +3800,7 @@ struct smb_version_operations smb30_operations = {
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb2_downgrade_oplock,
+	.downgrade_oplock = smb21_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb3_negotiate_wsize,
@@ -3897,7 +3906,7 @@ struct smb_version_operations smb311_operations = {
 	.dump_share_caps = smb2_dump_share_caps,
 	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
-	.downgrade_oplock = smb2_downgrade_oplock,
+	.downgrade_oplock = smb21_downgrade_oplock,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
 	.negotiate_wsize = smb3_negotiate_wsize,
-- 
2.7.4

