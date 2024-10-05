Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0445DD2FA;
	Sat,  5 Oct 2024 14:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728140155; cv=none; b=JXqOS/GD2+nX8FYfwy/QRLAtaPHVefhgBWhRE74FxQwG2CqFog56dKXcm9mJ074RV0SNLwtxdY8snc6dEPfroq4nyB/r6vzauZMEFgu18VuogxZhs8JVtOYsc16vg4NTGiLwJeet9qwzLWeppNxJLHQDh/jx6xaSHgzuW3PY2ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728140155; c=relaxed/simple;
	bh=GKFhspQKG3F8+HOlrGsjdqSuU0BhOiTDmtfSBXtyd6M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=jHaxa8F5W9xkkdIS1P/jV1/vOR9+iVDm4mdZ8Z1uNqMAXQhDSvTzFAVzuUXNCRxpm64Q0RHqG2Ubyrb1ZMstRp3e4cu5hGM5hgvTOaD6IymXoh+U1o49bIaK1j3EzybEyeCO0Os+hV/up7KaW03Uyj2ILTUVL0rIlRA8pEaZ6II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WW3P6qOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WW3P6qOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD0AC4CEC2;
	Sat,  5 Oct 2024 14:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728140154;
	bh=GKFhspQKG3F8+HOlrGsjdqSuU0BhOiTDmtfSBXtyd6M=;
	h=From:To:Cc:Subject:Date:From;
	b=WW3P6qOnvRFaaqOIx75NmlbuM374VF6z+qtlGkDJrbUuTy5lQG5JFdm0ip18zPmgo
	 F2aPOcLnRvzAIKfykkQRwRHjxpc41EngFgmKp8+5ldtSiYVcnOswLRM4+gEtBXBLbP
	 0z9LQm177PHjvdcJKRW3AvHJQsCIves/LygU8K3i2bbVOFMQL2YSi25lotME+b8Ajs
	 SL34DdgH/6dkYBPuPRTTOrtRvZOiBv3XGZoTxvfril2aoTIgMFkiOak+tlSuq34LYF
	 sSRT+J/1VpWhK7wzJ3DkzQ2fS/hj7i8m9dTUUB81S/ajoolGrHZXNNErr61cVq3NX/
	 xNMQfQUP4JxNQ==
Received: by pali.im (Postfix)
	id 0387E648; Sat,  5 Oct 2024 16:55:48 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Recognize SFU char/block devices created by Windows NFS server on Windows Server <<2012
Date: Sat,  5 Oct 2024 16:54:45 +0200
Message-Id: <20241005145445.19850-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Windows NFS server versions on Windows Server older than 2012 release use
for storing char and block devices modified SFU format, not compatible with
the original SFU. Windows NFS server on Windows Server 2012 and new
versions use different format (reparse points), not related to SFU-style.

SFU / SUA / Interix subsystem stores the major and major numbers as pair of
64-bit integer, but Windows NFS server stores as pair of 32-bit integers.

Which makes char and block devices between Windows NFS server <<2012 and
Windows SFU/SUA/Interix subsytem incompatible.

So improve Linux SMB client.

When SFU mode is enabled (mount option -o sfu is specified) then recognize
also these kind of char and block devices and its major and minor numbers,
which are used by Windows Server versions older than 2012.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 71d454a6bdf3..4d1accfde154 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -598,6 +598,17 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 				mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
 				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
 				fattr->cf_rdev = MKDEV(mjr, mnr);
+			} else if (bytes_read == 16) {
+				/*
+				 * Windows NFS server before Windows Server 2012
+				 * stores major and minor number in SFU-modified
+				 * style, just as 32-bit numbers. Recognize it.
+				 */
+				__u32 mjr; /* major */
+				__u32 mnr; /* minor */
+				mjr = le32_to_cpu(*(__le32 *)(pbuf+8));
+				mnr = le32_to_cpu(*(__le32 *)(pbuf+12));
+				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
 		} else if (memcmp("IntxCHR\0", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Char device\n");
@@ -610,6 +621,17 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 				mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
 				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
 				fattr->cf_rdev = MKDEV(mjr, mnr);
+			} else if (bytes_read == 16) {
+				/*
+				 * Windows NFS server before Windows Server 2012
+				 * stores major and minor number in SFU-modified
+				 * style, just as 32-bit numbers. Recognize it.
+				 */
+				__u32 mjr; /* major */
+				__u32 mnr; /* minor */
+				mjr = le32_to_cpu(*(__le32 *)(pbuf+8));
+				mnr = le32_to_cpu(*(__le32 *)(pbuf+12));
+				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
 		} else if (memcmp("IntxLNK\1", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Symlink\n");
-- 
2.20.1

