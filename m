Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188F2227575;
	Fri, 20 Dec 2024 17:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734714742; cv=none; b=Za0+TZLO5SiMcKv8ra9D/9Yq33lOLDewhg6ScppDEFpi/gDlOW6DsuGgKSPj2amMMQOZ0HMsSbscLaK8330FjjJfJDJwxk+vKq/vEAj7zDSt/pyvgL5mMF83MtIbUsP+fP0tEqJ17rZVKrHeX5R1O63ExrbIBWAXHhetlAUUOrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734714742; c=relaxed/simple;
	bh=pCMdG4EXTRnNM3oW/HyTNag7DVHM/FWV+DsXXaPt+Kw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bo/8WX9t6JXn/t+D7XcX6X65y2tiNTPAenq0t1WpvJ+sROPZk5rOyc8NwPYQUvJPXLdUdRUtxS8g3eJfNd6ns5e25J7jdjrzefd2DKBqLMyMGDPC/VEXn1gNmUy0jEuylzYRWsZE9xLi6A32ffGo0/6cMg3IMQefh96gVN707f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhlMDa4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhlMDa4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C039C4CED7;
	Fri, 20 Dec 2024 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734714742;
	bh=pCMdG4EXTRnNM3oW/HyTNag7DVHM/FWV+DsXXaPt+Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhlMDa4v0YhgEGyLnOZQVoHsKCpaca5vf2XuCL5DJCanMFTJv2y43dkYutAeQ+P2c
	 G8P9U0LCh/ibwls3eyc5H8lHC+7gm/X91AFxQyZ+SmsoCXcC3nJlb6oKPXp8DNTYWd
	 Tuu41KYZNW+7QVIGdxwOdzOA+s7PZbzLRbxE11eVI5JXTnM0cgVFDBjLrUsid0neMR
	 4TMhBWz++SCzFxqYhjL1ZQfh3m0XodtC1pet8hNcrEE0lg2a3CxmEgdpgVSCgxgxD8
	 xq+0VXtTvooTap89AmhYOF7tZWvGTu6LWqBaJay1Ta/gyuzB++GnUiBtTZ/xPKdmKQ
	 e8H3QCEnAczJw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	David Disseldorp <ddiss@suse.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 22/29] ksmbd: set ATTR_CTIME flags when setting mtime
Date: Fri, 20 Dec 2024 12:11:23 -0500
Message-Id: <20241220171130.511389-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241220171130.511389-1-sashal@kernel.org>
References: <20241220171130.511389-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.6
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
index 80cfaa1b4e01..e03d784148e6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6016,15 +6016,13 @@ static int set_file_basic_info(struct ksmbd_file *fp,
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
@@ -6066,8 +6064,6 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 			return -EACCES;
 
 		inode_lock(inode);
-		inode_set_ctime_to_ts(inode, attrs.ia_ctime);
-		attrs.ia_valid &= ~ATTR_CTIME;
 		rc = notify_change(idmap, dentry, &attrs, NULL);
 		inode_unlock(inode);
 	}
-- 
2.39.5

