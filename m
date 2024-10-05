Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FB417BD3;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728137029; cv=none; b=FuQQeaBr9BnEyC5pscvFB/rCI7p653iCQ1tYfji7OlcYfscSm2shg+fDQc8KVrfNbxpwnqqZOQC45cBW4MN/3lrB+i+EzgzyVqFvdhewzupOnnqaRfboO3zYlnO5ezVv5lX/CumLSLsk1gGSdX4jqphzD+QR1Jo6QQj0VSiXZBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728137029; c=relaxed/simple;
	bh=bNDQjtf3SaC9U3DetMKfO465iHp2XJiQrQYud2beBps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JVEYdeliqc+BAhuC+9WUAv3QUimGYQwJrnCFlEvr0xmO+CAT1UBBlsZw4H6cD+qLZhIuX6HGNWFX/oUNbLlU3m9BLhsdCYq5kiwYVucee5mKy2vW4I9r8GFot7OwPLbq0C/+TAQaUWyC0AjzNuJ/RHckuAA/BVKUJTAirxTiocc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0yVwwnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0yVwwnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13714C4CEC2;
	Sat,  5 Oct 2024 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728137029;
	bh=bNDQjtf3SaC9U3DetMKfO465iHp2XJiQrQYud2beBps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0yVwwnjfXiiksRGhbUI3U4fhBk4yFJRhBx38i3eLcb6UbcXOOzrIJHx9zT6+rOTc
	 wKPK4TlHm7hHSgLaqOcdzIIjNkU1uBWtCDSZmDSIqWGYpZ/trbdgv4H6G6KM7ozKVn
	 5QOWHxi1vtzaUcgtS2i3MvpGiy6M2Bm4dJsBvvquJ2IVse3Vc10sscrAhhgl0c3q3h
	 p03EPyMiJ+DJ11tXhUeyDmjRShmgjfCLgw+/H1mmZb+1t9pecuGyX/SHlDNCEV4XRU
	 MKoGBanIrfETfhMRJgkyaMZxLNdhpmM3YO6Zq9DngkXa2y/PvOp8UFA+MWxXawyIV5
	 Uc/dqX9HdWlpw==
Received: by pali.im (Postfix)
	id 7E87C648; Sat,  5 Oct 2024 16:03:42 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] cifs: Improve support for native SMB symlinks
Date: Sat,  5 Oct 2024 16:02:54 +0200
Message-Id: <20241005140300.19416-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240929185053.10554-1-pali@kernel.org>
References: <20240929185053.10554-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is second version of patch series which improves support for native
SMB symlinks.

Changes since v1:
- Patch which renames function was dropped
- Patch "Improve creating native symlinks pointing to directory" address
  issues pointed by Paulo Alcantara
- Patch "Fix parsing native symlinks directory/file type" was changed to
  apply fixups only for non-POSIX servers (Windows SMB/NT)
- Patch "Validate content of native symlink" was improved to check also
  UTF-16 buffer length of symlink

Pali Rohár (6):
  cifs: Improve creating native symlinks pointing to directory
  cifs: Fix creating native symlinks pointing to current or parent
    directory
  cifs: Fix parsing native symlinks relative to the export
  cifs: Fix parsing native symlinks directory/file type
  cifs: Validate content of native symlink
  cifs: Fix creating and resolving absolute NT-style symlinks

 fs/smb/client/cifs_unicode.c |  17 +-
 fs/smb/client/cifsglob.h     |   1 +
 fs/smb/client/cifsproto.h    |   1 +
 fs/smb/client/fs_context.c   |  22 ++
 fs/smb/client/fs_context.h   |   2 +
 fs/smb/client/inode.c        |   6 +
 fs/smb/client/reparse.c      | 538 ++++++++++++++++++++++++++++++++---
 fs/smb/client/reparse.h      |   4 +-
 fs/smb/client/smb1ops.c      |   3 +-
 fs/smb/client/smb2file.c     |  76 ++++-
 fs/smb/client/smb2inode.c    |  13 +-
 fs/smb/client/smb2proto.h    |  11 +-
 12 files changed, 642 insertions(+), 52 deletions(-)

-- 
2.20.1

