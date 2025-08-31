Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF13262FC2;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=JEgJGbtVluW4LWnDxIkl2r5yN8mV7/9ZTJmiwsNm+nqkqkdp5OtOPfTTYRVtvpTGjeMEy6ZtJKX8CZPoQ6nL0sZhiuypf5zAUEHV8mDJlTTph3DpcuQmiu2oSGbioMMaWG5zSBNvL/dNktTiyqYAVZnpm4jdhfQLggL0VLhdCg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=sXWaFMdUwYOSr6TRFPlyz4v0sDW5h49C99sHYUcew2g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pz7uKyrMFT+BtQRo8vabqJbpnTOdhh+dQYApuVb2EoasWicmQySVlSqtmBC4eLBcPu7xZUj/BS12Fi6sDsrpdRh1v0jXuhEdKnnz9pnprAj4qJsEqlOdqVIzX1M7WiXXN/j6ag413gc4oCeraaMO4oi4FuzplVaOuXP/8ONQV/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aY85IN9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aY85IN9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D159C4CEFD;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=sXWaFMdUwYOSr6TRFPlyz4v0sDW5h49C99sHYUcew2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aY85IN9PU/YNTZd4PC8ODJ87KR2GZUSfI/dHQHoYjRxmDjgYMl4VJjQ/dyhpq9qqr
	 puj6ehpPUAb4sz8nrhGtD5evz8aKthJYhjaCrxGjJ/mwMfjGzg98PQ5Z3g9Mds7Tqx
	 DFlJj1DsldC0CiD2xT1QSoy9bGCuZe727M/p3vJc+9cEOrpW1kk/MdqTrGCBVfvANi
	 p4KkLl2y6sdMzfE4qzKx+8NP3e1vff7A7FlIcQ6GIbHAuCh7AF2M7NQ+KmrxszpigA
	 teCKDiH5CL5JoPi7S/dtPt4YzhA9UvSr7b/cEwfx2KL0k1ye/ynlsN6z8lWJ/k9fvE
	 vBQuDRZqTjoLA==
Received: by pali.im (Postfix)
	id 52F8613DE; Sun, 31 Aug 2025 14:36:33 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/35] cifs: Avoid dynamic memory allocation of FILE_BASIC_INFO buffer in cifs_rename_pending_delete()
Date: Sun, 31 Aug 2025 14:35:40 +0200
Message-Id: <20250831123602.14037-14-pali@kernel.org>
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

Put FILE_BASIC_INFO buffer on the stack as it is not too large.
This simplify error handling in cifs_rename_pending_delete().

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 88d1d657cfb0..2889fa6625af 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1711,7 +1711,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 	__u32 dosattr, origattr;
-	FILE_BASIC_INFO *info_buf = NULL;
+	FILE_BASIC_INFO info_buf = {};
 	unsigned char sillyname[SILLYNAME_LEN + 1];
 	int sillyname_len;
 
@@ -1780,13 +1780,8 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 
 	/* set ATTR_HIDDEN and clear ATTR_READONLY, but only if needed */
 	if (dosattr != origattr) {
-		info_buf = kzalloc(sizeof(*info_buf), GFP_KERNEL);
-		if (info_buf == NULL) {
-			rc = -ENOMEM;
-			goto out_close;
-		}
-		info_buf->Attributes = cpu_to_le32(dosattr);
-		rc = CIFSSMBSetFileInfo(xid, tcon, info_buf, fid.netfid,
+		info_buf.Attributes = cpu_to_le32(dosattr);
+		rc = CIFSSMBSetFileInfo(xid, tcon, &info_buf, fid.netfid,
 					current->tgid);
 		/* although we would like to mark the file hidden
  		   if that fails we will still try to rename it */
@@ -1829,7 +1824,6 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 out_close:
 	CIFSSMBClose(xid, tcon, fid.netfid);
 out:
-	kfree(info_buf);
 	cifs_put_tlink(tlink);
 	return rc;
 
@@ -1843,8 +1837,8 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
 undo_setattr:
 	if (dosattr != origattr) {
-		info_buf->Attributes = cpu_to_le32(origattr);
-		if (!CIFSSMBSetFileInfo(xid, tcon, info_buf, fid.netfid,
+		info_buf.Attributes = cpu_to_le32(origattr);
+		if (!CIFSSMBSetFileInfo(xid, tcon, &info_buf, fid.netfid,
 					current->tgid))
 			cifsInode->cifsAttrs = origattr;
 	}
-- 
2.20.1

