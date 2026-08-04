Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1BD39DBC0
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 23:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785886981; cv=none; b=UzkhkC48E83uaKDbDT4qz3q6KkhJdSNZEHCwB66noda129GL4LlJeh0Hi4aKhCU9KC08pRpOWZdCNoxiQ36iITLm5mitb6xkEBXGfmqW8JWA1FKWERcOjIgIxlPEmvZD5Bwd0c/yzF7HJwAlPzqbr1Www21Z0KBjbSIR8qep8GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785886981; c=relaxed/simple;
	bh=WuQVmx2YnUI4XvhVejvYUutWQl5B/NxiBuax2awOuhM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gon8vJGwRd9Gq4GuHX5RokTqMaqeKKCJyhWVQzBt7ZsyijLu9H/3sJCB8B0SfjqxZzkQ9girFT/9oYQf1jMdHjtxp2NY4jwA+QnlDO2DGAuubMYR8s+JQ6z4B3hsq9ltGVRDird0IXPC9QR2+m44lRkkw77CjptkZoQAYOdQAuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mFPw0BO/; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mFPw0BO/"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6ae50ba83efso808963eaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 16:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785886978; x=1786491778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U+3ZwEjHNgAhP32u/xYJ8H0EA8bkhzbEo28sF+uqMsM=;
        b=mFPw0BO/sLzGl4M4HTBpMDjFnXKFXzUe/rK5wLzIpu7kzkA2P4cXzCcF9wuiqclnow
         YVz6pe4PjdPJ4XOf99W+s8uSQcs4AtJVyGuODV4JgemhXNbBTb+GSuhHnlmlGEqvgark
         Bt1JAMH9sPWL3igdZF/21M+FXlSHQ0nZiYQJ02mf6B+muvwUizrePm27T3vRfs6NGTgp
         9ajSsOzzd17W70P9M/BrAjGgKX4cGjz4+55P/2LScg0AkQ5EQkolUzRfpJu5Odupz6Ov
         IOZ54quCI0gqOno9ekujqyeoBRsiU7mIXZvFU9nUhhASTAhO0iqpC85E3vbr42TY1b3N
         ZvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785886978; x=1786491778;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+3ZwEjHNgAhP32u/xYJ8H0EA8bkhzbEo28sF+uqMsM=;
        b=DvhRgPd+35cjfhy2TWXCBB8GWMANxiP9A2OHw3198gwBlZhrnlqpnPe7lsKUpA11I4
         TKdK0vaNXqNYx/62HPEX5RyAccT4aDT25RaTiMOgbgxhREv/tUBeqzI99SvTeegi5smk
         qbgQo09Vvv3pweG5rAa1OvHrH24mCde8K5m/0KY81sqLAtcblbERo/zuJ+l1KUNBl9Wx
         WboygsGzwuk74WvYDcK6dSHLSx35kQe7hbx6sM7sop9rV8Rdk7rYkmYJuN8xe/nj/Em2
         mcCByRrcBrtLfrfLjT4PN5LHJjbOA8rwTiLhGkB7OpFvPwd/cX0t/RX8RlZA6KUBseB4
         gwVw==
X-Gm-Message-State: AOJu0YxsQCRzRuYZIHxzHXPKpm/mOlefghxw1CL27bzxJnIoaAbw48PI
	sJbw4xR7MMv7zsSk/TbjpImerNnNpobred2Hg2vFTtHP4KSlYDGpU4o3LH+8ew==
X-Gm-Gg: AR+sD12kL8LvDp4gvfxSMSAnISYaGYnd2GiGDplJ6nqPL8kxsetwcTRh28qx/7XCN8z
	q2Bz61xIgnkApbnLxqaKsN+QyNv9qqdniPudnobXXoz/x9xH/0MhB5MrSHHo9vM17H8w21VNTTT
	kmSq0npGSOX4L5szdFRCtdCW8GO2E0iGFrPMLOXLDWOyPjF+H3qNhnHOj39n/xvsBTIoUIpL2fc
	vF2v1zIg4YRGMBowhg0+VL41kTT5r1YsZIBXX31+QouiOrZIzRKvzMn6/Banzn91016eA2YwVFY
	ZF85Ak0Mh7l0f1A/KzNOcg2B4jJCJPdckd9hCNLN9r1EJWWrFla1/byA0TTrWdmgY4+5OuT3plc
	DC7LX/Lqea2micwj3/m5m7pj8PTQ7Oom8+8OPiP2b5OZjsAh1NeGroU0mfu14dVoue9JIQ5xw81
	5qoSXoQ7/HhzexurBvmCbP2fj/eZK0zekPcWYA0fAuSPKZq/jh1c1AFjkbxwYJHy8awiDW6jn8x
	v0fWYvt/t7NKdG0aKq7xOcIed5lOy0Olv9Pd79l462UlEdbOJ9DbqAIVgwW2FTifPx/hLYasyEf
	eLvNrlgDr8DuccHPHRuaa4Sd0HxvvTDual25M7TF5cyPblJPnfruDVI5ABHof+rfBg44xBJbIw=
	=
X-Received: by 2002:a05:6820:4d53:20b0:6ae:960e:d285 with SMTP id 006d021491bc7-6ae960f1087mr1537431eaf.15.1785886978314;
        Tue, 04 Aug 2026 16:42:58 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7204:d1ab:7afe:a6b])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4599e647973sm880971fac.16.2026.08.04.16.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 16:42:57 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH] smb/client: fix nlink of an overwritten open file
Date: Tue,  4 Aug 2026 18:42:05 -0500
Message-ID: <20260804234205.72986-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount with `posix` option
     mount -t cifs -o posix //${server_ip}/export /mnt
  3. client: touch /mnt/file1 /mnt/file2
  4. client: C program: int fd = open("/mnt/file2", O_RDONLY);
  5. client: C program: rename("/mnt/file1", "/mnt/file2");
  6. client: C program: struct stat stbuf; fstat(fd, &stbuf);
                        stbuf.st_nlink is 1, should be 0

This patch fixes xfstests generic/035 when mounted with `posix` option.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/inode.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b2806371bfde..1dc511272f2a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2648,11 +2648,8 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 	if (d_really_is_positive(target_dentry)) {
 		if (!rc) {
 			struct inode *inode = d_inode(target_dentry);
-			/*
-			 * Samba and ksmbd servers allow renaming a target
-			 * directory that is open, so make sure to update
-			 * ->i_nlink and then mark it as delete pending.
-			 */
+
+			/* Update the target link count after rename. */
 			if (S_ISDIR(inode->i_mode)) {
 				drop_cached_dir_by_name(xid, tcon, to_name, cifs_sb);
 				spin_lock(&inode->i_lock);
@@ -2663,6 +2660,10 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 				CIFS_I(inode)->time = 0; /* force reval */
 				inode_set_ctime_current(inode);
 				inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+			} else {
+				cifs_mark_open_handles_for_deleted_file(inode, to_name);
+				cifs_drop_nlink(inode);
+				inode_set_ctime_current(inode);
 			}
 		} else if (rc == -EACCES || rc == -EEXIST) {
 			/*
-- 
2.53.0

