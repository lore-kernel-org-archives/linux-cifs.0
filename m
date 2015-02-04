From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] CIFS Fixes
Date: Wed, 4 Feb 2015 11:42:49 -0600
Message-ID: <CAH2r5muj73BnGAPu997YFGot3pcvvuQGQaj=cNBmHBhqB1h0KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Three small cifs fixes.  One fixes a hang under stress, and the other two are
security related.

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 7a1ceba071709d11271ebd921310b5a18404dd33:

  cifs: fix MUST SecurityFlags filtering (2015-01-26 19:38:26 -0600)

----------------------------------------------------------------
Giel van Schijndel (1):
      cifs: use memzero_explicit to clear stack buffer

Niklas Cassel (1):
      cifs: fix MUST SecurityFlags filtering

Sachin Prabhu (1):
      Complete oplock break jobs before closing file handle

 fs/cifs/cifs_debug.c | 6 ++++--
 fs/cifs/file.c       | 6 +++++-
 fs/cifs/smbencrypt.c | 2 +-
 3 files changed, 10 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve
