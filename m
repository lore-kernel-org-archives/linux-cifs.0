Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B92D2DC773
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 04:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764824394; cv=none; b=Ki4hStge7U/T8ZclaJ3VDRoAJfF9+RH3pU+tzu/x/zNOc5jGnTKDgRCYCWVoqKLTucF6YYdgU8IdyGuJc5pln1JdoRM6AEsKve+A63ykUwWAIMxBy3NnY6IKoiezL57mKSl9cWAcZEwbv1F9TNU1sTCNDy0bViB90eH1uBIvf1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764824394; c=relaxed/simple;
	bh=eGlL4hhad/P7GhBW7jMb8FxqINXXDjelgXLbpA4Oz2I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ASEQUqMUU6NOJ6nhdNtPizu0zucZ49mhHrgdMpbIMI9M8RGDO/ut3MIOfkDkFT+AatQJbR0Lj3julING/Q8NKbfFDUAJe+IJExwAWro62DJda/eVctUlzAI68NxhoXsVVFgDcn/i5N7/E8dUlE0UNcRTXP98QIpverXH66gNXks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P/7cQ/n8; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P/7cQ/n8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764824381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=f89bclOKoWsmdxvcdH10YkgnB1JmuzLKIEn/nm8RMUc=;
	b=P/7cQ/n8t2hmongEuCfP78hZYaxaoGeh8Ne3zBuvCLqDyNkLzDhu8iEvPOfK7lY25VBh08
	QsVSa6dgmjPXjWymWKu/t2/LuVqFFWN/dH5ZH9HNEqYRd4HKFRb7l63zZaYGCTZm16Xt0D
	lsw7nY+5Tknz5GlX4MnKOvvNiYRgEaE=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxiaosong@chenxiaosong.com,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 00/10] smb: improve search speed of SMB2 maperror
Date: Thu,  4 Dec 2025 12:58:08 +0800
Message-ID: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Before applying this patchset, when searching for the last element of
smb2_error_map_table array and calling smb2_print_status(),
3480 comparisons are needed.

After applying this patchset, only 10 comparisons are required.

ChenXiaoSong (10):
  smb/client: reduce loop count in map_smb2_to_linux_error() by half
  smb/client: remove unused elements from smb2_error_map_table array
  smb: add two elements to smb2_error_map_table array
  smb/client: sort smb2_error_map_table array
  smb/client: use bsearch() to find target status code
  smb/client: introduce smb2_get_err_map()
  smb/client: introduce smb2maperror KUnit tests
  smb/server: rename include guard in smb_common.h
  smb: create common/common.h and common/common.c
  smb: move client/smb2maperror.c to common/

 fs/smb/Kconfig                           |  13 ++
 fs/smb/client/Makefile                   |   2 +-
 fs/smb/client/smb2misc.c                 |  44 ++++++
 fs/smb/client/smbencrypt.c               |   2 +-
 fs/smb/common/Makefile                   |   3 +-
 fs/smb/common/cifs_md4.c                 |   5 +-
 fs/smb/common/common.c                   |  30 ++++
 fs/smb/common/{md4.h => common.h}        |  27 +++-
 fs/smb/{client => common}/smb2maperror.c | 173 ++++++++++++++---------
 fs/smb/common/smb2status.h               |   5 +-
 fs/smb/server/smb2pdu.c                  |   2 +-
 fs/smb/server/smb_common.h               |   6 +-
 12 files changed, 227 insertions(+), 85 deletions(-)
 create mode 100644 fs/smb/common/common.c
 rename fs/smb/common/{md4.h => common.h} (60%)
 rename fs/smb/{client => common}/smb2maperror.c (97%)

-- 
2.43.0

