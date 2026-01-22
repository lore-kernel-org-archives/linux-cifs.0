Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D46734DCE2
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059526; cv=none; b=V8b1x137XCUSMIIpIqK/XgEzu1+yOtZ1B/fuZWpD2ObqN8FPq7Nc5+JiS5z55da5ziK3RvovrFJxqCAwpjz7jRb0WgjBZAFhTB2VSb82DOhc7JVwMmYQqBRSH9HwkQVx07yyLkYr0E7rXwy48Iud9ByQOw6o6S8JojWFeK16CJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059526; c=relaxed/simple;
	bh=H1fuqBMTP1ZZkRcXaioZ6VqY0e1tg5Aw34qXGxqdt2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3iMUAF7+gmZyaCahM8KPtxUB5rX9iHl30HYxo5xzAnW5w/qHIer6rVlX/jvN8SNmgl9xTejZywYx9izpzDsy4/Upe3sekvA6YbU64HJal8wRF0TYeSSLAMtDycogyD0c+Zq5mwi0RuUJHhBvY0k+9L3PWOQrpm136nMATCsbp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SW/sPfS3; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SW/sPfS3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8A6GcqgW3b9jCRYhnVC6QpIHnZKhZTaWZlQ2nzZ8Otg=;
	b=SW/sPfS3WgyxAfM/Qjj26RO6QQuqk0adw5ekQGm37YZp667PfNWXGf5AWs3GzJeJs2//8J
	TSby6H6F5mfDng3JdincKILa9A2M9NRT8pvcg5AjqkSpcV2UyNyzxlHrVkiAsnb2PQBagM
	ezl9QLQyCfGJBqz0y5tCC1ucJvt5YrA=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/7] smb/client: map NT_STATUS_BUFFER_OVERFLOW
Date: Thu, 22 Jan 2026 13:23:57 +0800
Message-ID: <20260122052402.2209206-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

See MS-CIFS 2.2.2.4 STATUS_BUFFER_OVERFLOW.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 10ab889a442c..c1330d32ef09 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -114,6 +114,7 @@ static const struct {
 } ntstatus_to_dos_map[] = {
 	{
 	ERRSRV, ERR_NOTIFY_ENUM_DIR, NT_STATUS_NOTIFY_ENUM_DIR}, {
+	ERRDOS, ERRmoredata, NT_STATUS_BUFFER_OVERFLOW}, {
 	ERRDOS, ERRgeneral, NT_STATUS_UNSUCCESSFUL}, {
 	ERRDOS, ERRbadfunc, NT_STATUS_NOT_IMPLEMENTED}, {
 	ERRDOS, ERRbadpipe, NT_STATUS_INVALID_INFO_CLASS}, {
-- 
2.43.0

