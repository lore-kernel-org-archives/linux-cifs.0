From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sat, 26 Sep 2015 22:32:30 -0500
Message-ID: <CAH2r5mut2makH7q0coedc3w56ovFuAqjh9eyLUN_cu5BcsE3XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

4 fixes from testing at the recent SMB3 Plugfest including two
important authentication ones (one fixes authentication problems to
some popular servers when clock times differ more than two hours
between systems, the other fixes Kerberos authentication for SMB3).

Please pull the following changes since commit
bcee19f424a0d8c26ecf2607b73c690802658b29:

  Merge branch 'for-4.3-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup (2015-09-21
18:26:54 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 88627148400e37b4bff197285d348fc05c9de013:

  fix encryption error checks on mount (2015-09-24 00:53:31 -0500)

----------------------------------------------------------------
Peter Seiderer (1):
      cifs: use server timestamp for ntlmv2 authentication

Steve French (3):
      disabling oplocks/leases via module parm enable_oplocks broken for SMB3
      [SMB3] Fix sec=krb5 on smb3 mounts
      fix encryption error checks on mount

 fs/cifs/cifsencrypt.c | 53 ++++++++++++++++++++++++++++++--
 fs/cifs/smb2ops.c     |  8 +++--
 fs/cifs/smb2pdu.c     | 84 ++++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 126 insertions(+), 19 deletions(-)

-- 
Thanks,

Steve
