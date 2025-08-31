Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769FF26F2A6;
	Sun, 31 Aug 2025 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643800; cv=none; b=A1mvEqWthVLIkPPd/JGyDIKRO4a86bl/wD0cl8KehCjXTrvgR4a4FIvgY+Qy8rgyC+q9fMVa14PaW0TywU3nDmi6SHOyYDKgDmH52CSZEPv/USnJt0U8A2DFXRJhyDECxAfbJA3YjUPDy7JueFdDBRmJa+IglRMu+mScguca8VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643800; c=relaxed/simple;
	bh=uA/HDvBMaiWbGDSPGBQm5JB6alpNsa8hljEovxFjYFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzXUgDG5QyyZ7S8t8e2dUTSHIianLGHgR/2sNgXgSszbhYygv0aPw/VVmNk+9TDJAlpdF5+KsDsU/ctJevTWILrdh5P1vyNpa7CTxfEfFZxBPUzFCM8k9+J7N8d2diYEP+ZbcrtpITwrhUyOpIp3S/y2MZSlTXHNz3BJk0XRnhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xst19Egx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xst19Egx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB061C4CEF5;
	Sun, 31 Aug 2025 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643800;
	bh=uA/HDvBMaiWbGDSPGBQm5JB6alpNsa8hljEovxFjYFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xst19Egx39dh/ALGVIAgUA17QxKkzijLuU4k9BH6KNEi4Rcxe877rwbRpAMUDdo+M
	 R4w+fStIarbJTYA81TYOGDmWFxk2ObZPhZ08PmppgJJBKdpnxlO1nKy2/P/2YiYTJi
	 JlGiOvSaEXeAiTrnZscCK/e9yDCqfIU/8D9aC8POZ8HraAbwPkqS5tDPrbaCJbdKd+
	 6e09IyrszbFGD/EEyYK+Q58Jel5kfMXTWnTjxEB6SWmlVRjUfZlhr6uvYtxVKzCnK3
	 6nMhUFoS4nCjpoUC5w3o6tXs6dWyxpEs9qUKrDWjlUlp/6lZ+8drYiOA0praCSLh1q
	 DOIIAk8MuYBWw==
Received: by pali.im (Postfix)
	id 217B912ED; Sun, 31 Aug 2025 14:36:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 31/35] cifs: Deduplicate smb2_unlink() and smb2_rmdir() into one common function
Date: Sun, 31 Aug 2025 14:35:58 +0200
Message-Id: <20250831123602.14037-32-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These two functions smb2_unlink() and smb2_rmdir() share lot of common
logic. Deduplicate them into one common static function smb2_remove().

No functional change. All logic and handling stay same.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 57 +++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index a3b1ed53a860..0dd4a77dfb64 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1332,43 +1332,54 @@ smb2_mkdir_setinfo(struct inode *inode, const char *name,
 		cifs_i->cifsAttrs = dosattrs;
 }
 
-int
-smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
-	   struct cifs_sb_info *cifs_sb)
+static int
+smb2_remove(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	    struct cifs_sb_info *cifs_sb, struct dentry *dentry, bool is_dir)
 {
 	struct cifs_open_parms oparms;
+	int op_flags;
+	int op;
+	int rc;
 
-	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
-	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
-			     FILE_OPEN, CREATE_NOT_FILE | OPEN_REPARSE_POINT, ACL_NO_MODE);
-	return smb2_compound_op(xid, tcon, cifs_sb,
-				name, &oparms, NULL,
-				&(int){SMB2_OP_RMDIR}, 1,
-				NULL, NULL, NULL, NULL);
-}
-
-int
-smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
-	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
-{
-	struct cifs_open_parms oparms;
+	if (is_dir)
+		drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
 
+	if (is_dir) {
+		op = SMB2_OP_RMDIR;
+		op_flags = CREATE_NOT_FILE;
+	} else {
+		op = SMB2_OP_DELETE;
+		op_flags = CREATE_NOT_DIR;
+	}
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name,
 			     DELETE, FILE_OPEN,
-			     CREATE_NOT_DIR | OPEN_REPARSE_POINT,
+			     OPEN_REPARSE_POINT | op_flags,
 			     ACL_NO_MODE);
-	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
-				  NULL, &(int){SMB2_OP_DELETE}, 1,
-				  NULL, NULL, NULL, dentry);
-	if (rc == -EINVAL) {
+	rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
+			      NULL, &op, 1, NULL, NULL, NULL, dentry);
+	if (rc == -EINVAL && dentry) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
 		rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
-				      NULL, &(int){SMB2_OP_DELETE}, 1,
+				      NULL, &op, 1,
 				      NULL, NULL, NULL, NULL);
 	}
 	return rc;
 }
 
+int
+smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	   struct cifs_sb_info *cifs_sb)
+{
+	return smb2_remove(xid, tcon, name, cifs_sb, NULL, true /* is_dir */);
+}
+
+int
+smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
+	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
+{
+	return smb2_remove(xid, tcon, name, cifs_sb, dentry, false /* is_dir */);
+}
+
 static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
 			      const char *from_name, const char *to_name,
 			      struct cifs_sb_info *cifs_sb,
-- 
2.20.1

