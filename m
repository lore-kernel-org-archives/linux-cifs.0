Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1811494A9;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402101; cv=none; b=M/wV5DXgeP3wQI3EX3OoVRASnzqFlfdzCIswxrUnqa77tEtHduffuSCWOy5rHcsU8U7+UOaqhS9SXO3dTU2OzEU/UxbRzdnE0eRCD0SFil+UxqOOgYKKFo6pqrA9tZ1S1MYqmlk5bgfaYixh0bigCbe9hqmvOC9cgPoGmxAusZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402101; c=relaxed/simple;
	bh=nxsaCKx/S6ofqyfz2JbV5DfOHQgLugRnXlYyZqkT36U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=McI9gzX7Am5rP6UgTKeHRSh1KpG52srsQLE/fkjK9cstJylgJCE+kfMjOQPwLOCmqszlV+A4dmEqGS/xAuu+f0zC4qPnc3xXPZQRI1v3rKs7YcSMi8LeCAY3iLqjW2Y8Fqegm++fEKkX0A4XH2ynkpYQOVW6eXZwI4TXJf+xEMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9nBZWf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9nBZWf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AE2C4CEEE;
	Sun,  8 Jun 2025 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749402101;
	bh=nxsaCKx/S6ofqyfz2JbV5DfOHQgLugRnXlYyZqkT36U=;
	h=From:To:Cc:Subject:Date:From;
	b=n9nBZWf4iVisvGNOET/N5HtzFjosQu0IbhMsc9FPadGHTfZMQM0FwiunA9A/SBsYs
	 tw12cGsRIkQpDGfixOsh/cBvuHzGVLQlrQatKBtnIjuDLACNd+V+ipOnfzh3cb+bX8
	 vb69ch0SEEJE9dG+XmrjCHay77o5hhUUvdDIOs0usElJgWlibJ7xkqFEibIcrIKY56
	 HKim/6X70N+UVT7ihRsWip9B5O3nLdIAJdWWZRWYjq+ZXb2cIPVDRy11TgB9MkZ4hp
	 dzAE0Iyip45C99LRGJYqK/K6fR9D86DoQGRce0F47mICjk+jnsOPUGPdkZXo6vxrS9
	 P47N4n/IlHLaA==
Received: by pali.im (Postfix)
	id 2B93555E; Sun,  8 Jun 2025 19:01:38 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] cifs: Fix validation of WSL-style special files
Date: Sun,  8 Jun 2025 19:01:14 +0200
Message-Id: <20250608170119.6813-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series fixes validation of WSL special files by Linux SMB
client, to be compatible with WSL subsystem.

Pali Rohár (5):
  cifs: Remove setting duplicate fattr->cf_dtype from wsl_to_fattr()
    function
  cifs: Fix validation of EAs for WSL reparse points
  cifs: Fix validation of SMB2_OP_QUERY_WSL_EA response size
  cifs: Query EA $LXMOD in cifs_query_path_info() for WSL reparse points
  cifs: Validate presence of EA $LXMOD for WSL reparse points

 fs/smb/client/reparse.c | 40 ++++++++++++++++++++------
 fs/smb/client/smb1ops.c | 62 +++++++++++++++++++++++++++++++++++++++--
 fs/smb/client/smb2pdu.h | 19 ++++++-------
 3 files changed, 101 insertions(+), 20 deletions(-)

-- 
2.20.1

