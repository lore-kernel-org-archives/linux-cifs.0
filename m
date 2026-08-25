Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94C937C113;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699200; cv=none; b=u34XXXX5feADJ1K0K10sZKkCwSp9v1L+JypzitCwcT9uPRKs54S+3e+e93mgu7O9TFM74Z69DEm6qCHoYmEGdLJXLJ0Y2Ri4uKZPJ9S939Fd0Gw1/hf/4IQff8Myl55E3qmiV6zOv8vEtPG6F9JmGuJWCqPFeJz9il6zz4b+UBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699200; c=relaxed/simple;
	bh=JhkMWWqRJx9psoumgsDK98+2tpoQ068BSJ78/2DGbyk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kvE0F0SjDavLPEDfq1JyNNCraPlMzN4v7MAe9ocBuo6phyiAfpEtCus7lj1uQbvUy34TrXoXy/e7Iv/CvGwbIMTipYOPvPOSqiEf6njl6uLj1eS7ScKII5vc9xqUVOQyjsIJwK/W5bGVT8uBq9xFhl9Hx+/oNPeiHhhhA87euaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3Wa8HNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3Wa8HNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFEB1F000E9;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699198;
	bh=lQ/yTMtE+w6OzU2M5CM1aO06yMT7ElEm71XdraXjWes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3Wa8HNsc9zCaOaeIbtwedG2aQi21Cuv9h+/uCraQWms7rtCUQ0Ekpf4nhFeT75Z+
	 YFs2P+YyOkkFqQHY0856Op11f8fZVdDgW5GkEfsCU2txiSyj9a9SIGBatQLj88X7j4
	 IQKkNOEIYsNzWguS/UpeWvqEc7MrdXi7zOq+A9kePDucvqocizCSXLY0w46x7KmIsL
	 Y619lxtaEHhlY+FlbKw6ORTZXzJqAfAZHVavySRyuzWF65/Qlwc4QvLKu/elC2DxoY
	 vJ0Q6+Gq4ISrP0Mkg4yvaqtKnB0oQ53EJ5WWTRMZERGEY/0NA5VRi3RVULKbyp3os5
	 yXUUxCsoUYbxw==
Received: by pali.im (Postfix)
	id 19865A4E; Wed, 26 Aug 2026 01:06:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] cifs: Remove code for querying FILE_INFO_STANDARD via CIFSSMBQPathInfo()
Date: Wed, 26 Aug 2026 01:06:14 +0200
Message-Id: <20260825230622.24617-2-pali@kernel.org>
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
 fs/smb/client/cifssmb.c   | 23 +++--------------------
 fs/smb/client/smb1ops.c   |  4 ++--
 fs/smb/client/smb1proto.h |  1 -
 3 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..a972950b7e09 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4119,7 +4119,6 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *search_name, FILE_ALL_INFO *data,
-		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
 	/* level 263 SMB_QUERY_FILE_ALL_INFO */
@@ -4169,10 +4168,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	byte_count = params + 1 /* pad */ ;
 	pSMB->TotalParameterCount = cpu_to_le16(params);
 	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	if (legacy)
-		pSMB->InformationLevel = cpu_to_le16(SMB_INFO_STANDARD);
-	else
-		pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
+	pSMB->InformationLevel = cpu_to_le16(SMB_QUERY_FILE_ALL_INFO);
 	pSMB->Reserved4 = 0;
 	in_len += byte_count;
 	pSMB->ByteCount = cpu_to_le16(byte_count);
@@ -4187,27 +4183,14 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		if (rc) /* BB add auto retry on EOPNOTSUPP? */
 			rc = smb_EIO2(smb_eio_trace_qpathinfo_invalid,
 				      get_bcc(&pSMBr->hdr), 40);
-		else if (!legacy && get_bcc(&pSMBr->hdr) < 40)
+		else if (get_bcc(&pSMBr->hdr) < 40)
 			rc = smb_EIO2(smb_eio_trace_qpathinfo_bcc_too_small,
 				      get_bcc(&pSMBr->hdr), 40);
-		else if (legacy && get_bcc(&pSMBr->hdr) < 24)
-			/* 24 or 26 expected but we do not read last field */
-			rc = smb_EIO2(smb_eio_trace_qpathinfo_bcc_too_small,
-				      get_bcc(&pSMBr->hdr), 24);
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
index 3ac4126267f6..9c77752cb7f9 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -510,7 +510,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &file_info,
-				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_sb->local_nls,
 				      cifs_remap(cifs_sb));
 
 	/*
@@ -556,7 +556,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	 * do not even use CIFSSMBQPathInfo() or CIFSSMBQFileInfo() function.
 	 */
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
-		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi, 0 /* not legacy */,
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &fi,
 				      cifs_sb->local_nls, cifs_remap(cifs_sb));
 
 	/*
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 80eaeb3dd2ec..f0350fa3f173 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -141,7 +141,6 @@ int CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		     u16 netfid, FILE_ALL_INFO *pFindData);
 int CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		     const char *search_name, FILE_ALL_INFO *data,
-		     int legacy /* old style infolevel */,
 		     const struct nls_table *nls_codepage, int remap);
 int CIFSSMBUnixQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			 u16 netfid, FILE_UNIX_BASIC_INFO *pFindData);
-- 
2.20.1

