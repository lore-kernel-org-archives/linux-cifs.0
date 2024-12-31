Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C6D1B4124;
	Tue, 31 Dec 2024 22:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684573; cv=none; b=njNSJwJ+WuBuMB1MGPvjOG8lDH9qaKVIcDZlD8GXYfoL917hqWpIWd15MDU7xaqFDtbZI6gF106/KV6688swONntWfjqU2fHKL5caV0IaaqK7Kcm2KOMzkSlVvW++FXVl23/BdFMwbYgM/J59Z6/hh7hV5nIxVuqjMMVrXEhBqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684573; c=relaxed/simple;
	bh=3XLPqvJJZJPa8z8IkXYFrQmMa/meoU5EyQwdPbBvo9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxORid8/2NoN+xv+tXF3MfDLFppk20G7zUk+5PggRHcJznEIHZkYxo6kiM1gyiJOho+UH0wk9VKvJCVmxFqqNsBwzIKrtPsyO11WynvLhA34eYqjJD7PWzqkbPOFOkFxcSkWslg+emtycLtsmfrmlZIfM/yhA7vOHra/9g6Dj9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8l/jyv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8l/jyv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D9FC4CEDD;
	Tue, 31 Dec 2024 22:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684572;
	bh=3XLPqvJJZJPa8z8IkXYFrQmMa/meoU5EyQwdPbBvo9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8l/jyv1A0YDCsrp6eK2rlwSZpU3lbfdZAnD3InTdpeWXt0TEwMOg45Z24RZhyDGh
	 snxJUMqzFDTeUCMeZ1Z8S4a7jGQfcBbqhvg6RqSAyxUY0uS5t2sv4oaud9PQriqlML
	 Tjuad4bUd9UgzJx+i2Mmj6VrSEh9TphM7nXrcHD3uwTFOhjiKeO4bq4Bb4mXADuzBa
	 qlQzzRmGX2GAxWD2lIEp30GgomHAn4oXeZCKQpMSZ6yLLfcvrQdaIt44nWgsSa1bpP
	 +QS+xAz94NC4bpjHLnBBMVRRg1u3emJ+35BoRUV4FMGvZF6+4Dj0eMzY9mkCxlOvSS
	 UxyjkDMWutDyg==
Received: by pali.im (Postfix)
	id 1C30C983; Tue, 31 Dec 2024 23:36:03 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cifs: Do not attempt to call CIFSGetSrvInodeNumber() without CAP_INFOLEVEL_PASSTHRU
Date: Tue, 31 Dec 2024 23:35:49 +0100
Message-Id: <20241231223549.15660-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223549.15660-1-pali@kernel.org>
References: <20241231223549.15660-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

CIFSGetSrvInodeNumber() uses SMB_QUERY_FILE_INTERNAL_INFO (0x3ee) level
which is SMB PASSTHROUGH level (>= 0x03e8). SMB PASSTHROUGH levels are
supported only when server announce CAP_INFOLEVEL_PASSTHRU.

So add guard in cifs_query_file_info() function which is the only user of
CIFSGetSrvInodeNumber() function and returns -EOPNOTSUPP when server does
not announce CAP_INFOLEVEL_PASSTHRU.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index a0a15dda0949..d959097ec2d2 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -622,7 +622,13 @@ static int cifs_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
 	 * There may be higher info levels that work but are there Windows
 	 * server or network appliances for which IndexNumber field is not
 	 * guaranteed unique?
+	 *
+	 * CIFSGetSrvInodeNumber() uses SMB_QUERY_FILE_INTERNAL_INFO
+	 * which is SMB PASSTHROUGH level therefore check for capability.
+	 * Note that this function can be called with tcon == NULL.
 	 */
+	if (tcon && !(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
+		return -EOPNOTSUPP;
 	return CIFSGetSrvInodeNumber(xid, tcon, full_path, uniqueid,
 				     cifs_sb->local_nls,
 				     cifs_remap(cifs_sb));
-- 
2.20.1

