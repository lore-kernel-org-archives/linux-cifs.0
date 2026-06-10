Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D93F2E7F2C
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2026 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104571; cv=none; b=sYDKNDE9VPSJHEUKUndjnhwd4eODjmm6pHozMRu2KUg2zMUgklhgbxS1unhAoje5yNuk/DHyArfiYSamJcu3FFBhhmmMH5qaOk1za+REk8irTe2ofnSiprq1SIHjoM4dO34DSgSaQVs2JUhwipwQiBwvGoP57pj97LJYOTMR83c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104571; c=relaxed/simple;
	bh=laX5f1m2DS92IoCbhJW+4iyxKxjWzSBHOvPOWWVp3m0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NM6BEjS5ftPCQReqjd6vRvIOMAOiUmAg1P44jzxW028poT4AdB4K65/X/X6hP/tlWRpGQu5r9P2xcAaJrwaZrG9Z4VPUA1VkTSvJtZPgrcd8vcRZyvaKhcZs9BAdKXgVzCV36d8+t9JEl9kmQYGQSEZPuGuqHYj7J0PEfFNYhCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+n2xyux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+n2xyux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD571F00893;
	Wed, 10 Jun 2026 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781104569;
	bh=gab9hochxwKLXJuTpKoG6c+2w41i961yAnU9Iy+X07g=;
	h=From:To:Cc:Subject:Date;
	b=L+n2xyuxQcJxNbaVls452FGtrcjc46V03t0HpuGgFqeesB1WSe3ucTmk6AqYfa8I9
	 NsjidPq506vuI7K9DHYBycVvwArpwdLZimKOAd/DgEQnRKBxM9NdxQRoal4x8oJ4aQ
	 3feZxzrooOOWpaZO8oao5u+G5LFSahkQ057j1pA71O7LORhiRluW832GQNyIAW9Y75
	 Ho+Qm7YBydP2HTsYei1Vosr32QAcWv26MgjEK/bK8hYnBi/lU+ASBEciHENEus2Zlp
	 P49eL7q7TQbwrOsGVySV5cfQCfcpYa5+eFm37ESA9s0RY02Gq8o2gBI3kzU1R+86KX
	 lWQeaey/aEU/Q==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 0/5] smb: add SMB2 compression support for ksmbd
Date: Thu, 11 Jun 2026 00:15:38 +0900
Message-Id: <20260610151543.25218-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds SMB 3.1.1 compression support to ksmbd and moves the
existing client LZ77 encoder into fs/smb/common so both cifs and ksmbd
can use the same codec.

cifs.ko advertises and decodes chained compression capabilities,
including LZ77 and Pattern_V1, but this series does not set
SMB2_READFLAG_REQUEST_COMPRESSED or add a compressed transform receive
path. Receiving compressed SMB2 transforms remains a TODO for CIFS
client developers.

ksmbd negotiates LZ77 and optional chained Pattern_V1 support, advertises
SMB2_SHAREFLAG_COMPRESS_DATA, decodes compressed client requests, and
compresses eligible READ responses when doing so reduces the wire size.

Namjae Jeon (5):
  smb: move LZ77 compression into common code
  smb: add common SMB2 compression transform helpers
  cifs: negotiate chained SMB2 compression capabilities
  ksmbd: negotiate and decode SMB2 compression
  ksmbd: compress SMB2 READ responses

 fs/smb/client/Makefile                    |   2 +-
 fs/smb/client/cifsglob.h                  |   2 +
 fs/smb/client/compress.c                  |  12 +-
 fs/smb/client/compress.h                  |  28 +-
 fs/smb/client/smb2pdu.c                   |  44 ++-
 fs/smb/common/Makefile                    |   3 +
 fs/smb/common/compress/compress.c         | 399 ++++++++++++++++++++++
 fs/smb/common/compress/compress.h         |  28 ++
 fs/smb/{client => common}/compress/lz77.c | 136 +++++++-
 fs/smb/{client => common}/compress/lz77.h |  17 +-
 fs/smb/common/smb2pdu.h                   |  11 +-
 fs/smb/server/Makefile                    |   2 +-
 fs/smb/server/compress.c                  | 209 ++++++++++++
 fs/smb/server/compress.h                  |  16 +
 fs/smb/server/connection.c                |  12 +
 fs/smb/server/connection.h                |   3 +
 fs/smb/server/ksmbd_work.c                |   1 +
 fs/smb/server/ksmbd_work.h                |   4 +
 fs/smb/server/server.c                    |  10 +
 fs/smb/server/smb2pdu.c                   | 118 ++++++-
 fs/smb/server/smb_common.c                |   5 -
 21 files changed, 989 insertions(+), 73 deletions(-)
 create mode 100644 fs/smb/common/compress/compress.c
 create mode 100644 fs/smb/common/compress/compress.h
 rename fs/smb/{client => common}/compress/lz77.c (75%)
 rename fs/smb/{client => common}/compress/lz77.h (65%)
 create mode 100644 fs/smb/server/compress.c
 create mode 100644 fs/smb/server/compress.h

-- 
2.25.1

