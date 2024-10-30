Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E51F4FD8
	for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2024 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730298533; cv=none; b=s/je1HY5p4ct3kpf3zAwGCGkRsq9Kh0VQ3Plwl36Xg+7owlgkcwEBBypZzvbB3tr8t9amR8NHAvcL+nyjzDVNDZMIUneF/RsM6pj/lo9iBXvH232LeEH/eXTGIthiGhbLt3hl5HPvtPD48K/ZBJemBFO3MIhZltUtiHfzji9vGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730298533; c=relaxed/simple;
	bh=/aRfUfBQN/8+w/JhZdl2bx6oJldWyy0AVCTe6/cmGjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3W5Udkf3uS1P653Yk0DBcdD+gamqyvyU0EP2ete0vkOyeqoyOykRA5g1urCBSCULmKTQE03l4wBF1HzhSCKDMDlgPoWYg2QPsUt8O+OHSl3xG/jlSx69JT0Ay50AVDkA10vFu4iwZkkvjQbUOsL0Qy9Aszb7IzncKTrLi89QUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PyRMazxN; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PyRMazxN"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7ea76a12c32so5145465a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2024 07:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730298530; x=1730903330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LyRWETo41UYXUIPrIY6yQtj97RvfI3bD2eh5eSArmT0=;
        b=PyRMazxNlQHHpw/GxkSzEhZKk2vsMOdzZf1MZOt/4z43etcsfAvh8FHJU4oQEd1LQg
         PDkeTy9d8liZWQwm8SZiMeb+jeovAFDGaHJi3dtiIpW1KRIMbKHzIb5B/gzgjriZGC67
         sl0sUhQXx2FOfed5NKvvzPPFrT3uHbbqFWfyF6ajEDdE6I35FBT77vwypUigfqlhRm7X
         r/d72WvRBB3seef3uMQ+Qp/DH2rAClSSdapCfr02qZBJ3ugSdER36kVZRwCS2muXb/Nd
         NlWgcXKoLx+uQncsh18XTjal7flSHRNnq6cwlba1w7yF+4vIOjwQh8b0Uw0bKmWM7qGg
         Q+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730298530; x=1730903330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LyRWETo41UYXUIPrIY6yQtj97RvfI3bD2eh5eSArmT0=;
        b=umm1GObO9CXaQWrHxzI1XWicbUbhuJeaA4T/jCjJux9OuhXXrCR5Wmgzz166kkv87C
         vyL4bppNWGJ5/7tailku3AXZpwn6umXZ193omvnKezHaqQ43p+jAl/i7/EBmU6UBzsQx
         Qrc8Mr1Ps69ct6C3rziQzy6TARDlEsilYdY+vu/WBI9JNo59/TrUto4rhbRZshpprHPr
         xF7p/i0aY7mxTJvUTTK+pAJRUZiUJN5uvZ/pFTF680XAQsTGxW43VyIfqu2WJzoY0/Cx
         waAteSgxYM+6q+kcpp1h0p6BQUAJhGoaqAv6f5dot/V5cJEqK1wSWVlL3Kkizi8U0Muw
         727w==
X-Forwarded-Encrypted: i=1; AJvYcCXW3M6ed5gL9Tvp7SuYqkNcRim8ZS55Ni78HMQsyGFMAWohZLKJQvGxca01+LDcYEoCd5STOgHb1oMI@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7GjfcWwySWVlEZFE2/xqv9UO/J0o1ojkVVb2dhw+tGGwlm+Og
	z/vQn726lgBq7N9/dZFmhY59bUfcqFA8FTJHwT8bNdjsVlToHpSz
X-Google-Smtp-Source: AGHT+IGQvuCEaxD+OraI+5cKyGSTu7tD/CJg85LUruBM4uiKXcONXcpmNBeIKIO1XfseqCDcqvNu/Q==
X-Received: by 2002:a05:6a20:9f96:b0:1d9:1971:bca9 with SMTP id adf61e73a8af0-1d9a8401bf9mr20881296637.24.1730298530417;
        Wed, 30 Oct 2024 07:28:50 -0700 (PDT)
Received: from met-Virtual-Machine.. ([167.220.2.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057932c62sm9304890b3a.45.2024.10.30.07.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 07:28:49 -0700 (PDT)
From: meetakshisetiyaoss@gmail.com
To: smfrench@gmail.com,
	sfrench@samba.org,
	pc@manguebit.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 2/2] cifs: support mounting with alternate password to allow password rotation
Date: Wed, 30 Oct 2024 10:27:58 -0400
Message-ID: <20241030142829.234828-2-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
In-Reply-To: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

This patch introduces the following changes to support password rotation on
mount:

1. If an existing session is not found and the new session setup results in
EACCES, EKEYEXPIRED or EKEYREVOKED, swap password and password2 (if
available), and retry the mount.

2. To match the new mount with an existing session, add conditions to check
if a) password and password2 of the new mount and the existing session are
the same, or b) password of the new mount is the same as the password2 of
the existing session, and password2 of the new mount is the same as the
password of the existing session.

3. If an existing session is found, but needs reconnect, retry the session
setup after swapping password and password2 (if available), in case the
previous attempt results in EACCES, EKEYEXPIRED or EKEYREVOKED.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/connect.c | 57 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 15d94ac4095e..71b305230e14 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1898,11 +1898,35 @@ static int match_session(struct cifs_ses *ses,
 			    CIFS_MAX_USERNAME_LEN))
 			return 0;
 		if ((ctx->username && strlen(ctx->username) != 0) &&
-		    ses->password != NULL &&
-		    strncmp(ses->password,
-			    ctx->password ? ctx->password : "",
-			    CIFS_MAX_PASSWORD_LEN))
-			return 0;
+		    ses->password != NULL) {
+
+			/* New mount can only share sessions with an existing mount if:
+			 * 1. Both password and password2 match, or
+			 * 2. password2 of the old mount matches password of the new mount
+			 *    and password of the old mount matches password2 of the new
+			 *	  mount
+			 */
+			if (ses->password2 != NULL && ctx->password2 != NULL) {
+				if (!((strncmp(ses->password, ctx->password ?
+					ctx->password : "", CIFS_MAX_PASSWORD_LEN) == 0 &&
+					strncmp(ses->password2, ctx->password2,
+					CIFS_MAX_PASSWORD_LEN) == 0) ||
+					(strncmp(ses->password, ctx->password2,
+					CIFS_MAX_PASSWORD_LEN) == 0 &&
+					strncmp(ses->password2, ctx->password ?
+					ctx->password : "", CIFS_MAX_PASSWORD_LEN) == 0)))
+					return 0;
+
+			} else if ((ses->password2 == NULL && ctx->password2 != NULL) ||
+				(ses->password2 != NULL && ctx->password2 == NULL)) {
+				return 0;
+
+			} else {
+				if (strncmp(ses->password, ctx->password ?
+					ctx->password : "", CIFS_MAX_PASSWORD_LEN))
+					return 0;
+			}
+		}
 	}
 
 	if (strcmp(ctx->local_nls->charset, ses->local_nls->charset))
@@ -2245,6 +2269,7 @@ struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
 	int rc = 0;
+	int retries = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2263,6 +2288,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 			cifs_dbg(FYI, "Session needs reconnect\n");
 
 			mutex_lock(&ses->session_mutex);
+
+retry_old_session:
 			rc = cifs_negotiate_protocol(xid, ses, server);
 			if (rc) {
 				mutex_unlock(&ses->session_mutex);
@@ -2275,6 +2302,13 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 			rc = cifs_setup_session(xid, ses, server,
 						ctx->local_nls);
 			if (rc) {
+				if (((rc == -EACCES) || (rc == -EKEYEXPIRED) ||
+					(rc == -EKEYREVOKED)) && !retries && ses->password2) {
+					retries++;
+					cifs_info("Session reconnect failed, retrying with alternate password\n");
+					swap(ses->password, ses->password2);
+					goto retry_old_session;
+				}
 				mutex_unlock(&ses->session_mutex);
 				/* problem -- put our reference */
 				cifs_put_smb_ses(ses);
@@ -2350,6 +2384,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	ses->chans_need_reconnect = 1;
 	spin_unlock(&ses->chan_lock);
 
+retry_new_session:
 	mutex_lock(&ses->session_mutex);
 	rc = cifs_negotiate_protocol(xid, ses, server);
 	if (!rc)
@@ -2362,8 +2397,16 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	       sizeof(ses->smb3signingkey));
 	spin_unlock(&ses->chan_lock);
 
-	if (rc)
-		goto get_ses_fail;
+	if (rc) {
+		if (((rc == -EACCES) || (rc == -EKEYEXPIRED) ||
+			(rc == -EKEYREVOKED)) && !retries && ses->password2) {
+			retries++;
+			cifs_info("Session setup failed, retrying with alternate password\n");
+			swap(ses->password, ses->password2);
+			goto retry_new_session;
+		} else
+			goto get_ses_fail;
+	}
 
 	/*
 	 * success, put it on the list and add it as first channel
-- 
2.46.0.46.g406f326d27

