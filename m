From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] A few small cifs fixes
Date: Thu, 24 Aug 2017 20:40:29 -0500
Message-ID: <CAH2r5mteecnhNXaeyTXtGsRxM2KLq5B2gDuJ9M48MDvOxPkgow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
98b9f8a4549909c6ba2117dfc09404989e6d8710:

  Merge tag 'ext4_for_linus_stable' of
git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4 (2017-08-22
21:30:52 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to d3edede29f74d335f81d95a4588f5f136a9f7dcf:

  cifs: return ENAMETOOLONG for overlong names in
cifs_open()/cifs_lookup() (2017-08-23 13:34:52 -0500)


The signed tag is cifs-fixes-for-4.13-rc6-and-stable

----------------------------------------------------------------
Ronnie Sahlberg (1):
      cifs: return ENAMETOOLONG for overlong names in cifs_open()/cifs_lookup()

Sachin Prabhu (1):
      cifs: Fix df output for users with quota limits

 fs/cifs/dir.c     | 18 ++++++++++++------
 fs/cifs/smb2pdu.c |  4 ++--
 2 files changed, 14 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
