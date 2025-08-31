Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44D42673B7;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=o+qgn0j2J1eBlgpiK9TrNX8mYtHGsguMjZ61OaSsqtrpQOLq9QBx7t0EKCiOmuyzTM+jZcnEVzvVNMe1SxiFre6nf2coRkuxfcv8PoMAjmhf1cb4EQ/Q69dF7MU0jcxzPGNNS30jzcyosnnYE3L9L6K95w8rLdRWrmRXKV8SyYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=hHR1lBd0YmwQFz+umy/fyXgJon1sazFIo4kz+GMPEtU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmkECSTNcENe5hnZRYkKZlrxjj/RzBtRIIWYzbToJ/WjoMOjar4gDa5BejOcAI1bg93osNOwtxrl3CVEEuJWHbRMQcaQ8fFvV7Ralh0GNfeEk03NzD41oHrw/X70e+iYfmDC0OlqQI35i3PBIpkb0a9oEbFLxiwTPWJOBKOjla4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GI42Y+PY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GI42Y+PY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3E7C4CEFA;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=hHR1lBd0YmwQFz+umy/fyXgJon1sazFIo4kz+GMPEtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GI42Y+PYTTF6IGM9uWZshIx1D2yGzdxMjG19EtlYquRDH+oLmAxUwMDYKWEbEOrTO
	 NBowRRungnBzbbdix99rwkIo9i7Y2av1oTKb9suyS70owAjysRciBxIBdW4DTKIQwI
	 vzDUcplIAhPcQ60hOmjkjDGDDuFKfuIB2PtPpdZ78xaD6u7UJHbrdFq5Y1pXq7ZaTr
	 caI3iEl/Hot+x67yS7hfq0ArdBJb/WZq4WPDWcOOx1qn0+CiDhJBz8TT1E2ONumPEC
	 4JjMkIO3z8ikNXStXh20Y0VVyBUG5DG6mcCQ3EH2CunESUnpM/zV6SyCNk92Ff17zA
	 hdhOtWBTv4qvg==
Received: by pali.im (Postfix)
	id A5B071B0B; Sun, 31 Aug 2025 14:36:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 20/35] cifs: Fix permission logic in cifs_rename_pending_delete()
Date: Sun, 31 Aug 2025 14:35:47 +0200
Message-Id: <20250831123602.14037-21-pali@kernel.org>
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

Opening file with DELETE access does not have to be allowed by server for
file with ATTR_READONLY attribute set. So the current logic for clearing
the ATTR_READONLY attribute in cifs_rename_pending_delete() can fail as it
tries to open file with access mask DELETE | FILE_WRITE_ATTRIBUTES.

Fix the permission logic. First clear the ATTR_READONLY attribute and then
the open file with DELETE access. As for the RENAME and SET_DELETE_PENDING
operations is not required the FILE_WRITE_ATTRIBUTES access, do not pass it
into open. This allows to call cifs_rename_pending_delete() also on the
files with ACL permissions which disallows file modification.

For changing attributes use the set_file_info() callback function which
already handles the situation when the caller wants to clear the
ATTR_READONLY flag. Note that the set_file_info() callback also updates the
cifsInode->cifsAttrs member, so remove explicit assignment here.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 48 ++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 4658af632098..63ab233517f2 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1755,20 +1755,6 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		goto out;
 	}
 
-	oparms = (struct cifs_open_parms) {
-		.tcon = tcon,
-		.cifs_sb = cifs_sb,
-		.desired_access = DELETE | FILE_WRITE_ATTRIBUTES,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
-		.disposition = FILE_OPEN,
-		.path = full_path,
-		.fid = &fid,
-	};
-
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
-	if (rc != 0)
-		goto out;
-
 	origattr = cifsInode->cifsAttrs & ~ATTR_NORMAL;
 
 	/* clear ATTR_READONLY, needed for opening file with DELETE access */
@@ -1791,16 +1777,27 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	/* change dosattr, but only if needed */
 	if (dosattr != origattr) {
 		info_buf.Attributes = cpu_to_le32(dosattr);
-		rc = CIFSSMBSetFileInfo(xid, tcon, &info_buf, fid.netfid,
-					current->tgid);
+		rc = tcon->ses->server->ops->set_file_info(inode, full_path, &info_buf, xid);
 		/* although we would like to mark the file hidden
  		   if that fails we will still try to rename it */
-		if (!rc)
-			cifsInode->cifsAttrs = dosattr;
-		else
+		if (rc)
 			dosattr = origattr; /* since not able to change them */
 	}
 
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = DELETE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
+
+	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	if (rc != 0)
+		goto undo_setattr;
+
 	/* rename the file */
 	rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
 				   false /* overwrite */,
@@ -1808,7 +1805,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 				   cifs_remap(cifs_sb));
 	if (rc != 0) {
 		rc = -EBUSY;
-		goto undo_setattr;
+		goto undo_close;
 	}
 
 	/* try to set DELETE_PENDING */
@@ -1832,8 +1829,8 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
 	}
 
-out_close:
 	CIFSSMBClose(xid, tcon, fid.netfid);
+
 out:
 	cifs_put_tlink(tlink);
 	return rc;
@@ -1847,15 +1844,14 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, dentry->d_name.name,
 				true /* overwrite */,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
+undo_close:
+	CIFSSMBClose(xid, tcon, fid.netfid);
 undo_setattr:
 	if (dosattr != origattr) {
 		info_buf.Attributes = cpu_to_le32(origattr);
-		if (!CIFSSMBSetFileInfo(xid, tcon, &info_buf, fid.netfid,
-					current->tgid))
-			cifsInode->cifsAttrs = origattr;
+		tcon->ses->server->ops->set_file_info(inode, full_path, &info_buf, xid);
 	}
-
-	goto out_close;
+	goto out;
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
-- 
2.20.1

