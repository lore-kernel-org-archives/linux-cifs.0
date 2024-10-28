Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023EA1DA0FC;
	Mon, 28 Oct 2024 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730113466; cv=none; b=NwXHPB8F6ZUU2Brs3F5aHKs4vGE9ZVOEy2WJLu+O0OS/qnhtyW86XGZBYygmfZUBoTWKrrzi+R2Vl0yYooRoUMA6kzmTA3GDy1cAil/MMZ3Uk8Mn+HjyQuu5YFI57x6k7iN1TRlB1ZkCipg8cqpD4VHpVz1Tc+CPE8CRRs5rhL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730113466; c=relaxed/simple;
	bh=ZzXP1X2euIq6WJQ9CY/nAkmNmvDugntVm3ieSCeNhCE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=oE35Vwq0vaghdEmriJ9b57MneGO+s/Zfu6thZAs4UDvOj/8W/BgdIIqMf+uypJdGl6wcNdFGYoy1rcaK6KOfXGJHqME6ofmp8UjUJUw0l7dNWXmMer5lJ2XU4egwZ8jVlC/4cRuOG4iGnA2AZQxp6QM7/uG8iVk4QTVXjUVGiKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJzuZtHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJzuZtHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60260C4CEC3;
	Mon, 28 Oct 2024 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730113465;
	bh=ZzXP1X2euIq6WJQ9CY/nAkmNmvDugntVm3ieSCeNhCE=;
	h=From:To:Cc:Subject:Date:From;
	b=oJzuZtHO739zDDjHnGtIWKxPaQJmHiawQdH9o1WvIdkDkW1phgmxS2oPcqpdBYvd6
	 NUHcQABVqW6vNq9U5lBNKdbxwx2inFRwCFdJw9hFCFBk90x+UH+tNbWrbj9DTnzuoV
	 0pkEKeBRRaVZT9Aeopj6yITkurYR9N4KQ5lG7NayOXibHk1Ftd5tnFBn/EfMtMi2zN
	 roGeY71HBCN6OxmXZ+4M/wPbLMsCV52T4DF4usu64AZ62zymWY/q4TLRjDT26cbhOt
	 x/oPciKFU0EgTOizW84bhOmQOsHyMnmaJIBJcWkUdO0K4kaPmXfthmFoG8BO+C8wDX
	 BQD2MCm9BA+pA==
Received: by pali.im (Postfix)
	id 105A0A58; Mon, 28 Oct 2024 12:04:18 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] cifs: Fixes for SMB1 non-UNICODE 8-bit mode
Date: Mon, 28 Oct 2024 12:03:35 +0100
Message-Id: <20241028110340.29911-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB1 protocol supports non-UNICODE (8-bit OEM character set) and
UNICODE (UTF-16) modes. Linux SMB1 client implements both of them but
there are few bugs in processing non-UNICODE mode.

This patch series add a new mount option -o nounicode to disable UNICODE
mode and force usage of non-UNICODE (8-bit OEM character set) mode. This
allows to test non-UNICODE code path against modern/recent SMB servers
which implements and prefer UNICODE mode.

And this patch series fixes SMB1 session setup and reading symlinks when
UNICODE mode is not active.

Tested against Windows Server 2022 SMB1 server and older Samba SMB1
server.

Pali Rohár (5):
  cifs: Add new mount option -o nounicode to disable SMB1 UNICODE mode
  cifs: Fix encoding of SMB1 Session Setup Kerberos Request in
    non-UNICODE mode
  cifs: Add support for SMB1 Session Setup NTLMSSP Request in
    non-UNICODE mode
  cifs: Fix parsing reparse point with native symlink in SMB1
    non-UNICODE session
  cifs: Remove unicode parameter from parse_reparse_point() function

 fs/smb/client/cifsfs.c     |  4 ++
 fs/smb/client/cifsglob.h   |  2 +
 fs/smb/client/cifsproto.h  |  2 +-
 fs/smb/client/cifssmb.c    |  5 ++-
 fs/smb/client/connect.c    | 32 +++++++++++++--
 fs/smb/client/fs_context.c | 11 ++++++
 fs/smb/client/fs_context.h |  2 +
 fs/smb/client/reparse.c    | 25 ++++++------
 fs/smb/client/sess.c       | 81 ++++++++++++++++++++++++--------------
 fs/smb/client/smb1ops.c    |  4 +-
 fs/smb/client/smb2file.c   |  1 -
 fs/smb/client/smb2proto.h  |  2 +-
 12 files changed, 118 insertions(+), 53 deletions(-)

-- 
2.20.1

