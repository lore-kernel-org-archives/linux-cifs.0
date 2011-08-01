From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v5 PATCH 0/5] Simplify demultiplex thread
Date: Mon,  1 Aug 2011 13:19:39 +0400
Message-ID: <1312190384-3376-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is going to make demultiplex code smaller and let us intergrate SMB2 protocol support easier further.

I successfully tested it with Connectathon Testsuites and two parallel mount/umount scripts.

This is the 5rd version of the patchset, rebased to current master.

Pavel Shilovsky (5):
  CIFS: Move buffer allocation to a separate function
  CIFS: Simplify socket reading in demultiplex thread
  CIFS: Move RFC1002 check to a separate function
  CIFS: Move mid search to a separate function
  CIFS: Cleanup demupltiplex thread exiting code

 fs/cifs/connect.c |  653 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 346 insertions(+), 307 deletions(-)
