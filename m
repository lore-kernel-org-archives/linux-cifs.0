Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CDA2F39BE;
	Sun,  1 Mar 2026 01:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330309; cv=none; b=npi8Q9MfuWPZVDMg3vd3XmYZ73jNhpzPbmnCGUJHlY4xafOo7N6EAirTyfH19btpCl8+d8xL/6tKyXrH6Ewwmx+gfYnxLSZ592LWhuvQ0veS+rXz2mDhwyNiYrv+QlgryloglHiRAb5iBL7RTy5pEpnrhsoPdtH748rOJcbcSmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330309; c=relaxed/simple;
	bh=CBvrVGrisF1eaZCNAte3uVqkWp8PdJvKBBzdl3js/RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZ+/M1q4iBn/JJD8GCI8dMY8IqLaQJonYQtg+u/pJNddKoOuDYAOwC99H245k/oRf//Kstasv/SYRdV5l/KYn29z7a96FON4Hf/nYEnLQfOer6ze+azgr4C95grQoiR4S40DuMwpH+LodfbNrvyov0ZILBMVK1lrhsmpIqiODLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fTB10FQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fTB10FQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E58C2BCB3;
	Sun,  1 Mar 2026 01:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330309;
	bh=CBvrVGrisF1eaZCNAte3uVqkWp8PdJvKBBzdl3js/RQ=;
	h=From:To:Cc:Subject:Date:From;
	b=fTB10FQ+t3VlRgl8+vBMTOcQMOegaxPqxvXTJMTOseb9yqaeFcWcLxI7nTU8PezWw
	 R8VKtx8HxqeNVke/LkQxaMH3iL9VTKl/cLpertxnXxNaxBF051Dx8/13MnQ1JLtS2p
	 3zqKPJh+jZZRnABESS9L/cY43LIjBGAPDAeUWmik7NZrULLxrhZRoXr0g1JzSqe3oq
	 UajKWAXbQ+vDvZCoELcJPFwiS/2L6dWI+r8SGr9AzTaBfD+O1Jqrvm6yaj4eyCWg1n
	 I3We0LprUUHrcQMuaGKqFBX8lsjDZwltNQJRYVL1F0/TSfSR6zip6vk2C6JTbf65XL
	 XO6jyNC5+hJaw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	pchelkin@ispras.ru
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org
Subject: FAILED: Patch "ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:58:27 -0500
Message-ID: <20260301015827.1723912-1-sashal@kernel.org>
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

The patch below does not apply to the 5.15-stable tree.
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




