Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0941F5843
	for <linux-cifs@vger.kernel.org>; Tue, 15 Oct 2024 18:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729017405; cv=fail; b=Oxa0SmyXTgpMqG+SkdELd6Gxji+vpKlX6MJTFiEEQfSdfEkcwbPG2TbJ1pHLjy7GTCgdYpr//VFeSCn4ckclEBjeMG7VYMjJSmc7lr7U3bQypknWEzMULmDg1h2Y/s0Y8RhmlgdxodFpm36Z29/7jEBWqwR0nvfs+VhtarNP40A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729017405; c=relaxed/simple;
	bh=IIbYmhoByUq7Z2s93HypcWpjr+2Lt4Pd6gqAjR9nqtk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g7NkN5sUnBPLO8MLz4DtsQSYfsL6nAH+lRq3WD9L+FI99WUDBd5yUrp1GmuM8JUinMDZjbgcaFaA8rJmki3mWqVAOmHpDYByju8zIFJZBXPl08Csl1kGCiqPBG97uc8bD/ACgiRg6Ch4/1CdjB4Pwx24Lct5SbbazHPDOX0NdPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Op9vffE/; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Op9vffE/"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1729017396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4RYNpEjK0x3l6zPp/unbAF1do3e2FBPT6v4+XZR9xA4=;
	b=Op9vffE/TMjN3g+nFRsCJztPcQ7kYyXRj4rzKrkzdGUgZXksBSLaa1uElDkr4f2MLpObli
	+jpeODmQ+iU1N9NDLBB8Fvs+cgT/E/AFVhQMRDA3eTSE+fPYxaUCLZP3wr7qMO91luQD4D
	Ht/SxXes3usMse8qOMzERrDfUBhuA45YOGjW1jjUsTvYA1nZeRVdD14irOTTFavxEcHbYN
	gkQjnznaJEzogX03ff/PBaBDEKVKUvWDYy1v7bnIk8HP7Tso2u6uhu1SyDRPwkrVqdpljI
	UZxbO1Aw4TX1dtceKUN39oB9nRD5+Mboxr/f8GJ6oyUKr2vK6ty6XZXqntjpWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1729017396; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=4RYNpEjK0x3l6zPp/unbAF1do3e2FBPT6v4+XZR9xA4=;
	b=j17QG37l43Jj1PGht6N+zGHNLEsaTLdnJQSw6nkx3LS5558/Vs+j6hqgISCE7Ghg9B3FWe
	tCpplbFejSIDNbM/1j1MK28YVEuTbBZbETbuWiIIx1EUgqEcjCPYc9RFilG9bqFEikEAnD
	C/fOjw59u7s8SdLa02phmynN/8p/mGYPnGAkhmxPbpWQ8EXZnK9iHU63Ce7Mq/oQ+sPFTg
	mzrho1D5qYC5iEdCwR8rRpbHsLUaEQIf743ANDMrrXviIpB/OwKgi/sOZt3VH3zyvgW0VN
	8STlDiYhw+v15IRJeeQKhVc1wf9BhLR41YV14TgKT6uXtBt5YiJWKghwlJARGQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1729017396; a=rsa-sha256;
	cv=none;
	b=X6saslGBlvOC9zxm8g1rrEwunvCgbp3zuSWODGiaXUNlPmMGDGs4yeI+Zn26ZuvxV8F6NX
	AE2GpAv+EYKnj9sTPDFnk1xRxyi7p4hUiZTr3URhw060XCvir2PdG5UffibJ9CVL1n0oVp
	VepoIax2d50j/gm375LGWN5d4/MrvGDoCSQ19dQCtciD6sygi6BvPDWDND7RzvM/e5w4Zl
	7ICKiOBwCXpOP3R/fEK5MTeWX0agMKlJaqC/SQo7CMJuow5Rk1ALlzLNJTZlmsYd8xjFFk
	PX62C+IRSZfElw7L2lwoUAknV0x1AXRm5wVauc1zrXsQe8mavAGzB1d9y3iWYw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] smb: client: fix OOBs when building SMB2_IOCTL request
Date: Tue, 15 Oct 2024 15:36:24 -0300
Message-ID: <20241015183624.465132-1-pc@manguebit.com>
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
 fs/smb/client/smb2pdu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index b2f16a7b696d..2384e00203ae 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3313,6 +3313,15 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 		return rc;
 
 	if (indatalen) {
+		unsigned int len;
+
+		if (WARN_ON_ONCE(smb3_encryption_required(tcon) &&
+				 (check_add_overflow(total_len - 1,
+						     indatalen, &len) ||
+				  ALIGN(len, 8) > MAX_CIFS_SMALL_BUFFER_SIZE))) {
+			cifs_small_buf_release(req);
+			return -EIO;
+		}
 		/*
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
-- 
2.47.0

