Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D0727E7C1
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748362430; cv=none; b=ndigG4Fio0ZSk71o783W+LUO8UpbGir2SPkv9W6XyRBZR7WAcOirvokZrCTKYMhy714ZsBErnlRjSuUDhfGxIF2npRuwYo1q3tMHxNk2l7ypwDuKm9HNewykTQXBYzYRFXiDODPpdRx9CvOolgDwnG2YMxo5qd5mWNusq4M0RJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748362430; c=relaxed/simple;
	bh=Pyxx/prI01bKffhkHvg0g83FWFro3cCMyET5SsNXUKs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uAaiE0Kt4IRWJViAQGASYS8wD3eq4/aL/0Vi4wIOuZFH5rAv6tZMwTAibcVhX4tnloc53pMQmqh6dOI22Ch9cZ5fPvVU6E969CGYue3LrVIHqpDkfMsOtE00dTrl5kLbPaDBWUnIBpXRb+dLlW3T67AwmOv9InwZxQ2YOEX2m9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=TqTbTuOz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TqTbTuOz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=snINRHgzR0pARdE9yaIqqTcIiJjdbYkKTgM2gMLU5lI=; b=TqTbTuOzse474/dRSv9yUQz4Mw
	KPkEG3QL5tBilLqOj8IWwNyyGNPVMtNsY/NWgFQmrUANgd5iNzpkWzEYcipeUeYsM/Xrr8KJZcenI
	rJk+NWrPdLrGzIDI+ee3cNUrwPQCXByKi9NBNa2trps6wWlIfBrgXNaOB00LJBMgwgZtwsU6OFe/6
	ev7KZ/H4i19DAgejCr5wuMJh88B7HV9zyrUoefZCZ9wJbRbnZ5+5joBnX9KLpc9N15hqQYw7Oabna
	gfD9rL1fmr3hOxtfVGf4ezSf4xNtn7K2VX7G6ekk1ZiYAvYfs4lNhstgG07fVhc9XIB3uJZMkfkJg
	qiFjXBWaImnvh9ad9BGqxYXjAAzI4IDDcjxbQrasoJbHw6KB8egI1TOEsaZJBzzDAm0pQmdVDdxfW
	+gtSKBddYCWdCc/dQNQAgZcc1ih/63jyxSEB/7BmPL+ZC4Gw47ZaCHGA+XIr0aT4zW2JlFwPVCfV9
	KMML3/rCjT9O8dQMUJO0ip/Q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uJwvr-007VkJ-0B;
	Tue, 27 May 2025 16:13:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH 0/5] smb:common: introduce and use common smb_direct headers (step1)
Date: Tue, 27 May 2025 18:12:57 +0200
Message-Id: <cover.1748362221.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

in preparation of a having a common smb_direct layer I started
to move things into common header files.

I'll work on this the next few months in order to
unify the in kernel client and server layers
and expose the result to userspace too.
So that Samba can also use it.

Stefan Metzmacher (5):
  smb: common: split out smb_direct related header files
  smb: client: make use of common smb_direct headers
  smb: common: add smb_direct_buffer_descriptor_v1
  smb: client: make use of common smb_direct_buffer_descriptor_v1
  smb: server: make use of common smb_direct_buffer_descriptor_v1

 fs/smb/client/smb2pdu.c                   | 16 +++----
 fs/smb/client/smbdirect.c                 | 22 ++++-----
 fs/smb/client/smbdirect.h                 | 50 +------------------
 fs/smb/common/smb_direct/smb_direct.h     | 11 +++++
 fs/smb/common/smb_direct/smb_direct_pdu.h | 58 +++++++++++++++++++++++
 fs/smb/server/connection.c                |  4 +-
 fs/smb/server/connection.h                |  8 ++--
 fs/smb/server/smb2pdu.c                   | 10 ++--
 fs/smb/server/smb2pdu.h                   |  8 +---
 fs/smb/server/transport_rdma.c            |  6 +--
 fs/smb/server/transport_rdma.h            | 41 ----------------
 11 files changed, 106 insertions(+), 128 deletions(-)
 create mode 100644 fs/smb/common/smb_direct/smb_direct.h
 create mode 100644 fs/smb/common/smb_direct/smb_direct_pdu.h

-- 
2.34.1

