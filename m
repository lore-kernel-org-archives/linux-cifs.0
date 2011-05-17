From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 17 May 2011 17:44:32 -0500
Message-ID: <BANLkTinQf83K5xEq10NiPL_cPXiJ0m60ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit c1d10d18c542278b7fbc413c289d3cb6219da6b3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
(2011-05-16 18:38:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: add fallback in is_path_accessible for old servers
      cifs: fix cifsConvertToUCS() for the mapchars case

 fs/cifs/cifs_unicode.c |   14 ++++++--------
 fs/cifs/connect.c      |    5 +++++
 2 files changed, 11 insertions(+), 8 deletions(-)


-- 
Thanks,

Steve
