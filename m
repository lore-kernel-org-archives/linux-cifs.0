Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CB1495CB
	for <linux-cifs@vger.kernel.org>; Mon,  8 Apr 2024 21:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712611954; cv=pass; b=ltraEK3q8PuwqouNrE0U+ZNUW//F45fdcfXsrB1ds0nl9DvD/kR26H2Er058oWkA0VyUjdoctazoJ9VYQus4PlxEilsxXswfPFOivw/ZN32oKudl97MEp3J3+GnHUhbjSbXVOVEWbSj2a7MmNQtRjAiv6s1MCRX3NeoeTXoCVr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712611954; c=relaxed/simple;
	bh=ZunjImYiSCFqWEILnRz9HqNyScF6epPEifH5RRHWb1U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HY9R7WDHShrpQlQhQa5H8Erj7FRzIzAooMvpHBmYMC5KG2XB1h+NTs7l1lQNwjLgy8jcoHtsytQxM56vSkIF4TXohp17aJm7zTE2xxwMzitZSLNhzgWeM3xi6h1CG7KKHr/L/hsV32Pl77q4hemCzYF2EsMG5LV2svoOub3diNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=dHZQgOdd; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="dHZQgOdd"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712611943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pz3aQQc+fs2xRuKbZQ0ouSREHphhShJCw0g46yBiDKs=;
	b=dHZQgOddoMOGPooQs0Hu97nL2Sz02ghNO0KKkfgOwdanWZtIbgejbi7OS//EgNcRBMIGAU
	aXiZMpv+6MNwaTepBgrHJXjjUtsnRT4bPRiXwr4wMKtRlwWxM5RDbe51TqaKsU6JuvDtkv
	RtgFLkkpyYeJiVe5EBpbNLavLlH+XVzSX3uIS0ljlzZSVbA3DsNgb1PALNCs4jZJ/B3Yu8
	rt2X1N4Ti7fsU6jOz0o8uZ5IHCnV7jgLuzf7vb2Wlf2iw60JItPavjvXtuL8MQN3gEb0L1
	JODv1GukutSilopffLO4fklKmBCzjdI/BDNf9Hz+ENp0rZgJxtWofyykKqxplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712611943; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pz3aQQc+fs2xRuKbZQ0ouSREHphhShJCw0g46yBiDKs=;
	b=rx4B4t/cf1Fk2TkXOIa4Z4/+YAxTDt7sVRjBdGO1UyQe8g0Hnsd9jbpORgvdUKt34qAAt2
	Kjvzes6+qIVOq0MhBwhNOQaIW3TVlDPvqqa7Ld2cJW43bqwsstDOgq4NJkOVrI4r0sziNu
	qe5DdIvOU4uFeKdRCLWY/Do6hLKNczrmSN586p/S/ay/Ps3B5aPG0AUgqoY4v0mohkQrKh
	BZfVGOm0Gz+FBjGg4NoHCF1f+VnKkPfT1pd/WrCs/6sXMHBy7xpHvvg5lPwYlLRfUDYYUE
	7xiIcRFn9bvK/4XFr4qOUgxNSEF+Eq6C+OlK81slxDqwGVqyKpjgYzzatXQKvA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712611943; a=rsa-sha256;
	cv=none;
	b=CvCscP2IXDG5G0TZx13Xze5APyqZxoUn7my66pRH/azBG0gzqqTYZKvt3dnicD+Y4KiY+S
	2ceGEOqPtqxcfxgxDJoH1HZGbA7XQyaS5LPV1henaTChki4/u7T4xZn32vUeDfaWiSR9/F
	h00b/rO0rgi9ZUGWSrcf4OvBEbh5pEmVGQZ45MRrDtAo/+YEl46cnTO+A6QJBVYjFmiuzf
	x7UbwC2yEH4fJn/zvJgiEp2+dfnmnaUVPTJdP8d/gO0FBwvYyxFu0ASwAdJEhqRslSXiq2
	l+M9mDP+tJMJ8MAOYSneASVrkGmWHM9hSA043Ybk8fUJcyidDz+jZd55FmGFhw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: fix NULL ptr deref in cifs_mark_open_handles_for_deleted_file()
Date: Mon,  8 Apr 2024 18:32:17 -0300
Message-ID: <20240408213217.241887-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_get_fattr() may be called with a NULL inode, so check for a
non-NULL inode before calling
cifs_mark_open_handles_for_deleted_file().

This fixes the following oops:

  mount.cifs //srv/share /mnt -o ...,vers=3.1.1
  cd /mnt
  touch foo; tail -f foo &
  rm foo
  cat foo

  BUG: kernel NULL pointer dereference, address: 00000000000005c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 2 PID: 696 Comm: cat Not tainted 6.9.0-rc2 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  1.16.3-1.fc39 04/01/2014
  RIP: 0010:__lock_acquire+0x5d/0x1c70
  Code: 00 00 44 8b a4 24 a0 00 00 00 45 85 f6 0f 84 bb 06 00 00 8b 2d
  48 e2 95 01 45 89 c3 41 89 d2 45 89 c8 85 ed 0 0 <48> 81 3f 40 7a 76
  83 44 0f 44 d8 83 fe 01 0f 86 1b 03 00 00 31 d2
  RSP: 0018:ffffc90000b37490 EFLAGS: 00010002
  RAX: 0000000000000000 RBX: ffff888110021ec0 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000005c0
  RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
  R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000200
  FS: 00007f2a1fa08740(0000) GS:ffff888157a00000(0000)
  knlGS:0000000000000000 CS: 0010 DS: 0000 ES: 0000 CR0:
  0000000080050033
  CR2: 00000000000005c0 CR3: 000000011ac7c000 CR4: 0000000000750ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? __die+0x23/0x70
   ? page_fault_oops+0x180/0x490
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? exc_page_fault+0x70/0x230
   ? asm_exc_page_fault+0x26/0x30
   ? __lock_acquire+0x5d/0x1c70
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   lock_acquire+0xc0/0x2d0
   ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? kmem_cache_alloc+0x2d9/0x370
   _raw_spin_lock+0x34/0x80
   ? cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
   cifs_mark_open_handles_for_deleted_file+0x3a/0x100 [cifs]
   cifs_get_fattr+0x24c/0x940 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   cifs_get_inode_info+0x96/0x120 [cifs]
   cifs_lookup+0x16e/0x800 [cifs]
   cifs_atomic_open+0xc7/0x5d0 [cifs]
   ? lookup_open.isra.0+0x3ce/0x5f0
   ? __pfx_cifs_atomic_open+0x10/0x10 [cifs]
   lookup_open.isra.0+0x3ce/0x5f0
   path_openat+0x42b/0xc30
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   do_filp_open+0xc4/0x170
   do_sys_openat2+0xab/0xe0
   __x64_sys_openat+0x57/0xa0
   do_syscall_64+0xc1/0x1e0
   entry_SYSCALL_64_after_hwframe+0x72/0x7a

Fixes: ffceb7640cbf ("smb: client: do not defer close open handles to deleted files")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 91b07ef9e25c..60afab5c83d4 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1105,7 +1105,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 		} else {
 			cifs_open_info_to_fattr(fattr, data, sb);
 		}
-		if (!rc && fattr->cf_flags & CIFS_FATTR_DELETE_PENDING)
+		if (!rc && *inode &&
+		    (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING))
 			cifs_mark_open_handles_for_deleted_file(*inode, full_path);
 		break;
 	case -EREMOTE:
-- 
2.44.0

