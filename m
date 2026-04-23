Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B00194C96;
	Thu, 23 Apr 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776952973; cv=none; b=kU9CKLi0M93oLCR6HKf70K97j6zSy2eciwPZ7NhI+WZqeKaS4jcrYwMsBPGiyzuhdxfSrckWqGrX73blvuPz8Q2cqHWkv7GQPpfdgkCfjvA7y8MClG5fc+b7O8fGk+53Znnit8k4Cu9GXCpo4cUD/GsJqmoj5YtSURi7ByUvZSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776952973; c=relaxed/simple;
	bh=N6ElxsER6+0Y62WC5jN8bk+IWLyIvM7A0v5OKiLyzKE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qWRPcmMcChtKlKCC6pIDZnD6KjMlqwUs4snF4oV8EJ5wgi3MjhYtOmw6JICCFnCsJXklTxnNdV2dfBxd8/iF0e6P5NBqUNp0CbIwn1CsXrc4ABgR69N7G12OoyutGpSCUOwhT/AE4fMyhinUPV2B8+lq4gbYjffvJCBeFtBJMXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.malta.altlinux.ru (obninsk.basealt.ru [217.15.195.17])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 86D1A233A4;
	Thu, 23 Apr 2026 17:02:45 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: stable@vger.kernel.org
Cc: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH v2 5.10.y] cifs: Fix connections leak when tlink setup failed
Date: Thu, 23 Apr 2026 17:02:45 +0300
Message-Id: <20260423140245.195039-1-kovalev@altlinux.org>
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
  c88f7dcd6d64); additionally NULL out mntdata after dfs_cache_add_vol()
  transfers its ownership to vol_list, otherwise the new error path from
  mount_setup_tlink() failure would double-free it via kfree(mntdata) in
  the error: label ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
v2: address mntdata double-free flagged by sashiko-bot review [1].
  - NULL out mntdata after dfs_cache_add_vol() in the DFS branch of
    cifs_mount(); otherwise the new goto error from mount_setup_tlink()
    failure hits kfree(mntdata) in the error: label while the pointer
    is already owned by vol_list (vi->mntdata set in dfs_cache_add_vol).

  The second concern raised by sashiko-bot (UAF on
  cifs_sb->origin_fullpath via cifs_kill_sb()) does not apply to 5.10.y:
  cifs_smb3_do_mount() handles cifs_mount() failure via the out_free
  label, which kfree()s cifs_sb directly without calling cifs_umount(),
  so the kfree(cifs_sb->origin_fullpath) in the error: label is the
  only release on this path and must stay.

  [1] https://sashiko.dev/#/patchset/20260421132612.38517-1-kovalev%40altlinux.org

v1: https://lore.kernel.org/all/20260421132612.38517-1-kovalev@altlinux.org/

 fs/cifs/connect.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 769c7759601d..3ce86a88fad4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4770,6 +4770,8 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	rc = dfs_cache_add_vol(mntdata, vol, cifs_sb->origin_fullpath);
 	if (rc)
 		goto error;
+	/* mntdata is now owned by vol_list */
+	mntdata = NULL;
 	/*
 	 * After reconnecting to a different server, unique ids won't
 	 * match anymore, so we disable serverino. This prevents
@@ -4786,9 +4788,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
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
@@ -4820,9 +4826,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
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

