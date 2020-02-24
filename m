Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2376C11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B1B2072D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JlYwT3ru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgBXNXC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:23:02 -0500
Received: from hr2.samba.org ([144.76.82.148]:44888 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBXNXC (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:23:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=dJXI5KukWPoMTB5fT+i9a1gcxSiL4Z+HO9MB6N1qPHc=; b=JlYwT3ruVFT4NXxF0WzeFS+7R7
        XTsfY485E7Zj74fmb7CK0GZRP2K+BeC/4zYqmkeyEQfJgEwA0v+hxvaNHm90KFbuKYpZzy/2bS+w2
        NuRJo3Y9aBRzzBPnuwJ8C5L3imxorogRWmd+8XLgDVafX6V6VnY1CG/o38wxVQxZQnVl3/BkDMKYi
        98We87Dwn6C0LW8gNScyATCF1574/Ax/x7y6z3rnl+YdPvzEvxh6BEBFRxK7OGWMg3gwvFviUWFME
        yLduQwSAOZtWB/USsh13CSoTdX6g8tCo8aKAVE2fUtz97+i0M6RTTyWWfY7yeasqLsioPEUWmx57H
        377pSqJfVtMY2gq6GHYqNQLIc5wrqiq8G4zAnxo6r0CpXrokADqLaJ5MkAqXB6LYUNorEfOkAwa4b
        bOrOnjpNL+c8DQ0+2H6+ah/hKErmXwKfG/dRAMTM9WacJ8P3MUjDgSP6Nt+J0LXdw/daf1tpm9cUk
        B/qBVL2vYEFQadQy32+itpQS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaS-00061e-7G; Mon, 24 Feb 2020 13:15:52 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 10/13] cifs: move cifs_reconnect_tcons() to fs/cifs/connect.c and make it static
Date:   Mon, 24 Feb 2020 14:15:07 +0100
Message-Id: <20200224131510.20608-11-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/connect.c   | 72 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 72 ---------------------------------------------
 fs/cifs/smb2proto.h |  1 -
 3 files changed, 72 insertions(+), 73 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6eca37924d9e..7f4be85b7cc9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -714,6 +714,78 @@ cifs_echo_request(struct work_struct *work)
 	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
 }
 
+static void cifs_reconnect_tcons(struct work_struct *work)
+{
+	struct TCP_Server_Info *server = container_of(work,
+					struct TCP_Server_Info, reconnect.work);
+	struct cifs_ses *ses;
+	struct cifs_tcon *tcon, *tcon2;
+	struct list_head tmp_list;
+	int tcon_exist = false;
+	int rc;
+	int resched = false;
+
+
+	/* Prevent simultaneous reconnects that can corrupt tcon->rlist list */
+	mutex_lock(&server->reconnect_mutex);
+
+	INIT_LIST_HEAD(&tmp_list);
+	cifs_dbg(FYI, "Need negotiate, reconnecting tcons\n");
+
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+			if (tcon->need_reconnect || tcon->need_reopen_files) {
+				tcon->tc_count++;
+				list_add_tail(&tcon->rlist, &tmp_list);
+				tcon_exist = true;
+			}
+		}
+		/*
+		 * IPC has the same lifetime as its session and uses its
+		 * refcount.
+		 */
+		if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
+			list_add_tail(&ses->tcon_ipc->rlist, &tmp_list);
+			tcon_exist = true;
+			ses->ses_count++;
+		}
+	}
+	/*
+	 * Get the reference to server struct to be sure that the last call of
+	 * cifs_put_tcon() in the loop below won't release the server pointer.
+	 */
+	if (tcon_exist)
+		server->srv_count++;
+
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
+		struct cifs_tcon_reconnect_params params = {
+			.start_timer = false,
+		};
+		rc = cifs_tcon_reconnect(tcon, &params);
+		if (!rc)
+			cifs_reopen_persistent_handles(tcon);
+		else
+			resched = true;
+		list_del_init(&tcon->rlist);
+		if (tcon->ipc)
+			cifs_put_smb_ses(tcon->ses);
+		else
+			cifs_put_tcon(tcon);
+	}
+
+	cifs_dbg(FYI, "Reconnecting tcons finished\n");
+	if (resched)
+		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
+	mutex_unlock(&server->reconnect_mutex);
+
+	/* now we can safely release srv struct */
+	if (tcon_exist)
+		cifs_put_tcp_session(server, 1);
+}
+
 static bool
 allocate_buffers(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f3c5eb62d51..b4446ecf4e97 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3290,78 +3290,6 @@ smb2_echo_callback(struct mid_q_entry *mid)
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
-void cifs_reconnect_tcons(struct work_struct *work)
-{
-	struct TCP_Server_Info *server = container_of(work,
-					struct TCP_Server_Info, reconnect.work);
-	struct cifs_ses *ses;
-	struct cifs_tcon *tcon, *tcon2;
-	struct list_head tmp_list;
-	int tcon_exist = false;
-	int rc;
-	int resched = false;
-
-
-	/* Prevent simultaneous reconnects that can corrupt tcon->rlist list */
-	mutex_lock(&server->reconnect_mutex);
-
-	INIT_LIST_HEAD(&tmp_list);
-	cifs_dbg(FYI, "Need negotiate, reconnecting tcons\n");
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-			if (tcon->need_reconnect || tcon->need_reopen_files) {
-				tcon->tc_count++;
-				list_add_tail(&tcon->rlist, &tmp_list);
-				tcon_exist = true;
-			}
-		}
-		/*
-		 * IPC has the same lifetime as its session and uses its
-		 * refcount.
-		 */
-		if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
-			list_add_tail(&ses->tcon_ipc->rlist, &tmp_list);
-			tcon_exist = true;
-			ses->ses_count++;
-		}
-	}
-	/*
-	 * Get the reference to server struct to be sure that the last call of
-	 * cifs_put_tcon() in the loop below won't release the server pointer.
-	 */
-	if (tcon_exist)
-		server->srv_count++;
-
-	spin_unlock(&cifs_tcp_ses_lock);
-
-	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		struct cifs_tcon_reconnect_params params = {
-			.start_timer = false,
-		};
-		rc = cifs_tcon_reconnect(tcon, &params);
-		if (!rc)
-			cifs_reopen_persistent_handles(tcon);
-		else
-			resched = true;
-		list_del_init(&tcon->rlist);
-		if (tcon->ipc)
-			cifs_put_smb_ses(tcon->ses);
-		else
-			cifs_put_tcon(tcon);
-	}
-
-	cifs_dbg(FYI, "Reconnecting tcons finished\n");
-	if (resched)
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 2 * HZ);
-	mutex_unlock(&server->reconnect_mutex);
-
-	/* now we can safely release srv struct */
-	if (tcon_exist)
-		cifs_put_tcp_session(server, 1);
-}
-
 int
 SMB2_echo(struct TCP_Server_Info *server)
 {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index c52be13a374a..fbceb62d355d 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -116,7 +116,6 @@ extern int smb2_open_file(const unsigned int xid,
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
-extern void cifs_reconnect_tcons(struct work_struct *work);
 extern int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
 extern unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 				  struct smb_rqst *rqst);
-- 
2.17.1

