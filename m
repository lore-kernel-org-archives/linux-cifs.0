From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] Clarify default dialect change warning messages
Date: Fri, 1 Sep 2017 21:20:05 -0500
Message-ID: <CAH2r5mtQpvDRV6jJuP=VX1Ese3FRUObYdM-8+UAM0FP1++4++w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As requested, additional kernel warning messages
to clarify the default dialect changes.

Please pull the following change since commit
e89ce1f89f62c7e527db3850a91dab3389772af3:

  Merge tag 'cifs-fixes-for-4.13-rc7-and-stable' of
git://git.samba.org/sfrench/cifs-2.6 (2017-08-31 18:45:04 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 7e682f766f289887c5cbf7c0a1e4970103f01ac4:

  Fix warning messages when mounting to older servers (2017-09-01
00:18:44 -0500)

The signed tag is cifs-smb3-dialect-warning-clarify

----------------------------------------------------------------
Steve French (1):
      Fix warning messages when mounting to older servers

 fs/cifs/connect.c | 22 +++++++++++++++++++++-
 fs/cifs/smb2pdu.c |  7 ++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
