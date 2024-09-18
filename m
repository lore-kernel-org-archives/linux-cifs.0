Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8A5132464
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636578; cv=pass; b=oprZhJU73bWplz1C7A1XfLGQkHWNFPAEYXB3Bov3CeV/mppKUx3/Y4zjxT8StA5G9+3BcEWrGgBDOaQpu7X6+HF0Zi0RoxM/oEFxD/5D9YH+01SgCJXE97KJSUwP0xfwpp1galNdg3OiVeulwKDpy7Mu0ugOS8EGn7+ByVeQ2q8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636578; c=relaxed/simple;
	bh=7BDrw2Wsgu9hbilz+d46QQdb+93h8AMbjWmzlruoob8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUfuPiblX10G76Ga8DforOIEn6p/wsVNEota/oprAN09XT0ifFIunAUtzjkhcVohtHcXZLvfYr616KSGM0U+QIvVEfqg27FFWeKpWfzCXT+yp+haACI6MgKoHH8ijy3A5pCE8bkiA/sR/X1SGflriDq+UK6xaWywY7JSzcs5xk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Qym1NZFy; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Qym1NZFy"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tI8M5neBcwcVw4Zjc9idtrkzUNfYBZs0C9OxoF3vZSY=;
	b=Qym1NZFymmYd5sBb9aFXuE0hzsHIY2GlUwQ+UBbvm7FIygAc2ysq5dp/qlqaYZTt2i5YmE
	GxUx2W4LBpnVHORFEXkm66AAydhCbGLGD4M/zBr9tcRE0MeMkrm/qWTfSfnC6oD76zZtN2
	QuwQryLY6DP7mJjeXWKs6ZF8/t6QFP8ptqUyB92H3fRgrejH12Go+C2tttlEo7514Ty/RW
	9zSJhLU9NSkt880OK8KovQYtpkyqHkL7KYqQdx82l0cCC1vP2axP+2kiN/v25km7mCO4Mp
	csE34+cigwQ9YN6kgCQFDY92nsDGFeKLLwjy8+NkTUWI0djO/wzuXx+jVy0kHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636575; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tI8M5neBcwcVw4Zjc9idtrkzUNfYBZs0C9OxoF3vZSY=;
	b=lgJ8wEuq/dj2AdgYojot3/QoIXAopELP6B3Sxm6hJRF/lnn0dE84D0eztwsK48nLqnuLtp
	09Dy4tS6YenFw29Ix3Ewd/lS0nA/AIY05qBZWbyd62YBvdoQ0+XWRF3wk1/8ybrDFi78N+
	Om/XuzjCLJDhwK7K35UewumNgLTbIR92CgKt6F/vErkDkdwL//Y3e7XH5FUe/LtEADnp7y
	y/z64J6sJTZnxhxwHSH9dV7YVxPpAVxWJ6za3JWel3yAF/kXhc2ZbpXaOr+6yqlYIgdyrr
	hqdC5fw/fiVLUaLIizvswZe3uWmFyQCjfpcVhrTbd426i29+GZ/RMfxHhOoRsA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636575; a=rsa-sha256;
	cv=none;
	b=eBjjEdlYCB5GmMWGnKRVZb109tfHisSreqVvr+ZIXIukxo+n81oulSrt94eKCw3H4p2KiA
	ciYqzp55rbcLSOA/7go/eTg/UmNH0Yo4aT8gfVxbohredrADpp2dvogzNjcHfmPb4hS6Vg
	m31za+tlZgP+WB6qwAzK4mqKw32PdWd/YOWl6nGK2olWLIaay7MkLoPnosEFeDsLYThIzB
	ccpAxwV0hz+CavFPOp3kAJr+766VsYfHnF3q1YnFPhwyPPh7QMjhIuLYtkfRpsh8TfjgpD
	T6hjnnfO/IENEzwtjwC4GWwVVvWYrDE/ItBfeJ8s1v5/I7msZyzJW4v1SLsMhg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 6/9] smb: client: stop flooding dmesg on failed session setups
Date: Wed, 18 Sep 2024 02:15:39 -0300
Message-ID: <20240918051542.64349-6-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Stop flooding dmesg over failed session setups as kerberos tickets
getting expired or passwords being rotated is a very common scenario.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 4 +++-
 fs/smb/client/smb2pdu.c | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e1df9f093339..a382f532974a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3390,6 +3390,8 @@ int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx)
 	ses = cifs_get_smb_ses(server, ctx);
 	if (IS_ERR(ses)) {
 		rc = PTR_ERR(ses);
+		if (rc == -ENOKEY && ctx->sectype == Kerberos)
+			cifs_dbg(VFS, "Verify user has a krb5 ticket and keyutils is installed\n");
 		ses = NULL;
 		goto out;
 	}
@@ -4008,7 +4010,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		rc = server->ops->sess_setup(xid, ses, server, nls_info);
 
 	if (rc) {
-		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
+		cifs_server_dbg(FYI, "Send error in SessSetup = %d\n", rc);
 		spin_lock(&ses->ses_lock);
 		if (ses->ses_status == SES_IN_SETUP)
 			ses->ses_status = SES_NEED_RECON;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f68746becd64..1f78b7368b00 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1626,8 +1626,8 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	spnego_key = cifs_get_spnego_key(ses, server);
 	if (IS_ERR(spnego_key)) {
 		rc = PTR_ERR(spnego_key);
-		if (rc == -ENOKEY)
-			cifs_dbg(VFS, "Verify user has a krb5 ticket and keyutils is installed\n");
+		cifs_dbg(FYI, "%s: couldn't auth with kerberos: %d\n",
+			 __func__, rc);
 		spnego_key = NULL;
 		goto out;
 	}
-- 
2.46.0

