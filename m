Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AD119885F;
	Thu,  6 Jun 2024 14:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683042; cv=none; b=OAn0ojc7h2jTRUH7L+9+ZpYyuKRoWq+u+uyXf6A05m9w9cYHVPLBzB/+UHDrA9PaW6ZT6bVxDNOt5KvWg1sm+MWyBr84ddxtdsCI5Ytxh9s0rF67B28Md0qy9kGKEDaoMsdAQ7va05ZNPmQKwYXCNKlncHlpX/1OQwwANglvvd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683042; c=relaxed/simple;
	bh=1bl/YBnM4NrsMyWpLOZWjdYDE2E+LJUEceW+1HjrIXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLbO75GnzZXFxshSrDPCk0qqs2a5TvjgmBmA0IwmeBzC6C1+Nj0ePDd7mXLEnmMfcG3a7N/sVIQzcBFDTfrDYxk6jhFKXmlfoLcflBP9kefg5OHOlGshWRCVpLHpUu9pWw64eobM8nPKJiH0PZ4o6sh/RJaKYiDnpm2GRWB9LqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXabhfJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXabhfJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5243C32781;
	Thu,  6 Jun 2024 14:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683042;
	bh=1bl/YBnM4NrsMyWpLOZWjdYDE2E+LJUEceW+1HjrIXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXabhfJVZBuP7C7MKhPVfXkTD2DVjipNrqMMPnpWvI6SiVJEFl5hDer6GofSJAgDM
	 PMjPTcm+NkpSG7GAuACAoe+g+vzMFW7sAWigOGglHpXE5818O4Re9CZL0jrNn+ku73
	 5m569DVchCKHII2vhIw6X7mQerKVzC5Al0xb+DvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 279/374] cifs: Fix missing set of remote_i_size
Date: Thu,  6 Jun 2024 16:04:18 +0200
Message-ID: <20240606131701.244247051@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 93a43155127fec0f8cc942d63b76668c2f8f69fa ]

Occasionally, the generic/001 xfstest will fail indicating corruption in
one of the copy chains when run on cifs against a server that supports
FSCTL_DUPLICATE_EXTENTS_TO_FILE (eg. Samba with a share on btrfs).  The
problem is that the remote_i_size value isn't updated by cifs_setsize()
when called by smb2_duplicate_extents(), but i_size *is*.

This may cause cifs_remap_file_range() to then skip the bit after calling
->duplicate_extents() that sets sizes.

Fix this by calling netfs_resize_file() in smb2_duplicate_extents() before
calling cifs_setsize() to set i_size.

This means we don't then need to call netfs_resize_file() upon return from
->duplicate_extents(), but we also fix the test to compare against the pre-dup
inode size.

[Note that this goes back before the addition of remote_i_size with the
netfs_inode struct.  It should probably have been setting cifsi->server_eof
previously.]

Fixes: cfc63fc8126a ("smb3: fix cached file size problems in duplicate extents (reflink)")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c  | 6 +++---
 fs/smb/client/smb2ops.c | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c8449f43856c5..4fb21affe4e11 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1277,7 +1277,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	struct cifsFileInfo *smb_file_src = src_file->private_data;
 	struct cifsFileInfo *smb_file_target = dst_file->private_data;
 	struct cifs_tcon *target_tcon, *src_tcon;
-	unsigned long long destend, fstart, fend, new_size;
+	unsigned long long destend, fstart, fend, old_size, new_size;
 	unsigned int xid;
 	int rc;
 
@@ -1344,6 +1344,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 		goto unlock;
 	if (fend > target_cifsi->netfs.zero_point)
 		target_cifsi->netfs.zero_point = fend + 1;
+	old_size = target_cifsi->netfs.remote_i_size;
 
 	/* Discard all the folios that overlap the destination region. */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
@@ -1356,9 +1357,8 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (target_tcon->ses->server->ops->duplicate_extents) {
 		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-		if (rc == 0 && new_size > i_size_read(target_inode)) {
+		if (rc == 0 && new_size > old_size) {
 			truncate_setsize(target_inode, new_size);
-			netfs_resize_file(&target_cifsi->netfs, new_size, true);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);
 		}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 28f0b7d19d534..6fea0aed43461 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2028,6 +2028,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		 * size will be queried on next revalidate, but it is important
 		 * to make sure that file's cached size is updated immediately
 		 */
+		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
 		cifs_setsize(inode, dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
-- 
2.43.0



