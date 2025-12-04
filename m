Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0452FBE14
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824389; cv=none; b=rwWp/B2z4gcxkoIqq4Z07sk2+Y9r3DfS5tySf96Obs0t/JItpfCwsXg9/XdD187uNOn01fO0/rolb9RsKqtTqihIQMKS8c3e0/KnD7iwDIJlYVlhViKTi6R/DWbwxdA0i24uBPB85D1Nmd44fbaVFOcEOS5nZxCOb1/7K674bew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824389; c=relaxed/simple;
	bh=pkfzsbbhoS8dSc0sCXHcgR0baQMXz4nmCTpdqOcLZkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsbnjNoFJ5sP5V/j5Az/9dK9dIsZUvN/WYSjSPmwRT59cwens5uWT6c50K0nfvR/z83fxerpRGD5UQaszJLRZmpI1xIZRBLt3w3vQr0hCI4yDMsQD1Pb9+op4Rj46pNfW5bG4wUc39KolCWpbgqcTbotiJ6i5Vrp0zcQZsv4wIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qrJRreqU; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qrJRreqU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpu2+fHhdm+SVBxmfXBwkvLZquyK3vrWeg83HtvStqA=;
	b=qrJRreqUBYM7lO0FSS+ISqvDYcsWIkW7FTyM5RppZ6AKqQ528+HXN7gGlJWNfoxAyr5pFn
	qaprrb2wD+5Ur79JzaNzcViC/uoRtUz1moAMHVLcY5PsBtWmD/5rxxKDHiq+jvfre9bnUE
	9oSdgrHxPNvzl4YM2K2VLGFS0GSCKlk=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 02/10] smb/client: remove unused elements from smb2_error_map_table array
Date: Thu,  4 Dec 2025 12:58:10 +0800
Message-ID: <20251204045818.2590727-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
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

