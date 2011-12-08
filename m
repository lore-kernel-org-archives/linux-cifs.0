From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 8 Dec 2011 13:36:03 -0600
Message-ID: <CAH2r5mtW3k8DqsJsJzuYG=VTYD8u2vqKSmbhBvNG6H_E2i_TAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit bca43384add241f1cf2d63ab088050ea21e9968d:

  Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
(2011-11-30 14:01:45 -0600)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: attempt to freeze while looping on a receive attempt
      cifs: check for NULL last_entry before calling cifs_save_resume_key

 fs/cifs/connect.c |    2 ++
 fs/cifs/readdir.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
