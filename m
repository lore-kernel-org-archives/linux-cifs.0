Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8433943078B
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 16:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527999; cv=none; b=o1IFi8cs0CFZ8yN9S6uvHqa5rV1lzrgdERntVUKcMw/12WahublNX0ptPwIM58LLqGWBxkRsB/eFZSHbzAsjLU42xFyCQEIIed81nkDlJJxIyRreVp24xKCIClb7+NsbMXT4qVlK2jdIudgknmjCXYFqMC260B5Xlxna250MNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527999; c=relaxed/simple;
	bh=3bVwJj4DTrb8dU44YG1c6iu9D/u6DaEFzyfdxZEj4O0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y41vzqya8qb+kUjOXucEvYh27iPbWUybK0H0Ycidjs5/ymJQBghkMeMmfGIIuwNu9X76bTTxBMJbndQkYHfxYX952thvuRazExgLBJLEgtxZdtHLngNNT91emDOo8UMeUWfW7H/OGyhb0w2KoIfOceD3vhpxZYlvIArlL2BFG4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=k41sMLxd; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="k41sMLxd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783527994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R2ogs1KqJVrtYepUi5WQVinxtDeS0aYLDQTekf5tbSU=;
	b=k41sMLxdlMEFxA+1BJ+vZRyzJYRjUbklePWc0sDDLnmI5Ayud2C9rwACN0TuXMNLM63ez7
	RSt8OyYQiA1odY5jawqxY3DtwIayrXr9JHu9fY6L3xMVgtjLgPchkCN8igzpt6to7ZsKth
	L+y5dKjrdAlAdb11I1p5UfIBUa//TygM/1dPO198toyb6/FFFIPfspuEdeIOypd8Vqrlfx
	LTlQ0F0AZpG7BG+BK+tpYvAqqGRF3jOYqahkBgKsfbGHI4mnNlDkILpo2MbwKrjioCzGbd
	vS6ZsWz/rED1bLiMbKvEvCRunKyJonpDWk5buyU5W3GEV8GP5ultCvOiO2ZGsg==
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
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 0/3] smb/client: fix incorrect nlink returned by fstat()
Date: Wed,  8 Jul 2026 16:25:49 +0000
Message-ID: <20260708162552.209468-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v3->v4:
  - Add patch #01 #02
  - Patch #03: add cf_flags to struct cifs_open_info_data

v3: https://lore.kernel.org/linux-cifs/20260701105635.794615-2-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (3):
  smb/client: use stack-allocated smb2_file_all_info in
    smb3_query_mf_symlink()
  smb/client: pass cifs_open_info_data to SMB2_open()
  smb/client: fix incorrect nlink returned by fstat()

 fs/smb/client/cifsglob.h  |  1 +
 fs/smb/client/inode.c     |  1 +
 fs/smb/client/link.c      | 15 +++------------
 fs/smb/client/smb2file.c  | 19 ++++++++-----------
 fs/smb/client/smb2pdu.c   | 26 ++++++++++++++------------
 fs/smb/client/smb2proto.h |  2 +-
 6 files changed, 28 insertions(+), 36 deletions(-)

-- 
2.54.0

