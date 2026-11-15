Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794765846;
	b=cCHyytaQ98lM0dc9YTOwxNDCVBA8o/KJ9a2PVmIIZIET+RkN4uTp0PZF3oOZxiND23Xx
	 XLWkXToCNlFtJNkJ7zSGbgtYAslxybND/u+OKt+pS8x6O5rT6I+vgcB/raWCfOjaOCxWL
	 dD8S11m6+0Fay4DQAkhcnviiRwHw71hcOc0pz4r6DDLsZw0obp/LA3I6Vs/rOARIHPXWp
	 PT3wkV1V6DRyLN0CpqGHlGiGDPZJei2WzpSNc1suTfjuUJItVHH1zODZCoHSFgjP1uYur
	 CgBiSnA8Oies/qOCNY2ya9yllwb2sYOTChvTH801pSv47hTzmTP3nsUnzjDfH5Z2xEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794765846;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCob8yxVUbZMrzUJynGorNZ6cDsRus7pIoTivcXFIek=;
	b=r1697zeM1arU8+5X3JMI/OAtm3UngwxkjrMugthPC5fxDJrQ7aDgMNEIU90Qr90GlP8k
	 +lXhBaH25ZiTEVE4M8Ma6GWN+wIVKzEGeDW0qnMl4ENVKPkTUyy/SwKPn/tVzThL+GcbP
	 kQEkyfxjposaC3ZStnO/cNMjqs71C4qrmwFbkYQRFOyutR+dVH3A095gn0qPXIEb8+Ofg
	 v3JZg+xBFy+VFLtdmX/FddSQ8xtWNtGeCLdIHLPyxf+vOLMknfy9IBE9KRgSbNPxTjvgR
	 /XABDZcwdIyKisVnLCUv9Geh8ie9w5fvbXVMPuZOkckKOcmrGLNxczjb+spUWitfd4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IBD9fQPZ;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EE8606A334
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 18:04:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47EE8606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IBD9fQPZ
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-491f34b4e0fso1063218f8f.2
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 10:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794765844; x=1795370644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jCob8yxVUbZMrzUJynGorNZ6cDsRus7pIoTivcXFIek=;
        b=IBD9fQPZzDEKg2bdACsPtBrqMrB7RpYNzqy1KmrygLKNqfGgfMBRaPWVmtSMny9Uyo
         zZZXZUcxGun91msLJSPue4OSf8KXgtednCc0ci+LHlwiRCT7BYfwj6SD9fUlUIoUNNdM
         HjfCIWv0XLZodUGxpASoDy920nowWC6vgr7iHYUYL+7eC7K2ekWYt+yxN8xnL5lTbX+/
         iPXMXBJgcRIoFjYblNIEP9XDiGpFeZaYRykIxOLk9q0/b6fE1AF+H2k0K17e9FL8HjA/
         bPcXWcQ7jEc4YWkcaZbecSnNezqq4f/KgXnLXzb11BA99Sp4jVEommfOUsdvdRwp16i1
         ptAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794765844; x=1795370644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jCob8yxVUbZMrzUJynGorNZ6cDsRus7pIoTivcXFIek=;
        b=nFsWj1NSh2m5gv9Bb12rJuNDQrcZkorJQQ6zqAMSlzAe8u/VV6CbZ8zSDevyxCto1B
         vCEjIHeXXHHQZnnFMUFCUO7y50QFAenIAqLXccNh5g22XrH8MnUCD32UDoreDiVvj8xf
         8A7NJ3XX9qJuH5fySwqDdMn7iZmnNFPqdRRhgYaoK8QOkuULPM+xEfQsFxFAfwTdsxZ/
         +T1T4j6xEPSHSdT8aozLqThOP9/0rcuDxVxRf0Nz9P4hw6NbXBb22OXcQcJGfIcbj8+n
         G8+mN7mNJyATOwV9HYGJISb+vuQONru6pg3N/cliKi4BstmLJ3sDsqBUCShyEj89mGFg
         X9SA==
X-Forwarded-Encrypted: i=1; AL+hErFAhA1lmTaJiILxXVkXizqOsw44pq5ycE/q0IPE9zAa/f7ElfgLjeHOZuUE8bN6bvbYDpbt/iSvw6E+@vger.kernel.org
X-Gm-Message-State: APuU4Z/Sk7AfVRkiYquuj8L3trwwvFEDKfzC3JqwAb+8yCWPFIwWZSn3
	j6iqhYhzPHJMxlYy8ZKjHoIK9HwI2c/PnjEjSBoo66UwZxE7FsLmbret
X-Gm-Gg: AYBFou3WbKLpkQpSwgtxDwMWqoeDNeCxd/hqETChpqhz5qMS60opty+gjss02QCP/j1
	j9sXrXKqvXyMhtnG0/dQ6vwbT/idTxGnKPN4dDVKJk08bAh+cZmWBaFLPySavqFkQCi/zgjl32U
	fmAoMIdvPwu/UM+H1bFPYAnETuPn4ENiN3dxuZk0ldTaekrUYwiCtgrsZptOP7dmncCttmpZh+/
	SIbNfFW2AH6Vwd+1sfvwtQJlTvqqSBkn6Xbq3WVXXFZwV1f/5cXTVSqmYtefBWUlaGeOOjc5Mht
	2OUb56Dwze7YxO58F8LkcUXEytUgdoXpNZfr4wVmtBR+0Ipaw3pK3QnPeYTrN8SRv5S+hCx6j+b
	9Wd+m1mi7oWN308jgDehzRL/7liRbdc5u6FOCC9UOdkM5SH5Zb7+yV/eGs4xRNwp+D0wQrULBMZ
	g6SBqyL5aA1/r0n37okFWKp8oGCwi96dalxWsfpLpQQ0P5c0V3KSSSXq9+BJEt+inukCl8dqePV
	/DA7GFuTK8vUv2sLU44ulZntPNv6zQ1Kbf9wo1wWrp5OxBfGHothXBplDAXbTo/THRTphoYFZq+
	OXPGm6LF4bIvPZY7Yy19Pe6y
X-Received: by 2002:a05:6000:1841:b0:48f:d7cd:a5ac with SMTP id ffacd0b85a97d-49c6b97336emr21325466f8f.0.1794765843381;
        Sun, 15 Nov 2026 10:04:03 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8c248sm17980448f8f.58.2026.11.15.10.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 10:04:02 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: David Sterba <dsterba@suse.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Chris Mason <mason@kernel.org>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Sean Smith <defendthedisabled@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	exfat@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [RFC PATCH v4 02/10] vfs: add fileattr_has_fsx_mask()
Date: Sun, 15 Nov 2026 19:03:35 +0100
Message-ID: <20261115180343.576773-3-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115180343.576773-1-koray.fra@gmail.com>
References: <20261115180343.576773-1-koray.fra@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add fileattr_has_fsx_mask() as a helper to let filesystems check for
unsupported xflags while allowing supported ones. Can be used in the
same way as fileattr_has_fsx().

Also make fileattr_has_fsx() a wrapper around fileattr_has_fsx_mask().

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 include/linux/fileattr.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 42b92ccdc583..ba7ed3b387d8 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -65,6 +65,23 @@ int copy_fsxattr_to_user(const struct file_kattr *fa, struct fsxattr __user *ufa
 void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags);
 void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
 
+/**
+ * fileattr_has_fsx_mask - check for extended flags/attributes
+ * @fa:				fileattr pointer
+ * @allowed_xflags_mask:	additional xflags permitted
+ *
+ * Return: true if any attributes are present that are not represented in
+ * ->flags or @allowed_xflags_mask.
+ */
+static inline bool fileattr_has_fsx_mask(const struct file_kattr *fa,
+					 u32 allowed_xflags_mask)
+{
+	return fa->fsx_valid &&
+		((fa->fsx_xflags & ~(FS_XFLAG_COMMON | allowed_xflags_mask)) ||
+		 fa->fsx_extsize != 0 || fa->fsx_projid != 0 ||
+		 fa->fsx_cowextsize != 0);
+}
+
 /**
  * fileattr_has_fsx - check for extended flags/attributes
  * @fa:		fileattr pointer
@@ -74,9 +91,7 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
  */
 static inline bool fileattr_has_fsx(const struct file_kattr *fa)
 {
-	return fa->fsx_valid &&
-		((fa->fsx_xflags & ~FS_XFLAG_COMMON) || fa->fsx_extsize != 0 ||
-		 fa->fsx_projid != 0 ||	fa->fsx_cowextsize != 0);
+	return fileattr_has_fsx_mask(fa, 0);
 }
 
 int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
-- 
2.56.0

