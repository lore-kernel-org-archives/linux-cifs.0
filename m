Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981CD18FDA9;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734882290; cv=none; b=enucRBJk16GdpuP+ha6+yMLft55DMfhMME1fzBoONpmdaOWUTz3iKC8+ziGDwxjg4B8U/xU5KYpqBges/rYg6SVOkwNmTiUDuatpyV7fwathbb3PpaAinTwcFZwdQLU21fUrn1QmuDQjB+N5RQ7Lzq3K/PQ+0py28QO3uThyLP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734882290; c=relaxed/simple;
	bh=JDQEZOdsea2srLQIbWI7xsM4aLspm8HPEYwnQDEVrW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A/W5gvMwAX/FuYTTZmmJP72uc334Ht5tfvAi1OXAOm4a8bL7tMHq87ywGM+KGZqTAVFgZzmNNwMzQJd8YJheVjIl0H2cfht5ThtUQRtGNcc75JVreduvFOjpZqdTfzxyUFVwXocTddrkeZxqPTZqmyZOgCYk3qCgSXhZklTyFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YU9heYRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YU9heYRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EE5C4CEDC;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734882290;
	bh=JDQEZOdsea2srLQIbWI7xsM4aLspm8HPEYwnQDEVrW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YU9heYRSJlNR5u3F+kJKG8orYtIgtee58klEetcyP/yeUfYr5YYXvH75RrE7kzOA1
	 bQ+rVP8MW5mu2AwzAaCU1P12DzMhdM7iBkrH4vnODM1QCgyY4a/KoF2lJi4dCRhcuJ
	 CN+uR4dyJDXeBQkmYeDpEdW8x0GuGSs3wGXN1QTQv8UdAbnPFeTWSa1jmBlUy2efPv
	 bL88NtNTkINWQ56ookx53lKDeURHencsY97SXZBB59V2vl4LjRz1AUMyqOgM6zxsjF
	 ED6i2h496Cfr+/487mF28/pmKEMvOWGOCo0zJ/a/F1OHH6+yy2XJE+fmX/tHpbMjh2
	 EGqw662TQH66Q==
Received: by pali.im (Postfix)
	id 70ACAD48; Sun, 22 Dec 2024 16:44:40 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cifs: Change translation of STATUS_NOT_A_REPARSE_POINT to -ENODATA
Date: Sun, 22 Dec 2024 16:43:39 +0100
Message-Id: <20241222154340.24104-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222154340.24104-1-pali@kernel.org>
References: <20241222154340.24104-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

STATUS_NOT_A_REPARSE_POINT indicates that object does not have repase point
buffer attached, for example returned by FSCTL_GET_REPARSE_POINT.

Currently STATUS_NOT_A_REPARSE_POINT is translated to -EIO. Change it to
-ENODATA which better describe the situation when no reparse point is set.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/netmisc.c      | 7 +++++++
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb2maperror.c | 2 +-
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index a2fb1ae14d41..0ff3ccc7a356 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -871,6 +871,13 @@ map_smb_to_linux_error(char *buf, bool logErr)
 	}
 	/* else ERRHRD class errors or junk  - return EIO */
 
+	/* special cases for NT status codes which cannot be translated to DOS codes */
+	if (smb->Flags2 & SMBFLG2_ERR_STATUS) {
+		__u32 err = le32_to_cpu(smb->Status.CifsError);
+		if (err == (NT_STATUS_NOT_A_REPARSE_POINT))
+			rc = -ENODATA;
+	}
+
 	cifs_dbg(FYI, "Mapping smb error code 0x%x to POSIX err %d\n",
 		 le32_to_cpu(smb->Status.CifsError), rc);
 
diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 358a766375b4..777431912e64 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -667,6 +667,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_QUOTA_LIST_INCONSISTENT",
 	 NT_STATUS_QUOTA_LIST_INCONSISTENT},
 	{"NT_STATUS_FILE_IS_OFFLINE", NT_STATUS_FILE_IS_OFFLINE},
+	{"NT_STATUS_NOT_A_REPARSE_POINT", NT_STATUS_NOT_A_REPARSE_POINT},
 	{"NT_STATUS_NO_MORE_ENTRIES", NT_STATUS_NO_MORE_ENTRIES},
 	{"NT_STATUS_MORE_ENTRIES", NT_STATUS_MORE_ENTRIES},
 	{"NT_STATUS_SOME_UNMAPPED", NT_STATUS_SOME_UNMAPPED},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index edd4741cab0a..180602c22355 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -546,6 +546,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_TOO_MANY_LINKS 0xC0000000 | 0x0265
 #define NT_STATUS_QUOTA_LIST_INCONSISTENT 0xC0000000 | 0x0266
 #define NT_STATUS_FILE_IS_OFFLINE 0xC0000000 | 0x0267
+#define NT_STATUS_NOT_A_REPARSE_POINT 0xC0000000 | 0x0275
 #define NT_STATUS_NO_SUCH_JOB 0xC0000000 | 0xEDE	/* scheduler */
 
 #endif				/* _NTERR_H */
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 00c0bd79c074..daa56b2a2a1a 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -871,7 +871,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_VALIDATE_CONTINUE, -EIO, "STATUS_VALIDATE_CONTINUE"},
 	{STATUS_NO_MATCH, -EIO, "STATUS_NO_MATCH"},
 	{STATUS_NO_MORE_MATCHES, -EIO, "STATUS_NO_MORE_MATCHES"},
-	{STATUS_NOT_A_REPARSE_POINT, -EIO, "STATUS_NOT_A_REPARSE_POINT"},
+	{STATUS_NOT_A_REPARSE_POINT, -ENODATA, "STATUS_NOT_A_REPARSE_POINT"},
 	{STATUS_IO_REPARSE_TAG_INVALID, -EIO, "STATUS_IO_REPARSE_TAG_INVALID"},
 	{STATUS_IO_REPARSE_TAG_MISMATCH, -EIO,
 	"STATUS_IO_REPARSE_TAG_MISMATCH"},
-- 
2.20.1

