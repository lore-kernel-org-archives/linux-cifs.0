Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C176EC35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB6120828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EgxzRaxb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbgBXNP5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:15:57 -0500
Received: from hr2.samba.org ([144.76.82.148]:41900 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNP5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:15:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=0ESyfIzx0Ss/EjrSOnFsGxHCMgKOirkFdsfAo+fHN8o=; b=EgxzRaxbiu+TN0PrvmeF+0VqXa
        Bg2uODbnPEwEJSKuS/seosfgPyQseJYWpkLOfXmAluFRJz7yolRchbxdT/Dq46JpYdsXw0hzsKbUN
        1+nHOZ+wkCNaFsarWmyEEtpLsq4d4aofOY9ZiwknvbK3t8wxZFatEyLgnjGYDC0Haqz6Yoidlemx7
        hEanzek/60GS26guJPuObMCsPp4te3mlI2gYlXvNnMETM1x7MXWEl7JsbU/MPEeja/E5NVLapbQXF
        nulFy+ypYxfao2bKMHqFm62UVNoE5K8zpyIZXezsI1XMAYY5cPjwvpKUvcxmCs4ZIayqisxPDTKI8
        h7ICzYac5ZxBgA7lgHqe1OKArygEa4A6g8gjDXkwlq1yWcocSq28b1BPgLooL7pp/uKdewEXxB2Cc
        NJFUSmElrkOBZSwTm87QXY6nTx9xFmg5lJ7falIHzNghS4A8HjZ+r8eigRcLgvrG2iFxR2XoKwEbA
        SowDp8+5+PE6k0Y6Rk0IeYdd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaQ-00061e-9A; Mon, 24 Feb 2020 13:15:50 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 04/13] cifs: split out a cifs_connect_session_locked() helper function
Date:   Mon, 24 Feb 2020 14:15:01 +0100
Message-Id: <20200224131510.20608-5-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifsproto.h |  8 +++----
 fs/cifs/cifssmb.c   | 13 +++---------
 fs/cifs/connect.c   | 51 +++++++++++++++++++++++++++++----------------
 fs/cifs/sess.c      |  9 ++++----
 fs/cifs/smb2pdu.c   | 21 +++++--------------
 5 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 89eaaf46d1ca..e2624ebad189 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -263,10 +263,10 @@ extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
 extern void cifs_free_llist(struct list_head *llist);
 extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
 
-extern int cifs_negotiate_protocol(const unsigned int xid,
-				   struct cifs_ses *ses);
-extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
-			      struct nls_table *nls_info);
+extern int cifs_connect_session_locked(const unsigned int xid,
+				       struct cifs_ses *ses,
+				       struct nls_table *nls_info,
+				       bool retry);
 extern int cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required);
 extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d2b92770384b..dcb009fade8c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -291,16 +291,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * and the server never sends an answer the socket will be closed
 	 * and tcpStatus set to reconnect.
 	 */
-	if (server->tcpStatus == CifsNeedReconnect) {
-		rc = -EHOSTDOWN;
-		mutex_unlock(&ses->session_mutex);
-		goto out;
-	}
-
-	rc = cifs_negotiate_protocol(0, ses);
-	if (rc == 0 && ses->need_reconnect)
-		rc = cifs_setup_session(0, ses, nls_codepage);
-
+	rc = cifs_connect_session_locked(0, ses,
+					 nls_codepage,
+					 tcon->retry);
 	/* do we need to reconnect tcon? */
 	if (rc || !tcon->need_reconnect) {
 		mutex_unlock(&ses->session_mutex);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 25df928b3ca0..34269ef40774 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3288,7 +3288,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 			 ses->status);
 
 		mutex_lock(&ses->session_mutex);
-		rc = cifs_negotiate_protocol(xid, ses);
+		rc = cifs_connect_session_locked(xid, ses,
+						 volume_info->local_nls,
+						 true /* retry */);
 		if (rc) {
 			mutex_unlock(&ses->session_mutex);
 			/* problem -- put our ses reference */
@@ -3296,18 +3298,6 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 			free_xid(xid);
 			return ERR_PTR(rc);
 		}
-		if (ses->need_reconnect) {
-			cifs_dbg(FYI, "Session needs reconnect\n");
-			rc = cifs_setup_session(xid, ses,
-						volume_info->local_nls);
-			if (rc) {
-				mutex_unlock(&ses->session_mutex);
-				/* problem -- put our reference */
-				cifs_put_smb_ses(ses);
-				free_xid(xid);
-				return ERR_PTR(rc);
-			}
-		}
 		mutex_unlock(&ses->session_mutex);
 
 		/* existing SMB ses has a server reference already */
@@ -3359,9 +3349,10 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->chan_count = 1;
 	ses->chan_max = volume_info->multichannel ? volume_info->max_channels:1;
 
-	rc = cifs_negotiate_protocol(xid, ses);
-	if (!rc)
-		rc = cifs_setup_session(xid, ses, volume_info->local_nls);
+	ses->need_reconnect = true;
+	rc = cifs_connect_session_locked(xid, ses,
+					 volume_info->local_nls,
+					 true /* retry */);
 
 	/* each channel uses a different signing key */
 	memcpy(ses->chans[0].signkey, ses->smb3signingkey,
@@ -5240,7 +5231,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	call_rcu(&cifs_sb->rcu, delayed_free);
 }
 
-int
+static int
 cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses)
 {
 	int rc = 0;
@@ -5266,7 +5257,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses)
 	return rc;
 }
 
-int
+static int
 cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		   struct nls_table *nls_info)
 {
@@ -5299,6 +5290,30 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
+int
+cifs_connect_session_locked(const unsigned int xid,
+			    struct cifs_ses *ses,
+			    struct nls_table *nls_info,
+			    bool retry)
+{
+	int rc;
+
+	if (ses->server->tcpStatus == CifsNeedReconnect) {
+		return -EHOSTDOWN;
+	}
+
+	rc = cifs_negotiate_protocol(xid, ses);
+	if (!rc && (ses->need_reconnect || ses->binding)) {
+		cifs_dbg(FYI, "Session needs reconnect\n");
+		rc = cifs_setup_session(xid, ses, nls_info);
+		if ((rc == -EACCES) && !retry) {
+			return -EHOSTDOWN;
+		}
+	}
+
+	return rc;
+}
+
 static int
 cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
 {
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 43a88e26d26b..d38a6769d8aa 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -252,11 +252,10 @@ cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
 	}
 
 	ses->binding = true;
-	rc = cifs_negotiate_protocol(xid, ses);
-	if (rc)
-		goto out;
-
-	rc = cifs_setup_session(xid, ses, vol.local_nls);
+	rc = cifs_connect_session_locked(xid,
+					 ses,
+					 vol.local_nls,
+					 true /* retry */);
 	if (rc)
 		goto out;
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2495c3021772..a15a53d2e808 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -343,21 +343,10 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	 * and the server never sends an answer the socket will be closed
 	 * and tcpStatus set to reconnect.
 	 */
-	if (server->tcpStatus == CifsNeedReconnect) {
-		rc = -EHOSTDOWN;
-		mutex_unlock(&tcon->ses->session_mutex);
-		goto out;
-	}
-
-	rc = cifs_negotiate_protocol(0, tcon->ses);
-	if (!rc && tcon->ses->need_reconnect) {
-		rc = cifs_setup_session(0, tcon->ses, nls_codepage);
-		if ((rc == -EACCES) && !tcon->retry) {
-			rc = -EHOSTDOWN;
-			mutex_unlock(&tcon->ses->session_mutex);
-			goto failed;
-		}
-	}
+	rc = cifs_connect_session_locked(0, tcon->ses,
+					 nls_codepage,
+					 tcon->retry);
+	/* do we need to reconnect tcon? */
 	if (rc || !tcon->need_reconnect) {
 		mutex_unlock(&tcon->ses->session_mutex);
 		goto out;
@@ -402,7 +391,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	case SMB2_SET_INFO:
 		rc = -EAGAIN;
 	}
-failed:
+
 	unload_nls(nls_codepage);
 	return rc;
 }
-- 
2.17.1

