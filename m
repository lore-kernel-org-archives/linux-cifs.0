Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A223E9F65
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 11:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768996228; cv=none; b=Nq2uW/VBsVQwoR/agx0rJlwSBSAPq3X1nIsXR3gwBC3ej8JRr3L0z6rcCJSljeRpg6b/FBzL8J9MCaE+GJ42lQTpX+nxqHMi2KeQyfnUvpHfsRoZQGWiGwHhQER6FFTPYLdL2LApTRRTkxxqQbGzZ2Y7J1YKKcoyzBYB994uJAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768996228; c=relaxed/simple;
	bh=kEAetfSZy18IUxXz4kWTGB+BE8BIfqt82+gJzPXjdtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=at1W1I/GJKRizJXg7KACQBEEqdROX6W4qeyUzEKXIsfhuLaNJvwZXRw8iRpdZdA181C1W/gShxOe4/t607tK00BgN/wHgDA4wuMOGe5sR1tMq9bXquRPMclTk3lMFpLILYhNzG/9szbwsgwyFW/9DA4WhF3YXxZijDm6qYtXm98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wU3whd0j; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wU3whd0j"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768996223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EESco5pgw/jOZ18GRS1ExLQhlnunZU4c98xodierz3w=;
	b=wU3whd0jHFUniqcEI+YpIEOOTqg9McH6ZnN0Vg4PJzztfBKn/PWzZf8v98Ezvsx4guNzo5
	V4huY5SZdL7KVy14tKFTGWnawUCGVX0JKEH20X6yBaLIu5UzR4EI95ohDBAgJDY4V7EpqO
	NUZ8RQyqrw8p2267hg8RVnOZJDJbTkc=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	hehuiwen@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 04/17] smb/client: add NT_STATUS_VARIABLE_NOT_FOUND
Date: Wed, 21 Jan 2026 19:48:59 +0800
Message-ID: <20260121114912.2138032-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

See MS-ERREf 2.3.1 STATUS_VARIABLE_NOT_FOUND.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/nterr.c        | 1 +
 fs/smb/client/nterr.h        | 1 +
 fs/smb/client/smb1maperror.c | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.c b/fs/smb/client/nterr.c
index 7f29fd5a482d..6f30bd5dcf61 100644
--- a/fs/smb/client/nterr.c
+++ b/fs/smb/client/nterr.c
@@ -346,6 +346,7 @@ const struct nt_err_code_struct nt_errs[] = {
 	{"NT_STATUS_STACK_OVERFLOW", NT_STATUS_STACK_OVERFLOW},
 	{"NT_STATUS_NO_SUCH_PACKAGE", NT_STATUS_NO_SUCH_PACKAGE},
 	{"NT_STATUS_BAD_FUNCTION_TABLE", NT_STATUS_BAD_FUNCTION_TABLE},
+	{"NT_STATUS_VARIABLE_NOT_FOUND", NT_STATUS_VARIABLE_NOT_FOUND},
 	{"NT_STATUS_DIRECTORY_NOT_EMPTY", NT_STATUS_DIRECTORY_NOT_EMPTY},
 	{"NT_STATUS_FILE_CORRUPT_ERROR", NT_STATUS_FILE_CORRUPT_ERROR},
 	{"NT_STATUS_NOT_A_DIRECTORY", NT_STATUS_NOT_A_DIRECTORY},
diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index be74410da6d5..e7d431d43b76 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -301,6 +301,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_STACK_OVERFLOW (0xC0000000 | 0x00fd)
 #define NT_STATUS_NO_SUCH_PACKAGE (0xC0000000 | 0x00fe)
 #define NT_STATUS_BAD_FUNCTION_TABLE (0xC0000000 | 0x00ff)
+#define NT_STATUS_VARIABLE_NOT_FOUND (0xC0000000 | 0x0100)
 #define NT_STATUS_DIRECTORY_NOT_EMPTY (0xC0000000 | 0x0101)
 #define NT_STATUS_FILE_CORRUPT_ERROR (0xC0000000 | 0x0102)
 #define NT_STATUS_NOT_A_DIRECTORY (0xC0000000 | 0x0103)
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 0735f7ed676d..2f81c4adef81 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -391,7 +391,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_STACK_OVERFLOW}, {
 	ERRHRD, ERRgeneral, NT_STATUS_NO_SUCH_PACKAGE}, {
 	ERRHRD, ERRgeneral, NT_STATUS_BAD_FUNCTION_TABLE}, {
-	ERRDOS, 203, 0xc0000100}, {
+	ERRDOS, 203, NT_STATUS_VARIABLE_NOT_FOUND}, {
 	ERRDOS, 145, NT_STATUS_DIRECTORY_NOT_EMPTY}, {
 	ERRHRD, ERRgeneral, NT_STATUS_FILE_CORRUPT_ERROR}, {
 	ERRDOS, 267, NT_STATUS_NOT_A_DIRECTORY}, {
-- 
2.43.0

