From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SMB3] Misc SMB3 fixes
Date: Thu, 14 Dec 2017 13:15:27 -0600
Message-ID: <CAH2r5ms9gnA15jQjMMjYHr3zPd2N5=+FduHciyXQpFvzTLYHng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
328b4ed93b69a6f2083d52f31a240a09e5de386a:

  x86: don't hash faulting address in oops printout (2017-12-05 17:59:29 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/4.15-rc-smb3

for you to fetch changes up to 5702591fc6a3f409f460def104ee149330dac82d:

  CIFS: don't log STATUS_NOT_FOUND errors for DFS (2017-12-06 12:48:01 -0600)

----------------------------------------------------------------
Small SMB3 fixes for stable and 4.15rc

----------------------------------------------------------------
Aurelien Aptel (1):
      CIFS: don't log STATUS_NOT_FOUND errors for DFS

Ronnie Sahlberg (1):
      cifs: fix NULL deref in SMB2_read

 fs/cifs/smb2ops.c |  3 ++-
 fs/cifs/smb2pdu.c | 30 +++++++++++++++---------------
 2 files changed, 17 insertions(+), 16 deletions(-)

-- 
Thanks,

Steve
