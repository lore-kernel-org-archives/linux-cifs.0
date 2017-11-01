From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SMB3] Patch for file name too long bug
Date: Tue, 31 Oct 2017 21:41:42 -0500
Message-ID: <CAH2r5mvA=ybD=c87tFOhTEyJsrHbwnCTDAvsTvQeJ0jGbZGt4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
0b07194bb55ed836c2cc7c22e866b87a14681984:

  Linux 4.14-rc7 (2017-10-29 13:58:38 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/smb3-file-name-too-long-fix

for you to fetch changes up to f74bc7c6679200a4a83156bb89cbf6c229fe8ec0:

  cifs: check MaxPathNameComponentLength != 0 before using it
(2017-10-30 02:11:38 -0500)

----------------------------------------------------------------
smb3 file name too long fix

Fixes regression (also for stable)
----------------------------------------------------------------
Ronnie Sahlberg (1):
      cifs: check MaxPathNameComponentLength != 0 before using it

 fs/cifs/dir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
