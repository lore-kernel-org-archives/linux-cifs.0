Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794017034;
	b=f4mfAAlH67tLOCCcVpcHs42yFzL0Tc//8BmCUXBgO3wu9QCe98NFgC9NCEl47gl8fEdj
	 XfoN76Eo9GmcTPkf/mUR+/YN6TQ7QWGk708u1w15k7k3gdvjwM7H/viHeShiGsBBYAKuw
	 v00R0Osd7sup2FnLiz8sUvUJBFqFVhHApBaEwQWEXeNcNW5lDGKEvJw1m3eEduBFzILZ6
	 sPR2OutUqa5KH7kJw+CozwYECxls0DZpcZ3w3dp2ucSbG14/jiTo7tOcuTM9iOEWCKoyG
	 bPKMsEJnhijAUGBbg023Mt6IVNS9G0lbsp3FaQQW0tQdEA9HuQI/emPzwyHkrAgvU2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794017034;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fag9CAq5RdDK24g6i+Jze72o+KqHUpaocfKTd7BZIO0=;
	b=HyG0R9oSWib+8sYR9WOz4zNf03SI6Xz9m7tZe72/ASqFd4VMpvpMyxZAo3adA+lzNcsV
	 EgWEuxDAMHl29hT3B2S1+b0cQGia5LTARLOUVgYKjLwdscGh0hMuvdELorT3j61srRkuk
	 tOkDX23ZtL7vbyoLoFEjRp1NUWMzFLj5+w4aykflF0IXmXv5vvd9eDiXfDYCDw1MTCmS+
	 VlhKTtUuIzPE4euMOKgmFTHxWDu2vi8QRifY+Vy4cIlf0RG6GYLHciQtq9mUW38po+1St
	 VqUFOgENNTpxAfBAAEIfY6QqVsAAt5mTwTtRbfb83wmA8drrXXeiHS8gFm2B4WWecnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjNPtQDd;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB9D606A32F
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 02:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CB9D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EjNPtQDd
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-37000e7234bso1590288eec.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 18:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794017033; x=1794621833; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fag9CAq5RdDK24g6i+Jze72o+KqHUpaocfKTd7BZIO0=;
        b=EjNPtQDdfUizC6avFZtZI8RqbdTirz6v/iHvg+7kwZmf+UjAaHZ5etVdklyGbtDOXp
         18tAeoppS5HrZjnmJhZV949evREpLPB23tunsddoEos0a8e8zQk7C+iCX4vyFih3BR1f
         E1zr1pjo3TG6g6pb7w6pOQVjJSYGnX7bOljfT9rcQyscyQbZigwH1NqxHXLHpVWtGru9
         0y03euFxYZ81BAjsVFTE3JHx10zDb6QSCSSXlglK19QQtAusZ66TtKp0Z8Ob8q/aJkTl
         0b88hhxJorBi6uJJeV2Oj8JphDwxh680XHcTciLnI+YYCa6jvv7GTIoQClv9HUFLxUrF
         voQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794017033; x=1794621833;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fag9CAq5RdDK24g6i+Jze72o+KqHUpaocfKTd7BZIO0=;
        b=SXfeYToY1pTln8wygAHYWNvBzwC1fbcSYB1hiCeaXr0+cy0NM8senYj+aclHmQE2/B
         5GB985ywBba/3UgIC4lbbG+HFFIZrJF1MHTIzEzXfvHIKPbERYXlykoHfdzgGq7vGjYy
         JKy0ei3Hm2RBkxT+zBe6Xzod0Y8h1p7UVmZrLkVG3EYE+8Un4rwt1L6PQZ9dAz3/N5A+
         yjKYIMXhCW07HS7yqLj2ESMqm49hU2QyAXs3SN3Wyol4Ot7W5a5qxkPKb9XUP5THL/Pu
         en4YwT/7/Siuxw+5b0Xu1hOEZd64GirckwqDx+GlQbNMCyFTafrBoKOjzTnrxqsWW0ov
         M85w==
X-Forwarded-Encrypted: i=1; AKwUvBxXs7TE75XjrLLnZDqD9/JtWytNBB6RhKBYaYpDRZXzL28z7YL1vgHYMZCJdkgIGefNYvgPqU8NSurs@vger.kernel.org
X-Gm-Message-State: APuU4Z/SoEn4jEwhy38R+xsyXE+t0vjUma/tMXHnVSwu1bqsesnUFwng
	3lB+JjsN6vg8BMk0u4qMKO8+2ZyruJUZiWfX1jb9mq/x/2oGzJts4bSu
X-Gm-Gg: AYBFou1w3o/N6V9bky/QAYMKTJImLRXAQnL6dIW0My5kkyY+bNyQvOYx5wuHkQ8W/Kx
	WGSkZ5ND9C0pFGrYM8MZ2+Qfq8pXug0PXyvtTu5zDN/bKS3dBq/j3sqfBFhqj9Xbo8hfFtcesv6
	WLSbM6MzDvzk5hXRx4z2RSPEB9JYauuFuwCZKB2oEPUoNCAy4HW7gtawIiEzM9DVY/EFMkUW1ce
	WaaBaASHgTmkzz6g4XyNtuzaPLBD7+30eXlx3PILiseQiv1i/OEys5dBxOzTKvoTjByoVRbixPy
	kZ18Cjlcq3owreQO9eSX/FBaq6xsdaMTN0s7rX6pTzgekzEIdzy5dGvXBa4nc79/W7a5eJAh6tO
	N19AYQdE/cjfs9AiGF91Krg81zEhRTZIqhfL00MVaCm0DJom6GK954SedLiprKHVV+PdwbSHR7t
	IzU+80rMsPnel1mOzChwrIn0PegeZqiT1iMU0c2zzOwU0fk7PWe4XxEm4VgiLY0JUHN+c/nNomp
	mhKhne7u5naktggAB+X3lUTxnrHe5S2jY6V86mYEM+6uoHMpDwnioqkLNi6Yas2ZndIwtAHpG9W
	Mc0rM8eLEMM3bCX2M0eijoK4fOfZVtoh2yBHErprV+IZvhJPuEe6N4UiZx0YTcivrno=
X-Received: by 2002:a05:7301:f0c:b0:36a:18e2:64c with SMTP id 5a478bee46e88-36f75a2afd9mr5001824eec.11.1794017032952;
        Fri, 06 Nov 2026 18:03:52 -0800 (PST)
Received: from fred-server.tail1cd3ef.ts.net ([166.199.5.81])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa922b205sm10524395eec.11.2026.11.06.18.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 18:03:52 -0800 (PST)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH 2/2] smb: client: fix double conversion of DFS path in setup_dfs_ref()
Date: Sat,  7 Nov 2026 02:02:57 +0000
Message-ID: <20261107020257.363811-3-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
References: <20261107020257.363811-1-fredric.cover.lkernel@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

setup_dfs_ref() converts the path from the mount charset to the DFS
cache charset (utf8) via dfs_get_path(), and then passes that already
converted string to dfs_get_referral().  dfs_cache_find() converts its
input again, assuming it is still in the mount charset.

When the mount charset is not utf8 (iocharset=iso8859-1, or a kernel
built with a non-utf8 CONFIG_NLS_DEFAULT) and the DFS path contains
non-ASCII characters, the utf8 bytes are interpreted as mount-charset
characters and encoded a second time.  For example, "é" is sent as
c3 83 c2 a9 instead of c3 a9.  The server then fails the second-level
referral with STATUS_OBJECT_PATH_NOT_FOUND and the mount fails with
-ENOENT, even though the path exists.

Pass the unconverted path to dfs_get_referral() so that it is converted
exactly once.

Such mounts now get past the second-level referral and reach
dfs_parse_target_referral(), which is why this change depends on
"smb: client: fix out-of-bounds read in dfs_parse_target_referral()".

Tested with a Samba DFS root containing a link named "café", mounted
with iocharset=iso8859-1 and the single Latin-1 byte 0xe9 in the path:
before, the mount failed with -ENOENT; with both patches applied, it
succeeds.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index e6dcaf9b8682..0660c0a1eefb 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -103,6 +103,7 @@ static int setup_dfs_ref(struct dfs_info3_param *tgt, struct dfs_ref_walk *rw)
 	struct cifs_sb_info *cifs_sb = rw->mnt_ctx->cifs_sb;
 	struct smb3_fs_context *ctx = rw->mnt_ctx->fs_ctx;
 	char *ref_path, *full_path;
+	const char *raw_path;
 	int rc;
 
 	set_root_smb_session(rw->mnt_ctx);
@@ -114,9 +115,10 @@ static int setup_dfs_ref(struct dfs_info3_param *tgt, struct dfs_ref_walk *rw)
 
 	if (!tgt || (tgt->server_type == DFS_TYPE_LINK &&
 		     DFS_INTERLINK(tgt->flags)))
-		ref_path = dfs_get_path(cifs_sb, ctx->UNC);
+		raw_path = ctx->UNC;
 	else
-		ref_path = dfs_get_path(cifs_sb, full_path);
+		raw_path = full_path;
+	ref_path = dfs_get_path(cifs_sb, raw_path);
 	if (IS_ERR(ref_path)) {
 		rc = PTR_ERR(ref_path);
 		kfree(full_path);
@@ -125,9 +127,13 @@ static int setup_dfs_ref(struct dfs_info3_param *tgt, struct dfs_ref_walk *rw)
 	ref_walk_path(rw) = ref_path;
 	ref_walk_fpath(rw) = full_path;
 
-	return dfs_get_referral(rw->mnt_ctx,
-				ref_walk_path(rw) + 1,
-				ref_walk_tl(rw));
+	/*
+	 * dfs_cache_find() canonicalizes its input from the mount's charset, so
+	 * give it the raw path. Passing ref_walk_path() (already in the cache
+	 * charset) would convert it a second time.
+	 */
+
+	return dfs_get_referral(rw->mnt_ctx, raw_path + 1, ref_walk_tl(rw));
 }
 
 static int __dfs_referral_walk(struct dfs_ref_walk *rw)
-- 
2.53.0

