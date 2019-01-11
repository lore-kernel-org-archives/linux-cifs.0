From: Steve French <smfrench@gmail.com>
Subject: Fwd: [PATCH 0/7] SMB3 credit flow control handling and writeback fixes
Date: Fri, 11 Jan 2019 00:22:05 -0600
Message-ID: <CAH2r5msHUUrOjOek5dLePs_NKRQ3NYGyYNvMPOt8_DD68Qpeaw@mail.gmail.com>
References: <1547159098-19011-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
To: bfoster@redhat.com, Jeff Layton <jlayton@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1547159098-19011-1-git-send-email-pshilov@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This is an important series, addressing various problems with
crediting (flow control) but more importantly patches 4 and 7 deal
with error cases in writeback, in writepages and writepage which may
be of more general interest.     Brian and Jeff have changed loosely
related code in the VFS and may have insight into whether additional
changes would be helpful beyond what Pavel has done in patches 4 and 7
in this series.

---------- Forwarded message ---------
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Thu, Jan 10, 2019 at 4:25 PM
Subject: [PATCH 0/7] SMB3 credit flow control handling and writeback fixes
To: <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>


This is the series of patches that address few problems with the current code.

Patch #1 adjusts credits properly for MTU credits if we didn't use all the
credits taken for an operation. This prevents loosing credits in error paths.

Patch #2 removes resetting credit number to 1 if server didn't grant us
any credits for the compounding chain. The current code didn't follow
the protocol correctly.

Patch #3 fixes credits handling for compounded requests by taking
one credit per part of the chain. All error paths that return credits
back are fixed accordingly.

Patch #4 fixes hiding EINTR error code returned after an interrupted attemp
to send SMB packet through the network.

Patch #5 removes wrong assumption that the server grants us one credit
for a cancelled request and parse the actual response to get the credit
number.

Patch #6 moves process credits granted by the server in the demultiplex
thread in order to avoid races with reconnects.

Patch #7 addresses few problems in writeback code, in particular related
to interrupted error code returned by the transport layer.

Patches #1-4 as marked for stable. Reviews are welcome.

Pavel Shilovsky (7):
  CIFS: Fix adjustment of credits for MTU requests
  CIFS: Do not set credits to 1 if the server didn't grant anything
  CIFS: Fix credit computation for compounded requests
  CIFS: Do not hide EINTR while sending network packets
  CIFS: Fix credits calculation for cancelled requests
  CIFS: Move credit processing to mid callbacks for SMB3
  CIFS: Fix error paths in writeback code

 fs/cifs/cifsglob.h  |  20 +++++++++
 fs/cifs/cifssmb.c   |   7 +--
 fs/cifs/file.c      |  29 ++++++++++---
 fs/cifs/inode.c     |  10 +++++
 fs/cifs/smb2pdu.c   |   8 +++-
 fs/cifs/transport.c | 122 +++++++++++++++++++++++++++++++++++++++-------------
 6 files changed, 155 insertions(+), 41 deletions(-)

--
2.7.4



-- 
Thanks,

Steve
