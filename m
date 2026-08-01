Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E328846A
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 07:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785570992; cv=none; b=SORLjsCTmElvGjXW2WO6y7xkThsZHPkhN4hKDERCnV+zuY+7XeRAox+6Ax9edv3DOuYf4znB1pFlelRDAG73PyuSKTILgA+Mu8E9xLx9WegO9HkatcRnvk7RrXUWpPV5lJgog1C7XBl6zzuCpNP6ttD8lTBkEFl77l1E3xhkcyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785570992; c=relaxed/simple;
	bh=+1BFKio6JpBEn6cyWitcMpqxAMKO/jKxLVR6EtgH9iI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TEnH1YuDgml4RXIyaM+qwD7M10/qsxYON7iIVRxbIPLIGhFHjBLPn502HBNCj+1GiJucBmctJNGvoLvzTZprXlRdiRWFqJ4fQMZZNbSLDrrLcAiL+u04v16oX+RQVO3WZzfwuD94/CzYa6B6Kjz2bY2IuvrdYNq2dTvdak7xJBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=OXTWlwg8; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="OXTWlwg8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785570984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lcZ/Gczw5k0aNBRKQKTZ+buxExc/JsIqmKwgo7KmG/g=;
	b=OXTWlwg89qxILd4qQFrFB2XJ91AZ060SSZfpD69n1iDnIyMH3BU0qMNtGTc7BwdZa5CWDp
	QyHxTUlNrgSRgGSdCyXzXKDeOZNjPWsC59ucjNWQUo2pDPsgOcEqrtPaYDfD+/NL6MsUKo
	pOm0zw9FkOPOnJDbYrc0aCd1iybwMEPVMWEjD0/CYlLGLNroETTc/QRS2e5p1qgUvkgDg5
	xKpmZfPdWKEiosyfPSAekk+YD9Sfh9xVITlN5z1Mj2DY5Cd0re0eLI2AFPl4Pu5hYlMMfA
	jrNJhLwTXL5HcLhy2pMYAAxXuqu7hJ+pNRuWH1DSdhp3b2GDvpNurh2tPdYm2w==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/client: show compress mount option
Date: Sat,  1 Aug 2026 07:55:15 +0000
Message-ID: <20260801075515.140004-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Example:

  1. mount -t cifs -o compress //localhost/test /mnt
  2. mount | grep cifs
     //localhost/test on /mnt type cifs (..., compress, ...)

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 1788d93a2522..a1dacc7d8f74 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -692,6 +692,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",seal");
 	else if (tcon->ses->server->ignore_signature)
 		seq_puts(s, ",signloosely");
+	if (cifs_sb->ctx->compress)
+		seq_puts(s, ",compress");
 	if (tcon->nocase)
 		seq_puts(s, ",nocase");
 	if (tcon->nodelete)
-- 
2.54.0

