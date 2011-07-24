From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [v4 PATCH 0/5] Simplify demultiplex thread
Date: Sun, 24 Jul 2011 19:00:30 +0400
Message-ID: <1311519630-2500-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset is going to make demultiplex code smaller and let us intergrate SMB2 protocol support easier further.

I successfully tested it with Connectathon Testsuites and two parallel mount/umount scripts.

This is the 4rd version of the patchset that includes minor changes for patch #1.


Pavel Shilovsky (5):
  CIFS: Move buffer allocation to a separate function
  CIFS: Simplify socket reading in demultiplex thread
  CIFS: Move RFC1002 check to a separate function
  CIFS: Move mid search to a separate function
  CIFS: Cleanup demupltiplex thread exiting code

 fs/cifs/connect.c |  653 ++++++++++++++++++++++++++++-------------------------
 1 files changed, 346 insertions(+), 307 deletions(-)
