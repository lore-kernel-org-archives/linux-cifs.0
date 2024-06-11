Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9B05336D;
	Tue, 11 Jun 2024 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718116951; cv=none; b=vESlw8VKDI2xpDqcbRjNecvsV/1Ei2wCJNN6koLHqFZqHhBSflr5p6DzfyhYiSuYSnjy2WYTAOOYNOdFZ4ocyrlqgs4CzYH0EKyKG+DoKoXCsWEexHsW7Tk85wifJ/crd8rptMMQhg2XLQ63iGNMP0/IDPlNWWcM+hvAy4p5Ghc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718116951; c=relaxed/simple;
	bh=jboeQ8nuXofiKGnAVVqFgVrGBESzCeHoA1Ouj+vGIOs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XwSvD5Nb6ygoPXP0jMQ+kIjfUB2L9uwwKJeh4YePOkyYcoILp2ZTM9NcoaowwwHm9GuJXgTSiT35vCZgl4i+890yl6dICJQiENfBHhiLTG47DwfsEDYu/Bsq5yS2qSfi2LB+NCB1+GWBrYx1FwUI4PbsHP6t8F2P3Bs23NGd1YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6c53a315c6eso4301057a12.3;
        Tue, 11 Jun 2024 07:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718116949; x=1718721749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9KDw44L8SS8YIgF73KlJ2tVSxG5HB3488LWyU9PuNc0=;
        b=d2bW/Xaxw3H8/gIs+n5ONYYE81+z+/c0hi5bD1pz1K8HEvxZmJIFivVXPRVkpSqrU+
         Kyvih+H43fd8vRjCc+e2lZr503GIrseCaDA+eLw0C7nvKYvLMEdpRoQk4hiTXRcjyQgo
         rKqLNPxZpiOJwtnHurg7fJucRTMdngZr9xe/c5c7qh7kzeY+SNtKeNukiOqLEmcCrHWa
         4wzMsRSkunooMyoo4JGkVzsfGYdUlTkEd6GqBxInr9YD/zxQvPXbQ0qKjIw0hwecIen2
         7j5W291fkw1H55M8WKoOFNxAcN3fYygAUjayiIBc7/qqERtxWK1erBHkrnigrAE6umqO
         nu8A==
X-Forwarded-Encrypted: i=1; AJvYcCV2mKr/0/wIHJFEA8buU5LacdBYMsQwap4RCRbhJzjvZdvPR0R72Am1TUaqUvGQYa+Lm4cdXckTWqfOwHiKqx61586+aP/u
X-Gm-Message-State: AOJu0Yx3GtHVwMMZT1wSRJmrVDOTXbamy2iu2fJKQb3U6coo0fmQEr8m
	Y9TW+jh1Xbo2CZgRQXl7bu/wsIo3YdfJ/JOYLq8mKqE4ACjjMKohL73wZA==
X-Google-Smtp-Source: AGHT+IHK7cBj6XJKH7EDR3Yu8OKQ6czBvrr+yRC2WQyOtdhqUWeL2K65L0YWR04/4toBOj0dXPHOmA==
X-Received: by 2002:a05:6a21:1518:b0:1af:bd03:3222 with SMTP id adf61e73a8af0-1b2f9c89fd2mr14256522637.45.1718116949331;
        Tue, 11 Jun 2024 07:42:29 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70598c98443sm3424679b3a.180.2024.06.11.07.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 07:42:29 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org,
	Wang Zhaolong <wangzhaolong1@huawei.com>
Subject: [PATCH] ksmbd: fix missing use of get_write in in smb2_set_ea()
Date: Tue, 11 Jun 2024 23:41:59 +0900
Message-Id: <20240611144200.22118-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix an issue where get_write is not used in smb2_set_ea().

Fixes: 6fc0a265e1b9 ("ksmbd: fix potential circular locking issue in smb2_set_ea()")
Cc: stable@vger.kernel.org
Reported-by: Wang Zhaolong <wangzhaolong1@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   |  7 ++++---
 fs/smb/server/vfs.c       | 17 +++++++++++------
 fs/smb/server/vfs.h       |  3 ++-
 fs/smb/server/vfs_cache.c |  3 ++-
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8bcede718c21..63a41193f6e6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2367,7 +2367,8 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 			if (rc > 0) {
 				rc = ksmbd_vfs_remove_xattr(idmap,
 							    path,
-							    attr_name);
+							    attr_name,
+							    get_write);
 
 				if (rc < 0) {
 					ksmbd_debug(SMB,
@@ -2382,7 +2383,7 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
 		} else {
 			rc = ksmbd_vfs_setxattr(idmap, path, attr_name, value,
 						le16_to_cpu(eabuf->EaValueLength),
-						0, true);
+						0, get_write);
 			if (rc < 0) {
 				ksmbd_debug(SMB,
 					    "ksmbd_vfs_setxattr is failed(%d)\n",
@@ -2474,7 +2475,7 @@ static int smb2_remove_smb_xattrs(const struct path *path)
 		    !strncmp(&name[XATTR_USER_PREFIX_LEN], STREAM_PREFIX,
 			     STREAM_PREFIX_LEN)) {
 			err = ksmbd_vfs_remove_xattr(idmap, path,
-						     name);
+						     name, true);
 			if (err)
 				ksmbd_debug(SMB, "remove xattr failed : %s\n",
 					    name);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 51b1b0bed616..9e859ba010cf 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1058,16 +1058,21 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 }
 
 int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
-			   const struct path *path, char *attr_name)
+			   const struct path *path, char *attr_name,
+			   bool get_write)
 {
 	int err;
 
-	err = mnt_want_write(path->mnt);
-	if (err)
-		return err;
+	if (get_write == true) {
+		err = mnt_want_write(path->mnt);
+		if (err)
+			return err;
+	}
 
 	err = vfs_removexattr(idmap, path->dentry, attr_name);
-	mnt_drop_write(path->mnt);
+
+	if (get_write == true)
+		mnt_drop_write(path->mnt);
 
 	return err;
 }
@@ -1380,7 +1385,7 @@ int ksmbd_vfs_remove_sd_xattrs(struct mnt_idmap *idmap, const struct path *path)
 		ksmbd_debug(SMB, "%s, len %zd\n", name, strlen(name));
 
 		if (!strncmp(name, XATTR_NAME_SD, XATTR_NAME_SD_LEN)) {
-			err = ksmbd_vfs_remove_xattr(idmap, path, name);
+			err = ksmbd_vfs_remove_xattr(idmap, path, name, true);
 			if (err)
 				ksmbd_debug(SMB, "remove xattr failed : %s\n", name);
 		}
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index cfe1c8092f23..cb76f4b5bafe 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -114,7 +114,8 @@ int ksmbd_vfs_setxattr(struct mnt_idmap *idmap,
 int ksmbd_vfs_xattr_stream_name(char *stream_name, char **xattr_stream_name,
 				size_t *xattr_stream_name_size, int s_type);
 int ksmbd_vfs_remove_xattr(struct mnt_idmap *idmap,
-			   const struct path *path, char *attr_name);
+			   const struct path *path, char *attr_name,
+			   bool get_write);
 int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			       unsigned int flags, struct path *parent_path,
 			       struct path *path, bool caseless);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 882a87f9e3ab..3bf1b3fb6ec8 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -262,7 +262,8 @@ static void __ksmbd_inode_close(struct ksmbd_file *fp)
 		ci->m_flags &= ~S_DEL_ON_CLS_STREAM;
 		err = ksmbd_vfs_remove_xattr(file_mnt_idmap(filp),
 					     &filp->f_path,
-					     fp->stream.name);
+					     fp->stream.name,
+					     true);
 		if (err)
 			pr_err("remove xattr failed : %s\n",
 			       fp->stream.name);
-- 
2.25.1

