From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Mon, 25 Apr 2011 22:12:46 -0500
Message-ID: <BANLkTimxDNAmv0iZ7918Tp=7y=pR5S6dag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Pavel Shilovsky (1):
      CIFS: Fix memory over bound bug in cifs_parse_mount_options

 fs/cifs/connect.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


-- 
Thanks,

Steve
