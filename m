Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ED23C4171
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968940; cv=none; b=eV1GuBlMspLAY6pK5UI2ZCfiIHOO14/rpmxVDDc6L12Uc7IDQlANSk1x6a0X/CjRtqjy56fm6WrjyWYXLoqmL0xYdqWPccn47jpk0nD9Qh/MZcsuejXvuQ17KqBIBRfixNC+AsGyopA3XMFbA1u6ppCLOefphbn3jn+xR2TjABI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968940; c=relaxed/simple;
	bh=p/TK3jLaoLV0OlOVeyap/vgWeVAoCMa/ecz1kXfV6hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rDHyDxZzVMh3DE0/CpRe7qVIM79RCcpsPYRWphtYu7DLSAGik6lm7vs17UQS70bIygRdNv54FEtaqXmr28iy379rWCgb2D2P0Yjys/eXf6xmMSunqX9hhAzIx3SN5O5jZItux1AhPVBhUPCobvOO4BuY2KLD0ZCBMpyOSIrcLdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oinVQQch; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oinVQQch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC241F00AC4;
	Mon, 17 Aug 2026 12:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968939;
	bh=YrrWmFc3wGeXJyx30+Zn3x0EI9L+PIWGugJOie9wPPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oinVQQch+n5kndWMfzCiu4Rxbvm+snARrE9qs7ir74C32ss1TZpwOHVsc25tcSCJB
	 7U3UOn7qgSYZz4EdVQuejaeOTCX1y3eTnWGghr0GHfm9qr9uRPXRkSH7E//pCtd8eD
	 KJMZmKLU7Bb9dyZSfz0Odoyx0J2gf9Hkg+1Ybkj97wV0117YUdsc5czeaV5sPXdeTf
	 FGmJ8RR9wGi5YpsvyJSYareb3VcmIlzFRuiTIyaUyCES8nQudhXDiyY+OSdMOElIZv
	 pK18H+AWHlQ1C4ZiN+KORyIWCM9D0KlaM02pEYgzLXTACm73noDh3e3bK0NODkjW8x
	 lQX9urR31UUMg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: notify parent directory leases on child create
Date: Mon, 17 Aug 2026 21:15:15 +0900
Message-Id: <20260817121524.8812-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BVT_DirectoryLeasing_ReadWriteHandleCaching requires a parent directory
lease break notification when another client creates a child in the
leased directory. A child CREATE without a lease context did not notify
the parent lease holders because the notification path expected a
non-NULL lease context.

Allow the parent lease notification helper to handle a NULL child lease
context and notify matching parent leases. Invoke it after a child is
created without a lease context while preserving the existing lease-key
filtering for requests that provide one.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 9 +++++----
 fs/smb/server/smb2pdu.c | 3 +++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 5fc2c79881d1..58af0fddf39f 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1450,7 +1450,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 	struct ksmbd_inode *p_ci = NULL;
 	LIST_HEAD(brk_list);
 
-	if (lctx->version != 2)
+	if (lctx && lctx->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
@@ -1463,9 +1463,10 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 			continue;
 
 		if (opinfo->o_lease->state != SMB2_OPLOCK_LEVEL_NONE &&
-		    (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
-		     !compare_guid_key(opinfo, fp->conn->ClientGUID,
-				      lctx->parent_lease_key))) {
+		    (!lctx ||
+		     (!(lctx->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE) ||
+		      !compare_guid_key(opinfo, fp->conn->ClientGUID,
+			       lctx->parent_lease_key)))) {
 			if (!atomic_inc_not_zero(&opinfo->refcount))
 				continue;
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index da461535229a..bcf4e8e1ca22 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4663,6 +4663,9 @@ int smb2_open(struct ksmbd_work *work)
 			goto err_out1;
 		}
 	} else {
+		if (created && !lc)
+			smb_send_parent_lease_break_noti(fp, NULL);
+
 		if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE && lc) {
 			if (S_ISDIR(file_inode(filp)->i_mode)) {
 				lc->req_state &= ~SMB2_LEASE_WRITE_CACHING_LE;
-- 
2.25.1

