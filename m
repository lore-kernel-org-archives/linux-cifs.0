Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEF81D416C
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 02:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782267413; cv=none; b=iavRHbDk5poGFuXl5EH/nqNY70zu2IfesPhCuU4ox8hzxaIpLvQbwLX6Mo42PD4fJnk81vOPJa0heeZmRuLiZxRPRtqDbz0R60iAYcIqtwRW9Kvj5Z/3Ve4g6LT9B++9yUkgQyxtAa8tpGbfej9quKPQT3bh4BPHUkBvfwWdvZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782267413; c=relaxed/simple;
	bh=+jBrI7lY8FrCzSmPojKFWoopy0IHRHjU22XOUX0S4VY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N4Y009vIcQ1MdLjmd/Gvbd7vbeLz+UCKf47GOd770eceWqrjYKhJTYGCV52xdxRifT6h6rizhTA28swNe8xAU2DyasLC4uXXspgD3tUcNKsOspvkDUW0rdOLPeZfQg5gxi6vA/rAVYPIEi0OFU24AlH9yhXZXkYzHMiEbXHIlC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z4947sbV; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z4947sbV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782267407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jr4Q0CB9EPYPSKb8NNK53bLcQawtRq/g8YFVzeO30zk=;
	b=Z4947sbV6cSL4hHaN8hVVDEUyL1Nb5ao1TXgielaukw4CvNk73HAH3FqYgxCb+Hejwn1IH
	dp53hK65knXnZlkXnHbfSmcNyWXRcCXeld8ze5rfjVJMMZMPNlCeOLRLYgiM8qhcoLqzC/
	yWSlZUP/YR6lzcWmI765g9K8jZi3UFI=
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
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 0/9] smb/client: fix mode 0 fallocate handling
Date: Wed, 24 Jun 2026 10:15:41 +0800
Message-ID: <20260624021550.1548952-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes since v1:
- Add patch 2 to preserve FSCTL_SET_SPARSE errors and only cache
  EOPNOTSUPP as missing sparse support.
- Update patch 6 to allow verified EOF-adjacent fallocate on non-sparse
  files.
- Add patch 7 to handle allocated ranges that overlap the requested
  fallocate range.
- Update patch 9 to limit zero-write emulation to small EOF-adjacent
  ranges on sparse files.

Link to v1:
https://lore.kernel.org/linux-cifs/20260623024619.1360127-1-huiwen.he@linux.dev

Huiwen He (9):
  smb/client: name the default fallocate mode
  smb/client: preserve errors from smb2_set_sparse()
  smb/client: handle smb2_set_sparse() failure in EOF-extending
    fallocate
  smb/client: handle smb2_set_sparse() failure in non-extending
    fallocate
  smb/client: do not account EOF extension as allocation
  smb/client: verify allocation after EOF-extending fallocate
  smb/client: handle overlapping allocated ranges in fallocate
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small sparse fallocate ranges at EOF

 fs/smb/client/inode.c     |  13 ++-
 fs/smb/client/smb2ops.c   | 181 ++++++++++++++++++++++++++++++--------
 fs/smb/client/smb2pdu.c   |  19 ++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 5 files changed, 182 insertions(+), 39 deletions(-)

-- 
2.43.0

