Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ECB264FB5;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=bAupcNegsIzpNgp1a0mkGKZIoct9qo6049XnehgOIyz1Pmq+cMLlrPaEUuR+cTd8AEPydJ2KdIN2KajVR6JpyfLMs8eAqoWFhAOx4KwPeyeZf5bhlPFvCe8RuvWIY6gf9GHjBXXSK4FSr1MXzzA3WyQNE0s4r0IVm6OrUpiXdZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=GCZSbjBPCLF1eAXCX5z+2NAiYG122Va1HFGU46nBOyU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwGCObK6MJVKLquCVdxqLviom85WRQGTA1vZujiIGl+nn14eD/4FA6MX8YwuNt1+uDycXVpw5gmV1Lcvl2OT+Dq9MTqBy0wHMp/yz3DREaN0Jenax4NRD+ENX1Pk0LGwgrQRP/vognl3nqnVf0N1q0VcUMPOc15Gz3Nt8NssKlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nd/9gMtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nd/9gMtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF45C4CEF8;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=GCZSbjBPCLF1eAXCX5z+2NAiYG122Va1HFGU46nBOyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nd/9gMtzXUChoUlZ8aMj9gHuQEAKqh6xeyjMhoSIReml7H3vQE9+s3TgjhgOU9uc3
	 xaktQRdB2t0rMP89zUgej/u2CEwpIX4hk6gYfpQiRhtRj0Ntx3dZtN9c9+HqLTeAro
	 20fq39gIf9qL2n0BoLMI0R3zaQR19xpcfE4g8mUEr94nYmkt9LWIWAg7V6fOdloupO
	 JFH++EPP+qc2KSOWFiIG4EOBUgHtOv3sgu/HgTN1d5rOYWi0rP5ukt59Hh+v8SOKy8
	 gK1DAxblWz3aq5zXVgafuGz87kIOTK9pA6a3nCEEQTE41bL9QSM5srO4uC/GDSk2H2
	 AM15ULWp6y64w==
Received: by pali.im (Postfix)
	id 7AA991B0A; Sun, 31 Aug 2025 14:36:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 19/35] cifs: Fix cifs_rename_pending_delete() for files with more hardlinks
Date: Sun, 31 Aug 2025 14:35:46 +0200
Message-Id: <20250831123602.14037-20-pali@kernel.org>
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

Do not set ATTR_HIDDEN when the file has more links. These attributes are
shared across all links, they are not direntry specific. So changing
attribute on one hardlink affects all other hardlinks.

The cifs_rename_pending_delete() function called from unlink() should
affect only the path passed to unlink(), and not other links.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 89d1b82ac55c..4658af632098 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1769,16 +1769,26 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	if (rc != 0)
 		goto out;
 
-	origattr = cifsInode->cifsAttrs;
-	if (origattr == 0)
-		origattr |= ATTR_NORMAL;
+	origattr = cifsInode->cifsAttrs & ~ATTR_NORMAL;
 
+	/* clear ATTR_READONLY, needed for opening file with DELETE access */
 	dosattr = origattr & ~ATTR_READONLY;
+
+	/*
+	 * Set ATTR_HIDDEN to hide the file, but only if this is not a hardlink
+	 * because all hardlinked directory entries shares same attribues and
+	 * we do not want to mark all hardlinked entries as hidden.
+	 */
+	if (inode->i_nlink <= 1)
+		dosattr |= ATTR_HIDDEN;
+
+	/* clearing all attributes is done via ATTR_NORMAL value */
+	if (origattr == 0)
+		origattr |= ATTR_NORMAL;
 	if (dosattr == 0)
 		dosattr |= ATTR_NORMAL;
-	dosattr |= ATTR_HIDDEN;
 
-	/* set ATTR_HIDDEN and clear ATTR_READONLY, but only if needed */
+	/* change dosattr, but only if needed */
 	if (dosattr != origattr) {
 		info_buf.Attributes = cpu_to_le32(dosattr);
 		rc = CIFSSMBSetFileInfo(xid, tcon, &info_buf, fid.netfid,
-- 
2.20.1

