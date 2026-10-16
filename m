Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DE545039;
	Fri, 16 Oct 2026 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792194767; cv=none; b=YEXdt5ibb9FEtLQqh4QGRZQUZ+Io06+4Ow18O4uYgDzPoKGH5TUQQLjxkRG2T1pA5TcXI/jZCA82gkeiAN5Mb+hTiEiZsX58DbhZpDUPIut53wp7MnVuFF6KFEryTiaIO7iBcnFQsXzgF2xD9+I9JKkqHMFelQZmwMvLc+5xRfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792194767; c=relaxed/simple;
	bh=QXilKyRqJrwNMzcX7XioD1gEYG2j2+eesqh+yf+HYU4=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=GlLn/hdlp89nv9crw+xiMOjnFI9YJ/F4/ONWjzLP2mnnADZHgFdYPZoTuH6qJWgYNRMfayEy3t+4GrGRf8asaQe/u7uTfz6jYTQjTfdHweCpKwg7mwp3GkT/qA56gPH8JN7Ww/cY6r2Sj6kjIQR58NrQfEaZTyKLw2XBbMOjHvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=yqe0fViP; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="yqe0fViP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:Subject:Cc:To:From:
	Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=aGtv9OjoqZMn1pYmcItOtLJ0759sNOoF1i5JiX/CXbs=; b=yqe0fViP+IiKkRAbNTNjoRbvlY
	mlITTZtVhZq83KAWVsfAbeTWJdHa1f5wX9yTSpGVgK3+pGn/rCxUMZeHJBunADNz3/vTwyLSrzSDH
	ERK8A7wAmiymda9Ri5rZM7EZq26/Dt19LDeZavumh3o3kYCqmkngN/X4WGNE/qA2FVOlrvJE6ufkN
	SvL7i/kQTwC1J0ijus3sj8Qi43h7NwVFhNBs2ZBNkcchPFvN0eqnKCeDvgNV/h2ITdS03V10SmVA/
	n6PivAV6IXTAJNQCAoXH+HWw5DNqq8DiOcWFCGhML0ZDswgMKJErqqSsUgyNXwvlwUOp64W+6nfju
	koD95p6A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xHrj8-00000003pDj-1oWX;
	Fri, 16 Oct 2026 20:52:42 -0300
Message-ID: <fcf60d2f4382fc7ccd77ea41c5e55b50@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Mark Brown <broonie@kernel.org>,
 linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] smb client changes for v7.4
Date: Fri, 16 Oct 2026 20:52:42 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Linus,

Please pull the following smb client changes for v7.4.  These are mostly
cleanups, a number of fixes (crashes, out-of-bounds reads and
data-integrity bugs), support for changing SMB compression through
chattr and internal CIFS version removal.

This conflicts with the vfs tree in fs/smb/client (mnt_idmap
constification, fscache_resize_cookie() and transport.c).  The
resolution is trivial and linux-next has been carrying it for a while.

Thanks,
Paulo

----------------------------------------------------------------
The following changes since commit ff47652a4b66c067c765a7ad464d930b5a9367cc:

  Merge tag 'cifs-fixes-7.3-rc6' of https://git.manguebit.org/linux (2026-10-02 14:04:11 -0700)

are available in the Git repository at:

  https://git.manguebit.org/linux.git tags/cifs-for-7.4

for you to fetch changes up to 78f73985846465a25a7bd1d89904053661f3ca92:

  smb: client: reclaim credits for decrypted reads with no matching mid (2026-10-15 16:45:30 -0300)

----------------------------------------------------------------
 - Implement ->fileattr_set so chattr(1) compression changes (chattr +c/-c)
   go through the generic VFS fileattr path and its permission and
   serialization checks instead of the raw FS_IOC_SETFLAGS fallback and
   remove the now-unreachable file flags ioctl handlers

 - Require stable pages when the connection is signed or SMB compression is
   enabled, so a buffered write can no longer modify a folio that is still in
   flight and corrupt its signature (surfaced as -EIO) or, with compression,
   silently corrupt the data stored on the server

 - Stop breaking a file's just-granted lease while probing it for a
   Minshall+French symlink, by reusing an already open handle or opening with
   the inode's lease key

 - Fix several out-of-bounds reads and use-after-free bug in SMB1

 - Fix an use-after-free bug in cifs_ses_add_channel()

 - Fix a NULL pointer dereference in the demultiplex thread when an encrypted
   read response matches no outstanding request and reclaim the credits
   granted on such responses to avoid starving the connection of credits

 - Fail sends fast when the connection needs to reconnect

 - Drop the redundant nls_table argument threaded through the session setup,
   tree connect and path-based call paths, allocate the session setup state
   on the stack and remove the internal CIFS version number along with a
   batch of write-only fields and commented-out code

----------------------------------------------------------------
Diego Oliva (7):
      smb: client: fix use-after-free infoleak via the readdir resume name
      smb: client: fix OOB last_entry pointer from unbounded LastNameOffset
      smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2
      smb: client: fix OOB read in the SMB_FIND_FILE_UNIX name scan
      smb: client: reject FIND data areas that run past the received response
      smb: client: reject short or out-of-range FIND response parameters
      smb: client: drop the redundant name bounds in cifs_filldir()

Enzo Matsumiya (1):
      smb: client: fast fail sends if need to reconnect

Henry Martin (1):
      smb: client: fix use-after-free in cifs_ses_add_channel()

Huiwen He (2):
      smb: client: implement fileattr_set for compression flags
      smb: client: remove unused file flags ioctl handlers

Paulo Alcantara (49):
      smb: client: rename mfsymlink helpers to the smb2_ prefix
      smb: client: set lease_granted before revalidating inode in cifs_nt_open()
      smb: client: avoid breaking the file lease when probing mfsymlinks
      smb: client: log the selected security type on session setup failure
      smb: client: remove commented-out ntlmv2_support definition
      smb: client: remove commented-out i_flags assignment
      smb: client: remove commented-out cancel_*_requests() calls
      smb: client: remove commented-out oplock assignment
      smb: client: remove commented-out write debug message
      smb: client: remove commented-out LOCK_RSP declaration
      smb: client: remove commented-out QPathInfo debug message
      smb: client: remove commented-out CIFSSMBWinSetPerms() call
      smb: client: remove commented-out time conversion debug message
      smb: client: remove commented-out Unix caps assignment
      smb: client: clean up cifs_buf_release()
      smb: client: remove the internal CIFS version number
      smb: client: remove unused overrideSecFlg from struct cifs_ses
      smb: client: remove write-only max_rw from TCP_Server_Info
      smb: client: remove write-only sec_kerberosu2u from TCP_Server_Info
      smb: client: remove write-only signing_negotiated from TCP_Server_Info
      smb: client: remove unused num_acl_set stat from cifs_tcon
      smb: client: size smb2_compound_vars.qi_iov for the padding iov
      smb: client: drop redundant nls_table arg from SMBSetInformation()
      smb: client: drop redundant nls_table arg from CIFSSMBSetPathInfo()
      smb: client: drop redundant nls_table arg from ->set_EA()
      smb: client: drop redundant nls_table arg from build_avpair_blob()
      smb: client: drop redundant nls_table arg from calc_ntlmv2_hash()
      smb: client: drop redundant nls_table arg from setup_ntlmv2_rsp()
      smb: client: drop redundant nls_table arg from build_ntlmssp_negotiate_blob()
      smb: client: drop redundant nls_table arg from build_ntlmssp_smb3_negotiate_blob()
      smb: client: drop redundant nls_table arg from build_ntlmssp_auth_blob()
      smb: client: drop unused nls_table arg from ascii_oslm_strings()
      smb: client: drop redundant nls_table arg from unicode_domain_string()
      smb: client: drop unused nls_table arg from ascii_domain_string()
      smb: client: drop redundant nls_table arg from unicode_ssetup_strings()
      smb: client: drop unused nls_table arg from ascii_ssetup_strings()
      smb: client: drop redundant nls_table arg from decode_unicode_ssetup()
      smb: client: drop unused nls_table arg from decode_ascii_ssetup()
      smb: client: drop redundant nls_table arg from ->sess_setup()
      smb: client: drop redundant nls_table arg from cifs_setup_session()
      smb: client: drop redundant nls_table arg from ->tree_connect()
      smb: client: drop redundant nls_table arg from CIFSPOSIXDelFile()
      smb: client: drop redundant nls_table arg from CIFSPOSIXCreate()
      smb: client: drop redundant nls_table arg from SMBLegacyOpen()
      smb: client: drop redundant nls_table arg from CIFSSMBRenameOpenFile()
      smb: client: allocate struct sess_data on the stack
      smb: client: allocate struct SMB2_sess_data on the stack
      smb: client: require stable pages for SMB compression
      smb: client: reclaim credits for decrypted reads with no matching mid

Zikang Gao (1):
      smb: client: do not pass a NULL buf to is_oplock_break()

 fs/smb/client/asn1.c        |   2 -
 fs/smb/client/cifs_debug.c  |   1 -
 fs/smb/client/cifsencrypt.c |  31 +++--
 fs/smb/client/cifsfs.c      |  11 +-
 fs/smb/client/cifsfs.h      |   5 +-
 fs/smb/client/cifsglob.h    |  26 ++---
 fs/smb/client/cifsproto.h   |  19 +--
 fs/smb/client/cifssmb.c     | 183 +++++++++++++++++------------
 fs/smb/client/connect.c     |  59 +++++++---
 fs/smb/client/dfs.c         |   6 +-
 fs/smb/client/dir.c         |   1 -
 fs/smb/client/file.c        |   7 +-
 fs/smb/client/inode.c       |  36 +++---
 fs/smb/client/ioctl.c       | 165 ++++++++++++--------------
 fs/smb/client/link.c        | 273 ++++++++++++++++++++++++++++++++------------
 fs/smb/client/misc.c        |   4 +-
 fs/smb/client/netmisc.c     |   3 -
 fs/smb/client/ntlmssp.h     |  11 +-
 fs/smb/client/readdir.c     |  80 +++++++++----
 fs/smb/client/sess.c        |  37 +++---
 fs/smb/client/smb1ops.c     |  14 +--
 fs/smb/client/smb1proto.h   |  21 ++--
 fs/smb/client/smb1session.c | 120 +++++++++----------
 fs/smb/client/smb2glob.h    |   8 ++
 fs/smb/client/smb2inode.c   |   7 +-
 fs/smb/client/smb2ops.c     |  36 +++---
 fs/smb/client/smb2pdu.c     |  66 +++++------
 fs/smb/client/smb2pdu.h     |   3 +
 fs/smb/client/smb2proto.h   |  17 ++-
 fs/smb/client/trace.h       |   2 +
 fs/smb/client/transport.c   |  33 ++++++
 fs/smb/client/xattr.c       |   2 +-
 32 files changed, 740 insertions(+), 549 deletions(-)
