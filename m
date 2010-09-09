From: shirishpargaonkar@gmail.com
Subject: [PATCH -v2 3/6] define, declare, and use crypto hash functions
Date: Thu,  9 Sep 2010 13:12:57 -0500
Message-ID: <1284055977-818-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-crypto@vger.kernel.org,
	Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: smfrench@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>


Mark dependency on crypto modules in Kconfig.

Defining per structures sdesc and cifs_secmech which are used to store
crypto hash functions and contexts.  They are stored per smb connection
and used for all auth mechs to genereate hash values and signatures.

Allocate crypto hashing functions, security descriptiors, and respective
contexts when a smb/tcp connection is established.
Release them when a tcp/smb connection is taken down.

md5 and hmac-md5 are two crypto hashing functions that are used
throught the life of an smb/tcp connection by various functions that
calcualte signagure and ntlmv2 hash, HMAC etc.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
---
 fs/cifs/Kconfig       |    3 ++
 fs/cifs/cifsencrypt.c |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsglob.h    |   18 ++++++++++++
 fs/cifs/cifsproto.h   |    2 +
 fs/cifs/connect.c     |   16 +++++++++--
 5 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 917b7d4..0ed2139 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -2,6 +2,9 @@ config CIFS
 	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
 	depends on INET
 	select NLS
+	select CRYPTO
+	select CRYPTO_MD5
+	select CRYPTO_ARC4
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7e15cd0..857dd37 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -470,3 +470,74 @@ void CalcNTLMv2_response(const struct cifsSesInfo *ses,
 	hmac_md5_final(v2_session_response, &context);
 /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
 }
+
+void
+cifs_crypto_shash_release(struct TCP_Server_Info *server)
+{
+	if (server->secmech.md5)
+		crypto_free_shash(server->secmech.md5);
+
+	if (server->secmech.hmacmd5)
+		crypto_free_shash(server->secmech.hmacmd5);
+
+	kfree(server->secmech.sdeschmacmd5);
+
+	kfree(server->secmech.sdescmd5);
+}
+
+int
+cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
+{
+	int rc;
+	unsigned int size;
+
+	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
+	if (!server->secmech.hmacmd5 ||
+			IS_ERR(server->secmech.hmacmd5)) {
+		cERROR(1, "could not allocate crypto hmacmd5\n");
+		return PTR_ERR(server->secmech.hmacmd5);
+	}
+
+	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
+	if (!server->secmech.md5 || IS_ERR(server->secmech.md5)) {
+		cERROR(1, "could not allocate crypto md5\n");
+		rc = PTR_ERR(server->secmech.md5);
+		goto crypto_allocate_md5_fail;
+	}
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.hmacmd5);
+	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdeschmacmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5\n");
+		rc = -ENOMEM;
+		goto crypto_allocate_hmacmd5_sdesc_fail;
+	}
+	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
+	server->secmech.sdeschmacmd5->shash.flags = 0x0;
+
+
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.md5);
+	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdescmd5) {
+		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5\n");
+		rc = -ENOMEM;
+		goto crypto_allocate_md5_sdesc_fail;
+	}
+	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
+	server->secmech.sdescmd5->shash.flags = 0x0;
+
+	return 0;
+
+crypto_allocate_md5_sdesc_fail:
+	kfree(server->secmech.sdeschmacmd5);
+
+crypto_allocate_hmacmd5_sdesc_fail:
+	crypto_free_shash(server->secmech.md5);
+
+crypto_allocate_md5_fail:
+	crypto_free_shash(server->secmech.hmacmd5);
+
+	return rc;
+}
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c68f31c..f0ec235 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -25,6 +25,9 @@
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
+#include <crypto/internal/hash.h>
+#include <linux/scatterlist.h>
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -109,6 +112,20 @@ struct session_key {
 	} data;
 };
 
+/* crypto security descriptor definition */
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+/* crypto hashing related structure/fields, not speicific to a sec mech */
+struct cifs_secmech {
+	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
+	struct crypto_shash *md5; /* md5 hash function */
+	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
+	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
+};
+
 struct cifs_cred {
 	int uid;
 	int gid;
@@ -187,6 +204,7 @@ struct TCP_Server_Info {
 	unsigned long lstrp; /* when we got last response from this server */
 	u16 dialect; /* dialect index that server chose */
 	/* extended security flavors that server supports */
+	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index c155479..8466a16 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -369,6 +369,8 @@ extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
 extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
 extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
 			     const struct nls_table *);
+extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
+extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 extern void calc_lanman_hash(const char *password, const char *cryptkey,
 				bool encrypt, char *lnm_session_key);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f8891a2..8789054 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1502,6 +1502,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
 
+	cifs_crypto_shash_release(server);
 	cifs_fscache_release_client_cookie(server);
 
 	task = xchg(&server->tsk, NULL);
@@ -1556,10 +1557,16 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		goto out_err;
 	}
 
+	rc = cifs_crypto_shash_allocate(tcp_ses);
+	if (rc) {
+		cERROR(1, "could not setup hash structures rc %d", rc);
+		goto out_err;
+	}
+
 	tcp_ses->hostname = extract_hostname(volume_info->UNC);
 	if (IS_ERR(tcp_ses->hostname)) {
 		rc = PTR_ERR(tcp_ses->hostname);
-		goto out_err;
+		goto out_err2;
 	}
 
 	tcp_ses->noblocksnd = volume_info->noblocksnd;
@@ -1600,7 +1607,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	}
 	if (rc < 0) {
 		cERROR(1, "Error connecting to socket. Aborting operation");
-		goto out_err;
+		goto out_err2;
 	}
 
 	/*
@@ -1614,7 +1621,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		rc = PTR_ERR(tcp_ses->tsk);
 		cERROR(1, "error %d create cifsd thread", rc);
 		module_put(THIS_MODULE);
-		goto out_err;
+		goto out_err2;
 	}
 
 	/* thread spawned, put it on the list */
@@ -1626,6 +1633,9 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	return tcp_ses;
 
+out_err2:
+	cifs_crypto_shash_release(tcp_ses);
+
 out_err:
 	if (tcp_ses) {
 		if (!IS_ERR(tcp_ses->hostname))
-- 
1.6.0.2
