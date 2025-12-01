Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AB6207A0B;
	Mon,  1 Dec 2025 22:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764627900; cv=none; b=Luk9Y3OVm9SKUNTSlRwV4NynJxfzjJ3uqeUXf9AJ9Uywic9HvEAoNFp7OOgnqPb7bv59S8uwXOac5YwyFJVULdCt9Wovihn7+TSy8/j0m4KZBXxyfp+dDagFBFrs1jBXF9gloDSIcR5guMAhRCSC9oPJj+c7KR18DrP7JeOKXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764627900; c=relaxed/simple;
	bh=LjiXOvEuoYChsYdCrGieOP2zkx/TDmNC8xATxaxPeR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm8BFjFIb4bOEeOGIh/8AntYJB2fDqqtl04PS4E3ToAupXUexpfbw9uCHzWjjr8TqnzZmZNw0BBslP6uHdg+KJJcN9NL1p7P/q0PYHEgxkMzmLlQ51abQelC8BsgZrLQzTd1Ib9fvHXtkJinaDqATx9xZrPglQzxPbdzw2KgXh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbX3s+H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbX3s+H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FABBC4CEF1;
	Mon,  1 Dec 2025 22:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764627899;
	bh=LjiXOvEuoYChsYdCrGieOP2zkx/TDmNC8xATxaxPeR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbX3s+H+sK464N6IL6114RU8eDk922KnTyVqz8QQq/4c8ksGsVts0Kci+M0xIAIOB
	 xESViSoWKKxvuHSZggK3ygPLlKasNiEC9s9h31vLYgeTf5LdeXLmYUOj2Si4wnRsZz
	 M7yndkdiML2/p76Rl9/7LPrq/mtB3FvGjHx6Q0m9ZMwus1ehSfOTAR1LJvQdl1wDHK
	 JHSB0dNoziwJIWhhMVwygR/sKl4FjKlcAi1pr56+SQPGhdPR01ojjMOLX70nTEHxIB
	 3xqoPD6bmT8vnjtFEde9vCRkWkhvLDxs6lD0w1uORYwMa0wvKaX2H+EnQVePF49y9z
	 +D1+fW38BtrLQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10.y] smb: client: fix memory leak in cifs_construct_tcon()
Date: Mon,  1 Dec 2025 17:24:51 -0500
Message-ID: <20251201222451.1290758-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025120144-dismiss-quilt-863b@gregkh>
References: <2025120144-dismiss-quilt-863b@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 3184b6a5a24ec9ee74087b2a550476f386df7dc2 ]

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
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Jay Shin <jaeshin@redhat.com>
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Different path + ctx -> vol_info ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5fc418f9210a5..29da38dfccdb9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5162,6 +5162,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 
 out:
 	kfree(vol_info->username);
+	kfree(vol_info->domainname);
 	kfree_sensitive(vol_info->password);
 	kfree(vol_info);
 
-- 
2.51.0

