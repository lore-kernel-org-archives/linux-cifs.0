Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B685318C340;
	Tue, 10 Sep 2024 10:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964196; cv=none; b=OCC72nOSt1OowSSPDGQnwxyM5BEpI1YWlmBRaYYuCX12J1QuzyutjnMvMOqbOfVAX9dFZrLpwZrvfJPrTp2gg0iJxnFn1Q9PByR/fkOf6fuSoOJVv/0kaehCjAnlsM1T+kE91wddyLLR/Byc3R3mVIQc3suDjSDqUYpxS9zyr00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964196; c=relaxed/simple;
	bh=CSPE2hltHc3s9Iley0fLgbkpoaP9tJsDBPRnzMOeqNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewPxxD5KOYPQlUnGNT+ShnJ/MaVYChqsOpV47z6VjPdiONvdynV7++eq1eDT+GxgWNtIEk4CuYgUs9fIdyKx7ucwHSCUy/yrYL4OdEek0O6UAVTDl/pTp8VckZ3mgYCn95Buh3c0sy2KBhnQaPhQjqNzeTH9HRY4cOLibDasz/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPrkkSXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPrkkSXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E6BC4CEC6;
	Tue, 10 Sep 2024 10:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964196;
	bh=CSPE2hltHc3s9Iley0fLgbkpoaP9tJsDBPRnzMOeqNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPrkkSXyy1if+pU/kg2cSdeg3qROrp0kZyfCg2Td21fl7kJJgY82KkLwndAPJxtrN
	 JfqUPElHewR/u7DMSIacaiRLhKiOgfnPdDLf1C5S2YutIIw3l67lJdZ4AUVaX26JWk
	 d3fQR4nb906Ma5vQ+p73ppG/IMMqCmF7Jw09IdQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
	Pavel Shilovsky <pshilov@microsoft.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-mm@kvack.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/269] cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region
Date: Tue, 10 Sep 2024 11:31:28 +0200
Message-ID: <20240910092611.813779531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

[ Upstream commit 91d1dfae464987aaf6c79ff51d8674880fb3be77 ]

Under certain conditions, the range to be cleared by FALLOC_FL_ZERO_RANGE
may only be buffered locally and not yet have been flushed to the server.
For example:

	xfs_io -f -t -c "pwrite -S 0x41 0 4k" \
		     -c "pwrite -S 0x42 4k 4k" \
		     -c "fzero 0 4k" \
		     -c "pread -v 0 8k" /xfstest.test/foo

will write two 4KiB blocks of data, which get buffered in the pagecache,
and then fallocate() is used to clear the first 4KiB block on the server -
but we don't flush the data first, which means the EOF position on the
server is wrong, and so the FSCTL_SET_ZERO_DATA RPC fails (and xfs_io
ignores the error), but then when we try to read it, we see the old data.

Fix this by preflushing any part of the target region that above the
server's idea of the EOF position to force the server to update its EOF
position.

Note, however, that we don't want to simply expand the file by moving the
EOF before doing the FSCTL_SET_ZERO_DATA[*] because someone else might see
the zeroed region or if the RPC fails we then have to try to clean it up or
risk getting corruption.

[*] And we have to move the EOF first otherwise FSCTL_SET_ZERO_DATA won't
do what we want.

This fixes the generic/008 xfstest.

[!] Note: A better way to do this might be to split the operation into two
parts: we only do FSCTL_SET_ZERO_DATA for the part of the range below the
server's EOF and then, if that worked, invalidate the buffered pages for the
part above the range.

Fixes: 6b69040247e1 ("cifs/smb3: Fix data inconsistent when zero file range")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <stfrench@microsoft.com>
cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
cc: Pavel Shilovsky <pshilov@microsoft.com>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: linux-mm@kvack.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 012d6ec12a69..acd5d7d79352 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3186,13 +3186,15 @@ static long smb3_zero_data(struct file *file, struct cifs_tcon *tcon,
 }
 
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
-			    loff_t offset, loff_t len, bool keep_size)
+			    unsigned long long offset, unsigned long long len,
+			    bool keep_size)
 {
 	struct cifs_ses *ses = tcon->ses;
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	unsigned long long new_size;
+	struct netfs_inode *ictx = netfs_inode(inode);
+	unsigned long long i_size, new_size, remote_size;
 	long rc;
 	unsigned int xid;
 
@@ -3204,6 +3206,16 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	inode_lock(inode);
 	filemap_invalidate_lock(inode->i_mapping);
 
+	i_size = i_size_read(inode);
+	remote_size = ictx->remote_i_size;
+	if (offset + len >= remote_size && offset < i_size) {
+		unsigned long long top = umin(offset + len, i_size);
+
+		rc = filemap_write_and_wait_range(inode->i_mapping, offset, top - 1);
+		if (rc < 0)
+			goto zero_range_exit;
+	}
+
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
-- 
2.43.0



