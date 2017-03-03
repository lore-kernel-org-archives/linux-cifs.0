From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 Fixes
Date: Fri, 3 Mar 2017 17:58:32 -0600
Message-ID: <CAH2r5muhCYpq_UU2cav94QbFO2-76SaBLhBe1xtp3P=Qrmjeyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some small bug fixes as well as SMB2.1/SMB3 enablement for
DFS (global namespace) which previously was only enabled for CIFS.

Please pull the following changes since commit
6053dc981449718d90a429933e99b441e1adaea6:

  Merge tag 'arm64-fixes' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2017-03-01
10:32:30 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to ef65aaede23f75977af56a8c330bb9be8c6e125c:

  smb2: Enforce sec= mount option (2017-03-02 23:13:37 -0600)

----------------------------------------------------------------
Aurelien Aptel (7):
      CIFS: move DFS response parsing out of SMB1 code
      CIFS: add build_path_from_dentry_optional_prefix()
      CIFS: add use_ipc flag to SMB2_ioctl()
      CIFS: let ses->ipc_tid hold smb2 TreeIds
      CIFS: set signing flag in SMB2+ TreeConnect if needed
      CIFS: use DFS pathnames in SMB2+ Create requests
      CIFS: implement get_dfs_refer for SMB2+

Pavel Shilovsky (1):
      CIFS: Fix possible use after free in demultiplex thread

Sachin Prabhu (1):
      smb2: Enforce sec= mount option

Steve French (1):
      CIFS: Fix sparse warnings

 fs/cifs/cifs_dfs_ref.c |   4 +-
 fs/cifs/cifs_unicode.h |   6 +-
 fs/cifs/cifsglob.h     |   5 +-
 fs/cifs/cifspdu.h      |  16 +++--
 fs/cifs/cifsproto.h    |   9 +++
 fs/cifs/cifssmb.c      | 119 ++----------------------------------
 fs/cifs/connect.c      |   3 +-
 fs/cifs/dir.c          |  13 +++-
 fs/cifs/misc.c         | 105 ++++++++++++++++++++++++++++++++
 fs/cifs/sess.c         |   4 +-
 fs/cifs/smb1ops.c      |   1 +
 fs/cifs/smb2file.c     |   3 +-
 fs/cifs/smb2ops.c      | 160 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.c      | 154 +++++++++++++++++++++++++++++++++++++++--------
 fs/cifs/smb2pdu.h      |   8 +++
 fs/cifs/smb2proto.h    |   5 +-
 16 files changed, 447 insertions(+), 168 deletions(-)

-- 
Thanks,

Steve
