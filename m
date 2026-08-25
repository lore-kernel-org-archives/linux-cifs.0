Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9398345729;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699200; cv=none; b=M8HUN2N8FmGiCoeL7u3vsqpcXrgP0xe2PWuL9k0H2c1bA801LvFWTdFUqUEhJ54gj/GGdrftOnYrVu+RXtGbsVbi2t4eIoFj+1Zh9yGjPEzaRn7r3Q0NH2GeQER/hGQTTqXfPk4fjgDxYkuSGJ7O15YNihYENUAKQ7MMI6heSy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699200; c=relaxed/simple;
	bh=7T1imIKO5QjKfyKOa/wE22gU63MG4l2XuQL51nOuXcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXcB7ZGc6qFvqfbddSIa6CoMqyNN8vCnSuy4scVgpWXYl+sPRUaexY/gG4wLKx2Iyah+NASkFuHKJrQop/+L3/eSkBR7BtB7xLAjl+MaI2k+UIYZf5S6qHAlcUmR9aBo6F4sw7iY/t8vE6QQq9B97lKopGOE6qMQe0N3nj9YMeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N00xddOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N00xddOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9731F00A3F;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699198;
	bh=+Q0/RIbHsAYjAAWNFCwTWF4fj8J6f3yrdQslB6mf/cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N00xddOJ96HrqbFEa2uD3a1YQT2c7UYzKmViHcYmrAkiRBu5PKWJn5ewowUAPkRwy
	 xNvJuYMcUd10HtXiUpLx4MDoN9jf1+MvT+x3krIgqFKnwCh1uRdKNG3K0/3mofCpsV
	 i8/SxaV8dAHQeFjIVBE6BW40C6ZpIzW1jpk/LriqBP3ds5DZWZZ3IxnTZxtzlLHYC+
	 WC2kVBgy7CpoSXXn/s9dYBk2xUxExOzIJaGTwdhVDdB7y+m/WaHB3UtSlU4TlgyaK2
	 02eo+6tbGdWnMc1VTSUdJxo0n2GmgaovjA4Q7WDU9gUp8YhNaggbmRgm6H7SKgvmox
	 MLzb6o0oVo3ew==
Received: by pali.im (Postfix)
	id 8CCCF11DD; Wed, 26 Aug 2026 01:06:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] cifs: Validate presence of EA $LXMOD for WSL reparse points
Date: Wed, 26 Aug 2026 01:06:17 +0200
Message-Id: <20260825230622.24617-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260825230622.24617-1-pali@kernel.org>
References: <20260821214722.q7rkflclyyugdxll@pali>
 <20260825230622.24617-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
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
index d4052f6c6e6c..233a445ba811 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1139,6 +1139,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 {
 	struct smb2_file_full_ea_info *ea;
 	bool ignore_missing_eas = false;
+	bool have_xattr_mode = false;
 	bool have_xattr_dev = false;
 	umode_t reparse_mode_type = 0;
 	u32 next = 0;
@@ -1198,6 +1199,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
 				return false;
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			have_xattr_mode = true;
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
@@ -1209,6 +1211,16 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
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
 	fattr->cf_mode |= reparse_mode_type;
 	return true;
 }
-- 
2.20.1

