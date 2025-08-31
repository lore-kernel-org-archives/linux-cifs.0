Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEB9262FDC;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=Kdo7np/FCLJyRgEUigrLQaK2IUhNirj8CGKNZjUNbEsMBox2RMgRsOe4GNNgOX0W7VV2KHLt/E70ZMjIxTNt2buE5M7M+/JcaU1vuTS30eylzLZziB/SJW1MP1D0KHuHgKpFW9ok+oE3kugYpVS+1f2qb09Dqk+5McyVA+4c5tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=PBsNBsU7BY6C7lAfXKklGf8nUYze5AXKchvgMMlH4YI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUqDs7hgDJFq2OPR0r+5XIP63t/c1qS2ZsGzoW7gzrqjar6MfmhnC8Hgup/i2X11w7zQbTWLy8b9W1CDnVLY7cnCPNUI3RZdnkD0tGUcgA2OovjjZZRZ9VTtD0XWRkCgnrLONZORmZN3o21nbxQDMrwitKsJzl9oIDZdzyiRdhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlv7KWCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlv7KWCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E71C4CEFC;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=PBsNBsU7BY6C7lAfXKklGf8nUYze5AXKchvgMMlH4YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlv7KWCTbt7XnhdAskkxhrX1YQiMv2MboAHykPLEud7E27NnKx3vXpcj3fTQDHE5R
	 MNq8zcQYbbxYrw0jTJsAr0ncIAracRCkolPJkF9VbKj37Xv0USr1Wnm5+RPqIQIrcZ
	 mncTX6FXNQBqEnkWMnDlpeK1elhenhItjrZH+VRxkgrdOFBRdOjQwv5TQ7L6j4iTI/
	 Yr/X7KSWvOgzQ6X9QKGnj0ySld8HGuTdEDbKwCo5xW+1g3Rj+mRgzM58NX9FbMA9Nf
	 iNIlBcBYo8owX/GXjJuGZO2y5KdG3WpOon+gv3otpp2dHrQ2pT//hpUxzOdSxbunnX
	 i+bEGlXF8W/bQ==
Received: by pali.im (Postfix)
	id 6918DF12; Sun, 31 Aug 2025 14:36:31 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/35] cifs: Remove code for querying FILE_INFO_STANDARD via CIFSSMBQPathInfo()
Date: Sun, 31 Aug 2025 14:35:31 +0200
Message-Id: <20250831123602.14037-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Querying FILE_INFO_STANDARD structure via SMB_INFO_STANDARD level over
TRANS2_QUERY_PATH_INFORMATION or TRANS2_QUERY_FILE_INFORMATION command
(implemented in CIFSSMBQPathInfo() when called with argument legacy=true)
is mostly unusable.

Win9x SMB server returns over those commands the FILE_INFO_STANDARD
structure with swapped TIME and DATE fields, compared with [MS-CIFS] spec
and Samba server implementation. Therefore this command cannot be used
unless we know against which server implementation we are connected.

There are already two fallback mechanisms for querying information about
path which are working correctly against Samba, NT and Win9x servers:
CIFSFindFirst() and SMBQueryInformation() commands.

So remove TRANS2_QUERY_PATH_INFORMATION/SMB_INFO_STANDARD code from
CIFSSMBQPathInfo() function, when the function is called with legacy=true.

Note that there is no use of CIFSSMBQPathInfo(legacy=true) anymore.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h |  1 -
 fs/smb/client/cifssmb.c   | 22 +++-------------------
 fs/smb/client/smb1ops.c   |  4 ++--
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c34c533b2efa..f467b24fd984 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -368,7 +368,6 @@ extern int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			u16 netfid, FILE_ALL_INFO *pFindData);
 extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			    const char *search_Name, FILE_ALL_INFO *data,
-			    int legacy /* whether to use old info level */,
 			    const struct nls_table *nls_codepage, int remap);
 extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 			       const char *search_name, FILE_ALL_INFO *data,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index d20766f664c4..42ab901a08e7 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3856,7 +3856,6 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *search_name, FILE_ALL_INFO *data,
-		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
 	/* level 263 SMB_QUERY_FILE_ALL_INFO */
@@ -3904,10 +3903,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	byte_count = params + 1 /* pad */ ;
 	pSMB->TotalParameterCount = cpu_to_le16(params);
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	if (legacy)
-		pSMB->InformationLevel = cpu_to_le16(SMB_INFO_STANDARD);
-	else
-		pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
+	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
 	pSMB->Reserved4 = 0;
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount = cpu_to_le16(byte_count);
@@ -3921,25 +3917,13 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = -EIO;
-		else if (!legacy && get_bcc(&pSMBr->hdr) < 40)
+		else if (get_bcc(&pSMBr->hdr) < 40)
 			rc = -EIO;	/* bad smb */
-		else if (legacy && get_bcc(&pSMBr->hdr) < 24)
-			rc = -EIO;  /* 24 or 26 expected but we do not read
-					last field */
 		else if (data) {
 			int size;
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
 
-			/*
-			 * On legacy responses we do not read the last field,
-			 * EAsize, fortunately since it varies by subdialect and
-			 * also note it differs on Set vs Get, ie two bytes or 4
-			 * bytes depending but we don't care here.
-			 */
-			if (legacy)
-				size = sizeof(FILE_INFO_STANDARD);
-			else
-				size = sizeof(FILE_ALL_INFO);
+			size = sizeof(FILE_ALL_INFO);
 			memcpy((char *) data, (char *) &pSMBr->hdr.Protocol +
 			       data_offset, size);
 		} else
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index de415b9945ee..9dca458dbc96 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -526,7 +526,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &file_info,
-				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_sb->local_nls,
 				      cifs_remap(cifs_sb));
 
 	/*
@@ -571,7 +571,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	 * do not even use CIFSSMBQPathInfo() or CIFSSMBQFileInfo() function.
 	 */
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
-		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi, 0 /* not legacy */,
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi,
 				      cifs_sb->local_nls, cifs_remap(cifs_sb));
 
 	/*
-- 
2.20.1

