From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
Date: Thu, 23 Jun 2011 14:58:48 -0400
Message-ID: <20110623145848.7840f339@tlielax.poochiereds.net>
References: <4DE6103E.6010100@hist.no>
	<4DE8B449.2000008@suse.de>
	<4DE8F989.50208@hist.no>
	<20110609182845.1ebfc678@tlielax.poochiereds.net>
	<20110622163612.45744bc2@tlielax.poochiereds.net>
	<4E0322B0.8030102@hist.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E0322B0.8030102-CND4fxrytsY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Jun 2011 13:25:36 +0200
Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org> wrote:

> >
> > I think that this is probably due to the change that added the
> > page_mkwrite function to cifs.ko. Prior to that, cifs did single-page
> > writes on signed connections. Now we do multi-page writes and windows
> > servers apparently reject large write calls on signed connections.
> >
> > One way to test this theory would be to set the wsize to something
> > smaller when you mount. For instance:
> >
> >      wsize=16384
> >
> > ...assuming that doesn't go over the server's MaxBufferSize, then thatFrom 
> > should act as a workaround. Can you try that and let me know if it
> > helps?
> 
> 
> Yes, that seemed to fix it. I added wsize=16384 and mounted using 
> debians 2.6.39-1-amd64 kernel.
> 
> I tried a recursive copy of 26MB from one directory tree to another on 
> that mount. It completed in 24s with no error messages. 1MB/s is not 
> much, but there may be 40 other users.
> 
> The server runs windows 2008r2, 64-bit.
> 

Great, thanks for testing that. Would you be able to test this patch on
2.6.39 kernel? It should apply cleanly there, but let me know if it
doesn't.

Also, I'm planning to send this off to stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org if there are no
objections, so if anyone has any, let me know ASAP.

--------------------[snip]-----------------------

cifs: fix wsize negotiation for 2.6.39 stable

Prior to 2.6.39, when signing was enabled on a socket the client only
sent single-page writes. This changed with commit ca83ce3d5b, which
made signed and unsigned connections use the same codepaths for write
calls.

This caused a regression when working with windows servers. Windows
machines will reject writes larger than the MaxBufferSize when signing
is active, but does not clear the CAP_LARGE_WRITE_X flag in the
negotiation.

This patch backports 2 patches that fix this problem in 3.0 kernels,
and changes a couple of the constants to values appropriate for the
writeback code in 2.6.39.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-by: Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   64 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 29fac128..2a9d9c1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2571,23 +2571,6 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	else /* default */
 		cifs_sb->rsize = CIFSMaxBufSize;
 
-	if (pvolume_info->wsize > PAGEVEC_SIZE * PAGE_CACHE_SIZE) {
-		cERROR(1, "wsize %d too large, using 4096 instead",
-			  pvolume_info->wsize);
-		cifs_sb->wsize = 4096;
-	} else if (pvolume_info->wsize)
-		cifs_sb->wsize = pvolume_info->wsize;
-	else
-		cifs_sb->wsize = min_t(const int,
-					PAGEVEC_SIZE * PAGE_CACHE_SIZE,
-					127*1024);
-		/* old default of CIFSMaxBufSize was too small now
-		   that SMB Write2 can send multiple pages in kvec.
-		   RFC1001 does not describe what happens when frame
-		   bigger than 128K is sent so use that as max in
-		   conjunction with 52K kvec constraint on arch with 4K
-		   page size  */
-
 	if (cifs_sb->rsize < 2048) {
 		cifs_sb->rsize = 2048;
 		/* Windows ME may prefer this */
@@ -2665,6 +2648,48 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 			   "mount option supported");
 }
 
+/* Prior to 3.0, cifs couldn't handle writes larger than this */
+#define CIFS_MAX_WSIZE (PAGEVEC_SIZE * PAGE_CACHE_SIZE)
+
+/*
+ * When the server doesn't allow large posix writes, only allow a wsize of
+ * 128k minus the size of the WRITE_AND_X header. That allows for a write up
+ * to the maximum size described by RFC1002.
+ */
+#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4)
+
+/* Make the default the same as the max */
+#define CIFS_DEFAULT_WSIZE CIFS_MAX_WSIZE
+
+static unsigned int
+cifs_negotiate_wsize(struct cifsTconInfo *tcon, struct smb_vol *pvolume_info)
+{
+	__u64 unix_cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	unsigned int wsize = pvolume_info->wsize ? pvolume_info->wsize :
+				CIFS_DEFAULT_WSIZE;
+
+	/* can server support 24-bit write sizes? (via UNIX extensions) */
+	if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WRITE_CAP))
+		wsize = min_t(unsigned int, wsize, CIFS_MAX_RFC1002_WSIZE);
+
+	/*
+	 * no CAP_LARGE_WRITE_X or is signing enabled without CAP_UNIX set?
+	 * Limit it to max buffer offered by the server, minus the size of the
+	 * WRITEX header, not including the 4 byte RFC1001 length.
+	 */
+	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
+	    (!(server->capabilities & CAP_UNIX) &&
+	     (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
+		wsize = min_t(unsigned int, wsize,
+				server->maxBuf - sizeof(WRITE_REQ) + 4);
+
+	/* hard limit of CIFS_MAX_WSIZE */
+	wsize = min_t(unsigned int, wsize, CIFS_MAX_WSIZE);
+
+	return wsize;
+}
+
 static int
 is_path_accessible(int xid, struct cifsTconInfo *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path)
@@ -2866,13 +2891,12 @@ try_mount_again:
 		cifs_sb->rsize = 1024 * 127;
 		cFYI(DBG2, "no very large read support, rsize now 127K");
 	}
-	if (!(tcon->ses->capabilities & CAP_LARGE_WRITE_X))
-		cifs_sb->wsize = min(cifs_sb->wsize,
-			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 	if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
 		cifs_sb->rsize = min(cifs_sb->rsize,
 			       (tcon->ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
 
+	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
+
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
 	if (!rc && tcon) {
-- 
1.7.5.4
