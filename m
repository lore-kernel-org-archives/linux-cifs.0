Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF5F1B4124;
	Tue, 31 Dec 2024 22:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684587; cv=none; b=POr3wOOE/N2OKvxiw24+gIlfZMRcFUb5P/3h+ddN5/Q5LzB6sDn3v7UNs1q7r82IGAn3tNb7Cc9hRZjNxXgjGmyEl14gnLeFZ6CClPq/1GR5GYIgOqzzMYKYrr97w6PcAwxM8RKnoawY1qcSZ2fC42bEVAqqFtYj7qRop3OgxoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684587; c=relaxed/simple;
	bh=hMGt3xP5uxThkXF/W8BvyH2YsnrYE4JOtErkvvsZBUY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Npqi1TXFiIyaVPPAGCgZYLvf8MJmA9SZCfLt4gSZLlUP6lDTjLL4NsNgqmE1PbftZ+rA9fMFlvWokFT4Km1aBnZjWyrE2mWhJsbexoOHRosCUQyDzwFkx+CbKpBDuCL2Errl6/kcvHBqfmckYuGahcPosNt9xl3DbfDpgianchw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYEkV4aR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYEkV4aR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F968C4CED2;
	Tue, 31 Dec 2024 22:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684587;
	bh=hMGt3xP5uxThkXF/W8BvyH2YsnrYE4JOtErkvvsZBUY=;
	h=From:To:Cc:Subject:Date:From;
	b=PYEkV4aRC5x0ui5P65UKMaOneBiTQH3WfeuzjEzHpYjo/PHkBpoatstQS3eoBIIgZ
	 nlUr80fetQauJu5VUcgeLc2wQdYQfg6TKxlTLau1iThxaV0mL9n77gR3Frja2W8lN5
	 3sx2Nb/Cks4tVRdp2OX1VCYMORkYPU+/8fqMqSEt2RUx5a6WvuvXmAi3PNPvAB4WDd
	 VP8tFBQKhAGTn57q8S81zHi9z7ZXmCWIUv+XpSV57d+PnrChoLFrhMp31CDj2zP1Vp
	 zbO4TlaH673HSfhzZyGV+eDaaFUE+e9n0ya9LqhZ54SqPVkg7XhP6jnlHah8jYPr0H
	 gCGi29IDhQYvQ==
Received: by pali.im (Postfix)
	id 9AEB797E; Tue, 31 Dec 2024 23:36:17 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix querying and creating MF symlinks over SMB1
Date: Tue, 31 Dec 2024 23:36:10 +0100
Message-Id: <20241231223610.15697-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Old SMB1 servers without CAP_NT_SMBS do not support CIFS_open() function
and instead SMBLegacyOpen() needs to be used. This logic is already handled
in cifs_open_file() function, which is server->ops->open callback function.

So for querying and creating MF symlinks use open callback function instead
of CIFS_open() function directly.

This change fixes querying and creating new MF symlinks on Windows 98.
Currently cifs_query_mf_symlink() is not able to detect MF symlink and
cifs_create_mf_symlink() is failing with EIO error.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/link.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index b1a346e20b07..2ecd705e9e8c 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -259,7 +259,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	FILE_ALL_INFO file_info;
+	struct cifs_open_info_data query_data;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -271,11 +271,11 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -314,7 +314,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
 		return rc;
 
-- 
2.20.1

