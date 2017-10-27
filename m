From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] Various SMB3 fixes for stable
Date: Fri, 27 Oct 2017 11:10:09 -0500
Message-ID: <CAH2r5muudMk5oAoBjpEGdwT5C0sQsqrebp36Eh7Aim8o=2swFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
3e0cc09a3a2c40ec1ffb6b4e12da86e98feccb11:

  Merge tag 'enforcement-4.14-rc6' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
(2017-10-18 06:47:59 -0400)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/4.14-smb3-fixes-for-stable

for you to fetch changes up to 4587eee04e2ac7ac3ac9fa2bc164fb6e548f99cd:

  SMB3: Validate negotiate request must always be signed (2017-10-26
12:20:59 -0500)

----------------------------------------------------------------
Various SMB3 fixes for 4.14 and stable

----------------------------------------------------------------
Aurelien Aptel (1):
      CIFS: do not send invalid input buffer on QUERY_INFO requests

Aur=C3=A9lien Aptel (1):
      CIFS: Fix NULL pointer deref on SMB2_tcon() failure

Benjamin Gilbert (1):
      cifs: Select all required crypto modules

David Disseldorp (2):
      SMB: fix leak of validate negotiate info response buffer
      SMB: fix validate negotiate info uninitialised memory use

Long Li (1):
      CIFS: SMBD: Fix the definition for SMB2_CHANNEL_RDMA_V1_INVALIDATE

Ronnie Sahlberg (1):
      cifs: handle large EA requests more gracefully in smb2+

Steve French (2):
      Fix encryption labels and lengths for SMB3.1.1
      SMB3: Validate negotiate request must always be signed

 fs/cifs/Kconfig         |  5 +++++
 fs/cifs/cifsglob.h      |  8 ++++++--
 fs/cifs/smb2maperror.c  |  2 +-
 fs/cifs/smb2ops.c       | 31 +++++++++++++++++++++++++------
 fs/cifs/smb2pdu.c       | 33 ++++++++++++++++++++++-----------
 fs/cifs/smb2pdu.h       |  5 +++--
 fs/cifs/smb2proto.h     |  1 +
 fs/cifs/smb2transport.c | 26 ++++++++++++++------------
 8 files changed, 77 insertions(+), 34 deletions(-)

--=20
Thanks,

Steve
