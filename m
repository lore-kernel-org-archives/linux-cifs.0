Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54941B0428;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684551; cv=none; b=FPslXCIcCtGGIgfQpanp7TDaVpFXYlXAsDosSKQj7ed0rEkKBImrAKRiDrZjsYlXbt7bRHstoJUwb41fqZyfVyxxhd+Gj6LhHLeg7KfWQEC5l+cRa/WsQEydx4UrbEts+m9hj8yJ7jloCMwlUV39Gw7lA6rQwpMY7SYyHUlxsgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684551; c=relaxed/simple;
	bh=W8c5iBpRMEjpMq8Amb2dRFJttRR277+4BAcA8bSbu3A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=MZMOW+UjnYF81O5PQjUDvnCIAaYGg6lbAhlQQjd4ra+TjY8oBENwgEL6YFDdq4xPqIhYdV2KqAoAhVBfzjnhhUVZpsJgyzL7Nd3z5+IaW3NrpBkWnoQ8G3fiqVuU7lBUZYUmjq2uf2lSfunJrP4NikbPC0YmeNoHXGNKpDHVBAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWLvjDcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWLvjDcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C385C4CED2;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684551;
	bh=W8c5iBpRMEjpMq8Amb2dRFJttRR277+4BAcA8bSbu3A=;
	h=From:To:Cc:Subject:Date:From;
	b=HWLvjDcN3s68YRcoPcwSx9m4MdjxaUlYzWMgHuJLKYF/rk3h2FYY38iD9HgYeuxh1
	 v5y9G65dLu2+aV7432o2onjokC5pxwIF6pVNySQE4XI01ilW2dKR/o/h7SohSYYmdg
	 lFZkfHBcf2mdxYoEAl//G036mrrDu/YU5/bxZtKRYcNQkkhS4A7fQDIRc+ak/CyUg3
	 kn2m/vn72nP0UQEuGBtzE8O1EDP5FAV06b4fXvH6Fmu4bK2Idv1MjHvt5qPgJY3RDD
	 R/rMv494CeTMpownQtw5TtyTmTzKujGpDNvFk8tKCrdLEgQq9bBcyFhwjpt00225bM
	 9t0MV86hakzGg==
Received: by pali.im (Postfix)
	id BC23D97E; Tue, 31 Dec 2024 23:35:40 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] cifs: Fix access_flags_to_smbopen_mode
Date: Tue, 31 Dec 2024 23:35:10 +0100
Message-Id: <20241231223514.15595-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When converting access_flags to SMBOPEN mode, check for all possible access
flags, not only GENERIC_READ and GENERIC_WRITE flags.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index dd71c4c8f776..604e204e3f57 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1024,15 +1024,31 @@ static __u16 convert_disposition(int disposition)
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
2.20.1

