Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE0D62171
	for <linux-cifs@vger.kernel.org>; Fri,  6 Dec 2024 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733500066; cv=none; b=NVMYox7rxk05a7B+PBSHbjou+54NS122kDHPlq783qF2uWA6H8wKw9T+uGnAD5xv4zqmw+zdwM6qbdlwz9p6H5b/myoIXvVYqNxiEdxDkbbjCmNbZs4oxwYrdkX3kJ3+ttXPrk0px0V5DZ785lgV/FcQop7lPVbpY5nLtieh860=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733500066; c=relaxed/simple;
	bh=JfPgl/fnlY4YdqAgh2zz4S/wMIsllZVSGfaI8O6lpmU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tXxHpjUOusvzUNUZoe2t8YigENf1EfrlG3noY1oSGKKcBpoV1AZaZjvtMHREZ5abgDheBpPFB85mpN4iiRcWOk4yKV101gXLg9rsSGAFtWs40TKY8QH+LuPyni7CaoVEvURXySzqPVscIWRidySd86ZBKx6l/Iu6+E1NaJX42DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7fd21e4a9c0so1403446a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Dec 2024 07:47:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733500064; x=1734104864;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BVbgpVfKhTT58P3T35HkaF9qcjJoA1bjWf6O+vuK8Eo=;
        b=ugXQzVErvVmKq0hw0DHYEFtL6elD6VbXlbCqsYFKVCeYcgFtNkmenwjQxMSw8o0Kh/
         cdbJsS8gptMvjv4MbzVM23NFtKlzVww+v03EC9m/V0Son7SL9x95Tu3vphXJ/f9QLrNC
         FFsQYLGxB4GcB041DkJd8YDytwQvOP8euvBptlvoQQ3WJUcsYHW1JjaDEaF78K9FUIGu
         cy5PsnRD/6b798c1PXtVaZLQdyyXak397unp7gD/ldw+K62vt4I+4/fZ5TVOQOWgyxLZ
         L/SVj14TG/J7BSBojxAXBf+4W445YnDS3rVIqozn2yvL3uNGenYGaVJr6ZLMltlzd8n3
         YoxQ==
X-Gm-Message-State: AOJu0YxSNVEB5Uz2VasmlEf6eGIHzCwULBShRogW4ZAx1yNwOutitAJL
	k27fcR9rTGl4uJZyQ1O29SMDy3mDpz3ePWzY4BNH2+abpre91naDmgJVkA==
X-Gm-Gg: ASbGnct87nbBbqcrvy9OsUQh30dp5Iiqep2MNB0/WYdvZ25l4URDrY2v8NAG4eedi/q
	waRopmYXs+7BdPiHO3lC91UyE770gBK+zNKsyH8yGiw69vksOMH1Tn8Rt+nw5WfHw+FRxb+hwQv
	+lNzK8B5U/JzmYnuVhRyV0qWe6V0RAXSCEQar0P6Ha0FxzhptIegQQAjWG9Cuahd4ITJ4k4F/v7
	6XnH+lxBj+FNnjm3UyrzUw20l18u/1DTQ+xJ+haA73Po74knRT4DQG1ZhSIovMv
X-Google-Smtp-Source: AGHT+IEZ/gKP5bFF/p+xnuqZMLgtmwRwNwKaofGjwc0YxpwQUfMuGyvbVVVqRApeZAqE8boY0CCGDA==
X-Received: by 2002:a05:6a21:78a6:b0:1d8:f62d:3585 with SMTP id adf61e73a8af0-1e1870af416mr4352401637.5.1733500064073;
        Fri, 06 Dec 2024 07:47:44 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725a2ca649bsm3178399b3a.146.2024.12.06.07.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2024 07:47:43 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ksmbd: set ATTR_CTIME flags when setting mtime
Date: Sat,  7 Dec 2024 00:38:58 +0900
Message-Id: <20241206153858.12505-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/server/smb2pdu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5a70df87074c..803b35b89513 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6026,15 +6026,13 @@ static int set_file_basic_info(struct ksmbd_file *fp,
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
@@ -6076,8 +6074,6 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 			return -EACCES;
 
 		inode_lock(inode);
-		inode_set_ctime_to_ts(inode, attrs.ia_ctime);
-		attrs.ia_valid &= ~ATTR_CTIME;
 		rc = notify_change(idmap, dentry, &attrs, NULL);
 		inode_unlock(inode);
 	}
-- 
2.25.1

