Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D1C1ACEAF;
	Tue, 25 Mar 2025 18:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928148; cv=none; b=dF3CbUFXk/JoXctIV+dQdfHzroMQgqYA4aEFU+V3piLHyLdHPfKPhOcXLn18Bu9lpErPcJaPL1eaKiMl9NqWkDurW0SArBKp9PujKFn3jxSceyJPgEoPZqrhL6s+mxacRyq8iLinb55uyyi1xvclMSjQiS1uocbXCBBYy+l/w+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928148; c=relaxed/simple;
	bh=UuhNhHmsCai/OKW+CiwgEP7JQe/3sSD6DbKl78C/SFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LT7s7Uge1kHdu+rN5DSQJ+WCE3sNZYZBrBkLCSgZxmW0G6WVOSG4KoYTA4KWwMA9eXUIwGf75HSRfOhq241Xat2XIUr0NJOC85nESM+eZfWGmzuqpEzSy5cZFVnWN3pbPlxokSuf46z+ta2YiEjoL/ihuE1hUziUrGVoSbRCGd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7SPUZTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7SPUZTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B7AC4CEE4;
	Tue, 25 Mar 2025 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928148;
	bh=UuhNhHmsCai/OKW+CiwgEP7JQe/3sSD6DbKl78C/SFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7SPUZTZ0YeuwtVf9cjpleunSpATK+cQGkH0cdNJ5vRML247DY87PVJFMKYcidwHt
	 5IQR4O7xkDpIjX/ZNKnig3WrKdSVbeNgGuzd5kvNNv2taamwR5bIxYY5azt3yxf8qS
	 /IS4vsseZ2WBnhemIKqEjFYQ8AIYXLtm0JRNIkrsdcExhUySO+2wPqjWc4hLUWq/hV
	 DGfN4wNC1giuxVbTvtCgNrcy1ktx86Hs4QaG8yT/67NVLuiOUHych5/z/qsDR7V4iu
	 jObM8vjcDtIcZbIFKLy1FWy+6e3DabcRpi/vYQoAw14jwWhmpg5iW0aYVxFXp9qxzP
	 B9mo0gPQ2B8PA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.13 5/7] smb: client: don't retry IO on failed negprotos with soft mounts
Date: Tue, 25 Mar 2025 14:42:13 -0400
Message-Id: <20250325184215.2152123-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325184215.2152123-1-sashal@kernel.org>
References: <20250325184215.2152123-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.8
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 7643dbd9db09fffebb4a62cd27599f17f4148b17 ]

If @server->tcpStatus is set to CifsNeedReconnect after acquiring
@ses->session_mutex in smb2_reconnect() or cifs_reconnect_tcon(), it
means that a concurrent thread failed to negotiate, in which case the
server is no longer responding to any SMB requests, so there is no
point making the caller retry the IO by returning -EAGAIN.

Fix this by returning -EHOSTDOWN to the callers on soft mounts.

Cc: David Howells <dhowells@redhat.com>
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 46 ++++++++++++--------
 fs/smb/client/smb2pdu.c | 96 ++++++++++++++++++-----------------------
 2 files changed, 69 insertions(+), 73 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index a993d4ac58411..dd5211d268f48 100644
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
index 7ece98c742bdb..23ae73c9c5e97 100644
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
2.39.5

