Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269FE188596;
	Fri, 23 Aug 2024 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724421694; cv=none; b=iOVciYpGRogxVqWRQPMyODD0GORW/sVnMYFVZyqAyGlxTZrcdYQ9o2TwWanWBlZpfK1rnbD5YmFS7/O71qFZMVffT5ske8Ja6DfiZ21K932v4c37V9QrpH45p6FaFGUkSINSw2l12vwQXAzoIGYIu85UjLaCF0HMjM6hhDc2C2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724421694; c=relaxed/simple;
	bh=kmFJ6IkgaY+qHZ/H2gzxPDZxNt6344kfxXbIcUkQHcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpXy+KtURkX8hvyVX2K76piav4V44n+ZyHndoJlwROoO58FrYdIv/2lea0SPbTsMgDr2t1AOZ+qq7VIFLdaLTdSPZsS8Pc+D4bUov7mteIaIXALV8VlD/MTDL+X/Nm5ixbXAcbX6QBNv1HippqqYGnBwg2tmKcqUSWIT5xxbEf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sg6s3xGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sg6s3xGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EED0C4AF10;
	Fri, 23 Aug 2024 14:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724421694;
	bh=kmFJ6IkgaY+qHZ/H2gzxPDZxNt6344kfxXbIcUkQHcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg6s3xGjopKRcoQPDAvy7MzbT6UjKzkOcaTC6qb2BaBIDU3PrQaZt265V5clEN3wz
	 lcE7vkvt0/BQarwf0VfTFjBxR8aT2ZQP6s3i+2XnVG/9ERYi9qlKcGVFyXyi138X7g
	 c8B7CtZHjpmlSmLO83Yfx5c2MW9n+3lp5fcC3sXxcFpkVR79Bo2KGzZrIHrCmji7tY
	 rZxVOMhv+2SdpL/HMAkhqv/wqzMmyVepgsFVxVONvimtBWuJBck6UEh8Z4OyUYs/jV
	 GgvCAwkvt495yyNf6Ydm8sU1SIdOD2b+kMbFYyTV3DudDY051a+ouAr+jrCfBY1i2t
	 +OafJ2Rw2YxPQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Sangsoo Lee <constant.lee@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.10 03/24] ksmbd: override fsids for smb2_query_info()
Date: Fri, 23 Aug 2024 10:00:25 -0400
Message-ID: <20240823140121.1974012-3-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823140121.1974012-1-sashal@kernel.org>
References: <20240823140121.1974012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.10.6
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f6bd41280a44dcc2e0a25ed72617d25f586974a7 ]

Sangsoo reported that a DAC denial error occurred when accessing
files through the ksmbd thread. This patch override fsids for
smb2_query_info().

Reported-by: Sangsoo Lee <constant.lee@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 373c7ecbf8033..49adf6e65cb46 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5596,6 +5596,11 @@ int smb2_query_info(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "GOT query info request\n");
 
+	if (ksmbd_override_fsids(work)) {
+		rc = -ENOMEM;
+		goto err_out;
+	}
+
 	switch (req->InfoType) {
 	case SMB2_O_INFO_FILE:
 		ksmbd_debug(SMB, "GOT SMB2_O_INFO_FILE\n");
@@ -5614,6 +5619,7 @@ int smb2_query_info(struct ksmbd_work *work)
 			    req->InfoType);
 		rc = -EOPNOTSUPP;
 	}
+	ksmbd_revert_fsids(work);
 
 	if (!rc) {
 		rsp->StructureSize = cpu_to_le16(9);
@@ -5623,6 +5629,7 @@ int smb2_query_info(struct ksmbd_work *work)
 					le32_to_cpu(rsp->OutputBufferLength));
 	}
 
+err_out:
 	if (rc < 0) {
 		if (rc == -EACCES)
 			rsp->hdr.Status = STATUS_ACCESS_DENIED;
-- 
2.43.0

