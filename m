From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 00/15] SMB3 encryption support
Date: Mon, 30 Jan 2017 13:39:29 -0800
Message-ID: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset adds encryption support when SMB3 version of the protocol and higher is negotiated. The encryption is done through the kernel crypto API (CCM(AES)).

The patchset has been successfully tested by xfstests and cthon test suites with encrypted file shares on Samba.

Patches are split into several groups:
 1) #1-#4: prepare transport infractructure to be able to send SMB3 transform header; this is done primarily by separating RFC1001 length and SMB2 header into different iovs.
 2) #5-#6: simplify SMB2 header processing and cleaning up a read codepath.
 3) #7-#9: encrypt outcoming packets by transforming them before sending.
 4) #10-#14: decrypt incoming packets and pass ordinary SMB2 messages for further usual processing.
 5) #15: allow to use "seal" mount option to request the encryption on a share.

Changes since v1:
 - module dependencies are fixed;
 - error path handling during message decryption is fixed;
 - other minor fixes.

Pavel Shilovsky (15):
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

 fs/cifs/Kconfig         |   2 +
 fs/cifs/cifsencrypt.c   |  51 ++--
 fs/cifs/cifsfs.c        |   2 +
 fs/cifs/cifsglob.h      |  28 +-
 fs/cifs/cifsproto.h     |  13 +-
 fs/cifs/cifssmb.c       | 135 +++++-----
 fs/cifs/connect.c       |  71 ++++--
 fs/cifs/file.c          |  52 +++-
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
 19 files changed, 1556 insertions(+), 473 deletions(-)

-- 
2.7.4
