Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB26C30F816
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 06:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765175027; cv=none; b=YJfPSdGRP3Ma/2UzvbOs+IJ3NdCURrb0FwIBsSCHRxAPSohLjy3QETCqUcvMIGazRjHzJ2dVdJMA//YCM5I9c0xgkL4vkdNhLprpbqMg5MeIthXfQv8j+VXyfV8JQmLnyVVreBwyOZrR56HXHFrWvAR39CNYX6oiMWreuBUhoQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765175027; c=relaxed/simple;
	bh=Sm7xJItM3A8nowZ/aAgVOb18ozcro+lPJ3CuXTL/RHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYgMjCUqFur1To5KNajvs6vIHJrWhKnLwIK6m0//+p/oE4jDPbYVI3g1YwVHIM1mNryG1kGbU3h78xYYnyVRw2oIkkaWEGeYxUcpqLt/5dPz2bWrI9BgOq9rwa7oRvkgr567wApl9+wjMKaL+x1+w0KsFL0/pzegAPVEZ1PyIvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ru1AR2pA; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ru1AR2pA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765175024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APRdAn0mnH6LsGxaYp180UZYgqFVPyYSJQSWTFgU0lQ=;
	b=ru1AR2pAVet3MxtbKX2dsSjLlARKm38kpPSQUZ5viZVlq3siKNhwE7Rkx2Tde47iA74uP3
	ZnQXshVzLAxA+0qVequX8AIftbYTcpGPK58tDwpW84AbWrDj1dNw6d9OZyl1AXeNCfkckE
	dkJdZc19aqQ9DAJ2xIEVILYFYy5Udn8=
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
Subject: [PATCH 24/30] smb/client: remove useless elements from mapping_table_ERRDOS array
Date: Mon,  8 Dec 2025 14:20:54 +0800
Message-ID: <20251208062100.3268777-25-chenxiaosong.chenxiaosong@linux.dev>
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
 fs/smb/client/netmisc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index d7d1b9b4abcd..553d2a33b6de 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -98,7 +98,6 @@ static struct smb_to_posix_error mapping_table_ERRDOS[] = {
 	{ERRnetlogonNotStarted, -ENOPROTOOPT},
 	{ERRsymlink, -EOPNOTSUPP},
 	{ErrTooManyLinks, -EMLINK},
-	{0, 0}
 };
 
 static unsigned int errdos_num = sizeof(mapping_table_ERRDOS) /
-- 
2.43.0

