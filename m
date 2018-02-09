From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT][SMB3] A few small SMB3 fixes
Date: Fri, 9 Feb 2018 11:41:59 -0600
Message-ID: <CAH2r5msKkKG-B4RH97NwuBVv3Tb-eaz3fWFs+HjBn3-6WGhpBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
617aebe6a97efa539cc4b8a52adccd89596e6be0:

  Merge tag 'usercopy-v4.16-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux (2018-02-03
16:25:42 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/4.16-minor-rc-SMB3-fixes

for you to fetch changes up to 5f60a56494ea5518376b274dd93b3ceee9a783fb:

  Add missing structs and defines from recent SMB3.1.1 documentation
(2018-02-07 09:36:46 -0600)

----------------------------------------------------------------
4.16 minor SMB3 fixes

There are a couple additional security fixes that are still being tested
that are not in this set.

----------------------------------------------------------------
Arnd Bergmann (1):
      cifs: silence compiler warnings showing up with gcc-8.0.0

Steve French (3):
      Add some missing debug fields in server and tcon structs
      address lock imbalance warnings in smbdirect.c
      Add missing structs and defines from recent SMB3.1.1 documentation

 fs/cifs/cifs_debug.c |   9 +++-
 fs/cifs/cifssmb.c    |   4 +-
 fs/cifs/smb2pdu.h    | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smbdirect.c  |  16 ++++----
 4 files changed, 130 insertions(+), 13 deletions(-)

-- 
Thanks,

Steve
