Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80761B043A;
	Tue, 31 Dec 2024 22:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684572; cv=none; b=BFVVasVWG4K8pq5DA8fNKneQeBYAF9xGJI/j/ZC8vWfxF88f4BpQKaJVqvmbmmijgs+Ne7OEdgMpiNkagv2acJH4gBm8idR5WxtE92u3iJe5Rupso46Iobu0GQVl/LDAhIo7c3Ytsd7k7VHzOfyU0lpNjIqO8lziUjGDlSLfUY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684572; c=relaxed/simple;
	bh=33hH9i9NgcEzckkxoluPeGwGOk4cZSXThF8m2iw6P2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=A4C+JEFbxrM97vkAhSr7OuIt/YkdVE0ZrafAd3nMufsX/z0pRVHjNyEtAmMgbqR/EJSl1jr33ci8FncYsfWb3mR8er9P3Z3MXTC2kdEbNC4KsCwxIprW0CQnASV0myiIQAdIRtsd/T2JQqAdUqDLfncg+LPzgKs2Z65YhtOUCJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIIXlf7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIIXlf7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31265C4CED2;
	Tue, 31 Dec 2024 22:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684572;
	bh=33hH9i9NgcEzckkxoluPeGwGOk4cZSXThF8m2iw6P2k=;
	h=From:To:Cc:Subject:Date:From;
	b=oIIXlf7ng7pP0e9lcfDgVZNwTzQUab33sNcoUTqv5iUA4OURIL37k4GV53Mt9w1RI
	 91iIFjNlApdB6nBWSaOyTJckfWrFOqQF6pSqpItRJLEW9NfTlJb+ClBa09syr0UUx5
	 mfRX88ycQtkNWEZPygMfkRfo0vSHLh/hKoGJv+lehv2zSq+t6oM+7KFeWPeM0ZQ6b3
	 JPjRfUGBnxewFIMJ2EBqBZ9ivYyYRSqbJg28qD9bqANuWKcT0vlzwbRmzFw/G1kYCG
	 jJHQyKfnxeG+xstBQa4G0DzXrilRQJob/2AU/74pNKGi5c5qgIO97ug8eXGAVtbweR
	 cvsGeu/Jqy06Q==
Received: by pali.im (Postfix)
	id 0132297E; Tue, 31 Dec 2024 23:36:02 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cifs: Do not attempt to call CIFSSMBRenameOpenFile() without CAP_INFOLEVEL_PASSTHRU
Date: Tue, 31 Dec 2024 23:35:48 +0100
Message-Id: <20241231223549.15660-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CIFSSMBRenameOpenFile() uses SMB_SET_FILE_RENAME_INFORMATION (0x3f2) level
which is SMB PASSTHROUGH level (>= 0x03e8). SMB PASSTHROUGH levels are
supported only when server announce CAP_INFOLEVEL_PASSTHRU.

All usage of CIFSSMBRenameOpenFile() execept the one is already guarded by
checks which prevents calling it against servers without support for
CAP_INFOLEVEL_PASSTHRU.

The remaning usage without guard is in cifs_do_rename() function, so add
missing guard here.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index ac408e3e0478..9393a9c18010 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2408,6 +2408,13 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	if (to_dentry->d_parent != from_dentry->d_parent)
 		goto do_rename_exit;
 
+	/*
+	 * CIFSSMBRenameOpenFile() uses SMB_SET_FILE_RENAME_INFORMATION
+	 * which is SMB PASSTHROUGH level.
+	 */
+	if (!(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
+		goto do_rename_exit;
+
 	oparms = (struct cifs_open_parms) {
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
-- 
2.20.1

