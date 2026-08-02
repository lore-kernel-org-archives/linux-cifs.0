Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE439B481
	for <linux-cifs@vger.kernel.org>; Sun,  2 Aug 2026 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785690557; cv=none; b=igU0qvfDr+fnb4IAnDQd64Q06ZYV7I1MfPkCeuKGsLBs0wMSNmaTm+YIEdxGYVo4d/oeEr3p/le7ZMGmAKhveecmfgYxawQMf5CaQjp6mluwIJ7nZMDBQCeedZTMhkX2SY0dVu3yTw9fgQ5KNAzjXRFCBNVZJain3vOh5DrbTis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785690557; c=relaxed/simple;
	bh=pxpxx2H0WjwaEj/k5tkEC/cDnUoeCfhFW6V+XB/cFH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX0HhykqhmL7jKg5V2Ray2vLPIQ8ldgExH6j0zuHuIK8OuKACA9nuk1tr7wl0JA+b2EKbNydD4alDFXOBupf7JAYlIWYu9+700cKg/YWx87FhuqVO4tS1dFDxe8OkLN9koNSLWRlL89Oe3vIBiU/pqDvc97cwkJROTa42qxalQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=BO9a7Woz; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="BO9a7Woz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785690552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIuaHpM9qAS5GZKH15B9TuknWWihyzdG4wf9dbN2kYA=;
	b=BO9a7WozQT50dngqLgoD2BLXvkh3QO4KS9DGwHTGD/bCT2bFh83IBIWWKZXbb4wgl9j+qJ
	7rsRA9mk6PCsXrd2NR/0pDR/2XJrZMQQKkE51hH03761J+IYkRGdc7Xe+wHQ7iT3Vv3LPK
	r/7Fhi4f2FI6sHPmGxGSATGjUJAXAYiSdk91UOYuKMp4l69++PHaqaGm4UzK2W65QizmzW
	dF0nH+Fxpsablj6wKlB2H9HKjx6g4ZxFUxqn/LCAlj0ltRLQklO0NL+fDACBvCEP64PiSR
	N6fwD0T+xjkmyec/uQqgmNsChlJXbRo53LCcQ77JzIUhhKY2t/VRY3a0PVP+Jw==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/2] smb/server: fix posix state check for directory rename
Date: Sun,  2 Aug 2026 17:07:57 +0000
Message-ID: <20260802170757.220862-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
References: <20260802170757.220862-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount -t cifs //${server_ip}/export /mnt # without posix option
  3. client: mkdir /mnt/dir1/; touch /mnt/dir1/file
  4. client: tail -f /mnt/dir1/file # open file
  5. client: mv /mnt/dir1 /mnt/dir2
             rename succeeded, but it was expected to fail with "Permission denied"

See POSIX-FSA 2.1.3.1.

work->tcon->posix_extensions only records whether POSIX extensions were
negotiated on the connection. It does not indicate that the handles
were opened with POSIX create contexts.

Fixes: c841bd3d8dec ("ksmbd: deny renaming directory with open children")
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs.c       | 3 +--
 fs/smb/server/vfs_cache.c | 2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 34975e18528c..28940c7b5f83 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -721,8 +721,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, struct ksmbd_file *old_fp,
 	if (err)
 		goto out_drop_write;
 
-	if (!work->tcon->posix_extensions && d_is_dir(old_child) &&
-	    ksmbd_has_open_files(old_fp)) {
+	if (d_is_dir(old_child) && ksmbd_has_open_files(old_fp)) {
 		err = -EACCES;
 		goto out3;
 	}
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index c66584ed23ab..eac9886eb6e3 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1152,6 +1152,8 @@ bool ksmbd_has_open_files(struct ksmbd_file *old_fp)
 			continue;
 		if (fp_dentry == dentry)
 			continue;
+		if (old_fp->is_posix_ctxt && fp->is_posix_ctxt)
+			continue;
 		if (is_subdir(fp_dentry, dentry)) {
 			ret = true;
 			break;
-- 
2.54.0

