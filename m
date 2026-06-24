Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86E11D416C
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267432; cv=none; b=rbsTFMq/42V0DII7EPUUuN2fuV9MsQHv8EE6x+4TuI3GrWf7oMnjmSaAenXN5wvd4KGjrc1W8YS0hohQ2DbDSGHBG2txFrsE1P9I+vlaDvxayfAYGoZAPWFUvlM8aFtMfABJoLYcayTFJt1gYNRUMAlvlYKsFz8+fPrioAe+jWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267432; c=relaxed/simple;
	bh=+fwB87bgUbxzPPi3gSbfKrT6p3J8mzdTpjwLDzLK/vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxYSyBWhSgQeE/OtUH+sX1FgNCnXgmcxNF4fO/lxfCbofJ68O7TJP15yUuLltThh3RU/91USHLqvaZ9dhIC+yjeaXNLPnh2yj7/AKIHjk+xOwIbdMRH/ZSsXrswe6Jk+kEUzWsfENjVaJgBVNduM4qouY/ZzF9WL+7RJ+NxpqCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z9PNQUIZ; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z9PNQUIZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RAwHiMsDQyvZFbk1S36QgC7MRQ2lSi+zjeuA/4JdFNc=;
	b=Z9PNQUIZqGJYMx8JpCzIIHN9jqPgQy8+Pc92jonj+cFp/zffLJnyyAVv1qF2qXIFgxekyR
	Uk2ItgHAbwF7+O4HFe3tys+160djaftaKNofWPt2EukcXofbkahQveD+1OotWphYNxagEK
	PoQ91dhighptBlNSXR61i9DtNVCk6/o=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 2/9] smb/client: preserve errors from smb2_set_sparse()
Date: Wed, 24 Jun 2026 10:15:43 +0800
Message-ID: <20260624021550.1548952-3-huiwen.he@linux.dev>
In-Reply-To: <20260624021550.1548952-1-huiwen.he@linux.dev>
References: <20260624021550.1548952-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

smb2_set_sparse() converts every FSCTL_SET_SPARSE failure to false and
marks sparse support as broken for the share. Callers therefore report
EOPNOTSUPP even for errors such as ENOSPC or EACCES, and later sparse
operations remain disabled until the share is unmounted.

Return the SMB2 ioctl error directly. Set broken_sparse_sup only for
EOPNOTSUPP, which indicates that the server does not support the request.

Update smb3_punch_hole() to propagate the error returned by
smb2_set_sparse().

Fixes: 3d1a3745d8ca ("Add sparse file support to SMB2/SMB3 mounts")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2964f461fc84..965a4d21dd43 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2117,8 +2117,9 @@ smb2_sync_write(const unsigned int xid, struct cifs_fid *pfid,
 }
 
 /* Set or clear the SPARSE_FILE attribute based on value passed in setsparse */
-static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
-		struct cifsFileInfo *cfile, struct inode *inode, __u8 setsparse)
+static int smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
+			   struct cifsFileInfo *cfile, struct inode *inode,
+			   __u8 setsparse)
 {
 	struct cifsInodeInfo *cifsi;
 	int rc;
@@ -2127,31 +2128,31 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* if file already sparse don't bother setting sparse again */
 	if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && setsparse)
-		return true; /* already sparse */
+		return 0; /* already sparse */
 
 	if (!(cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) && !setsparse)
-		return true; /* already not sparse */
+		return 0; /* already not sparse */
 
 	/*
 	 * Can't check for sparse support on share the usual way via the
 	 * FS attribute info (FILE_SUPPORTS_SPARSE_FILES) on the share
 	 * since Samba server doesn't set the flag on the share, yet
 	 * supports the set sparse FSCTL and returns sparse correctly
-	 * in the file attributes. If we fail setting sparse though we
-	 * mark that server does not support sparse files for this share
-	 * to avoid repeatedly sending the unsupported fsctl to server
-	 * if the file is repeatedly extended.
+	 * in the file attributes. If the server returns EOPNOTSUPP, mark
+	 * that sparse files are not supported on this share to avoid
+	 * repeatedly sending the unsupported FSCTL.
 	 */
 	if (tcon->broken_sparse_sup)
-		return false;
+		return -EOPNOTSUPP;
 
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
 			cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
 			&setsparse, 1, CIFSMaxBufSize, NULL, NULL);
 	if (rc) {
-		tcon->broken_sparse_sup = true;
+		if (rc == -EOPNOTSUPP)
+			tcon->broken_sparse_sup = true;
 		cifs_dbg(FYI, "set sparse rc = %d\n", rc);
-		return false;
+		return rc;
 	}
 
 	if (setsparse)
@@ -2159,7 +2160,7 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
 	else
 		cifsi->cifsAttrs &= (~FILE_ATTRIBUTE_SPARSE_FILE);
 
-	return true;
+	return 0;
 }
 
 static int
@@ -3483,10 +3484,9 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 
 	/* Need to make file sparse, if not already, before freeing range. */
 	/* Consider adding equivalent for compressed since it could also work */
-	if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse)) {
-		rc = -EOPNOTSUPP;
+	rc = smb2_set_sparse(xid, tcon, cfile, inode, set_sparse);
+	if (rc)
 		goto out;
-	}
 
 	filemap_invalidate_lock(inode->i_mapping);
 	/*
-- 
2.43.0

