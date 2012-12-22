From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [GIT] CIFS Fixes
Date: Fri, 21 Dec 2012 20:46:18 -0600
Message-ID: <CAH2r5mvxsmPouS9ZFU9A1sw1RXG3ChYbjVY=g2-+Bs+vUcCazw@mail.gmail.com>
References: <CAH2r5msYO-rzAgtNZ-ALM7+ukGa8XwWUiPhhBkk=t=ROuNV7cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msYO-rzAgtNZ-ALM7+ukGa8XwWUiPhhBkk=t=ROuNV7cw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Dec 21, 2012 at 5:18 PM
Subject: [GIT] CIFS Fixes
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Misc. small cifs fixes

The following changes since commit 1800098549fc310cffffefdcb3722adaad0edda8:

  ARM: OMAP: Fix build breakage due to missing include in i2c.c (2012-12-20
08:43:25 -0800)

are available in the git repository at:
  git://git.samba.org/sfrench/cifs-2.6.git for-next

Jeff Layton (3):
      cifs: fix double-free of "string" in cifs_parse_mount_options
      cifs: don't compare uniqueids in cifs_prime_dcache unless server inode
numbers are in use
      cifs: eliminate cifsERROR variable

 fs/cifs/cifs_debug.h |    6 +-----
 fs/cifs/cifsfs.c     |    1 -
 fs/cifs/connect.c    |    9 ++-------
 fs/cifs/readdir.c    |   19 +++++++++++++++----
 4 files changed, 18 insertions(+), 17 deletions(-)

--
Thanks,

Steve



--
Thanks,

Steve
