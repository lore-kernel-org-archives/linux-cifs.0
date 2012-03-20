From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: pull request
Date: Tue, 20 Mar 2012 15:30:59 +0400
Message-ID: <CAKywueTDvzmHzwApV3gqSa4MrS-tPiWDORorDk0fe_NtgT_wZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit ce85852b90a214cf577fc1b4f49d99fd7e98784a:

  CIFS: Fix a spurious error in cifs_push_posix_locks (2012-03-19
10:20:22 -0500)

are available in the git repository at:
  git://git.altlinux.org/people/piastry/public/cifs-2.6.git cifs-patches

Pavel Shilovsky (17):
      CIFS: Respect negotiated MaxMpxCount
      CIFS: Simplify inFlight logic
      CIFS: Introduce credit-based flow control
      CIFS: Make wait_for_free_request killable
      CIFS: Prepare credits code for a slot reservation
      CIFS: Delete echo_retries module parm
      CIFS: Separate protocol-specific code from transport routines
      CIFS: Separate protocol-specific code from demultiplex code
      CIFS: Separate protocol-specific code from cifs_readv_receive code
      CIFS: Expand CurrentMid field
      CIFS: Change mid_q_entry structure fields
      CIFS: Move locks to file structure
      CIFS: Fix VFS locks usage
      CIFS: Convert lock type to 32 bit variable
      CIFS: Separate protocol specific lock type handling
      CIFS: Separate protocol specific part from getlk
      CIFS: Separate protocol specific part from setlk

 fs/cifs/README       |    6 +-
 fs/cifs/cifs_debug.c |   28 +++---
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsfs.c     |   14 +--
 fs/cifs/cifsglob.h   |   84 ++++++++++----
 fs/cifs/cifsproto.h  |   14 ++-
 fs/cifs/cifssmb.c    |  109 +++++++++++--------
 fs/cifs/connect.c    |  129 +++++++++++-----------
 fs/cifs/dir.c        |    6 +-
 fs/cifs/file.c       |  254 ++++++++++++++++++++++++++++++------------
 fs/cifs/misc.c       |  117 ++++++++++++-------
 fs/cifs/netmisc.c    |    3 +-
 fs/cifs/transport.c  |  305 ++++++++++++++++++++++++++++----------------------
 13 files changed, 651 insertions(+), 422 deletions(-)


-- 
Best regards,
Pavel Shilovsky.
