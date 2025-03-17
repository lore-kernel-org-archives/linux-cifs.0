Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723B8F9DA
	for <linux-cifs@vger.kernel.org>; Mon, 17 Mar 2025 19:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742240370; cv=none; b=YTWPzGGFuqHuKmEdQtyoL5SYDIWFIyJcDIueZIKLD9VjmRED3WkJ5t8lIPn18L/80aKdS+/fcs5vK8N2aOZVKuDZ5vNkL3eWnAUDTYTmWIx19EO5BHfG2ht7cL2VQyeMP6pqzRFbCX8NmvwkTuF8DEbUDp2O3UqB0hB6RjupDAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742240370; c=relaxed/simple;
	bh=zPpkz0aCvn/KayqC2x9VlN3SkASvWW7hzmfHXzaJlT0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TE+u9AuAG561IEOtidB+7Y9BFBXaTbzvFNQPdVcLPV5nwogzv7aU57ABZWR/qLZTsO8K9KxmoUzqIwNAnq7lBLpS5C9NkPPrIPTeKZGa49MjTeDor4FFVbllFoQNiMwJNXlrtv9wOxReqAxOnznZODOTMTzKjjPuiYISpFv37kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Wtl7prOV; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Wtl7prOV"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1742240366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dCvgfDaZpnc0Hn23jd+v+uYrOMRO92DtbMOxYgRi04o=;
	b=Wtl7prOVojjjk9HYkPr31FYE6VzGv8oBMTBJqn5SdDUcqbwvmzKv9Qah//z1HWcrUdC8GN
	IQWgpCUN2+Ji8Kg+anBDOkcNpT85KfQ5OUO4yDeQ8ZIsv2wcTTaxSqvG/XG4Gu3KGi4tLD
	4TOsunPTrd2v5QYwQTO5QV3uO8s72NZXaF/CKR43+6TPf/L9pNUWC4QVJbySdhlLpMhwq6
	qfBeGPzYAGziXr39WRRYcDqxzx8kfNJ7J7C9+xiv8P2JKHcmUQqSUgiNqBUFQr+ombDb5o
	FzZY5KNxt2EJ1/bdTvAsRxQ/ZUBPzSABxgStDfbk3P+RPBaH7LZ7DEg0+3ggFA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>
Subject: [PATCH] smb: client: don't retry IO on failed negprotos with soft mounts
Date: Mon, 17 Mar 2025 16:39:22 -0300
Message-ID: <20250317193922.388668-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If @server->tcpStatus is set to CifsNeedReconnect after acquiring
@ses->session_mutex in smb2_reconnect() or cifs_reconnect_tcon(), it
means that a concurrent thread failed to negotiate, in which case the
server is no longer responding to any SMB requests, so there is no
point making the caller retry the IO by returning -EAGAIN.

Fix this by returning -EHOSTDOWN to the callers on soft mounts.

Cc: David Howells <dhowells@redhat.com>
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifssmb.c | 46 ++++++++++++--------
 fs/smb/client/smb2pdu.c | 96 ++++++++++++++++++-----------------------
 2 files changed, 69 insertions(+), 73 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index d07682020c64..4fc9485c5d91 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -114,19 +114,23 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 
 	mutex_lock(&ses->session_mutex);
 	/*
-	 * Recheck after acquire mutex. If another thread is negotiating
-	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
+	 * Handle the case where a concurrent thread failed to negotiate or
+	 * killed a channel.
 	 */
 	spin_lock(&server->srv_lock);
-	if (server->tcpStatus == CifsNeedReconnect) {
+	switch (server->tcpStatus) {
+	case CifsExiting:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-
-		if (tcon->retry)
-			goto again;
-		rc = -EHOSTDOWN;
-		goto out;
+		return -EHOSTDOWN;
+	case CifsNeedReconnect:
+		spin_unlock(&server->srv_lock);
+		mutex_unlock(&ses->session_mutex);
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	default:
+		break;
 	}
 	spin_unlock(&server->srv_lock);
 
@@ -152,16 +156,20 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&ses->ses_lock);
 
 	rc = cifs_negotiate_protocol(0, ses, server);
-	if (!rc) {
-		rc = cifs_setup_session(0, ses, server, ses->local_nls);
-		if ((rc == -EACCES) || (rc == -EHOSTDOWN) || (rc == -EKEYREVOKED)) {
-			/*
-			 * Try alternate password for next reconnect if an alternate
-			 * password is available.
-			 */
-			if (ses->password2)
-				swap(ses->password2, ses->password);
-		}
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	}
+	rc = cifs_setup_session(0, ses, server, ses->local_nls);
+	if ((rc == -EACCES) || (rc == -EHOSTDOWN) || (rc == -EKEYREVOKED)) {
+		/*
+		 * Try alternate password for next reconnect if an alternate
+		 * password is available.
+		 */
+		if (ses->password2)
+			swap(ses->password2, ses->password);
 	}
 
 	/* do we need to reconnect tcon? */
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ed7812247ebc..f9c521b3c65e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -300,32 +300,23 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	mutex_lock(&ses->session_mutex);
 	/*
-	 * if this is called by delayed work, and the channel has been disabled
-	 * in parallel, the delayed work can continue to execute in parallel
-	 * there's a chance that this channel may not exist anymore
+	 * Handle the case where a concurrent thread failed to negotiate or
+	 * killed a channel.
 	 */
 	spin_lock(&server->srv_lock);
-	if (server->tcpStatus == CifsExiting) {
+	switch (server->tcpStatus) {
+	case CifsExiting:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		rc = -EHOSTDOWN;
-		goto out;
-	}
-
-	/*
-	 * Recheck after acquire mutex. If another thread is negotiating
-	 * and the server never sends an answer the socket will be closed
-	 * and tcpStatus set to reconnect.
-	 */
-	if (server->tcpStatus == CifsNeedReconnect) {
+		return -EHOSTDOWN;
+	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-
-		if (tcon->retry)
-			goto again;
-
-		rc = -EHOSTDOWN;
-		goto out;
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	default:
+		break;
 	}
 	spin_unlock(&server->srv_lock);
 
@@ -350,43 +341,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&ses->ses_lock);
 
 	rc = cifs_negotiate_protocol(0, ses, server);
-	if (!rc) {
-		/*
-		 * if server stopped supporting multichannel
-		 * and the first channel reconnected, disable all the others.
-		 */
-		if (ses->chan_count > 1 &&
-		    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-			rc = cifs_chan_skip_or_disable(ses, server,
-						       from_reconnect);
-			if (rc) {
-				mutex_unlock(&ses->session_mutex);
-				goto out;
-			}
-		}
-
-		rc = cifs_setup_session(0, ses, server, ses->local_nls);
-		if ((rc == -EACCES) || (rc == -EKEYEXPIRED) || (rc == -EKEYREVOKED)) {
-			/*
-			 * Try alternate password for next reconnect (key rotation
-			 * could be enabled on the server e.g.) if an alternate
-			 * password is available and the current password is expired,
-			 * but do not swap on non pwd related errors like host down
-			 */
-			if (ses->password2)
-				swap(ses->password2, ses->password);
-		}
-
-		if ((rc == -EACCES) && !tcon->retry) {
-			mutex_unlock(&ses->session_mutex);
-			rc = -EHOSTDOWN;
-			goto failed;
-		} else if (rc) {
+	if (rc) {
+		mutex_unlock(&ses->session_mutex);
+		if (!tcon->retry)
+			return -EHOSTDOWN;
+		goto again;
+	}
+	/*
+	 * if server stopped supporting multichannel
+	 * and the first channel reconnected, disable all the others.
+	 */
+	if (ses->chan_count > 1 &&
+	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		rc = cifs_chan_skip_or_disable(ses, server,
+					       from_reconnect);
+		if (rc) {
 			mutex_unlock(&ses->session_mutex);
 			goto out;
 		}
-	} else {
+	}
+
+	rc = cifs_setup_session(0, ses, server, ses->local_nls);
+	if ((rc == -EACCES) || (rc == -EKEYEXPIRED) || (rc == -EKEYREVOKED)) {
+		/*
+		 * Try alternate password for next reconnect (key rotation
+		 * could be enabled on the server e.g.) if an alternate
+		 * password is available and the current password is expired,
+		 * but do not swap on non pwd related errors like host down
+		 */
+		if (ses->password2)
+			swap(ses->password2, ses->password);
+	}
+	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		if (rc == -EACCES && !tcon->retry)
+			return -EHOSTDOWN;
 		goto out;
 	}
 
@@ -490,7 +479,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case SMB2_IOCTL:
 		rc = -EAGAIN;
 	}
-failed:
 	return rc;
 }
 
-- 
2.48.1

