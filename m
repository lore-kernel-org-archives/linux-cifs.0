Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3041E3C1D51;
	Sun,  6 Sep 2026 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721688; cv=none; b=sHYcr0HT7oTd1W//DwHDqb1zKlyQqcY6aD+N3pVM7/hlr1B+nesj7eNnIFGiilLJk3jrK7EI0aARWcvfOt8XaR6eenkwpG2BhiP7e09zHMu9dwHHowsjtjMSUTSgaKWGjFDRCIoIWMiXTGrjqM9lLLpLEeFLKEB0fkCI/I8rCG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721688; c=relaxed/simple;
	bh=XLZ+oYd2cPMQR2hIhw9vxQp/4lJmmFTaQ8iHb9ZyHa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdQMyTYakQRJUCZkrErxx/dp4PH6NnJi3AnGAkwFkd7it3nPfkeAp2UYoo/Ki/uZAbvCSnJhLJUeo+QaANKDZbD+s28gh27ZJrUDKKFnnt0G/wt8JeaCOPC9QMlBouEBAN7t+h7xZK8q3DbUBEllMjGShBMrR+6ViROVNYWxzgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Fp4uCPoa; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Fp4uCPoa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=hzdT5LbIlX1gWTGPbUP0i7F/OgQiY4KCbOVda5imG3I=; b=Fp4uCPoakfc/Ib5C7flQZ4VFm4
	q2JtqEUrPcu3R5SZdjsHhX8As3oSNAmv6jGYzQXaPu0+WqTccW/enSn+7gz27trGJTtJPBXZAKBMe
	3cvQJoaFKhkyz0mYEvETKE8ZA3fjcq7zPsdv7fiduz6x4tFuEKj53EAqZG2hKThZRdiPW+j+U+cbr
	VHhuQDLaNi3xtsfYpHhXfN8H5fVSMoty/DdegFRkeeNi6Nda0TU6bM6iNirzMx1jsJ5SGmzL9yWlW
	xMB2t4OKD75Ig1VLUKOnLMLURFVg2/FEZI+G5P08h4im5o4Mga4NcK2lIaee+kyGdYTgBYtTVXk6k
	0cDcPgZw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3IDl-00000000o6J-1N2t;
	Sun, 06 Sep 2026 16:08:05 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 5/7] smb: client: fix file type corruption in wsl_to_fattr()
Date: Sun,  6 Sep 2026 16:08:01 -0300
Message-ID: <20260906190803.667489-5-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906190803.667489-1-pc@manguebit.org>
References: <20260906190803.667489-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Clear S_IFMT before the switch statement.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 10ef82d46d86..9edc379bd686 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1146,6 +1146,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	fattr->cf_uid = cifs_sb->ctx->linux_uid;
 	fattr->cf_gid = cifs_sb->ctx->linux_gid;
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
-- 
2.55.0

