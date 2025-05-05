Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4766227935F;
	Mon,  5 May 2025 22:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483272; cv=none; b=IbqTgM3ApaebavxlskfJFO2+oA7xfeuzNhNKqVNYk2Ce+oxKElEXAT+XnHU4qb/WbglZ+1sG05wIIhb1qjHvThFkMxDQIq5UdXB3/3R2oeK21My/YtBrrWK3yHIJSC2Cj4lv+TV7PahJ9qtur9bZ2UvdMIIS4fXezYL1ZqxP6dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483272; c=relaxed/simple;
	bh=vTWdEUGED8dsDjRpFam5cGKS5PxqzED40BtaT+yB3XU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ERU0pnlqJdH5efAxWUwmaThI3XVGsq9CBGYqQvICg/mTfBgp0Ch+faNlF+l+s1zI+Za81s70gn9MNfJehOK0W6+zy2jLgvkj+s84dQ2iIeWS3L17Rh7eP5aMl34pj2oakWywq0N0AtPMjDSOqPL48mIgLYLVEIaUJP8hYY4jdOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ci+u5zO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci+u5zO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447E9C4CEF3;
	Mon,  5 May 2025 22:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483272;
	bh=vTWdEUGED8dsDjRpFam5cGKS5PxqzED40BtaT+yB3XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci+u5zO/WjRRls8uveiMSuar9oSbBWhvSoyX47yspXmIh35zuGu66Et4CjphG6Y0b
	 MzE0z/5S2U9Jb7hDafAa1oqYdTS/Kc/jVHB0EvNDvnbRWSWx0nOVJhvLfqlkYWRTbY
	 wWKhxdgj7HLB7mOKPysMeQ/NS2m/1aY2OuCAoN3HQwOZE3FmZAP8lyWeAGUS79Yyar
	 5IpGbEoGX0FvuGkydbjaiY64Y7df7qBJ1a8oeWzQ9SiXUfPt5nOfAN/OevjgDz0+on
	 Q5czMW/oRzKXGx2DQSRPJ/a+YWpKI4Ck/kxAeZ1yK0GsQ1icpFc9V1eS+ByIxAKNmL
	 3XH1hLkmv+1+A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 006/642] cifs: Fix access_flags_to_smbopen_mode
Date: Mon,  5 May 2025 18:03:42 -0400
Message-Id: <20250505221419.2672473-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 6aa9f1c9cd09c1c39a35da4fe5f43446ec18ce1e ]

When converting access_flags to SMBOPEN mode, check for all possible access
flags, not only GENERIC_READ and GENERIC_WRITE flags.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 4fc9485c5d91a..c2abe79f0dd3b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1038,15 +1038,31 @@ static __u16 convert_disposition(int disposition)
 static int
 access_flags_to_smbopen_mode(const int access_flags)
 {
-	int masked_flags = access_flags & (GENERIC_READ | GENERIC_WRITE);
-
-	if (masked_flags == GENERIC_READ)
-		return SMBOPEN_READ;
-	else if (masked_flags == GENERIC_WRITE)
+	/*
+	 * SYSTEM_SECURITY grants both read and write access to SACL, treat is as read/write.
+	 * MAXIMUM_ALLOWED grants as many access as possible, so treat it as read/write too.
+	 * SYNCHRONIZE as is does not grant any specific access, so do not check its mask.
+	 * If only SYNCHRONIZE bit is specified then fallback to read access.
+	 */
+	bool with_write_flags = access_flags & (FILE_WRITE_DATA | FILE_APPEND_DATA | FILE_WRITE_EA |
+						FILE_DELETE_CHILD | FILE_WRITE_ATTRIBUTES | DELETE |
+						WRITE_DAC | WRITE_OWNER | SYSTEM_SECURITY |
+						MAXIMUM_ALLOWED | GENERIC_WRITE | GENERIC_ALL);
+	bool with_read_flags = access_flags & (FILE_READ_DATA | FILE_READ_EA | FILE_EXECUTE |
+						FILE_READ_ATTRIBUTES | READ_CONTROL |
+						SYSTEM_SECURITY | MAXIMUM_ALLOWED | GENERIC_ALL |
+						GENERIC_EXECUTE | GENERIC_READ);
+	bool with_execute_flags = access_flags & (FILE_EXECUTE | MAXIMUM_ALLOWED | GENERIC_ALL |
+						GENERIC_EXECUTE);
+
+	if (with_write_flags && with_read_flags)
+		return SMBOPEN_READWRITE;
+	else if (with_write_flags)
 		return SMBOPEN_WRITE;
-
-	/* just go for read/write */
-	return SMBOPEN_READWRITE;
+	else if (with_execute_flags)
+		return SMBOPEN_EXECUTE;
+	else
+		return SMBOPEN_READ;
 }
 
 int
-- 
2.39.5

