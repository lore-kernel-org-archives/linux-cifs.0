Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078D334A1A8;
	Mon,  5 May 2025 22:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484774; cv=none; b=mY66K/Zemf6wGEf3lNhSQ4OK6OoCPtSbcuqrQSQYhkTVLFysHfBaopey0Yi233VJAm0RoCmJKryWO+m7Mij96UVxvudzrXrtHiNfKlbRtspIvBcfXUtAbfc/6ecRvd9Y+14pAdjN7Bl7s/lSOYWurNeTBtbidokjGvUdLRK+ZKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484774; c=relaxed/simple;
	bh=HWH1ugpSoG/RqzhXFGn6QF6bHYVSCrUdy0rrFXGONEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpusbBPHb8UU9zQIVkqYaAId5/WSNURfCr4RmnjjPT353GBvEc31OFIRiC0d7zpyNt7+pyb4mxjnwaQIY+AD6ZLLbh5aVGI2WLufAT63UJ6drnWdGm2htR6QgYVn9WP5Enunvn7Fke66A/Eg5lW3198KTVNreBHInT/KYOPQqMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/ohHrBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/ohHrBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CD3C4CEE4;
	Mon,  5 May 2025 22:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484773;
	bh=HWH1ugpSoG/RqzhXFGn6QF6bHYVSCrUdy0rrFXGONEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/ohHrBAMnmY3avwRMi9nil+GUwtaS3vqyf6Ujyws883NmaMiSbPG9S0kWjhzj0VN
	 IEEYNCzJyEXj+EzJHquPdT4E0Ch2k8qlts1vovuTacPGkDPlj94oOr8UjiVI8zciVU
	 VgJAUILGcmq56fXEzdBCHPPt058B2HSILP08qRmncGq7T3Ym+dB78V/4QWUpLFiUS2
	 gds4CA2f13lvMXxvN3ZrAzPoaaE7gXU2EfdydUxVm6GIldGLMWnhOiIlDQwm4/YSI6
	 JHGxYAZFY94L4TdrqEiN3tN5grfUCZ6iNt7zUCdTZcRi4mEjNJkKlwvYpjtEL2gdrm
	 qSij1bRp3BADQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 005/486] cifs: Fix querying and creating MF symlinks over SMB1
Date: Mon,  5 May 2025 18:31:21 -0400
Message-Id: <20250505223922.2682012-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 4236ac9fe5b8b42756070d4abfb76fed718e87c2 ]

Old SMB1 servers without CAP_NT_SMBS do not support CIFS_open() function
and instead SMBLegacyOpen() needs to be used. This logic is already handled
in cifs_open_file() function, which is server->ops->open callback function.

So for querying and creating MF symlinks use open callback function instead
of CIFS_open() function directly.

This change fixes querying and creating new MF symlinks on Windows 98.
Currently cifs_query_mf_symlink() is not able to detect MF symlink and
cifs_create_mf_symlink() is failing with EIO error.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/link.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index 47ddeb7fa1116..aa45ef6ae99a6 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -257,7 +257,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	FILE_ALL_INFO file_info;
+	struct cifs_open_info_data query_data;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -269,11 +269,11 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, &file_info);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, &query_data);
 	if (rc)
 		return rc;
 
-	if (file_info.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
+	if (query_data.fi.EndOfFile != cpu_to_le64(CIFS_MF_SYMLINK_FILE_SIZE)) {
 		rc = -ENOENT;
 		/* it's not a symlink */
 		goto out;
@@ -312,7 +312,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
 		return rc;
 
-- 
2.39.5

