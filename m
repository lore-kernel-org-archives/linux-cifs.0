From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SMB3] Fixes and Security Upgrade for CIFS client
Date: Tue, 11 Jul 2017 14:28:08 -0500
Message-ID: <CAH2r5mt38FynUi+5JJ0Wk9SQu650F-eqRWb=rH+ahnFEJykSUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
026d15f6b9878794fae1f794cae881ccd65052e5:

Most important among these is the upgrade of the default dialect to
SMB3.0 in order to improve security. With the move to SMB3, setacl
support for SMB3 was also added (it had been allowed only for cifs)
as well as a bug fix for stable.

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/shli/md (2017-07-08
12:50:18 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/smb3-security-fixes-for-4.13

for you to fetch changes up to 68a6afa7fad2644e6b575aba2f2fbda81e730e5b:

  cifs: Clean up unused variables in smb2pdu.c (2017-07-09 23:38:00 -0500)

----------------------------------------------------------------
Upgrade default dialect to more secure SMB3 from older cifs dialect

----------------------------------------------------------------
Christos Gkekas (1):
      cifs: Clean up unused variables in smb2pdu.c

Pavel Shilovsky (2):
      CIFS: Display SMB2 error codes in the hex format
      CIFS: Reconnect expired SMB sessions

Shirish Pargaonkar (2):
      cifs: prototype declaration and definition to set acl for smb 2
- 3 and cifsacl mount options
      cifs: Use smb 2 - 3 and cifsacl mount options setacl function

Steve French (2):
      [SMB3] Remove ifdef since SMB3 (and later) now STRONGLY preferred
      [SMB3] Improve security, move default dialect to SMB3 from old CIFS

 fs/cifs/Kconfig        | 83 ++++++++++++++++++------------------------------
 fs/cifs/Makefile       |  7 ++--
 fs/cifs/cifs_unicode.c |  2 --
 fs/cifs/cifs_unicode.h |  2 --
 fs/cifs/cifsfs.c       | 13 ++------
 fs/cifs/cifsglob.h     | 20 ++----------
 fs/cifs/cifssmb.c      |  7 ++++
 fs/cifs/connect.c      | 41 ++++++------------------
 fs/cifs/ioctl.c        |  2 --
 fs/cifs/link.c         |  4 ---
 fs/cifs/misc.c         | 11 ++-----
 fs/cifs/smb2maperror.c |  4 +--
 fs/cifs/smb2ops.c      | 86 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.c      | 74 ++++++++++++++++++++-----------------------
 fs/cifs/smb2proto.h    |  3 ++
 15 files changed, 180 insertions(+), 179 deletions(-)

-- 
Thanks,

Steve
