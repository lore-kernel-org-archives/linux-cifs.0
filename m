Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F793268690;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=sNX/6Sn2085SLT5C2/XWtiPbvdxJHb46TI3Bqz3rrUq2UqlAO+sKUgATaJhUHQw83DoOIWYXeK/ib//2vbybcbdHv2K0y4sdIoyhPmETsTilrth2nOPcf/2456SFGZ67rdmcuMO7yAqJWdkw6SIp+miKFuTXoY1CtIGUiE1C6pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=ZLF42ulSn4oztGUtexC/05mImgiTglF5VFIenWM/R94=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JZomm0YJaPNeuQ0apHk9+ZEvZ4Ynomq9A8C4Nvk0Dh5vSJCP/HepB1JffeNMUTE5L5lQ2cSvjWeHzMrDEuy39BOaTWQYCJwNB3ugrqRbeamMWVyF5mcvP9uVsvV0RvdYyilwmHk9peH1yP51ynp24PO3n1DI356wFC3U7fG/sd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmlH9VDO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmlH9VDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A941C4CEF5;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=ZLF42ulSn4oztGUtexC/05mImgiTglF5VFIenWM/R94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmlH9VDOPQw2LRQdaradMDTvNfbtjZgl7WPT9jqHmNs3QnIPjv1sdbX6rUHmf401c
	 eot98YGuza9eDBYSAL4QVUQT2UqaUdUE3XuO8RtoxAdRhb6GH9GxF5gLMlw2RBtgxl
	 c/DNIj4qf37pkfsVujA4OdnDZV6iuyXm49ZzW3sujfzTxtzrCOeMZjTPsm76Nq2fhr
	 WzJbR/yatBZQMDRbMkQvL5QZ6l39xeApyNCrWr0hr3WfZt9ATzgeCd6n+/Q7XykENQ
	 j+ozLlQqTZHkd6BO+MODWIPzN5aJ9fQV5NiBcNPmiTN41nDyW2wQEv3+Lji+tYRPd5
	 F4MDfgi8Tu9LA==
Received: by pali.im (Postfix)
	id 64455D70; Sun, 31 Aug 2025 14:36:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 23/35] cifs: Fix SMBLegacyOpen() function
Date: Sun, 31 Aug 2025 14:35:50 +0200
Message-Id: <20250831123602.14037-24-pali@kernel.org>
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

Function SMBLegacyOpen() contains many FIXME comments, commented code and
missing handling of different flags.

Fix the FIXME comments, add missing handling of different flags and use
named macros as constants instead of magic numbers.

This is done according to MS-CIFS spec.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h |  4 +++
 fs/smb/client/cifssmb.c | 73 +++++++++++++++++++++++++++--------------
 fs/smb/client/smb1ops.c |  4 ++-
 3 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index d9cf7db0ac35..cb1f99d22dd7 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -137,6 +137,10 @@
  * Flags on SMB open
  */
 #define SMBOPEN_WRITE_THROUGH 0x4000
+#define SMBOPEN_DO_NOT_CACHE  0x1000
+#define SMBOPEN_RANDOM_ACCESS 0x0200
+#define SMBOPEN_SEQUENTIAL    0x0100
+#define SMBOPEN_DENY_COMPAT   0x0000
 #define SMBOPEN_DENY_ALL      0x0010
 #define SMBOPEN_DENY_WRITE    0x0020
 #define SMBOPEN_DENY_READ     0x0030
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2a83fbc65395..c09713ebdc7c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1103,32 +1103,41 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 		count = 0;      /* no pad */
 		name_len = copy_path_name(pSMB->fileName, fileName);
 	}
-	if (*pOplock & REQ_OPLOCK)
-		pSMB->OpenFlags = cpu_to_le16(REQ_OPLOCK);
-	else if (*pOplock & REQ_BATCHOPLOCK)
+
+	if (*pOplock & REQ_BATCHOPLOCK)
 		pSMB->OpenFlags = cpu_to_le16(REQ_BATCHOPLOCK);
+	else if (*pOplock & REQ_OPLOCK)
+		pSMB->OpenFlags = cpu_to_le16(REQ_OPLOCK);
+
+	if (pfile_info)
+		pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
 
-	pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
 	pSMB->Mode = cpu_to_le16(access_flags_to_smbopen_mode(access_flags));
-	pSMB->Mode |= cpu_to_le16(0x40); /* deny none */
+	pSMB->Mode |= cpu_to_le16(SMBOPEN_DENY_NONE);
+
+	if (create_options & CREATE_WRITE_THROUGH)
+		pSMB->Mode |= cpu_to_le16(SMBOPEN_WRITE_THROUGH);
+
+	if (create_options & CREATE_NO_BUFFER)
+		pSMB->Mode |= cpu_to_le16(SMBOPEN_DO_NOT_CACHE);
+
+	if (create_options & CREATE_RANDOM_ACCESS)
+		pSMB->Mode |= cpu_to_le16(SMBOPEN_RANDOM_ACCESS);
+	else if (create_options & CREATE_SEQUENTIAL)
+		pSMB->Mode |= cpu_to_le16(SMBOPEN_SEQUENTIAL);
+
 	/* set file as system file if special file such as fifo,
 	 * socket, char or block and server expecting SFU style and
 	   no Unix extensions */
-
 	if (create_options & CREATE_OPTION_SPECIAL)
 		pSMB->FileAttributes = cpu_to_le16(ATTR_SYSTEM);
-	else /* BB FIXME BB */
-		pSMB->FileAttributes = cpu_to_le16(0/*ATTR_NORMAL*/);
+	else
+		pSMB->FileAttributes = cpu_to_le16(0);
 
 	if (create_options & CREATE_OPTION_READONLY)
 		pSMB->FileAttributes |= cpu_to_le16(ATTR_READONLY);
 
-	/* BB FIXME BB */
-/*	pSMB->CreateOptions = cpu_to_le32(create_options &
-						 CREATE_OPTIONS_MASK); */
-	/* BB FIXME END BB */
-
-	pSMB->Sattr = cpu_to_le16(ATTR_HIDDEN | ATTR_SYSTEM | ATTR_DIRECTORY);
+	pSMB->Sattr = cpu_to_le16(ATTR_READONLY | ATTR_HIDDEN | ATTR_SYSTEM | ATTR_ARCHIVE);
 	pSMB->OpenFunction = cpu_to_le16(convert_disposition(openDisposition));
 	count += name_len;
 	inc_rfc1001_len(pSMB, count);
@@ -1139,24 +1148,38 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
 	if (rc) {
 		cifs_dbg(FYI, "Error in Open = %d\n", rc);
+	} else if (pSMBr->hdr.WordCount != 15) {
+		rc = -EIO;
 	} else {
-	/* BB verify if wct == 15 */
-
-/*		*pOplock = pSMBr->OplockLevel; */ /* BB take from action field*/
+		if (!(pSMBr->Action & 0x8000))
+			*pOplock = OPLOCK_NONE;
+		else if (*pOplock & REQ_BATCHOPLOCK)
+			*pOplock = OPLOCK_BATCH;
+		else if (*pOplock & REQ_OPLOCK)
+			*pOplock = OPLOCK_EXCLUSIVE;
+		else
+			*pOplock = OPLOCK_NONE;
 
 		*netfid = pSMBr->Fid;   /* cifs fid stays in le */
+
 		/* Let caller know file was created so we can set the mode. */
 		/* Do we care about the CreateAction in any other cases? */
-	/* BB FIXME BB */
-/*		if (cpu_to_le32(FILE_CREATE) == pSMBr->CreateAction)
-			*pOplock |= CIFS_CREATE_ACTION; */
-	/* BB FIXME END */
+		if ((pSMBr->Action & 0x0003) == 2)
+			*pOplock |= CIFS_CREATE_ACTION;
 
 		if (pfile_info) {
-			pfile_info->CreationTime = 0; /* BB convert CreateTime*/
-			pfile_info->LastAccessTime = 0; /* BB fixme */
-			pfile_info->LastWriteTime = 0; /* BB fixme */
-			pfile_info->ChangeTime = 0;  /* BB fixme */
+			struct timespec64 ts;
+			__u32 time = le32_to_cpu(pSMBr->LastWriteTime);
+
+			ts.tv_nsec = 0;
+			ts.tv_sec = time;
+			pfile_info->LastWriteTime = cpu_to_le64(cifs_UnixTimeToNT(ts));
+			pfile_info->ChangeTime = pfile_info->LastWriteTime;
+			if (*pOplock & CIFS_CREATE_ACTION)
+				pfile_info->CreationTime = pfile_info->LastWriteTime;
+			else
+				pfile_info->CreationTime = 0;
+			pfile_info->LastAccessTime = 0;
 			pfile_info->Attributes =
 				cpu_to_le32(le16_to_cpu(pSMBr->FileAttributes));
 			/* the file_info buf is endian converted by caller */
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 6e928e90d72b..73d3dc83faa6 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -853,7 +853,9 @@ static int cifs_open_file(const unsigned int xid, struct cifs_open_parms *oparms
 				   oparms->disposition,
 				   oparms->desired_access,
 				   oparms->create_options,
-				   &oparms->fid->netfid, oplock, &fi,
+				   &oparms->fid->netfid,
+				   oplock,
+				   data ? &fi : NULL,
 				   oparms->cifs_sb->local_nls,
 				   cifs_remap(oparms->cifs_sb));
 	else
-- 
2.20.1

