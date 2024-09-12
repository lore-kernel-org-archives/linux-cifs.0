Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23601A305E;
	Thu, 12 Sep 2024 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142761; cv=none; b=dNqhJ+WiD8XG98jVS27Y1eKJOcOZRu8ct0UCpjLsSJ4yLMEj3whNPUYxW9dekMJqunk6SwwA7qx3fmL8fww8rB5pgIo+9Sid6u7UAtqGZPstlJYH9NnuYvS7U6KPhfA+GttvCj5N9TN2RtHrj7b/XDRjACwh7g+/8Mfpax1nfaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142761; c=relaxed/simple;
	bh=Bx2ZfJxux6Lf9+D4Cr93MpDM5P+eKzzLZZK74b1rWys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ljZ57Th2kizwYjWo42/Vvy9+99lQbcD/+G/8XxKjRonICoNkq5IWUVAcp+E5iySIaQ3eIfMoM2Mgb82OY2Knq4R76OrjF+wboYZwNRT66ATWLUd+HzOm/noQMwWeKotOsIvYQNe+5EykJ+G597QpYTg2e8e2x4XeCMMpYd6Yej8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M4EMxvBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M4EMxvBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0844BC4CED1;
	Thu, 12 Sep 2024 12:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142761;
	bh=Bx2ZfJxux6Lf9+D4Cr93MpDM5P+eKzzLZZK74b1rWys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4EMxvBjYRwd1SfkXm6rirhd4QsPwgr3/2E2vsZgdBTzvA66AtQ/VptkHMWRtDNIv
	 15G3sfljgrw0gdf5QF3CoPhXPf+H6X17fub4XUr0e1eyDors/d/VR4fPYzNOdQjQC9
	 CBeeFZdUvASd2w/StgeoNn1CWSIhFL0nFBVR/QRhiMtmomx9ZZ6U0TFL0mrNmW0XHR
	 sIOiiqY3FBPQRd7Mb2UgYMmA+7YBb6RrzqkVf9p4grcliV588yOnW32bKJ/Y77skoX
	 tuaR/6HqaYjuEyQIPZVCg+FhjsiMvbBjPeW0gkOIGtW2v4TMpU24GJW4O6ydhI1LIi
	 sC4c+VRTAhl+g==
Received: by pali.im (Postfix)
	id DC2E0C56; Thu, 12 Sep 2024 14:05:55 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special files
Date: Thu, 12 Sep 2024 14:05:47 +0200
Message-Id: <20240912120548.15877-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
References: <20240912120548.15877-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU-style fifo is empty file with system attribute set. This format is used
by old Microsoft POSIX subsystem and later also by OpenNT/Interix subsystem
(which replaced Microsoft POSIX subsystem and is part of Microsoft SFU).

SFU-style socket is file which has system attribute set and file content is
one zero byte. This format was introduced in Interix 3.0 subsystem, as part
of the Microsoft SFU 3.0 and is used also by all later versions. Previous
versions had no UNIX domain socket support.

Currently when sfu mount option is specified then CIFS creates fifo and
socket special files with some strange LnxSOCK or LnxFIFO content which is
not compatible with Microsoft SFU and neither recognized by other SMB
implementations which have some SFU support, including older Linux cifs
implementations.

So when sfu mount option is specified, create all fifo and socket special
files compatible with SFU format to achieve SFU interop, as it is expected
by sfu mount option.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c |  8 ++++----
 fs/smb/client/smb1ops.c |  2 +-
 fs/smb/client/smb2ops.c | 29 +++++++++++++++++++----------
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index cfae2e918209..0ffc45aa5e2c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1076,8 +1076,8 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
 	pSMB->Mode = cpu_to_le16(access_flags_to_smbopen_mode(access_flags));
 	pSMB->Mode |= cpu_to_le16(0x40); /* deny none */
-	/* set file as system file if special file such
-	   as fifo and server expecting SFU style and
+	/* set file as system file if special file such as fifo,
+	 * socket, char or block and server expecting SFU style and
 	   no Unix extensions */
 
 	if (create_options & CREATE_OPTION_SPECIAL)
@@ -1193,8 +1193,8 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 	req->AllocationSize = 0;
 
 	/*
-	 * Set file as system file if special file such as fifo and server
-	 * expecting SFU style and no Unix extensions.
+	 * Set file as system file if special file such as fifo, socket, char
+	 * or block and server expecting SFU style and no Unix extensions.
 	 */
 	if (create_options & CREATE_OPTION_SPECIAL)
 		req->FileAttributes = cpu_to_le32(ATTR_SYSTEM);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e1f2feb56f45..e03c91a49650 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1078,7 +1078,7 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
 	 * SFU emulation should work with all servers, but only
-	 * supports block and char device (no socket & fifo),
+	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9c2d065d3cc4..9e90672caf60 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5066,26 +5066,32 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 	struct cifs_fid fid;
 	unsigned int bytes_written;
 	struct win_dev pdev = {};
+	size_t pdev_len = 0;
 	struct kvec iov[2];
 	__u32 oplock = server->oplocks ? REQ_OPLOCK : 0;
 	int rc;
 
 	switch (mode & S_IFMT) {
 	case S_IFCHR:
+		pdev_len = sizeof(pdev);
 		memcpy(pdev.type, "IntxCHR\0", 8);
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
 		break;
 	case S_IFBLK:
+		pdev_len = sizeof(pdev);
 		memcpy(pdev.type, "IntxBLK\0", 8);
 		pdev.major = cpu_to_le64(MAJOR(dev));
 		pdev.minor = cpu_to_le64(MINOR(dev));
 		break;
 	case S_IFSOCK:
-		strscpy(pdev.type, "LnxSOCK");
+		/* SFU socket is system file with one zero byte */
+		pdev_len = 1;
+		pdev.type[0] = '\0';
 		break;
 	case S_IFIFO:
-		strscpy(pdev.type, "LnxFIFO");
+		/* SFU fifo is system file which is empty */
+		pdev_len = 0;
 		break;
 	default:
 		return -EPERM;
@@ -5100,14 +5106,17 @@ static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 	if (rc)
 		return rc;
 
-	io_parms.pid = current->tgid;
-	io_parms.tcon = tcon;
-	io_parms.length = sizeof(pdev);
-	iov[1].iov_base = &pdev;
-	iov[1].iov_len = sizeof(pdev);
+	if (pdev_len > 0) {
+		io_parms.pid = current->tgid;
+		io_parms.tcon = tcon;
+		io_parms.length = pdev_len;
+		iov[1].iov_base = &pdev;
+		iov[1].iov_len = pdev_len;
+
+		rc = server->ops->sync_write(xid, &fid, &io_parms,
+					     &bytes_written, iov, 1);
+	}
 
-	rc = server->ops->sync_write(xid, &fid, &io_parms,
-				     &bytes_written, iov, 1);
 	server->ops->close(xid, tcon, &fid);
 	return rc;
 }
@@ -5149,7 +5158,7 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
 	 * SFU emulation should work with all servers, but only
-	 * supports block and char device (no socket & fifo),
+	 * supports block and char device, socket & fifo,
 	 * and was used by default in earlier versions of Windows
 	 */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
-- 
2.20.1

