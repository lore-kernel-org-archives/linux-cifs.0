Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C53343D6A
	for <linux-cifs@vger.kernel.org>; Wed, 17 Dec 2025 13:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765979175; cv=none; b=htU3NfTzvJro/WF1Wb7RRyqWE4Y+s3QPy8UpKmLawhqej5vTqwFCBXiU9I/yceMno0v1RjP2jZYoKhuu1qeCcPIt6t8eBasVfxTr2STjfGgl37p+c+9XcyhZ3CpFBDCyaZ8IgtBlTyIIGYS2G4+Oq4stXZlzRhOCGEFSeYtJSgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765979175; c=relaxed/simple;
	bh=G8ZyxdO5qv7cpHM0jg6S04nx54kPD1tCcia48JUw8NM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kk97vHISfCyYNpDtTu+x2FcpgbVpvULKpegTUr95llDZdDdFGI4hgW4C4+qKW8h2DPsAjtZ+XYjGXqQsKXLR6JGItC1Ro+pyvPWjVGMTqBuI+qZo6r6kggZUhd+JHHh8xBNs3o9nZ9W/B6bkkvcO5LuhTKBYOIukFULAWQBTIcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v/cg1b91; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v/cg1b91"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765979170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w2Bl2dHTlSSGfqzI1ilqE+ej3OLAy7k6+K+EtcV4uQU=;
	b=v/cg1b91LOcH1Q4fut131T57noCXMyRX6yeo6h8w52hFqRLg4FDD9nmwJMKKjXzWh0Gadg
	IXoju0WHw9y1IDrn3a6Hj7BL3LSrmb10tG3vv6WtaY0DR3SlvfT5sMXPebtzDl6XilgojY
	VdcpaP/MjXPQU+LXvlEDl6NqlLfRwAg=
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
	senozhatsky@chromium.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH RFC cifs-utils 0/1] smbinfo: add notify subcommand
Date: Wed, 17 Dec 2025 21:44:55 +0800
Message-ID: <20251217134456.16735-1-chenxiaosong.chenxiaosong@linux.dev>
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

What would be an appropriate maximum value for the `data_len` field in `struct smb3_notify_info`?
Currently, I set `data_len` to `1000`, referring to the implementation in Samba's `smbclient` (see `cmd_notify()`).

ChenXiaoSong (1):
  smbinfo: add notify subcommand

 smbinfo     | 69 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 71 insertions(+)

-- 
2.43.0

