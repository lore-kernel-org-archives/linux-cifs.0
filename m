Return-Path: <SRS0=Albd=AV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4FCC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Jul 2020 05:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE7D32072E
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Jul 2020 05:01:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="MHUmRSvK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgGJFBV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Jul 2020 01:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgGJFBV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Jul 2020 01:01:21 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACEBC08C5CE
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2020 22:01:21 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id 6359180F3;
        Thu,  9 Jul 2020 22:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1594357280; bh=8CMJ8ypzQKOKWMm+qNoVZLFpiLA4av3EJA9cEZhP9yU=;
        h=From:To:Cc:Subject:Date:From;
        b=MHUmRSvKbhfBHZ9+6HLEepUOrFV7c1aR3bhqkSeFyd4aiQIwIyNfvbMeiNXXES8sh
         2o4tQjk4V1PTzeSZyKqc4wR3gDHjbCoovDhtco4OyoK6WwkoDlWLo/a/8EHFlgSP0y
         WpZe1YAVHrB+l1ApEmT3/Cvsz1/Hckuy9bMmh/hyAoEjMbUQuONrGwNV8uhR9rOmH1
         2rfZGHPmaO3bpWhg1pddwRdMvhjvLo8bywlPVtxlC/TCcDl79dUJPDg974ymLhghhq
         kz5gXbaYd4ADqYCMYu4VOOaVqtuTozJH+SGeGzHTZNLKi0AE9rH5/BWBKxYsDJXgvK
         wXOUf2fuaJNYQ==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        =?UTF-8?q?Aur=C3=A9lien=20Aptel?= <aaptel@suse.com>
Subject: [PATCH v4] cifs: Fix leak when handling lease break for cached root fid
Date:   Thu,  9 Jul 2020 22:01:16 -0700
Message-Id: <20200710050116.623540-1-paul@darkrain42.org>
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
Changes from v3:
  - refactor pending open lease handling into separate functions so that the
    core spinlock handling can occur all in smb2_is_valid_lease_break

 fs/cifs/smb2misc.c | 73 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 6a39451973f8..865cd248c605 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -504,15 +504,31 @@ cifs_ses_oplock_break(struct work_struct *work)
 	kfree(lw);
 }
 
+static void
+smb2_queue_pending_open_break(struct tcon_link *tlink, __u8 *lease_key,
+			      __le32 new_lease_state)
+{
+	struct smb2_lease_break_work *lw;
+
+	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
+	if (!lw) {
+		cifs_put_tlink(tlink);
+		return;
+	}
+
+	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
+	lw->tlink = tlink;
+	lw->lease_state = new_lease_state;
+	memcpy(lw->lease_key, lease_key, SMB2_LEASE_KEY_SIZE);
+	queue_work(cifsiod_wq, &lw->lease_break);
+}
+
 static bool
-smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
-		    struct smb2_lease_break_work *lw)
+smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 {
-	bool found;
 	__u8 lease_state;
 	struct list_head *tmp;
 	struct cifsFileInfo *cfile;
-	struct cifs_pending_open *open;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
@@ -542,22 +558,29 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp,
 		cfile->oplock_level = lease_state;
 
 		cifs_queue_oplock_break(cfile);
-		kfree(lw);
 		return true;
 	}
 
-	found = false;
+	return false;
+}
+
+static struct cifs_pending_open *
+smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
+				  struct smb2_lease_break *rsp)
+{
+	__u8 lease_state = le32_to_cpu(rsp->NewLeaseState);
+	int ack_req = le32_to_cpu(rsp->Flags &
+				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
+	struct cifs_pending_open *open;
+	struct cifs_pending_open *found = NULL;
+
 	list_for_each_entry(open, &tcon->pending_opens, olist) {
 		if (memcmp(open->lease_key, rsp->LeaseKey,
 			   SMB2_LEASE_KEY_SIZE))
 			continue;
 
 		if (!found && ack_req) {
-			found = true;
-			memcpy(lw->lease_key, open->lease_key,
-			       SMB2_LEASE_KEY_SIZE);
-			lw->tlink = cifs_get_tlink(open->tlink);
-			queue_work(cifsiod_wq, &lw->lease_break);
+			found = open;
 		}
 
 		cifs_dbg(FYI, "found in the pending open list\n");
@@ -578,14 +601,7 @@ smb2_is_valid_lease_break(char *buffer)
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	struct smb2_lease_break_work *lw;
-
-	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
-	if (!lw)
-		return false;
-
-	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
-	lw->lease_state = rsp->NewLeaseState;
+	struct cifs_pending_open *open;
 
 	cifs_dbg(FYI, "Checking for lease break\n");
 
@@ -603,11 +619,27 @@ smb2_is_valid_lease_break(char *buffer)
 				spin_lock(&tcon->open_file_lock);
 				cifs_stats_inc(
 				    &tcon->stats.cifs_stats.num_oplock_brks);
-				if (smb2_tcon_has_lease(tcon, rsp, lw)) {
+				if (smb2_tcon_has_lease(tcon, rsp)) {
 					spin_unlock(&tcon->open_file_lock);
 					spin_unlock(&cifs_tcp_ses_lock);
 					return true;
 				}
+				open = smb2_tcon_find_pending_open_lease(tcon,
+									 rsp);
+				if (open) {
+					__u8 lease_key[SMB2_LEASE_KEY_SIZE];
+					struct tcon_link *tlink;
+
+					tlink = cifs_get_tlink(open->tlink);
+					memcpy(lease_key, open->lease_key,
+					       SMB2_LEASE_KEY_SIZE);
+					spin_unlock(&tcon->open_file_lock);
+					spin_unlock(&cifs_tcp_ses_lock);
+					smb2_queue_pending_open_break(tlink,
+								      lease_key,
+								      rsp->NewLeaseState);
+					return true;
+				}
 				spin_unlock(&tcon->open_file_lock);
 
 				if (tcon->crfid.is_valid &&
@@ -625,7 +657,6 @@ smb2_is_valid_lease_break(char *buffer)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	kfree(lw);
 	cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
 	return false;
 }
-- 
2.27.0

