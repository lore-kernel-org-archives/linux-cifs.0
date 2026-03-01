Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B66285C84;
	Sun,  1 Mar 2026 01:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328538; cv=none; b=Qh0uiEPgz6jXea+jJPo1DlLrbpuMRFQlh5bNbd874cLHLDbTnhrkR+AFl78gbnLpcmAoD+Z0nNecK151mApWVVJmgrg49f+xeplvIoD5lHeaK5ZMeCJ5+blz5pmBmCCkOX1leDfNR7skv7+1riPZd6krKd1y1DpH6XjrFWvvKSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328538; c=relaxed/simple;
	bh=dj9a1zw0iVDX0X264gbz2jbxQdfwfErx51IkqDHkr5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jm8Yc/vUB/wjeTZAnZpwhLgxJavflS6D/eh6xv4ciimo3jooSsdYrjCeML6Ca+90Q2MhQ1Mlf5tBKXHMXVipzDwmI9GMgOLXamj3mp85iC2hkYeoz2Ogx8DPI+hJAMV63H33JM1dKLbUZS6HYur9DgoWuos1/C34J1b8sIeOxqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGWgTAtK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGWgTAtK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204D1C19424;
	Sun,  1 Mar 2026 01:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328537;
	bh=dj9a1zw0iVDX0X264gbz2jbxQdfwfErx51IkqDHkr5Q=;
	h=From:To:Cc:Subject:Date:From;
	b=HGWgTAtK2uojT+jVRjYmca5FdDIt0Q0g6LyKfzPQC2rMt1O3hHYxUKxozoVgSDUjp
	 RNi/rcnn3jvzZoKp1QwoMBFh+0zjT2FgA55Z4jf7UajcjzLiPb7nOlGPTlew6zLyb1
	 C2ZagJ1W88GHegPBUz8F9WPLTLLW5HY5lzIEuQEPLKk4IGPrMBuRlMo7ejJCFEO2BT
	 3q8FimffOpNznH5JH4p+9FySlIlIshJTD7Rn/L0lnHg4xVdFDrg5oJUfwbJ573lqrP
	 qEhMPkrFXUVOL8ndupNJoOhFi0ER4bMALmOsVyAup9wbnMO2R9Dby4uxMiIlFyV7PM
	 ouTE5FeuZp4pQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	pchelkin@ispras.ru
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org
Subject: FAILED: Patch "ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:28:55 -0500
Message-ID: <20260301012856.1686760-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From a09dc10d1353f0e92c21eae2a79af1c2b1ddcde8 Mon Sep 17 00:00:00 2001
From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Sat, 14 Feb 2026 18:45:14 +0300
Subject: [PATCH] ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error
 paths

There are two places where ksmbd_vfs_kern_path_end_removing() needs to be
called in order to balance what the corresponding successful call to
ksmbd_vfs_kern_path_start_removing() has done, i.e. drop inode locks and
put the taken references.  Otherwise there might be potential deadlocks
and unbalanced locks which are caught like:

BUG: workqueue leaked lock or atomic: kworker/5:21/0x00000000/7596
     last function: handle_ksmbd_work
2 locks held by kworker/5:21/7596:
 #0: ffff8881051ae448 (sb_writers#3){.+.+}-{0:0}, at: ksmbd_vfs_kern_path_locked+0x142/0x660
 #1: ffff888130e966c0 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: ksmbd_vfs_kern_path_locked+0x17d/0x660
CPU: 5 PID: 7596 Comm: kworker/5:21 Not tainted 6.1.162-00456-gc29b353f383b #138
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
Workqueue: ksmbd-io handle_ksmbd_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x44/0x5b
 process_one_work.cold+0x57/0x5c
 worker_thread+0x82/0x600
 kthread+0x153/0x190
 ret_from_fork+0x22/0x30
 </TASK>

Found by Linux Verification Center (linuxtesting.org).

Fixes: d5fc1400a34b ("smb/server: avoid deadlock when linking with ReplaceIfExists")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cbb31efdbaa2e..2782eea214d0d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6115,14 +6115,14 @@ static int smb2_create_link(struct ksmbd_work *work,
 				rc = -EINVAL;
 				ksmbd_debug(SMB, "cannot delete %s\n",
 					    link_name);
-				goto out;
 			}
 		} else {
 			rc = -EEXIST;
 			ksmbd_debug(SMB, "link already exists\n");
-			goto out;
 		}
 		ksmbd_vfs_kern_path_end_removing(&path);
+		if (rc)
+			goto out;
 	}
 	rc = ksmbd_vfs_link(work, target_name, link_name);
 	if (rc)
-- 
2.51.0




