From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB3: Add xattr support to SMB3 and a bug fix
Date: Thu, 7 Sep 2017 16:45:23 -0500
Message-ID: <CAH2r5muU8xpsW6WXkMkf_vY1r9u7_ZEsp4fEJykz=nsH=BfGpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
81a84ad3cb5711cec79f4dd53a4ce026b092c432:

  Merge branch 'docs-next' of git://git.lwn.net/linux (2017-09-03
21:07:29 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 76e752701a8af4404bbd9c45723f7cbd6e4a251e:

  cifs: Check for timeout on Negotiate stage (2017-09-04 20:55:29 -0500)

Adds xattr support for SMB3 and a bug fix.

Signed tag is 4.14-smb3-xattr-enable

----------------------------------------------------------------
Ronnie Sahlberg (2):
      cifs: Add support for reading attributes on SMB2+
      cifs: Add support for writing attributes on SMB2+

Samuel Cabrero (1):
      cifs: Check for timeout on Negotiate stage

 fs/cifs/cifsglob.h  |   2 +-
 fs/cifs/cifsproto.h |   3 +-
 fs/cifs/cifssmb.c   |  15 +++-
 fs/cifs/connect.c   |   3 +-
 fs/cifs/smb2ops.c   | 204 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   |  34 +++++++++
 fs/cifs/smb2pdu.h   |  10 +++
 fs/cifs/smb2proto.h |   6 ++
 fs/cifs/xattr.c     |   2 +-
 9 files changed, 274 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve
