Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D381621345;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885097; cv=none; b=JPbZrL/mVfXHw3+sMX2TFQtUNZ3b7vbl78I4GyhYUP5dleV4PfFegMLIPYOEcH1nymLBoxbxYnvoJPBHwHcoNioMH0K5/lOD3BqtFVz+b4jjK/Kr4tEE2QUzKFAIgrtlAcmSl84NMnYubKa7n6WaZaMk7IY/20COLsm/enj/GXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885097; c=relaxed/simple;
	bh=Z5Sln9N7pTCxLsjomeib10hBB3kqTVEDAjc6J95l/UQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Xi5r6tjcYYaba/pGE34Ek/Col2ybuPxHtDpRL83awmRVIogHZD/sps4ooTnTkBWjieLd/+01bhorv6HsX/+USDbsn3UjcDHHCPwUR6IhP6Xyh3qXpq8jTC+3lM8qRDet2flWWmGxi4+79nOxLr/LVnRurAPjERHyuUA+Kccd6Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IY5zUUrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IY5zUUrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E835C4CED3;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885097;
	bh=Z5Sln9N7pTCxLsjomeib10hBB3kqTVEDAjc6J95l/UQ=;
	h=From:To:Cc:Subject:Date:From;
	b=IY5zUUrcF7elyxJaAR3VPKz/JlJ7f8rPqnakMtlI1E/xf6hpvW8HmQjMd5I8eLsYI
	 DkuIVOh+VfqEAetu43YfY+yR0oTMlJfCqbemPdIPYA4dH2Da00b18CRPQM72uEf/IK
	 ED+nr9nO9xRQj31Ga18oqjh4839452FobnmY3t4UtNSPyhwyUf1Fzgz9zP7hAp4dXP
	 RVilg0rdPhyNCnADtRTpOH8uVHfVuMH88VtvdnyBUrEvrvh1scTASb9F49C/ftQ1fO
	 lYuzKTxa9wGYm/+shd7VScFYw9gzdc72HJ1v1ydERV9CvKLp6tQrqaaL3TZ/Wb8nLY
	 2sVBUrNmEibyw==
Received: by pali.im (Postfix)
	id D3B307F2; Sun, 22 Dec 2024 17:31:26 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] cifs: Fix connections over NetBIOS session
Date: Sun, 22 Dec 2024 17:30:44 +0100
Message-Id: <20241222163050.24359-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series fixes establishment of NetBIOS session for SMB2+
connections which is currently broken. Tested with SMB3 dialect
against Windows Server 2022.

Also it improves autodetection whether NetBIOS session is needed on
specified server port, and allows to initialize NetBIOS session also
over other port than 139. This is needed when testing against virtual
machines when port 139 is forwarded over some non-system port.

Pali Rohár (6):
  cifs: Allow to disable or force initialization of NetBIOS session
  cifs: Fix establishing NetBIOS session for SMB2+ connection
  cifs: Improve establishing SMB connection with NetBIOS session
  cifs: Improve handling of NetBIOS packets
  cifs: Fix negotiate retry functionality
  cifs: Set default Netbios RFC1001 server name to hostname in UNC

 fs/smb/client/cifsglob.h   |   4 +
 fs/smb/client/cifsproto.h  |   3 +
 fs/smb/client/connect.c    | 316 ++++++++++++++++++++++++++++++++++---
 fs/smb/client/fs_context.c |  25 ++-
 fs/smb/client/fs_context.h |   2 +
 fs/smb/client/smb1ops.c    |   7 -
 fs/smb/client/smb2ops.c    |   3 -
 fs/smb/client/transport.c  |   5 +-
 8 files changed, 327 insertions(+), 38 deletions(-)

-- 
2.20.1

