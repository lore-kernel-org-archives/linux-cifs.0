Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDB4328635
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 02:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465792; cv=none; b=mqxE9kKr6MxiQVqZdJ5PJ3m9PDarjAVT9zCXVntIQrOTjESy1UFEjrIRreZMf0VBiNPLtIGrK3COqT62TH3QeqYyQKB0JYOIACVmjbPsIQlDB9uypLkAkjtFpAXans8WytfFIYTbjn7UQAIWfrwsvQflVY4exXoB9P5aIibjMHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465792; c=relaxed/simple;
	bh=m9TqBGBpEevLyTAnFphiAPSm/XkVmteoIA9k2HD6k5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M6ATVZT3U+QynxY8Z7NV8eS7JHP1g2D8PYeik0ZG8KrmNREliW9yfBDYUY8nZFNpEeYpAzdq2qdjOR1dDSZYp50WgF9zJnU0TvHwRkvwF8UWXzNC8eRv0byOMk2gsvmZRU5nB1ZLaAzbgqX7zcfcOQ5S8p8EA4/A5qdmIrBP6GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ept80c0X; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ept80c0X"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785465789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7hP0hNqIw5p0SPsu1pOSxnBHfo6L+d4USvXj5DkOHmA=;
	b=Ept80c0XhCaUedcudQ0ObbgU/CfXJTN5Mr9AjI2b5/VgWFDVVtJ9Hw30421PPmmxAlf+9H
	/ikb++MhNfURTq+IjviFrNHaSjNaGDUK2QhhWVX6OQBaihXEItfMSLxQXUs9WR8MHLrFVQ
	m1PLPTgf2u8BVFcTmlUeW3/tun6J0fg=
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>
Subject: [PATCH 0/2] smb/server: fix memory leak bugs
Date: Fri, 31 Jul 2026 10:42:51 +0800
Message-ID: <20260731024253.148107-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

ZhangGuoDong (2):
  smb/server: fix memory leak in ksmbd_krb5_authenticate()
  smb/server: fix memory leak in ksmbd_login_user()

 fs/smb/server/auth.c             | 1 +
 fs/smb/server/mgmt/user_config.c | 1 +
 2 files changed, 2 insertions(+)

-- 
2.43.0

