From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 17 May 2016 17:36:54 -0500
Message-ID: <CAH2r5mtvDJN0N+XdkxPsPnk2nQzJb3Gev4ump=DvSXKvU804hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Various small CIFS and SMB3 fixes (including some for stable).

Please pull the following changes since commit
7f427d3a6029331304f91ef4d7cf646f054216d2:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2016-05-17
11:01:31 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 897fba1172d637d344f009d700f7eb8a1fa262f1:

  remove directory incorrectly tries to set delete on close on
non-empty directories (2016-05-17 14:09:44 -0500)

----------------------------------------------------------------
Goldwyn Rodrigues (1):
      cifs: Use file_dentry()

Sachin Prabhu (1):
      cifs: remove any preceding delimiter from prefix_path

Stefan Metzmacher (4):
      fs/cifs: correctly to anonymous authentication via NTLMSSP
      fs/cifs: correctly to anonymous authentication for the LANMAN
authentication
      fs/cifs: correctly to anonymous authentication for the NTLM(v1)
authentication
      fs/cifs: correctly to anonymous authentication for the NTLM(v2)
authentication

Steve French (2):
      Update cifs.ko version to 2.09
      remove directory incorrectly tries to set delete on close on
non-empty directories

 fs/cifs/cifs_dfs_ref.c |   6 ++-
 fs/cifs/cifsfs.h       |   2 +-
 fs/cifs/connect.c      |   8 ++-
 fs/cifs/file.c         |   4 +-
 fs/cifs/readdir.c      |   4 +-
 fs/cifs/sess.c         | 139 ++++++++++++++++++++++++++++---------------------
 fs/cifs/smb2glob.h     |   1 +
 fs/cifs/smb2inode.c    |   8 ++-
 fs/cifs/smb2pdu.c      |  16 ++++++
 fs/cifs/smb2proto.h    |   2 +
 10 files changed, 121 insertions(+), 69 deletions(-)

-- 
Thanks,

Steve
