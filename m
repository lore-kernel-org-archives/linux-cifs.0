Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3FF36DA0F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 02:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783565913; cv=none; b=XSJweTwnsIIf8ZB4xj1vDGSX8m1cc3HMkpmXvtxgk+sxzLWZd+VCpJBN4UGlW3boO7Pk2aYjdD3MPAfUnZaGwbaIeKYVr2lPSxkNn2CD1p5KhEc0xzq7Djp8aBWjrtpc9h3C0sKonHuMYwEKTvMhcuQx/otQblKi9X/P7DAy9lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783565913; c=relaxed/simple;
	bh=qsA7c/Y4DscE5oXo1ucDqa3U4aR7bPpRSpXV5/Cjr5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhgxnKXnrzRODbrrb+0bvdHlq6oy/t1TQZszhKR0VJ8AeQes2qad9xMpCeB0N82AeDs4jKTwAlbLLbJRkmQhYt8y4gOWpmk+jZTyWrEyFQ0Neff/sEpZLbjbLvlM+MAa/6LiiczlPq7KHU+5VPkesscH3U47nD9ucBnEAa29FGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=BebINTdu; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="BebINTdu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783565909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gjFuN6M+VQ20ORfLZA7E7Zr632yXYN1KePXJ6mkK4tE=;
	b=BebINTdui2WpybrnufSrXAoRiNb1QtMjwEgIB5HyBWT7KdW6Nn8kktoLrP/P2g1nTWXtEr
	tE9kOmxM+J3fXSKn7IH0lFsqGy+1jWvtdV27NQbJq/t9fq+xD25lf2B1ChjR9Pt7d/ipZ0
	mkmohHyuE4y1HaIBTkJBP3APOSh8cc1WiEsQYeRmAU6NV1mcXgGpFPQPHB8Cgk/Qq4jSXg
	FF5tzdrLwF03VJU53Dkqqiwnx8O9nLXOOkIcIw6V4n/Wky2xig86R6BYLc7W6f/pHiu1a7
	V9OijUuxos426DtAnVpRhk5nlnRg4ao9Vnqbt+B/U85sEizLLg2So1gZRrN5IQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v5 4/4] smb/client: fix incorrect nlink returned by fstat()
Date: Thu,  9 Jul 2026 10:57:03 +0800
Message-ID: <20260709025703.3715326-5-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260709025703.3715326-1-chenxiaosong@chenxiaosong.com>
References: <20260709025703.3715326-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. mount -t cifs //${server_ip}/export /mnt
  2. touch /mnt/file1; ln /mnt/file1 /mnt/file2; ln /mnt/file1 /mnt/file3
  3. C program: int fd = open("/mnt/file1", O_RDONLY);
  4. C program: struct stat stbuf; fstat(fd, &stbuf);
                stbuf.st_nlink is always 1, should be 3

Setting `unknown_nlink` to true in `SMB2_open()` triggers the
`CIFS_FATTR_UNKNOWN_NLINK` flag in `cifs_open_info_to_fattr()`,
which safely preserves the existing i_nlink in
`cifs_nlink_fattr_to_inode()`.

See the detailed procedure below:

  path_openat
    open_last_lookups
      lookup_open
        atomic_open
          cifs_atomic_open // dir->i_op->atomic_open
            cifs_lookup
              cifs_get_inode_info
                cifs_get_fattr
                  smb2_query_path_info // server->ops->query_path_info
                    smb2_compound_op
                      SMB2_open_init
                      case SMB2_OP_QUERY_INFO
                      SMB2_query_info_init(FILE_ALL_INFORMATION,)
                  cifs_open_info_to_fattr
                    fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks)
                update_inode_info
                  cifs_iget
                    cifs_fattr_to_inode
                      cifs_nlink_fattr_to_inode
                        set_nlink(inode, fattr->cf_nlink)
    do_open
      vfs_open
        do_dentry_open
          cifs_open
            cifs_nt_open
              smb2_open_file // server->ops->open
                SMB2_open
                  buf->unknown_nlink = true
              cifs_get_inode_info
                cifs_get_fattr
                  cifs_open_info_to_fattr
                    if (data->unknown_nlink) // true
                    fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK
                update_inode_info
                  cifs_fattr_to_inode
                    cifs_nlink_fattr_to_inode
                      if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) // true
                      return // do not modify nlink

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/inode.c    | 2 ++
 fs/smb/client/smb2pdu.c  | 1 +
 3 files changed, 4 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ea1c5eb2356a..0454f69630ae 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -250,6 +250,7 @@ struct cifs_open_info_data {
 	bool adjust_tz;
 	bool reparse_point;
 	bool contains_posix_file_info;
+	bool unknown_nlink;
 	struct {
 		/* ioctl response buffer */
 		struct {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1dbcfd163ff0..4711886d7b4b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -909,6 +909,8 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	memset(fattr, 0, sizeof(*fattr));
+	if (data->unknown_nlink)
+		fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
 	fattr->cf_cifsattrs = le32_to_cpu(info->Attributes);
 	if (info->DeletePending)
 		fattr->cf_flags |= CIFS_FATTR_DELETE_PENDING;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5707d76a8647..d4d4c510412c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3380,6 +3380,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		file_info->EndOfFile = rsp->EndofFile;
 		file_info->Attributes = rsp->FileAttributes;
 		file_info->NumberOfLinks = cpu_to_le32(1);
+		buf->unknown_nlink = true;
 		file_info->DeletePending = 0; /* successful open = not delete pending */
 	}
 
-- 
2.54.0

