Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13552882D0;
	Mon,  1 Dec 2025 22:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764626957; cv=none; b=qy31Z2s7lB/a7ngNhJIKFwnMAF1QXa8MRIFwGD68dTcelMALtM6lIBacDI4zjNfmezC4GXhExO2nqbjfEn23flFVkrSW+7AGBgh81W1e379IGZgf8CDjsZZmpSW/Aul/B1Zh8EVID/SBxY42GWVDKieUvArH3f1Bs6tGS5zogMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764626957; c=relaxed/simple;
	bh=Js3ghnFZJ7YTPR0bCSccW+BMGxnMoOTm8M8mf0LkAOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W680d2Yjs20w5BT3lWRl+geGWJCFiADLx5gkU6etAQMNBb4+BB5mu/KWtx6OvntPNiGltC6/JPaVfCP0JTxy6Tv8CqKcOAMTP2FW8QyFvHec88LpvkEW2MAoSZv79NIAySvmaOLY3LCTMhIwObxR3Iu7x7x8NhvxCAFHcZbourk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sSm/h4Uj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sSm/h4Uj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5E1C4CEF1;
	Mon,  1 Dec 2025 22:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764626956;
	bh=Js3ghnFZJ7YTPR0bCSccW+BMGxnMoOTm8M8mf0LkAOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSm/h4UjHJahCOwLj3mfF5fHKlXG2eyUlXEMS0j3tRlCV4sMROlID8tHAzaHED3Zt
	 O2YrmpmkOyAdPeSt110PVdmH2cpFth73Yag3gWx0A0eRAIDF7n0xXL1fJjDXhSTmGx
	 KYCyGWMwyJrD9bvGjTvNl/4fIxXlBvUBDRcEQ48eg7IYNCCuyv4d6qscXabQg/sha1
	 lEaJfGk87zFwpYgPNXC6w2+nhh8aqLXiwKWAWAJtSqD15HL+SKnRXDYCVO/DHNmNxr
	 sQg3pkJX+iCREfxdZ+7sYCdhKeYH2uaJicgei5D2H6UepxWpSYwaZDVu4kcZtYxUtt
	 bHi3q8RcVrwhw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y] smb: client: fix memory leak in cifs_construct_tcon()
Date: Mon,  1 Dec 2025 17:09:13 -0500
Message-ID: <20251201220913.1279668-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2025120143-confider-enzyme-4aa6@gregkh>
References: <2025120143-confider-enzyme-4aa6@gregkh>
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
[ applied fix to fs/cifs/connect.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 51ceaf9ea3151..677c757fffffb 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3926,6 +3926,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 
 out:
 	kfree(ctx->username);
+	kfree(ctx->domainname);
 	kfree_sensitive(ctx->password);
 	kfree(ctx);
 
-- 
2.51.0

