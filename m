From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/8] ntlmv2/ntlmssp  defines, data structures
Date: Tue,  7 Sep 2010 23:44:00 -0500
Message-ID: <1283921040-12994-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Defining per smb connection structures, sdesc, ntlmssp_auth, cifs_secmech,
and cphready.

Fields tilen and tilbob are session specific.

sdesc holds security descriptor, ntlmssp_auth holds secondary key which
is a nonce that gets used as a key to generate signatures,
ciphertext is genereated by rc4/arc4 encryption of secondary key using
ntlmv2 session key and sent in the session key field of the type 3 message
sent by the client during ntlmssp negotiation/exchange
These are per session structures and secondary key and cipher text 
get calculated only once per smb connection, during first smb session setup
for that smb connection.

Field cphready is used to mark such that once secondary keys and ciphertext
are calculated during very first smb session setup for a smb connection
and ciphertext is sent to the server, the same does not happen during
subsequent smb session setups/establishments.

if key exchange is negotiated between client and server, hmacmd5 and md5 hold
respective crypto function/algorithm.

tilen and tiblob hold the length and blob that is target info or 
attribute value (av) pairs, which is part of the authentication blob.
These are per smb session fields.

Various defines are defined such as values used in AV pairs/Target Info pairs.
And various key and hash sizes are also defined.

The reason mac_key was changed to session key is, this structure does not hold
message authentication code, it holds the session key (for ntlmv2, ntlmv1 etc.).
mac is generated as a signature in cifs_calc* functions.

Mark dependency on crypto modules in Kconfig.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Kconfig       |    3 +++
 fs/cifs/cifsencrypt.c |   13 +++++++------
 fs/cifs/cifsglob.h    |   34 ++++++++++++++++++++++++++++++++--
 fs/cifs/cifspdu.h     |    7 +++++++
 fs/cifs/cifsproto.h   |    4 ++--
 fs/cifs/ntlmssp.h     |   13 +++++++++++++
 6 files changed, 64 insertions(+), 10 deletions(-)

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
index 847628d..796ebc7 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -42,7 +42,8 @@ extern void SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 		       unsigned char *p24);
 
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
-				    const struct mac_key *key, char *signature)
+				    const struct session_key *key,
+					char *signature)
 {
 	struct	MD5Context context;
 
@@ -89,7 +90,7 @@ int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
 }
 
 static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
-				const struct mac_key *key, char *signature)
+				const struct session_key *key, char *signature)
 {
 	struct  MD5Context context;
 	int i;
@@ -156,14 +157,14 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 }
 
 int cifs_verify_signature(struct smb_hdr *cifs_pdu,
-			  const struct mac_key *mac_key,
+			  const struct session_key *session_key,
 			  __u32 expected_sequence_number)
 {
 	unsigned int rc;
 	char server_response_sig[8];
 	char what_we_think_sig_should_be[20];
 
-	if ((cifs_pdu == NULL) || (mac_key == NULL))
+	if (cifs_pdu == NULL || session_key == NULL)
 		return -EINVAL;
 
 	if (cifs_pdu->Command == SMB_COM_NEGOTIATE)
@@ -192,7 +193,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 					cpu_to_le32(expected_sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
-	rc = cifs_calculate_signature(cifs_pdu, mac_key,
+	rc = cifs_calculate_signature(cifs_pdu, session_key,
 		what_we_think_sig_should_be);
 
 	if (rc)
@@ -209,7 +210,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 }
 
 /* We fill in key by putting in 40 byte array which was allocated by caller */
-int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
+int cifs_calculate_mac_key(struct session_key *key, const char *rn,
 			   const char *password)
 {
 	char temp_key[16];
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0cdfb8c..a39849d 100644
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
@@ -97,7 +100,7 @@ enum protocolEnum {
 	/* Netbios frames protocol not supported at this time */
 };
 
-struct mac_key {
+struct session_key {
 	unsigned int len;
 	union {
 		char ntlm[CIFS_SESS_KEY_SIZE + 16];
@@ -120,6 +123,28 @@ struct cifs_cred {
 	struct cifs_ace *aces;
 };
 
+/* crypto security descriptor definition */
+struct sdesc {
+	struct shash_desc shash;
+	char ctx[];
+};
+
+/* per smb connection structure/fields */
+struct ntlmssp_auth {
+	__u32 client_flags; /* sent by client in type 1 ntlmsssp exchange */
+	__u32 server_flags; /* sent by server in type 2 ntlmssp exchange */
+	unsigned char sec_key[CIFS_CPHTXT_SIZE]; /* a nonce client generates */
+	unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to server */
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
 /*
  *****************************************************************
  * Except the CIFS PDUs themselves all the
@@ -182,11 +207,14 @@ struct TCP_Server_Info {
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* needed for CIFS PDU signature */
-	struct mac_key mac_signing_key;
+	struct session_key mac_signing_key;
 	char ntlmv2_hash[16];
 	unsigned long lstrp; /* when we got last response from this server */
 	u16 dialect; /* dialect index that server chose */
 	/* extended security flavors that server supports */
+	struct ntlmssp_auth ntlmssp; /* sec key, ciphertext, flags */
+	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
+	bool	cphready;		/* ciphertext is calculated */
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_kerberosu2u;	/* supports U2U Kerberos */
@@ -222,6 +250,8 @@ struct cifsSesInfo {
 	char userName[MAX_USERNAME_SIZE + 1];
 	char *domainName;
 	char *password;
+	unsigned int tilen; /* length of the target info blob */
+	unsigned char *tiblob; /* target info blob in challenge response */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 };
 /* no more than one of the following three session flags may be set */
diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 14d036d..f5c78fb 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -134,6 +134,13 @@
  * Size of the session key (crypto key encrypted with the password
  */
 #define CIFS_SESS_KEY_SIZE (24)
+#define CIFS_CLIENT_CHALLENGE_SIZE (8)
+#define CIFS_SERVER_CHALLENGE_SIZE (8)
+#define CIFS_HMAC_MD5_HASH_SIZE (16)
+#define CIFS_CPHTXT_SIZE (16)
+#define CIFS_NTLMV2_SESSKEY_SIZE (16)
+#define CIFS_NTHASH_SIZE (16)
+
 
 /*
  * Maximum user name length
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 1f54508..8d63406 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -361,9 +361,9 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 			  __u32 *);
 extern int cifs_verify_signature(struct smb_hdr *,
-				 const struct mac_key *mac_key,
+				 const struct session_key *session_key,
 				__u32 expected_sequence_number);
-extern int cifs_calculate_mac_key(struct mac_key *key, const char *rn,
+extern int cifs_calculate_mac_key(struct session_key *key, const char *rn,
 				 const char *pass);
 extern int CalcNTLMv2_partial_mac_key(struct cifsSesInfo *,
 			const struct nls_table *);
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 49c9a4e..3c8c6c1 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -61,6 +61,19 @@
 #define NTLMSSP_NEGOTIATE_KEY_XCH   0x40000000
 #define NTLMSSP_NEGOTIATE_56        0x80000000
 
+/* Define AV Pair Field IDs */
+#define NTLMSSP_AV_EOL                 0
+#define NTLMSSP_AV_NB_COMPUTER_NAME    1
+#define NTLMSSP_AV_NB_DOMAIN_NAME      2
+#define NTLMSSP_AV_DNS_COMPUTER_NAME   3
+#define NTLMSSP_AV_DNS_DOMAIN_NAME     4
+#define NTLMSSP_AV_DNS_TREE_NAME       5
+#define NTLMSSP_AV_FLAGS               6
+#define NTLMSSP_AV_TIMESTAMP           7
+#define NTLMSSP_AV_RESTRICTION         8
+#define NTLMSSP_AV_TARGET_NAME         9
+#define NTLMSSP_AV_CHANNEL_BINDINGS    10
+
 /* Although typedefs are not commonly used for structure definitions */
 /* in the Linux kernel, in this particular case they are useful      */
 /* to more closely match the standards document for NTLMSSP from     */
-- 
1.6.0.2
