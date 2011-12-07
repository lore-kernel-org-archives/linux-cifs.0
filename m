From: Greg KH <gregkh@suse.de>
Subject: [21/27] cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch
Date: Wed, 07 Dec 2011 08:54:54 -0800
Message-ID: <20111207165602.151282904@clark.kroah.org>
References: <20111207165611.GA19872@kroah.com>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<alan@lxorguk.ukuu.org.uk>, Pavel Shilovsky <piastryyy@gmail.com>,
	Steve French <smfrench@gmail.com>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	Steve French <sfrench@us.ibm.com>,
	Pavel Shilovsky <piastry@etersoft.ru>,
	Suresh Jayaraman <sjayaraman@suse.com>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.com>

The stable release 2.6.32.32 added the upstream commit
12fed00de963433128b5366a21a55808fab2f756. However, one of the hunks of
the original patch seems missing from the stable backport which can be
found here:
   http://permalink.gmane.org/gmane.linux.kernel.stable/5676

This hunk corresponds to the change in is_valid_oplock_break() at
fs/cifs/misc.c.

This patch backports the missing hunk and is against
linux-2.6.32.y stable kernel.


Cc: Steve French <sfrench@us.ibm.com>
Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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
