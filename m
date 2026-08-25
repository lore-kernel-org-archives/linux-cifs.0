Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93261D63E4;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699200; cv=none; b=sP2iaN/DjEv+elshcApl3lqiqfSmzzuMhzFgcdhwpy/ebA4/C2UUHGYTGfRtWQeZgdSOLqhGKJLhZjbiKfjN2BmZmmKqgcVroSF7RPXa1ZKlt7Gug26h/4I5afiCihv52xkOppCN/rQCCLwrxVa4YtTn/AbTzi8j+r/2de5yMC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699200; c=relaxed/simple;
	bh=sfvVxVB9aXnqKCeJmU/0wt/DS5SRyhd5QHPvXUmDMmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gdKbGcGE9KbmorFn+6Jm15qsJ6IQWRb1pDB3eR7fBd9Uj+TOq4c+Ka+YTXANeQp2s0PeqSR17De5WEVmgJ7Fkarf0eYqDHsamivrQhTmOPSVdTfuh1AdmI6O/67svqggvfI/pWwqaN4AO9vHrjvEd86UUZrUQbvId6RVKYRQ2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j6q3ey1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6q3ey1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C421F00A3D;
	Tue, 25 Aug 2026 23:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787699198;
	bh=mv+A0OGUDREKbbz9wz4M9ykJ1O4GkxENDT/zbHHJz+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6q3ey1Dhb6rFNOrxJBVegy6kUaCvbbYDcBuV26P8XNSa1D9d+gax0Io8dvLajVSK
	 0wHf2gOb0GYRF24bdaAW37gvce/Jsheqq6bUfrfckbJ6clvdvHjqFzkwIvQRXy5RBQ
	 y3Nn2IypOK5v8CFqPI1o9Q6HUMyHhtjl5MZxJpjMwnLUw7Wpk5QxeS1IXRppcte2ay
	 kX3BWX0QZVehYHG4sZDJRG+102+ZUI+s5nYKXEjDaXTHfbgYCJlJug2fIGkJo4JWWT
	 0SH/ItLZtty4A00iatyiXdWuIClkP4h5rXCQTgZPmOZjagbjD20uNkOfw1P5NU70G/
	 CWYxHNSHKCnTw==
Received: by pali.im (Postfix)
	id EB3E44EE; Wed, 26 Aug 2026 01:06:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] Various changes
Date: Wed, 26 Aug 2026 01:06:13 +0200
Message-Id: <20260825230622.24617-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260821214722.q7rkflclyyugdxll@pali>
References: <20260821214722.q7rkflclyyugdxll@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rebased changes on top of the 45c13f3f9e3bb15fd89ff2864c6f627a3b4b4229.

Pali Rohár (9):
  cifs: Remove code for querying FILE_INFO_STANDARD via
    CIFSSMBQPathInfo()
  cifs: Remove cifs_backup_query_path_info() and replace it by
    cifs_query_path_info()
  cifs: Fix validation of EAs for WSL reparse points
  cifs: Validate presence of EA $LXMOD for WSL reparse points
  cifs: Check if server supports EAs before trying to set it for WSL
  cifs: Extend ->set_EA() callback to allow operate on reparse point
  cifs: Create native Window socket file compatible also with WSL
    subsystem
  cifs: Add support for parsing WSL symlinks in version 1 format
  cifs: Add support for creating WSL symlinks in version 1 format

 fs/smb/client/cifsglob.h   |  10 +-
 fs/smb/client/cifsproto.h  |   1 +
 fs/smb/client/cifssmb.c    |  43 +++---
 fs/smb/client/fs_context.c |  11 +-
 fs/smb/client/fs_context.h |   3 +-
 fs/smb/client/inode.c      |  98 +------------
 fs/smb/client/link.c       |   3 +-
 fs/smb/client/reparse.c    | 273 ++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb1ops.c    |  11 +-
 fs/smb/client/smb1proto.h  |   4 +-
 fs/smb/client/smb2ops.c    |   6 +-
 fs/smb/client/xattr.c      |   3 +-
 fs/smb/common/fscc.h       |   5 +-
 13 files changed, 297 insertions(+), 174 deletions(-)

-- 
2.20.1

