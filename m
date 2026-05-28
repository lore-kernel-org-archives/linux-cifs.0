Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892B13164B7;
	Thu, 28 May 2026 20:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999013; cv=none; b=oc+QKysxbVtWwx9JN4OFa71dlswgOsK+ZAHiIZzMyHrGbFBwxebinSdEYtrs3Nttx5kRHn7bgyUuK729B165WUo1XaWvZr0nkAArdMwQewa4SLnydeoC9o7n1vwKAc0a3psuWehooaNU3MyHlewCc/cKD/PaEwh3734c3HJpgtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999013; c=relaxed/simple;
	bh=SwhUBopI2lXqvF+V7mmyDuOIgNPdMxv1+uzyfs57tNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odi6j2OZi8RDT/rKoE8cKnYke1jtlZewycUv/LYtKMOdcN93VRc/lzViYzAk2gMZuEiQ60SnjFY+tDM2rNfKX+9wV6MhSrRdwORROUFnmN+HFGZjWnoZMQQwHk0+8jmQ7W0NUmWh0p2jGt2sZQwjEs0X362veQlywYUwXSJdb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8n5iZf9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8n5iZf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45441F000E9;
	Thu, 28 May 2026 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999012;
	bh=GzB/+PDPprjImgng6l/tPsxCXzL0G64HMgBFxRY2kWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8n5iZf9nh0uEvB+fM6yNASXTJTCCPBGcTUcKJ2ezkkzKVVBpFPk8zgQlr/I6Cacb
	 ltFaUsYQmoR3bRRYdikI6vt/fU0+SO0Xo6g1f1UvNGHyNfQuT5rHIY4kxUnn0tGPrr
	 pd6h5nQVAithXrI1Azh2jSYmwU9CHHrZCwswC+Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 377/461] cifs: Fix undefined variables
Date: Thu, 28 May 2026 21:48:26 +0200
Message-ID: <20260528194658.363504094@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 8cf8b5ae8e093132b0dce0a932af10c9ef077936 ]

Fix a couple of undefined variables introduced by the patch to fix tearing
on ->remote_i_size and ->zero_point.  For some reason, make W=1 with gcc
doesn't give undefined variable warnings (but clang does).

Fixes: 2c8f4742bb76 ("netfs: Fix potential for tearing in ->remote_i_size and ->zero_point")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605031459.eX5UbO3K-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605021450.ca5QGqLH-lkp@intel.com/
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christian Brauner <brauner@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index db6062dcbb3ec..386b0d43f064f 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1339,7 +1339,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	struct cifsFileInfo *smb_file_src = src_file->private_data;
 	struct cifsFileInfo *smb_file_target = dst_file->private_data;
 	struct cifs_tcon *target_tcon, *src_tcon;
-	unsigned long long i_size, old_size, new_size, zero_point;
+	unsigned long long i_size, new_size;
 	unsigned long long destend, fstart, fend;
 	unsigned int xid;
 	int rc;
@@ -1407,7 +1407,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 		goto unlock;
 
 	spin_lock(&target_inode->i_lock);
-	if (fend > zero_point)
+	if (fend > target_cifsi->netfs._zero_point)
 		netfs_write_zero_point(target_inode, fend + 1);
 	i_size = target_inode->i_size;
 	spin_unlock(&target_inode->i_lock);
@@ -1422,7 +1422,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	if (target_tcon->ses->server->ops->duplicate_extents) {
 		rc = target_tcon->ses->server->ops->duplicate_extents(xid,
 			smb_file_src, smb_file_target, off, len, destoff);
-		if (rc == 0 && new_size > old_size) {
+		if (rc == 0 && new_size > i_size) {
 			truncate_setsize(target_inode, new_size);
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);
-- 
2.53.0



