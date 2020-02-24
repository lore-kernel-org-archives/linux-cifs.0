Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDDFC11D32
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0BF320828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="UM2C2b+8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgBXNQF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:16:05 -0500
Received: from hr2.samba.org ([144.76.82.148]:41990 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNQF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=VYe+rzlWoOOw5XsvZ6CP2Josx4UQBK4rzfry/xCXkLU=; b=UM2C2b+8NF4t+GhWyDx+8einKN
        DF9jSdtUkq422qEqtanaPKaOJHDKfiOxsl8W0XbVn4pvux6ilOA5imQyHYEQXAik4USWBbDKxYm54
        JFljI3rb1BYnu4jVK4hAhWrRsum5kv+MGBIvHw7u0N5nTDkcKceuDUM8Y0hNPKnank19uLxEPdBDi
        0Hdlw/YCpMndkVX1lCxd/A70pAHFeTEK22nRE3jBpRcoR+FMFjNYE3SdVFrSQ2oMEgjZx0TNZz7Dz
        gsKr1PZFdnhzd6FOdAYpdYHlM9cvd9ASS4+SGtpZTsH3r4R8ldOLpSkzti8U7XowJ4H6bBcLWfZjU
        xHjZPSPQbSHNNwG69HCaOYn86HZF+3Wl1dhSU+rCjQjiQT5hgkprexgAB+danDYnjNje0tarBf4R2
        +GlW6Ws26Y2JpY2m+mEbeQUfT0SpwjuHMh2ysKXNEb638dg8MSjYv5s0dALaZAbnDocnj6PuYhJRs
        gHmEYJ6dPDiv9cvgOFMbc8l/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaR-00061e-Rq; Mon, 24 Feb 2020 13:15:51 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 09/13] cifs: turn smb2_reconnect_server() into a generic cifs_reconnect_server()
Date:   Mon, 24 Feb 2020 14:15:06 +0100
Message-Id: <20200224131510.20608-10-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/connect.c   |  2 +-
 fs/cifs/smb2pdu.c   | 12 ++++++------
 fs/cifs/smb2pdu.h   |  2 --
 fs/cifs/smb2proto.h |  2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fc430ba99571..6eca37924d9e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2823,7 +2823,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
+	INIT_DELAYED_WORK(&tcp_ses->reconnect, cifs_reconnect_tcons);
 	mutex_init(&tcp_ses->reconnect_mutex);
 	memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr,
 	       sizeof(tcp_ses->srcaddr));
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 162fe3381f4c..6f3c5eb62d51 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -159,7 +159,7 @@ static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
 	struct cifs_tcon_reconnect_params params = {
-		.skip_reconnect = false,
+		.start_timer = true,
 	};
 
 	switch (smb2_command) {
@@ -197,9 +197,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 		break;
 	}
 
-	if (smb2_command != SMB2_INTERNAL_CMD)
-		params.start_timer = true;
-
 	/*
 	 * Check if handle based operation so we know whether we can continue
 	 * or not without returning to caller to reset file handle.
@@ -3293,7 +3290,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
-void smb2_reconnect_server(struct work_struct *work)
+void cifs_reconnect_tcons(struct work_struct *work)
 {
 	struct TCP_Server_Info *server = container_of(work,
 					struct TCP_Server_Info, reconnect.work);
@@ -3340,7 +3337,10 @@ void smb2_reconnect_server(struct work_struct *work)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon);
+		struct cifs_tcon_reconnect_params params = {
+			.start_timer = false,
+		};
+		rc = cifs_tcon_reconnect(tcon, &params);
 		if (!rc)
 			cifs_reopen_persistent_handles(tcon);
 		else
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index fa03df130f1a..330748bd3736 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -81,8 +81,6 @@
 #define SMB2_SET_INFO		cpu_to_le16(SMB2_SET_INFO_HE)
 #define SMB2_OPLOCK_BREAK	cpu_to_le16(SMB2_OPLOCK_BREAK_HE)
 
-#define SMB2_INTERNAL_CMD	cpu_to_le16(0xFFFF)
-
 #define NUMBER_OF_SMB2_COMMANDS	0x0013
 
 /* 52 transform hdr + 64 hdr + 88 create rsp */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index de6388ef344f..c52be13a374a 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -116,7 +116,7 @@ extern int smb2_open_file(const unsigned int xid,
 extern int smb2_unlock_range(struct cifsFileInfo *cfile,
 			     struct file_lock *flock, const unsigned int xid);
 extern int smb2_push_mandatory_locks(struct cifsFileInfo *cfile);
-extern void smb2_reconnect_server(struct work_struct *work);
+extern void cifs_reconnect_tcons(struct work_struct *work);
 extern int smb3_crypto_aead_allocate(struct TCP_Server_Info *server);
 extern unsigned long smb_rqst_len(struct TCP_Server_Info *server,
 				  struct smb_rqst *rqst);
-- 
2.17.1

