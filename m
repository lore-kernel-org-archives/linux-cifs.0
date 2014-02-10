From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Sun, 9 Feb 2014 22:44:43 -0600
Message-ID: <CAH2r5msb3BUduUozZVk55_ppYX9pzjpX7yCgUijCJtGP1g7DDg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Small fix from Jeff for writepages leak, and some fixes for ACLs and
xattrs when SMB2 enabled.
Am expecting another fix from Jeff and at least one more fix (for
mounting SMB2 with cifsacl)
in the next week.

The following changes since commit 9343224bfd4be6a02e6ae0c0d66426c955c7d76e:

  Merge branch 'akpm' (patches from Andrew Morton) (2014-02-06 13:49:03 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 4a5c80d7b5615be8098f9d5da97d166afc318abc:

  [CIFS] clean up page array when uncached write send fails
(2014-02-07 20:47:00 -0600)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: use a flexarray in cifs_writedata

Steve French (3):
      Add protocol specific operation for CIFS xattrs
      retrieving CIFS ACLs when mounted with SMB2 fails dropping session
      [CIFS] clean up page array when uncached write send fails

 fs/cifs/cifsacl.c   | 28 ++++++++++++++++++++++++----
 fs/cifs/cifsglob.h  |  9 +++++++--
 fs/cifs/cifsproto.h |  3 ++-
 fs/cifs/cifssmb.c   | 15 +++++----------
 fs/cifs/file.c      | 31 ++++++++++++++++++++-----------
 fs/cifs/inode.c     | 13 +++++++++----
 fs/cifs/smb1ops.c   |  8 ++++++++
 fs/cifs/smb2pdu.c   |  5 +++--
 fs/cifs/smb2proto.h |  3 ++-
 fs/cifs/xattr.c     | 15 +++++++++++----
 10 files changed, 91 insertions(+), 39 deletions(-)

-- 
Thanks,

Steve
