Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB02C43381
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8475A65220
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCHPBd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:01:33 -0500
Received: from mx.cjr.nz ([51.158.111.142]:40526 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231266AbhCHPBL (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Mar 2021 10:01:11 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 026957FD3B;
        Mon,  8 Mar 2021 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1615215669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sMprAHaVC9T0zE3PR40XL4rryZSvJULJJJtCmSg42g4=;
        b=X5wqTdSIt/hC27iz955DjTJ7YqSViRg4hbVt8g/gmwFx5aTnciYBicfaQWnvs6XIGpiumC
        b4ehL1+Fle6X4zvltDB1qm9qrPPiyHCNADFl3IFC+rKOLdoD4vE2n+RDEVAKuwr531EWjo
        wxYXKR8RShq0lH/jkGvIFyIfzs4KHneaqgUzfrAv8WQthHgrQjN9JL0sbEOcAbUNDlM18G
        /EwhwqkxSgSTkYRx0v4pOCT/Pq0u1KdH4cOEoQma/bUUeCMZNUzfPGBTVjCf0zdvLNPGrR
        oeLtKqENnD9DcXPGyLNqPnmDxlsZmHGrdAuzB26EyhiLqQDJzsrXt48QZEr1Kg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/4] cifs: print MIDs in decimal notation
Date:   Mon,  8 Mar 2021 12:00:47 -0300
Message-Id: <20210308150050.19902-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The MIDs are mostly printed as decimal, so let's make it consistent.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifs_debug.c | 2 +-
 fs/cifs/connect.c    | 4 ++--
 fs/cifs/smb2misc.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 3aedc484e440..88a7958170ee 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -207,7 +207,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 						from_kuid(&init_user_ns, cfile->uid),
 						cfile->dentry);
 #ifdef CONFIG_CIFS_DEBUG2
-					seq_printf(m, " 0x%llx\n", cfile->fid.mid);
+					seq_printf(m, " %llu\n", cfile->fid.mid);
 #else
 					seq_printf(m, "\n");
 #endif /* CIFS_DEBUG2 */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 68642e3d4270..eec8a2052da2 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -741,7 +741,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&GlobalMid_Lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
+			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
 			kref_get(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
@@ -752,7 +752,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
+			cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
 			cifs_mid_q_entry_release(mid_entry);
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 3ea3bda64083..0a55a77d94de 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -767,7 +767,7 @@ smb2_cancelled_close_fid(struct work_struct *work)
 	int rc;
 
 	if (cancelled->mid)
-		cifs_tcon_dbg(VFS, "Close unmatched open for MID:%llx\n",
+		cifs_tcon_dbg(VFS, "Close unmatched open for MID:%llu\n",
 			      cancelled->mid);
 	else
 		cifs_tcon_dbg(VFS, "Close interrupted close\n");
-- 
2.30.1

