Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E39B188006;
	Sat, 28 Sep 2024 22:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560848; cv=none; b=gJjZ7UwJd939x6eqOYyrlIHub/yN0EYGNzm4y1mN9bfnQEs/O/LgTEPoH3YLOm2aSLo0dbPMr8zDZw/MuCqYyyR8CebMp3mApBHrdVj9TqvYHDmgOc21m3aYPPEEyqPgsDIRSUmMstk2rayfAAwH4jyJUa5tY/devU8GmzlomJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560848; c=relaxed/simple;
	bh=+5MshYdIWOim2Y4JZXynrXZzEYNgicdvjusLOdJ6Br4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swROwY4Ro6YrcF+UTSGU/f1MDTrzlQ8AnPjvcyJy7XSbTT81jW7r2C2OouhXQbdQ/qGrzyeX5w0R+h3lNr+KWVtXmgOXKCm5ESLR1Y21Xt3zF+mnBqKV9oWYnZZtAkYOWWTaC5H52kQrATGK3kndIv5TUzHxGajUT1Uv+gUz25I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k1JUOchg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k1JUOchg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3765AC4CEC3;
	Sat, 28 Sep 2024 22:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560848;
	bh=+5MshYdIWOim2Y4JZXynrXZzEYNgicdvjusLOdJ6Br4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1JUOchgCjeCmgw6ecTxMTsoXaOitkoJGu5M8Hri2le4YCIEXg1qinrrdLDq8EwCs
	 G23lXrrgpldKOmon24hANOP7vUrmUqcRJWvLx1c1CHFkRyfzXu5rTsx2hdeCI/xsx1
	 bnDonb7ck9TMIp8riklEZbSxizGftcuxALMH1pPGQTwVB5WaHTN59g52w9YIDNshEg
	 /yzEZffRXHuojUSRaygluvpRH9o7nAJeBIaq+weKUngEAdD5nHETPcMy6IfoEKGfhL
	 m/cvPLpZwmApFWOPrR55Zt9kOHsnVGKarAR6cT47b3V2D+cSeWVh/NsIUNyjDp+/88
	 xKSKWnQE/tAuw==
Received: by pali.im (Postfix)
	id EF87DAA2; Sun, 29 Sep 2024 00:00:40 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] cifs: Fix creating NFS-style char/block devices
Date: Sat, 28 Sep 2024 23:59:44 +0200
Message-Id: <20240928215948.4494-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-1-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux SMB client currently creates NFS-style char and block devices with
swapped major and minor numbers.

Per MS-FSCC 2.1.2.6 NFS_SPECFILE_CHR and NFS_SPECFILE_BLK DataBuffer's
field contains two 32-bit integers that represent major and minor device
numbers.

So the first one 32-bit integer in DataBuffer is major number and second
one in DataBuffer is minor number. Microsoft Windows NFS server reads them
in this order too.

But Linux CIFS client creates new reparse point DataBuffer with minor
number first and major number second.

Fix this problem in Linux SMB client and puts major and minor number in
the correct order into DataBuffer.

This change fixes interoperability of char and block devices on Windows
share which is exported over both SMB and NFS protocols.

Fixes: 102466f303ff ("smb: client: allow creating special files via reparse points")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 48c27581ec51..63984796721a 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -108,8 +108,8 @@ static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
 	buf->InodeType = cpu_to_le64(type);
 	buf->ReparseDataLength = cpu_to_le16(len + dlen -
 					     sizeof(struct reparse_data_buffer));
-	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MAJOR(dev) << 32) |
-						 MINOR(dev));
+	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MINOR(dev) << 32) |
+						 MAJOR(dev));
 	iov->iov_base = buf;
 	iov->iov_len = len + dlen;
 	return 0;
-- 
2.20.1

