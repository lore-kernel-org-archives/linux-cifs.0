From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 20 May 2016 19:07:48 -0500
Message-ID: <CAH2r5mtJgL+fSGQ6aKR05rAjgr3T+RQOsu56UQSfLC6egcAOtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two small cifs fixes, including one spnego upcall cifs security fix for stable

Please pull the following changes since commit
03b979dd0323ace8e29a0561cd5232f73a060c09:

  Merge tag 'please-pull-misc-4.7' of
git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux (2016-05-19
18:14:49 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 48a77aa7e20557319205f9bd4cc02d4b67b5f761:

  CIFS: Remove some obsolete comments (2016-05-19 21:56:34 -0500)

----------------------------------------------------------------
Sachin Prabhu (1):
      cifs: Create dedicated keyring for spnego operations

Steve French (1):
      CIFS: Remove some obsolete comments

 fs/cifs/cifs_spnego.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.c      | 11 +++------
 fs/cifs/cifsproto.h   |  2 ++
 3 files changed, 72 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
