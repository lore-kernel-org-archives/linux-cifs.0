From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Two cifs fixes
Date: Tue, 17 May 2011 17:42:35 -0500
Message-ID: <BANLkTinfk5XQ5a2fhRjOao9-ziOry97N6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have queued up two recently found cifs fixes in the cifs git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: add fallback in is_path_accessible for old servers
      cifs: fix cifsConvertToUCS() for the mapchars case

 fs/cifs/cifs_unicode.c |   14 ++++++--------
 fs/cifs/connect.c      |    5 +++++
 2 files changed, 11 insertions(+), 8 deletions(-)

Given how late (rc7) any additional testing appreciated (Jeff and
Shirish and I have tested these).
-- 
Thanks,

Steve
