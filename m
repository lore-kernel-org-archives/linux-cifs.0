Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A7F33D1;
	Sun, 22 Dec 2024 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734873682; cv=none; b=sYZ/USX8wgotqRW900XpyTE+z8lbB+BHpdhwaATVsdb2CaptSOq8u/Vgp+yUHOQyleeWcb++OeFdSuWRfrbWIelqkInYKxkGcQqBWkMhOUQVYsJIChSs7fIV/PEyAUvEaYqcHbm9aeBKu8yBMxg1sDefZvrlaEjcbMTnflwsmzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734873682; c=relaxed/simple;
	bh=YkexGRvdRo755HzB+GSiIwFy3Lgn4VJ3kSS9PVcouxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f66Wd3Syk/m9gH6EY4vQxN8ruNkhkIlHrnvUZyy0O8BWFSWkAtfHFX2NuQn2yxmJ7ANqO2GUANS2Nux5cCRKtnkTk10WIhUjFXCBqJwY6MpsJrsokZU4ZKOkabHxbpsPwF58o5d9PND4P9Tql61ezSN+Pl4rFBrJ7uNI71ePQqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=peYEEPQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="peYEEPQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A69C4CECD;
	Sun, 22 Dec 2024 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734873681;
	bh=YkexGRvdRo755HzB+GSiIwFy3Lgn4VJ3kSS9PVcouxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peYEEPQm5ghCTeTA5k+ANGwFWakoKzp2sKbt9rkmXYNNa2uYWutVp29+xe9wmBilm
	 KguwvZiVIo3MKxUm8D9mFPxdlXQRnR7TGf7VfSmHyuo7k7BLk3UcjNYoILv2s415pM
	 II/+Z1PBtnrr2inpL5QjqAnqSlme0oJpk93uH2pMc30hjsZzl3jRuQz4f6vjGeLwHl
	 RZz2o7G2k7JVSp3NKLmmzUtDZxJ+pOMQZsLJItmwg1DJGkWb/locfDsLE7Tg9qtci0
	 AjA/v6BTpiyIh3dPEXYN5Dpwet/Bkwc2V2Zcx7fPl6C995mlbNdiwsLBimWfofbST0
	 ZwjLKNa50l7nA==
Received: by pali.im (Postfix)
	id 74A45982; Sun, 22 Dec 2024 14:21:11 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
Date: Sun, 22 Dec 2024 14:20:28 +0100
Message-Id: <20241222132029.23431-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222132029.23431-1-pali@kernel.org>
References: <20241005160826.20825-1-pali@kernel.org>
 <20241222132029.23431-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Some operations, like WRITE, does not require FILE_READ_ATTRIBUTES access.

So when FILE_READ_ATTRIBUTES is not explicitly requested for
smb2_open_file() then first try to do SMB2 CREATE with FILE_READ_ATTRIBUTES
access (like it was before) and then fallback to SMB2 CREATE without
FILE_READ_ATTRIBUTES access (less common case).

This change allows to complete WRITE operation to a file when it does not
grant FILE_READ_ATTRIBUTES permission and its parent directory does not
grant READ_DATA permission (parent directory READ_DATA is implicit grant of
child FILE_READ_ATTRIBUTES permission).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index e4ae8d2d5bd0..ff255fdc4532 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -152,16 +152,25 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_fid *fid = oparms->fid;
 	struct network_resiliency_req nr_ioctl_req;
+	bool retry_without_read_attributes = false;
 
 	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL)
 		return -ENOMEM;
 
-	oparms->desired_access |= FILE_READ_ATTRIBUTES;
+	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES)) {
+		oparms->desired_access |= FILE_READ_ATTRIBUTES;
+		retry_without_read_attributes = true;
+	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 		       &err_buftype);
+	if (rc == -EACCES && retry_without_read_attributes) {
+		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+			       &err_buftype);
+	}
 	if (rc && data) {
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
-- 
2.20.1

