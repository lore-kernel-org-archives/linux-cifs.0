From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 6 May 2011 16:38:31 -0500
Message-ID: <BANLkTi=RPZx0HkvRe-WC9gcDzF88MZ5vrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit fafc9929c668f8bae6dd1f109f33a86d2cb3c460:

  Merge branch 'drm-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
(2011-04-28 13:14:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (5):
      cifs: change bleft in decode_unicode_ssetup back to signed type
      cifs: check for bytes_remaining going to zero in CIFS_SessSetup
      cifs: sanitize length checking in coalesce_t2 (try #3)
      cifs: refactor mid finding loop in cifs_demultiplex_thread
      cifs: handle errors from coalesce_t2

 fs/cifs/connect.c |  120 +++++++++++++++++++++++++++++-----------------------
 fs/cifs/sess.c    |   19 ++-------
 2 files changed, 71 insertions(+), 68 deletions(-)


-- 
Thanks,

Steve
