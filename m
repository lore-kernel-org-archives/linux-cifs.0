From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Fri, 21 Sep 2012 23:49:22 -0500
Message-ID: <CAH2r5mvnj1dpCjH2ZODcTBUCtwoZMYbgC=Lj=6kcw17=6SKArw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 4651afbbae968772efd6dc4ba461cba9b49bb9d8:
  Linus Torvalds (1):
        Merge branch 'for-3.6-fixes' of git://git.kernel.org/.../tj/wq

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-linus

Jeff Layton (1):
      cifs: fix return value in cifsConvertToUTF16

 fs/cifs/cifs_unicode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
Thanks,

Steve
