From: Steve French <smfrench@gmail.com>
Subject: [PATCH 2/2] [SMB3] Do not fall back to SMBWriteX in set_file_size error cases
Date: Mon, 28 Sep 2015 18:01:56 -0500
Message-ID: <1443481316-8484-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench@gmail.com>,
	Steve French <steve.french@primarydata.com>,
	<re.emese@gmail.com>, <spender@grsecurity.net>,
	Stable <stable@vger.kernel.org>
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The error paths in set_file_size for cifs and smb3 are incorrect.

In the unlikely event that a server did not support set file info
of the file size, the code incorrectly falls back to trying SMBWriteX
(note that only the original core SMB Write, used for example by DOS,
can set the file size this way - this actually  does not work for the more
recent SMBWriteX).  The idea was since the old DOS SMB Write could set
the file size if you write zero bytes at that offset then use that if
server rejects the normal set file info call.

Fortunately the SMBWriteX will never be sent on the wire (except when
file size is zero) since the length and offset fields were reversed
in the two places in this function that call SMBWriteX causing
the fall back path to return an error. It is also important to never call
an SMB request from an SMB2/sMB3 session (which theoretically would
be possible, and can cause a brief session drop, although the client
recovers) so this should be fixed.  In practice this path does not happen
with modern servers but the error fall back to SMBWriteX is clearly wrong.

Removing the calls to SMBWriteX in the error paths in cifs_set_file_size

Pointed out by PaX/grsecurity team

Signed-off-by: Steve French <steve.french@primarydata.com>
CC: <re.emese@gmail.com>
CC: <spender@grsecurity.net>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/inode.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f621b44..6b66dd5 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2034,7 +2034,6 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
-	struct cifs_io_parms io_parms;
 
 	/*
 	 * To avoid spurious oplock breaks from server, in the case of
@@ -2056,18 +2055,6 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 			rc = -ENOSYS;
 		cifsFileInfo_put(open_file);
 		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
-		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
-			unsigned int bytes_written;
-
-			io_parms.netfid = open_file->fid.netfid;
-			io_parms.pid = open_file->pid;
-			io_parms.tcon = tcon;
-			io_parms.offset = 0;
-			io_parms.length = attrs->ia_size;
-			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
-					  NULL, NULL, 1);
-			cifs_dbg(FYI, "Wrt seteof rc %d\n", rc);
-		}
 	} else
 		rc = -EINVAL;
 
@@ -2093,28 +2080,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	else
 		rc = -ENOSYS;
 	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
-	if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
-		__u16 netfid;
-		int oplock = 0;
 
-		rc = SMBLegacyOpen(xid, tcon, full_path, FILE_OPEN,
-				   GENERIC_WRITE, CREATE_NOT_DIR, &netfid,
-				   &oplock, NULL, cifs_sb->local_nls,
-				   cifs_remap(cifs_sb));
-		if (rc == 0) {
-			unsigned int bytes_written;
-
-			io_parms.netfid = netfid;
-			io_parms.pid = current->tgid;
-			io_parms.tcon = tcon;
-			io_parms.offset = 0;
-			io_parms.length = attrs->ia_size;
-			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, NULL,
-					  NULL,  1);
-			cifs_dbg(FYI, "wrt seteof rc %d\n", rc);
-			CIFSSMBClose(xid, tcon, netfid);
-		}
-	}
 	if (tlink)
 		cifs_put_tlink(tlink);
 
-- 
1.9.1
