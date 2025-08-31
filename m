Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B8BEAD7;
	Sun, 31 Aug 2025 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643795; cv=none; b=Hbz9OZm8mUpRvpqpUPkPc68OeaB3XLUEHEaFPRS+VuFXzt1aUC91Ngd6xwjJaBaDTxgvsWmwhVuMKvo0N+n4puJuoW+7zPWUp7kAKrfKXQdykzJB/Dy6ujhjK9Alw+TUmb7fKoX12AMHNnHFLgDhJHHsm6YOR3WcBxzLwTQqbc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643795; c=relaxed/simple;
	bh=rxCdwQlYnec2995LbRwxC0xImYoxqfc9Q+HrlJEr2+Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9iAT9VrZ5eSvBD0udlmXOWx+toUIAIvkySdpvsd5KOtSI2AsAWvvghpgi98IK/aS0dYL5RugeXFloIDlaEC2k0a/Rqok6EN1sGw1MpGTLA8M2X0qptPu4amsfgEoNpFvlrXepYTzv4nEm5DhdA20nF4XgyzewaXKARw3bWUoI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EkjKxtzl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkjKxtzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D299C4CEF5;
	Sun, 31 Aug 2025 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643794;
	bh=rxCdwQlYnec2995LbRwxC0xImYoxqfc9Q+HrlJEr2+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkjKxtzl1zMTqi79q/UkX47NFvYOxTNLpLkWb3nUecNcsgoMR/2N5gCDvaXEaqxod
	 fWLHp8NSVqW0+YPS2yS0iEDRqze7n7V+aPgHQ7DCha7mCJRsu5TpNydrtu7bOnD90q
	 xM391ljS0UaiYpnNTpxsL/HAZW2YdVsrkiSA50C9xN3Qm/ACB1DVw5X091gBOUQiPa
	 8CvN14qhkuqmXnQNDGY6m191TEGWDI2K+fMs3ECWI1qkXZHJCIafGMAdW/TKHVrHMQ
	 QvsXHZQpNbblb7BeMy8739GW6rrRP/AFBd6hcOIJu/BSq0E/ja5GN77dQ2nOhdjIO3
	 cWWaU0fa0RmDQ==
Received: by pali.im (Postfix)
	id DEE85D58; Sun, 31 Aug 2025 14:36:30 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 01/35] cifs: Fix and improve cifs_is_path_accessible() function
Date: Sun, 31 Aug 2025 14:35:28 +0200
Message-Id: <20250831123602.14037-2-pali@kernel.org>
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
index 893a1ea8c000..1772f30419a9 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -521,21 +521,27 @@ static int
 cifs_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 			struct cifs_sb_info *cifs_sb, const char *full_path)
 {
-	int rc;
-	FILE_ALL_INFO *file_info;
+	int rc = -EOPNOTSUPP;
+	FILE_ALL_INFO file_info;
 
-	file_info = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
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

