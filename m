From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Fri, 11 Feb 2011 13:11:32 -0600
Message-ID: <AANLkTik4L8=MkZ+SAydq+WMO4NO7BsPtFs0i955kKwSY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

  Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (2):
      cifs: clean up checks in cifs_echo_request
      cifs: don't always drop malformed replies on the floor (try #3)

Steve French (1):
      [CIFS] Do not send SMBEcho requests on new sockets until SMBNegotiate

 fs/cifs/cifsglob.h  |    4 +++-
 fs/cifs/connect.c   |   37 ++++++++++++++++++++++++++++---------
 fs/cifs/transport.c |    3 +++
 3 files changed, 34 insertions(+), 10 deletions(-)


-- 
Thanks,

Steve
