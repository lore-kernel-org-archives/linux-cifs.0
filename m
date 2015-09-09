From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GiT] CIFS Fixes
Date: Tue, 8 Sep 2015 23:22:25 -0500
Message-ID: <CAH2r5mvkcq1S8iLEZDNmvZiFpiEJT5fBo_g2zg_VQ2KRMLtrhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Small cifs fix and a patch for improved debugging.
Please pull the following changes since commit
1b647a166f07dcf08709c8606470f4b17a4aa11d:

  Merge tag 'dmaengine-fix-4.2-rc8' of
git://git.infradead.org/users/vkoul/slave-dma (2015-08-18 12:17:36
-0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 5fb4e288a025af1abc5c67ecebf30fbf6b3edad1:

  cifs: Fix use-after-free on mid_q_entry (2015-08-20 10:19:25 -0500)

----------------------------------------------------------------
Christopher Oo (1):
      cifs: Fix use-after-free on mid_q_entry

Steve French (2):
      Add way to query server fs info for smb3
      Update cifs version number

 fs/cifs/cifs_ioctl.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.h     |  2 +-
 fs/cifs/cifspdu.h    | 14 ++++++++++++++
 fs/cifs/cifssmb.c    |  7 +++++++
 fs/cifs/ioctl.c      | 48 ++++++++++++++++++++++++++++++++++++++++++------
 fs/cifs/smb2pdu.c    |  7 +++++++
 fs/cifs/transport.c  |  2 ++
 7 files changed, 115 insertions(+), 7 deletions(-)
 create mode 100644 fs/cifs/cifs_ioctl.h

-- 
Thanks,

Steve
