Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFEF2EAD0D
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 17:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768844600; cv=none; b=JRBwSOElGURaoQ9N9jdEbDAUNvzcYDj9R+pljYGRhaAtRnhqiZR6wL1nuvgBv4UsOZVVvj1fX0velVYNvMSEYFrgqRRYXeliJTE1/dQ81VVTxqQvqaCFUt95O2uqMjj65OPLk08Mq9kevD8zWBZvo256atjTfq0PgyWXfCAH7uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768844600; c=relaxed/simple;
	bh=iGvrOzqPUJ/qeLuug5cswXxyRi6lC4hCaHa2qR+kFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EgqUGEsUr7S/yuqRKHrnOy5gm4mFPTq8gZxHxgnOJ/2rDlWR2xfQP5te/9wPEze4lbHWJS+VeOL9G/AmcBqVThG6yAAdoTrcC2GnrxD3aZXf/FawdjawxM6guMtjMp9QnvFUFCWltGmyMMGKnXvRdP5J3lMipPeVXVk16H8E5TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=v+tblFMX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="v+tblFMX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=NUYE8j9yPl0jpoX8En9kaNRoyvBQraT/1ExWrInBEV8=; b=v+tblFMXFoo8ZP1mWNKhSQlwI4
	xlo09JgZSMAmhc2U23dr35MwY0mphmXoIUzQyDUHIlM4eM5/24cZV0iWSpQGskI31ZvszXOn9swLe
	K0shFNgcckXvkrqPhaP89waNGy7YQlIMhsQxQbtpoA8Wpc6aPuNlb959eiTRRAefOYdN3HFGRr3yC
	hqROS9oFe735LmAWaltv9Hmu1mhzJtzbZYppHCBLpUFMqXEHH78i1JzVpU1DYhFxFYj/LWvkO9Rpt
	LEAHQdY75xOTgPvC1++DyaKqAIVLT/lZkLZTvP5JtqOhASoONWJDS/N6V2ncjbqDDNtmJG+d4uzEv
	z8uQXqLEi0DPMjvBB8HWCAaAtag4MtQbtn3hEVifArI4E25sZxfCwqHG34Zgx0skXJ5uMXtqAvBsd
	SQuLLKWbvPlGYKo0xnWKgPDUwDC9gzFtl3EFDsKMRmvCzaQ4cpGiSUZUce6CrpJFQieLmuLDamEZz
	siG5ZeSZiPePhfSIONiSOj3n;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vhtHX-00000001BGD-3FSN;
	Mon, 19 Jan 2026 17:43:15 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	NeilBrown <neil@brown.name>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH] smb: server: fix comment for ksmbd_vfs_kern_path_start_removing()
Date: Mon, 19 Jan 2026 18:43:10 +0100
Message-ID: <20260119174310.437091-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This was found by sparse...

Fixes: 1ead2213dd7d ("smb/server: use end_removing_noperm for for target of smb2_create_link()")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: NeilBrown <neil@brown.name>
Cc: Christian Brauner <brauner@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f891344bd76b..b8e648b8300f 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1227,7 +1227,7 @@ int ksmbd_vfs_kern_path(struct ksmbd_work *work, char *filepath,
 }
 
 /**
- * ksmbd_vfs_kern_path_start_remove() - lookup a file and get path info prior to removal
+ * ksmbd_vfs_kern_path_start_removing() - lookup a file and get path info prior to removal
  * @work:		work
  * @filepath:		file path that is relative to share
  * @flags:		lookup flags
-- 
2.43.0

