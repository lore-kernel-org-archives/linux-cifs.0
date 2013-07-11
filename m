From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB2/SMB3 symlinks broken
Date: Thu, 11 Jul 2013 00:11:18 -0500
Message-ID: <CAH2r5mvBtbHYteEGH9LvwYJkh1mbzuXK6kbP6E+gEarf+mK_CA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Was trying to decide if enabling mfsymlinks by default for smb2/smb3
made sense (since Windows symlinks are for admin only) and these
symlinks are commonly used by Apple (and work on cifs), but aren't
implemented yet in cifs.ko for smb2 or later mounts

In testing though, noticed that specifying "mfsymlinks" on an
smb2/smb3 mount causes cifs.ko to send a cifs open (which the server
rejects forcing a reconnect).   The obvious fix for this would be to
make link.c protocol generic as we did for a few other cifs functions
- but I am now leaning against this in favor of adding a new version
specific op - basically doing an smb2/smb3 protocol worker which calls
the smb2/smb3 specific "open_op_close" (need to add write as a valid
op) and then add cleanup if the open succeeds but the write fails.
Fixing up link.c by making open version generic (see below) is ok (and
there are only three places that call) - but write is hard to fixup
correctly in a protocol generic way and it prevents us from doing this
as one compounded op (open/write/close) or query (open/query/close) to
optimize in the smb2/smb3 case.  Looks like repeating this type of
change 3 times in fs/cifs/link.c is the wrong approach so I will work
on an smb2/smb3 symlink version op tomorrow.

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index b83c3f5..5c9c7ad 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -189,10 +189,11 @@ CIFSCreateMFSymLink(const unsigned int xid,
struct cifs_tcon *tcon,
 	int oplock = 0;
 	int remap;
 	int create_options = CREATE_NOT_DIR;
-	__u16 netfid = 0;
 	u8 *buf;
 	unsigned int bytes_written = 0;
+	struct cifs_fid cfile;
 	struct cifs_io_parms io_parms;
+	struct cifs_open_parms oparms;
 	struct nls_table *nls_codepage;

 	nls_codepage = cifs_sb->local_nls;
@@ -211,9 +212,16 @@ CIFSCreateMFSymLink(const unsigned int xid,
struct cifs_tcon *tcon,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;

-	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
-			 create_options, &netfid, &oplock, NULL,
-			 nls_codepage, remap);
+	oparms.tcon = tcon;
+	oparms.cifs_sb = cifs_sb;
+	oparms.disposition = FILE_CREATE;
+	oparms.desired_access = GENERIC_WRITE;
+	oparms.create_options = create_options;
+	oparms.path = fromName;
+	oparms.fid = &cfile->fid;
+	oparms.reconnect = true;
+
+	rc = server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc != 0) {
 		kfree(buf);
 		return rc;

-- 
Thanks,

Steve
