Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38703A1D14;
	Wed,  3 Dec 2025 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781109; cv=none; b=PY1vJYuZjS82/5qpScINJsRdxedCkDrUxZi+GMkLNAnx5biJrlHmd0AIvjxKDb2CTGf4F2ZU1RYK+aK3btjtE2sma+g1FYHwNS4q8tcXbzGd9d1nM+PrqeuyP3cBqKqzcQf7N87iFCArpMuuWVpdu0i1aS8ucxRh3TwH8asAEpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781109; c=relaxed/simple;
	bh=mIxKv1CYT7oySN2uIJ2wmeG9vV+lve9zLA2xymm3+rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gximJYUbPyLqh+g2zVf+LCVMpkHGdrdzzJprD1x9mWH3IjYdYl7SDIeAKdEFTr3ZjeKR3UYC4243oZCVLdY8o/R3HfJsN1pjwKYYfn79XuOXnYHAki6ZpoBGFhdoMHq3jkfb8TaFVDeXfIHjAV/VMI7ngAoY1fQHoy1+Qpug0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvmf3lAN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvmf3lAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD02C4CEF5;
	Wed,  3 Dec 2025 16:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781109;
	bh=mIxKv1CYT7oySN2uIJ2wmeG9vV+lve9zLA2xymm3+rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvmf3lAN5WWIg2ECPhE7DvfIMEuzySvyuUgJGSoOrGjlleguPiK1gg8CckKyuZ8Ld
	 IKtOQQlDicArFufhuiGsePJ2JV+zLxIf30+Wz9jiEMomBhTe7Po/DOvlDyFj5mtcOc
	 Ogy4gZeM5ErWyI6rFMG7m1tFww1anhBPBlNQcKI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Jay Shin <jaeshin@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 50/93] smb: client: fix memory leak in cifs_construct_tcon()
Date: Wed,  3 Dec 2025 16:29:43 +0100
Message-ID: <20251203152338.371156577@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4224,6 +4224,7 @@ cifs_construct_tcon(struct cifs_sb_info
 
 out:
 	kfree(ctx->username);
+	kfree(ctx->domainname);
 	kfree_sensitive(ctx->password);
 	kfree(origin_fullpath);
 	kfree(ctx);


