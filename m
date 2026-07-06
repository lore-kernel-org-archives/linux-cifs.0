Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99563CE0A0;
	Mon,  6 Jul 2026 18:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363728; cv=none; b=N7R4D8B1Q3jNEgftNumT3gLuq1P75rGLFtFNppOt0bHdnDJDYVTh6Yjtbcibzed2RLEx/weabMKM0ODQRSjKL7VPCMIBz3i2YfMnMHXAtdRgQJrhYvlyeD+NM9672P8Oc/eC/yuexBNYgin+6idEQOdLUbTq3lHGEw0SJGGWqMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363728; c=relaxed/simple;
	bh=o8VqMUd5B6LLfCENW0vVL5A4Plv1PXMXnxj8EsJcUhY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRdt5uLhqUFO4NEJ31PlW8z7sKne9Dc7r5US7nsDyD2HmSsOEu4h4JBOJaAfYicG22vO3pmFqS0U/vod+BODrXC01QqgbWMDlN50rGyqLS5EuzgozNUwx8W72hmmqYvcAEHlLG37dwtk4mnwnNr0CiehhL1qA2nycGuFPDjB5eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMsvvLkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMsvvLkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184B51F00A3F;
	Mon,  6 Jul 2026 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363718;
	bh=Nuqp/5oV13E9I6WRNSgmpmOvG6gjq3PaCGM8zTMST6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMsvvLkOonW3NmxoFDvblpMRFQYUe++hvDlAW6E5BglyZ9f4PW/8D7Iu7gczL08mn
	 DlZbK0xjQJ8u6zuTMQOPtLdJS8cWR3+B9b+R1eH4PtGzlWmP/cpncrB4zgWyf2masA
	 ZitfXDDc4cogcfX7s3qnqE1MZhBqfHcRuNt13caZTxsacVx+2FfdfRJGX49lcNrxMX
	 eGFetWm6am+oEV0ApfvE2JH9+B+psQ4aI+TmQ1L0KpqzA3J5MZdo/uHglYFgeN8QLk
	 Fde2Yi1E4Bq2ASJ92k3U3AeFMxjrWO23s006EbatC7hGeQydXlYvanbsbiSbzf0jJA
	 04dhpBfjfvG2A==
Received: by pali.im (Postfix)
	id 56828BB9; Mon,  6 Jul 2026 20:48:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 02/11] cifs: Remove code for querying FILE_INFO_STANDARD via CIFSSMBQPathInfo()
Date: Mon,  6 Jul 2026 20:48:10 +0200
Message-Id: <20260706184819.22124-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260706184819.22124-1-pali@kernel.org>
References: <20260706184819.22124-1-pali@kernel.org>
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
index d39175cdf1b1..d7a6955d904e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4107,7 +4107,6 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 int
 CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 		 const char *search_name, FILE_ALL_INFO *data,
-		 int legacy /* old style infolevel */,
 		 const struct nls_table *nls_codepage, int remap)
 {
 	/* level 263 SMB_QUERY_FILE_ALL_INFO */
@@ -4157,10 +4156,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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
@@ -4175,27 +4171,14 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
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
index 437ee5542a8e..e14ab5449943 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -510,7 +510,7 @@ cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (tcon->ses->capabilities & CAP_NT_SMBS)
 		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &file_info,
-				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_sb->local_nls,
 				      cifs_remap(cifs_sb));
 
 	/*
@@ -555,7 +555,7 @@ static int cifs_query_path_info(const unsigned int xid,
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

