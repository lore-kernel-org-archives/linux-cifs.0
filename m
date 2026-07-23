Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E28E30DD22
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784776664; cv=none; b=SjuvBANLakpKqqjymbfndO4suNAr6mbYh9EXX7PnyKBXJMcqCVC3SNaQq5WyakuNqNAsDgL0xCpbRoAlwb96D4a0gErL5BxVMTfBYvEJeVUy6w+qgKGco2oLzvDBKz61GPyTGEwC3CJyWgARkHKPVJ1ojpAqoZu5zIBP3l/sR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784776664; c=relaxed/simple;
	bh=FRp8S6qzgANY4Oy352WxDj+8zsDwhYqOsjEGzpVQXPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j+EHIgFpAdypzuRTMjrRof8lGggkqokR4ya2thXe12oCsbTss7qwq0BP+naJ21e5pu042c4QInjTRgwSgHzhK1YYYTPCNBy0af6nP7eQz+UFYEBsc9t9UfCIkijnjBzCdbaLiejEbvTnYGVUw4HAeTyldwrDwqazQM5j/v2eyfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=tc3rXSOr; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="tc3rXSOr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784776658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EHHJd+VP49O10L2xwMaYM6af1lZGE7nZcjNIXTQ6JbM=;
	b=tc3rXSOrmw1zCt1o99VrRHX6zMxidyZ7NdE9RUoSb1e9CoQGI/ASRUO/3zz1NlXhl7xw0Z
	R8NB4z2xZtcAsFb2trmy0+PZKZj0QytHfaPt92x3PepCfEwpc6tc/r5qfGgR7GbBvoI95Q
	lPpP8lUy9+/UE17tpdL0p6kmxMh1TTKjlSXre+sodcuunQhh2cC9EoEgpG5/4W5WJCkBK2
	QNZ17c+QpcaI0Yy/4GpXF7KokWEUCPabfhqfjg7fGvCDrqNbIsSwC6UYdywwbG3SDFoLX2
	kdSCMaQWMqEkk0xLdng3uVlS18D3lLXyxY6m8P6eS0bXoCcokAaotKO8aCAA+g==
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
	metze@samba.org,
	gael.blivet@gmail.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH 00/11] smb/server: change notify support
Date: Thu, 23 Jul 2026 03:16:28 +0000
Message-ID: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
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

Sorry for taking such a long time to complete the ksmbd change notify feature.
Over the past few months, I have been busy with the birth of my daughter and
my PhD-related tasks, which left me with limited time to work on it.

Once Gaël updates his patch ("ksmbd: defer CHANGE_NOTIFY completion instead of STATUS_NOT_IMPLEMENTED"),
I will rebase my patchset on top of it.

To test this feature, the following patches need to be applied to cifs-utils and kernel smb client:
  - cifs-utils: https://chenxiaosong.com/lkml/cifs-utils-parse-notify
  - kernel smb client: https://chenxiaosong.com/lkml/cifs-improve-notify

The complete kernel client and server patches are also available at the following link:
https://chenxiaosong.com/repo/linux/ksmbd-change-notify

ChenXiaoSong (11):
  smb/server: add debug type for change notify
  smb/server: validate notify requests
  smb/server: support canceling notify requests
  smb/server: watch directories for changes
  smb/server: keep notify watches on file handles
  smb/server: save simple notify events
  smb/server: save old names for rename notify events
  smb/server: match rename notify events
  smb/server: encode notify events
  smb/server: send notify events to the client
  smb/server: break directory leases before sending notify events

 fs/smb/server/Kconfig     |    1 +
 fs/smb/server/Makefile    |    2 +-
 fs/smb/server/glob.h      |    3 +-
 fs/smb/server/notify.c    | 1011 +++++++++++++++++++++++++++++++++++++
 fs/smb/server/notify.h    |   24 +
 fs/smb/server/oplock.c    |   40 ++
 fs/smb/server/oplock.h    |    1 +
 fs/smb/server/server.c    |    2 +-
 fs/smb/server/smb2pdu.c   |   12 +-
 fs/smb/server/vfs_cache.c |    3 +
 fs/smb/server/vfs_cache.h |    4 +
 11 files changed, 1095 insertions(+), 8 deletions(-)
 create mode 100644 fs/smb/server/notify.c
 create mode 100644 fs/smb/server/notify.h

-- 
2.54.0

