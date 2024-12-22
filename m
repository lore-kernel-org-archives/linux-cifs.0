Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F19A290F;
	Sun, 22 Dec 2024 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734882290; cv=none; b=LE1RseSJ2l41iLRBQTu0/oAjK45uOrWe8f2Hlhrt+p9RiIARccmrLdRseI1ta+8rH3hG8R3ZK46A76E16Gib2KaDQPSRn9UTsw5CpV6pN2Z/MCB0toS/76bi8yWfeR/usNZi0YujolU/JuJHLzFOc1ozU3b0V5gici78Xa0/vyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734882290; c=relaxed/simple;
	bh=2jLHHwe+QdP/HaQQE1ven7vjvrOuwIocPtMUW/LzcIU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=GGq5qaBxuOpgB7jkhy32WmrQc6/Op0ALx/LBG1RCA5K2dawZbHTYrtHXabNcOSA9upf//AQr5OpMO2WYvF/vkBrgNY5g65aR8Yf602eR2pmBPpKIuutMegpA6mIOw4goX+YMaPum+XspLD2vw2NFRSgO8eCElo7OrW7X6Juvx+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lq5StWba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lq5StWba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB469C4CECD;
	Sun, 22 Dec 2024 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734882290;
	bh=2jLHHwe+QdP/HaQQE1ven7vjvrOuwIocPtMUW/LzcIU=;
	h=From:To:Cc:Subject:Date:From;
	b=lq5StWba0e1732aTRblD2EteYIZgXdDW5lh37CD+9O34cxVyLitYnIPK2aIl3rkMA
	 hE0LPtbmSTXMQ6UE+raSlaJGnZK8U2alPhhub/1h6FFLzXzBah2eoQuwh0qJn1cekb
	 Tjr9zFOkZ04+t+C0qPeaXOohgziM6i/vUdtKaNNfbrkNCGqQQ7WjXKenYqtp1HbWbR
	 brBAAC4PFIHEi3EXBMqHyNN9R8CcyAGmU2BgJsKjoukVBnZ46JgTrsR8acooFWmwlQ
	 OessZbyAC9E15PBXsRVlHwsOzhW5U33sgmjYDT3yUSV/gD16Z67U5mTAnNl6/WrzRx
	 eQz3V2WM07Q6w==
Received: by pali.im (Postfix)
	id E890D7F2; Sun, 22 Dec 2024 16:44:39 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cifs: Add support for querying reparse points from userspace
Date: Sun, 22 Dec 2024 16:43:36 +0100
Message-Id: <20241222154340.24104-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series add a new xattr system.reparse for querying reparse
point buffer from userspace, fixes errnos related to reparse points and
do not attempt to use reparse points when server does not support them.

Add new reparse point or changing/deleting existing reparse point is not
implemented yet, can be done in the future via setxattr()/removexattr().

Pali Rohár (4):
  cifs: Split parse_reparse_point callback to functions: get buffer and
    parse buffer
  cifs: Add a new xattr system.reparse for querying repase point from
    SMB server
  cifs: Change translation of STATUS_NOT_A_REPARSE_POINT to -ENODATA
  cifs: Check if server supports reparse points before using them

 fs/smb/client/cifsglob.h     |  6 ++---
 fs/smb/client/cifssmb.c      |  3 +++
 fs/smb/client/inode.c        | 11 +++++----
 fs/smb/client/link.c         |  3 ++-
 fs/smb/client/netmisc.c      |  7 ++++++
 fs/smb/client/nterr.c        |  1 +
 fs/smb/client/nterr.h        |  1 +
 fs/smb/client/reparse.c      | 15 ++++--------
 fs/smb/client/reparse.h      |  5 +---
 fs/smb/client/smb1ops.c      | 17 +++++--------
 fs/smb/client/smb2inode.c    |  8 +++++++
 fs/smb/client/smb2maperror.c |  2 +-
 fs/smb/client/smb2ops.c      | 12 +++++-----
 fs/smb/client/xattr.c        | 46 ++++++++++++++++++++++++++++++++++++
 14 files changed, 96 insertions(+), 41 deletions(-)

-- 
2.20.1

