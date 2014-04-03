From: Cyril Roelandt <tipecaml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] fs: cifs: remove unused variable.
Date: Fri,  4 Apr 2014 00:05:21 +0200
Message-ID: <1396562721-28354-1-git-send-email-tipecaml@gmail.com>
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Cyril Roelandt <tipecaml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In SMB2_set_compression(), the "res_key" variable is only initialized to NULL
and later kfreed. It is therefore useless and should be removed.

Found with the following semantic patch:

<smpl>
@@
identifier foo;
identifier f;
type T;
@@
* f(...) {
...
* T *foo = NULL;
... when forall
    when != foo
* kfree(foo);
...
}
</smpl>

Signed-off-by: Cyril Roelandt <tipecaml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8603447..3802f8c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1352,7 +1352,6 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid)
 {
 	int rc;
-	char *res_key = NULL;
 	struct  compress_ioctl fsctl_input;
 	char *ret_data = NULL;
 
@@ -1365,7 +1364,6 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 			2 /* in data len */, &ret_data /* out data */, NULL);
 
 	cifs_dbg(FYI, "set compression rc %d\n", rc);
-	kfree(res_key);
 
 	return rc;
 }
-- 
1.9.1
