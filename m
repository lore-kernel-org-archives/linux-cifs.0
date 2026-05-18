Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE49B37883E
	for <linux-cifs@vger.kernel.org>; Mon, 18 May 2026 15:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779117884; cv=none; b=M9UMP+YNrAlLa7GcwMXA8JxvpxMNySgmEV2oyYl017WoFHgcxTZ2isLEMhgb5TMsk91pCbgzz7liBdPayPUBxpjU6jemSPhUG3yu3RmdyeVWMWJY9+doUiH2M0FD+wGB/mXsiie7w//7KqXzzziluigmb44vNWISJaVMcqv9AAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779117884; c=relaxed/simple;
	bh=Uc4mXFYaTsrQTxwoBvMGOjX/IewTCtB6MsewK92hNck=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QAoCHfU35pTK+7L7eV72VxKw271Vdwdyef94E8G+LvPUSiE+4cfiI49V6dcQaBbE44GF6zf9GuQ9Ez2SryZhxXYaIszYedv5SDJclo47jo8sMnDRd6CA8IZCqdkvsPhG31St0vit/23Akfb2y9cgU9VSSNVbuSj6OBZqwEb1s/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=kzKDCkko; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="kzKDCkko"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779117876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gEqMeveuAUdnZdfz3ZrTgbkIZlyBo8trpu5h9dzLD9s=;
	b=kzKDCkkoD1CpL52NQlSyd3Jpo23Gs99zrFZtPry/At/kP1qdMpHnCMc+KsOXdohtGHzw9G
	Tg5EKN+GMUqlJGbBLq/vAnlNhuG3kcb3+x0JVYB8I4V6mI2TirzMPpwB3D1/C0KPd4osBL
	2y8jkLYaxfWMBtA3bOBlvuOt6709WhLUCkbg32NfVSg3nkmlbjp46j9i4EyQxeby/gfd86
	OuKV5himqp/UVCKo0z12UxLuLZ/RfX9j20po8XO7vUorY0117OaSSm2Emzs4rpdOYbCL2L
	TRqDl6jx8Mn8x+bp+nQGQasTMUM4Ipl3l5fhwVCmdcyc9QF6dyDj0FbIfI95bQ==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH] smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close
Date: Mon, 18 May 2026 15:23:22 +0000
Message-ID: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
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
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: C program: openat(AT_FDCWD, "/mnt", O_RDWR | O_TMPFILE, 0600)

Do not treat `FILE_DELETE_ON_CLOSE_LE` as delete pending while files
remain open.

This patch fixes xfstests generic/004.

Link: https://chenxiaosong.com/en/smb-xfstests-generic-004.html
Co-developed-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/vfs_cache.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 913164c958b1..5a232d94f567 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -211,7 +211,7 @@ int ksmbd_query_inode_status(struct dentry *dentry)
 		return ret;
 
 	down_read(&ci->m_lock);
-	if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
+	if (ci->m_flags & S_DEL_PENDING)
 		ret = KSMBD_INODE_STATUS_PENDING_DELETE;
 	else
 		ret = KSMBD_INODE_STATUS_OK;
@@ -227,7 +227,7 @@ bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 	int ret;
 
 	down_read(&ci->m_lock);
-	ret = (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	ret = (ci->m_flags & S_DEL_PENDING);
 	up_read(&ci->m_lock);
 
 	return ret;
@@ -395,12 +395,20 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 		}
 	}
 
+	down_write(&ci->m_lock);
+	/* Promote S_DEL_ON_CLS to S_DEL_PENDING when close */
+	if (ci->m_flags & S_DEL_ON_CLS) {
+		ci->m_flags &= ~S_DEL_ON_CLS;
+		ci->m_flags |= S_DEL_PENDING;
+	}
+	up_write(&ci->m_lock);
+
 	if (atomic_dec_and_test(&ci->m_count)) {
 		bool do_unlink = false;
 
 		down_write(&ci->m_lock);
-		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
-			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
+		if (ci->m_flags & S_DEL_PENDING) {
+			ci->m_flags &= ~S_DEL_PENDING;
 			do_unlink = true;
 		}
 		up_write(&ci->m_lock);
-- 
2.54.0

