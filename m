Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBDA19004A;
	Tue, 21 Apr 2026 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776777976; cv=none; b=tXsIhDX56PsIsgcrFRZq4bE8i1LJt63e7VQhHFZZVm5FnXI/Fk/Isz+TFdbaccepd5AXi6MS9B6ex7+vMcY1Nm4s09Hvx06g9M5xx3LE7iLI0qL+SYsFZDS+fSA83ejQIztiK73PXKF7hSHkzL9PTppFJUnTuP6bf1oeZYB7RW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776777976; c=relaxed/simple;
	bh=oYn8wqJFenAgTBU6zT0gfzUkCUtPMUGM8nu/rQnPnV0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pns8ZbxvCQAzEWP8tLiDz69kBQNS+iw3u5FPnOsLDMim79KVxQhAVzA5ZGG+OLt3z82qjfYJ2ITfllPvUxOgYsYJgndfzuCu5FTPjFXv6Nwi6JpOu0X1YlXD4eew3XKWTRMJC7zfqtRQ19Iow1hftaDm7g+g8/7JeJrq7JES0HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 2E1C82338F;
	Tue, 21 Apr 2026 16:26:13 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: stable@vger.kernel.org
Cc: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH 5.10.y] cifs: Fix connections leak when tlink setup failed
Date: Tue, 21 Apr 2026 16:26:12 +0300
Message-Id: <20260421132612.38517-1-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit 1dcdf5f5b2137185cbdd5385f29949ab3da4f00c upstream.

If the tlink setup failed, lost to put the connections, then
the module refcnt leak since the cifsd kthread not exit.

Also leak the fscache info, and for next mount with fsc, it will
print the follow errors:
  CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)

Let's check the result of tlink setup, and do some cleanup.

Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ kovalev: bp to fix CVE-2022-49822; adapted to use direct xid/ses/tcon
  variables instead of mnt_ctx struct fields due to the older kernel not
  having the corresponding cifs_mount() refactoring (see upstream commit
  c88f7dcd6d64) ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 fs/cifs/connect.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 769c7759601d..3161155fd069 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4786,9 +4786,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	vol->prepath = NULL;
 
 out:
-	free_xid(xid);
 	cifs_try_adding_channels(ses);
-	return mount_setup_tlink(cifs_sb, ses, tcon);
+	rc = mount_setup_tlink(cifs_sb, ses, tcon);
+	if (rc)
+		goto error;
+
+	free_xid(xid);
+	return rc;
 
 error:
 	kfree(ref_path);
@@ -4820,9 +4824,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 			goto error;
 	}
 
-	free_xid(xid);
+	rc = mount_setup_tlink(cifs_sb, ses, tcon);
+	if (rc)
+		goto error;
 
-	return mount_setup_tlink(cifs_sb, ses, tcon);
+	free_xid(xid);
+	return rc;
 
 error:
 	mount_put_conns(cifs_sb, xid, server, ses, tcon);
-- 
2.50.1

