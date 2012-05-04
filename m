From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 4 May 2012 15:59:16 -0500
Message-ID: <CAH2r5ms1W=dxF98gGCm6_+t0sEZCFsWJpvyyhUgV4XCssSFjWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit b821861b905a79f71746945237968c3382d99adc:

  Merge tag 'ktest-for-v3.4-rc5' of
git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest
(2012-05-01 19:43:34 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Ian Kent (1):
      cifs - check S_AUTOMOUNT in revalidate

Jeff Layton (3):
      cifs: don't cap ra_pages at the same level as default_backing_dev_info
      cifs: add missing initialization of server->req_lock
      cifs: make sure we ignore the credentials= and cred= options

Sachin Prabhu (1):
      CIFS: Fix indentation in cifs_show_options

Stefan Metzmacher (1):
      fs/cifs: fix parsing of dfs referrals

Steve French (1):
      [CIFS] Update cifs version to 1.78

 fs/cifs/cifsfs.c  |    2 +-
 fs/cifs/cifsfs.h  |    2 +-
 fs/cifs/cifssmb.c |    6 +++++-
 fs/cifs/connect.c |   21 ++++-----------------
 fs/cifs/dir.c     |   17 ++++++++++++-----
 5 files changed, 23 insertions(+), 25 deletions(-)

-- 
Thanks,

Steve
