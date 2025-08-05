Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876A71FDD
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754432097; cv=none; b=llufGy3ky4aaEU/Q6to1vnoDbXaLo+IFwEPiqgP72QYdjz0DnPuRwkZrX91BYHgg7TdxaYZfL8ed7Sir93Fmj00mynBzekOvkSxw+A2lm1++vFOtZ8fOkz+7YbauCcb1e3jivin4Z5NUfsfCq8c5i0VLkb5JSqBf87hGFZ1Y4WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754432097; c=relaxed/simple;
	bh=mK5IRXzGj28GAhNf0zCiy9WnGkUiWlPc6qdrcRSf9g0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=StFXXZTBvDEzorbc9WKn0BM6vM53d/IXqWN1skqWQeb9qIJs69CoYsr70DQD68nYyZBZJWUmFry7cuQNd/KnB5mLIw6pYx+288GOv6IlpwJaz3UYGoFXR53jWQv612P2kLjsvStxWsx0QqJCMBpVL4zcn6zDRU6rqwc3jfFvyiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PlASeJQN; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PlASeJQN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754432083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=deJVCHOrfeXofIjfV/ZrgjbuJYlj77iTRiW6Wr9/ugw=;
	b=PlASeJQNviCs6KvXSVntRK0INhPS/WiVjve6A5PB8Q3HV0k5Mbwaey623I5x1yq7w/YJo5
	0erNA92BQ9+u7ye78nt+8gC692V4NwC9o6w9/v3gwRPYKBjsDU0mqTXbECmX62hwmUrXzy
	P/uZvvZdRlGIK1ymw8KwsIHvhktw/aw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: server: Fix extension string in ksmbd_extract_shortname()
Date: Wed,  6 Aug 2025 00:14:23 +0200
Message-ID: <20250805221424.57890-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In ksmbd_extract_shortname(), strscpy() is incorrectly called with the
length of the source string (excluding the NUL terminator) rather than
the size of the destination buffer. This results in "__" being copied
to 'extension' rather than "___" (two underscores instead of three).

Since 'extension' is a fixed-size buffer, we can safely omit the size
argument and let strscpy() infer it using sizeof(). This ensures that
the string "___" (three underscores) is copied correctly.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/server/smb_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index 425c756bcfb8..92c0562283da 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -515,7 +515,7 @@ int ksmbd_extract_shortname(struct ksmbd_conn *conn, const char *longname,
 
 	p = strrchr(longname, '.');
 	if (p == longname) { /*name starts with a dot*/
-		strscpy(extension, "___", strlen("___"));
+		strscpy(extension, "___");
 	} else {
 		if (p) {
 			p++;
-- 
2.50.1

