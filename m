Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD031B0F01
	for <linux-cifs@vger.kernel.org>; Tue, 15 Oct 2024 21:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729029382; cv=fail; b=pusv5NCUR2WG9tI7aqCjIsTQbeVQbAjuAuPBAiYItSL6dgIoorlLXoP5Uhq99Hk63KLXpHQSeKCbQFZdSTX5xBWnNoz0oFTDjvrcvqWkUyJONWGqoplAUZhNRWi0NsosJ2XdqCmcAChF7GLirhFpIs3PkLzhRgWAE8QovJPUORU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729029382; c=relaxed/simple;
	bh=jZ0MpISUUgXr4CypcHEk8wGU84dtYmZ3jq+E3CeBOyw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EItCUbCRUNoxMpSAELrM+bszMqbq3ySw+niGj4uYWi+3csnvjeKAQozWF6OG4TTul/Re8yJ+iRVXnYgOELIiUepWG8/6DBQ+B7yODCckDIfENH6RyNUtmcsplleoWLtNGOWcgC9RwNlbuZS2XicBMTznZV3OFuBCaCM9QkBQ+Fs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=a6aPUcnb; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="a6aPUcnb"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1729029379; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=h5vekCADfEDr3dKh+PMdqIFqyu1aH0hyK1+qJy3kIBE=;
	b=a6aPUcnbcXciuFlZueEbibBdFR0UFbqzeTVIrUtA3GrAPj73ofkvCAsO+Tq59KEuVduKOy
	1gePBc3VoWboP6VomRPBn8PTGg93v4EE0L1A8+nKD8Pao+nXLDMMXDO3KhgWacuG/s4v46
	JOgHAm6h08RXjehyOY7tYAX2AkeM2lydffBa2j0its48q2fWgYGCvd7Lt8arpVlJPrZUbC
	GLUG9Vj1jwtdnn4JfSlfNtOq7HgfPBpj4xaU+2jvw+JyGtXeU6jB0DDoYgrsBHHutXjLUs
	ihxC+AIR1I9lYEdyehkPWoWAo5KyCXoaksMQmzBkY9jUBSYQZaKeO6RfkecNiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1729029379;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=h5vekCADfEDr3dKh+PMdqIFqyu1aH0hyK1+qJy3kIBE=;
	b=bOnDIXmRGFG+a/c0nCOJPbp6ybetb6rosyEli81po017qHwPm9ol++anBQcamKfeyNFV/T
	1+zPPZbZXFCbpcwcVe5+6BUapaBWjoQpObgG1GlU7DzaDo+5Cu5/kTR/fPT5VLAw8kwibT
	qivY2ltC3M+VWAYlsBfgo0MqwX49Vu5dzOTUV93iLidEP79WjJ1oD7+Vzm+02YS0umI1fo
	r1FSvebfSrFfxqkMid00mwFCB+J/vl1GzceVtwZGL4srGX9k6hzSZF5RfnCMmkumjNzl2s
	LAOK0LsaXwxCHEWQtlBJVmn4QOoK7jhV6REGFVEtfu1MmqYw2S11i2KCNkwqtw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1729029379; a=rsa-sha256;
	cv=none;
	b=YEG7i6r6r7d2CKmYWKfLZrOOi/QNp+Sz3dNWCFq3cNPLb8gCysXcMeg9ndOSau7HP42o8+
	vkH4xrLerc97vA4JdTq5O3TKmUeYnsldEWjRYV929Epfl1gOIIdavO0XparOtnMnBze1nz
	ZAd8q4GC79A1xn/9KJiwnkWRXbs+bszjdZlxxmX999xa7SPwj/HxPsVDtMhtgcIjql1Arj
	nbgwHS0wRbyWnVBi5yLJnNujWH18VR1eAxPxTNKXoRyJyszekZseM0IDz1fH6RbbJbiKyF
	P1wBHPAcscyI/mMkMWf1Hzd3jpKfoK6wMvfWUlXt7VIIWlR2mCJoljeCgKWgQw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v2] smb: client: fix OOBs when building SMB2_IOCTL request
Date: Tue, 15 Oct 2024 18:56:11 -0300
Message-ID: <20241015215611.502354-1-pc@manguebit.com>
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
 fs/smb/client/smb2pdu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b2f16a7b696d..069bbfdc9750 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3313,6 +3313,16 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		return rc;
 
 	if (indatalen) {
+		unsigned int len;
+
+		pr_err("XXX %s: total_len=%u\n", __func__, total_len - 1);
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

