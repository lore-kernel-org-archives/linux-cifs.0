From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: last patches for 3.0
Date: Wed, 6 Jul 2011 12:35:27 -0500
Message-ID: <CAH2r5mshrJRCLc-UsY0CGT_Y5Hsfh1-mUmrqH9o9V3FbSBNqwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have reviewed/merged two of Jeffs 4 recent patches (still reviewing
the last two)

On the problem with WindowsXP mounts limiting the number of
simultaneous requests and timing out when large numbers are sent in
parallel (especially when doing large numbers of small writes at one
time) - I am running ok with this patch and did discuss briefly with
Jeff.  I would rather not do a more invasive patch (if possible) -
this leaves the behavior as is except for servers which specify an mpx
under 50 which is reasonable (ie at least 2) - otherwise it should
work identically, and it seems to fix the XP problem.

commit a30b9327eb4543d45ffb79ebbcabe251eb6a3b9c
Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date:   Fri Jul 1 12:47:23 2011 -0500

    [CIFS] Limit simultaneous requests to older servers which set maxmpx low

    WindowsXP (at least some service packs) sets the maximum number of
simultaneous
    requests to 10 which is smaller than most servers (almost all set
    the limit at 50) and the cifs client set it to, and when
    about 30 requests or so are in flight, requests to WindowsXP servers can
    time out, especially with the new cifs async write code
    which frequently dispatches larger numbers of requests in parallel
    than in previous versions of cifs.

    Limit the number of simultaneous requests to what the server
    sets unless server reports an implausible number (must be a minimum of 2
    to allow for a request and oplock break).

    Signed-off-by: Steve French <smfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 1a9fe7f..1957f5d 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -453,6 +453,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		}
 		server->sec_mode = (__u8)le16_to_cpu(rsp->SecurityMode);
 		server->maxReq = le16_to_cpu(rsp->MaxMpxCount);
+		/* maxReq must be at least 2, almost all servers set to 50,
+		   some old non-MS servers set incorrectly so set to default
+		   (otherwise oplock break e.g. would fail */
+		if (server->maxReq < 2)
+			server->maxReq = CIFS_MAX_REQ; /* 50 */
 		server->maxBuf = min((__u32)le16_to_cpu(rsp->MaxBufSize),
 				(__u32)CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
@@ -560,6 +565,11 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	/* one byte, so no need to convert this or EncryptionKeyLen from
 	   little endian */
 	server->maxReq = le16_to_cpu(pSMBr->MaxMpxCount);
+	/* maxReq must be at least 2, almost all servers set to 50,
+	   some old non-MS servers set incorrectly so set to default
+	   (otherwise oplock break e.g. would fail */
+	if (server->maxReq < 2)
+		server->maxReq = CIFS_MAX_REQ; /* 50 */
 	/* probably no need to store and check maxvcs */
 	server->maxBuf = min(le32_to_cpu(pSMBr->MaxBufferSize),
 			(__u32) CIFSMaxBufSize + MAX_CIFS_HDR_SIZE);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 147aa22..e2bd2a9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -264,7 +264,13 @@ static int wait_for_free_request(struct
TCP_Server_Info *server,

 	spin_lock(&GlobalMid_Lock);
 	while (1) {
-		if (atomic_read(&server->inFlight) >= cifs_max_pending) {
+		/* We must check that don't exceed maxReq but on SMB Negotiate
+		   it is not initted yet (maxReq must be at least two) */
+		/* Could also check if oplock enabled but how could turn off? */
+		if ((atomic_read(&server->inFlight) >= cifs_max_pending) ||
+		    ((atomic_read(&server->inFlight) + 1 >= server->maxReq) &&
+		      (server->maxReq > 1))) {
 			spin_unlock(&GlobalMid_Lock);
 #ifdef CONFIG_CIFS_STATS2
 			atomic_inc(&server->num_waiters);

-- 
Thanks,

Steve
