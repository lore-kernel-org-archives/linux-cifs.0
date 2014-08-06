From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Updates
Date: Wed, 6 Aug 2014 09:56:57 -0500
Message-ID: <CAH2r5mtzhoaePY9MQEMnfywY7Lwxg_nG9yhzH9pHuhg14O5u=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Most visible change in this set is the additional of multi-credit
support for SMB2/SMB3 which dramatically improves the
large file i/o performance for these dialects and significantly
increases the maximum i/o size used on the wire for SMB2/SMB3.
Also reconnection behavior after network failure is improved.

The following changes since commit 6f0928036bcbd8dd2ebee9201580da8bcc0a81af:

  Merge tag 'pm+acpi-3.16-rc8' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
(2014-07-31 16:42:10 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to f29ebb47d5bb59ef246966b047356c03629a9705:

  Add worker function to set allocation size (2014-08-05 12:53:37 -0500)

----------------------------------------------------------------
Pavel Shilovsky (24):
      CIFS: Fix async reading on reconnects
      CIFS: Separate page processing from writepages
      CIFS: Separate page sending from writepages
      CIFS: Separate pages initialization from writepages
      CIFS: Fix wsize usage in writepages
      CIFS: Fix cifs_writev_requeue when wsize changes
      CIFS: Separate filling pages from iovec write
      CIFS: Separate writing from iovec write
      CIFS: Fix wsize usage in iovec write
      CIFS: Use multicredits for SMB 2.1/3 writes
      CIFS: Separate page search from readpages
      CIFS: Fix rsize usage in readpages
      CIFS: Separate page reading from user read
      CIFS: Fix rsize usage in user read
      CIFS: Fix rsize usage for sync read
      CIFS: Use multicredits for SMB 2.1/3 reads
      CIFS: Indicate reconnect with ECONNABORTED error code
      CIFS: Use separate var for the number of bytes got in async read
      CIFS: Count got bytes in read_into_pages()
      CIFS: Fix possible buffer corruption in cifs_user_read()
      CIFS: Improve indentation in cifs_user_read()
      CIFS: Optimize cifs_user_read() in a short read case on reconnects
      CIFS: Optimize readpages in a short read case on reconnects
      CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2

Sachin Prabhu (5):
      cifs: replace code with free_rsp_buf()
      cifs: Split lanman auth from CIFS_SessSetup()
      cifs: Split ntlm and ntlmv2 authentication methods off CIFS_SessSetup()
      cifs: Split Kerberos authentication off CIFS_SessSetup()
      cifs: Separate rawntlmssp auth from CIFS_SessSetup()

Steve French (6):
      Remove sparse build warning
      Update cifs version
      Add Pavel to contributor list in cifs AUTHORS file
      update CIFS TODO list
      [CIFS] Fix incorrect hex vs. decimal in some debug print statements
      Add worker function to set allocation size

 Documentation/filesystems/cifs/AUTHORS |    1 +
 Documentation/filesystems/cifs/TODO    |   97 +--
 fs/cifs/cifs_debug.c                   |    2 +-
 fs/cifs/cifsfs.h                       |    2 +-
 fs/cifs/cifsglob.h                     |   19 +
 fs/cifs/cifsproto.h                    |    4 +
 fs/cifs/cifssmb.c                      |  119 ++--
 fs/cifs/connect.c                      |    8 +-
 fs/cifs/file.c                         |  872 ++++++++++++++---------
 fs/cifs/misc.c                         |   13 +-
 fs/cifs/sess.c                         | 1192 ++++++++++++++++++++++----------
 fs/cifs/smb1ops.c                      |    8 +
 fs/cifs/smb2inode.c                    |    2 +-
 fs/cifs/smb2maperror.c                 |    2 +-
 fs/cifs/smb2misc.c                     |    6 +-
 fs/cifs/smb2ops.c                      |   73 +-
 fs/cifs/smb2pdu.c                      |   94 ++-
 fs/cifs/smb2proto.h                    |    2 +-
 fs/cifs/smb2transport.c                |    5 +
 fs/cifs/transport.c                    |   25 +-
 20 files changed, 1702 insertions(+), 844 deletions(-)

-- 
Thanks,

Steve
