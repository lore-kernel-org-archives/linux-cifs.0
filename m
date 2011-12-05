From: <gregkh-l3A5Bk7waGM@public.gmane.org>
Subject: Patch "cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch" has been added to the 2.6.32-longterm tree
Date: Mon, 05 Dec 2011 13:40:28 -0800
Message-ID: <13231212281085@kroah.org>
References: <4ED8AE80.7030008@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <stable-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: sjayaraman-IBi9RG/b67k@public.gmane.org, gregkh-l3A5Bk7waGM@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ED8AE80.7030008-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch

to the 2.6.32-longterm tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/longterm/longterm-queue-2.6.32.git;a=summary

The filename of the patch is:
     cifs-fix-cifs-stable-patch-cifs-fix-oplock-break-handling-try-2.patch.patch
and it can be found in the queue-2.6.32 subdirectory.

If you, or anyone else, feels it should not be added to the 2.6.32 longterm tree,
please let <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> know about it.


>From sjayaraman-IBi9RG/b67k@public.gmane.org  Mon Dec  5 13:33:36 2011
From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Date: Fri, 02 Dec 2011 16:24:56 +0530
Subject: cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch
To: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Greg KH <gregkh-l3A5Bk7waGM@public.gmane.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,  Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <4ED8AE80.7030008-IBi9RG/b67k@public.gmane.org>

From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>

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
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>

---
 fs/cifs/misc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -584,6 +584,9 @@ is_valid_oplock_break(struct smb_hdr *bu
 				pCifsInode->clientCanCacheAll = false;
 				if (pSMB->OplockLevel == 0)
 					pCifsInode->clientCanCacheRead = false;
+				else if (pSMB->OplockLevel)
+					pCifsInode->clientCanCacheRead = true;
+
 				rc = slow_work_enqueue(&netfile->oplock_break);
 				if (rc) {
 					cERROR(1, ("failed to enqueue oplock "


Patches currently in longterm-queue-2.6.32 which might be from sjayaraman-IBi9RG/b67k@public.gmane.org are

/home/gregkh/linux/longterm/longterm-queue-2.6.32/queue-2.6.32/cifs-fix-cifs-stable-patch-cifs-fix-oplock-break-handling-try-2.patch.patch
