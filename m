Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01D712E52
	for <linux-cifs@vger.kernel.org>; Sun, 11 Feb 2024 23:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707694215; cv=pass; b=E1vaiE7rqJ+U4GJ0nPsQwvfHBf28rJgUnwN8WmvqT2t8nsmFivGU6MeOu2ujln71W8WOdOPV7uSmsIYSnxk9PeswRhtKzHsWa3kiIfmRLLru9qLBQQ5THgxXsboViL6E0AjyKTnpR+P5fXeMkOdHNtEQYXtqV4F3D0CqX8Al0S8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707694215; c=relaxed/simple;
	bh=k3K6did4C2wW4aUWpXJhkdUZ/iT2GFKmHTfeHOxA62A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxWNTsoXglm/hGqj0TiLzN4h16TJ/7iIRMFULVKQDNrd5z+wlM6k/vYippifaT+6MVBIXdxGdBtY0Ic9kfkzCIGYqyTzxnOwsRA2oELAZqiKxIhj9jadt+ibdUQTvvMoJQ3FbTo9xNvnsaUEEHXQrK5KUGyb+sdMrqb3Q1iLI9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=A5F5DuMX; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="A5F5DuMX"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1707693647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iZ0Bf7d9JLDl+KIPMEGMvlf2V54ODdk/m17lSJiWIDI=;
	b=A5F5DuMXKESBaDyp0XwCdi63Ixj56LOsG3VirXzGHq0GBiDtm+VsM0tDs8PPQVs67KDz4D
	hrGpHiHAJ7kCpC8nbQiwBggbTHVOQ2CVCqyQBpe43VLmx7ND3CgYvQrSDAJ2ZFlSyyADD8
	mmmWeLyp8RN9sq2y5w2TzJAXA0ztoFooLB/rDpB+NUmjzLuDIvgl/pn2tMi+jfnOz3WH9e
	SmZQF1d02+6E9AvS/uPZEpXqM7UNnH3LqPiQFsRf+xtke7JIrEKWO0/kMm/ek5v8TSowbP
	nZ2InA9z71mD0fRzu6ZTn0m55+a93xY8lDw2drfsTCxiVd++C/q4rFIH8SiguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1707693647; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iZ0Bf7d9JLDl+KIPMEGMvlf2V54ODdk/m17lSJiWIDI=;
	b=hgcSzTmy5vemmrIPaAH62W5VTU/kZBG3TIVQjqJPGyzXL/JUFt3FYPWLLIlDNFT1xGnnan
	WSboBq52yolPpvknlBFK6XMhdfeWHYA2Uv9aa0A5v76i4Ed082gWnK/k7EKfIyBq8ST0Ph
	GlIMW7zCe6C3mD10YKhahuUUZVFqkhqEo//bAi7TxOL+bVzSTBYdDOfUKf6dBtyJmnifjf
	fYzU8CSzLhe2Py1+bJZuuiLvPWBTeh/A6rhviEyIodtvSKes5iIlA0Rpzq4cAePKBNu5t1
	d/X1/c8sxUeQs00eEQGR3K3gRtGt1wQX+90ERrL6tTckXDGynaxqlXBaACt4zQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1707693647; a=rsa-sha256;
	cv=none;
	b=d92t79y6f18zWVQ/2L6/xLQiCNqYbU43oOKeHzSQUhoPwFP5wdejDhZzqI+0DeHi7HeyPX
	z+/aEHZ9Pq+G2RsW8ZWRLygFZRhGYB+r3QKk8QODj2oxW7aGKqsFhoSBeOOMsVmjTAja97
	6j6VRghi74z9VWW2S/JDT9UloNNSbYDmO35Zb9Hn3liJ8LeGJJoAJ4GlaXlDUCw0RWaK5Q
	Gpja+52lizR1uKzV3yiZMru3hLAwe31Xfhd98DkYTcSrTKskWWR3SaVKo+ylCDNQGgYWIg
	5QUZG7anejFFfFuY4WLpK/RF8joHz/66HfDCPt2e/nF2Uxe+xMENCpHbXLnxjA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/2] smb: client: handle path separator of created SMB symlinks
Date: Sun, 11 Feb 2024 20:19:31 -0300
Message-ID: <20240211231931.185193-2-pc@manguebit.com>
In-Reply-To: <20240211231931.185193-1-pc@manguebit.com>
References: <20240211231931.185193-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert path separator to CIFS_DIR_SEP(cifs_sb) from symlink target
before sending it over the wire otherwise the created SMB symlink may
become innaccesible from server side.

Fixes: 514d793e27a3 ("smb: client: allow creating symlinks via reparse points")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 6b3c384ead0d..4695433fcf39 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5217,7 +5217,7 @@ static int smb2_create_reparse_symlink(const unsigned int xid,
 	struct inode *new;
 	struct kvec iov;
 	__le16 *path;
-	char *sym;
+	char *sym, sep = CIFS_DIR_SEP(cifs_sb);
 	u16 len, plen;
 	int rc = 0;
 
@@ -5231,7 +5231,8 @@ static int smb2_create_reparse_symlink(const unsigned int xid,
 		.symlink_target = sym,
 	};
 
-	path = cifs_convert_path_to_utf16(symname, cifs_sb);
+	convert_delimiter(sym, sep);
+	path = cifs_convert_path_to_utf16(sym, cifs_sb);
 	if (!path) {
 		rc = -ENOMEM;
 		goto out;
@@ -5254,7 +5255,10 @@ static int smb2_create_reparse_symlink(const unsigned int xid,
 	buf->PrintNameLength = cpu_to_le16(plen);
 	memcpy(buf->PathBuffer, path, plen);
 	buf->Flags = cpu_to_le32(*symname != '/' ? SYMLINK_FLAG_RELATIVE : 0);
+	if (*sym != sep)
+		buf->Flags = cpu_to_le32(SYMLINK_FLAG_RELATIVE);
 
+	convert_delimiter(sym, '/');
 	iov.iov_base = buf;
 	iov.iov_len = len;
 	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
-- 
2.43.0

