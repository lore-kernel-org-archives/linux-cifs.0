Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA0C1B042A;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=AAQkMxOBhdWHxSfrH/Ts9qyQvTwe1f4EMUo/TLgA+BcB/O47Mj3azqu8R9olMcxOwIKyIz8a3w41CuAaUCHtuh37D3dX8gy6Uw2RJuAewLVdig5iVj3SVNDmtut7iMhZqUkaJDb5nUsJY1uidey33Zi3UctM+QHzu+B03cuNqVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=4j8MqoiJKVErbLBGKe6ycwnF4jbeDiBki/o5B+5xBO4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gCnO/wzkucZvfW2Ahkp6eVxLXyxzsAXbBKzoVkN//RgzX5MrN1C+/aahZrrhzvNd+WvxzfOOjUDkW2l+L5o1LcUmvKcPrl2YWK+07ibYHKPNKeCVXuT0+aeKgGuoA2j2gjlLO3naWPWADl7O9+CAHX5sTz9pImuo5DAI6tarAqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMrwuBlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMrwuBlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F64EC4CED2;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684629;
	bh=4j8MqoiJKVErbLBGKe6ycwnF4jbeDiBki/o5B+5xBO4=;
	h=From:To:Cc:Subject:Date:From;
	b=EMrwuBlkUs53KWkw5ZY/N25QGTiRreQgy8C72PoXHOypLGKck2hT/B7bV1m7wyj2S
	 wqiTMx23lHNpShcvhP8RYxAFQF3MUx4/SHa+5gXEr5iaIoJYdzL6/xG9LQ1WIhf0Qb
	 3bhmj/IReZiRkNFfzeL9+KkxgQD2+ZoM6mXN7AnHHNKEZT48NB4cLYBytTurExBKVN
	 Oezb0KYplrSGTDBkO4X8CyHUhr3ewDXAcuqRqpLWfndXHVrURdfl80HjlH5nufiH8O
	 GiFPRm30fyZF2xDP+m6TmbR18Fs5nXEURAr5qSSOz5YiaBGE8AdE0++z1J9mXCACWD
	 lNa/Jj3tqnQcQ==
Received: by pali.im (Postfix)
	id 4417997E; Tue, 31 Dec 2024 23:37:00 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] cifs: Fix struct FILE_ALL_INFO
Date: Tue, 31 Dec 2024 23:36:31 +0100
Message-Id: <20241231223642.15722-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

struct FILE_ALL_INFO for level 263 (0x107) used by QPathInfo does not have
any IndexNumber, AccessFlags, IndexNumber1, CurrentByteOffset, Mode or
AlignmentRequirement members. So remove all of them.

Also adjust code in move_cifs_info_to_smb2() function which convers struct
FILE_ALL_INFO to struct smb2_file_all_info.

Fixed content of struct FILE_ALL_INFO was verified that is correct against:
* [MS-CIFS] section 2.2.8.3.10 SMB_QUERY_FILE_ALL_INFO
* Samba server implementation of trans2 query file/path for level 263
* Packet structure tests against Windows SMB servers

This change fixes CIFSSMBQFileInfo() and CIFSSMBQPathInfo() functions which
directly copy received FILE_ALL_INFO network buffers into kernel structures
of FILE_ALL_INFO type.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h | 12 +++++++-----
 fs/smb/client/cifspdu.h  |  6 ------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1338b3473ef3..82e819f9d24e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2216,11 +2216,13 @@ static inline size_t ntlmssp_workstation_name_size(const struct cifs_ses *ses)
 
 static inline void move_cifs_info_to_smb2(struct smb2_file_all_info *dst, const FILE_ALL_INFO *src)
 {
-	memcpy(dst, src, (size_t)((u8 *)&src->AccessFlags - (u8 *)src));
-	dst->AccessFlags = src->AccessFlags;
-	dst->CurrentByteOffset = src->CurrentByteOffset;
-	dst->Mode = src->Mode;
-	dst->AlignmentRequirement = src->AlignmentRequirement;
+	memcpy(dst, src, (size_t)((u8 *)&src->EASize - (u8 *)src));
+	dst->IndexNumber = 0;
+	dst->EASize = src->EASize;
+	dst->AccessFlags = 0;
+	dst->CurrentByteOffset = 0;
+	dst->Mode = 0;
+	dst->AlignmentRequirement = 0;
 	dst->FileNameLength = src->FileNameLength;
 }
 
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index 3ad1bb79ea9e..e5e397291da9 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2294,13 +2294,7 @@ typedef struct { /* data block encoding of response to level 263 QPathInfo */
 	__u8 DeletePending;
 	__u8 Directory;
 	__u16 Pad2;
-	__le64 IndexNumber;
 	__le32 EASize;
-	__le32 AccessFlags;
-	__u64 IndexNumber1;
-	__le64 CurrentByteOffset;
-	__le32 Mode;
-	__le32 AlignmentRequirement;
 	__le32 FileNameLength;
 	union {
 		char __pad;
-- 
2.20.1

