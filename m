Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D5F274B37;
	Mon, 24 Nov 2025 20:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764014447; cv=none; b=aw6wrjVF5LUc8BWYzaalAAPmpWuoZv0KP4KMhUd/+aooL9dNtVjRLUk5qjolxhwPF71cd05w97aFfOHyQjdHLSFeFjbmrTo73xn+C4bxJzac4nkMajbWPt8YiwEILS6tjalvCI8U8t147Eo88I1ZaC5mG7W80ieQ8G1W9kZ2Zg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764014447; c=relaxed/simple;
	bh=ysO5pl/6P4fnV/oI03gvDptSCv2C+WfgIpZ42KwbVIk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SK9CXUsvQNJm+nxeFcb+4amGqc1JzCi+JJU/6oA5MKTWLFvYAzEtrHS8EoFB9kIBL+aYtJ4kRfcEkmaLa7TW5CKC8z44YWjfH3wvhrHSpjvkNhBG1/q2oH81fZJYvUYufMBI1dz7m5UsCztG1BzLVc34+yF2t2FzVMxwLEooKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=g/FMdIYt; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="g/FMdIYt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ialKFkSCnjSh2MY2cSEPjRVGrwC+bylrASTkFM64/oI=; b=g/FMdIYtofO2P6E5Rmhdn8oOWO
	pN93xK4/tsrq3qolr8ZJ2HxAwMYCM7pv8aEcSj1TYlIEFQpAcbPP4eFbABwsFHv/F7BsBKILorxnO
	ClRA9iCXS+EzXgxYDJu3n+wis6K/Pbw8zotHO98S4PJLSe/IYnftHrcocnz/3p4H2Xng2X+kNwtaH
	M598wPTUbUQn6tTWSCbmAV3eNYZFHVMjhF++4/7vlNFsNtYRRtr73EuYGFUsQ027HasvI7EFx9t1o
	T9N3QAkmZCFE6K/vDpNH8/hzxVKWXyO+yFzThSjNks8glwafPyNER7lPV97VEUiSccyv94RzV65DF
	w66RudmQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1vNcjj-00000000Qv4-3d5V;
	Mon, 24 Nov 2025 17:00:36 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Jay Shin <jaeshin@redhat.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix memory leak in cifs_construct_tcon()
Date: Mon, 24 Nov 2025 17:00:36 -0300
Message-ID: <20251124200036.1582605-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When having a multiuser mount with domain= specified and using
cifscreds, cifs_set_cifscreds() will end up setting @ctx->domainname,
so it needs to be freed before leaving cifs_construct_tcon().

This fixes the following memory leak reported by kmemleak:

  mount.cifs //srv/share /mnt -o domain=ZELDA,multiuser,...
  su - testuser
  cifscreds add -d ZELDA -u testuser
  ...
  ls /mnt/1
  ...
  umount /mnt
  echo scan > /sys/kernel/debug/kmemleak
  cat /sys/kernel/debug/kmemleak
  unreferenced object 0xffff8881203c3f08 (size 8):
    comm "ls", pid 5060, jiffies 4307222943
    hex dump (first 8 bytes):
      5a 45 4c 44 41 00 cc cc                          ZELDA...
    backtrace (crc d109a8cf):
      __kmalloc_node_track_caller_noprof+0x572/0x710
      kstrdup+0x3a/0x70
      cifs_sb_tlink+0x1209/0x1770 [cifs]
      cifs_get_fattr+0xe1/0xf50 [cifs]
      cifs_get_inode_info+0xb5/0x240 [cifs]
      cifs_revalidate_dentry_attr+0x2d1/0x470 [cifs]
      cifs_getattr+0x28e/0x450 [cifs]
      vfs_getattr_nosec+0x126/0x180
      vfs_statx+0xf6/0x220
      do_statx+0xab/0x110
      __x64_sys_statx+0xd5/0x130
      do_syscall_64+0xbb/0x380
      entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: f2aee329a68f ("cifs: set domainName when a domain-key is used in multiuser")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Jay Shin <jaeshin@redhat.com>
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 55cb4b0cbd48..2f94d93b95e9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4451,6 +4451,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 
 out:
 	kfree(ctx->username);
+	kfree(ctx->domainname);
 	kfree_sensitive(ctx->password);
 	kfree(origin_fullpath);
 	kfree(ctx);
-- 
2.51.1

