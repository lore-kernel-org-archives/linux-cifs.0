Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AD1D517;
	Sat, 12 Oct 2024 08:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723356; cv=none; b=YsXNsoXyLImBsq3pk5RIo8HwlDwPvmy4IUFKi75yGSHuJtFKsQxzWdZ2dj5U1jdP492CrPcq/OIgpiDFvp+VyiGIJmBRgE2a2AJkxqzth9bzq+A4MuvpX3cbR34phkQZU4wE3UQgK0vPBTLxWY5dI6DJE+ENo3bvGdQoNUYcGRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723356; c=relaxed/simple;
	bh=aXcWnBwn8eWzEpq2xCZrD9ltkMngFQdpO2DxXG4OBig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZsA0Q0dMSaLl+g9VJvzMU8crbBPATBxegiT7tR+ZN79fPfjJJ4ybYk3P3M/llhQt6jtH7LSNB1008XDm6dfqrPkErLuYeWmIdM5jPJZEU2HkpZBo8SqdHAzSA5YD/EeG7onERKNzEZ3fvCtqc53dl1IGkLs2Ux+RHoB6GJFhz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXFFlkWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXFFlkWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D9AC4CEC6;
	Sat, 12 Oct 2024 08:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728723356;
	bh=aXcWnBwn8eWzEpq2xCZrD9ltkMngFQdpO2DxXG4OBig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXFFlkWG2xALIxw6MpT+bonBCEp14z0bIenks0ExMq0uJmKp6CkgcMs0YTQ4mhvVq
	 Av0rY+rOJ9YCC7cosx/ul8OhuFcnYiZR9CzsSXF244j/ux+fYFjk07RTLSiLUIJYiN
	 W51TPLNda/X9CR1A7eljOBVVGoPmu3/LVEtIeG4d80fnSVl1nZpfwS0rlJHmADcptR
	 wGO4l72XAZgmUngmqaAn8DZACdir3rP6juSWtNPTz96eOHZLp10uRvnFs0BaYimdgL
	 RgimmlIfzRXUU/5cC8G7GuDZfL88qAzGs69EgWCH6Xy24k+8sDoN8wAl7KIIRwremZ
	 6V7p9orQy2E5w==
Received: by pali.im (Postfix)
	id E8F647BD; Sat, 12 Oct 2024 10:55:50 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/7] cifs: Add support for creating native Windows sockets
Date: Sat, 12 Oct 2024 10:55:49 +0200
Message-Id: <20241012085549.670-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241012085252.560-1-pali@kernel.org>
References: <20241012085252.560-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Native Windows sockets created by WinSock on Windows 10 April 2018 Update
(version 1803) or Windows Server 2019 (version 1809) or later versions is
reparse point with IO_REPARSE_TAG_AF_UNIX tag, with empty reparse point
data buffer and without any EAs.

Create AF_UNIX sockets in this native format if -o nonativesocket was not
specified.

This change makes AF_UNIX sockets created by Linux CIFS client compatible
with AF_UNIX sockets created by Windows applications on NTFS volumes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsfs.c     |  2 ++
 fs/smb/client/connect.c    |  2 ++
 fs/smb/client/fs_context.c |  5 +++++
 fs/smb/client/fs_context.h |  2 ++
 fs/smb/client/reparse.c    | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 43 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 39ec67d9808e..eb279d5c6bd3 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -689,6 +689,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 					    cifs_sb->ctx->backupgid));
 	seq_show_option(s, "reparse",
 			cifs_reparse_type_str(cifs_sb->ctx->reparse_type));
+	if (cifs_sb->ctx->nonativesocket)
+		seq_puts(s, ",nonativesocket");
 	seq_show_option(s, "symlink",
 			cifs_symlink_type_str(get_cifs_symlink_type(cifs_sb)));
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index bc5b5100ac09..3db39f2ef5a8 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2831,6 +2831,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 		return 0;
 	if (old->ctx->reparse_type != new->ctx->reparse_type)
 		return 0;
+	if (old->ctx->nonativesocket != new->ctx->nonativesocket)
+		return 0;
 	if (old->ctx->symlink_type != new->ctx->symlink_type)
 		return 0;
 
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d68db6ac5f73..7f21630885cb 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -178,6 +178,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("sec", Opt_sec),
 	fsparam_string("cache", Opt_cache),
 	fsparam_string("reparse", Opt_reparse),
+	fsparam_string("nativesocket", Opt_nativesocket),
 	fsparam_string("symlink", Opt_symlink),
 	fsparam_string("symlinkroot", Opt_symlinkroot),
 
@@ -1674,6 +1675,9 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		if (parse_reparse_flavor(fc, param->string, ctx))
 			goto cifs_parse_mount_err;
 		break;
+	case Opt_nativesocket:
+		ctx->nonativesocket = result.negated;
+		break;
 	case Opt_symlink:
 		if (parse_symlink_flavor(fc, param->string, ctx))
 			goto cifs_parse_mount_err;
@@ -1803,6 +1807,7 @@ int smb3_init_fs_context(struct fs_context *fc)
 	ctx->retrans = 1;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
+	ctx->nonativesocket = 0;
 
 /*
  *	short int override_uid = -1;
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 5f306f581fd1..18d39d457145 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -170,6 +170,7 @@ enum cifs_param {
 	Opt_sec,
 	Opt_cache,
 	Opt_reparse,
+	Opt_nativesocket,
 	Opt_symlink,
 	Opt_symlinkroot,
 
@@ -300,6 +301,7 @@ struct smb3_fs_context {
 	bool dfs_automount:1; /* set for dfs automount only */
 	enum cifs_reparse_type reparse_type;
 	enum cifs_symlink_type symlink_type;
+	bool nonativesocket:1;
 	bool dfs_conn:1; /* set for dfs mounts */
 	char *symlinkroot; /* top level directory for native SMB symlinks in absolute format */
 };
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index d950c60323e8..57320a4c4d79 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -375,6 +375,35 @@ static int detect_directory_symlink_target(struct cifs_sb_info *cifs_sb,
 	return 0;
 }
 
+static int create_native_socket(const unsigned int xid, struct inode *inode,
+				struct dentry *dentry, struct cifs_tcon *tcon,
+				const char *full_path)
+{
+	struct cifs_open_info_data data = {
+		.reparse_point = true,
+		.reparse = { .tag = IO_REPARSE_TAG_AF_UNIX, },
+	};
+	struct reparse_data_buffer buf = {
+		.ReparseTag = cpu_to_le32(IO_REPARSE_TAG_AF_UNIX),
+		.ReparseDataLength = cpu_to_le16(0),
+	};
+	struct kvec iov = {
+		.iov_base = &buf,
+		.iov_len = sizeof(buf),
+	};
+	struct inode *new;
+	int rc = 0;
+
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+				     tcon, full_path, false, &iov, NULL);
+	if (!IS_ERR(new))
+		d_instantiate(dentry, new);
+	else
+		rc = PTR_ERR(new);
+	cifs_free_open_info(&data);
+	return rc;
+}
+
 static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 			       mode_t mode, dev_t dev,
 			       struct kvec *iov)
@@ -598,6 +627,9 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 {
 	struct smb3_fs_context *ctx = CIFS_SB(inode->i_sb)->ctx;
 
+	if (S_ISSOCK(mode) && !ctx->nonativesocket && ctx->reparse_type != CIFS_REPARSE_TYPE_NONE)
+		return create_native_socket(xid, inode, dentry, tcon, full_path);
+
 	switch (ctx->reparse_type) {
 	case CIFS_REPARSE_TYPE_NFS:
 		return mknod_nfs(xid, inode, dentry, tcon, full_path, mode, dev, NULL);
-- 
2.20.1

