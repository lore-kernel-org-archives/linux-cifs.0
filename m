Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A2038DE9
	for <linux-cifs@vger.kernel.org>; Tue, 15 Oct 2024 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729029853; cv=fail; b=AVIS+16spDe9cP6K/k3R9ok4yA7sYrMeVik3T2vl1Xcjn2oCzOrnlgceExCv+9hvbQ1RZO+v1Swox//Q/RgvqZVIddzMJIrMPuW6yA+7rk8WzaXtBWMZG2GwyCUPkKwJggA9gD9k9edy1QIu3jpPqicAfxAOF0iFD5FX8Eq5LWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729029853; c=relaxed/simple;
	bh=Xpkyxwu4AqZMvkIoQUp6WLA4WQJr5pxRcNFEdookoP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YEEtKSYr0YtbZ0eK7AIzUs5ABC60BAkMJ+KJa/rUb+TJ6+hQOaVUMsPxkeDng1l+gYnhtI8kFpaDeLYPRwCrAQGOmUyAN9KPaEpNlOqugEGT1tuPBTOd7rjKTvP8tuWiGFFCfpCWIFG+MJtTmKx5W6r68d+vPT8X85SW0P4uQNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=o9/Vo+25; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="o9/Vo+25"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1729029849; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fCe0sF8CmTlALkwIHde792oUKc9wnU+e+AVhLAbV8Nc=;
	b=o9/Vo+25jPERQWg0f+Er3tDZ/ghpBDrbHre3O6XounOD/QHDksqAlFqpNVJIV8SvH0Ajju
	r/3DriUAk/zqJcxx5Q1rrHavIiwrf664O8XAv4bSwhUjd436DX8AKoHfiu5Bh3F84SXd9v
	FBx9T04eDSRv+dtn+rnNiQAi4oySJUu2NjaBVbbgA8t+BKL2dVoGMVvQz+4OsNQvJyPdUy
	zYxMDdGUhNfWFxlrD3aODRXWhwS8kmt4GP+LU6h9WDrsJwrb9NvlN2PiWivUcRkzK/A9kd
	K4pf6rtQp9P0Z0ay3/Lgom4fgsyMxUT4DceMf4IcWiVR5JUtJFc2LU8Nyii3VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1729029849;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=fCe0sF8CmTlALkwIHde792oUKc9wnU+e+AVhLAbV8Nc=;
	b=dRo0qxjPFQilUKkqBS+zhOxRlD9PazLfpB1NBj+I2AZ6cj3aTQ0EFd5UlsF7EzJn4qJKAt
	p24HudEPeLJmv+plwK2xQ/SpiQxv6wv3XWD/XLCWG13KQYI+/6WOHxcCU7MVikVY6isynG
	+Ms4Q/1IrCTcILuCS0pNe2I4VWOuoWQ4SJbuy8fb9+LvI7K1YAerJ7nB1GcdESayjr4Nai
	iSbYmFpkz/K7EIVoLyTQZU+faRRpT5hytZ4wfpfgsPUdklMyh3tIL/cEyUXzbSDbNQNdJx
	vxDDx9rjZq4STadhqu/a9PXo7NfWIzSpxtkoaKJIg0w9BfEeMHCtKMBLHcr/LQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1729029849; a=rsa-sha256;
	cv=none;
	b=erGwFhqYX9YptNtbyLW8iae0vFT9CNRtVnbGPqGUcTa19Bgz0ig5c69/EviVrHDDdQ3f7k
	ayShTpatIf9t0Y+py5Sr9PWStgOr3/Qu2JAKHpfA+3ZyJ3NZ/vU9uFfayu2xzxTDNcEi9+
	t8os89dxdCGnwUOlTLj4GQgx4leYdhZTjicORB8FXjI9hFVF7zPDGykPwGN1T45nwEgv/Q
	EOIxvvj7w9mEz+Qwo4UeMzlW0KDYXpBHo04E23zZGzJJL5WNveppisQydCx+lvDs8+cYed
	hYPHblfOBtvgquo9Ui4uswsIBmt7Jmw/ocMpudKNWqXx0r0/TcdrqQIifnJDtw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v3] smb: client: fix OOBs when building SMB2_IOCTL request
Date: Tue, 15 Oct 2024 19:04:04 -0300
Message-ID: <20241015220404.503324-1-pc@manguebit.com>
Reply-To: id:20241015183624.465132-1-pc@manguebit.com
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When using encryption, either enforced by the server or when using
'seal' mount option, the client will squash all compound request buffers
down for encryption into a single iov in smb2_set_next_command().

SMB2_ioctl_init() allocates a small buffer (448 bytes) to hold the
SMB2_IOCTL request in the first iov, and if the user passes an input
buffer that is greater than 328 bytes, smb2_set_next_command() will
end up writing off the end of @rqst->iov[0].iov_base as shown below:

  mount.cifs //srv/share /mnt -o ...,seal
  ln -s $(perl -e "print('a')for 1..1024") /mnt/link

  BUG: KASAN: slab-out-of-bounds in
  smb2_set_next_command.cold+0x1d6/0x24c [cifs]
  Write of size 4116 at addr ffff8881148fcab8 by task ln/859

  CPU: 1 UID: 0 PID: 859 Comm: ln Not tainted 6.12.0-rc3 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  1.16.3-2.fc40 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   print_report+0x156/0x4d9
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   ? __virt_addr_valid+0x145/0x310
   ? __phys_addr+0x46/0x90
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   kasan_report+0xda/0x110
   ? smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   kasan_check_range+0x10f/0x1f0
   __asan_memcpy+0x3c/0x60
   smb2_set_next_command.cold+0x1d6/0x24c [cifs]
   smb2_compound_op+0x238c/0x3840 [cifs]
   ? kasan_save_track+0x14/0x30
   ? kasan_save_free_info+0x3b/0x70
   ? vfs_symlink+0x1a1/0x2c0
   ? do_symlinkat+0x108/0x1c0
   ? __pfx_smb2_compound_op+0x10/0x10 [cifs]
   ? kmem_cache_free+0x118/0x3e0
   ? cifs_get_writable_path+0xeb/0x1a0 [cifs]
   smb2_get_reparse_inode+0x423/0x540 [cifs]
   ? __pfx_smb2_get_reparse_inode+0x10/0x10 [cifs]
   ? rcu_is_watching+0x20/0x50
   ? __kmalloc_noprof+0x37c/0x480
   ? smb2_create_reparse_symlink+0x257/0x490 [cifs]
   ? smb2_create_reparse_symlink+0x38f/0x490 [cifs]
   smb2_create_reparse_symlink+0x38f/0x490 [cifs]
   ? __pfx_smb2_create_reparse_symlink+0x10/0x10 [cifs]
   ? find_held_lock+0x8a/0xa0
   ? hlock_class+0x32/0xb0
   ? __build_path_from_dentry_optional_prefix+0x19d/0x2e0 [cifs]
   cifs_symlink+0x24f/0x960 [cifs]
   ? __pfx_make_vfsuid+0x10/0x10
   ? __pfx_cifs_symlink+0x10/0x10 [cifs]
   ? make_vfsgid+0x6b/0xc0
   ? generic_permission+0x96/0x2d0
   vfs_symlink+0x1a1/0x2c0
   do_symlinkat+0x108/0x1c0
   ? __pfx_do_symlinkat+0x10/0x10
   ? strncpy_from_user+0xaa/0x160
   __x64_sys_symlinkat+0xb9/0xf0
   do_syscall_64+0xbb/0x1d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7f08d75c13bb

Reported-by: David Howells <dhowells@redhat.com>
Fixes: e77fe73c7e38 ("cifs: we can not use small padding iovs together with encryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
v1 -> v2: fix ALIGN() usage
v2 -> v3: remove pr_err() used for debugging

 fs/smb/client/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b2f16a7b696d..6584b5cddc28 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3313,6 +3313,15 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		return rc;
 
 	if (indatalen) {
+		unsigned int len;
+
+		if (WARN_ON_ONCE(smb3_encryption_required(tcon) &&
+				 (check_add_overflow(total_len - 1,
+						     ALIGN(indatalen, 8), &len) ||
+				  len > MAX_CIFS_SMALL_BUFFER_SIZE))) {
+			cifs_small_buf_release(req);
+			return -EIO;
+		}
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
-- 
2.47.0

