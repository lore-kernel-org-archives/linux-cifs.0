Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C021DA23
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 01:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789954907; cv=none; b=piBmHMh5cqy7GfjysWd7uTtKz7PtDhro/yqFJ1v9hh/IWSuhhZ/AN6jK21U7dQ0XosWX9SRaEDTDN5kY4mNQX2dZ03tGbhy1zAWoRvnDDKC9J4nHdpl0cy8FL5GLlUnmclEPiIei21pnDjCfDS9BTyp3RU9GdvKE+qf4fhlJjhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789954907; c=relaxed/simple;
	bh=+xtw18o8hfjwv+BoHcX3t33cELGJmJKvE4gjwmFZpaM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V+a3tTW2dh9OlkmlgSVt7WVDbEVZKWGqGOnysQ9WpgGSSnsETOyWndPQVYS/1LYIxbewIrS3Gdg1UddJsre722cvVG94DZpGZTpIwArRINYM/fEiVmwmzrXU4DShCf+TxhFHVffNPGAaiT81uGFj6xojc8n3Y8qiJtgPMTuenEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M9M5bJ3d; arc=none smtp.client-ip=91.218.175.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M9M5bJ3d"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+xtw18o8hfjwv+BoHcX3t33cELGJmJKvE4gjwmFZpaM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789954903; v=1; x=1790559703;
 b=M9M5bJ3dOshYlyprZCZ0rIVObpsP3FDKKSqFItosdNYAPSBamtUkAN6Tb1Iw5T4/K+AKDVax
 J2AmUdgZ0Z5YUzfK6Z9BbDnTheIiM9YmkUrwDScdkG4Lc5tXzs1j0br7vvdjjAW6GgJ1Hl3I4kW
 V3jRdDaXu2v3HV/VTcvj+ZsM=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e6ac0ae9d346dac8;
	Mon, 21 Sep 2026 01:41:33 +0000
X-Mizu-Trace-ID: e6ac0ae9d346dac8
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 0/3] smb: update POSIX extension specification references
Date: Mon, 21 Sep 2026 09:41:26 +0800
Message-ID: <20260921014130.147229-1-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2: Patch #03: update FS_POSIX_INFORMATION reference.

v1: https://lore.kernel.org/linux-cifs/20260920055653.114794-1-zhang.guodong@linux.dev/

ZhangGuoDong (3):
  smb/server: update POSIX extension specification references
  smb/client: update POSIX extension specification references
  smb/common: update POSIX extension specification references

 fs/smb/client/smb2pdu.h | 10 +++++++---
 fs/smb/common/fscc.h    |  5 ++---
 fs/smb/server/smb2pdu.h | 16 +++++++---------
 3 files changed, 16 insertions(+), 15 deletions(-)

-- 
2.55.0

