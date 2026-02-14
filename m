Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484101DFF7;
	Sat, 14 Feb 2026 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771083945; cv=none; b=gZ03702w73NMGFeQ9RB2y1TEQd12CwU5jsEnNAh6T0FfXY165V2P/Cgmcu/QrCuG2FwzNEUW/zwA4QtLkzAJTFVyEOUuZXJZGUYrqFZrESjxGhQkn9uf1+MV3IFNdzbYX565m28c0e7CRn2Dp8zHQiv1otI4R+Remyt1EYNg3mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771083945; c=relaxed/simple;
	bh=2b/Hz7E/hS5O1BPXPF/6BmcIdM80RX59SIW0Jgmtuqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ln5UDrhZ6pB+rOqTKkFBIr2nYWHSfQkD/b73YcYEoXPY++5w02vZliz5pYDXUu3YIDvcX40oFCy6CgbvtfgP6yhB4dfDjOMvMntg/noGSC0vcdVIvK3JV9pG1zTBFrXWPrJ1uaPjtaLsZWjxTbVrYccMJDugorDIGDdnfQsd3ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=mv2f3Fj4; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="mv2f3Fj4"
Received: from debian.lan (unknown [104.28.230.246])
	by mail.ispras.ru (Postfix) with ESMTPSA id B6F56406C740;
	Sat, 14 Feb 2026 15:45:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B6F56406C740
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1771083934;
	bh=oTfkgZXpjapkYtjWtm270jN3Ycp4DQI4x3V+ugTHea8=;
	h=From:To:Cc:Subject:Date:From;
	b=mv2f3Fj46VPIZWHd8f6zo+6m8q8FsHAiojEklclq9MlEeTmnAfY8889uGbTAJnKfg
	 6faZYPMahC8PrKiGmQ1mGdcuGGgpzT9a8ZNmZDKEkgXqVU44v6lhGUsv0y2qpcWeUq
	 5IJgwxHFhsnunKkxXWQDQpbDplTLWxgtRct77UrI=
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	NeilBrown <neil@brown.name>
Cc: Fedor Pchelkin <pchelkin@ispras.ru>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: call ksmbd_vfs_kern_path_end_removing() on some error paths
Date: Sat, 14 Feb 2026 18:45:14 +0300
Message-ID: <20260214154515.1229565-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index cbb31efdbaa2..2782eea214d0 100644
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

