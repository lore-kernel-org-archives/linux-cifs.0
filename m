Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D162288C96
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765174995; cv=none; b=aIAaCECpK588fTD2yGs3qrcls13P8zozE7CNKGYgTysc6O2oLMh+rwKxnxUnaCtIyt4RR70kSvG8C04X0S0btQeLJ7IyfpZnaS2/y6YcdXVEpkTe+2ClmuvZGmvzqZkploDUqxP6gpCZibm86of6AiSBdpDKMTEQkHblZT7GhVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765174995; c=relaxed/simple;
	bh=Xa6u7EEB6ROil2s7okVH/IONJkWefu8Wp5CUEUSxwKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZAF9BZdSzcO0Kkw/V0Av2Z0lrU/j2jGfeEoW7r8Iwb0WDO6E8QsvpgqGHUW7QkwRnC+7CIewKh3e1DZxI+FSBVnpbd7HXR6r7aSdGFyqzpwW00VKmiCqzqze6ykZmUYl7aID3SPTa2LTC13+igVukdajf9vJvEDJvUUzSoXzM+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YEbVilNl; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YEbVilNl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765174990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7nsRpKTbneAsKr9vdFP0TRQt1KgHKYjbe7uCedyAnA=;
	b=YEbVilNlc1lzqJGXGZkV5hMFx1fkJH4nXqzpE5DQ8lVQMrAKquSjnYAjyqEZlWVUMGUl+Q
	YPAea8c2Gi2yUPtNjKGrWZpxZ/UJb3jSU8WZiaMzMa7tcA+W9uB+dXRoUrdjmu9AjOenBx
	McUVvYBHBextQJhS11lYZG2gMDJKHUI=
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
Subject: [PATCH 13/30] smb/client: remove useless elements from ntstatus_to_dos_map array
Date: Mon,  8 Dec 2025 14:20:43 +0800
Message-ID: <20251208062100.3268777-14-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The last element in the array is no longer needed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/netmisc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 55100c2c14cf..4e6312593d6f 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -793,8 +793,7 @@ static struct ntstatus_to_dos ntstatus_to_dos_map[] = {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
-	ERRDOS, ERRinvlevel, 0x007c0001}, {
-	0, 0, 0 }
+	ERRDOS, ERRinvlevel, 0x007c0001},
 };
 
 static unsigned int ntstatus_to_dos_num = sizeof(ntstatus_to_dos_map) /
-- 
2.43.0

