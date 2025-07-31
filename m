Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BE528A40F
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 23:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754005631; cv=none; b=NxNQAiUkBOvWk3ZopMJeaENTuz8XipjKF/AWcv6BnVJNdH2wFmV978HhlYPNSYkS42033jfkB4C9FWc7fE0wCIhI9AO8LhJn5ELxNfYkZylzUDzHRw5jCc3PCUj/b3IJrCEzJdEn4+X5ZqomXIipf4ykkfi2zPmF+r8lNApDKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754005631; c=relaxed/simple;
	bh=GmOfgPuz+khoiSRsqjWf59/DzveVmV2RknsRUviiv/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVEmBcwmNZFjfmSYSus/tetexdfbBjeSgaRq9ACYDAodw5YqYjsDeHOALiu3WAMtGudSMdPzq76oh2GOm0Gn/sYYlpuG/i1eGCYDDLRI4eDWdJ+vNc+aRq5Z01YMFWUpRYhcV+eRfXT5RQWwJkBbD+FnELPOMRGhsQt/M9MWxGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=U+pfzNH/; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="U+pfzNH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=tF2JpWjYgdXnxKvXeQbn3h0Yvk+11BRJUNrPCpvli9Y=; b=U+pfzNH/7WgBRyBx/QEGPd8dOA
	Ib3ABWHAmGCRcEmElMDSnRQTKGBPvz/0GTiUlwmELy3bcN8zim9iP6Z06Et1Hjpz0BR6qnkTCIO2U
	XhIIneC++Dv7NS+1aDx0ENjbBcX6Y+fOnbv46G9J4+vuOcpN5KgIz/OCGwuoKxKKIPe/ox6E7hLek
	TcqXfsXWIeLzxMIUMcytfwNpy+c5wM5VqZaLaJTHFRYYjqgELM9sraKuW4LIplw6Cbgiq0TCsfuo3
	9tFxEStAqdNwizDxYhDKaXW1xCgV+4rcmYu0tdUNaYUMY0iuebT4L1PFwurhnMboPmUIF3cQUYeFj
	TUdgkxCg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uhczL-00000000AcB-04yc;
	Thu, 31 Jul 2025 20:47:07 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Ralph Boehme <slow@samba.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Richardson <m.richardson@ed.ac.uk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH 3/3] smb: client: fix creating symlinks under POSIX mounts
Date: Thu, 31 Jul 2025 20:46:43 -0300
Message-ID: <20250731234643.787785-3-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250731234643.787785-1-pc@manguebit.org>
References: <20250731234643.787785-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB3.1.1 POSIX mounts support native symlinks that are created with
IO_REPARSE_TAG_SYMLINK reparse points, so skip the checking of
FILE_SUPPORTS_REPARSE_POINTS as some servers might not have it set.

Cc: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>
Cc: David Howells <dhowells@redhat.com>
Reported-by: Matthew Richardson <m.richardson@ed.ac.uk>
Closes: https://marc.info/?i=1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 fs/smb/client/cifsglob.h  | 5 +++++
 fs/smb/client/cifssmb.c   | 4 ++--
 fs/smb/client/link.c      | 2 +-
 fs/smb/client/smb1ops.c   | 2 +-
 fs/smb/client/smb2inode.c | 5 ++---
 fs/smb/client/smb2ops.c   | 5 ++---
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 19dd901fe8ab..a97e2cca2f53 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2377,4 +2377,9 @@ static inline bool cifs_netbios_name(const char *name, size_t namelen)
 	return ret;
 }
 
+#define CIFS_REPARSE_SUPPORT(tcon) \
+	((tcon)->posix_extensions || \
+	 (le32_to_cpu((tcon)->fsAttrInfo.Attributes) & \
+	  FILE_SUPPORTS_REPARSE_POINTS))
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 6c890db06593..d20766f664c4 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2751,7 +2751,7 @@ int cifs_query_reparse_point(const unsigned int xid,
 	if (cap_unix(tcon->ses))
 		return -EOPNOTSUPP;
 
-	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+	if (!CIFS_REPARSE_SUPPORT(tcon))
 		return -EOPNOTSUPP;
 
 	oparms = (struct cifs_open_parms) {
@@ -2879,7 +2879,7 @@ struct inode *cifs_create_reparse_inode(struct cifs_open_info_data *data,
 	 * attempt to create reparse point. This will prevent creating unusable
 	 * empty object on the server.
 	 */
-	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
+	if (!CIFS_REPARSE_SUPPORT(tcon))
 		return ERR_PTR(-EOPNOTSUPP);
 
 #ifndef CONFIG_CIFS_XATTR
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index afe76367d2c8..fe80e711cd75 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -635,7 +635,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	case CIFS_SYMLINK_TYPE_NATIVE:
 	case CIFS_SYMLINK_TYPE_NFS:
 	case CIFS_SYMLINK_TYPE_WSL:
-		if (le32_to_cpu(pTcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
+		if (CIFS_REPARSE_SUPPORT(pTcon)) {
 			rc = create_reparse_symlink(xid, inode, direntry, pTcon,
 						    full_path, symname);
 			goto symlink_exit;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e364b6515af3..f722c7f47b07 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1272,7 +1272,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 		 */
 		return cifs_sfu_make_node(xid, inode, dentry, tcon,
 					  full_path, mode, dev);
-	} else if (le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS) {
+	} else if (CIFS_REPARSE_SUPPORT(tcon)) {
 		/*
 		 * mknod via reparse points requires server support for
 		 * storing reparse points, which is available since
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 69d251726c02..2a0316c514e4 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1346,9 +1346,8 @@ struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 	 * attempt to create reparse point. This will prevent creating unusable
 	 * empty object on the server.
 	 */
-	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS))
-		if (!tcon->posix_extensions)
-			return ERR_PTR(-EOPNOTSUPP);
+	if (!CIFS_REPARSE_SUPPORT(tcon))
+		return ERR_PTR(-EOPNOTSUPP);
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     SYNCHRONIZE | DELETE |
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1b4a31894f43..bd6c1fb2a992 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5260,10 +5260,9 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
 					full_path, mode, dev);
-	} else if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_REPARSE_POINTS)
-		|| (tcon->posix_extensions)) {
+	} else if (CIFS_REPARSE_SUPPORT(tcon)) {
 		rc = mknod_reparse(xid, inode, dentry, tcon,
-					full_path, mode, dev);
+				   full_path, mode, dev);
 	}
 	return rc;
 }
-- 
2.50.1

