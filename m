Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF5030E0F2
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 05:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769059518; cv=none; b=RkAsxz4Yxzq23YrjEp4g3dQDXL6mypEzGao1ez4WD58o6+ExGwBrhSz/NzArrWguLaqEOrdDMG0ZeeodAvraeW1ys/8F4zABnb/QZbZA9uG6aS+UE3WUnGqMBQ106JPkIDLTuJ9ry9zY1YEQqVwoB1LslLu9GtijIk0wK5IQLTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769059518; c=relaxed/simple;
	bh=6JT8MZVP1Ap5L2DNrTI1EKIcJtFWR+hvjlK5Y5fjPWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UGAE46otBbpIbw8vILFIChe5AzfhzQpJYheS823vI+MPsJpiMX8f2gKmG0nrxCsbU45ZWaHmOE5kSzdXytvuUXMqMDNuzypFxYwxNqt21M7uQ0feQDbiK1HuFBYg1+LERJ3/h6geNbqJJGomgZ/n1OnS+47HxXBOo9nXchPEm80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P3RdW3tR; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P3RdW3tR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7REIbDaCB1lEin5PXxOt4pSVBOjFuZZX55aIbl5xep4=;
	b=P3RdW3tR30IqtqOPaQDewvM6Z5aBFlU/6VRdTRdBro4iFHcBiKRdHi6AViEQJH6e5C5OYR
	NNtYGNbaUTh2HseyfCnegTHqeYWBUcBpM9HRLLCXszXRfLmJFkU4RtZU4LpWQruLv0IffQ
	3CkR1PQy2/ABIRrI+g6pN1JGdpEDinI=
From: chenxiaosong.chenxiaosong@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/7] smb/client: update SMB1 maperror, part 2
Date: Thu, 22 Jan 2026 13:23:55 +0800
Message-ID: <20260122052402.2209206-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

This is a preparation to improve the search speed of the SMB1 maperror.

The previous work is here:
part 1: https://lore.kernel.org/linux-cifs/20260121114912.2138032-1-chenxiaosong.chenxiaosong@linux.dev/

ChenXiaoSong (7):
  smb/client: map NT_STATUS_NOTIFY_ENUM_DIR
  smb/client: map NT_STATUS_BUFFER_OVERFLOW
  smb/client: map NT_STATUS_MORE_PROCESSING_REQUIRED
  smb/client: map NT_STATUS_PRIVILEGE_NOT_HELD
  smb/client: rename to NT_STATUS_SOME_NOT_MAPPED
  smb/client: rename to NT_ERROR_INVALID_DATATYPE
  smb/client: move NT_STATUS_MORE_ENTRIES

 fs/smb/client/nterr.c        |  3 ++-
 fs/smb/client/nterr.h        | 12 ++++++------
 fs/smb/client/smb1maperror.c |  4 ++++
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
2.43.0

