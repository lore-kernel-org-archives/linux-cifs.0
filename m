Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B6B22E3FF;
	Fri, 20 Dec 2024 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734714787; cv=none; b=qYHpSZwayHDycllfSb+qwWt28jfHaifFO3Dtl4Js83xLAzGmVjyZKmipF+iv80rhGWPYww6LV9TMXCz7BDxia1S6L7ZVtLqN5i4LdNVhuaE80kuh9yumPWAMnuolyghXu/1nwwTdYnJzanD2MbB/zYfKw3xwqbngW2O5IZ2EeLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734714787; c=relaxed/simple;
	bh=S59A/UWVUqXIZ3fRdfKru1rS4IxPD2DHrZSh3KhdQeg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u8dijM49F9lw4mnE+TERNssweIJ023ugzUtxTupc36VsjbHZ7sL9rhF/nqP0wZRm1OCLlhMCkvbsVYn8xvNg4Cuo89RYY/1uacaOAk9zXsVu2NVjdt1gGpAxy0AT/QBF1tLUbIo+7lz13R6lZbVFYjys0/jZ2zrPGMvITmhF4+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHbNOVgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHbNOVgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D0BC4CED3;
	Fri, 20 Dec 2024 17:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734714787;
	bh=S59A/UWVUqXIZ3fRdfKru1rS4IxPD2DHrZSh3KhdQeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHbNOVgJdRsGy8n5uma71sbxZIhK2H6prYSLo/ugxXL7foyZp9wVH7wVv2ultYG1x
	 HOemjOmeTewxvHAo9fQdbDCxLA7hrs8A32gNtrOiBZLpxydyOuZnSOfBnB9IaknDgv
	 LYMBf/OzMB8MHf5/CMQAx2k20xVKfl4iyCXQf9SjiM0JsvXPFlj8gjOAfbigQI3oLe
	 5lL1XyJPue6U1VLnR+zuxf3V+e1o68wP4W7Rf1b0HZXSTxoEFDwJbZqlvZtplMypB8
	 FUJF0lZK1KWIwtJshzhYLLCmIo8NVjkwKWV8CuDXzBfZfPNoISUW0MiuRpNOW7B5OS
	 5UqUYC8meMpjQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	David Disseldorp <ddiss@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 11/16] ksmbd: set ATTR_CTIME flags when setting mtime
Date: Fri, 20 Dec 2024 12:12:35 -0500
Message-Id: <20241220171240.511904-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241220171240.511904-1-sashal@kernel.org>
References: <20241220171240.511904-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.67
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 21e46a79bbe6c4e1aa73b3ed998130f2ff07b128 ]

David reported that the new warning from setattr_copy_mgtime is coming
like the following.

[  113.215316] ------------[ cut here ]------------
[  113.215974] WARNING: CPU: 1 PID: 31 at fs/attr.c:300 setattr_copy+0x1ee/0x200
[  113.219192] CPU: 1 UID: 0 PID: 31 Comm: kworker/1:1 Not tainted 6.13.0-rc1+ #234
[  113.220127] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
[  113.221530] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[  113.222220] RIP: 0010:setattr_copy+0x1ee/0x200
[  113.222833] Code: 24 28 49 8b 44 24 30 48 89 53 58 89 43 6c 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 48 89 df e8 77 d6 ff ff e9 cd fe ff ff <0f> 0b e9 be fe ff ff 66 0
[  113.225110] RSP: 0018:ffffaf218010fb68 EFLAGS: 00010202
[  113.225765] RAX: 0000000000000120 RBX: ffffa446815f8568 RCX: 0000000000000003
[  113.226667] RDX: ffffaf218010fd38 RSI: ffffa446815f8568 RDI: ffffffff94eb03a0
[  113.227531] RBP: ffffaf218010fb90 R08: 0000001a251e217d R09: 00000000675259fa
[  113.228426] R10: 0000000002ba8a6d R11: ffffa4468196c7a8 R12: ffffaf218010fd38
[  113.229304] R13: 0000000000000120 R14: ffffffff94eb03a0 R15: 0000000000000000
[  113.230210] FS:  0000000000000000(0000) GS:ffffa44739d00000(0000) knlGS:0000000000000000
[  113.231215] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  113.232055] CR2: 00007efe0053d27e CR3: 000000000331a000 CR4: 00000000000006b0
[  113.232926] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  113.233812] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  113.234797] Call Trace:
[  113.235116]  <TASK>
[  113.235393]  ? __warn+0x73/0xd0
[  113.235802]  ? setattr_copy+0x1ee/0x200
[  113.236299]  ? report_bug+0xf3/0x1e0
[  113.236757]  ? handle_bug+0x4d/0x90
[  113.237202]  ? exc_invalid_op+0x13/0x60
[  113.237689]  ? asm_exc_invalid_op+0x16/0x20
[  113.238185]  ? setattr_copy+0x1ee/0x200
[  113.238692]  btrfs_setattr+0x80/0x820 [btrfs]
[  113.239285]  ? get_stack_info_noinstr+0x12/0xf0
[  113.239857]  ? __module_address+0x22/0xa0
[  113.240368]  ? handle_ksmbd_work+0x6e/0x460 [ksmbd]
[  113.240993]  ? __module_text_address+0x9/0x50
[  113.241545]  ? __module_address+0x22/0xa0
[  113.242033]  ? unwind_next_frame+0x10e/0x920
[  113.242600]  ? __pfx_stack_trace_consume_entry+0x10/0x10
[  113.243268]  notify_change+0x2c2/0x4e0
[  113.243746]  ? stack_depot_save_flags+0x27/0x730
[  113.244339]  ? set_file_basic_info+0x130/0x2b0 [ksmbd]
[  113.244993]  set_file_basic_info+0x130/0x2b0 [ksmbd]
[  113.245613]  ? process_scheduled_works+0xbe/0x310
[  113.246181]  ? worker_thread+0x100/0x240
[  113.246696]  ? kthread+0xc8/0x100
[  113.247126]  ? ret_from_fork+0x2b/0x40
[  113.247606]  ? ret_from_fork_asm+0x1a/0x30
[  113.248132]  smb2_set_info+0x63f/0xa70 [ksmbd]

ksmbd is trying to set the atime and mtime via notify_change without also
setting the ctime. so This patch add ATTR_CTIME flags when setting mtime
to avoid a warning.

Reported-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index a3231fca351b..70249f36b84a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6017,15 +6017,13 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 	}
 
-	attrs.ia_valid |= ATTR_CTIME;
 	if (file_info->ChangeTime)
-		attrs.ia_ctime = ksmbd_NTtimeToUnix(file_info->ChangeTime);
-	else
-		attrs.ia_ctime = inode_get_ctime(inode);
+		inode_set_ctime_to_ts(inode,
+				ksmbd_NTtimeToUnix(file_info->ChangeTime));
 
 	if (file_info->LastWriteTime) {
 		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
-		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET);
+		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET | ATTR_CTIME);
 	}
 
 	if (file_info->Attributes) {
@@ -6067,8 +6065,6 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 			return -EACCES;
 
 		inode_lock(inode);
-		inode_set_ctime_to_ts(inode, attrs.ia_ctime);
-		attrs.ia_valid &= ~ATTR_CTIME;
 		rc = notify_change(idmap, dentry, &attrs, NULL);
 		inode_unlock(inode);
 	}
-- 
2.39.5

