From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 0/5] Stable fixes
Date: Mon,  5 Dec 2016 13:11:06 -0800
Message-ID: <1480972271-57692-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Here are a bunch of fixes targeted for stable. The first tree patches
are small fixes. The patch #4 fixes the kernel crash due to a memory
corruption bug during reconnect. The patch #5 fixes a possible stucking
on the mutex which was already locked by the same process.

Changes since v1:
 - Addressed Sachin's suggestions about replacing mod_delayed_work with
queue_delayed_work in patches #4 and #5.
 - Updated a description of patch #5.

Pavel Shilovsky (5):
  CIFS: Decrease verbosity of ioctl call
  CIFS: Fix missing nls unload in smb2_reconnect()
  CIFS: Fix a possible memory corruption in push locks
  CIFS: Fix a possible memory corruption during reconnect
  CIFS: Fix a possible double locking of mutex during reconnect

 fs/cifs/cifsglob.h  |  4 +++
 fs/cifs/cifsproto.h |  3 ++
 fs/cifs/connect.c   | 34 ++++++++++++++++-----
 fs/cifs/file.c      |  8 ++++-
 fs/cifs/ioctl.c     |  2 +-
 fs/cifs/smb2file.c  |  2 +-
 fs/cifs/smb2pdu.c   | 87 ++++++++++++++++++++++++++++++++++++-----------------
 fs/cifs/smb2pdu.h   |  2 ++
 fs/cifs/smb2proto.h |  1 +
 9 files changed, 105 insertions(+), 38 deletions(-)

-- 
2.7.4
