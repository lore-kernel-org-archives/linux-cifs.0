Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87A23D0907;
	Mon,  6 Jul 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363727; cv=none; b=UURFiuBLhjerBfqwjGG5PMgOwIQkVGWzaxRZ8HZsYmh5NZKia9dc96x95yygGuf0r0K079H1+TlgPGrLGfWvZ0gd67G6JNDIl2Ztn1NfrAC4WPzZULJFTPRuWrPgY1gmYt9YFLL5Vc9nPlMwXE4uy4Nh3iti8IxIIYmsz8vXhGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363727; c=relaxed/simple;
	bh=Ts9av1ZsLfHjnPY0Js2hj2mtN2MhasC5S/41HDDwRBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9oIOC+KkeK/HR4yP0uDHTMqEpyS9iMrHrpPD/XI3ED141MIaXK7qfuc6RthS1lV1iM8fDrbS3wBDwFhTSyFGd+lYNoeE5Up+E30rrkdFEatwhaTdYiIvv38zJY/pYqiGrrV5FChaHQTjU5Gl98hEW4qznaBabXk5q8g+AmHpZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwLcRQHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwLcRQHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBB81F000E9;
	Mon,  6 Jul 2026 18:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363717;
	bh=QXBgBiJ7dTq5LFms6/5ufUmzNuTVgYQDOAIoToxgtSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwLcRQHBNltX9eJSnZnnc8/Tax9dX+IndaZmf6IhMgdqkUYo21qRhKaSxiWWael8w
	 VTMESv5z6ne7x3H59zxn0gaamJL2tI3jY/BZ8nI3q1qfAQVrrfV5wczvvYlWkV/hu2
	 ZJn8NozVZhGO/3cABaOyl/ss5vGVi3XitZjtPu9E4X90W4F0Ynu9bG861DKwRCcIoL
	 O6sTkkHWAokpimUlyGOD9UcPSN45pLWeC/skLrGLYodH/YrR7MHpm8LGGT1kpbo+ox
	 GxSaH92yuqMbSaOjeGsiRHeBRA4Agbw8wEZRgrm/tRXCPHYQ1YbZL3gLMm/lXZdKUJ
	 rd0aEMCQOQgaA==
Received: by pali.im (Postfix)
	id 29CBBA1B; Mon,  6 Jul 2026 20:48:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 01/11] cifs: Fix and improve cifs_is_path_accessible() function
Date: Mon,  6 Jul 2026 20:48:09 +0200
Message-Id: <20260706184819.22124-2-pali@kernel.org>
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

Do not call SMBQueryInformation() command for path with SMB wildcard
characters on non-UNICODE connection because server expands wildcards.
Function cifs_is_path_accessible() needs to check if the real path exists
and must not expand wildcard characters.

Do not dynamically allocate memory for small FILE_ALL_INFO structure and
instead allocate it on the stack. This structure is allocated on stack by
all other functions.

When CAP_NT_SMBS was not negotiated then do not issue CIFSSMBQPathInfo()
command. This command returns failure by non-NT Win9x SMB servers, so there
is no need try it. The purpose of cifs_is_path_accessible() function is
just to check if the path is accessible, so SMBQueryInformation() for old
servers is enough.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index d34b3d99f6ed..437ee5542a8e 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -505,21 +505,27 @@ static int
 cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
-	FILE_ALL_INFO *file_info;
+	int rc = -EOPNOTSUPP;
+	FILE_ALL_INFO file_info;
 
-	file_info = kmalloc_obj(FILE_ALL_INFO);
-	if (file_info == NULL)
-		return -ENOMEM;
+	if (tcon->ses->capabilities & CAP_NT_SMBS)
+		rc = CIFSSMBQPathInfo(xid, tcon, full_path, &file_info,
+				      0 /* not legacy */, cifs_sb->local_nls,
+				      cifs_remap(cifs_sb));
 
-	rc = CIFSSMBQPathInfo(xid, tcon, full_path, file_info,
-			      0 /* not legacy */, cifs_sb->local_nls,
-			      cifs_remap(cifs_sb));
+	/*
+	 * Non-UNICODE variant of fallback functions below expands wildcards,
+	 * so they cannot be used for querying paths with wildcard characters.
+	 * Therefore for such paths returns -ENOENT as they cannot exist.
+	 */
+	if ((rc == -EOPNOTSUPP || rc == -EINVAL) &&
+	    !(tcon->ses->capabilities & CAP_UNICODE) &&
+	    strpbrk(full_path, "*?\"><"))
+		rc = -ENOENT;
 
 	if (rc == -EOPNOTSUPP || rc == -EINVAL)
-		rc = SMBQueryInformation(xid, tcon, full_path, file_info,
+		rc = SMBQueryInformation(xid, tcon, full_path, &file_info,
 				cifs_sb->local_nls, cifs_remap(cifs_sb));
-	kfree(file_info);
 	return rc;
 }
 
-- 
2.20.1

