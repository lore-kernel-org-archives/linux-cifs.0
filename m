Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD964A2A48
	for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2026 19:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791659522; cv=none; b=pKP5a5USi7XaDmtN47316knFgeodY6VEc/bOKJCIhGyJhZ2ol0epLMVxvd7mKpD8r5/Rv/sLZX7TNgyiDCwf5JOP8webHd4zLo0DNXUwnLj3Oad3yPDH99rNIO5KS5fURndV1xu1/EnQZMOKm5hs6F6Ji712L3GOYICnywcDO1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791659522; c=relaxed/simple;
	bh=lwVwmgkZTws1Bf1KrGLUNbjrdoP4vb6TfSWiGNKs0AE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=k+ySY8hwaloGiygIBGOp/WwxZUDnRFFHkRT7X5BPTAO9jz/SMwc8sNjNadylWW+k2xUOb7UZ41cNTQ1SrpbAulkJXXMjQ78WSFu4/Fe80TcSIXQ7tqb9wf5+hNj+PYvToZZkla2WQ61eL+F+g6vkQkvHCTNeW1ZZl+N7TPWLuuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=YbbGm0zO; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="YbbGm0zO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1791659513; bh=7JOskYC05vmDetDxG1ATRi5gE341lcs3uWuHcd1fXYY=;
	h=From:To:Cc:Subject:Date;
	b=YbbGm0zOA2qc1f16uzIFSaAphnzoL6brCrE0h3+KFnvQF7Y8YJ8VBKIolndfdMR5v
	 CP03yBEU9HGxhx09l5N9nYzoPLrbXV+PYRuHEekcrC6yVERQ2HCYI94zMjwTNDyjHz
	 yUeqtux1vGl+rq/0Z1OOUhjwGOqng9C0wA9IxFwc=
Received: from demiurge ([240e:b30:2199:72b1::e99])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 2F3A3A5D; Sun, 11 Oct 2026 03:11:51 +0800
X-QQ-mid: xmsmtpt1791659511t6k99pgsq
Message-ID: <tencent_B5ED8BAE1AA8B048FF6EBB8AD35DBF004306@qq.com>
X-QQ-XMAILINFO: MJf32pulH481gECSMZAjBqDvyJReaIMIbMmJa6PvR48zg9rLuRYbyDmiG/Ntnc
	 XyKCksAYXsCajtfAeMqtBHRPUuUuKduiGAGcJJ6W+tm4GtNVybPX0zXuKNEXmbtP8cNnguSq2t+c
	 mQQFr6xKnlxWzDVCmX0azO9OCULCpA9AvGQWGFPJb54030v+iCHNEWeF3AvJUGz4tuNRC1nkGhFr
	 2dBwZ55FJdXGZfGpxTauSWTHyLtufRNjMHBMfD/5dfz/9Z03r57jhYpYWSf505jKfcmqguHWf0dM
	 RV03pTYuti1+V1hAbzUUs1pNALqQz76idRAmJqz/1MP8bppl4dz/bXy2PmHRAjCjQkjuqzrgDYyQ
	 6dsLFvjtk5vmM4m3QqTbHXP8/HO39rVtiiWZIqh2VReMwc9Nkp/R2frtcIAQTTI/A2czQKetDJU2
	 St5r9duI4gf0mnwY8vRY+b3pmuj2JsiY/wNSWZRPSr6N0JJKDITDF+tj/TOtG0fld/KihhBZB52L
	 An+1iWgw4BrxOqz12fkU7KIAVFRa0+YfUNqxvr7CduYwMcvhBoKbLpJ9J05nmPhmttlP/SiebDTm
	 6ptA4Xb23nx0sbHlaQkAihxgKdOO5DJCMkwuDLQPP7QfLDTAxrt328pOfmYY9UiQrsa/RXWz9I9t
	 apCCbtxS3OM5TPp9aQEXESY2RPvI2f4FIBTvPJWsuGZmDTYOypZh2z9uIBpGBCpXXEkYby0ngDK7
	 G6v+5+XrLtn9A3K0IwnR2oXUj1JvQt71eveFqK7hd6w9MOzgmDTXlaxeQBArwbeVx36D7NVfy7rE
	 5xHma750RGXlO3j1dnQs4oahpOXNITt2xONXdf4ffH3f77leF8/sQnSlcSQP16fy2GEJlltcZvHs
	 HuZPX/j5whLdM6VS1eDB4Pz5UfvlK0Mjsh/+PbjaGLBr2uHejfrY2dDRD7aGlslJ7GlPzi83z7Cd
	 A8940QKFU4YiWnYUnVnEBahry/geQUp55U80oJ2c1dnenHGvWHPFVOqJYQIrzqORrnkdwMm9VV1U
	 Z2nXwDXv6mZbgyfyi7sHUKGPCmf50sa/BtT8CEcWnS3X47yF4Gg/X716cPe+g=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: =?UTF-8?q?=E6=98=9F=E6=B5=B7=E6=98=94=E6=B6=9F?= <starcyrene@qq.com>
To: linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	=?UTF-8?q?=E6=98=9F=E6=B5=B7=E6=98=94=E6=B6=9F?= <starcyrene@qq.com>
Subject: [PATCH] smb: client: add "noautomount" mount option to skip junction submounts
Date: Sun, 11 Oct 2026 03:11:51 +0800
X-OQ-MSGID: <20261010191151.242558-1-starcyrene@qq.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the cifs client walks into a name-surrogate reparse point that
points to a directory and that it cannot handle locally (a plain NTFS
junction, for instance), the dentry is marked DCACHE_NEED_AUTOMOUNT and
the next traversal creates a separate CIFS submount for it
(cifs_d_automount() -> cifs_do_automount()).

That machinery is what makes DFS referrals work, but for regular
junctions every traversal pays for a new superblock and SMB session and
leaves a mount behind.  Scanning a tree that contains many junctions
therefore floods the mount table: a single find(1) over a Windows share
whose package cache holds 2014 junctions created 2014 CIFS submounts,
which broke tools that enumerate mounts (a hosting panel rendering one
entry per mount stopped responding).  The submounts are also mostly
useless: reading through them typically fails with EACCES even when the
very same path is perfectly readable through the parent mount.

None of the existing options turn this off: "nodfs" only skips DFS
referral resolution (these junction submounts are not DFS), and
"reparse=" selects the format used when creating new reparse points,
not how existing ones are traversed.

Add a "noautomount" mount option.  When set, CIFS_FATTR_JUNCTION inodes
are not marked S_AUTOMOUNT, so junctions stay regular directories and
the SMB server resolves the reparse target on access - which Windows
does transparently for normal path traversal.  The default is off, so
behavior without the option is completely unchanged.  Note that the
option also disables automounting of DFS referrals, so it should not be
used on DFS mounts.

Tested against a Windows 11 SMB 3.1.1 server (workgroup) sharing C: and
D: with 2014 junctions (package cache) plus several system junctions
("Documents and Settings", "Start Menu/Programs", NVIDIA plugin dirs):

  - with "noautomount": deep tree scans create zero submounts, junction
    directories are listable through the parent mount, and sequential
    reads run at full speed (99 MB/s, identical to the unpatched
    module on the same hardware),
  - without it: behavior is identical to the unpatched module (one
    submount per junction, "CIFS: Attempting to mount" per entry).

Assisted-by: DeepSeek-V4-Flash
Signed-off-by: 星海昔涟 <starcyrene@qq.com>
---
 Documentation/admin-guide/cifs/usage.rst | 11 +++++++++++
 fs/smb/client/cifsfs.c                   |  2 ++
 fs/smb/client/fs_context.c               |  4 ++++
 fs/smb/client/fs_context.h               |  2 ++
 fs/smb/client/inode.c                    | 13 ++++++++++++-
 5 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cifs/usage.rst b/Documentation/admin-guide/cifs/usage.rst
index d989ae5..e4904ac 100644
--- a/Documentation/admin-guide/cifs/usage.rst
+++ b/Documentation/admin-guide/cifs/usage.rst
@@ -613,6 +613,17 @@ A partial list of the supported mount options follows:
 		server claims to support it.  This can help work around
 		a problem with parsing of DFS paths with Samba server
 		versions 3.0.24 and 3.0.25.
+  noautomount
+		Do not turn name-surrogate reparse points (e.g. Windows
+		NTFS junctions) pointing to a directory into submounts
+		on traversal.  Such entries are then exposed as regular
+		directories and the server resolves the reparse target
+		on access.  Without this option a deep scan of a tree
+		containing many junctions creates one CIFS submount per
+		junction, which floods the mount table with entries that
+		are usually useless and often not even listable.  Note
+		that this option also disables automounting of DFS
+		referrals, so it should not be used on DFS mounts.
   remount
 		remount the share (often used to change from ro to rw mounts
 		or vice versa)
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 149becc..db74faa 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -748,6 +748,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",nounix");
 	if (sbflags & CIFS_MOUNT_NO_DFS)
 		seq_puts(s, ",nodfs");
+	if (cifs_sb->ctx->noautomount)
+		seq_puts(s, ",noautomount");
 	if (sbflags & CIFS_MOUNT_POSIX_PATHS)
 		seq_puts(s, ",posixpaths");
 	if (sbflags & CIFS_MOUNT_SET_UID)
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b6d1e06..ff03b65 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -90,6 +90,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag("nomapchars", Opt_nomapchars),
 	fsparam_flag_no("sfu", Opt_sfu),
 	fsparam_flag("nodfs", Opt_nodfs),
+	fsparam_flag("noautomount", Opt_noautomount),
 	fsparam_flag_no("posixpaths", Opt_posixpaths),
 	fsparam_flag_no("unix", Opt_unix),
 	fsparam_flag_no("linux", Opt_unix),
@@ -1321,6 +1322,9 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_nodfs:
 		ctx->nodfs = 1;
 		break;
+	case Opt_noautomount:
+		ctx->noautomount = 1;
+		break;
 	case Opt_hard:
 		if (result.negated) {
 			if (ctx->retry == 1)
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index 0b64fcb..a0ed492 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -113,6 +113,7 @@ enum cifs_param {
 	Opt_nomapchars,
 	Opt_sfu,
 	Opt_nodfs,
+	Opt_noautomount,
 	Opt_posixpaths,
 	Opt_unix,
 	Opt_nocase,
@@ -277,6 +278,7 @@ struct smb3_fs_context {
 	bool mand_lock:1;  /* send mandatory not posix byte range lock reqs */
 	bool seal:1;       /* request transport encryption on share */
 	bool nodfs:1;      /* Do not request DFS, even if available */
+	bool noautomount:1; /* Do not automount junctions/reparse points */
 	bool local_lease:1; /* check leases only on local system, not remote */
 	bool noblocksnd:1;
 	bool noautotune:1;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 4661407..95e60f0 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -248,7 +248,18 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 	}
 	spin_unlock(&inode->i_lock);
 
-	if (fattr->cf_flags & CIFS_FATTR_JUNCTION)
+	/*
+	 * With the "noautomount" mount option, do not turn junctions and
+	 * other name-surrogate reparse points into submounts; keep them as
+	 * regular directories instead and let the server resolve the
+	 * reparse target on access.  Scanning a tree that contains many
+	 * junctions (e.g. a package cache) otherwise creates a submount per
+	 * junction and floods the mount table with entries that are useless
+	 * and often not even listable.  Default behavior is unchanged.
+	 * Note that the option also affects DFS referral mounts, so it
+	 * should not be used on DFS shares.
+	 */
+	if (fattr->cf_flags & CIFS_FATTR_JUNCTION && !cifs_sb->ctx->noautomount)
 		inode->i_flags |= S_AUTOMOUNT;
 	if (inode_state_read_once(inode) & I_NEW) {
 		cifs_set_netfs_context(inode);
-- 
2.53.0

