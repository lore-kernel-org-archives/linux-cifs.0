Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5743C1969;
	Mon,  6 Jul 2026 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783363739; cv=none; b=fIbtxxKEGZQfIHtf5MsG/CdXe1Nt+uNBrrQFvfT++eCYv+AQ7U33teVTeHVs0G2DipCXEyX4hnpYo11JA9NIu/mox3apyKuFYlyXN7a6r1X4sY/gI+OhW4AMDRHt3DpUKJuAaAXuItMmOWi+BJUWxIwPbAgkhOOb8KbPGiZoSSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783363739; c=relaxed/simple;
	bh=EbmH9tg3zQH2QoUK5PF3nXiqZaX54+lNf85wlX8nnjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urLYSYo5uu8TRycFWk+zwZi1HQU94ppp7YF37+pg2b1A7Gj+hcbpeOhWRUvWGLpsARR3dQO427Ga8bVORb3BsrZXSva2fApRUt5G8DX5RcIb8Lwz0Rtjo1cMxGwxD3C+l1XYVbnXl0uYu40tuhYvx27GgKMW2TGrT4+oLqrXu+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOyxpF9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOyxpF9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4471F00ACF;
	Mon,  6 Jul 2026 18:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783363720;
	bh=hrTzZ3gW05REpkBsODmF16wG05c5GXQy0wCBYXLXwww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOyxpF9GgYxs6TTGTPEqDYd3zWNG/IwW4H07fRVAulPNIFW5BEa1haN/eXh9ey1Tn
	 UNiZUPqiBR0dnyB2h0891q4D31edCYuqFELjbmUnjdW403ZpMOPnqP6jFCl+sW+0Jj
	 Zrm1+QAuvIPhlMfEyz/kKHbSo0wV2UmKuc3CR8EefsqastNnABMJfaFPZFTIhPBNpW
	 Fa8LpdfNKeDW1+CPd60v1WKZG5FQGrNxR+D0OV483d284KHFoJBOSG5ceyC+bnQteJ
	 NEnTKjmOzLJ4SovJUYQ2TESx6Hboqh62qqB3TKqhyHctb8ItHunS3EIihz3h39tOU5
	 ewsN95Mb2I4hQ==
Received: by pali.im (Postfix)
	id 340D11037; Mon,  6 Jul 2026 20:48:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 07/11] cifs: Check if server supports EAs before trying to set it for WSL
Date: Mon,  6 Jul 2026 20:48:15 +0200
Message-Id: <20260706184819.22124-8-pali@kernel.org>
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

WSL special files store information into EAs. When EAs are not supported
on the server filesystem then fast fail in mknod_wsl() function.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 99e93b56374f..e2ea59a17c9c 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -668,6 +668,13 @@ static int mknod_wsl(unsigned int xid, struct inode *inode,
 	struct kvec reparse_iov, xattr_iov;
 	int rc;
 
+	/*
+	 * WSL special files store information into EAs. When EAs are not
+	 * supported on the server filesystem then fast fail.
+	 */
+	if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) & FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
+		return -EOPNOTSUPP;
+
 	rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb, &reparse_iov);
 	if (rc)
 		return rc;
-- 
2.20.1

