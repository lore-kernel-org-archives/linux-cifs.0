Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D183AA19C;
	Wed,  3 Dec 2025 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780743; cv=none; b=A26EE8xbX4q1byy0zEOVIymgsl61ZHLIBJo9Jf64bILkXAL/W5OllrJKuwrk4aLci0WohhwadEIq/2RYyHvwjtASvEdIuX3ECy+Vmiov3GTOAKASuE+igaLRxwKBf6Ka1LgTPc8b6YibGru86mYRCnrh7RFtwZj+AGxBtuyqhVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780743; c=relaxed/simple;
	bh=eE1MgjL8I7/jKcxsoo40q750u1/7Jb1FexJjnZOtHO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKvkYz1TAIED75RWJzdWLtjZCoeVTjzurXLG6Ypn+4Z3T3VCzL6F47ty1fpyQ5t8mH42fS6ulAhalum9Yi83BKM9UDn6cKpjH5gkPgbLVipKwEbuiPlYO27ORwzBIk9mIj/zMzrwlJvgjHI7NYXwGrgH8WLg4NljRVy4sWZ8sY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Q9h8dB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Q9h8dB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63E1C4CEF5;
	Wed,  3 Dec 2025 16:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780743;
	bh=eE1MgjL8I7/jKcxsoo40q750u1/7Jb1FexJjnZOtHO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Q9h8dB1k3eyGnbAyTCI5Qn5+Mo7fmA2T8RJM9uzR8A3Ew+OFpHr+jtngY1TuFo4W
	 BJaa2ciraH7JgUOtlRLFE7onNw6RzPc57ZDxPVQQHZJck9TiG0E7lY7EW+gfRW3/hb
	 Utd+JMIXB/3h+nx/xmkcCDha3YBnBC+guedK1Cho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 077/132] smb: client: fix memory leak in cifs_construct_tcon()
Date: Wed,  3 Dec 2025 16:29:16 +0100
Message-ID: <20251203152346.146051848@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 3184b6a5a24ec9ee74087b2a550476f386df7dc2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4227,6 +4227,7 @@ cifs_construct_tcon(struct cifs_sb_info
 
 out:
 	kfree(ctx->username);
+	kfree(ctx->domainname);
 	kfree_sensitive(ctx->password);
 	kfree(origin_fullpath);
 	kfree(ctx);


