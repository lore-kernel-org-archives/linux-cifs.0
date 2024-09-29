Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBBD55E53;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727635864; cv=none; b=CPKU4JIBzqnKm+FbVD+9ZInU5RZ2Mz2VbarcL3yK+QnC8QCxTX/ARvh7EX5Cc0AycwZXlOEbWq+Be/KsmOinqtUyeF0X6gh0KMD7nPOmTIbdRQPYfukUTKZEiximX9c3CBl4s4Lq7RLHaMofy5WX/pu1fXnXt5ccJKO8IcWj9l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727635864; c=relaxed/simple;
	bh=Smyda09QytiOgtvr5vHjvB5Eoa2wj8kkQxDlMltOPVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dgMzePpfK05sYtk7GaJO07CarK4YWTTGs0mTQ8XpEbZRJSwyJFJLVxhT+T9bb1a6xShnWZZjG4YHxTK7t2/uCj3jQtXWmyzf4ZfwP4jToU8EKX80bPFOPhoG/xQPuCRTOVPYRFY16fI+DXgzOJBlNH+wmKzqA8rBYJQm0tbh8ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/cO4g/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/cO4g/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505D0C4CED3;
	Sun, 29 Sep 2024 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727635864;
	bh=Smyda09QytiOgtvr5vHjvB5Eoa2wj8kkQxDlMltOPVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/cO4g/Preg7vgqyLNL0va0+bR5lIBuPmwau3eVoDZE6OBjEvYRdM/3yROaG2aRfH
	 TRWHXuWBUhIqsdB+4JUF4C/HcgAd4vE6ghFAvG0BQHggy7Eo6C8jx7v6AZ4ud0hhvW
	 ZfePehDszOswj9dh9ZqcO4wYsdeASoC1En9mrhZo1UF6HifTDFKYRWdSdnvMO1qCLT
	 DIaWNBffj6XzAD2t24hVuI8l6QRGAxLX2Gvd5vQSO1QXUlOQBRnOooQr0CAi2hubAJ
	 g5reDm/G/DeEO7DUxe44B7QTYdcGq4Dff17gxst13u0PRlJpcN/wY9JtkQ6Dvd9sqq
	 vLb/K6oQ8sxLw==
Received: by pali.im (Postfix)
	id 07ACFD48; Sun, 29 Sep 2024 20:50:58 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] cifs: Validate content of native symlink
Date: Sun, 29 Sep 2024 20:50:52 +0200
Message-Id: <20240929185053.10554-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240929185053.10554-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Check that buffer does not contain UTF-16 null codepoint
because Linux cannot process symlink with null byte.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 5a738f65b190..ca4f96c43508 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -509,6 +509,16 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 	int rc;
 	int i;
 
+	/*
+	 * Check that buffer does not contain UTF-16 null codepoint
+	 * because Linux cannot process symlink with null byte.
+	 */
+	if (unicode && UniStrnlen((wchar_t *)buf, len/2) != len/2) {
+		cifs_dbg(VFS, "srv returned null byte in native symlink target location\n");
+		rc = -EIO;
+		goto out;
+	}
+
 	smb_target = cifs_strndup_from_utf16(buf, len, unicode, cifs_sb->local_nls);
 	if (!smb_target) {
 		rc = -ENOMEM;
-- 
2.20.1

