Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8DC18EC4
	for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 23:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fdYuXwGo"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702681171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YdMiEfpagzMjP7p2kIXQ4OUunFKWqlNgC6VoI9TlSoA=;
	b=fdYuXwGoJQTO1413AT2/gON6o6EkdP4i4agrFNmky3iPJLaLnpwJk3KzxFMY4axc+hvsfC
	Fpa1OF9MbtwF0viyb4pH7nkskUDr0maWedieTOkTUXiwsHqEpL7JcGnp20QjIhIwE8Cch/
	kqeEhbDNtHz+zCUkxLhaU7m0rExlhoCQtsTdSX6w/dXnIrKab65iQd/DF0b7hJy6IcHIfF
	JJj8RhgNUPVDfogLS0tRs+/v+WJ3u1HKsBzZFHJPaJLCALl++0vSKnm199IRU4iHOV9OfN
	PrQV1zYF2bcqzlcLxlJcos1Js4Y+m17c/qmXdusScC4xyITTAvhdyG/wh8T6pA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702681171; a=rsa-sha256;
	cv=none;
	b=k9mHkSfC+U7QZbG8R9eHvnFsc6bqx4uNO24jvk6cMcYlSWYgCzzv7NCGbtZ1JNLv/LLoys
	4HTr3i2PsyNf3sxiOUMAmo0cKR1TyzFYGAcP+/OxuHm0lllx3iSZd4iQWvZliysIBpogA5
	ROPbT/bfl1H4/gqu9CrZyjV+FfX9aNNRhXwTqHSnHgYZEq/v3WACmcwcJABLuaf6eTPekH
	kJYpLwKb/sy7T4nekTGkbDZfPUELLzq9Vk/U72v3fj/9XgZpUVk8KCDmT+NbnWua0C7Rvc
	bJcWzkYRa2Cjdv7bHm6TUngmX3DMXSr2ug2NH9QX9vDhwmUZKWUdlY8/INHEXg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702681171; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=YdMiEfpagzMjP7p2kIXQ4OUunFKWqlNgC6VoI9TlSoA=;
	b=g5rTxyKab3Wxv78lXPJhnicx/h5A+W2eGu4XSJeqrWQizy+Z8pjqC5V0btIqYM1BZ/utyL
	fjxpjQ0oRWIhoWJ1OwotnZJcFp9CPNRVMuLnOjQNhCHf2XS6RnbvRlKf0V1AJrJldsuYZd
	e8vGXTsiZAIMYs4FT4RJZLRtUI6ajQoH7RDCML59LfLC2S9Q8aPKBPqdDtvm84fDI5gEDf
	5HUWqujv0Alc9SQgNuYavDOLhNSwtTbp7V5prEaA2bl4chqqYvYdqPdnbB0Meb2BXkX+u5
	yD9vbqbjYfLTpkmYHZXAPgPjx8Tdnn+TjdmysJLbh95CGEhHjJYJWAs4+nFNvA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	j51569436@gmail.com
Subject: [PATCH] smb: client: fix OOB in smbCalcSize()
Date: Fri, 15 Dec 2023 19:59:14 -0300
Message-ID: <20231215225914.20065-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate @smb->WordCount to avoid reading off the end of @smb and thus
causing the following KASAN splat:

  BUG: KASAN: slab-out-of-bounds in smbCalcSize+0x32/0x40 [cifs]
  Read of size 2 at addr ffff88801c024ec5 by task cifsd/1328

  CPU: 1 PID: 1328 Comm: cifsd Not tainted 6.7.0-rc5 #9
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.2-3-gd478f380-rebuilt.opensuse.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x4a/0x80
   print_report+0xcf/0x650
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __phys_addr+0x46/0x90
   kasan_report+0xd8/0x110
   ? smbCalcSize+0x32/0x40 [cifs]
   ? smbCalcSize+0x32/0x40 [cifs]
   kasan_check_range+0x105/0x1b0
   smbCalcSize+0x32/0x40 [cifs]
   checkSMB+0x162/0x370 [cifs]
   ? __pfx_checkSMB+0x10/0x10 [cifs]
   cifs_handle_standard+0xbc/0x2f0 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   cifs_demultiplex_thread+0xed1/0x1360 [cifs]
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? lockdep_hardirqs_on_prepare+0x136/0x210
   ? __pfx_lock_release+0x10/0x10
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? mark_held_locks+0x1a/0x90
   ? lockdep_hardirqs_on_prepare+0x136/0x210
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? __kthread_parkme+0xce/0xf0
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   kthread+0x18d/0x1d0
   ? kthread+0xdb/0x1d0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x34/0x60
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1b/0x30
   </TASK>

This fixes CVE-2023-6606.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218218
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/misc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 35b176457bbe..c2137ea3c253 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -363,6 +363,10 @@ checkSMB(char *buf, unsigned int total_read, struct TCP_Server_Info *server)
 			cifs_dbg(VFS, "Length less than smb header size\n");
 		}
 		return -EIO;
+	} else if (total_read < sizeof(*smb) + 2 * smb->WordCount) {
+		cifs_dbg(VFS, "%s: can't read BCC due to invalid WordCount(%u)\n",
+			 __func__, smb->WordCount);
+		return -EIO;
 	}
 
 	/* otherwise, there is enough to get to the BCC */
-- 
2.43.0

