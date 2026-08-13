Received: from mta1.migadu.com (out-10.mta1.migadu.com [95.215.58.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EA1468C37
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627322; cv=none; b=ouZsma/g2T15it7fBKU0skm5Ex62VCD/oE+Dn7FKk8mzhxbxT6RKSlKO1OfzIALP7R17zww/QVIvPVMSleSRfQzpxjGMmdSyw8rqGEvaf4/jAI8zIsZrd0AHrkNJWLE5uAdOUCbGbDtQsK85NQjxZwteGJkV/PdRf7iTaYPJeA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627322; c=relaxed/simple;
	bh=NeFxzgL3NyXZ1VhmjcsxPaCnYo7WIPOTbMcpQyv1B+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iFL24tbYg/fzxIkCUIdpIxlTAeOltreh3P6TPSWtB2vWsfnZeS2eYbrprDWLgQsHKXX0+lUr9L3ZdLFE6uZRfjdL/COLJ88Gc8gEYa7oBr0M3ZhwWRcCA3Wf3GvAaGnuytg21njrj60wfaAniaceKcVqm+BGavkFRrppbxvwiU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DY6KsYJb; arc=none smtp.client-ip=95.215.58.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DY6KsYJb"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NeFxzgL3NyXZ1VhmjcsxPaCnYo7WIPOTbMcpQyv1B+4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786627318; v=1; x=1787232118;
 b=DY6KsYJbRfGbgZRkwkfI7NCbf6ZvpcGE5fAdQYt+CeIDvtjajKOWAt0sFrouFymxAzFGiwPQ
 daTKggNyYXBnbRq5/V4LzIKN7Ytg60efPR31zutOfUVRBU/qi2RL5QQ5QJ4J5ixQX9fS/N8VOak
 I9DP9c3m14mqSF8EuNVcRX6Q=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:9d9:8475:703:1f32:b67e)
	by smtp.migadu.com with ESMTPS id 6953e079861a1af1;
	Thu, 13 Aug 2026 13:21:58 +0000
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 0/2] smb/client: fix emulated insert range handling
Date: Thu, 13 Aug 2026 21:21:34 +0800
Message-ID: <20260813132136.366532-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

This series fixes two issues in the SMB3 FALLOC_FL_INSERT_RANGE
emulation.

Patch 1 fixes missing new EOF validation, which allowed RLIMIT_FSIZE to
be bypassed.

Patch 2 preserves hole semantics for inserted ranges, fixing xfstests
generic/064 against Samba and ksmbd.

In my Windows Server testing, aligned 64 KiB and 128 KiB insert ranges
were reported as holes, but generic/064 still fails because it uses
4 KiB inserts. Azure Files may not pass the test because it does not
support sparse files.

Thanks,
Huiwen

Huiwen He (2):
  smb/client: validate new EOF for insert range
  smb/client: mark file sparse before emulating insert range

 fs/smb/client/smb2ops.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

-- 
2.43.0

