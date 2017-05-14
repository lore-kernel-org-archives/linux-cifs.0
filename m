From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 14 May 2017 09:51:07 -0500
Message-ID: <CAH2r5mtx+GhrgJpnpf=1nYC_8TMsSGF24i2BodS7e4ezAnJOsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
56868a460b83c0f93d339256a81064d89aadae8e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide
(2017-05-09 15:56:58 -0700)

A set of minor cifs fixes are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 67b4c889cc835a2a6e2ff4e20544a33e37e2875d:

  [CIFS] Minor cleanup of xattr query function (2017-05-12 20:59:10 -0500)

----------------------------------------------------------------
Christophe JAILLET (1):
      SMB2: Fix share type handling

Joe Perches via samba-technical (1):
      cifs: cifsacl: Use a temporary ops variable to reduce code length

Karim Eshapa (1):
      fs: cifs: transport: Use time_after for time comparison

Rabin Vincent (1):
      CIFS: silence lockdep splat in cifs_relock_file()

Steve French (2):
      Don't delay freeing mids when blocked on slow socket write of request
      [CIFS] Minor cleanup of xattr query function

 fs/cifs/cifsacl.c   | 30 ++++++++++++++----------------
 fs/cifs/cifsglob.h  |  2 +-
 fs/cifs/cifsproto.h |  3 +--
 fs/cifs/cifssmb.c   | 11 +++--------
 fs/cifs/file.c      |  2 +-
 fs/cifs/inode.c     |  3 +--
 fs/cifs/smb2pdu.c   | 21 +++++++++------------
 fs/cifs/transport.c |  4 +---
 fs/cifs/xattr.c     |  6 ++----
 9 files changed, 33 insertions(+), 49 deletions(-)

-- 
Thanks,

Steve
