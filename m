Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085E81F4723
	for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2024 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730298528; cv=none; b=Yl6UFGCGhk86oOa2FY2XXX9UlOzehx0eotJHw9wSeiI1eJTYjEvnHNSug3sHCKI3Zab47gV9xnPNEsY9QwD4eBSdzmqGaEflWzcdrMyGFjxVP8YCdL8bFCHXoBsPF0E+JmSRKm3FkRSdofrkzcdJdPSuIkhmfFWtgoXPqeO6/qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730298528; c=relaxed/simple;
	bh=smVq5JZBQM0z49fiSOIirouvIKCNhjDVWYfeyIGteFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sv5BqH7SH7dMtE0ABRn5DXS6n6403YdlpaF4T4jbbikfiefFWG1gB0Kj9R6DOLgfT2iJUxVimVxWvZtixBLE0qFarKyMzJ7M7t+KiVtDmvV1DYyUavW23+qe5q2GPUwVGSGTkCKctp4tsSQJPwVzwqCjaC2l2I9waZNXgZeED0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QB4iWUId; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QB4iWUId"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71ec997ad06so4824412b3a.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Oct 2024 07:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730298525; x=1730903325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dpowo321Czo3qutNIrBLTm3hFebIsCuqLsf6alPI15w=;
        b=QB4iWUId0cXXwJ2S2indxWdoMMnH/aO8rcNydcEQ3qNF7FKB+SeswUOz+qJ8+1mRQs
         LdYvUiqzpUwxBiYMvUwRVv4wg9c3PSFOCv1IQ2fDUUdEG9Inz+pDZKoCk+yjQkL5KGNi
         gI4VESjxWnYQoMEtA/HJZLqj7eOV6L1aoQjJE92QJTQamgvbsxYvGg0anPtXNNKlUF8N
         +F2juv2CqZXJldOsKXdIgimFmUzd0ZPGcPMnezfRjIdvs2zCX2qqvIVdP9ERd/xV5TIq
         GvyCqzs6Ld5TxF8saD35qzFgrEEBE5UZjuPC4Yyr/5h902dBiD07zXG50pKTSonKI/SQ
         EXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730298525; x=1730903325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dpowo321Czo3qutNIrBLTm3hFebIsCuqLsf6alPI15w=;
        b=mCc/15m8bsIoszvBH3k9RPr48yn5hR854nuUbh6ZRz/AxoNru/ORxhWsGgzp37ZUJN
         LyLvxB7jLJvUkhFcdT9C3NvtuGkJGSBfAJosi3EcKritPPClJtSp5RYr6ESByXGjv680
         4NIdWt9zCMclNyjXx1rbjm9XCWYTmwkS/dtKIaZ9VEEIEpAupzFYMr+cqcH+qMPjhItw
         xl5oBXT66zBq70Moa5B9bOxj93XIQQEPl6k1nwRmKrYKv4kN3TtvwB8nIRmKyCdqYkGw
         jOLB3J9Fq8tdvmu1ZhhKXdRH5C6aLeIQlduAFerw6lwEGkWGsL5C4MT4k5Ym+uaqmJBW
         BSyw==
X-Forwarded-Encrypted: i=1; AJvYcCWlsHZgFzoCFpCdF5LIauLx0rYkkcDxYFinDXaDgJDjL3tpTMVn0gxkdn902oThlW1d6JR40Vibqarl@vger.kernel.org
X-Gm-Message-State: AOJu0YzA3T8ER0BHZ32kBJfR5e2+lNE3p7JKtfRNzw3I0Fk9EMPyq2AK
	/mF674/KaF4hKnQ61WTjlcA3t1ZQ24qn0QHgIFrFElE3lajzmZmU
X-Google-Smtp-Source: AGHT+IH/rhrhOtPtcadY2c8HXltXWINicD7NASIJypyaPoMuFI7DeSr0qyE9YGf0taV2fLwBRrWq9g==
X-Received: by 2002:a05:6a00:1410:b0:71e:702c:a680 with SMTP id d2e1a72fcca58-720ab4c5d79mr4056262b3a.26.1730298525180;
        Wed, 30 Oct 2024 07:28:45 -0700 (PDT)
Received: from met-Virtual-Machine.. ([167.220.2.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057932c62sm9304890b3a.45.2024.10.30.07.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 07:28:44 -0700 (PDT)
From: meetakshisetiyaoss@gmail.com
To: smfrench@gmail.com,
	sfrench@samba.org,
	pc@manguebit.com,
	lsahlber@redhat.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 1/2] cifs: during remount, make sure passwords are in sync
Date: Wed, 30 Oct 2024 10:27:57 -0400
Message-ID: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

We recently introduced a password2 field in both ses and ctx structs.
This was done so as to allow the client to rotate passwords for a mount
without any downtime. However, when the client transparently handles
password rotation, it can swap the values of the two password fields
in the ses struct, but not in smb3_fs_context struct that hangs off
cifs_sb. This can lead to a situation where a remount unintentionally
overwrites a working password in the ses struct.

In order to fix this, we first get the passwords in ctx struct
in-sync with ses struct, before replacing them with what the passwords
that could be passed as a part of remount.

Also, in order to avoid race condition between smb2_reconnect and
smb3_reconfigure, we make sure to lock session_mutex before changing
password and password2 fields of the ses structure.

Fixes: 35f834265e0d ("smb3: fix broken reconnect when password changing on the server by allowing password rotation")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/fs_context.c | 69 +++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 5c5a52019efa..73610e66c8d9 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -896,6 +896,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	int rc;
 
@@ -915,21 +916,71 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
+
 	if (need_recon == false)
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
 	else  {
-		kfree_sensitive(ses->password);
-		ses->password = kstrdup(ctx->password, GFP_KERNEL);
-		if (!ses->password)
-			return -ENOMEM;
-		kfree_sensitive(ses->password2);
-		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
-		if (!ses->password2) {
-			kfree_sensitive(ses->password);
-			ses->password = NULL;
+		if (ctx->password) {
+			new_password = kstrdup(ctx->password, GFP_KERNEL);
+			if (!new_password)
+				return -ENOMEM;
+		} else
+			STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
+	}
+
+	/*
+	 * if a new password2 has been specified, then reset it's value
+	 * inside the ses struct
+	 */
+	if (ctx->password2) {
+		new_password2 = kstrdup(ctx->password2, GFP_KERNEL);
+		if (!new_password2) {
+			if (new_password)
+				kfree_sensitive(new_password);
 			return -ENOMEM;
 		}
+	} else
+		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
+
+	/*
+	 * we may update the passwords in the ses struct below. Make sure we do
+	 * not race with smb2_reconnect
+	 */
+	mutex_lock(&ses->session_mutex);
+
+	/*
+	 * smb2_reconnect may swap password and password2 in case session setup
+	 * failed. First get ctx passwords in sync with ses passwords. It should
+	 * be okay to do this even if this function were to return an error at a
+	 * later stage
+	 */
+	if (ses->password &&
+	    cifs_sb->ctx->password &&
+	    strcmp(ses->password, cifs_sb->ctx->password)) {
+		kfree_sensitive(cifs_sb->ctx->password);
+		cifs_sb->ctx->password = kstrdup(ses->password, GFP_KERNEL);
+	}
+	if (ses->password2 &&
+	    cifs_sb->ctx->password2 &&
+	    strcmp(ses->password2, cifs_sb->ctx->password2)) {
+		kfree_sensitive(cifs_sb->ctx->password2);
+		cifs_sb->ctx->password2 = kstrdup(ses->password2, GFP_KERNEL);
+	}
+
+	/*
+	 * now that allocations for passwords are done, commit them
+	 */
+	if (new_password) {
+		kfree_sensitive(ses->password);
+		ses->password = new_password;
+	}
+	if (new_password2) {
+		kfree_sensitive(ses->password2);
+		ses->password2 = new_password2;
 	}
+
+	mutex_unlock(&ses->session_mutex);
+
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
-- 
2.46.0.46.g406f326d27

