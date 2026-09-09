Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EE446D548;
	Wed,  9 Sep 2026 23:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788995278; cv=none; b=HDx7vvPXg6OsNtsoHyI0Gnw++Xg5hQMzQqYLH/KI+mGDjtnAhMNZBzwGrCBgsPE4KaEIOA4mYlVfnivv3P8LM4qP88i7sZC2pNhcThmKhwT8N8TP8SLbFhUePVXvrZncy1hEn8ICrp3R+o72AUL7/l4ibp2Mrruaw3LA8q5Iad4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788995278; c=relaxed/simple;
	bh=PaZiw9UEAmOoi2UbLeZnIYlbzCNRI4ZzrAIdO7cQyYw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ilAAHtbdP3Xi8NPyyzTev8x3I0l75D7NuAaziZKzVLfDv8E5NnTh2pU1pKMdIUWOONn2r3R1NC5l+2aXbVpQ3uUJGznldfMW/RxCFEFmHhaoKCDJyNCMq1J3Bxs+zDDY3vwJzcj4PhDuzhDqd3v623Z6ihmMgy7Rwh3MVSnjr5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=MxsqX52G; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="MxsqX52G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=s/gcxqRcSyyccjMtaF/eAGGMhNUjSpuF165Ao1nmHiE=; b=MxsqX52Gekfxakiq8XbYC80J/6
	v9vkyreSh/Dhktz0G/8dLG7Q7jQniK45dCNLNkE6/OAjjdqV95xB+f0Tg7dfLazX1SoT+wq5UlLEK
	iGtGx/KxqBeyimAU7N3QTSZIO70n1GHI4QUXrYvddAV/ABRrk5Ihm+cVi5vAm02XWHo4VGee4U0pY
	KDwlulTWIDLzN8G8DnTD0dFDnnlsq7vo2Lk8AlyDTJByvSq1LrfK9RFm8NFFFkEOmnMdHzi2p6f+o
	YrqM2vobptb9K0hsO0iNGV6L8rr+pCSRvFuwirtpLb7k+Ux36+HPk4GmVExwSZr9ZeVe7BYK9DYGw
	rURXPofg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x4ROO-000000014aJ-1bd6;
	Wed, 09 Sep 2026 20:07:48 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Pali Rohar <pali@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix one-byte OOB read in smb2_parse_native_symlink()
Date: Wed,  9 Sep 2026 20:07:48 -0300
Message-ID: <20260909230748.1226168-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When parsing a share-root relative native symlink, memcpy copies
smb_target+1 (skipping the leading separator) but uses
strlen(smb_target)+1 as the length, reading one byte past the
allocated buffer.

This fixes the following KASAN splat when accessing an SMB symlink
with a target of '\a\b':

  BUG: KASAN: slab-out-of-bounds in smb2_parse_native_symlink+0x4f5/0xca0
  Read of size 5 at addr ffff88800878fe21 by task netfsfuzz-execu/1
  CPU: 1 UID: 0 PID: 1 Comm: netfsfuzz-execu Tainted: G N
  7.2.0-11943-g2709dd5ae32f-dirty #1 PREEMPT(lazy)
  Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix,
  1996)
  Call Trace:
   <TASK>
   dump_stack_lvl+0x7b/0xa0
   print_report+0xd0/0x630
   kasan_report+0xe5/0x120
   kasan_check_range+0x105/0x1b0
   __asan_memcpy+0x23/0x60
   smb2_parse_native_symlink+0x4f5/0xca0
   parse_reparse_point+0x68a/0x1530
   reparse_info_to_fattr+0x752/0xa20
   cifs_get_fattr+0x873/0x15b0
   cifs_get_inode_info+0xc0/0x310
   cifs_lookup+0x308/0xa70
   __lookup_slow+0x122/0x2b0
   lookup_slow+0x50/0x70
   path_lookupat+0x525/0xaf0
   filename_lookup+0x1f2/0x550
   vfs_statx+0xd1/0x1a0
   vfs_fstatat+0x65/0xc0
   __do_sys_newfstatat+0x9a/0x120
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Fixes: 723f4ef90452 ("cifs: Fix parsing native symlinks relative to the export")
Suggested-by: Pali Rohar <pali@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index b6bded042e78..8a1b9e8be5ba 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -971,7 +971,8 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 			linux_target[i*3 + 1] = '.';
 			linux_target[i*3 + 2] = sep;
 		}
-		memcpy(linux_target + levels*3, smb_target+1, smb_target_len); /* +1 to skip leading sep */
+		/* +1 to skip leading sep */
+		memcpy(linux_target + levels*3, smb_target+1, smb_target_len-1);
 	} else {
 		/*
 		 * This is either an absolute symlink in POSIX-style format
-- 
2.55.0

