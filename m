Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6466D430794
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 16:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783528016; cv=none; b=YhCskNdGbCEG7qlC+thaXB3A0mKBtMV9JbGfwcRZHet1OJgoxoP9Kzbhbu1l6Rj9X+O9DclyAdt/OCPXOdSdjrAqkHdk2ONDMaxVGNe/rCbAeRDMHMiv4iRWQsyvVSsrtRL+MgVYWqaeQW56VDHzm1ENBHOEA3cQOAHE8aHHXBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783528016; c=relaxed/simple;
	bh=JsjZW/ncRNW92Zj7Soj96plgL6a0jpqpT6s4tNUwm3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdgWbsLVg1jG8Dl5pQa4jOxHSUpk60yOqbGfYWtMY7SxAVBRBlGktVKOglnugtud9X+0hyMV8Sq/BQcM3SO7c+w55ypziydqg/jyg7t+6Gs5ds285F81V/ibknR6UuO56vg7f3ShcBwUIBBD4duryipMeGg71uhomkTU53YY5FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=qNAotFLO; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="qNAotFLO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783528011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C2ZmJdcntaAy6qHQ6/sg09W/gldzhISSBIhMFg/vp44=;
	b=qNAotFLOWpe/zaz3au3zkDK3QZx5cBii/MDroQ0Cfkfyk/2ZC84q05X/Hiymx8MwAlYKnC
	t98MqVadPjohCw5i7TIpZuipmotkQx3zB7B6JvdHuo917npdCb0V29/x9OxDuIjI2kauIy
	HSHVchqt1BzPehd+A2dqhdRFWqDmz4L5N/NJyir4uCoTlCTW2ETW+GaN4j7/rqR4QXKJ7T
	UhiYa/I1mRZFntZu6q2sx04XtYdNEIYDQi+e9Y+z1TNK3kra7saHkASl1xtZgdPbjEDWOV
	Aw3ZTCJwutNcNnyFIOIlu2rmAqCdKn6AsuIRuppMQKSe8gjTj1UrtjswkWKQwA==
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
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 3/3] smb/client: fix incorrect nlink returned by fstat()
Date: Wed,  8 Jul 2026 16:25:52 +0000
Message-ID: <20260708162552.209468-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
References: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
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

`cifs_atomic_open()` already obtains the correct nlink. Setting
`CIFS_FATTR_UNKNOWN_NLINK` flag in `SMB2_open()` will safely preserve
the existing i_nlink in `cifs_nlink_fattr_to_inode()`.

Refer to the detailed procedure below:

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
                  buf->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK
              cifs_get_inode_info
                cifs_get_fattr
                  cifs_open_info_to_fattr
                    fattr->cf_flags |= data->cf_flags // set CIFS_FATTR_UNKNOWN_NLINK
                update_inode_info
                  cifs_fattr_to_inode
                    cifs_nlink_fattr_to_inode
                      if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) // true
                      return // do not modify nlink

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/inode.c    | 1 +
 fs/smb/client/smb2pdu.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ea1c5eb2356a..08f36e49df2a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -250,6 +250,7 @@ struct cifs_open_info_data {
 	bool adjust_tz;
 	bool reparse_point;
 	bool contains_posix_file_info;
+	u32 cf_flags;
 	struct {
 		/* ioctl response buffer */
 		struct {
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 1dbcfd163ff0..3fe89ab7c651 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -909,6 +909,7 @@ static void cifs_open_info_to_fattr(struct cifs_fattr *fattr,
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	memset(fattr, 0, sizeof(*fattr));
+	fattr->cf_flags |= data->cf_flags;
 	fattr->cf_cifsattrs = le32_to_cpu(info->Attributes);
 	if (info->DeletePending)
 		fattr->cf_flags |= CIFS_FATTR_DELETE_PENDING;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5707d76a8647..720efa60fe70 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3380,6 +3380,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		file_info->EndOfFile = rsp->EndofFile;
 		file_info->Attributes = rsp->FileAttributes;
 		file_info->NumberOfLinks = cpu_to_le32(1);
+		buf->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
 		file_info->DeletePending = 0; /* successful open = not delete pending */
 	}
 
-- 
2.54.0

