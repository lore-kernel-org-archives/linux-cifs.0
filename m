Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E9F2D320E
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 09:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770025798; cv=none; b=Q/QKQ+vvQy7nglXi2Sagwi63t5e6qhMUrDkIxR0tkvKeNgCMJvep5B6ZrsDBxZpbvCjXdwP3pBqwwy+Th/HfEdEl2CvdQXChzm4GfjPOTFkPWTWbraCx7hAOFZ7+7OZOeaIShDsaqGU2qZLAhOBZCqv7OeWszyM4SlG6+H0kkbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770025798; c=relaxed/simple;
	bh=cvVSftVXaxO6V20G+ZA72Dus+G3jzItOVnoLL2qzEow=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jhvHVzjTwkCwcKd9InrOYcswvzhpV8zw8Rkomd2+jQMvtVyImGYbN2M+87waE966TvURpVcG1OaM7gNjQvYh0WHTcA7hVECSxrUGl56W6eLeOSKYRE+Ue5swijIMoWW04VTsDmAKnTLMAgZi7pw3EOQYq+KkbboWL9Dz/wOfqsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wtS6Xak7; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wtS6Xak7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770025793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1UcJbyo+VwiCE1pxmnobpcPpBOQ1942PPTVETgmnvtg=;
	b=wtS6Xak7fO4sr7lFo/wrM5FTWVNoqJe1Ao43uQVHD4ehzTnZGbqAxxMqfzRDe9W/RYcpGX
	LpLxJfAu/4ZioMScn1CAHnw0msgJj4+ASSG6wG97U+qzHSetlrwslgOe3LSq+70d2LRPm3
	YHDnmQLMm9k0hJYpU/GeF2d6JlPQsX8=
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
	nspmangalore@gmail.com,
	henrique.carvalho@suse.com,
	meetakshisetiyaoss@gmail.com,
	ematsumiya@suse.de,
	pali@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH v3 0/1] smb/client: fix memory leaks
Date: Mon,  2 Feb 2026 09:49:05 +0000
Message-ID: <20260202094906.1933479-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>

v2->v3: rebased on mainline

v2: https://lore.kernel.org/linux-cifs/20260202082407.1881618-1-chenxiaosong.chenxiaosong@linux.dev/

The following patches from v2 have already been merged into cifs-2.6.git for-next:
  - smb/client: fix memory leak in smb2_open_file(): https://lore.kernel.org/linux-cifs/20260202082407.1881618-3-chenxiaosong.chenxiaosong@linux.dev/

For detailed information, please see the link: https://chenxiaosong.com/en/smb-buildbot.html (I will ensure this link is always accessible).

ChenXiaoSong (1):
  smb/client: fix memory leak in SendReceive()

 fs/smb/client/cifstransport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
2.52.0

