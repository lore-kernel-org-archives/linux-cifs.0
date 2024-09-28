Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DCF189502;
	Sat, 28 Sep 2024 22:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560850; cv=none; b=oy79w4V0LVyABm34SKnyg1DwR1ApwkZ81teg5GKbJbB0t+uCsclP5au/xt0tUjIvGNUkbLZ1z8OTYSaJF2LfCyAAe9p56z/DYRHJjCbq/jAh0KaRuWQ4hX2h26xTKXVsCKOYfB+gAmHBqr8en7o8eB0m2wUZMQfk7pkSFyZoka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560850; c=relaxed/simple;
	bh=Un5y3IwAsPJjjVsTLoX+SCgsvxWycXjRtC2sfJf3T0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jp4MnHOsdP2SlGDnsh1M1+DP3vn1/BNeD5jVX6nCuEZR7H/g37SpZV+FacUqIukOYoxwop/B4uY2gbOuYelImYFBD5m8LNcWJKMTqf3aJwxCupSlvagASreM6dU8sWcJXrr8FoMbQSWViqt1wzpe8yPxC4UC5+rv6ge5a7+v7Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwXOp17E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwXOp17E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0045C4CECE;
	Sat, 28 Sep 2024 22:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560850;
	bh=Un5y3IwAsPJjjVsTLoX+SCgsvxWycXjRtC2sfJf3T0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwXOp17EpF/sGoDvIDyxR9/p5sbUIzz13D5DJ0FXGqo8waEgwMy5pHjwsvS6Gg8GN
	 5tNpGLQsukYm18B97LrtLvEAYUhZdSl9nJ5ZnYdckqg/UPtlne+fELfKk1+9rJMzqC
	 /MkrWLEWWnxmwi1wgTqQyh0rUzluQDWfM/9XlJCdNXeM0Z/+iA7Uzh2N57/QvGuSEz
	 yqr2+K1MUpEEGGN8qZHn3dsNxw/oALrHPZkZrAb4yLvVoEbgTYZbKDjxpQ/Gh+YPwe
	 bTUFZflfl1ZoVTdG/5fdx8Qp1vnUkxiC3cpmwU6KchHpSzhv/O56wz4OHTqFHBRQCP
	 xUFkJE+RK4rHQ==
Received: by pali.im (Postfix)
	id D9305CB5; Sun, 29 Sep 2024 00:00:41 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] cifs: Rename posix to nfs in parse_reparse_posix() and reparse_posix_data
Date: Sat, 28 Sep 2024 23:59:48 +0200
Message-Id: <20240928215948.4494-9-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-1-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This function parses NFS-style reparse points, which are used only by
Windows NFS server since Windows Server 2012 version. This style of special
files is not understood by Microsoft POSIX / Interix / SFU / SUA subsystems.

So make it clear that parse_reparse_posix() function and reparse_posix_data
structure are not POSIX general, but rather NFS specific.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h |  2 +-
 fs/smb/client/cifspdu.h  |  2 +-
 fs/smb/client/reparse.c  | 14 +++++++-------
 fs/smb/client/reparse.h  |  2 +-
 fs/smb/common/smb2pdu.h  |  2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 9eae8649f90c..119537e98f77 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -223,7 +223,7 @@ struct cifs_open_info_data {
 		__u32 tag;
 		union {
 			struct reparse_data_buffer *buf;
-			struct reparse_posix_data *posix;
+			struct reparse_nfs_data *nfs;
 		};
 	} reparse;
 	struct {
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index c3b6263060b0..fefd7e5eb170 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1506,7 +1506,7 @@ struct reparse_symlink_data {
 #define NFS_SPECFILE_BLK	0x00000000004B4C42
 #define NFS_SPECFILE_FIFO	0x000000004F464946
 #define NFS_SPECFILE_SOCK	0x000000004B434F53
-struct reparse_posix_data {
+struct reparse_nfs_data {
 	__le32	ReparseTag;
 	__le16	ReparseDataLength;
 	__u16	Reserved;
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 35e8f2e18530..a23ea2f78c09 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -81,7 +81,7 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	return rc;
 }
 
-static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
+static int nfs_set_reparse_buf(struct reparse_nfs_data *buf,
 			       mode_t mode, dev_t dev,
 			       struct kvec *iov)
 {
@@ -120,20 +120,20 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 		     const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_open_info_data data;
-	struct reparse_posix_data *p;
+	struct reparse_nfs_data *p;
 	struct inode *new;
 	struct kvec iov;
 	__u8 buf[sizeof(*p) + sizeof(__le64)];
 	int rc;
 
-	p = (struct reparse_posix_data *)buf;
+	p = (struct reparse_nfs_data *)buf;
 	rc = nfs_set_reparse_buf(p, mode, dev, &iov);
 	if (rc)
 		return rc;
 
 	data = (struct cifs_open_info_data) {
 		.reparse_point = true,
-		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
+		.reparse = { .tag = IO_REPARSE_TAG_NFS, .nfs = p, },
 	};
 
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
@@ -313,7 +313,7 @@ int smb2_mknod_reparse(unsigned int xid, struct inode *inode,
 }
 
 /* See MS-FSCC 2.1.2.6 for the 'NFS' style reparse tags */
-static int parse_reparse_posix(struct reparse_posix_data *buf,
+static int parse_reparse_nfs(struct reparse_nfs_data *buf,
 			       struct cifs_sb_info *cifs_sb,
 			       struct cifs_open_info_data *data)
 {
@@ -414,7 +414,7 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	/* See MS-FSCC 2.1.2 */
 	switch (le32_to_cpu(buf->ReparseTag)) {
 	case IO_REPARSE_TAG_NFS:
-		return parse_reparse_posix((struct reparse_posix_data *)buf,
+		return parse_reparse_nfs((struct reparse_nfs_data *)buf,
 					   cifs_sb, data);
 	case IO_REPARSE_TAG_SYMLINK:
 		return parse_reparse_symlink(
@@ -507,7 +507,7 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 				 struct cifs_fattr *fattr,
 				 struct cifs_open_info_data *data)
 {
-	struct reparse_posix_data *buf = data->reparse.posix;
+	struct reparse_nfs_data *buf = data->reparse.nfs;
 	u32 tag = data->reparse.tag;
 
 	if (tag == IO_REPARSE_TAG_NFS && buf) {
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 5be54878265e..2a91f64de557 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -18,7 +18,7 @@
  */
 #define IO_REPARSE_TAG_INTERNAL ((__u32)~0U)
 
-static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
+static inline dev_t reparse_nfs_mkdev(struct reparse_nfs_data *buf)
 {
 	u32 major, minor;
 
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c769f9dbc0b4..0e77a4c0145a 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1550,7 +1550,7 @@ struct reparse_symlink_data_buffer {
 	__u8	PathBuffer[]; /* Variable Length */
 } __packed;
 
-/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
+/* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_nfs_data */
 
 struct validate_negotiate_info_req {
 	__le32 Capabilities;
-- 
2.20.1

