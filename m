Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ABF2629D;
	Sun, 22 Dec 2024 13:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734873682; cv=none; b=lTjYefEv1SCpb2b5u10326DJMXkpWE8j6fqe1X9w13wLO6/hOQdqGyI3iHWBVzBWMcgw/nU9YqymctcaWRMkyt+jlMkWEVJ6SaSob9MnOtz+eT7AKnco0JXhj3mSKFNoAHNTvmiRbvAEyHnHzzZNcoqWyZrk7AmkQmnhnMv/zIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734873682; c=relaxed/simple;
	bh=V4XWfgmm9c5zawwIzD9gN8mXOp60nkKTLY8+CwsQXE0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MTF3QkMQm1E2x8IC+8LcUFO1m5nJ+WvKVhGfitcDCssZLK0LKkipM7Yzo8vauIAijmM6fKA4yHLWMeMKd4S4s7h+LxsI5fIZLO4Ogp6yORHKAhChxy5T2TFim+ne2QTCSus8Ed4Z6/9Dc6onQ5IhkBxwDun2qP5JgwdRU9mH1f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQeCetvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQeCetvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598A1C4CED4;
	Sun, 22 Dec 2024 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734873681;
	bh=V4XWfgmm9c5zawwIzD9gN8mXOp60nkKTLY8+CwsQXE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQeCetvHeGURVbZaaaFolsZE4fEd1apYrr6DqPh9EfwJeyt+EniKO+VfEkcpQhogi
	 1peGAq39rUJhWag1bpduDU845HQDj9PAuSbklJpQo39w27wUpYWf8+XDEaunnkb1PA
	 IhxlsKV+xbOV2tb3w8IOk5vrDohDph/c8sO/c+3SMInzRlj4GzDXOSkUt4HiPCl75R
	 TJb0cNBgvSTQAncwDBx/vIikERLIKZC0/T1sZpVwpieiGCXfYto5ztA/LacLowzlM2
	 JrrY+YcDkrmbs9+rJnX6TKhqPd0B5UhTEP5fSyzGdVvYwP47Hoy88iyf7XK9Z9+Bw4
	 mQMRJDCJxTpow==
Received: by pali.im (Postfix)
	id 579997F2; Sun, 22 Dec 2024 14:21:11 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] cifs: Improve access without FILE_READ_ATTRIBUTES permission
Date: Sun, 22 Dec 2024 14:20:27 +0100
Message-Id: <20241222132029.23431-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005160826.20825-1-pali@kernel.org>
References: <20241005160826.20825-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux SMB client currently is not able to access files for which do not
have FILE_READ_ATTRIBUTES permission.

For example it is not able to write data into file on SMB server to
which has only write access (no read or read attributes access). And
applications are not able to get result of stat() syscall on such file.

Test case against Windows SMB server:

1) On SMB server prepare file with only GENERIC_WRITE access for Everyone:
   ACL:S-1-1-0:ALLOWED/0x0/0x40000000

2) On SMB server remove all access for file's parent directory

3) Mount share by Linux SMB client and try to append data to that file:
   echo test >> /mnt/share/dir/file

4) Try to call: stat /mnt/share/dir/file

Without this change the write test fails because Linux SMB client is trying
to open SMB path "\dir\file" with GENERIC_WRITE|FILE_READ_ATTRIBUTES. With
this change the test pass as Linux SMB client is not opening file with
FILE_READ_ATTRIBUTES access anymore.

Similarly without this change the stat test always fails as Linux SMB
client is trying to read attributes via SMB2_OP_QUERY_INFO. With this
change, if SMB2_OP_QUERY_INFO fails then Linux SMB client fallbacks for
reading stat attributes via OPEN with MAXIMUM_ALLOWED access (which will
pass if there is some permission) and OPEN reply will contain attributes
required for stat().

Changes in v2:
* At first attempt still try to open with FILE_READ_ATTRIBUTES and
  fallback to open without FILE_READ_ATTRIBUTES only on -EACCESS.

Pali Rohár (2):
  cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
  cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES

 fs/smb/client/cifspdu.h   |  1 +
 fs/smb/client/smb2file.c  | 12 ++++++-
 fs/smb/client/smb2glob.h  |  1 +
 fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 83 insertions(+), 2 deletions(-)

-- 
2.20.1

