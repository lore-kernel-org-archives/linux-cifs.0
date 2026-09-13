Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71ED368D4D
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 23:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342095; cv=none; b=GjhTiPK061L7NS6hE78jOrOve5V+Aom3KreC97fakJ5F8zHY2BGtJjsqNC5hJs1Rc7g4sucO5CwSRUruVb1PuwdNpf3kcA29LcnHHrYelcf3cwljoBOgmRoC+4kio70MT7FSNY8av2y+78OgQIr3LzlWIAu5oIwWiM2DYobxoHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342095; c=relaxed/simple;
	bh=viO8eC3j9KzfPcV/j7y7/rzhZTYrpqYKvpKQLH8iVFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkxUlTVIFoeysW0gDCuhRlNOGb5KLAo3GD2BkkbZqJMbcY6jdbnnrNB2No9FPLQYELbTV5I972s40EQHMiLKXhLbaliwNAbzjbcoGel1Q4iP3wqVllcZ+tZhlcvl/fCfLhr4cIKwRnAhAY/WYewtvOdHlbrfhZ/sCHEYUP9qYQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rwmGfyiV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rwmGfyiV"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49e78adf099so3878095e9.2
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 16:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789342092; x=1789946892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LcgwgeosnRNV7PFECXXh2BBuUm7C27vyrwhZo1dTWRM=;
        b=rwmGfyiVjUS0H8ydm9Ub9s0NtDrDJRCnDCGsuehIbNecvs621kRq+erfIXE8DxFtn0
         gqZsUhtZ3xHeOSpUGvSym3MxUjtMRbPaQLJWYufuzRNKUH/7HN8coOHkoBh4CE/YhS+t
         ZGNYhOjU3z22JEMIaUCWGiioEErfuh2/ZSdsU/HXvkgOMuyP2J/EYwgOvQ9ArDRlkWBK
         qzBMEr2rP4mNKDOjZJZYG/zN9Bi+xQpuq47XBlzBk5zhPnip3RqR415/SEtLkLa+v3tr
         SF8AOwHNsMdVr9+gX9JyKfPr3xGu9+2Kkx5kBrYnpNkTb/srb064ybZ5KewZ4JzmedyA
         zD6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342092; x=1789946892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LcgwgeosnRNV7PFECXXh2BBuUm7C27vyrwhZo1dTWRM=;
        b=H38qH+l6tp7hf4l+pWDvQuD+04214sIfWhcY8aBg72uhD9XVZnBBUJavgQsKQX/Kq7
         sxxmTlPKcO7OzaGoQBnVOyndDNV1B55qSkMnm+VqW3D6Lr+ZMkRhMWsRoILicszn7ms+
         7zBrTacGx3s3yZepZVraBWY4WSQeZKbeALPaS39rnBdc5JWM9Ch4M3hSzTS6YgrKQd+r
         P3U5/Si/cqTPD9aABCxXw76eBhl3lV4w0ru+3MWbM269VtQ+Q+xUjimtmXSxnCijg40I
         P4X9tqA/Y/urhIuh2KV09x5dvDwGb0yB5Hrhgs5Je6vytEX1ucwGJVMvH4NSMR/q824l
         Ffwg==
X-Forwarded-Encrypted: i=1; AKwUvByL4C4R24uOK3FyhaT2vb2XUsCKJ9rn3o3zVbAI5Pvvk42VwVjski/8fGcjQ9osTn7OkIkT2Ud4oIyj@vger.kernel.org
X-Gm-Message-State: AFuF++n/JRVUpXuUA09q4c73HA0SQR3rbrZ97xDWPafN5SFX4MwkxYjr
	UL3m1qZE8FeN/FyYav7xOi/JZPSqmd60wvB+lh9K+wKAw/gtmqkhre0Q+EoYYg==
X-Gm-Gg: AYBFou0ELh3yzFJZbLXjob/t5D7nDW3eUuLP9e1R/ImlUSwjio8PCtlNfKLk8pmMJAh
	mE2qhtqA66S1TtDueP1dFLfzhg5V0ba8TanAXTT+S+DYFleDQKYsO2m1FnMznQS1+87bxMwjVLN
	ezA5blwcXl/a2BcRahjLXdTu8PLTAE/qxAKPvUuDcd2NjP6tDWBPBfwEXEhGTI9AccFseYPWjLb
	UiRgqbaMt3nNeEJxHAA9e78puRadQD+/uFi6tNBmOqfb+LPkrK2T2di7rUxvwH+eva7AVT1kcAY
	7gF09fXTp5+Ucp4ybsUGL+X6Sqa4xB5ZQjBxTJMUKMprvkwtDqAalwHvbozxTIRMfJ3ex+H8Grg
	cw+HxOPf9uYQqjjShAT8Rfae1wMuGETDjcHUvzQPO6Unxcv/hKULH+FMr1b9aqoE3P7rGW8GCfN
	TdPwhPoEceIjOLx3/VhLsv/dEzZlFXv7NozzhvTq/RdPpjsSpkmdjUb9aCQnqdDdCfteYp7VZML
	4V6u5wMRYQyuC1m9ikTUww=
X-Received: by 2002:a05:600c:4f54:b0:49d:15f8:2bdb with SMTP id 5b1f17b1804b1-49e7a63950dmr1160385e9.7.1789342091773;
        Sun, 13 Sep 2026 16:28:11 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm396657625e9.3.2026.09.13.16.28.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 16:28:11 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/4] ksmbd: copy stream content when renaming to a new stream name
Date: Mon, 14 Sep 2026 01:26:35 +0200
Message-ID: <20260913232737.51704-2-g.blivet@me.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913232737.51704-1-g.blivet@me.com>
References: <20260913232737.51704-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_rename() creates the target stream with
ksmbd_vfs_setxattr(..., NULL, 0, ...), so the source stream's content
is not carried over and renaming a named stream produces a zero-length
stream.

Read the source stream and write it under the new name. The lookup is
case-insensitive because smb2_set_stream_name_xattr() stores
fp->stream.name with the client's casing, which need not be the casing
on disk. A rename to the stream the handle already refers to does
nothing; that comparison is case-insensitive too, since every lookup in
this path is. A read failure now fails the rename instead of creating
an empty target, and a write failure reports its own errno rather than
-EINVAL, since writing a value can fail where writing an empty one
could not.

Initialize s_type, which parse_stream_name() assigns only when the name
carries an explicit stream type and which selects the target xattr
name.

parse_stream_name() leaves the stream name empty when the stream part
is, as in "::$DATA" or ":", returning NULL for the first spelling and
"" for the second. Return without creating an xattr in either case,
after the base name check so that a base ending in '/' is covered too.
These previously created xattrs named "(null)" and "".

The source xattr is left in place and fp->stream.name still refers to
it, as before this change: readers of that pointer take no lock, so it
cannot be swapped here.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
---
 fs/smb/server/smb2pdu.c | 35 ++++++++++++++++++++++++++++++-----
 fs/smb/server/vfs.c     |  6 +++---
 fs/smb/server/vfs.h     |  3 +++
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2af4c8e36721..d5def8a3becc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8026,9 +8026,11 @@ static int smb2_rename(struct ksmbd_work *work,
 		return PTR_ERR(new_name);
 
 	if (fp->is_posix_ctxt == false && strchr(new_name, ':')) {
-		int s_type;
+		int s_type = 0;
 		char *xattr_stream_name, *stream_name = NULL;
+		char *stream_buf = NULL;
 		size_t xattr_stream_size;
+		ssize_t stream_buf_len = 0;
 		int len;
 
 		rc = parse_stream_name(new_name, &stream_name, &s_type);
@@ -8042,6 +8044,10 @@ static int smb2_rename(struct ksmbd_work *work,
 			goto out;
 		}
 
+		/* An empty stream name is the base file's default stream. */
+		if (!stream_name || !stream_name[0])
+			goto out;
+
 		rc = ksmbd_vfs_xattr_stream_name(stream_name,
 						 &xattr_stream_name,
 						 &xattr_stream_size,
@@ -8049,15 +8055,34 @@ static int smb2_rename(struct ksmbd_work *work,
 		if (rc)
 			goto out;
 
+		/* A handle opened without a stream has no source to copy. */
+		if (ksmbd_stream_fd(fp)) {
+			if (!strcasecmp(xattr_stream_name, fp->stream.name)) {
+				kfree(xattr_stream_name);
+				goto out;
+			}
+
+			stream_buf_len = ksmbd_vfs_getcasexattr(file_mnt_idmap(fp->filp),
+								fp->filp->f_path.dentry,
+								fp->stream.name,
+								fp->stream.size,
+								&stream_buf);
+			if (stream_buf_len < 0) {
+				rc = stream_buf_len;
+				kfree(xattr_stream_name);
+				goto out;
+			}
+		}
+
 		rc = ksmbd_vfs_setxattr(file_mnt_idmap(fp->filp),
 					&fp->filp->f_path,
 					xattr_stream_name,
-					NULL, 0, 0, true);
-		if (rc < 0) {
+					stream_buf, stream_buf_len, 0, true);
+		kfree(stream_buf);
+		if (rc < 0)
 			pr_err("failed to store stream name in xattr: %d\n",
 			       rc);
-			rc = -EINVAL;
-		}
+
 		kfree(xattr_stream_name);
 		goto out;
 	}
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 3a6f3139c6f5..c2bd972261c6 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -217,9 +217,9 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 	return err;
 }
 
-static ssize_t ksmbd_vfs_getcasexattr(struct mnt_idmap *idmap,
-				      struct dentry *dentry, char *attr_name,
-				      int attr_name_len, char **attr_value)
+ssize_t ksmbd_vfs_getcasexattr(struct mnt_idmap *idmap,
+			       struct dentry *dentry, char *attr_name,
+			       int attr_name_len, char **attr_value)
 {
 	char *name, *xattr_list = NULL;
 	ssize_t value_len = -ENOENT, xattr_list_len;
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 55d099de71f5..2c53ca5bed7e 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -108,6 +108,9 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 			   struct dentry *dentry,
 			   char *xattr_name,
 			   char **xattr_buf);
+ssize_t ksmbd_vfs_getcasexattr(struct mnt_idmap *idmap,
+			       struct dentry *dentry, char *attr_name,
+			       int attr_name_len, char **attr_value);
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
 				int attr_name_len);
-- 
2.53.0

