From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 7 Jan 2013 14:38:45 -0600
Message-ID: <CAH2r5msAo_AX-Z9V4BWCTPVjHDTnycpCQoH=wPfj5j7sr1WQZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Misc. small cifs fixes.

The following changes since commit ecccd1248d6e6986130ffcc3b0d003cb46a485c0:
  Zlatko Calusic (1):
        mm: fix null pointer dereference in wait_iff_congested()

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (2):
      cifs: move check for NULL socket into smb_send_rqst
      cifs: adjust sequence number downward after signing NT_CANCEL request

Pavel Shilovsky (3):
      Revert "CIFS: Fix write after setting a read lock for read oplock files"
      CIFS: Fix write after setting a read lock for read oplock files
      CIFS: Don't let read only caching for mandatory byte-range locked files

 fs/cifs/cifsfs.c    |    1 -
 fs/cifs/cifsglob.h  |    2 +-
 fs/cifs/file.c      |  141 +++++++++++++++++++++++++++-----------------------
 fs/cifs/smb1ops.c   |    8 +++
 fs/cifs/smb2ops.c   |    2 +
 fs/cifs/transport.c |    6 +-
 6 files changed, 90 insertions(+), 70 deletions(-)

-- 
Thanks,

Steve
