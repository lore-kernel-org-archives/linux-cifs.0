Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BAC2C1589
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 08:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760690861; cv=none; b=gpjvUgpOAy9fIGlTcAfDJzAWyqmFtZtZNp8AG6Xn+dQS4WCfECF1LRMneWcN/SAYDEA/c2Lyxm6Ix5ajNN5s5fnvDhtYN+VaFdbyOlJJx/B9JO8GmamWBWl07nxGguwK7Gua3FYTAgIcKj73OmHfB5PKo02zR1ezGgOqTHxGsag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760690861; c=relaxed/simple;
	bh=5JUMQ9DVUdQVwokzYhzDF5+4yHYW5WaZ6dKFzUPm9mU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q+TvXAfLnG7syaZoLrxYOtZZKwoHkWm4LqWsD59gzzH2HgJ1qAPUtTzQY6sADmuGPEYSbjYjTxh1iTqI0x6EDZCmpjsmwrakpuQTVe9Lo2aHpVqg0ki7iMMwjayUmcMFJKuWlrCnL2j+G+ym1jo+qeC0xd5FysOzi3NXcrjjxyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aZcVRk5c; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aZcVRk5c"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760690856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ITwxdB7PWXKfRZv2OTqV1MZgCdb/cKw8xN4yW0YqhFU=;
	b=aZcVRk5cWmXQOq+iUjpuHVqys2yCy80XkuWRcRdHAdQg9w1T3IOSgT7YrYVmp8bJfbtn2s
	hE+TjH0zh7mh/zgCMaMBjAsUfWM9++Hk6pKO4/zxZunwBWSnLBHfGiQB0ZySgTeDRUgsO5
	mQdpSnvLaVy50WIXsw5xuUaxLQkEhi0=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/6] smb/server: fix return values of smb2_0_server_cmds proc
Date: Fri, 17 Oct 2025 16:46:04 +0800
Message-ID: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

These functions should return error code when an error occurs,
then __process_request() will print the error messages.

ChenXiaoSong (6):
  smb/server: fix return value of smb2_read()
  smb/server: fix return value of smb2_notify()
  smb/server: fix return value of smb2_query_dir()
  smb/server: fix return value of smb2_ioctl()
  smb/server: fix return value of smb2_oplock_break()
  smb/server: update some misguided comment of smb2_0_server_cmds proc

 fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

-- 
2.43.0

