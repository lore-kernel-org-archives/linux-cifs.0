Return-Path: <SRS0=xLh5=AN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2515FC433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 16:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFFD7207D4
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jul 2020 16:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="KzZJN5XJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGBQoU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jul 2020 12:44:20 -0400
Received: from o-chul.darkrain42.org ([74.207.241.14]:49060 "EHLO
        mail.darkrain42.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGBQoU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jul 2020 12:44:20 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id E3DDF80F1;
        Thu,  2 Jul 2020 09:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593708260; bh=TpXwmu6PqX6XJKTeyeMh9wZBc0/zYjl+shpiIx7lINQ=;
        h=From:To:Cc:Subject:Date:From;
        b=KzZJN5XJh57BdSHy5sZ/l652YFYsOPv9KZHhjIJ/KRN1T6RsbmSxnSfShk1vhGsxC
         jsS0oa2AL+Apr4Lx/mdcf024u6SrvNqlrH5sTzakwRATkxc1SpIcHSHK8y6U7GOTWv
         2tLcuTePLgE3scPnldA+An+G9fTlQsdz2yl2QzscpBVtTjVsf0ZsbwygKzXW6Fvre9
         rrIHZ2wBBNmASGsFo780e51z+6nC3FJlyU6uNp07vCJ82lnQfsA2LS5wPt5rsTuSGz
         KbNecQ2cs41GC74awn2WEVEk+DKDAOWuVn1R0MFBcOHz+zzeD5saCzt/TTlx/VNpC+
         //dEPOE4G9rCA==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
Subject: [PATCH v3] cifs: Fix leak when handling lease break for cached root fid
Date:   Thu,  2 Jul 2020 09:44:11 -0700
Message-Id: <20200702164411.108672-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Handling a lease break for the cached root didn't free the
smb2_lease_break_work allocation, resulting in a leak:

    unreferenced object 0xffff98383a5af480 (size 128):
      comm "cifsd", pid 684, jiffies 4294936606 (age 534.868s)
      hex dump (first 32 bytes):
        c0 ff ff ff 1f 00 00 00 88 f4 5a 3a 38 98 ff ff  ..........Z:8...
        88 f4 5a 3a 38 98 ff ff 80 88 d6 8a ff ff ff ff  ..Z:8...........
      backtrace:
        [<0000000068957336>] smb2_is_valid_oplock_break+0x1fa/0x8c0
        [<0000000073b70b9e>] cifs_demultiplex_thread+0x73d/0xcc0
        [<00000000905fa372>] kthread+0x11c/0x150
        [<0000000079378e4e>] ret_from_fork+0x22/0x30

Avoid this leak by only allocating when necessary.

Fixes: a93864d93977 ("cifs: add lease tracking to the cached root fid")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org> # v4.18+
---
Changes since v2:
   - address sparse lock warnings by inlining smb2_tcon_has_lease and
     hardcoding some return values (seems to help sparse's analysis)

 fs/cifs/smb2misc.c | 60 +++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 6a39451973f8..8919df9d7dfd 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -504,9 +504,8 @@ cifs_ses_oplock_break(struct work_struct *work)
 	kfree(lw);
 }
 
-static bool
-smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
-		    struct smb2_lease_break_work *lw)
+static inline bool
+smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 {
 	bool found;
 	__u8 lease_state;
@@ -516,9 +515,13 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
+	struct smb2_lease_break_work *lw;
+	struct tcon_link *tlink;
+	__u8 lease_key[SMB2_LEASE_KEY_SIZE];
 
 	lease_state = le32_to_cpu(rsp->NewLeaseState);
 
+	spin_lock(&tcon->open_file_lock);
 	list_for_each(tmp, &tcon->openFileList) {
 		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
 		cinode = CIFS_I(d_inode(cfile->dentry));
@@ -542,7 +545,8 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		cfile->oplock_level = lease_state;
 
 		cifs_queue_oplock_break(cfile);
-		kfree(lw);
+		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cifs_tcp_ses_lock);
 		return true;
 	}
 
@@ -554,10 +558,9 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 
 		if (!found && ack_req) {
 			found = true;
-			memcpy(lw->lease_key, open->lease_key,
+			memcpy(lease_key, open->lease_key,
 			       SMB2_LEASE_KEY_SIZE);
-			lw->tlink = cifs_get_tlink(open->tlink);
-			queue_work(cifsiod_wq, &lw->lease_break);
+			tlink = cifs_get_tlink(open->tlink);
 		}
 
 		cifs_dbg(FYI, "found in the pending open list\n");
@@ -567,25 +570,33 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		open->oplock = lease_state;
 	}
 
-	return found;
-}
-
-static bool
-smb2_is_valid_lease_break(char *buffer)
-{
-	struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
-	struct list_head *tmp, *tmp1, *tmp2;
-	struct TCP_Server_Info *server;
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon;
-	struct smb2_lease_break_work *lw;
+	spin_unlock(&tcon->open_file_lock);
+	if (!found)
+		return false;
+	spin_unlock(&cifs_tcp_ses_lock);
 
 	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
-	if (!lw)
-		return false;
+	if (!lw) {
+		cifs_put_tlink(tlink);
+		return true;
+	}
 
 	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
+	lw->tlink = tlink;
 	lw->lease_state = rsp->NewLeaseState;
+	memcpy(lw->lease_key, lease_key, SMB2_LEASE_KEY_SIZE);
+	queue_work(cifsiod_wq, &lw->lease_break);
+	return true;
+}
+
+static bool
+smb2_is_valid_lease_break(char *buffer)
+{
+	struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
+	struct list_head *tmp, *tmp1, *tmp2;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon;
 
 	cifs_dbg(FYI, "Checking for lease break\n");
 
@@ -600,15 +611,11 @@ smb2_is_valid_lease_break(char *buffer)
 			list_for_each(tmp2, &ses->tcon_list) {
 				tcon = list_entry(tmp2, struct cifs_tcon,
 						  tcon_list);
-				spin_lock(&tcon->open_file_lock);
 				cifs_stats_inc(
 				    &tcon->stats.cifs_stats.num_oplock_brks);
-				if (smb2_tcon_has_lease(tcon, rsp, lw)) {
-					spin_unlock(&tcon->open_file_lock);
-					spin_unlock(&cifs_tcp_ses_lock);
+				if (smb2_tcon_has_lease(tcon, rsp)) {
 					return true;
 				}
-				spin_unlock(&tcon->open_file_lock);
 
 				if (tcon->crfid.is_valid &&
 				    !memcmp(rsp->LeaseKey,
@@ -625,7 +632,6 @@ smb2_is_valid_lease_break(char *buffer)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	kfree(lw);
 	cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
 	return false;
 }
-- 
2.27.0

