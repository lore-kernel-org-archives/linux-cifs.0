Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="LrI97eju"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B6CC5
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 14:08:27 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wiu5B2PoglkzeWLSgd3FFsu9FVQ6dToR0RKcHnmo21Q=;
	b=LrI97ejub6oRMb3ceg03lZ8Y0HhfNJNFaFpURG2RX8z1qxLH2vcMMkt7lJz9UNDKjVIcU0
	ykSBfPzClJlSV5s/+AzoMqI41OL194m6jE25yrT7L9TU1xGHQDGwZwDO7XD3mPnRZE4I3L
	+wyMcq19T//mmnnalqYlGuGlny1q4TPh/PLT+UTuTg25xJQQk1INDzNc3frzeGBPCae0+K
	v1mQmbVhHM260WLsXzx+nPvzF8+CCBPUKtzzIrWiqDq++7OTurKuT8bdTdg2mKIsGzVqgc
	ocNr/O0SXn5/n5gXOoniKptsATXcsQ3a4EcQ7g4FW3mQUopr9fKWFybWwJNCWA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700950106; a=rsa-sha256;
	cv=none;
	b=GZJmJaFVSN0+/oIOuee3dIx6ZgBNXFQh6igHpTJ0HecDTf8/WUtliILq0BU4nXX2L/11Gd
	GpNTxj6kkoo7cClXKI3Aa3gZ/zAOvq8lOsYcdEvw5DxNrR61D2+fCIco84QfAEbAVP/ODO
	AJRmjLzuYx5dzJWpQEIZ/1DoOl7f06LW/sVtbC/L0rYKjykMNeCMizI6mOKyuxSuaV9f36
	BITiJFEnGR9OssHnlqBnlq2Q8jfzaat0rjgvahXR/+ImXrfYJHkIaHHqKlJpe9/K7nSYnJ
	OZimgURBtTl7+lk5fQ+2DQ4aq82y7M0gOH5I9ZQd62wB3Q8DnAdMwhrwMh7opg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950106; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=wiu5B2PoglkzeWLSgd3FFsu9FVQ6dToR0RKcHnmo21Q=;
	b=gZF9HvtLxG0x7Qe63UsZ3GYg8vTl/W9SkhC/J3y22m/B6KoXPvAMaAeLcgatOgi/2dr6Rx
	InUfjPvPcs+X0UaSbZNI2lH70L+zVd0EOydU6mnBMfSvqrpKu+2f3rOtQfFVVEJiy7FX2v
	KAmineL3MH5knwCTqUgutFXPwoJEOw/AFl92fnVccmgBz7SJcedru95A+O2ES+exvD2jzZ
	NZyhS1qBDb5ttYq2j9zqYt8UbfLSQfeSE5mzqs5iGGmUXNNxI4KqvknIS56dFE3IBV+wqS
	4Og1XETVb5UQ+DWW1Vh6NJs4+OCUWgiz+lRgJy8n5bjWyri5d1fQcsGOnBI2HQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 0/8] reparse points work
Date: Sat, 25 Nov 2023 19:08:05 -0300
Message-ID: <20231125220813.30538-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steve,

This series contains reparse point fixes and improvements for SMB2+:

- Add support for creating character/block devices, sockets and fifos
  via NFS reparse points by default.

- Add support for creating SMB symlinks via IO_REPARSE_TAG_SYMLINK
  reparse points.

- smb2_compound_op()

  * allow up to MAX_COMPOUND(5) commands in a single compound request
  * introduce SMB2_OP_{GET,SET}_REPARSE commands

- Optimisations for dentry revalidation and read/write of reparse
  points by reducing number of roundtrips.

- Fix renaming and hardlinking of reparse points

For people who pass 'mfsymlinks' and 'sfu' mount options, the
implementation is expected to avoid creating reparse points at all.

Volker Lendecke had suggested trying to create both SMB symlink and
mfsymlink in a single compound request but this series doesn't have
it.  It could be implemented later.

Paulo Alcantara (8):
  smb: client: extend smb2_compound_op() to accept more commands
  smb: client: allow creating special files via reparse points
  smb: client: allow creating symlinks via reparse points
  smb: client: optimise reparse point querying
  smb: client: fix renaming of reparse points
  smb: client: fix hardlinking of reparse points
  smb: client: cleanup smb2_query_reparse_point()
  smb: client: optimise dentry revalidation for reparse points

 fs/smb/client/cifsglob.h  |   47 +-
 fs/smb/client/cifsproto.h |   30 +-
 fs/smb/client/cifssmb.c   |   17 +-
 fs/smb/client/dir.c       |    7 +-
 fs/smb/client/file.c      |   10 +-
 fs/smb/client/inode.c     |   85 ++-
 fs/smb/client/link.c      |   29 +-
 fs/smb/client/smb2glob.h  |   26 +-
 fs/smb/client/smb2inode.c | 1054 ++++++++++++++++++++++---------------
 fs/smb/client/smb2ops.c   |  297 ++++++-----
 fs/smb/client/smb2proto.h |   29 +-
 fs/smb/client/trace.h     |    7 +-
 12 files changed, 988 insertions(+), 650 deletions(-)

-- 
2.43.0

