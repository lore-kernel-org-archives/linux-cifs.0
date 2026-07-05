Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08F626CE39
	for <linux-cifs@vger.kernel.org>; Sun,  5 Jul 2026 21:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783286325; cv=none; b=G0j1u3wNvXnP6j1X0FsHeHJRZIflrFSpndBNMeOfLHx9ANYrnmEUUYWKuXdHfO6ALvWY5V7yL0aZZj+yTFNJAuUFWjTChugVUxhdr9Q4fjUoZmkVlfO2ZYg4o92GhZoyY74GtLXBc+/kPlRqy8ATDK8w9DzbKcgCA09ZPitET88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783286325; c=relaxed/simple;
	bh=aUYNEAVdai+ygfouiMi+IZBUZZWAYhtRGtIXLtuwouI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6jTdp83LH9tpvLdnTdX5T8hgFXm9kPKuMgZei7vCGqWlVs7r6YGUK+VIMjDz6JodsFMCuwT/nvqlQwaERkTCtmpy7FcHJZBJ3Zq+bHygccfVUq8RMQNNXqyNTZl46L9N7Tfg6t3OgUCdLJmPB3z9v5OtdJ9lsfk/JFiVX+KLi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W7IN+EUY; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W7IN+EUY"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4472500e25fso928145fac.1
        for <linux-cifs@vger.kernel.org>; Sun, 05 Jul 2026 14:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783286322; x=1783891122; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4dQUT2tdVMOycwrn7a6+qZLHB3wUzn6WU218JsH/EdA=;
        b=W7IN+EUYtbElu9O7ERGoutXiMyS2YHWLnqG2MC/DGxOoJvvBh0CtqCVKx37v0Hkbkp
         azcEBMdBeInPFmE/LGGYPHCom4nvLIJLxHvDx2cq3MAbgtHUFCmxKp6x1xINmTVPGwpV
         mDtNwcz/AstLPvs3Hf6sU9P24Z4Zo487qyCKzITYa+DgyzMga67xoaGj8uowAuG3OYDb
         v1y3PaGQc0oAAdN9dzDjphi+8sMz98iWb5MuijctVcKwnD/Oy/0YGlwR4c6MZYN/WqEu
         pn3h139C+goMHTg+VQe+z0Guk1rVYR4wWwgOkxxw+96cJkGkNEXYXF/hzf4KSulVdedX
         GanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783286322; x=1783891122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dQUT2tdVMOycwrn7a6+qZLHB3wUzn6WU218JsH/EdA=;
        b=fA+RUEKhFigHhR2jlCGbcxyls5njGWpOcrAnBHnNYe8BsLLspof0G5JA9+W9eufGyp
         cHiF5Wk87VMmPCH2kHqu8VdqOM1HL0C8ybCJDBNj7sfQ1/yIL9OUdqCpka6iL8XJ3ZUH
         L8jf8xn3a7u6WATOeq4o5gpzOPwh3QfnxUSk05p2/5HpNJFQZTVqkxDwlE0vJvGoCnCW
         u3EhbHTy5+CrC3s6etiDELKikIK2MOLgJO+cgUwutKZyeZkmW/9YOpXkC7fi6n4JGtRu
         2vCEoJV40Xczb+y/9be7LaWrBFfGfnYlfCuQve+fnAI5z8Gk7yuUye2ZHr2JkpGMGLtw
         TirA==
X-Gm-Message-State: AOJu0YwJkURyHTnoT2+AtFkIj7CUaLtTOjFiUm6cAmhNiwD5f16E+DVa
	ZDkVxtlmSJ43JEsmij19hqyfQSTzwWOULZzM6JMgHxcwdEgspdb0q0PuoqTv8A==
X-Gm-Gg: AfdE7cme15F4rzxckalg389ok2OqgKy8YenxBUItmltPa/PV1y0dJZv80Z78lE3VYUU
	QbGZrGpnHYflBZzIvWpmtwFlC1GLQ6rX/DozS0TBUDkXHjxFas3biX3Itwo9nGeyiOtdJS54ikI
	KLy7Ana92nSVUNwbmGV3XwYA4ByXJqe9y2jGQn2Swrm3/XWT/zHgPlqWOmgjztZKCKlP0U4z09A
	GtUjJYxfGPnE9sZEko88IND038QmECz2cXBFzDPm4iP2AxOuQXwO6cuOAF1nyl9m2Odkzbjdg/a
	G7oEwT1DdF09PgigpvoPmB5pG4ZrJLMda4dzc29Ig1sNUrifNr0NV3ZmbTuuI3qBHWFdi44ifz5
	tbaGhYe1NVtwBRyJUlB6IMQWaEGhWCbb4fpN3VOgSHghyBk3ZRV7RqvYB5+0AsPWQ6j3mNOjZHf
	PfwaMVjDWz4znHlXp9OwPhECofDy8sxYX9NZB1m9Sz3qjW04Ktf6MQw3Mz6pU+Mja9qelNRcU00
	5BZaPex1dgborQ1Uu9yiUshj5nzYFncgGuCW05cxC4ZQnx/HmjqlsjaH2FM/lpB4sNbozYhNx0u
	V1kSL+KV1IUQu+qSwjjPduvkyA==
X-Received: by 2002:a05:6808:309b:b0:497:da7f:179f with SMTP id 5614622812f47-499b9f18d80mr5474305b6e.20.1783286322529;
        Sun, 05 Jul 2026 14:18:42 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:bd6:647c:82f8:c548])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-497d17d328bsm8641513b6e.4.2026.07.05.14.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 14:18:41 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Steve French <stfrench@microsoft.com>
Subject: [PATCH v2] smb: client: preserve leading slash for POSIX absolute symlink targets
Date: Sun,  5 Jul 2026 16:17:57 -0500
Message-ID: <20260705211757.60659-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating a native SMB symbolic link (CIFS_SYMLINK_TYPE_NATIVE) whose
target is an absolute path on a mount that uses POSIX paths, the leading
path separator was silently dropped from the stored symlink target.

create_native_symlink() converted the target to UTF-16 with
cifs_convert_path_to_utf16().  That helper is intended for share-relative
SMB paths and therefore unconditionally strips a leading path separator.
For an absolute POSIX symlink target the leading '/' is significant, so a
target of "/foo/bar" was stored - and read back - as "foo/bar", even
though the reparse point was still flagged as absolute
(SYMLINK_FLAG_RELATIVE cleared).

On a POSIX paths mount the symlink target is stored verbatim, so convert
it directly with cifs_strndup_to_utf16() instead.  This preserves the
leading separator, avoids the leading-backslash stripping that
cifs_convert_path_to_utf16() also performs (a backslash is a valid POSIX
filename character), and uses NO_MAP_UNI_RSVD to match the readback path
in smb2_parse_native_symlink(), which always converts the target with
cifs_strndup_from_utf16() / NO_MAP_UNI_RSVD.  This mirrors how the NFS and
WSL reparse symlink creators convert their targets.

The NT-style absolute symlink handling, which needs the "\??\" prefix and
drive-letter colon preserved, continues to use cifs_convert_path_to_utf16()
together with the existing masking of those bytes.

Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/reparse.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index cd1e1eaee67a..5cc5b0410d48 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -67,6 +67,7 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	char *sym = NULL;
 	struct kvec iov;
 	bool directory;
+	int path_len;
 	int rc = 0;
 
 	if (strlen(symname) > REPARSE_SYM_PATH_MAX)
@@ -168,7 +169,21 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/')
 		sym[0] = sym[1] = sym[2] = sym[5] = '_';
 
-	path = cifs_convert_path_to_utf16(sym, cifs_sb);
+	/*
+	 * On a POSIX paths mount the symlink target is stored verbatim, so
+	 * convert it with cifs_strndup_to_utf16().  cifs_convert_path_to_utf16()
+	 * must not be used here: it strips a leading path separator (it is
+	 * meant for share-relative SMB paths), which would corrupt an absolute
+	 * POSIX symlink target such as "/foo/bar".  Using NO_MAP_UNI_RSVD also
+	 * matches the readback path in smb2_parse_native_symlink().
+	 */
+	if (sbflags & CIFS_MOUNT_POSIX_PATHS)
+		path = cifs_strndup_to_utf16(sym, strlen(sym), &path_len,
+					     cifs_sb->local_nls,
+					     NO_MAP_UNI_RSVD);
+	else
+		path = cifs_convert_path_to_utf16(sym, cifs_sb);
+
 	if (!path) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.53.0

