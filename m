Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=I0byaffaqsEhHL+m+06xDK7NiQXVmktZhsrYrhq+KIxoRQQ1wHSK/y1/C8GJWjNpElHV
	 Rwib4rl72tuFc8CndLB1+fvNfifm1PDk41extyP0yqNQMHA6+j236y9cqvAFoIbMofgFX
	 eeF6664HJRmJpAGy1lto2BGBJhvSJKU0vfaGAycQrEkYZeMBBy8UUsANZIEB1cks+qAZQ
	 faFmFwUepW2h2wqqC2gZ+oMZXu3HLeds6KGwN1/AyTRuGlm0KoDu0as1bB3y4K6s04Ly4
	 6RTtCmAdubbzejyFfdI9YP9K8UcF3ldZty7idjCkTn04o2F7ZaDk/rdOqd2QgOEO/IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=pWS3JwVxq8BPKl5typ3BsrdaWXW9EhNPjKYs7EHpLwg=;
	b=q0RxSss6oQvYUUtvSlCAXl9Y3Ib4d/yZJCC+/6uTh8uptkPkb27/XEqsG4GIGVXwT3w8
	 0A28xHi9YgdSSdqzpiM+7158CpCibby7GOwBzHoyuoBUZerTytAzPHHSlK5QEMJ/3chXw
	 y2p37A5ZwDRFOU8YOfqEi2g2tbLiuasIf5sI8FfglE77R/EmpsCx26KhU4U1wKGDJ58jK
	 1mQGIEAzgJGjkn0mpLGeglNzmcwc2UbINXtWKnirrvzQD/Pp3BUrICT1i6Ujg0Ia7Rf6B
	 KZg6heIIgy1aNF52VPMcMtGUNU4PCHTgWGGyWFLxjbHkGx9OkiBr9ny8ZpXT9KuWA+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dQcr0woO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48D606A328;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dQcr0woO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B7E1F01828;
	Mon, 26 Oct 2026 22:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053574;
	bh=pWS3JwVxq8BPKl5typ3BsrdaWXW9EhNPjKYs7EHpLwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQcr0woOdR3JEt37zD4ucJaBAokKOrgpaOFrZfn1T2E+Zng0mor0xLLVH1bR8Ie3y
	 qeQxtf6u6V+gYeGKKNztY0mwqeKOTUcqZzhj7HnECTeYc4hzjYmXMtmyGBPeaBObeC
	 Zbo7ixYm2bRyj4q/TlyupmkDX/SC+b6lNinDaEulN+6s5/6TPjl+Sk4STn8ILnh2xX
	 u4pxVvxJEku7+3MJ/WFcJ9w01VTHsEsix5/MGn7dtXccL6jMbLT3UQFmjwIWDgFMxe
	 geJgSnfmaqhCqhO02uzcK08iFFA5PVV1RwJRrCa7dPQDoon5IzsUNLbQ9WxBo0leGg
	 JKXTfN60nXrcA==
Received: by pali.im (Postfix)
	id 3815ACA4; Mon, 26 Oct 2026 23:26:10 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 4/9] cifs: Validate presence of EA $LXMOD for WSL reparse points
Date: Mon, 26 Oct 2026 23:25:55 +0100
Message-Id: <20261026222600.17323-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
References: <20261026222600.17323-1-pali@kernel.org>
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

S_DT part of xattr $LXMOD is mandatory for all WSL reparse points except the
WSL symlink and Win32 socket. Microsoft WSL subsystem does not recognize
them without xattr $LXMOD too, and treat such inodes as regular files.

Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index e547510ca3c5..577cdf49c047 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1153,6 +1153,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	kgid_t gid = cifs_sb->ctx->linux_gid;
 	struct smb2_file_full_ea_info *ea;
 	bool ignore_missing_eas = false;
+	bool have_xattr_mode = false;
 	bool have_xattr_dev = false;
 	dev_t rdev = 0;
 	umode_t mode;
@@ -1216,6 +1217,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			if (S_DT(mode) != S_DT(get_unaligned_le32(v)))
 				return false;
 			mode = get_unaligned_le32(v);
+			have_xattr_mode = true;
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
@@ -1226,6 +1228,16 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
 		return ignore_missing_eas;
 
+	/*
+	 * S_DT part of xattr MODE is mandatory for all WSL reparse points except the WSL symlink.
+	 * Microsoft WSL does not recognize them without xattr MODE too (except the WSL symlink).
+	 * IO_REPARSE_TAG_AF_UNIX is here an exception because this reparse point is used by both
+	 * WSL subsystem and native NT/WinAPI subsystems. And NT/WinAPI creates AF UNIX socket
+	 * without the xattr MODE and recognize it also without the xattr MODE.
+	 */
+	if (!have_xattr_mode && (tag != IO_REPARSE_TAG_AF_UNIX && tag != IO_REPARSE_TAG_LX_SYMLINK))
+		return ignore_missing_eas;
+
 	fattr->cf_uid = uid;
 	fattr->cf_gid = gid;
 	fattr->cf_mode = mode;
-- 
2.20.1

