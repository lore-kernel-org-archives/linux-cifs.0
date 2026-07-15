Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14421318146
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123753; cv=none; b=Pqhb5rqsnrDzwpoDCkpwRd3VXaEOqIGg5yIns6gtuEszpIvKfwhcRNtu1JsvmIZMV+OOSGbj2jxgwiUkfexPRSGp99sjBt4CTAGsYM3/3EuFqHKA24Z4SMwifaV1osnnt/jYpJSM0o4zciWGuyyb5WnM/7NBDUxPXYimlZH4oYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123753; c=relaxed/simple;
	bh=ka5bniFsxRdkbtc0Y1i61uk9I8qBEKDxIPslAem6ARo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VOrOIe/5wFnsjI/jDjOb3DvRUWccHzAVMa1mFpIroVROxnWTjpA22AvOz7qw5Ddzn3w+BWrLo44n1waK8VcZS451YfapVv2zyfA+vZgGfqr2ywbXXXUuqpIk3gdvahButc6JgpWOy/MlH30m4beqlflf+m14dr/weN8KZwzdH9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=d1vQZyEx; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="d1vQZyEx"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784123747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VRbku3LZJM9SV7vDEzqV6bnrAQ65k18SBoAr7YIsdgU=;
	b=d1vQZyExbUzuxgY77HKHD5DDdzV7VU3FxnKuR2rUQcZc9gXQrfcjD6DFs064+tAntGsxrr
	BhGdkshO10tfbXQqkX3WrDYxi/3BKism4eHn904UvsksFIaZczykw90W7ErK16g4F6+Pgf
	Are6Dpckg/bdOKTEwnCG/9QRHdKBanX/IfPs58KyXRE/Ax1hB1w0bCfABFLOnDwgC6ndF2
	w0QTTcy9UTvEqz6wurza15L4UtnR0UXcIAKKYBYRwG2GU2Loh30j7crrtt9ZSWE9Qa8YnI
	wcVYCbiw+WMhx2OF2BLdoK1Na0+80/xqUF7jWaENtfbLyxseEtFIhSzAF1iR5Q==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/3] smb/server: fix some bugs in preparation for change notify support
Date: Wed, 15 Jul 2026 13:55:10 +0000
Message-ID: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I have implemented the ksmbd change notify feature, please see the following GitHub link (some minor changes are also needed):
https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/

However, to make this feature work properly, some pre-existing bugs need to be fixed first.

ChenXiaoSong (3):
  smb/server: fix signing when a response uses more than one iov
  smb/server: cancel async requests when closing connection
  smb/server: stop new async work when closing connection

 fs/smb/server/connection.c | 21 +++++++++++
 fs/smb/server/smb2pdu.c    | 76 ++++++++++++++++++++++++++------------
 2 files changed, 74 insertions(+), 23 deletions(-)

-- 
2.54.0

