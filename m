Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CD01B87C7;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=n5TFrwkGhcXZAonomYNxoHyt9YQCg3PGcJW8dmly7GmytAa1Xg+JkKxF/0ZwN4Z9oLNQfBJt+8TDf/Ve/NOaI7faK1vSRtcAsGhb3w7apXZ+m/vZ9VizYJ3D58WlrstAgj1O6RCNyxWoFtFtjrCROLsBLP2t9JyC573aTpj2AnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=+arv5vFxEsgoW/DEZyE6e9Vi4gLHCwC1jHGKqTG9YkE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWcJ5mwVWGrmBaCxV7H0eywB37UzQTXAGA0YYfhpBaw9SdVOYgMbmXiiTnhmGvejL08yziWLdvHzCYKS1M3+4BXKrjuiXcQS5HsYUSIQLdgOpgDz7znEVIqRavo14ZFm7kbM0tivixpcKOLvqCLUvHPNVG7IzimQKqVKahln0Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+FL1HtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+FL1HtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EAFC4CEE1;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684630;
	bh=+arv5vFxEsgoW/DEZyE6e9Vi4gLHCwC1jHGKqTG9YkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+FL1HtEDaYCPPgqIqWlYr7CepO7wLCFicZTs/FJcFlF9cj7gZYkZlS/wFTXuXnKK
	 RFiatERlF7TrkLtWqtxuTPi01nNt4/NX2HY470XyBc6mRkTnSO9HQbS7TepbGqnxo+
	 XJzXCPmvcbKK4dpwIChh/usgj2EUpO7gC+B12vwAUJuSw9LefCDQ+YGitbED1pEqmk
	 kMTQpBWAmNmnvhmjNyQXhIn2hyPXWlDUXYfPQ5u2D+zDhCbumb7ecS6d1IXczEIGgA
	 BXiwdZ6KVMU3uVWDA4WdK6DdVziKJlwE2/oKtCnhEWiGR65PBUX/iIFx0NUHp6W82c
	 A6pI/u/iPnN1w==
Received: by pali.im (Postfix)
	id 43DDAFE0; Tue, 31 Dec 2024 23:37:01 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] cifs: Allow fallback code in smb_set_file_info() also for directories
Date: Tue, 31 Dec 2024 23:36:39 +0100
Message-Id: <20241231223642.15722-9-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On NT systems, it is possible to do SMB open call also for directories.
Open argument CREATE_NOT_DIR disallows opening directories. So in fallback
code path in smb_set_file_info() remove CREATE_NOT_DIR restriction to allow
it also for directories.

Similar fallback is implemented also in CIFSSMBSetPathInfoFB() function and
this function already allows to call operation for directories.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 49b5b75ef2f0..62f4e1081ea4 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -915,7 +915,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
 		.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.create_options = cifs_create_options(cifs_sb, 0),
 		.disposition = FILE_OPEN,
 		.path = full_path,
 		.fid = &fid,
-- 
2.20.1

