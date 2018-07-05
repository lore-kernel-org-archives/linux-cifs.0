From: Paulo Alcantara <paulo@paulo.ac>
Subject: [PATCH] cifs: Fix infinite loop when using hard mount option
Date: Thu,  5 Jul 2018 13:46:34 -0300
Message-ID: <20180705164634.12288-1-paulo@paulo.ac>
Cc: smfrench@gmail.com, Paulo Alcantara <paulo@paulo.ac>,
        Paulo Alcantara <palcantara@suse.de>, stable@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

For every request we send, whether it is SMB1 or SMB2+, we attempt to
reconnect tcon (cifs_reconnect_tcon or smb2_reconnect) before carrying
out the request.

So, while server->tcpStatus != CifsNeedReconnect, we wait for the
reconnection to succeed on wait_event_interruptible_timeout(). If it
returns, that means that either the condition was evaluated to true, or
timeout elapsed, or it was interrupted by a signal.

Since we're not handling the case where the process woke up due to a
received signal (-ERESTARTSYS), the next call to
wait_event_interruptible_timeout() will _always_ fail and we end up
looping forever inside either cifs_reconnect_tcon() or smb2_reconnect().

Here's an example of how to trigger that:

$ mount.cifs //foo/share /mnt/test -o
username=foo,password=foo,vers=1.0,hard

(break connection to server before executing bellow cmd)
$ stat -f /mnt/test & sleep 140
[1] 2511

$ ps -aux -q 2511
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2511  0.0  0.0  12892  1008 pts/0    S    12:24   0:00 stat -f
/mnt/test

$ kill -9 2511

(wait for a while; process is stuck in the kernel)
$ ps -aux -q 2511
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2511 83.2  0.0  12892  1008 pts/0    R    12:24  30:01 stat -f
/mnt/test

By using 'hard' mount point means that cifs.ko will keep retrying
indefinitely, however we must allow the process to be killed otherwise
it would hang the system.

Signed-off-by: Paulo Alcantara <palcantara@suse.de>
Cc: stable@vger.kernel.org
---
 fs/cifs/cifssmb.c | 10 ++++++++--
 fs/cifs/smb2pdu.c | 18 ++++++++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d352da325de3..93408eab92e7 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -157,8 +157,14 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * greater than cifs socket timeout which is 7 seconds
 	 */
 	while (server->tcpStatus == CifsNeedReconnect) {
-		wait_event_interruptible_timeout(server->response_q,
-			(server->tcpStatus != CifsNeedReconnect), 10 * HZ);
+		rc = wait_event_interruptible_timeout(server->response_q,
+						      (server->tcpStatus != CifsNeedReconnect),
+						      10 * HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting reconnect due to a received"
+				 " signal by the process\n", __func__);
+			return -ERESTARTSYS;
+		}
 
 		/* are we still trying to reconnect? */
 		if (server->tcpStatus != CifsNeedReconnect)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 810b85787c91..086629b0d59c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -155,7 +155,7 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 {
-	int rc = 0;
+	int rc;
 	struct nls_table *nls_codepage;
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
@@ -166,10 +166,10 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	 * for those three - in the calling routine.
 	 */
 	if (tcon == NULL)
-		return rc;
+		return 0;
 
 	if (smb2_command == SMB2_TREE_CONNECT)
-		return rc;
+		return 0;
 
 	if (tcon->tidStatus == CifsExiting) {
 		/*
@@ -212,8 +212,14 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 			return -EAGAIN;
 		}
 
-		wait_event_interruptible_timeout(server->response_q,
-			(server->tcpStatus != CifsNeedReconnect), 10 * HZ);
+		rc = wait_event_interruptible_timeout(server->response_q,
+						      (server->tcpStatus != CifsNeedReconnect),
+						      10 * HZ);
+		if (rc < 0) {
+			cifs_dbg(FYI, "%s: aborting reconnect due to a received"
+				 " signal by the process\n", __func__);
+			return -ERESTARTSYS;
+		}
 
 		/* are we still trying to reconnect? */
 		if (server->tcpStatus != CifsNeedReconnect)
@@ -231,7 +237,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	}
 
 	if (!tcon->ses->need_reconnect && !tcon->need_reconnect)
-		return rc;
+		return 0;
 
 	nls_codepage = load_nls_default();
 
-- 
2.18.0
