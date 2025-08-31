Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0965E1684B4;
	Sun, 31 Aug 2025 12:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643795; cv=none; b=ScTHpK0z4CDMUGE+mXgbHD1fB8flUAYZB1DS+kPbqseuTGstmKCfNTSfWa5atEo8vRY6g7cjdTwtipH2RKskSW9diN6ohU0nAZPEdp3DqnJZqjUtMza/ZF0bfhs3qXNGHb0GDohhtaIAVeZOYHdrOB2/aWDOl4HCN/m2vzTGsjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643795; c=relaxed/simple;
	bh=52Qhkrsry7g7VpncZjJ63ms3ZNI8xBfomvDvvd2arvc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=m0wBmYOkRQwQqMTNE7YPrmqedMXn4R4s5wlkoCS7cBmWT4fpkqWblC7qVE6G4CMLUWVKsOp1NXQcN9CIyeEmR/gOF9BROvyuQXybTQ44eyihuqH9tdc1leP4ijgArisnih95oCg5xnZAlF3ukcPzrssK/Xk/wKFjHSAH36qdIkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kVvZZh6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kVvZZh6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A7DC4CEED;
	Sun, 31 Aug 2025 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643794;
	bh=52Qhkrsry7g7VpncZjJ63ms3ZNI8xBfomvDvvd2arvc=;
	h=From:To:Cc:Subject:Date:From;
	b=kVvZZh6wcSMEP87wsYelckASzSSuN66mA0fKYborfW20k4bCHvaVp21d7RYvIUxr3
	 t6Eqn65lMOmnBfuvTu1wA72KTkWyKUcfa0pb4A52qE8NXNpy+KXVx9U/0Ooz4XWF9C
	 tJc4u2Syy2Doy1N6ttimWj/9BmxiS5bivpcupNK5DSJlIqR1jqrS5F/+NT7aJBFewU
	 TqRaAXBsF9YotdPXCaRfkIc8owZrkY9osNJXhKxNzgS6E1MfL1OnBnE+PugtVZpBHH
	 /v9Wl8ZInuoDoeYoSLPfJCdYUwo6swzQia9eiEcS99F5FNu2Ow3TptOj/A490HJJMX
	 C8N9RyyvQGkfg==
Received: by pali.im (Postfix)
	id BFD22598; Sun, 31 Aug 2025 14:36:30 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 00/35] cifs: Fix SMB rmdir() and unlink() against Windows SMB servers
Date: Sun, 31 Aug 2025 14:35:27 +0200
Message-Id: <20250831123602.14037-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series improves Linux rmdir() and unlink() syscalls called on
SMB mounts exported from Windows SMB servers which do not implement
POSIX semantics of the file and directory removal.

This patch series should have no impact and no function change when
communicating with the POSIX SMB servers, as they should implement
proper rmdir and unlink logic.

When issuing remove path command against non-POSIX / Windows SMB server,
it let the directory entry which is being removed in the directory until
all users / clients close all handles / references to that path.

POSIX requires from rmdir() and unlink() syscalls that after successful
call, the requested path / directory entry is released and allows to
create a new file or directory with that name. This is currently not
working against non-POSIX / Windows SMB servers.

To workaround this problem fix and improve existing cifs silly rename
code and extend it also to SMB2 and SMB3 dialects when communicating
with Windows SMB servers. Silly rename is applied only when it is
necessary (when some other client has opened file or directory).
If no other client has the file / dir open then silly rename is not
used.

With this patch series, after successful rmdir() or unlink() call from
Linux userspace application, the path is released, it is not visible in
the followup readdir() call, also stat() properly returns ENOENT and it
is possible to call creat() or mkdir() on the same path to create new
node. Silly rename is used to ensure that path is released.

Before this change, the original path was visible in the readdir() call
and create() or mkdir() was failing with EEXIST, even rmdir() or
unlink() on that path returned success.


Test cases when "path" is opened on Windows server by other client, so
path cannot be removed.

1.
  unlink("path");
  mkdir("path");

  before: unlink returns success but mkdir returns EEXIST.
  after: unlink returns success, mkdir creates new directory and the
  orignal one is silly renamed.

2.
  unlink("path")
  open("path") without O_CREAT
  mkdir("path")

  before: unlink returns success, open returns ENOENT and mkdir returns
  EEXIST.
  after: unlink returns success, open returns ENOENT, mkdir creates
  new directory and the original path is silly renamed.

3.
  unlink("path")
  stat("path")
  mkdir("path")

  before: unlink returns success, stat returns ENOENT and mkdir returns
  EEXIST.
  after: unlink returns success, stat returns ENOENT, mkdir creates new
  directory and the original path is silly renamed.

4.
  unlink("path")
  stat("path")
  open("path") with O_CREAT | O_EXCL

  before: unlink returns success, stat returns ENOENT and open returns
  EEXIST.
  after: unlink returns success, stat returns ENOENT, open creates new
  file and the original path is silly renamed.

5.
  unlink("path")
  readdir("parent_of_path")

  before: unlink returns success but readdir returns entry corresponding
  to path.
  after: unlink returns success, original path is silly renamed and
  readdir returns the entry under new silly name.


Test case when "tmp_path" on the Windows server was created (or opened)
as a exclusive temporary file with the DELETE_PENDING flag set:

Before:

  stat("tmp_path") - returns ENOENT
  mkdir("tmp_path") - returns EEXIST
  open("tmp_path") without O_CREAT - returns ENOENT
  open("tmp_path") with O_CREAT | O_EXCL - return EEXIST
  unlink("tmp_path") - returns ENOENT
  readdir(parent_of_tmp_path) - returns the "tmp_path" entry

After:

  stat("tmp_path") - success
  mkdir("tmp_path") - returns EEXIST
  open("tmp_path") without O_CREAT - returns EBUSY
  open("tmp_path") with O_CREAT | O_EXCL - return EEXIST
  unlink("tmp_path") - returns EBUSY
  readdir(parent_of_tmp_path) - returns the "tmp_path" entry

The difference is in stat(), open() and unlink() syscalls. Now Linux
applications can stat such files, so file attributes are now visible in
"ls -l -a" output, but trying to open / modify / delete them fails with
EBUSY instead of ENOENT.


Pali Rohár (35):
  cifs: Fix and improve cifs_is_path_accessible() function
  cifs: Allow fallback code in smb_set_file_info() also for directories
  cifs: Add fallback code path for cifs_mkdir_setinfo()
  cifs: Remove code for querying FILE_INFO_STANDARD via
    CIFSSMBQPathInfo()
  cifs: Remove CIFSSMBSetPathInfoFB() fallback function
  cifs: Remove cifs_backup_query_path_info() and replace it by
    cifs_query_path_info()
  cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY
  cifs: Improve SMB2+ stat() to work also for paths in DELETE_PENDING
    state
  cifs: Improve SMB1 stat() to work also for paths in DELETE_PENDING
    state
  cifs: Improve detect_directory_symlink_target() function
  cifs: Fix random name construction for cifs_rename_pending_delete()
  cifs: Fix DELETE comments in cifs_rename_pending_delete()
  cifs: Avoid dynamic memory allocation of FILE_BASIC_INFO buffer in
    cifs_rename_pending_delete()
  cifs: Extend CIFSSMBRenameOpenFile() function for overwrite parameter
  cifs: Do not try to overwrite existing sillyname in
    cifs_rename_pending_delete()
  cifs: Add comments for DeletePending assignments in open functions
  cifs: Use NT_STATUS_DELETE_PENDING for filling fi.DeletePending in
    cifs_query_path_info()
  cifs: Do not set NumberOfLinks to 1 from open or query calls
  cifs: Fix cifs_rename_pending_delete() for files with more hardlinks
  cifs: Fix permission logic in cifs_rename_pending_delete()
  cifs: Propagate error code from CIFSSMBSetFileInfo() to
    cifs_rename_pending_delete()
  cifs: Improve cifs_rename_pending_delete() to work without the
    PASSTHRU support
  cifs: Fix SMBLegacyOpen() function
  cifs: Add a new callback set_file_disp() for setting file disposition
    (delete pending state)
  cifs: Add a new callback rename_opened_file() for renaming an opened
    file
  cifs: Add SMB2+ support into cifs_rename_pending_delete() function.
  cifs: Move SMB1 usage of CIFSPOSIXDelFile() from inode.c to cifssmb.c
  cifs: Fix smb2_unlink() to fail on directory
  cifs: Fix smb2_rmdir() on reparse point
  cifs: Simplify SMB2_OP_DELETE API usage
  cifs: Deduplicate smb2_unlink() and smb2_rmdir() into one common
    function
  cifs: Use cifs_rename_pending_delete() fallback also for rmdir()
  cifs: Add a new open flag CREATE_OPTION_EXCLUSIVE to open with deny
    all shared reservation
  cifs: Use CREATE_OPTION_EXCLUSIVE when opening file/dir for SMB2+
    non-POSIX unlink/rmdir
  cifs: Use CREATE_OPTION_EXCLUSIVE when doing SMB1 rmdir on NT server

 fs/smb/client/cifsglob.h     |  11 +-
 fs/smb/client/cifspdu.h      |   5 +
 fs/smb/client/cifsproto.h    |   6 +-
 fs/smb/client/cifssmb.c      | 228 +++++++++++++----------
 fs/smb/client/inode.c        | 346 ++++++++++++++++-------------------
 fs/smb/client/netmisc.c      |   2 +-
 fs/smb/client/reparse.c      |  75 +++-----
 fs/smb/client/smb1ops.c      |  84 +++++++--
 fs/smb/client/smb2glob.h     |   1 +
 fs/smb/client/smb2inode.c    | 264 +++++++++++++++++++++++---
 fs/smb/client/smb2maperror.c |   2 +-
 fs/smb/client/smb2ops.c      |  24 +++
 fs/smb/client/smb2pdu.c      |  51 +++++-
 fs/smb/client/smb2proto.h    |   6 +
 14 files changed, 704 insertions(+), 401 deletions(-)

-- 
2.20.1

