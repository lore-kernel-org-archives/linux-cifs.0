From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [GIT] CIFS Fixes
Date: Fri, 9 Nov 2012 22:39:43 -0600
Message-ID: <CAH2r5mtYsEMbZDfgHntKT0CjAwiT4dUKo55wmEhpVNqbS=bqrg@mail.gmail.com>
References: <CAH2r5msoaCqyoz4wQb_jhuQVySOJY33V08X30TrZhYMAdRWhDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msoaCqyoz4wQb_jhuQVySOJY33V08X30TrZhYMAdRWhDg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Nov 9, 2012 at 8:48 PM
Subject: [GIT] CIFS Fixes
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


The following changes since commit 0f89a5733a8d28174c7adeb1fdc20ac11439e766:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-11-02
20:48:41 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 3798f47aa276b332c30da499cb4df4577e2f8872:

  cifs: Do not lookup hashed negative dentry in cifs_atomic_open (2012-11-05
06:45:54 -0500)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code

Sachin Prabhu (1):
      cifs: Do not lookup hashed negative dentry in cifs_atomic_open

 fs/cifs/cifsacl.c | 49 ++++++++++++++++++++-----------------------------
 fs/cifs/dir.c     | 11 ++++++++++-
 2 files changed, 30 insertions(+), 30 deletions(-)

--
Thanks,

Steve



--
Thanks,

Steve
