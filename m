Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20921E86F;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137030; cv=none; b=s2umS/C2mk9l/c9onR3VcemKJez6WhN6GZO4N6XhIG9V+z2n9xPxdgcV/ttxAyR+plprVm+nGy6y2yC2bnSQSutwcAQjsLD5c+WLDgzAQXEN9ocvKmsRMaW9Xp0MuG5thQbAo+XjL40/rSXPiWVdO8DRNnjgJQqvMxEe2NDcNC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137030; c=relaxed/simple;
	bh=1EMZDsuMmDkNSxzMQAtXAHiCdyxZsiTk4Nmrsli0tuk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPDgGJFM0mIwOFLLeehlnDW6lRJYpcS3If2K5n21KrPg0SrDSGUHsZAuS8TzeJfuPXTpz/gkwvUtTZu9SpxVCkLLVVtcVsmr39wvvSWiosgYiX5SVAQksxqmZ0fblpkHx02Y+a2/dW/DDTyJIyrANoKCM8bRuzscFaaVadUEdww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhxfOchs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhxfOchs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A091CC4CECE;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137029;
	bh=1EMZDsuMmDkNSxzMQAtXAHiCdyxZsiTk4Nmrsli0tuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhxfOchs2x7rdAc41/vhNzFyblJmqxFOEINclT8k+med1BkTR6SQEz2cja6OoAFxB
	 hJ4qdwnGcs3nM+ZnvGICHZUVuPzDLBJ3J0xLZKApb//KjXX6AHnwFIVfmtl21JBz5S
	 jtkM24pZRvFuoijbMGItBIApSlIo2nLCLH+rLWaJa+dW5RTELeSnhBKmq+Q0cYpIGH
	 soNq2vpxCHzVUNn/9+/Ge5uCkg71PmOanAe1lmcXVmKWrqXMngt6seNj2SctKX/0sR
	 K4vUZ94loW/FyfXH+R9SD2hM0C252061laHabiOfPAS6APRa5y2LcE6YPXEuBtoaak
	 OELDXEjN41sew==
Received: by pali.im (Postfix)
	id 6E7D5BA8; Sat,  5 Oct 2024 16:03:43 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] cifs: Validate content of native symlink
Date: Sat,  5 Oct 2024 16:02:59 +0200
Message-Id: <20241005140300.19416-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005140300.19416-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
 <20241005140300.19416-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Check that path buffer has correct length (it is non-zero and in UNICODE
mode it has even number of bytes) and check that buffer does not contain
null character (UTF-16 null codepoint in UNICODE mode or null byte in
non-unicode mode) because Linux cannot process symlink with null byte.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 0d1cea64ab6e..fb1d16b17f38 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -544,6 +544,25 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 	int rc;
 	int i;
 
+	/* Check that length it valid for unicode/non-unicode mode */
+	if (!len || (unicode && (len % 2))) {
+		cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
+		rc = -EIO;
+		goto out;
+	}
+
+	/*
+	 * Check that buffer does not contain UTF-16 null codepoint in unicode
+	 * mode or null byte in non-unicode mode because Linux cannot process
+	 * symlink with null byte.
+	 */
+	if ((unicode && UniStrnlen((wchar_t *)buf, len/2) != len/2) ||
+	    (!unicode && strnlen(buf, len) != len)) {
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

