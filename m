Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F713234
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748448117; cv=none; b=NUKui70KUB9gOmo5cuPnOz37sHpR6uZIREuBWcKVyuwJQdJgCFtMY17LYspk8o9tpNIRePhNZqv+gPziChGVJ1ZaXYlYUgqozAWMB9tNjysosQ28kpl3+Zp0UgQ7h0z/3YzdjAQn3ycwj+WBK1+T09Q1X0Up46nhZ5dPWS5SZo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748448117; c=relaxed/simple;
	bh=rCtiwIsz8DsOaaXiYVkBTcKhJrWnV0Vvn0DitYEx7A8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AhwQ+u9Y7TdvcCTxvI29yYJYYjS0H63buB+pUx4wUotVirdoomHaJOMvTlheoogmYr9MHwqD9mWy0uUof+979abRf+vdigD3fOEeDRRqCYYuglCGro1AvqhXMmaahkIw5D1wGlYXfNAnc/msNrY4OODPtKnQBX3uXDDSlPWIxnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YmVVKcp4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YmVVKcp4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=zH8YBsvV1hICAGAzX1LdL/LRTV58yov6883I8zebeJI=; b=YmVVKcp4o9ZvcOSb9FfERcjQut
	7Dzng8cg5Xfw0lYNvo88OSrHs90zrDkNn0/0U7B1h2SGzeZY2RAduOW5xE8MH+vOkDUFJK0dvEn0r
	cSJJllitNy+aOWSgvRvD03xQPolu+cpiIPa27dfUp6xIl9u72V+w055I1z7ms6i/QpSV5KXFQ+Tjj
	JRzwhir3pmBRe9Nyz0+HkrPIa/5wYUrc9pxC/uieXmnv+ikVWOxMvKlyOiwBd7BDi0Y60xC/2GGHu
	d9uTfXnIQC+jeZYf2LS9L/UzgZaQVYjLYAkFEjZmAAws+12j+0A2gJj1KgT5ZhjGbLr3/hCjMdUgz
	jWJiL5oxpmAawwajoVGCGlyeizC//e9qQYaDVSE0i4mOMqLr8pWlU/RXBXk56m3MgTTzCbDf+vM7k
	AovG5zXk5DaSbeElPrBOdT7Gg3Os3R6TC3/BE/UQw5uNxy8KhkHWpiUbe59sJDhKsMTSU8WLtgkBc
	iK8zF67e6OjjkPM/jo9Vg/JR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uKJDz-007hGi-0x;
	Wed, 28 May 2025 16:01:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	samba-technical@lists.samba.org
Subject: [PATCH v2 00/12] smb:common: introduce and use common smbdirect headers/structures (step1)
Date: Wed, 28 May 2025 18:01:29 +0200
Message-Id: <cover.1748446473.git.metze@samba.org>
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
to move things into common header files and added the first
step in using shared structues like struct smbdirect_socket.

Currently only simple things are shared and there is no
intended behaviour change (even if I found some things
I'd like to change, but I'll defer them in order to
make the review easier).

I'll work on this the next few months in order to
unify the in kernel client and server layers
and expose the result to userspace too.
So that Samba can also use it.

v2:
  - change smb_direct into smbdirect
  - make usage of header files just as needed
  - also introduce struct smbdirect_socket[_parameters]
    as shared structures

Stefan Metzmacher (12):
  smb: smbdirect: add smbdirect_pdu.h with protocol definitions
  smb: client: make use of common smbdirect_pdu.h
  smb: server: make use of common smbdirect_pdu.h
  smb: smbdirect: add smbdirect.h with public structures
  smb: client: make use of common smbdirect.h
  smb: server: make use of common smbdirect.h
  smb: smbdirect: add smbdirect_socket.h
  smb: client: make use of common smbdirect_socket
  smb: server: make use of common smbdirect_socket
  smb: smbdirect: introduce smbdirect_socket_parameters
  smb: client: make use of common smbdirect_socket_parameters
  smb: server: make use of common smbdirect_socket_parameters

 fs/smb/client/cifs_debug.c                 |  23 +-
 fs/smb/client/smb2ops.c                    |  14 +-
 fs/smb/client/smb2pdu.c                    |  17 +-
 fs/smb/client/smbdirect.c                  | 389 +++++++++++----------
 fs/smb/client/smbdirect.h                  |  71 +---
 fs/smb/common/smbdirect/smbdirect.h        |  37 ++
 fs/smb/common/smbdirect/smbdirect_pdu.h    |  55 +++
 fs/smb/common/smbdirect/smbdirect_socket.h |  43 +++
 fs/smb/server/connection.c                 |   4 +-
 fs/smb/server/connection.h                 |  10 +-
 fs/smb/server/smb2pdu.c                    |  11 +-
 fs/smb/server/smb2pdu.h                    |   6 -
 fs/smb/server/transport_rdma.c             | 385 +++++++++++---------
 fs/smb/server/transport_rdma.h             |  41 ---
 14 files changed, 613 insertions(+), 493 deletions(-)
 create mode 100644 fs/smb/common/smbdirect/smbdirect.h
 create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h

-- 
2.34.1

