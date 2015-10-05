From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 5 Oct 2015 15:54:42 -0500
Message-ID: <CAH2r5mtH9W+3PWBZzSCPwuwN-uaVKwx2KuX8g2p=sW009CAyhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two fixes for problems pointed out by automated tools.

Thanks PaX/grsecurity team and Dan Carpenter (and the Smatch tool)

Please pull the following changes since commit
e3be4266d3488cbbaddf7fcc661f4473db341e46:

  Merge branch 'perf-urgent-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2015-09-27
12:51:39 -0400)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 616a5399b8f11a526cedcbaeb68bc0a1b08a3f43:

  [CIFS] Update cifs version number (2015-10-03 16:54:17 -0500)

----------------------------------------------------------------
Steve French (3):
      [SMB3] Missing null tcon check
      [SMB3] Do not fall back to SMBWriteX in set_file_size error cases
      [CIFS] Update cifs version number

 fs/cifs/cifsfs.h  |  2 +-
 fs/cifs/inode.c   | 34 ----------------------------------
 fs/cifs/smb2pdu.c |  2 +-
 3 files changed, 2 insertions(+), 36 deletions(-)

-- 
Thanks,

Steve
