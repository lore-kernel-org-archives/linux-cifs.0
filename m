Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DB6273D75
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034383; cv=none; b=pQp6sy01L0S35xrnj8HHXaDyG6gj8lz6PPyajY/hsEqrrWHHwronzpeulM1XP01FJ5bw8225YkUpB30W3s0SlNSOWVxNF6eIVMwPAn1JcQ6RxGe8Cq7ApD7ZmtbsLeIJNiox3H+2VbuQWpK2ayG7Y23xLkhgmHbLeKT4d5h9pDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034383; c=relaxed/simple;
	bh=pkfzsbbhoS8dSc0sCXHcgR0baQMXz4nmCTpdqOcLZkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMeSoUAJ0F3sB2MGzf+7Uq8WBsJF9GJXh47soJmx+SOoq93dYc1Pj3wazaZY7WYCnCAQGTEXto6Rik6zzIe8ZK/3kB6aTWcaVr19XFfBU/cmnFJgo1MgvKG5Dx6IVHfUL9KHDClfAydlu+NfKIwaJEmS+IYa3DHqSFglrFYyHDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xhwduOHC; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xhwduOHC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpu2+fHhdm+SVBxmfXBwkvLZquyK3vrWeg83HtvStqA=;
	b=xhwduOHCws3w47hmiK6h00O6y+krTM38LRKxoeRjtbNY3z8ED3MUQ2Jm2+0qY+oCWjB5xu
	SIMEYhtAcB+iZMU5tQf/1Enok++oUxervXChj59q+Y7SDEaSVUG4akLjs40FsxjGpGpei7
	W3Gd7ipyArY4c734eMfJ5ybgzZsjT8s=
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
Subject: [PATCH v4 02/10] smb/client: remove unused elements from smb2_error_map_table array
Date: Sat,  6 Dec 2025 23:18:18 +0800
Message-ID: <20251206151826.2932970-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251206151826.2932970-1-chenxiaosong.chenxiaosong@linux.dev>
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

