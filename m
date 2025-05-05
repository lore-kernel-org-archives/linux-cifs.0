Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1CD396ED5;
	Mon,  5 May 2025 23:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486394; cv=none; b=ka39qpECuW+wtJ8P62Ws2NgzcEe+eZZWkEDViGJmHCNwCuLl2yQbDfRaS+vRsk3xo+VB43qtU50Kl8jJnUWU7ieWCCnde9TRkmX6y9iX6tW87+9cHZyHCQF6qm/ybjpqOgg0Mg1bqvKCKK70QJvVz2usfTKU+VAscjkpwsCGFoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486394; c=relaxed/simple;
	bh=d8HLwVBJXftHhGusazL9mjEIpHK7Wy8ygOPuVThl/EQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0GhUPt868NaCpdgq9yLp8HQOjPh2ceEzRePnEL/Z0xBUI50M/ClJTz5Y1a45/cUPmFnHkqtTGWP0aBAfs7SDHa2nPXr+oExFBSxLdcmegp8sRXN3jHJhDoy1Yg4gPccpTbh2z1g0YHbmtsXp/149XyMVQ100jmFUqZ159CbVgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BP8qUy/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BP8qUy/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C89EC4CEF2;
	Mon,  5 May 2025 23:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486393;
	bh=d8HLwVBJXftHhGusazL9mjEIpHK7Wy8ygOPuVThl/EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BP8qUy/ZMQUvGxZ9TJL7hiDTdEC+w70lytOKcG4b7Sr2IsLMJVm1lMoMZVpdiJeYX
	 DekgQ+/6Jb9qTu4bQcNc6B6oYRTquG00aCpvsWvHtk3u9Q48iiM/VR38O/4itId/hY
	 DlDopeomTh8+ksRCs7YDHuYjubJ4l9lVz56aXqGDT3J8c/9DfMSOAaXtDX05uKWgBI
	 D/yc7oCg+EGLzyHZu1QArNemQUuQKU5j+dv3rnAoptBLjJcrscYnKb5mUx8OX2dtNV
	 rM8EEpQJZHM2odojJBRldNS2yu2QrDIfj2+v5z59NnhiS/MYC5xa6XAUoU1YlTmgmA
	 Vs749/sziTXLg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.1 004/212] cifs: Fix querying and creating MF symlinks over SMB1
Date: Mon,  5 May 2025 19:02:56 -0400
Message-Id: <20250505230624.2692522-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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
index c0f101fc1e5d0..d71feb3fdbd2c 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -269,7 +269,7 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 	int buf_type = CIFS_NO_BUFFER;
-	FILE_ALL_INFO file_info;
+	struct cifs_open_info_data query_data;
 
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
@@ -281,11 +281,11 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -324,7 +324,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc)
 		return rc;
 
-- 
2.39.5

