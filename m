Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053573;
	b=Fofvc+i81dmHE9toTVXYBFtyQMPzRH5dsHlXuIK/yztH6D9uEp67QJI953Jclqm6FoVl
	 8/hhnjfMJofOza4tJz/dT8gshvd9mouaG4y2EFjKeTVflGnsx0eiXimSzLGBr0Q9oefSX
	 upiZMFIQVPairMEsIXGdAnS2lwfL49JEz4pVb/BOeNVfpDLFpjs9z4Jw5PbMmEniXawwG
	 +XBa01M3eR1z10lcN/YrPeIRliV7W4u0Zj2PIhgrhk2FfGFa2v2ZlOZ2tE2yMxpfCEFEV
	 EAYowSjyFajdtP+yWG2gVfltjvvTB33I1thHWK48ewJa7HFJD8QSD8JChbt+hmjPMLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053573;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7VKj4mJ1D2Spwo3h/8zqbn22lXUbnbkbxwIyAxSGCzg=;
	b=OpJJ6BXMCFd50tto/IZKzDD96d5FzecQTmDJSSLk9ymxglIV81GuNVqu89Kd/RUaASQW
	 YzkqadhVBJkwDF9J8lfOfbZ/IvhjSaThVuNGW9HWNOjU78k+kTyPqYCviqDm/RtHg8V/N
	 JbwPNK83a55tJ/JbKy9geDbfVxWdegv16zHNB0v+mDtcEhORdfBzc6OFLpTHEpQwb87cr
	 lnd9Qp3FN1LIIF5Olb44xHdA/EqEPtTexAoY7ntww/wuR383k2MnFxL6QGElIVMTNcifa
	 ON6rQz7Dt2adkq/ybaAcKE7F7zZGNJHYA17tTiWQVbHhwcUWKfAjmslx8KsQ3Qcztaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gi8+F+dc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9757D606A31A;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gi8+F+dc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274F61F01828;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053573;
	bh=7VKj4mJ1D2Spwo3h/8zqbn22lXUbnbkbxwIyAxSGCzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gi8+F+dcnh2Zg4WEZ0NimaLyXnj96AiMW6qeUDqsqU0pp8XUY7Vux1cqtCI3aVtZR
	 ASbnRv0MemVn9XduF/atMh0AyMi7LtWbltcYhTImoXusvn/15OFlPuyglY9fWOH6Ga
	 eZPGz0L1iHYg1x6y9ZXjRMGA4r3QMszh9ajQUPA9NcoiFvWo4zT7Ux7NjdR+Xgmso/
	 ebaxWIMOyClKK9qSrjcvjXbqC293TqGIQF8Fkc1awuqtjJQ1GSzDOT2kIm2we7Apsd
	 abhpPnfx8Kna29S9tlSKlzi37ByrYOIvDHsqT9yEGC6EBl9OmAb7naCiHE0t8d100C
	 wZKYle1xKIoTg==
Received: by pali.im (Postfix)
	id B118E83A; Mon, 26 Oct 2026 23:26:09 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 1/9] cifs: Remove code for querying FILE_INFO_STANDARD via CIFSSMBQPathInfo()
Date: Mon, 26 Oct 2026 23:25:52 +0100
Message-Id: <20261026222600.17323-2-pali@kernel.org>
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
index 6dddbd84b93b..8bdd81af6d21 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4144,7 +4144,6 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *search_name, FILE_ALL_INFO *data,
-		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
 	/* level 263 SMB_QUERY_FILE_ALL_INFO */
@@ -4194,10 +4193,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -4212,27 +4208,14 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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

