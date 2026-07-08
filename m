Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC52E3FE
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 02:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783479402; cv=none; b=opAPODFi1tMBM6nLXvkk/Elu4ewwruwAbppZ+6LOoju8AhyVl348uFFINGxYKJ3KyKdUcUvyJdqZq5CV4lN4S0R7UYYeHFM/88e1UaWRjKOgv0ouwGWbEwjF7EQdKPK2xeqzWtqkbiBvwrgasz+akk14Dqiny3bvyW4OTWR5N9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783479402; c=relaxed/simple;
	bh=NxVmbaonymZeufuLVKDyaRJaJexSiywGr9RITYLMwIc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FJytaZtKYSGYs6BHvfmH2EDSEesmUusWKiYg36vWtwzjqlzp0nBDJl7Cwkwt9JpRFzszMkXZ1au3EGyfgr3HViiKikw3ZPyrRklPT0D9lI5kTSRc1X488hmaRzVDGX2ivBpfd7SPWHUwV5OSR/yp73VWRR0M6A8q1mVXP45lve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=oXsHnXdY; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="oXsHnXdY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783479395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZjUvpbc76vi9xOu5Ah82x47XcKduXG8Lv598X6z5L+4=;
	b=oXsHnXdYufqG7QzzJMmowmslUerYJQ+n0e0632ZUuVE6oGeZJ6zywNx3x8xJ9OoNivtjE8
	32lxTultVpMKYt6SDNhD1iR8zXaUkVqNcs37+AAwcbnYuuSu46P1T8oUQdYZr64U8Mi+WX
	rr1pEVfk8yxjjO78tfVukhi+ARGYzQq1p/G+slAA9NXP7Z00dd++Q5wOWQ9JWMgyQYMm8Y
	1SGZ67XLCuyedip5fD956ETu6zQdOZSVgYZL3wFGgWlEb6aahF0pyWCHl7P/vPCw4VYt/e
	ORQYKFVYzYBqq4szs5IAna5dATb2dhDzy705UyEv/dZ3U9UGkxR//thxXUYeoQ==
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
Subject: [PATCH v2 0/3] smb/server: improve async interim response handling for compound requests
Date: Wed,  8 Jul 2026 02:56:12 +0000
Message-ID: <20260708025615.145390-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2: send compound prefix before async pending response,
        then send STATUS_PENDING as a standalone response.

v1: https://lore.kernel.org/linux-cifs/20260702110522.911411-1-chenxiaosong@chenxiaosong.com/

I am currently implementing the ksmbd change notify feature, and I have
encountered the following issue.

Before this patchset, no CREATE response:

  Windows client compound request:
    CREATE dir; CHANGE_NOTIFY, fid = compound fid

  Server response:
    CHANGE_NOTIFY STATUS_PENDING, AsyncId = N

After this patchset:

  Server response:
    CREATE dir SUCCESS, fid = X
    CHANGE_NOTIFY STATUS_PENDING, AsyncId = N

ChenXiaoSong (3):
  smb/server: send compound prefix before async pending response
  smb/server: introduce struct ksmbd_transport_write
  smb/server: use MSG_EOR for async interim response

 fs/smb/server/connection.c     | 31 +++++++++++++++++-----
 fs/smb/server/connection.h     | 15 ++++++++---
 fs/smb/server/smb2pdu.c        | 47 +++++++++++++++++++++++++++++++++-
 fs/smb/server/transport_rdma.c |  9 ++++---
 fs/smb/server/transport_tcp.c  | 13 +++++-----
 5 files changed, 95 insertions(+), 20 deletions(-)

-- 
2.54.0

