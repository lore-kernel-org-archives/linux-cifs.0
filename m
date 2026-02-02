Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251CA3542C1
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 08:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770020717; cv=none; b=PPWUDnbLSBSwOVV6g9geL31U//2ut2JM0lhHLAx5dY8PPljpO+tB8dXGolY9GEkt/NHIslV6Ev77jcGNWFHB0+omuKIqH7eOf4biDQKjbbUkrJR5X3b19rzu/Je6clTjOIEa5FQuZP1YefTpCuoVMH84Lzl4ENN7sLcKOwCzY6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770020717; c=relaxed/simple;
	bh=XLhXMq+fYvC04UKrWEvN+sZRb7LDiymZB8SjpIvgAQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o85oEOLy9ZR7Hazfq53Zpci1XLiIHtF+CcWcwcHPeiy2sGIXT1llEifzsn3jqXkHVZD6hPWvm0/RDT0uaVmfbMeLOV6JPC0zwbxk7ZglH4shjYirzJoyVwucA9gUuQ+P165pawG/LhZxN/+KJu0WGy+hQacijxgvZtHrjqwJ0OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZudD5ciY; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZudD5ciY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770020706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RoJbk1PCG8vfncTd+6FHt4ez5CMGOem1FyamDymaI6A=;
	b=ZudD5ciYrFnZVSGcP0l3viZXud+5T3Boc3ErG34e/4rJ309rrPZa1Y8+lk5aZBpdGkDNz2
	JyTCAmSCGx9b3s8Te01okks/8tpFLxXukq4a/RD9hC8wT+2Ae4oY/SRDHI2aTbae9tLSJ8
	pzKNQ7xshDve7IrcOZUoG2dEv1cxsCg=
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/2] smb/client: fix memory leaks
Date: Mon,  2 Feb 2026 08:24:05 +0000
Message-ID: <20260202082407.1881618-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2:
  - Add "Reported-by: Paulo Alcantara <pc@manguebit.org>"
  - Patch #02
    - Add "Reviewed-by: Pali Rohár <pali@kernel.org>"
    - Update the commit message description

Steve, the patch #02 has already been merged into cifs-2.6.git for-next.
Please replace it with the updated version.

For detailed information, please see the link: https://chenxiaosong.com/en/smb-buildbot.html (I will ensure this link is always accessible).

v1:
  - smb/client: fix memory leak in SendReceive(): https://lore.kernel.org/linux-cifs/20260202064928.1879323-1-chenxiaosong.chenxiaosong@linux.dev/
  - smb/client: fix memory leak in smb2_open_file(): https://lore.kernel.org/linux-cifs/20260201081017.998628-1-chenxiaosong.chenxiaosong@linux.dev/

ChenXiaoSong (2):
  smb/client: fix memory leak in SendReceive()
  smb/client: fix memory leak in smb2_open_file()

 fs/smb/client/smb1transport.c | 4 +++-
 fs/smb/client/smb2file.c      | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.52.0

