From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [GIT] CIFS Fixes
Date: Fri, 6 Jul 2012 01:47:02 -0500
Message-ID: <CAH2r5mvZ+1Z3iTivmkcubZ6jCo=oRkTL86KZxBccNvP9TVgS2Q@mail.gmail.com>
References: <CAH2r5mtX_P+JHKA8r9hDSEpV_pC4w=z8_FfjwpkWP0-jS4MadQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtX_P+JHKA8r9hDSEpV_pC4w=z8_FfjwpkWP0-jS4MadQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Jul 6, 2012 at 1:45 AM
Subject: [GIT] CIFS Fixes
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


The following changes since commit 94fa83c424321189ca24fb6cb4c0d224cdedc72d:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
(2012-06-12 18:48:17 +0300)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git master

for you to fetch changes up to ec01d738a1691dfc85b96b9f796020267a7be577:

  cifs: when server doesn't set CAP_LARGE_READ_X, cap default rsize at
MaxBufferSize (2012-07-03 12:54:42 -0500)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: when server doesn't set CAP_LARGE_READ_X, cap default rsize at
MaxBufferSize

Suresh Jayaraman (1):
      cifs: fix parsing of password mount option

 fs/cifs/connect.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)


--
Thanks,

Steve



--
Thanks,

Steve
