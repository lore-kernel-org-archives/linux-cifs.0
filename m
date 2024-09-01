Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F091E18132F;
	Sun,  1 Sep 2024 16:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207989; cv=none; b=gttj8wOM/x+zJ6fJA2Um6Wwz8S+0ktEr0DWlXsXF4O1mNhW+40rTlCmg31HpyqjQY5vUMhvL7GFRWYLME4SAaMkGLN11sx7ISPJaWHDjdB0GRc2IeDdb+jLJzKgNbEqT7RmrEZ061kfh5LqQd1U2nSYHeZGuyqjjdVXZQK5rc5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207989; c=relaxed/simple;
	bh=N/959gfYX00ziHtqMXnG549dcbHHpLZdLmkODtpAD8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlkmMArZawysg5C2e6LdOD2mYei/r78MjEP0Mi4tz7qHLFKvbHKIHEPagY6/eJwm1kgfdxH/XNBSVLokBvRVa+tqg/YrZ16HWyx687sGEn/K0b2WrtwhqAmKgg9Ii1/8d54KtCmlQs8Q5BlovCy63QNqJel3lJy/P5KLct4Mgt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp5D+XHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp5D+XHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7988EC4CEC3;
	Sun,  1 Sep 2024 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207988;
	bh=N/959gfYX00ziHtqMXnG549dcbHHpLZdLmkODtpAD8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp5D+XHtHnF3J9X6XnVIxGXlWjIvjWsJA98Od70cJUgs3JllvjttWqxtTKexuhonq
	 cbMRebALByB+JCfRM4XZimOwbjU1OL3gRv6DcxZEKD4ZYvNgfw30KVmiowd8/k5dzx
	 hxbPhyDmhnzrAc7aar8ZCinGFlP3h5ulr4KECRBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/93] cifs: Fix FALLOC_FL_PUNCH_HOLE support
Date: Sun,  1 Sep 2024 18:16:27 +0200
Message-ID: <20240901160808.870426806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 416871f4fb84bc96822562e654941d5625a25bf8 ]

The cifs filesystem doesn't quite emulate FALLOC_FL_PUNCH_HOLE correctly
(note that due to lack of protocol support, it can't actually implement it
directly).  Whilst it will (partially) invalidate dirty folios in the
pagecache, it doesn't write them back first, and so the EOF marker on the
server may be lower than inode->i_size.

This presents a problem, however, as if the punched hole invalidates the
tail of the locally cached dirty data, writeback won't know it needs to
move the EOF over to account for the hole punch (which isn't supposed to
move the EOF).  We could just write zeroes over the punched out region of
the pagecache and write that back - but this is supposed to be a
deallocatory operation.

Fix this by manually moving the EOF over on the server after the operation
if the hole punched would corrupt it.

Note that the FSCTL_SET_ZERO_DATA RPC and the setting of the EOF should
probably be compounded to stop a third party interfering (or, at least,
massively reduce the chance).

This was reproducible occasionally by using fsx with the following script:

	truncate 0x0 0x375e2 0x0
	punch_hole 0x2f6d3 0x6ab5 0x375e2
	truncate 0x0 0x3a71f 0x375e2
	mapread 0xee05 0xcf12 0x3a71f
	write 0x2078e 0x5604 0x3a71f
	write 0x3ebdf 0x1421 0x3a71f *
	punch_hole 0x379d0 0x8630 0x40000 *
	mapread 0x2aaa2 0x85b 0x40000
	fallocate 0x1b401 0x9ada 0x40000
	read 0x15f2 0x7d32 0x40000
	read 0x32f37 0x7a3b 0x40000 *

The second "write" should extend the EOF to 0x40000, and the "punch_hole"
should operate inside of that - but that depends on whether the VM gets in
and writes back the data first.  If it doesn't, the file ends up 0x3a71f in
size, not 0x40000.

Fixes: 31742c5a3317 ("enable fallocate punch hole ("fallocate -p") for SMB3")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 66cfce456263b..012d6ec12a691 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3251,6 +3251,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsFileInfo *cfile = file->private_data;
 	struct file_zero_data_information fsctl_buf;
+	unsigned long long end = offset + len, i_size, remote_i_size;
 	long rc;
 	unsigned int xid;
 	__u8 set_sparse = 1;
@@ -3282,6 +3283,27 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 			(char *)&fsctl_buf,
 			sizeof(struct file_zero_data_information),
 			CIFSMaxBufSize, NULL, NULL);
+
+	if (rc)
+		goto unlock;
+
+	/* If there's dirty data in the buffer that would extend the EOF if it
+	 * were written, then we need to move the EOF marker over to the lower
+	 * of the high end of the hole and the proposed EOF.  The problem is
+	 * that we locally hole-punch the tail of the dirty data, the proposed
+	 * EOF update will end up in the wrong place.
+	 */
+	i_size = i_size_read(inode);
+	remote_i_size = netfs_inode(inode)->remote_i_size;
+	if (end > remote_i_size && i_size > remote_i_size) {
+		unsigned long long extend_to = umin(end, i_size);
+		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
+				  cfile->fid.volatile_fid, cfile->pid, extend_to);
+		if (rc >= 0)
+			netfs_inode(inode)->remote_i_size = extend_to;
+	}
+
+unlock:
 	filemap_invalidate_unlock(inode->i_mapping);
 out:
 	inode_unlock(inode);
-- 
2.43.0



