Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B7132E753
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 13:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764941217; cv=none; b=ppZWi3lzxDxiZlaXOUxR4DQZ0TukZtDPRHh42vNGm59Fr6fk3G/X9/wZru9MtET+93Up7obLabXwI7LON1+GSeKZc/PBk08IrqFwdkSARP20m4cxmdDp7Y8vov77gxczZu9X4M1vNtBZByz2Lh18d8HXpuC5O3IbXFzTs0ZRlJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764941217; c=relaxed/simple;
	bh=pkfzsbbhoS8dSc0sCXHcgR0baQMXz4nmCTpdqOcLZkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHQcMWBULlRX3+cyqw2STVepJcTXEjfGUfPJbkxNwudPBWs6UMnFLWmODwwtTfDnZ0nP99Oj7++PUxpGH95QvmPHvjZu4CFvBSmq6VGOL/8tL0NZ+sIM8H9aSTAU8PViCkLt2PudqYeq/+zKygZEJmLaknMxl8SC4eM+tjcOo6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LFq3Oq/B; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LFq3Oq/B"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764941211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpu2+fHhdm+SVBxmfXBwkvLZquyK3vrWeg83HtvStqA=;
	b=LFq3Oq/BrlOBOgur42guTKvhn923wYm6ZgOfOqVIWxQCBPDUPzgnOCHwHnKzeny3r2zsvA
	o9+9c46GGaFru6GDUAEdA+sMQtUxEm+i6+cWUFWjSAN4PL8AaR8FGqhXC7z8C+xEQhl4Pm
	fMP6i8Ywcw9J1R6LYKDky6fxVBXZXe8=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 2/9] smb/client: remove unused elements from smb2_error_map_table array
Date: Fri,  5 Dec 2025 21:25:28 +0800
Message-ID: <20251205132536.2703110-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251205132536.2703110-1-chenxiaosong.chenxiaosong@linux.dev>
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

