From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [SMB3] fixes for stable
Date: Mon, 18 Sep 2017 14:32:45 -0500
Message-ID: <CAH2r5msbPbw7AjnVaHNUsTdA2u=Eb9V3umDFXwEzJURPC0shsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
52269718dc2cf2585d7a2828f31d46ef46e68000:

  Merge tag 'dma-mapping-4.14' of
git://git.infradead.org/users/hch/dma-mapping (2017-09-12 13:30:06
-0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git
tags/4.14-smb3-multidialect-support-and-fixes-for-stable

for you to fetch changes up to 94a9daeaece415ce37ccb413b49a580e68e3477b:

  Update version of cifs module (2017-09-17 23:10:48 -0500)

----------------------------------------------------------------
Convert default dialect to smb2.1 or later to allow connecting to
Windows 7 for example, also includes some fixes for stable

I expect to send additional fixes, and an additional security
improvement (SMB3.1.1) at the end of the week - since am in midst of
an SMB3 test event where these are being verified.
----------------------------------------------------------------
Arnd Bergmann (1):
      cifs: hide unused functions

Ronnie Sahlberg (1):
      cifs: check rsp for NULL before dereferencing in SMB2_open

Steve French (3):
      CIFS/SMB3: Update documentation to reflect SMB3 and various changes
      SMB3: Add support for multidialect negotiate (SMB2.1 and later)
      Update version of cifs module

 Documentation/filesystems/cifs/AUTHORS  |  5 ++
 Documentation/filesystems/cifs/README   | 81 ++++++++++++++----------------
 Documentation/filesystems/cifs/TODO     | 72 +++++++++++++-------------
 Documentation/filesystems/cifs/cifs.txt | 24 +++++----
 fs/cifs/cifsfs.h                        |  2 +-
 fs/cifs/cifsglob.h                      |  6 +++
 fs/cifs/connect.c                       | 24 ++++++---
 fs/cifs/smb2ops.c                       | 42 ++++++++++++++++
 fs/cifs/smb2pdu.c                       | 89 ++++++++++++++++++++++++++++-----
 fs/cifs/smb2pdu.h                       |  2 +-
 10 files changed, 235 insertions(+), 112 deletions(-)

-- 
Thanks,

Steve
