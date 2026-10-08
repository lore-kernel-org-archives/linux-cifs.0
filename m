Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86454E2F28
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 15:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473184; cv=none; b=t27vc+z1ebt3zNt4/rCv8OtVRcFEthcx8J+qisTTgp6TxHr1Kl46YuqvOtunP2tq5RkMxNPSuQWBl8WCTue++P0T3Tt5PTwtXhxwU/UMdhG49p0W5e6wrSXdfICC1KzVw9NO9BenEKqLoHCxiz4oDgUR1Qdjub/f5dcxph9JY5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473184; c=relaxed/simple;
	bh=BnX+tW917e2ep0AD06iDELoUpJb1f9PtjJfaF1/h/ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogC9KN/ZGAdqvHA9p05tCy5fZBv3Ey3+sUlFGiSE20me91tYxPSV1QY7F9tsBHOT6LqIP+xiZHrmjwn/0ygO7Flh/B/ZkAqAF0j5d5tncx7CnOKoyoNG6Kw4EFT3uWAADnN7E9eFLwdMqh38A+0H9SCTicfYDQB1i6Na0H0AdZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtppJKn6; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtppJKn6"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a6e6f80d64so149124a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 08:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791473170; x=1792077970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W6dQo+XOFZwjP4FilzjIvU+VBwZHW7Mw0WgQYDNHew8=;
        b=KtppJKn6juoG7WHPkz012cDyRd7omb/Vte4rzkJMPaCe7k4LAo72HoSfiRMJI1oV+5
         gcOHZdbXUiiL5qNB/HlZ14bKcdk0xP9fGJitpGzoS5hv51rGdrtekz+tENQfvBX8Ck1c
         tP0o8FO3E/UsuhnhsLODzjbrLAnbMi11/45MMMF44Y+xU81TBx5yRMSyEcidnIXyTxfG
         H8GzWoHK34TbJt9Uz8zz+Add1MeaYg0P65y1l0zAlYEf3SPZIKSZm/0CYVbMIqmPbMgY
         bP4WD3HIH0BcSgqJpA+/scbIrcIggLI+6cN6nKbsspBN5O+wditVNgK/AHY23qzcWaEy
         p1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791473170; x=1792077970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W6dQo+XOFZwjP4FilzjIvU+VBwZHW7Mw0WgQYDNHew8=;
        b=SPoidHM8dYCN4iFCDetlPu4b3XmpP27JflGz6NBfPL+vumF3t453c3ulXN63zc0xS7
         lxrlWtRfN3z56LfK/NtZYdm0h/ilYxCqG2C0C0i/l2yT7pkIEUCf4Zer7YLt/KnmL1w6
         wiRfIiB+soVX4WD0Yc7kFmgyAov0JTuhNx926FGGC9edTDkM0r8okulz/0GvXFMi/s6o
         fk+uUB6dce9IuhTX4b9ILqS+r0I90m91HqG/C5/T4RW0CmlGOQPoiWzsmnmczfnRTMYF
         wjEIyjhWVHp+nOd9B8wwId2NhF1qljUkOa1sE5fOBNboUmjJdrVP/nKLVZvmVY1ql609
         UyPg==
X-Forwarded-Encrypted: i=1; AKwUvBwxPXnLfjNzANKeqLgj3/Wu8fr08MHgW65oyY3aJ/Qh7O/RpvGW9IIc8cWqpaVqx0BaOgXM5MmlucWQ@vger.kernel.org
X-Gm-Message-State: AFq9FYJBX9JDNUERdiqrKQatwXFBxpdMNMhqGHikA/Sx12RIaR8gFYcO
	o0ua/SGyNo2ASTVYgleFth1ZPbbrQRfuYzpQcdBUrOY7RGw7H+je6KbL
X-Gm-Gg: AYBFou24KQJN9TV4apGp4I4Yz2fvzU7q2cT/kSAT9qCQKJQ96abD6e8HG4/mgMtRcir
	WG7cTfXiL/bKcT5selfZY2c/rWwkPgy/m7vBrZeBmC9pmbzGId2HQyySqRL0/ut/xD6ciY72gkj
	QPJMHz7/OmEik6uf4hZYyTmPWCY06HMDNmMWHHsdAeuSqA1BWCkkdI0gIWPRt2I7ZFBhdl3INWT
	PO+R+jMflqWf511hshuiH0YulkjxHLSX7dN4iPizjODZI7R9v8nUD0zxUii4RIXqseUrVM6qF09
	n76A+M9S9tz26doODZMuTnzpXaV7I8uZzpjP3uzk2SaLD/wnMjUnK1fi/h/VEgb+HzwQcxzwBC6
	RDpwDc+dM3nJll+Vh1wVU7rgH74uim2fwSSDPYr63O2f2ULvdl27+4PllFrhXScS8kzYYRmJkNo
	+KYGTSe3jpZ8zhNfXFnNOD0/J2Lje2XjdiN+YGXp1DcXFG5cUtIYOWPcsvGLiYTkw=
X-Received: by 2002:a17:90b:1809:b0:3a0:bcc8:1549 with SMTP id 98e67ed59e1d1-3aa9a437f1emr4109382a91.6.1791473165176;
        Thu, 08 Oct 2026 08:26:05 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1c17b63sm5554792a91.12.2026.10.08.08.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 08:26:04 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 3/3] ksmbd: preserve unreadable named streams on open
Date: Fri,  9 Oct 2026 00:25:37 +0900
Message-ID: <20261008152537.4147299-4-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008152537.4147299-1-charsyam@gmail.com>
References: <20261008152537.4147299-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A write-only client can open an existing named stream with FILE_OPEN_IF
without permission to read the underlying file. The case-insensitive
lookup finds the xattr name, but querying its value length then fails
with -EACCES. smb2_set_stream_name_xattr() treats every negative result
as a missing stream and replaces the existing xattr with an empty value.

A failed xattr list is not proof that the stream is absent either:
for example, -ENOMEM can lead to the same empty replacement. Preserve
listing errors and create a stream only for -ENOENT or -ENODATA. The
latter can occur if the xattr is removed between listing its name and
querying its value. Return other lookup errors without changing the
stream.

A write-only FILE_OPEN now reports access denied instead of name not
found. FILE_OVERWRITE_IF and FILE_SUPERSEDE on an unreadable stream
also fail instead of appearing to replace it. Stream writes and EOF
changes already need to read the old value, so such handles cannot
update the stream after opening either.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/smb2pdu.c | 2 ++
 fs/smb/server/vfs.c     | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4d43de74f..52a19871d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3420,6 +3420,8 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 				     xattr_stream_size, xattr_stream_name);
 	if (rc >= 0)
 		return 0;
+	if (rc != -ENOENT && rc != -ENODATA)
+		return rc;
 
 	if (fp->cdoption == FILE_OPEN_LE) {
 		if (!strcmp(stream_name, "AFP_AfpInfo") &&
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 7020b7de3..3fa0e26e5 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1952,7 +1952,11 @@ ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 	ssize_t value_len = -ENOENT, xattr_list_len;
 
 	xattr_list_len = ksmbd_vfs_listxattr(dentry, &xattr_list);
-	if (xattr_list_len <= 0)
+	if (xattr_list_len < 0) {
+		value_len = xattr_list_len;
+		goto out;
+	}
+	if (!xattr_list_len)
 		goto out;
 
 	for (name = xattr_list; name - xattr_list < xattr_list_len;
-- 
2.43.0

