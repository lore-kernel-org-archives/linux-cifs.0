Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0635948165E
	for <linux-cifs@vger.kernel.org>; Wed, 22 Jul 2026 08:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710470; cv=none; b=omIjVyUVjTrfvlMM4a1gOPDEzMJgyyhCs5bjLuBBpTPcFv42xh6iZodBFjxe58zVYGhqdZz2192CB8ldmYXb32Fbd5joL3lPpwuaRTm8vU+groLktFho3lLhUlQqTD1tMsg9dXyg9OryISCBqid6IYcrUk/i65xwqGDOz6RxGu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710470; c=relaxed/simple;
	bh=1zjqtwIKa2dNoaIM+bGn2BAvcQrIIEjFf1keDxCULVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bekGYPWg92oGBEP8x/7thS0M1eFyLef2rsMFrGE+9lFS+KZljdSxVUHoeLQf3EyYh+5sd9bdy/YewW+onm5/Y2WiK10G1o9H6yDGh98dKSdyswo9RtMSg8kCliNFHNvzsdCF49KIt11eUzehwKX+7zeNWBi0Aql7yHJnXF6JQPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D3eBCjnp; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D3eBCjnp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784710465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SXeXmPJ0JkP6tKxFJQPPM3A1bI/0/RAUc8gBikPKa+c=;
	b=D3eBCjnpec59D95drrslxxT8ztbd2mfmEcFK2HtrLmrsbhfzGBg7vfs8nL/knemQFDCSaQ
	u/RhhsiY2Ha7EZ3ZhrJW5JQPuvgmJX4obYBAPQP9tFxj26vE7s0dhlFepIjWzVDT8G+6Ob
	Tvsv6t5RUq/DURFFTTaWFrYx8Svdeeg=
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
Subject: [PATCH 0/2] smb/client: handle compression flags through fileattr
Date: Wed, 22 Jul 2026 16:53:31 +0800
Message-ID: <20260722085333.86217-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

This series moves CIFS compression flag updates to the generic VFS
fileattr path.

- Patch1 implements ->fileattr_set for CIFS compression flags so
  FS_IOC_SETFLAGS uses the generic VFS permission and serialization checks.

- Patch 2 removes the old FS_IOC_GETFLAGS and FS_IOC_SETFLAGS
  handlers from cifs_ioctl(), which are no longer reachable.

Thanks,
Huiwen

Huiwen He (2):
  smb/client: implement fileattr_set for compression flags
  smb/client: remove unused file flags ioctl handlers

 fs/smb/client/cifsfs.c |   6 +-
 fs/smb/client/cifsfs.h |   2 +
 fs/smb/client/ioctl.c  | 165 ++++++++++++++++++-----------------------
 3 files changed, 79 insertions(+), 94 deletions(-)

-- 
2.43.0

