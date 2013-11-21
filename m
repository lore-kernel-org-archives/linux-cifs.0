From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Wed, 20 Nov 2013 21:54:21 -0600
Message-ID: <CAH2r5msTi=keXhjob1F9fxTSR8AVAAzR5PZKHqHXaf6WAdqTpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Small set of changes this time.  As promised, the finish up of
the copy offload support, and a small security feature for SMB3
needed to prevent certain types of downgrade attacks.

The following changes since commit 2d3c627502f2a9b0a7de06a5a2df23
65542a72c9:

  Revert "init/Kconfig: add option to disable kernel compression"
(2013-11-17 11:17:36 -0800)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to ff1c038addc4f205d5f1ede449426c7d316c0eed:

  Check SMB3 dialects against downgrade attacks (2013-11-19 23:52:54 -0600)

----------------------------------------------------------------
Steve French (3):
      CIFS: Fix SMB2/SMB3 Copy offload support (refcopy) for large files
      Removed duplicated (and unneeded) goto
      Check SMB3 dialects against downgrade attacks

 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/smb2ops.c   | 99 ++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/smb2pdu.c   | 92 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/cifs/smb2pdu.h   | 12 +++++--
 fs/cifs/smb2proto.h |  1 +
 fs/cifs/smbfsctl.h  |  2 +-
 6 files changed, 185 insertions(+), 22 deletions(-)


-- 
Thanks,

Steve
