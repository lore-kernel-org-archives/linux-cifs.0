From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS/SMB3 patches
Date: Mon, 20 Feb 2017 18:27:32 -0600
Message-ID: <CAH2r5mtOFXgQpQZSDXzfNxX6POg7wdWQdOx41yCUav09_CVvrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
6d04dfc8966019b8b0977b2cb942351f13d2b178:

Includes support for a critical SMB3 security feature: per-share
encryption from Pavel, and a cleanup from Jean Delvare. Will have
another cifs/smb3 merge next week.

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
(2017-02-01 11:52:27 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to ae6f8dd4d0c87bfb72da9d9b56342adf53e69c31:

  CIFS: Allow to switch on encryption with seal mount option
(2017-02-01 16:46:37 -0600)

----------------------------------------------------------------
Jean Delvare (3):
      cifs: Simplify SMB2 and SMB311 dependencies
      cifs: Only select the required crypto modules
      cifs: Add soft dependencies

Pavel Shilovsky (16):
      CIFS: Fix splice read for non-cached files
      CIFS: Separate SMB2 header structure
      CIFS: Make SendReceive2() takes resp iov
      CIFS: Make send_cancel take rqst as argument
      CIFS: Send RFC1001 length in a separate iov
      CIFS: Separate SMB2 sync header processing
      CIFS: Separate RFC1001 length processing for SMB2 read
      CIFS: Add capability to transform requests before sending
      CIFS: Enable encryption during session setup phase
      CIFS: Encrypt SMB3 requests before sending
      CIFS: Add transform header handling callbacks
      CIFS: Add mid handle callback
      CIFS: Add copy into pages callback for a read operation
      CIFS: Decrypt and process small encrypted packets
      CIFS: Add capability to decrypt big read responses
      CIFS: Allow to switch on encryption with seal mount option

 fs/cifs/Kconfig         |  12 +-
 fs/cifs/cifsencrypt.c   |  51 ++--
 fs/cifs/cifsfs.c        |  14 +
 fs/cifs/cifsglob.h      |  28 +-
 fs/cifs/cifsproto.h     |  13 +-
 fs/cifs/cifssmb.c       | 135 +++++-----
 fs/cifs/connect.c       |  71 ++++--
 fs/cifs/file.c          |  62 ++++-
 fs/cifs/sess.c          |  27 +-
 fs/cifs/smb1ops.c       |   4 +-
 fs/cifs/smb2glob.h      |   5 +
 fs/cifs/smb2maperror.c  |   5 +-
 fs/cifs/smb2misc.c      |  61 +++--
 fs/cifs/smb2ops.c       | 663 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c       | 575 +++++++++++++++++++++++++++--------------
 fs/cifs/smb2pdu.h       |  27 +-
 fs/cifs/smb2proto.h     |   5 +
 fs/cifs/smb2transport.c | 132 ++++++----
 fs/cifs/transport.c     | 171 ++++++++-----
 19 files changed, 1582 insertions(+), 479 deletions(-)

-- 
Thanks,

Steve
