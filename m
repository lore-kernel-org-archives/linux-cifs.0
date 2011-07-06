From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v2 PATCH 0/5] Simplify demultiplex thread
Date: Wed,  6 Jul 2011 14:27:34 +0400
Message-ID: <1309948059-29704-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is going to make demultiplex code smaller and let us intergrate SMB2 protocol support easier further.

I successfully tested it with Connectathon Testsuites and two parallel mount/umount scripts.

This is the 3rd version of the patchset that includes bufixes for patch #4.

Pavel Shilovsky (5):
  CIFS: Move buffer allocation to a separate function
  CIFS: Simplify socket reading in demultiplex thread
  CIFS: Move RFC1002 check to a separate function
  CIFS: Move mid search to a separate function
  CIFS: Cleanup demupltiplex thread exiting code

 fs/cifs/connect.c |  630 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 331 insertions(+), 299 deletions(-)
