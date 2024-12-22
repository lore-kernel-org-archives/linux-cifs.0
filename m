Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CEE190068;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734888267; cv=none; b=fYFVENjigopI4fNx3YtiLg6Y18q18/GSD69dTQkTJr+59feCir+9WZR/HjNq0Uv1Jc0LHe91A5YgTA7X3MvoxKPZINiLIJJp0/fSUE6pHUnxRIunBCJ2l9k+9A/gTCNw6Zrpp1R9cBvvaSPv7u7O4kCD3U4ZDauFSSxOBEFVlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734888267; c=relaxed/simple;
	bh=c8zviAS9Da2By6CGp+7qvmzMNe6QG4WU9CJQtwf+usU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QjsJVpn68giSRLN5rhgyF7w/cHA+N3yIR6MoDb9HdvHDHhVdSoIs9zFG1MHxp4d8JVmkuYSlwudnEUnpoqm8P39lUijxpJz1SdVESvRQWbIUu2oxST3uaaKgoooqd2Av6gFue8m1RNIABPKfwWinUziOT9K41s/FmrgsxUFDD2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFnO3Wc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFnO3Wc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE9FC4CEDE;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734888267;
	bh=c8zviAS9Da2By6CGp+7qvmzMNe6QG4WU9CJQtwf+usU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFnO3Wc6x7ghsLo0QsUVVVzugr0CBRHImrM3+KL+hhP/yAb+Fyy58spBXqGvfai+2
	 4+eAT2Lak6LVCEuFcHjGPe5QUIJfRNrxTGVxivAAMTWQTYvJJov/q3G0H4Ft6FjSxA
	 PhjBBoZhbiLKeLqynH++OzP5uNBWltzuA7BqL3Qr29Kmd1Wye6Kp0B68Y37tiNtQZo
	 mnz/CmDq87Y0x/2NlF0kA+HYLKBVqB+fUtzQiXYEuyyWE+ZpOBv0bRKxe+wkNKpkqW
	 xuy8V9lszuO/9AmMOiyQQ10UZOg3YjpCWuNIK91HabT0/E8fSAI9qfn2OS/CW3dIFA
	 VK3LfnkyqSQ6w==
Received: by pali.im (Postfix)
	id 849CDB9A; Sun, 22 Dec 2024 18:24:17 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cifs: Remove duplicate struct reparse_symlink_data and SYMLINK_FLAG_RELATIVE
Date: Sun, 22 Dec 2024 18:24:03 +0100
Message-Id: <20241222172404.24755-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222172404.24755-1-pali@kernel.org>
References: <20241222172404.24755-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In file common/smb2pdu.h is defined struct reparse_symlink_data_buffer
which is same as struct reparse_symlink_data and is used in the whole code.
So remove duplicate struct reparse_symlink_data from client/cifspdu.h.

In file common/smb2pdu.h is defined also SYMLINK_FLAG_RELATIVE constant, so
remove duplication from client/cifspdu.h.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d0e7fbc5cacd..2a29fa31c927 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -1485,22 +1485,6 @@ struct file_notify_information {
 	__u8  FileName[];
 } __attribute__((packed));
 
-/* For IO_REPARSE_TAG_SYMLINK */
-struct reparse_symlink_data {
-	__le32	ReparseTag;
-	__le16	ReparseDataLength;
-	__u16	Reserved;
-	__le16	SubstituteNameOffset;
-	__le16	SubstituteNameLength;
-	__le16	PrintNameOffset;
-	__le16	PrintNameLength;
-	__le32	Flags;
-	char	PathBuffer[];
-} __attribute__((packed));
-
-/* Flag above */
-#define SYMLINK_FLAG_RELATIVE 0x00000001
-
 /* For IO_REPARSE_TAG_NFS */
 #define NFS_SPECFILE_LNK	0x00000000014B4E4C
 #define NFS_SPECFILE_CHR	0x0000000000524843
-- 
2.20.1

