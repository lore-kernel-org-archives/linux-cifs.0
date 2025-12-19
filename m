Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40951F4606
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 23:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188543; cv=none; b=P0CAHuetlwsTNUKo3waibvKqunjSWjlXOdPG9gKTb3RnH/rzzJnaHY1cd9DFU1ZaVqbnHFCMvv7Ip5pO+GtRecxgqdAZ9HAqmBpZgxX4lvHLWjxGGCXbza7YypvY7d55oKtT3CnBhIVHLkwX1ZL40yDKZi2qDhy4H176lKan1Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188543; c=relaxed/simple;
	bh=jyGW1G08uZquTfSh593jhKl+T0wYPAZ6k7gQd0s4z/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ScJach1T4SUzHscQNFqmSfvHeUMeMFzAHjvKBY1K8/AltB2g3zsaOotUlcjAdHFL8KRod0yRSPNHm5AfZ+wg/5NWfUZq8DRRxg44rfN+YplQgkuqe9j5VeRP9AzGV+9z65x7hu6cmxSj1bNmT8GGdgrA+EXkZtka0PlLd1xbCcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MGBYMTba; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MGBYMTba"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766188534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1lwqMyaAyYgo0+aPJ3EYitJl6NKEHZ0sLLvfWjhBEs8=;
	b=MGBYMTbaCY4+3fY1ot07VLd8nagl/x8qjHGaWhADzg/I7iFF4bEASLz+RqseoRh0tfWZgP
	z53KR0mR8K/HM+xjGJ3GMXVwxVA9u69qOQtO2AzJCBmEykSX59hqTCZ9sZNOlpbw1wkZiI
	867jaClY/+qK5ZfUKZiRDstuWXR0Kqw=
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
Subject: [PATCH RFC v3 0/3] smb: fix minimum PDU size
Date: Sat, 20 Dec 2025 07:54:16 +0800
Message-ID: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

If my understanding is incorrect, please let me know.

v1: https://lore.kernel.org/all/20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev/
v1->v3:
  - Create patch #0001 #0003
  - Patch #0002: update value of SMB2_MIN_SUPPORTED_PDU_SIZE

v2: https://lore.kernel.org/linux-cifs/20251219170057.337496-1-chenxiaosong.chenxiaosong@linux.dev/
v2->v3:
  - Patch #0002: fix typo in commit message (smb_pdu -> smb2_pdu)

ChenXiaoSong (3):
  smb/server: fix minimum SMB1 PDU size
  smb/server: fix minimum SMB2 PDU size
  smb: use sizeof() to get __SMB2_HEADER_STRUCTURE_SIZE

 fs/smb/common/smb1pdu.h    | 5 +++++
 fs/smb/common/smb2pdu.h    | 8 ++++----
 fs/smb/server/connection.c | 8 ++++----
 3 files changed, 13 insertions(+), 8 deletions(-)

-- 
2.43.0

