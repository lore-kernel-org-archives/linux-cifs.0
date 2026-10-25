Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.127
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917312;
	b=EoKHXx/z40GHagn9PWKzIe+TPvia/S3azjvPEOurPViYPOxMPYmAnQJS1G8V0rrhgHn8
	 uRZdbT5tOyRMnQQ1+n01KmEpQ9Cmaz8g9MnuPHnkUFXvvWqhtYrMSHDucdNhOble2KFAi
	 ZifSRJVtctwdb1qO6x7MeiBozb2u0z25CrYs1KOm4bZ9Rm2Pw//4NZgWuAtviriigIAbe
	 x6ZoeUD4V8Z6mZgP0uJztzVbqaWFBdkonEphsXG6LdBbL+mCXkUrFD0r5h8mwmxhgLFy0
	 7PxgX0OBXHsKZ7ScUam8vWcGrF240y+EzH+xw0f5NCdi7fw/Jz7KXiwVMBaChbHA8kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917312;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3nr6bPxei2fSs3vE8kAXEq9e/Pq3RIBdWB9qfKr2oPw=;
	b=PvCEjSgbFvV6yxUiTTNzA3SwcWQaR73hmf3QQ67Yz7JjlWnBE5wmqft/kuWypi4FsEj+
	 5Ovr9qzfSzNQJE3X/eOM78NwOq83JCZWXCSTQZiqxYd8zqfQ3N1bc16NUuqcuCwFCXtZd
	 KuPrLXcv0lfBAjoU+q0Mvlezaa8NRU2LjZ2fULcNR6Q96XkShnngB6GQKk4nnCoVk3L1L
	 lpk7uD/hLpg0lXYB6pWvSA7RVujaqtPFoqqOD+IR9xrsz1Lzsv8+xUP9aD39a3GSOtr8f
	 BLElM+ia94Cw5JfiS27s7EJidz30Ve2GV3166PGzh9wS7hWyRn0OMqCIkk9iN6vmRNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=BaJXBT6N;
	arc=none smtp.remote-ip=95.215.58.127
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE29606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 08:35:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AE29606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=BaJXBT6N
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=T3XACV93ZYc5nr+mva+6S7q6fPbcaQTVKBArdnqBJtc=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792917308; v=1; x=1793522108;
 b=BaJXBT6NsfuxPT9RzefaqwN4uLy6rvax55smPraF+UGDFuzLei1yDqB01iJuj+RvDwscDAFC
 NVD38VeQnI+ELOk5EY3eyM39IvOWGkWWGRQJJntkngmjZjyLcf40F7WIkshga90ugypwfxHFzX3
 FxlNffuw7EYsD6Gp8Mm9kKrhAkWi2cKtOSOjawOFnLUlwplcNrsLk2CQK5Qp22RJhj66V4qhZ8X
 YK/CHjFj3+RX+uSbPFEz1GQKJO+m+neGOR7vtdDsTyn5BmLnliCK5zcbwUBm1/QI+/OwIce8gyB
 7ByqVS1eVELVsM6eHH4WxeY3wBQGBSEB2tKF3h3RmxWXg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ac4fae4eb3cd5904;
	Sun, 25 Oct 2026 08:35:07 +0000
X-Mizu-Trace-ID: ac4fae4eb3cd5904
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 00/13] smb/server: change notify support
Date: Sun, 25 Oct 2026 08:34:37 +0000
Message-ID: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2:
- Patch #04 #07: fix LAST_WRITE and LAST_ACCESS notify event mappings.
- Patch #04 #08 #09 #11 #12: limit notify event memory per open.
- Add patch #13: support change notify for named streams.

v1: https://lore.kernel.org/linux-cifs/20260926090518.78547-1-chenxiaosong@chenxiaosong.com/

TODO: The KUnit test cases are still being modified.

To test this feature, the following patches need to be applied to cifs-utils and kernel smb client:
  - cifs-utils: https://chenxiaosong.com/lkml/cifs-utils-parse-notify
  - kernel smb client: https://chenxiaosong.com/lkml/cifs-improve-notify

The complete kernel client and server patches are also available at the following link:
https://chenxiaosong.com/repo/linux/ksmbd-change-notify

ChenXiaoSong (13):
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
  smb/server: support change notify for named streams

 fs/smb/server/Kconfig     |    1 +
 fs/smb/server/Makefile    |    3 +-
 fs/smb/server/glob.h      |    3 +-
 fs/smb/server/notify.c    | 1415 +++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h    |   80 +++
 fs/smb/server/oplock.c    |   40 ++
 fs/smb/server/oplock.h    |    1 +
 fs/smb/server/server.c    |    2 +-
 fs/smb/server/smb2pdu.c   |  112 +--
 fs/smb/server/vfs.c       |   67 +-
 fs/smb/server/vfs_cache.c |    3 +
 fs/smb/server/vfs_cache.h |    4 +
 12 files changed, 1614 insertions(+), 117 deletions(-)
 create mode 100644 fs/smb/server/notify.c
 create mode 100644 fs/smb/server/notify.h

-- 
2.55.0

