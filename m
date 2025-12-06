Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0173723ABA7
	for <linux-cifs@vger.kernel.org>; Sat,  6 Dec 2025 15:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765034388; cv=none; b=T1nk8IZ37G55hXTsBQ3KvpS3A/JxYN2eOdj3PGiZ67X3CAD5/X5BdjAtEvQcJQUG+MwB8VfZpMcPMKOwGYLrDET0+9ZEOtBRvjUmBFEjOBSF4J/C+VvxlKDQup5iXeHk8boyKK/R3vQ9tiOfW+VtLBQT7GEP1mHxq2upODGYEeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765034388; c=relaxed/simple;
	bh=6HJEMr5X59OEb8//cubWzNJerCMISoQtM0zHJvgTDYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1qZMGxjZpf4BWOsbCQzWicv/8Df+lVwRKnvIjoWppIxGl2w1xhxuoDyjt2GarsV7ql/Dr4xm0NJfj1ohkQP3ZW+GS9V9BS/XzeFTVcLjfoe5RWXTb9SzFkKwRadkpiZFE2xR0hlKBi0uWg+hR+pGgjz49S9tk+4gxnjPVTQ4Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pd9to7U3; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pd9to7U3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765034385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k+idk5A+mq8aU5amT3grfojWt2+XsKPXn7rdBgtsvkw=;
	b=pd9to7U3R80Uevte+q3EWkmT7zBofdvgLKwCPwlnwlTenBL8F3g/WU7pt4bn2mWXY/bn2o
	TPlBrT8/aOSkt2itKGWo71NgyQnPVGu6+c9XiZYmdADmSccO0em+eBF5cjzm1dN9MHoEyj
	A+lTsT55PH05cuBVBZmlAmV2CPoiRa8=
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
Subject: [PATCH v4 04/10] smb/client: add two elements to smb2_error_map_table array
Date: Sat,  6 Dec 2025 23:18:20 +0800
Message-ID: <20251206151826.2932970-5-chenxiaosong.chenxiaosong@linux.dev>
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

Both status codes are mapped to -EIO.

Now all status codes from common/smb2status.h are included in the
smb2_error_map_table array(except for the first two zero definitions).

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2maperror.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 118e32cc8edc..a77467d2d81c 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -734,6 +734,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_FS_DRIVER_REQUIRED, -EOPNOTSUPP, "STATUS_FS_DRIVER_REQUIRED"},
 	{STATUS_IMAGE_ALREADY_LOADED_AS_DLL, -EIO,
 	"STATUS_IMAGE_ALREADY_LOADED_AS_DLL"},
+	{STATUS_INVALID_LOCK_RANGE, -EIO, "STATUS_INVALID_LOCK_RANGE"},
 	{STATUS_NETWORK_OPEN_RESTRICTION, -EIO,
 	"STATUS_NETWORK_OPEN_RESTRICTION"},
 	{STATUS_NO_USER_SESSION_KEY, -EIO, "STATUS_NO_USER_SESSION_KEY"},
@@ -2413,6 +2414,8 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_IPSEC_INTEGRITY_CHECK_FAILED, -EIO,
 	"STATUS_IPSEC_INTEGRITY_CHECK_FAILED"},
 	{STATUS_IPSEC_CLEAR_TEXT_DROP, -EIO, "STATUS_IPSEC_CLEAR_TEXT_DROP"},
+	{STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP, -EIO,
+	"STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP"},
 };
 
 int
-- 
2.43.0

