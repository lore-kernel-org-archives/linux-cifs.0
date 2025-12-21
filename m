Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CD4249EB
	for <linux-cifs@vger.kernel.org>; Sun, 21 Dec 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766330632; cv=none; b=Oj5NkiKdOyFBcEwdo6aYFS409cFHbScm1yKDkpjOJjlrBWMFR4OGiQSRAaS3EJZS34OEHiSP9ES+LzM58W0bLGcJI32sQ1o0VzXq5kZ38T+OmNdCEy1FwPdPsa1l0SZHSm9cOBgd9ENNhIOzc4YSl90DMPENg1/kQHdVvyJMS0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766330632; c=relaxed/simple;
	bh=xue1vwmyeNU5eCphuVqX2DLp15V0doeCJ8XcZIwhvtE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BUM76yMkYeoFoNiLyOmucJpWEPsInsCfy59k6Uk6WeF/bgfGiuqCth/Q9oUnRlDoUTPLXM06xf/XeKIZ0NJHu4W1rQyzbY7f0M/3gaYPqKiYMik/rJKEO1CK1s7T34xIViv6RIletoaMt2rS1nCshif7vsH73G1FfbMmMzuvfsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k/ug6oE7; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k/ug6oE7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766330624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0sfjisTuBGNcAyl/mZ39j4OTECN9Lo34hWli/lEpY5I=;
	b=k/ug6oE7aeBH+yJOqmNZ9HDB2826eI00UxwYPsMtyD1Y7ydPe2dn3MBvY5GaP+lXipskr4
	T6Wp+LZdpStkwW0kHmLhAh399WGFpG8WxjFYu1TROrDWd8Aw0sAthfVF4szKIuujqTlnqw
	GRBybnf1croPvLmNzqghubjpj5JdQwg=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH cifs-utils v2 0/1] smbinfo: add notify subcommand
Date: Sun, 21 Dec 2025 23:22:15 +0800
Message-ID: <20251221152216.363567-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

If you have any better ideas, please let me know.

v1: https://lore.kernel.org/linux-cifs/20251217134456.16735-1-chenxiaosong.chenxiaosong@linux.dev/T/#t
v1->v2:
  - `watch_tree`: False -> True
  - Continuously calls `ioctl()` until interrupted by `Ctrl+C`

ChenXiaoSong (1):
  smbinfo: add notify subcommand

 smbinfo     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 77 insertions(+)

-- 
2.43.0

