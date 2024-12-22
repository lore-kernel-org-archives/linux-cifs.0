Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A54918FC7B;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734879572; cv=none; b=GIzisbGM9rljeuBhvtdfRnGAkiU3iGr0YNAMUyVmlQg8XGu6jve/WZjImI6+vfQd9a5+Zde+CCesTngghHXLOlsBMxsl7GJxUGaeg87+vxB95pKEBhplZ+cLpHrKQB9zcmxzw2Fel3KdFNzw82iwBvSBkTAZtbnzbaQCt4idB6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734879572; c=relaxed/simple;
	bh=Rbqm/7dZm4VcUQYm+XeS0ttuv5HxnoyRG5piKuEuMZ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XsFICpRLulDBLP3BmHSOK8YN4n+qM1CNjxi/9J2r8aqT8Qg34vzoYROeA6z2YnUXsxN1F1hu8gyZ2nOyrK2TQMTFMXrQcR8WbYzCKuPqrVhYu8XcjhBx2o2uSvgfbPkD1hPaYkH8FW4qGX+0zvZVKtVLnhnVx2CrMG2eSAdkdB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mr+o3vGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mr+o3vGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BFEC4CEDD;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734879571;
	bh=Rbqm/7dZm4VcUQYm+XeS0ttuv5HxnoyRG5piKuEuMZ8=;
	h=From:To:Cc:Subject:Date:From;
	b=Mr+o3vGadMa63N2j6XxUZ5AQiiI7vRzoUp0x2j5LXEr3Q8jWH8rTCRZ5ATTTfDw+z
	 tzeshC4XLcKKshzKov5r43gIrw8vXn+ZCgkk/9V4PvJsgN8uFeMNPkkZZUw/a3lPlY
	 JOescE4escbhlFI6HXAwXRJnrDt2OZ3elYLLAhhL6Uq13XDa8nHtZPqBeSkKmhstTr
	 zRVAPGk4xa0t86IRBzOQRQehKqqOmSJWGRF8q2JnfB0omYweTEHPIW3tyrMd7VmTg5
	 WZCKU61BQAOYtISTzuTiDSgFnI+U24Zs8Cd9WFOvknCTwmNRih308l6Z458kwiNJlz
	 S455BJbjOpPZw==
Received: by pali.im (Postfix)
	id 5B0027F2; Sun, 22 Dec 2024 15:59:21 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cifs: Handle all name surrogate reparse points
Date: Sun, 22 Dec 2024 15:58:41 +0100
Message-Id: <20241222145845.23801-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Name surrogate reparse point represents another named entity in the system.

If the name surrogate reparse point is not handled by Linux SMB client
and it is of directory type then treat it as a new mount point.

Cleanup code for all explicit surrogate reparse points (like reparse
points with tag IO_REPARSE_TAG_MOUNT_POINT) as they are handled by
generic name surrogate reparse point code.

Pali Rohár (4):
  cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from
    parse_reparse_point()
  cifs: Treat unhandled directory name surrogate reparse points as mount
    directory nodes
  cifs: Remove explicit handling of IO_REPARSE_TAG_MOUNT_POINT in
    inode.c
  cifs: Improve handling of name surrogate reparse points in reparse.c

 fs/smb/client/inode.c    | 17 +++++++++++++----
 fs/smb/client/reparse.c  | 24 ++++++++++--------------
 fs/smb/common/smbfsctl.h |  3 +++
 3 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.20.1

