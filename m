Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D82DDAF
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 04:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="hqleqbUM"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702699815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=592PpszBy+wK5ur9oBozp/DCIholZwuFhMl1xRTDUzQ=;
	b=hqleqbUMZ0yG7QUTwwMODsAab4fNUGahn1OQaOgNGBvehojFrTVIo1s3vffcITKk/a0F+y
	MK26n1f+upJ3UYlK4ADHlda++Zj/7CY6u/YIhaMS9uqlkeHp4lUI3slMIEGveMGthuJXUF
	3t+axKQ4FaGhEvC3/p0yfCQ3y3Qlh+jltKnI4v7n6mZWgs8VnxHbEaRPcnAVTU97Gs85xS
	mYk1gY02A1IcJBUix/2QXV0vdYk25LY5YYbhTjNyyyb4jxxVV5ULURDi7oZb1fG5UfWwTk
	6IW25LzXoDR8VwT0IgRg+ITnjJcONTGVYHYOs3zEZdr+CeKjJeM+0MuagURunQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702699815; a=rsa-sha256;
	cv=none;
	b=a8iAT3D5jEUpV6qcjcxJckHyCtdTuiSKgO04JlBBQfZqAEAKf/Nts7Z4R5nNJ+aqdgTFRs
	DPg0h6Ejgr6IxwVi8zXCI8lnbEBg1OxHGKTVQHHLWVezFa/QUsoBc90JtT5LgMdKMKfDWE
	z4niupG+mUwTfIbTvJquzuQnpWRfSssxrRRQOehBOAsMKqaiDPrvcZrx6g0WMAww85GmiB
	YMkeXwzb46mXMZLlawhZ0D949yBtHVPjVurzKZsT8HmSgxQdc9ix92c341A1J9gDBoE8Le
	4/HGXbNWks0jSJG8X8ZPImHmXurYpvofWmRjPA4WK06KO5L8W3PTBeYUFHtQ+A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702699815; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=592PpszBy+wK5ur9oBozp/DCIholZwuFhMl1xRTDUzQ=;
	b=QcY0DuOKuJ6XGSkZ9+WP1zr3LhjcIlXY4wnw6V8y6EoYNR/AZ24RFMf/hFy0UbhBqNPhfi
	62fJIJ/2o+1uQw3iCMDQ4lYiCcU3xLVc3So/E3tpl4Lny8l+Bf8olQRhIC5iFbX2sOMxfK
	oL351BQ0Na39smvJaW1c4EVgl4YXebocPLDZSK2aNieUXh14jLrHBXG42i8gOg6u6m7QCl
	3A2o017tdva89McML0AaTrqbCOXP/ewo/EQbTfuo4b6whXkd4ujk2uSV2xRwkXSVSHaqfN
	xCLnULKLZwmR8MMm2BEjAekX78HcXWfEvIeMIbubDYGMXe6jxf3ANAe9jdJTYg==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	j51569436@gmail.com
Subject: [PATCH 2/2] smb: client: fix potential OOB in smb2_dump_detail()
Date: Sat, 16 Dec 2023 01:10:05 -0300
Message-ID: <20231216041005.7948-2-pc@manguebit.com>
In-Reply-To: <20231216041005.7948-1-pc@manguebit.com>
References: <20231216041005.7948-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate SMB message with ->check_message() before calling
->calc_smb_size().

This fixes CVE-2023-6610.

Reported-by: j51569436@gmail.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218219
Signed-off-by: Paulo Alcantara <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 62b0a8df867b..66b310208545 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -403,8 +403,10 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
 		 shdr->Id.SyncId.ProcessId);
-	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
-		 server->ops->calc_smb_size(buf));
+	if (!server->ops->check_message(buf, server->total_read, server)) {
+		cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
+				server->ops->calc_smb_size(buf));
+	}
 #endif
 }
 
-- 
2.43.0

