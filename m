Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB5B165F1A
	for <linux-cifs@vger.kernel.org>; Sat,  8 Aug 2026 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786171381; cv=none; b=unhjFq1GAAag0VgJbESW/e8ZW0GI03CR2EzupUHgTM0COvFiFaNWEDpd8JHCvO2OghDlQmGwhsgS/3faA+syrqNZ4dMsXtUzVWdodJEva8LPBPfaXue8nWNfI4YZUv+yr7IbUXZ7/jjR7SczDY71IW2uq6erezWcwKVNnvAF+BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786171381; c=relaxed/simple;
	bh=eCA1iPJPM0GDqJ06NtWYC8MRhzuAjNmlSdfXltIqLZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gNIlavrgdNgsR+YySPkRegpNiEWk/hgny/3iOBYPoCVPfFOJ5M2o3MpRKWEpZJI+utKk8SoMwrm6xUS8xQTG7yPVPnZajpob02CB0VjgTzy5Ucpz3LnuZggmKoj97ZWCK9tZMLhsoXNRHWg5wYeqs93XpUYSWAfkbljCXcYaW8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=LCu9Lwrd; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="LCu9Lwrd"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786171374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VgUmEBnZhS3wM05AtIgydmFG1j4J4ZNuezVf3AuaHyY=;
	b=LCu9LwrdtTE0TSfQkF0EzzVXbdVKrmuhMLGTj/iiLsIkMoNyFizgW7W3q8AzM31CmuGkHn
	MVa2WvA0QM2IEPtqO5UGa6G7Og/aXk3++fJyusjV0A9Ij9irPX+vViftXRg16khPlxJwPA
	i/b4Ru5Y38LNYLlHKjCE4jCpiS1n9U7E9f229PUvbyEFRMnc6fEigQu+Up6xZWKcw5baPn
	1fuksYzm/47si1cVbUPrFoFlOXZSIKcbZTjZbHd2vaDFVbEXXHugegB/e8gS7IDP0a1uX5
	fzz4xQHIFbRRFOnKfeRnPdEvIDbQ5Sma7F4Qwbr4NxoqiP219t+TZfArYMasqQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 0/3] ksmbd: refactor smb2_notify() to a blocking wait
Date: Sat,  8 Aug 2026 06:41:37 +0000
Message-ID: <20260808064145.1002261-1-chenxiaosong@chenxiaosong.com>
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

v2->v3:
  - Add patch #01.
  - Patch #02 #03:
    - Rebase on ksmbd-for-next-next branch.
    - Split Gaël's patch into two patches for easier review.

The next version of my complete notify implementation may still take some time to modify,
so merging Gael's patch sooner would help avoid repeated rebasing.

Gael's v2: https://lore.kernel.org/linux-cifs/20260725102737.33616-1-g.blivet@me.com/
Gael's v1: https://lore.kernel.org/linux-cifs/20260724150528.1762-1-g.blivet@me.com/

ChenXiaoSong (1):
  smb/server: support compound fid in notify requests

Gael Blivet (2):
  ksmbd: temporarily remove interim-work change notify handling
  ksmbd: refactor smb2_notify() to a blocking wait

 fs/smb/server/ksmbd_work.c |   3 -
 fs/smb/server/ksmbd_work.h |   5 +-
 fs/smb/server/smb2pdu.c    | 305 ++++++-------------------------------
 fs/smb/server/vfs_cache.c  |  48 ------
 fs/smb/server/vfs_cache.h  |   6 -
 5 files changed, 47 insertions(+), 320 deletions(-)

-- 
2.54.0

