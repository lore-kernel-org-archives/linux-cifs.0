From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 0/5] Move protocol specific transport code to ops struct
Date: Wed, 23 May 2012 12:06:41 +0400
Message-ID: <1337760406-3015-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The second version of the patchset consists some fixes based on Jeff's comments.

Here is yet another patchset that is targeted to make existing cifs code
more protocol independent and let us add new protocols easily further.

It can be merge as soons as got reviewed and ok for 3.5.

Pavel Shilovsky (5):
  CIFS: Move protocol specific part from SendReceive2 to ops struct
  CIFS: Move header_size/max_header_size to ops structure
  CIFS: Move protocol specific part from cifs_readv_receive to ops
    struct
  CIFS: Move protocol specific demultiplex thread calls to ops struct
  CIFS: Move add/set_credits and get_credits_field to ops structure

 fs/cifs/cifs_debug.c |    6 +++-
 fs/cifs/cifs_debug.h |    4 +-
 fs/cifs/cifsglob.h   |   50 +++++++++++++++++++++++-----------
 fs/cifs/cifsproto.h  |    5 +--
 fs/cifs/cifssmb.c    |   49 ++++++++++-----------------------
 fs/cifs/connect.c    |   48 ++++++++++----------------------
 fs/cifs/misc.c       |   19 -------------
 fs/cifs/smb1ops.c    |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c  |   30 +++++++++++---------
 9 files changed, 162 insertions(+), 123 deletions(-)
