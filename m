From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes (fixed merge request and resending)
Date: Thu, 8 Dec 2011 22:09:52 -0600
Message-ID: <CAH2r5mtzfMs=TX+fjRRPvc840FWhgvrBAf8Y+bVFM4GbFoG8kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 883381d9f1c5a6329bbb796e23ae52c939940310:

  Merge branch 'dev' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2011-11-29
08:59:12 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: attempt to freeze while looping on a receive attempt
      cifs: check for NULL last_entry before calling cifs_save_resume_key

Pavel Shilovsky (1):
      CIFS: Add descriptions to the brlock cache functions

Steve French (1):
      cifs: Fix sparse warning when calling cifs_strtoUCS

 fs/cifs/connect.c    |    2 ++
 fs/cifs/file.c       |   26 ++++++++++++++++++++++++++
 fs/cifs/readdir.c    |   10 ++++++++--
 fs/cifs/smbencrypt.c |    6 +++---
 4 files changed, 39 insertions(+), 5 deletions(-)


-- 
Thanks,

Steve
