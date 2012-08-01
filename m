From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] [CIFS] Add SMB2 rmdir/mkdir support
Date: Wed, 1 Aug 2012 18:37:05 -0500
Message-ID: <CAH2r5muym8O+9ezntNBeNm5SY_dEKb=aOv2cCyfeWLiMv+uurw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adds SMB2 rmdir/mkdir capability to the SMB2/SMB2.1 support in cifs.
I am holding up a few more days on merging the remainder of the
SMB2/SMB2.1 enablement although it is nearing review completion,
in order to address some review comments from Jeff Layton on a
few of the subsequent SMB2 patches, and also to debug an
unrelated cifs problem that Pavel discovered.

The following changes since commit b387e41e523c1aa347cff055455d0dd129357df4:

  Merge branch 'merge' of
git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2012-07-27
08:35:26 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 1a500f010fb2d121c58f77ddfde2eca1bde3bfcd:

  CIFS: Add SMB2 support for rmdir (2012-07-27 15:17:50 -0500)

----------------------------------------------------------------
Pavel Shilovsky (5):
      CIFS: Simplify cifs_mkdir call
      CIFS: Separate protocol specific part from mkdir
      CIFS: Add SMB2 support for mkdir operation
      CIFS: Move rmdir code to ops struct
      CIFS: Add SMB2 support for rmdir

 fs/cifs/cifsglob.h  |   10 ++
 fs/cifs/cifsproto.h |   11 +-
 fs/cifs/cifssmb.c   |   31 +++---
 fs/cifs/inode.c     |  302 ++++++++++++++++++++++++++++-----------------------
 fs/cifs/smb1ops.c   |   24 ++++
 fs/cifs/smb2inode.c |   39 +++++++
 fs/cifs/smb2ops.c   |    3 +
 fs/cifs/smb2proto.h |    8 ++
 8 files changed, 270 insertions(+), 158 deletions(-)

-- 
Thanks,

Steve
