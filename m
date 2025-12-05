Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E512DAFB8
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 04:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909066; cv=none; b=PWR7Pi0OzVry7wDoqu7rx4GK1eDeyTN6h1Lptyi9tgM3VAJidiaoY2wwT6QcDfsFdWyLo+cwY0ShVkkwwXsJrKAnK4B5ASuMPMe0VqZge/0uw7slraYJkit8xBrxDqOus2nAJtOozC5QgnDWpbHF3bzmi2Ez6vv3JvSbokky1c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909066; c=relaxed/simple;
	bh=pkfzsbbhoS8dSc0sCXHcgR0baQMXz4nmCTpdqOcLZkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+WE29j5HYaWDWl27qHVZuQsVf07+gUifuY895rUpU/sg3eH1RFo4GWUWB2W6QzQmogc80zl28v6UKEcy3V666DNsizGt81KLXo0HeKUs9MY2pmhuD6XeIVjj4mqoZWlIIF8IDQe2tgPEcOVmWhb+ZNu/aOYXBgkaGHavJk2unQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v0taEtME; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v0taEtME"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764909062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpu2+fHhdm+SVBxmfXBwkvLZquyK3vrWeg83HtvStqA=;
	b=v0taEtME+BG3vZlfk5gwqaGz+QU58nt3+WLD3tQ7g0XMAQLyprSQIYOUfwuypwxK95cwRt
	7KOsjxj0asCwhv6ULR28PaR9eqEyZLpu4qLA8nQ6KSGy27n2QSraj0Qjk1PpTcKp3kcbpS
	h/NBxQAnMSM2uPg7/AQER2sxAYnJTjg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/9] smb/client: remove unused elements from smb2_error_map_table array
Date: Fri,  5 Dec 2025 12:29:50 +0800
Message-ID: <20251205042958.2658496-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205042958.2658496-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

STATUS_SUCCESS and STATUS_WAIT_0 are both zero, and since zero indicates
success, they are not needed.

Since smb2_print_status() has been removed, the last element in the array
is no longer needed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index d1df6e518d21..118e32cc8edc 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -23,8 +23,6 @@ struct status_to_posix_error {
 };
 
 static const struct status_to_posix_error smb2_error_map_table[] = {
-	{STATUS_SUCCESS, 0, "STATUS_SUCCESS"},
-	{STATUS_WAIT_0,  0, "STATUS_WAIT_0"},
 	{STATUS_WAIT_1, -EIO, "STATUS_WAIT_1"},
 	{STATUS_WAIT_2, -EIO, "STATUS_WAIT_2"},
 	{STATUS_WAIT_3, -EIO, "STATUS_WAIT_3"},
@@ -2415,7 +2413,6 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_IPSEC_INTEGRITY_CHECK_FAILED, -EIO,
 	"STATUS_IPSEC_INTEGRITY_CHECK_FAILED"},
 	{STATUS_IPSEC_CLEAR_TEXT_DROP, -EIO, "STATUS_IPSEC_CLEAR_TEXT_DROP"},
-	{0, 0, NULL}
 };
 
 int
-- 
2.43.0

