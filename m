Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112E1BD9DB;
	Tue, 31 Dec 2024 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684632; cv=none; b=o8+vPoro4acwpagW5R7vmzN61iSAjJSLTpOCgOtQMs0FEfG8CreNw46h1GGVmA1uEqqjO+Gpd0HO+Qx9MnJX1/yZPCNsu59EsPnrQ6eh1Hthz9pTjHR5JSY0SzkiwoeYEevKfmSyo5xCtRFcKR+pC8sywtaTZAXfARWaLvmLSG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684632; c=relaxed/simple;
	bh=UWkpvBOsLVGSoGQCgId4dC2bh1SGJftMfZdSlT04PQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCo6DBr4lfIwnfK+lHlcyUS2KKpzZKHKO05d87ivIFZieiE1/p6lnxblvf4rCeRn2MK/Ll+rZKBYeu+M6tSIgia6Prdi5IO944DFJeVSUrXCkIp4B24WXTEv7aLRgODbyNmXk1weVhvbfLVXby69ucA04uTd6E+OT63IE5ckoXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+YvGGSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+YvGGSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0803BC4CEEA;
	Tue, 31 Dec 2024 22:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684632;
	bh=UWkpvBOsLVGSoGQCgId4dC2bh1SGJftMfZdSlT04PQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+YvGGSkwXwkJjiUAgC2Fcsg0pQ//iulHTwTma6kfNmyZZbP6bOTNWjycpEocav0N
	 bH2UhCCIR3xtPJeBuikpGUSTS7aSz8sMPU166GnLco/0mFxhMiJDD4Rt+QdViXd/WE
	 OiQsu2ZiktGeMv09WXsM1ugIcPx6p87Q+RZFyj+lRnTsmnL0WT9e4sBP76gTUu3b9B
	 PqhDzx9NXLZ4reg1YnIiSfYnB0tAVoRorUHKYk6mTMj/xcIYlHDFK0hfX8KVgLykAS
	 zzQAQrdSkQfPBLD2LvGfe9gIkhE0G033wo07/1+WvDKe0wuOaIknPxfsgoWV8gSuqq
	 W2gjJJbxGuR5A==
Received: by pali.im (Postfix)
	id 23F19F3C; Tue, 31 Dec 2024 23:37:01 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 08/12] cifs: Remove code for querying FILE_INFO_STANDARD via CIFSSMBQPathInfo()
Date: Tue, 31 Dec 2024 23:36:38 +0100
Message-Id: <20241231223642.15722-8-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Querying FILE_INFO_STANDARD structure via SMB_QUERY_FILE_ALL_INFO level
over TRANS2_QUERY_PATH_INFORMATION or TRANS2_QUERY_FILE_INFORMATION command
(implemented in CIFSSMBQPathInfo() when called with argument legacy=true)
is mostly unusable.

Win9x SMB server returns over those commands the FILE_INFO_STANDARD
structure with swapped TIME and DATE fields, compared with [MS-CIFS] spec
and Samba server implementation. Therefore this command cannot be used
unless we know against which server implementation we are connected.

There are already two fallback mechanisms for querying information about
path which are working correctly against Samba, NT and Win9x servers:
CIFSFindFirst() and SMBQueryInformation() commands.

So remove TRANS2_QUERY_PATH_INFORMATION/SMB_QUERY_FILE_ALL_INFO code from
CIFSSMBQPathInfo() function, when the function is called with legacy=true.
Note that there is no use of CIFSSMBQPathInfo(legacy=true) anymore.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h |  1 -
 fs/smb/client/cifssmb.c   | 22 +++-------------------
 fs/smb/client/smb1ops.c   |  4 ++--
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index ea8a0ecce9dc..52548238b467 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -351,7 +351,6 @@ extern int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			u16 netfid, FILE_ALL_INFO *pFindData);
 extern int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			    const char *search_Name, FILE_ALL_INFO *data,
-			    int legacy /* whether to use old info level */,
 			    const struct nls_table *nls_codepage, int remap);
 extern int SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 			       const char *search_name, FILE_ALL_INFO *data,
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index c0dc404e27b3..c88b6ea7c00a 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3816,7 +3816,6 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *search_name, FILE_ALL_INFO *data,
-		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
 	/* level 263 SMB_QUERY_FILE_ALL_INFO */
@@ -3864,10 +3863,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -3881,25 +3877,13 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 
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
index a7a846260736..49b5b75ef2f0 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -525,7 +525,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &file_info,
-				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_sb->local_nls,
 				      cifs_remap(cifs_sb));
 
 	/*
@@ -570,7 +570,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	 * do not even use CIFSSMBQPathInfo() or CIFSSMBQFileInfo() function.
 	 */
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
-		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi, 0 /* not legacy */,
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi,
 				      cifs_sb->local_nls, cifs_remap(cifs_sb));
 
 	/*
-- 
2.20.1

