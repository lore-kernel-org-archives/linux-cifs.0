From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH] cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch
Date: Fri, 02 Dec 2011 11:08:27 +0530
Message-ID: <4ED86453.2040007@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The stable release 2.6.32.32 added the upstream commit
12fed00de963433128b5366a21a55808fab2f756. However, one of the hunks of
the original patch seems missing from the stable backport which can be
found here:
   http://permalink.gmane.org/gmane.linux.kernel.stable/5676

This hunk corresponds to the change in is_valid_oplock_break() at
fs/cifs/misc.c.

This patch backports the missing hunk and is against
linux-2.6.32.y stable kernel.


Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
---
[PS. not very happy about the subject line and changelog.
 Feel free to modify as you see fit.]

 fs/cifs/misc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d27d4ec..7055827 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -584,6 +584,9 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
+				else if (pSMB->OplockLevel == OPLOCK_READ)
+					pCifsInode->clientCanCacheRead = true;
+
 				rc = slow_work_enqueue(&netfile->oplock_break);
 				if (rc) {
 					cERROR(1, ("failed to enqueue oplock "
