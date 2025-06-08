Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAA316C850;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402101; cv=none; b=D9VE/Yly4hozw1krqIrD4jJHavMWwhiEfXXWhmb8auyy1IRpOQ8Kvc8akZI5PJ5UB8/ga1/YzX4MWbGEbz2VBLCRbvykUPCOx1Eglsf9o94++W5kAgZzN2Y5SXzAX5A4ZFtGqQBw3xMOxj+7sVEdWsIpmPywMbvk1MkbfYMMx1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402101; c=relaxed/simple;
	bh=dG+HAQQRyvd4jvroCu9QenmDzGqdwnSUb+X0lOm2yg8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KTQlQCaOr5bMbO8BH0ci9CEXH7Adqt9RPrX6i8WcRdPosnUVN6TyX7XpVHOhFh6gMpSdw0c1Ma4oTtbSqrGFiPtLj+QOml2La8MUdK8WXHqfkZVTeIc6NEGGsOvuLAkZGp6g65nBfuaQqSX594GBEAz0b0jBBCCARy5CusDL8zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3UIWDUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3UIWDUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D06EC4CEF2;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749402101;
	bh=dG+HAQQRyvd4jvroCu9QenmDzGqdwnSUb+X0lOm2yg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3UIWDURt/XK3yyd4u9pO/LTCYu7Azv+Qe81b7qMwbxDuYvJ4zntx0S/3+XL4KeVZ
	 nvjrmcmS76gDHGT2cRl0WT73e7pTmc9U5gGaZ4vfToQAAP4O1LWgHOHAGwHD7n4Usf
	 ge07Dd/zAkNh3qOfgnl0DyKph3Er+CUDHCSFUbVFCvJrJ4UUPgFTCeHkLPHbCFJuvJ
	 U6TA6DfsbYJ0ijpahm/hv7fxoK1rxQcfPlr0igBJ4eZUIJ1L3zdVuCdCAEA/5PyrqG
	 7yiw/kgzsJKom5tXSN+xpdTyQlYmKjX2PUE/WQuuOcyjmO+H6KwrQsfIJBSd7/OmFq
	 m4OO8HJyjGDLw==
Received: by pali.im (Postfix)
	id B56E3FA7; Sun,  8 Jun 2025 19:01:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] cifs: Fix validation of SMB2_OP_QUERY_WSL_EA response size
Date: Sun,  8 Jun 2025 19:01:17 +0200
Message-Id: <20250608170119.6813-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608170119.6813-1-pali@kernel.org>
References: <20250608170119.6813-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently the SMB2_OP_QUERY_WSL_EA checks that response buffer has at least
size SMB2_WSL_MIN_QUERY_EA_RESP_SIZE and maximally it is
SMB2_WSL_MAX_QUERY_EA_RESP_SIZE.

Constant SMB2_WSL_MIN_QUERY_EA_RESP_SIZE is defined wrongly because it
expects that the there are at least 3 EAs. But WSL subsystem has only one
mandatory EA: $LXMOD. So fix the SMB2_WSL_MIN_QUERY_EA_RESP_SIZE to be size
of the structure of one EA.

Relax also SMB2_WSL_MAX_QUERY_EA_RESP_SIZE, calculate maximum size from the
size of the largest EA which is 8 bytes for $LXDEV.

This change allows to recognize WSL CHR and BLK reparse points which have
only $LXMOD and $LXDEV EAs (no $LXUID or $LXGID). WSL subsystem recognize
such reparse points too.

Fixes: ea41367b2a60 ("smb: client: introduce SMB2_OP_QUERY_WSL_EA")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2pdu.h | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 3c09a58dfd07..cdf0ab9ddbcd 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -425,24 +425,23 @@ struct smb2_create_ea_ctx {
 #define SMB2_WSL_XATTR_MODE		"$LXMOD"
 #define SMB2_WSL_XATTR_DEV		"$LXDEV"
 #define SMB2_WSL_XATTR_NAME_LEN	6
-#define SMB2_WSL_NUM_XATTRS		4
 
 #define SMB2_WSL_XATTR_UID_SIZE	4
 #define SMB2_WSL_XATTR_GID_SIZE	4
 #define SMB2_WSL_XATTR_MODE_SIZE	4
 #define SMB2_WSL_XATTR_DEV_SIZE	8
 
+/* minimal size: at least the smallest EA has to be present */
 #define SMB2_WSL_MIN_QUERY_EA_RESP_SIZE \
-	(ALIGN((SMB2_WSL_NUM_XATTRS - 1) * \
-	       (SMB2_WSL_XATTR_NAME_LEN + 1 + \
-		sizeof(struct smb2_file_full_ea_info)), 4) + \
-	 SMB2_WSL_XATTR_NAME_LEN + 1 + sizeof(struct smb2_file_full_ea_info))
+	(sizeof(struct smb2_file_full_ea_info) + SMB2_WSL_XATTR_NAME_LEN + 1 + 4)
 
+/*
+ * maximal size: all 4 EAs are present,
+ * beginning of each EA structure has to be aligned to 4 bytes,
+ * EAs have different size and can be returned in any other,
+ * use the largest EA size for aligning when calculating maximal size
+ */
 #define SMB2_WSL_MAX_QUERY_EA_RESP_SIZE \
-	(ALIGN(SMB2_WSL_MIN_QUERY_EA_RESP_SIZE + \
-	       SMB2_WSL_XATTR_UID_SIZE + \
-	       SMB2_WSL_XATTR_GID_SIZE + \
-	       SMB2_WSL_XATTR_MODE_SIZE + \
-	       SMB2_WSL_XATTR_DEV_SIZE, 4))
+	4 * ALIGN((sizeof(struct smb2_file_full_ea_info) + SMB2_WSL_XATTR_NAME_LEN + 1 + 8), 4)
 
 #endif				/* _SMB2PDU_H */
-- 
2.20.1

