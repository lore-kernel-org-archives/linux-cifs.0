Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2D1175D5C;
	Sun,  6 Oct 2024 10:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728208871; cv=none; b=r2psmbgKjxS+FfF/WkGviwTeKH6lIeR+afrRWE0QBn/tC8OXRaDkK+xIYTKkzRvAzlOOHj3Tz5QN1DMGBoHSf0lGL+2uIivgdSAotF9lVwSCWYBsMVCzWM2vO9izBM91JLVnCizWsIJy/gOI8oZVD5zdzoqVekKiv1au/zmisw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728208871; c=relaxed/simple;
	bh=nDcqMOmHhs7STNbH0Ot5sUT4vs+zoNhL3T3tE+/I+JA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=aXwPYZWgJjjulIP3DZpCCZ4NhFbCR4enibOlX01n1qI09DzscOVjlOINJhCMyAYBC01eJ2+l4/KESZb4jr777xleiKA8vfI7QJFJxPxQP6sj1/71wqd6mNX4LXJjSEnhUqcqmFqlbSpckuEwfnY/yagtFV9FXNP/mlk0pmZLXqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PaBIQk+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PaBIQk+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E282AC4CECF;
	Sun,  6 Oct 2024 10:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728208871;
	bh=nDcqMOmHhs7STNbH0Ot5sUT4vs+zoNhL3T3tE+/I+JA=;
	h=From:To:Cc:Subject:Date:From;
	b=PaBIQk+m9qCRhv6wm/h55UfuuZKI3SIkZ43/NFKcwWt3Y5+YEOmLEk+cwqd4gsZmN
	 Hm8GJMc5GzXSC7C+vGpSF4l3ZhBttHYI9kg+sgdCW55ipraX1H13BkpzV32uH1SIAA
	 ITjVTVyLOx4b2TlhDH6vn67Iqei5O44QKziWIpHIS+yNlbWn2Z42TInoGK27op1Wwj
	 24zCP4TkoG6xtRPvszPfLIYPUYSmhePUC2gtmplsnZgKZSBkEi8WJX7EvelPXv90B2
	 Ixx4kGHdKSG9IPJPT6KUzVL9+PrkLS0KV+bQOPLSAbdv6Nc1JKv5wzGGpkjyJhlLWZ
	 sMxRaJh4LAAuw==
Received: by pali.im (Postfix)
	id F119C81A; Sun,  6 Oct 2024 12:01:01 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] cifs: Improve mount option -o reparse and support for native Windows sockets
Date: Sun,  6 Oct 2024 12:00:39 +0200
Message-Id: <20241006100046.30772-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series improves choosing reparse format when creating new
special files.

In following table is behavior of creating new special files before
this patch series. In columns are mount options, in rows are file types
and in each cell is reparse format which is created.

          -o reparse=default  -o reparse=nfs  -o reparse=wsl
symlink      native              native          native
socket       nfs                 nfs             wsl
fifo         nfs                 nfs             wsl
block        nfs                 nfs             wsl
char         nfs                 nfs             wsl


After this patch series the table looks like:

          -o reparse=default  -o reparse=nfs  -o reparse=wsl  -o reparse=native+nfs  -o reparse=native+wsl  -o reparse=native  -o reparse=none
symlink      native              nfs             wsl             native                 native                 native             -disallowed-
socket       native              nfs             wsl             native                 native                 native             -disallowed-
fifo         nfs                 nfs             wsl             nfs                    wsl                    -disallowed-       -disallowed-
block        nfs                 nfs             wsl             nfs                    wsl                    -disallowed-       -disallowed-
char         nfs                 nfs             wsl             nfs                    wsl                    -disallowed-       -disallowed-


The default behavior when no option is specified (which is same as
-o reparse=default) changes only for creating new sockets which are
now created in its native NTFS form with IO_REPARSE_TAG_AF_UNIX reparse
tag.

The nfs and wsl behavior is changed to always create new special files
in its own formats.

There are new options native+nfs and native+wsl which creates by default
in native form (symlinks + sockets) and fallbacks to nfs/wsl for other
types (fifo, char, block). This is probably the most useful for
interoperability. Mount option -o reparse=default is now same as
-o reparse=native+nfs

For completeness there are also new options -o reparse=native which
allows to creating only native types used by Windows applications
(symlinks and sockets) and option -o reparse=none to completely disable
creating new reparse points.


Pali Rohár (7):
  cifs: Add mount option -o reparse=native
  cifs: Add mount option -o reparse=none
  cifs: Add support for creating native Windows sockets
  cifs: Add support for creating NFS-style symlinks
  cifs: Improve guard for excluding $LXDEV xattr
  cifs: Add support for creating WSL-style symlinks
  cifs: Validate content of WSL reparse point buffers

 fs/smb/client/cifsglob.h   |  18 +++-
 fs/smb/client/fs_context.c |  16 +++
 fs/smb/client/fs_context.h |   4 +
 fs/smb/client/reparse.c    | 211 +++++++++++++++++++++++++++++++------
 fs/smb/client/reparse.h    |   2 +
 5 files changed, 218 insertions(+), 33 deletions(-)

-- 
2.20.1

