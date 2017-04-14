From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 fixes
Date: Fri, 14 Apr 2017 11:01:01 -0500
Message-ID: <CAH2r5msvKz_N-Kycse86hwjsC_3p8+WqA82-1C0diNZ=FEiu9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As promised, here is the remaining set of cifs/smb3 fixes for stable
(and a fix for one regression) now that they have had additional
review and testing.  Please pull the following changes since commit
c08e611b7d0169b513e3b4515ffd51ac7f37f22c:

  Merge branch 'linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
(2017-04-10 09:37:43 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 67dbea2ce6873f8ba57988ba3e608e8bf61c347f:

  CIFS: Fix SMB3 mount without specifying a security mechanism
(2017-04-13 10:03:26 -0500)

----------------------------------------------------------------
Germano Percossi (3):
      CIFS: reconnect thread reschedule itself
      CIFS: remove bad_network_name flag
      CIFS: store results of cifs_reopen_file to avoid infinite wait

Mark Syms (1):
      CIFS: handle guest access errors to Windows shares

Pavel Shilovsky (2):
      CIFS: Fix null pointer deref during read resp processing
      CIFS: Fix SMB3 mount without specifying a security mechanism

 fs/cifs/cifsglob.h  |  1 -
 fs/cifs/cifsproto.h |  3 +--
 fs/cifs/cifssmb.c   | 15 ++++++++-------
 fs/cifs/connect.c   |  3 +++
 fs/cifs/file.c      |  6 +++---
 fs/cifs/smb2ops.c   |  4 ++--
 fs/cifs/smb2pdu.c   | 19 ++++++++++++-------
 7 files changed, 29 insertions(+), 22 deletions(-)

-- 
Thanks,

Steve
