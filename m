From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 fixes
Date: Fri, 7 Jul 2017 18:13:19 -0500
Message-ID: <CAH2r5mvnUjiMkHUKgDm=cp7SJkZo9JsSYDfDRvkeU7jrsynA9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

First set of CIFS/SMB3 fixes for the merge window.  Also improves
POSIX character
mapping for SMB3.

Another set, which moves the default dialect up from cifs to smb3, and impr=
oves
set ACL and chmod support is still being reviewed, and I will try to have t=
hat
ready next week.

Also let me know if you want me to change how I do signed tags - since I ad=
ded
one for this pull request.

Please pull the following changes since commit
6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c:

  Linux 4.12 (2017-07-02 16:07:02 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 966681c9f029afd5decee069b7658bb58ad0a863:

  CIFS: fix circular locking dependency (2017-07-05 20:08:39 -0500)

----------------------------------------------------------------
Arnd Bergmann (1):
      cifs: hide unused functions

Aur=C3=A9lien Aptel (1):
      CIFS: add CONFIG_CIFS_DEBUG_KEYS to dump encryption keys

Bj=C3=B6rn JACKE (1):
      CIFS: add SFM mapping for 0x01-0x1F

Colin Ian King (1):
      cifs: set oparms.create_options rather than or'ing in
CREATE_OPEN_BACKUP_INTENT

Jeff Layton (1):
      cifs: set mapping error when page writeback fails in writepage
or launder_pages

Long Li (1):
      cifs: Do not modify mid entry after submitting I/O in cifs_call_async

Rabin Vincent (1):
      CIFS: fix circular locking dependency

Shirish Pargaonkar (2):
      cifs: prototype declaration and definition for smb 2 - 3 and
cifsacl mount options
      cifs: Use smb 2 - 3 and cifsacl mount options getacl functions

Steve French (1):
      SMB3: Enable encryption for SMB3.1.1

 fs/cifs/Kconfig         |   9 ++++
 fs/cifs/cifs_unicode.c  |   8 ++++
 fs/cifs/file.c          |  16 ++++---
 fs/cifs/smb2ops.c       | 119 ++++++++++++++++++++++++++++++++++++++++++++=
+++-
 fs/cifs/smb2pdu.c       |  52 ++++++++++++++++-----
 fs/cifs/smb2proto.h     |   3 ++
 fs/cifs/smb2transport.c |  28 ++++++++++--
 fs/cifs/transport.c     |   7 ++-
 8 files changed, 218 insertions(+), 24 deletions(-)

--=20
Thanks,

Steve
