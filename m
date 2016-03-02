From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 2 Mar 2016 08:27:49 -0600
Message-ID: <CAH2r5mu43Xa4WbPLYxRN1+Rv2HzL48sfZbeJU+FL+fw6Hh=0=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Various small CIFS/SMB3 fixes for stable.   Fixes address
oops that can occur when accessing Macs with SMB3, and
another problem found to Samba when read responses queued
(e.g. with gluster under Samba)

Please pull the following changes since commit
fc77dbd34c5c99bce46d40a2491937c3bcbd10af:

  Linux 4.5-rc6 (2016-02-28 08:41:20 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 9589995e46d89c70c6fa4723c5f3e5ec04c3c3e3:

  CIFS: Fix duplicate line introduced by clone_file_range patch
(2016-03-01 09:38:00 -0600)

----------------------------------------------------------------
Justin Maggard (1):
      cifs: fix out-of-bounds access in lease parsing

Pavel Shilovsky (1):
      CIFS: Fix SMB2+ interim response processing for read requests

Steve French (1):
      CIFS: Fix duplicate line introduced by clone_file_range patch

Yadan Fan (1):
      Fix cifs_uniqueid_to_ino_t() function for s390x

 fs/cifs/cifsfs.c  |  1 -
 fs/cifs/cifsfs.h  | 12 ++++--------
 fs/cifs/cifssmb.c | 21 ++++++++++++++++++---
 fs/cifs/smb2pdu.c | 24 ++++++++++++++----------
 4 files changed, 36 insertions(+), 22 deletions(-)

-- 
Thanks,

Steve
