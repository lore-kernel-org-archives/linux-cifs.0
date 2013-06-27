From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][CIFS] Fix build warning
Date: Thu, 27 Jun 2013 01:13:58 -0500
Message-ID: <CAH2r5ms4mAXCyxT+dMQhMbG1On9G5eihF7GSfxSGL9z=86v7OQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, 27 Jun 2013 01:06:50 -0500
Subject: [PATCH] [CIFS] Fix build warning

Fix build warning in Shirish's recent SMB3 signing patch
which occurs when SMB2 support is disabled in Kconfig.

fs/built-in.o: In function `cifs_setup_session':
>> (.text+0xa1767): undefined reference to `generate_smb3signingkey'

Pointed out by: automated 0-DAY kernel build testing backend
Intel Open Source Technology Center

CC: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h      | 2 ++
 fs/cifs/cifsproto.h     | 2 +-
 fs/cifs/connect.c       | 3 ++-
 fs/cifs/smb2ops.c       | 1 +
 fs/cifs/smb2transport.c | 4 ++--
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2d0f524..b0f077e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -365,6 +365,8 @@ struct smb_version_operations {
 	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *fid);
+	/* The next two functions will need to be changed to per smb session */
+	void (*generate_signingkey)(struct TCP_Server_Info *server);
 	int (*calc_signature)(struct smb_rqst *rqst,
 				   struct TCP_Server_Info *server);
 };
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ff669e7..c8ff018 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -436,7 +436,7 @@ extern int setup_ntlmv2_rsp(struct cifs_ses *,
const struct nls_table *);
 extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
 extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 extern int calc_seckey(struct cifs_ses *);
-extern int generate_smb3signingkey(struct TCP_Server_Info *);
+extern void generate_smb3signingkey(struct TCP_Server_Info *);

 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern int calc_lanman_hash(const char *password, const char *cryptkey,
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 354ea77..afcb8a1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3841,7 +3841,8 @@ cifs_setup_session(const unsigned int xid,
struct cifs_ses *ses,
 			server->sequence_number = 0x2;
 			server->session_estab = true;
 			ses->auth_key.response = NULL;
-			generate_smb3signingkey(server);
+			if (server->ops->generate_signingkey)
+				server->ops->generate_signingkey(server);
 		}
 		mutex_unlock(&server->srv_mutex);

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ed39930..48fe7c4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -709,6 +709,7 @@ struct smb_version_operations smb30_operations = {
 	.get_lease_key = smb2_get_lease_key,
 	.set_lease_key = smb2_set_lease_key,
 	.new_lease_key = smb2_new_lease_key,
+	.generate_signingkey = generate_smb3signingkey,
 	.calc_signature = smb3_calc_signature,
 };

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 87563ee..09b4fba 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -116,7 +116,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct
TCP_Server_Info *server)
 	return rc;
 }

-int
+void
 generate_smb3signingkey(struct TCP_Server_Info *server)
 {
 	unsigned char zero = 0x0;
@@ -187,7 +187,7 @@ generate_smb3signingkey(struct TCP_Server_Info *server)
 	memcpy(server->smb3signingkey, hashptr, SMB3_SIGNKEY_SIZE);

 smb3signkey_ret:
-	return rc;
+	return;
 }

 int
-- 
1.7.11.7


On Thu, Jun 27, 2013 at 12:30 AM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   429b46f4fdaf9c9007b7c0fc371b94e40c3764b2
> commit: 429b46f4fdaf9c9007b7c0fc371b94e40c3764b2 [36/36] [CIFS] SMB3 Signing enablement
> config: make ARCH=parisc defconfig
>
> All error/warnings:
>
>>> ERROR: "generate_smb3signingkey" [fs/cifs/cifs.ko] undefined!
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Thanks,

Steve
