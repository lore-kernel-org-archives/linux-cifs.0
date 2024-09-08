Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2387A17BA4
	for <linux-cifs@vger.kernel.org>; Sun,  8 Sep 2024 06:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725777482; cv=none; b=k0KGxTbIdMlR3gX2efNg66xvAa5Y+mBU6yLMxEyxqmOKCh9+sXgxTueR5ytEOj9Hxo4oBByexp4m25zkktwCZL09eR4Owbz4CmiF6hgqTgvBluqvvEVBJ4QxsUyBSdjZHjYemb60BfEAp2bK2RppbOSMxIio5dj6zna/VGbXRm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725777482; c=relaxed/simple;
	bh=6CisR0c4Y2cq7MiQKbp1BvSZRyFdcu9go/rKb/caYrE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Qd9C2R3hHJQ/oy07lkXWfb9PdR8IJfWSGzMgRoWyyo7YAc/i2dU4Icrf2HP7gp07CQNtAiA+QKJL7nLlM7nbxfbjTtCN0wqr5Xn9CB6MEpS5IJWf4mfLSaVWtZsbDkFe9YX9ayGpVsMJAR1B52QJpMOsgxZEi1NpWVW2xZ/YhOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-710da8668b3so542833a34.1
        for <linux-cifs@vger.kernel.org>; Sat, 07 Sep 2024 23:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725777480; x=1726382280;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yD6fQfbCLBt/dn52yj4eXMJZaBf7xX3PoTCUdpx26Fw=;
        b=eEvpTjcVJd5cIwchwNtZj7kCJ5AMyvsLNbrkrz7jTXw6KSWCwZHiU4cyPggvioEBxC
         OF5OP0E2eUDmYMK3lZm8gTTeffWefJyO+eoKPtWCfo4Vq5rrL++LX9bxnmAHoKuvJh8S
         15LuSWU9wlP8D69hrdOBBG4fkysF/hi+t+HVb+UjAlKeYdUlPAq3rFfXYiM9WOIDn1kY
         zAbhzmabagOX69qG3kXAHceNQYIq5ArgoOVgio9LcPL/JIiK8gLKL9kK6sxy8b2QVTIp
         tU0KTcGzsMZAIE1QDsmH6VGdbyTn9Wmk5nyszsH2GXFGvFTjlDs4w7H6IY7F6ABJBuOD
         6zuw==
X-Gm-Message-State: AOJu0YwkGh0lBofPORgLl0zCbDaN3zgiqP1wV9qEemYbAkZzVO36c/j4
	RVHUghCqWOqgPSLX4nCJ6tOA9rPgwlsGXFwlb95ncfDipaP3PyFn/+iC3Q==
X-Google-Smtp-Source: AGHT+IFOj8GmZq/IB+rMijOYRBaJICW/mqGlqcgg8tW7wb143PfSjxw+QtoMYI45FcJjmVE1w+CkDQ==
X-Received: by 2002:a05:6830:6310:b0:70c:9c66:af53 with SMTP id 46e09a7af769-710cc25d760mr9042670a34.25.1725777479857;
        Sat, 07 Sep 2024 23:37:59 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dadbfe46ecsm4342827a91.2.2024.09.07.23.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2024 23:37:59 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: handle caseless file creation
Date: Sun,  8 Sep 2024 15:37:40 +0900
Message-Id: <20240908063740.4455-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ray Zhang reported ksmbd can not create file if parent filename is
caseless.

Y:\>mkdir A
Y:\>echo 123 >a\b.txt
The system cannot find the path specified.
Y:\>echo 123 >A\b.txt

This patch convert name obtained by caseless lookup to parent name.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 13dad48d950c..7cbd580120d1 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1167,7 +1167,7 @@ static bool __caseless_lookup(struct dir_context *ctx, const char *name,
 	if (cmp < 0)
 		cmp = strncasecmp((char *)buf->private, name, namlen);
 	if (!cmp) {
-		memcpy((char *)buf->private, name, namlen);
+		memcpy((char *)buf->private, name, buf->used);
 		buf->dirent_count = 1;
 		return false;
 	}
@@ -1235,10 +1235,7 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 		char *filepath;
 		size_t path_len, remain_len;
 
-		filepath = kstrdup(name, GFP_KERNEL);
-		if (!filepath)
-			return -ENOMEM;
-
+		filepath = name;
 		path_len = strlen(filepath);
 		remain_len = path_len;
 
@@ -1281,10 +1278,9 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 		err = -EINVAL;
 out2:
 		path_put(parent_path);
-out1:
-		kfree(filepath);
 	}
 
+out1:
 	if (!err) {
 		err = mnt_want_write(parent_path->mnt);
 		if (err) {
-- 
2.25.1

