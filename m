Received: from mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C8B3A6B6F
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413580; cv=none; b=mPHwD+RJAb3TCFHIvthNwHAAKrI49LXSLdpAvqbrQFSIM3xcKjyjiVgTqaA86lHk1izWgv+Z2dZayFunm6cFErkVMumUzAoAvDqIEynKHnORm2PJX2tj1yxB6xSt1H6gTRGJ2QGZTGTF4ZxB16UzFIBMwdshqJbvImZNNCGQLAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413580; c=relaxed/simple;
	bh=8B6PfoVSeHVrcRRZpSZhOUQKdYL46WWBAZKJKllYgdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fl4riCuxEY1m5/cJ1JwkEko/4EIfvygtxa+sfW7UFHc1IEgZXdhSO9bsfmaTpmAu4mMKUBgUZSASsfDIeBu9Uqsi2LERxrH8ClDxvHdFcBO3mwjEDsw8ymK/SNZ69aSy744l5CYcIG28/NDjlV3icgfFl1nZYpGgGq5iEuJGaVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=afYEfXQe; arc=none smtp.client-ip=91.218.175.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="afYEfXQe"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8B6PfoVSeHVrcRRZpSZhOUQKdYL46WWBAZKJKllYgdc=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790413574; v=1; x=1791018374;
 b=afYEfXQen04vmuPrUfgKKvTd88SKUHDTgCULlrO3HV22hLGB3KBUDfAltwiJM580SVHBPKjL
 jECBlS+Jqfi7NOMyxqRQwVfDmbDcavDELw1Bz85hisSoAhNt2Jeg9FjsEMV4fLhL7ezSpZpD3qd
 8l6UJIkvob3ePHW8+7vCA0hhnNDUYH7w/wiSPrtD5ClXPnbpzZAXpsmgh0JM7i72PqedzB+sPdV
 hyx+1nN1+4LWs0koHUI8JIIGPOHIxGBHrsgqaNQz4tCX3aiM4tJ3lvG9bBfqYfNXbmjaBfqEuAy
 mF0fB1QBF6zbtjvtfp/7a73EHUY2+p24Im2kcTpQ/9bgA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f5919a77ba617eba;
	Sat, 26 Sep 2026 09:06:04 +0000
X-Mizu-Trace-ID: f5919a77ba617eba
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 00/12] smb/server: change notify support
Date: Sat, 26 Sep 2026 09:05:06 +0000
Message-ID: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

rfc v1 -> v1:
  - Patch #02: STATUS_INVALID_PARAMETER for CHANGE_NOTIFY on non-directory opens.
  - Patch #04: Do not reject a CompletionFilter if no mapped bits remain, keep the request pending.
  - Patch #04: Do not merge later CHANGE_NOTIFY filters into the existing watch.
  - Patch #04: Add a mapping for `FILE_NOTIFY_CHANGE_SIZE` in `ksmbd_notify_mapping`.
  - Patch #11: Give queued events to the oldest pending waiter first.
  - Patch #11: Use the current request's `OutputBufferLength` instead of `notify->max_buffer_size`.

rfc v1: https://lore.kernel.org/linux-cifs/20260723031644.312866-1-chenxiaosong@chenxiaosong.com/

TODO: stream-related notify.

ChenXiaoSong (12):
  smb/server: move change notify handling into notify.c
  smb/server: add more validation for change notify requests
  smb/server: add debug type for change notify
  smb/server: support non-recursive directory change watches
  smb/server: support recursive directory change watches
  smb/server: keep notify watches on file handles
  smb/server: save simple notify events
  smb/server: save old names for rename notify events
  smb/server: match rename notify events
  smb/server: encode notify events
  smb/server: send notify events to the client
  smb/server: break directory leases before sending notify events

 fs/smb/server/Kconfig     |    1 +
 fs/smb/server/Makefile    |    3 +-
 fs/smb/server/glob.h      |    3 +-
 fs/smb/server/notify.c    | 1193 +++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h    |   26 +
 fs/smb/server/oplock.c    |   40 ++
 fs/smb/server/oplock.h    |    1 +
 fs/smb/server/server.c    |    2 +-
 fs/smb/server/smb2pdu.c   |  112 +---
 fs/smb/server/vfs_cache.c |    3 +
 fs/smb/server/vfs_cache.h |    4 +
 11 files changed, 1278 insertions(+), 110 deletions(-)
 create mode 100644 fs/smb/server/notify.c
 create mode 100644 fs/smb/server/notify.h

-- 
2.55.0

