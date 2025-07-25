Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5093B10FD
	for <linux-cifs@vger.kernel.org>; Fri, 25 Jul 2025 01:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753407271; cv=none; b=Tug6/VT6zCRXxqiPR43iB09c1JiYqY7c/mpfZiytNeY7HtKgQGOavoTVeHEh9lQhtxLBM3++FoZD3iC9Px0IYZD1hOGrFI8xXCesqNcJ+P1nTlvqGkyw/V3Cm4tgzSghlhSSGaNoG1yfqFOCOcETf92KT1XSRr1hfRSLyoytnRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753407271; c=relaxed/simple;
	bh=dAsPd6ceSda5XbNKffGM/MZJ4DsMLRFXv2slK0d/1EA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sfe2A6cvLLPe06866qsJ9ZYirVigxD3HAlwTbyuaOykQWboCtvBpTNKeKT2c4YR+yKQqJ+lgJWiY9n5m6R2G8uhB7X8gMHZesLOUVa5hPLvKL+7zFHaOxDfMjWeqIUqr414gFlvnRIXlUA1Ss7O8pkxZBSJn/nZS43nH67FJeAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235d6de331fso20282235ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 18:34:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753407269; x=1754012069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PAjSKBlJaxTaOouKoGP6lw8Xmc0vherv2oVUOPYPS5Y=;
        b=ZJus2xqRUc4kaW0t5gSuCA7RolkuVr8OwEuFKzVsfOnTRwYSyarz2Vu7+72fJ8CYsl
         PhX+E4diVVZG9Raxp8oMHTN0p/A7O4AFq/0CZPhY5jBcwCMe04bPvAR558hh108TGO1j
         1mhHkkrjV8jjxHIYHS0sYqX7g+IKqS/hSk0MCtMD8eJUMIiTdVjTpGcJf2WGd+vuHaWM
         2Ug1VsBMdv9rKhRQ7lI9oeeNudnGu6ENjSO4FNzSJbmvb6zZ8TqIMuJfN/Eu62JDS1Qs
         10hIh3EdKKeNv7paiLVRTkQYfuEoCut6Sol0LOPYXmdTPhA9prNTvucNdiXUnGL4ub9m
         8sTg==
X-Gm-Message-State: AOJu0Yxclzn6S22UlFVTb7HBE+8R5lb5eIDBGx9/FA6SCGLmGAvFO3+h
	mQ9b1R/GW3UvnT97xtjayN32FnaPUyJKEOUdLgQYpa4xmMnZKKOVMtoYwFW9AA==
X-Gm-Gg: ASbGncs1VVIjHOQf5fRvzln2OhM/C4dStNMbDNeoiDpp68kJiC7AbHRjxqCImu33h/H
	4IvS48KflxPYQll6inVcIyF008D2db5yKo6luYlFDLrpykF3zptuOYNo1ocsQACL7AmLJS4jG3L
	i8IFaTRaA3dKrFG3Tb/TBUCHf0xgMg2ixFzpKhWw6cdIXh4JkwRi7bm+Pbbyra5eWFlG3dXvJQz
	Dx4RMY4xxAia1W1ucJHtl0jZGKnBjnfi/lv7KiNZkBXaCBBuEw0223e77pWgpEYJdsKAcv7AJTY
	ju18uyn49GX0A9vYKKp9BisWMmkXljvh1bDko8rL6z8XIm7rfu5exVxDj4hJ6GiUWlQvh4rMwpq
	sV827b7SllSRZxtm2rDPe9LxjFo8r9GvlTtraJQ==
X-Google-Smtp-Source: AGHT+IGNLqzIpen4IWiAquSTzTd0XL1vaLw2J8pcQgrKPoKq3SvZmaqm6WcWn6dR9zkv+8TfxZ5/sg==
X-Received: by 2002:a17:903:2ac6:b0:23e:3249:612e with SMTP id d9443c01a7336-23fb30acc7emr1859055ad.34.1753407269110;
        Thu, 24 Jul 2025 18:34:29 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48dc988sm24832375ad.147.2025.07.24.18.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 18:34:28 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH] ksmbd: fix corrupted mtime and ctime in smb2_open
Date: Fri, 25 Jul 2025 10:34:07 +0900
Message-Id: <20250725013407.18039-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If STATX_BASIC_STATS flags are not given as an argument to vfs_getattr,
It can not get ctime and mtime in kstat.

This causes a problem showing mtime and ctime outdated from cifs.ko.
File: /xfstest.test/foo
Size: 4096            Blocks: 8          IO Block: 1048576 regular file
Device: 0,65    Inode: 2033391     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:cifs_t:s0
Access: 2025-07-23 22:15:30.136051900 +0100
Modify: 1970-01-01 01:00:00.000000000 +0100
Change: 1970-01-01 01:00:00.000000000 +0100
Birth: 2025-07-23 22:15:30.136051900 +0100

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 05ac2b14a7b1..2bd8cc20215a 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -553,7 +553,8 @@ int ksmbd_vfs_getattr(const struct path *path, struct kstat *stat)
 {
 	int err;
 
-	err = vfs_getattr(path, stat, STATX_BTIME, AT_STATX_SYNC_AS_STAT);
+	err = vfs_getattr(path, stat, STATX_BASIC_STATS | STATX_BTIME,
+			AT_STATX_SYNC_AS_STAT);
 	if (err)
 		pr_err("getattr failed, err %d\n", err);
 	return err;
-- 
2.25.1

