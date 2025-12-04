Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE652586E8
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 04:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824387; cv=none; b=XS2E3VRDRHUDLoBFFt8Rvco0PaT8gCht6VB9Vnbk5o0NPPikjJy2EwivdmppmyyEKP5/KHkwy/2upJ+8BR7aZybgKWf9XVGTo69SKGYEjJW7usHJfsDz7OG/RPMJCwG/HaIEiZxjZ74Fo7yza/bGWG9V2hZWZa+r4S6tdT1/DuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824387; c=relaxed/simple;
	bh=6aXn44a1M6nJNTujS0JveAqJewtw4mFPNA/YcXrkO6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QD9wNVM3aycPKHCpxFqFbSGwjKOt1R7HUAICNrzgvozaJCa35URd+JyFf1rlb1mew+nJHGAiGbllhwUYeLUwfDGY3ugspxKA/w2SfrG/K8x1dydvTTPdgN3ENZMd8+TyGHGsa2YEx2puxzONevn6Ys1OXA9dXzMr0uhcD3o9EBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=La6ekXPl; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="La6ekXPl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9E4YQC4tLUss3JEGgnYG4E8jlhj+nguaNxjZ4U4/UwY=;
	b=La6ekXPlqOMsGhBixHtv6DGY2oHK+2cbf9HSjixNQ/XxHFZmuaEH1fOBK3vWcLsgIXy7tO
	eNrN35nM0tJVU4if1D2/4Vtza5tWIEkWpTiyvYA0cZnfaAjcZZwerjYtt5VSYUg5EfeNZT
	Nyd1itTB+Kq8pl3NJfC4RO3Z3LuB3GM=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 01/10] smb/client: reduce loop count in map_smb2_to_linux_error() by half
Date: Thu,  4 Dec 2025 12:58:09 +0800
Message-ID: <20251204045818.2590727-2-chenxiaosong.chenxiaosong@linux.dev>
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

The smb2_error_map_table array currently has 1740 elements. When searching
for the last element and calling smb2_print_status(), 3480 comparisons
are needed.

The loop in smb2_print_status() is unnecessary, smb2_print_status() can be
removed, and only iterate over the array once, printing the message when
the target status code is found.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 12c2b868789f..d1df6e518d21 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -2418,24 +2418,6 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{0, 0, NULL}
 };
 
-/*****************************************************************************
- Print an error message from the status code
- *****************************************************************************/
-static void
-smb2_print_status(__le32 status)
-{
-	int idx = 0;
-
-	while (smb2_error_map_table[idx].status_string != NULL) {
-		if ((smb2_error_map_table[idx].smb2_status) == status) {
-			pr_notice("Status code returned 0x%08x %s\n", status,
-				  smb2_error_map_table[idx].status_string);
-		}
-		idx++;
-	}
-	return;
-}
-
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
@@ -2452,16 +2434,16 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 		return 0;
 	}
 
-	/* mask facility */
-	if (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
-	    (smb2err != STATUS_END_OF_FILE))
-		smb2_print_status(smb2err);
-	else if (cifsFYI & CIFS_RC)
-		smb2_print_status(smb2err);
+	log_err = (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
+		   (smb2err != STATUS_END_OF_FILE)) ||
+		  (cifsFYI & CIFS_RC);
 
 	for (i = 0; i < sizeof(smb2_error_map_table) /
 			sizeof(struct status_to_posix_error); i++) {
 		if (smb2_error_map_table[i].smb2_status == smb2err) {
+			if (log_err)
+				pr_notice("Status code returned 0x%08x %s\n", smb2err,
+					  smb2_error_map_table[i].status_string);
 			rc = smb2_error_map_table[i].posix_error;
 			break;
 		}
-- 
2.43.0

