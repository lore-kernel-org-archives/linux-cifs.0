From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Fri, 27 May 2011 16:02:55 -0500
Message-ID: <BANLkTimujC6OABE9A65_Mv3q_2GE80PPdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit e52e713ec30a31e9a4663d9aebbaae5ec07466a6:

  Merge branch 'docs-move' of
git://git.kernel.org/pub/scm/linux/kernel/git/rdunlap/linux-docs
(2011-05-27 10:25:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Steve French (1):
      [CIFS] Follow on to cifsacl endian patch (__constant_cpu_to_le32
was required)

 fs/cifs/cifsacl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


-- 
Thanks,

Steve
