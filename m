From: Joe Perches <joe@perches.com>
Subject: [PATCH] cifs: Rename cERROR and cifserror to cifs_vfs_err
Date: Tue, 12 Mar 2013 15:44:47 -0700
Message-ID: <1363128287.23052.21.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The cERROR macro is always used as cERROR(1, and cifserror
is just a printk(KERN_ERR "CIFS VFS: ".

Make a cifs_vfs_err function that uses the vsprintf %pV
extension to avoid duplicating the "CIFS VFS: " prefix.

Remove the cERROR macro and use cifs_vfs_err directly.

Size is reduced ~ 1% when CONFIG_CIFS_DEBUG is set (default y)

$ size fs/cifs/cifs.ko*
   text	   data	    bss	    dec	    hex	filename
 265520	   2525	    132	 268177	  41791	fs/cifs/cifs.ko.new
 268359	   2525	    132	 271016	  422a8	fs/cifs/cifs.ko.old

Other miscellaneous changes around these conversions:

o Miscellaneous typo fixes
o Remove unnecessary terminating \n's
o Remove unnecessary OOM messages as kmalloc() calls dump_stack.
o Coalesce formats to make grep easier,
  added missing spaces when coalescing formats
o Use %s, __func__ instead of embedded function name
o Removed unnecessary "cifs: " prefixes

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/cache.c         |   2 +-
 fs/cifs/cifs_debug.c    |  61 ++++++++++++++--------
 fs/cifs/cifs_debug.h    |  15 +-----
 fs/cifs/cifs_dfs_ref.c  |   8 +--
 fs/cifs/cifs_unicode.c  |   4 +-
 fs/cifs/cifsacl.c       |  22 ++++----
 fs/cifs/cifsencrypt.c   |  87 +++++++++++++++----------------
 fs/cifs/cifsfs.c        |   9 ++--
 fs/cifs/cifssmb.c       |  69 +++++++++++--------------
 fs/cifs/connect.c       | 135 +++++++++++++++++++++---------------------------
 fs/cifs/dir.c           |   6 +--
 fs/cifs/file.c          |  25 ++++-----
 fs/cifs/fscache.c       |   2 +-
 fs/cifs/inode.c         |   4 +-
 fs/cifs/link.c          |  10 ++--
 fs/cifs/misc.c          |  34 ++++++------
 fs/cifs/netmisc.c       |   6 +--
 fs/cifs/readdir.c       |  25 +++++----
 fs/cifs/sess.c          |  40 +++++++-------
 fs/cifs/smb1ops.c       |   6 +--
 fs/cifs/smb2inode.c     |   2 +-
 fs/cifs/smb2misc.c      |  54 +++++++++----------
 fs/cifs/smb2ops.c       |  14 ++---
 fs/cifs/smb2pdu.c       |  60 +++++++++++----------
 fs/cifs/smb2transport.c |  18 +++----
 fs/cifs/smbencrypt.c    |  14 ++---
 fs/cifs/transport.c     |  42 +++++++--------
 fs/cifs/xattr.c         |   4 +-
 28 files changed, 373 insertions(+), 405 deletions(-)

diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 282d6de..e2166dc 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
 		break;
 
 	default:
-		cERROR(1, "Unknown network family '%d'", sa->sa_family);
+		cifs_vfs_err("Unknown network family '%d'", sa->sa_family);
 		key_len = 0;
 		break;
 	}
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d9ea6ed..74fa107 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -57,15 +57,32 @@ cifs_dump_mem(char *label, void *data, int length)
 	}
 }
 
+#ifdef CONFIG_CIFS_DEBUG
+void cifs_vfs_err(const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_ERR "CIFS VFS: %pV\n", &vaf);
+
+	va_end(args);
+}
+#endif
+
 void cifs_dump_detail(void *buf)
 {
 #ifdef CONFIG_CIFS_DEBUG2
 	struct smb_hdr *smb = (struct smb_hdr *)buf;
 
-	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
-		  smb->Command, smb->Status.CifsError,
-		  smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
-	cERROR(1, "smb buf %p len %u", smb, smbCalcSize(smb));
+	cifs_vfs_err("Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d",
+		     smb->Command, smb->Status.CifsError,
+		     smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
+	cifs_vfs_err("smb buf %p len %u", smb, smbCalcSize(smb));
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
@@ -78,25 +95,25 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	if (server == NULL)
 		return;
 
-	cERROR(1, "Dump pending requests:");
+	cifs_vfs_err("Dump pending requests:");
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu",
-			mid_entry->mid_state,
-			le16_to_cpu(mid_entry->command),
-			mid_entry->pid,
-			mid_entry->callback_data,
-			mid_entry->mid);
+		cifs_vfs_err("State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu",
+			     mid_entry->mid_state,
+			     le16_to_cpu(mid_entry->command),
+			     mid_entry->pid,
+			     mid_entry->callback_data,
+			     mid_entry->mid);
 #ifdef CONFIG_CIFS_STATS2
-		cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
-			mid_entry->large_buf,
-			mid_entry->resp_buf,
-			mid_entry->when_received,
-			jiffies);
+		cifs_vfs_err("IsLarge: %d buf: %p time rcv: %ld now: %ld",
+			     mid_entry->large_buf,
+			     mid_entry->resp_buf,
+			     mid_entry->when_received,
+			     jiffies);
 #endif /* STATS2 */
-		cERROR(1, "IsMult: %d IsEnd: %d", mid_entry->multiRsp,
-			  mid_entry->multiEnd);
+		cifs_vfs_err("IsMult: %d IsEnd: %d", mid_entry->multiRsp,
+			     mid_entry->multiEnd);
 		if (mid_entry->resp_buf) {
 			cifs_dump_detail(mid_entry->resp_buf);
 			cifs_dump_mem("existing buf: ",
@@ -603,7 +620,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 			global_secflags = CIFSSEC_MAX;
 			return count;
 		} else if (!isdigit(c)) {
-			cERROR(1, "invalid flag %c", c);
+			cifs_vfs_err("invalid flag %c", c);
 			return -EINVAL;
 		}
 	}
@@ -614,13 +631,13 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	cFYI(1, "sec flags 0x%x", flags);
 
 	if (flags <= 0)  {
-		cERROR(1, "invalid security flags %s", flags_string);
+		cifs_vfs_err("invalid security flags %s", flags_string);
 		return -EINVAL;
 	}
 
 	if (flags & ~CIFSSEC_MASK) {
-		cERROR(1, "attempt to set unsupported security flags 0x%x",
-			flags & ~CIFSSEC_MASK);
+		cifs_vfs_err("attempt to set unsupported security flags 0x%x",
+			     flags & ~CIFSSEC_MASK);
 		return -EINVAL;
 	}
 	/* flags look ok - update the global security flags for cifs module */
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 69ae3d3..66449e1 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -62,14 +62,8 @@ do {									\
 	printk(KERN_WARNING fmt "\n", ##__VA_ARGS__)
 
 /* error event message: e.g., i/o error */
-#define cifserror(fmt, ...)						\
-	printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);		\
 
-#define cERROR(set, fmt, ...)						\
-do {									\
-	if (set)							\
-		cifserror(fmt, ##__VA_ARGS__);				\
-} while (0)
+__printf(1, 2) void cifs_vfs_err(const char *fmt, ...);
 
 /*
  *	debug OFF
@@ -87,16 +81,11 @@ do {									\
 	if (0 && set)							\
 		cifsfyi(fmt, ##__VA_ARGS__);				\
 } while (0)
-#define cifserror(fmt, ...)						\
+#define cif_vfs_err(fmt, ...)						\
 do {									\
 	if (0)								\
 		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);	\
 } while (0)
-#define cERROR(set, fmt, ...)						\
-do {									\
-	if (0 && set)							\
-		cifserror(fmt, ##__VA_ARGS__);				\
-} while (0)
 #endif		/* _CIFS_DEBUG */
 
 #endif				/* _H_CIFS_DEBUG */
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 210fce2..e7f1a40 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -84,8 +84,8 @@ static char *cifs_get_share_name(const char *node_name)
 	/* find server name end */
 	pSep = memchr(UNC+2, '\\', len-2);
 	if (!pSep) {
-		cERROR(1, "%s: no server name end in node name: %s",
-			__func__, node_name);
+		cifs_vfs_err("%s: no server name end in node name: %s",
+			     __func__, node_name);
 		kfree(UNC);
 		return ERR_PTR(-EINVAL);
 	}
@@ -320,8 +320,8 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 		/* connect to a node */
 		len = strlen(referrals[i].node_name);
 		if (len < 2) {
-			cERROR(1, "%s: Net Address path too short: %s",
-					__func__, referrals[i].node_name);
+			cifs_vfs_err("%s: Net Address path too short: %s",
+				     __func__, referrals[i].node_name);
 			mnt = ERR_PTR(-EINVAL);
 			break;
 		}
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 71d5d0a..70c6de0 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -227,8 +227,8 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
 		charlen = codepage->char2uni(from, len, &wchar_to);
 		if (charlen < 1) {
-			cERROR(1, "strtoUTF16: char2uni of 0x%x returned %d",
-				*from, charlen);
+			cifs_vfs_err("strtoUTF16: char2uni of 0x%x returned %d",
+				     *from, charlen);
 			/* A question mark */
 			wchar_to = 0x003f;
 			charlen = 1;
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f1e3f25..9581b5d 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -462,7 +462,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			*pbits_to_set &= ~S_IXUGO;
 		return;
 	} else if (type != ACCESS_ALLOWED) {
-		cERROR(1, "unknown access control type %d", type);
+		cifs_vfs_err("unknown access control type %d", type);
 		return;
 	}
 	/* else ACCESS_ALLOWED type */
@@ -551,12 +551,12 @@ static void dump_ace(struct cifs_ace *pace, char *end_of_acl)
 	/* validate that we do not go past end of acl */
 
 	if (le16_to_cpu(pace->size) < 16) {
-		cERROR(1, "ACE too small %d", le16_to_cpu(pace->size));
+		cifs_vfs_err("ACE too small %d", le16_to_cpu(pace->size));
 		return;
 	}
 
 	if (end_of_acl < (char *)pace + le16_to_cpu(pace->size)) {
-		cERROR(1, "ACL too small to parse ACE");
+		cifs_vfs_err("ACL too small to parse ACE");
 		return;
 	}
 
@@ -601,7 +601,7 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 
 	/* validate that we do not go past end of acl */
 	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
-		cERROR(1, "ACL too small to parse DACL");
+		cifs_vfs_err("ACL too small to parse DACL");
 		return;
 	}
 
@@ -628,7 +628,7 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 		ppace = kmalloc(num_aces * sizeof(struct cifs_ace *),
 				GFP_KERNEL);
 		if (!ppace) {
-			cERROR(1, "DACL memory allocation error");
+			cifs_vfs_err("DACL memory allocation error");
 			return;
 		}
 
@@ -703,7 +703,7 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 	/* validate that we do not go past end of ACL - sid must be at least 8
 	   bytes long (assuming no sub-auths - e.g. the null SID */
 	if (end_of_acl < (char *)psid + 8) {
-		cERROR(1, "ACL too small to parse SID %p", psid);
+		cifs_vfs_err("ACL too small to parse SID %p", psid);
 		return -EINVAL;
 	}
 
@@ -972,7 +972,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 			create_options, &fid, &oplock, NULL, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		cERROR(1, "Unable to open file to set ACL");
+		cifs_vfs_err("Unable to open file to set ACL");
 		goto out;
 	}
 
@@ -1005,12 +1005,12 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
-		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
+		cifs_vfs_err("%s: error %d getting sec desc", __func__, rc);
 	} else {
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr);
 		kfree(pntsd);
 		if (rc)
-			cERROR(1, "parse sec desc failed rc = %d", rc);
+			cifs_vfs_err("parse sec desc failed rc = %d", rc);
 	}
 
 	return rc;
@@ -1033,7 +1033,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
-		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
+		cifs_vfs_err("%s: error %d getting sec desc", __func__, rc);
 		goto out;
 	}
 
@@ -1046,7 +1046,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	secdesclen = max_t(u32, secdesclen, DEFAULT_SEC_DESC_LEN);
 	pnntsd = kmalloc(secdesclen, GFP_KERNEL);
 	if (!pnntsd) {
-		cERROR(1, "Unable to allocate security descriptor");
+		cifs_vfs_err("Unable to allocate security descriptor");
 		kfree(pntsd);
 		return -ENOMEM;
 	}
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 652f505..29cddf6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -50,20 +50,20 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 		return -EINVAL;
 
 	if (!server->secmech.sdescmd5) {
-		cERROR(1, "%s: Can't generate signature", __func__);
+		cifs_vfs_err("%s: Can't generate signature", __func__);
 		return -1;
 	}
 
 	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5", __func__);
+		cifs_vfs_err("%s: Could not init md5", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
 		server->session_key.response, server->session_key.len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response", __func__);
+		cifs_vfs_err("%s: Could not update with response", __func__);
 		return rc;
 	}
 
@@ -71,7 +71,7 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "null iovec entry");
+			cifs_vfs_err("null iovec entry");
 			return -EIO;
 		}
 		/* The first entry includes a length field (which does not get
@@ -88,8 +88,8 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 				iov[i].iov_base, iov[i].iov_len);
 		}
 		if (rc) {
-			cERROR(1, "%s: Could not update with payload",
-							__func__);
+			cifs_vfs_err("%s: Could not update with payload",
+				     __func__);
 			return rc;
 		}
 	}
@@ -106,7 +106,7 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 
 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_vfs_err("%s: Could not generate md5 hash", __func__);
 
 	return rc;
 }
@@ -236,7 +236,7 @@ int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
 
 	ses->auth_key.response = kmalloc(temp_len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		cERROR(1, "NTLM can't allocate (%u bytes) memory", temp_len);
+		cifs_vfs_err("NTLM can't allocate (%u bytes) memory", temp_len);
 		return -ENOMEM;
 	}
 	ses->auth_key.len = temp_len;
@@ -334,7 +334,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
 		ses->auth_key.len = 0;
-		cERROR(1, "Challenge target info allocation failure");
+		cifs_vfs_err("Challenge target info allocation failure");
 		return -ENOMEM;
 	}
 
@@ -420,7 +420,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	wchar_t *server;
 
 	if (!ses->server->secmech.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash");
+		cifs_vfs_err("calc_ntlmv2_hash: can't generate ntlmv2 hash");
 		return -1;
 	}
 
@@ -430,13 +430,13 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set NT Hash as a key", __func__);
+		cifs_vfs_err("%s: Could not set NT Hash as a key", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5");
+		cifs_vfs_err("%s: could not init hmacmd5", __func__);
 		return rc;
 	}
 
@@ -444,7 +444,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
-		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure");
+		cifs_vfs_err("%s: user mem alloc failure", __func__);
 		rc = -ENOMEM;
 		return rc;
 	}
@@ -460,7 +460,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 				(char *)user, 2 * len);
 	kfree(user);
 	if (rc) {
-		cERROR(1, "%s: Could not update with user", __func__);
+		cifs_vfs_err("%s: Could not update with user", __func__);
 		return rc;
 	}
 
@@ -470,7 +470,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (domain == NULL) {
-			cERROR(1, "calc_ntlmv2_hash: domain mem alloc failure");
+			cifs_vfs_err("%s: domain mem alloc failure", __func__);
 			rc = -ENOMEM;
 			return rc;
 		}
@@ -481,8 +481,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 					(char *)domain, 2 * len);
 		kfree(domain);
 		if (rc) {
-			cERROR(1, "%s: Could not update with domain",
-								__func__);
+			cifs_vfs_err("%s: Could not update with domain",
+				     __func__);
 			return rc;
 		}
 	} else if (ses->serverName) {
@@ -490,7 +490,6 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (server == NULL) {
-			cERROR(1, "calc_ntlmv2_hash: server mem alloc failure");
 			rc = -ENOMEM;
 			return rc;
 		}
@@ -501,8 +500,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 					(char *)server, 2 * len);
 		kfree(server);
 		if (rc) {
-			cERROR(1, "%s: Could not update with server",
-								__func__);
+			cifs_vfs_err("%s: Could not update with server",
+				     __func__);
 			return rc;
 		}
 	}
@@ -510,7 +509,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 					ntlmv2_hash);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_vfs_err("%s: Could not generate md5 hash", __func__);
 
 	return rc;
 }
@@ -522,20 +521,21 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
 
 	if (!ses->server->secmech.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash");
+		cifs_vfs_err("%s: can't generate ntlmv2 hash", __func__);
 		return -1;
 	}
 
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
 				ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set NTLMV2 Hash as a key", __func__);
+		cifs_vfs_err("%s: Could not set NTLMV2 Hash as a key",
+			     __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
+		cifs_vfs_err("%s: could not init hmacmd5", __func__);
 		return rc;
 	}
 
@@ -548,14 +548,14 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + offset, ses->auth_key.len - offset);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response", __func__);
+		cifs_vfs_err("%s: Could not update with response", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_vfs_err("%s: Could not generate md5 hash", __func__);
 
 	return rc;
 }
@@ -575,14 +575,15 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		if (!ses->domainName) {
 			rc = find_domain_name(ses, nls_cp);
 			if (rc) {
-				cERROR(1, "error %d finding domain name", rc);
+				cifs_vfs_err("error %d finding domain name",
+					     rc);
 				goto setup_ntlmv2_rsp_ret;
 			}
 		}
 	} else {
 		rc = build_avpair_blob(ses, nls_cp);
 		if (rc) {
-			cERROR(1, "error %d building av pair blob", rc);
+			cifs_vfs_err("error %d building av pair blob", rc);
 			goto setup_ntlmv2_rsp_ret;
 		}
 	}
@@ -595,7 +596,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	if (!ses->auth_key.response) {
 		rc = ENOMEM;
 		ses->auth_key.len = 0;
-		cERROR(1, "%s: Can't allocate auth blob", __func__);
+		cifs_vfs_err("%s: Can't allocate auth blob", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 	ses->auth_key.len += baselen;
@@ -613,14 +614,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	/* calculate ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
 	if (rc) {
-		cERROR(1, "could not get v2 hash rc %d", rc);
+		cifs_vfs_err("could not get v2 hash rc %d", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	/* calculate first part of the client response (CR1) */
 	rc = CalcNTLMv2_response(ses, ntlmv2_hash);
 	if (rc) {
-		cERROR(1, "Could not calculate CR1  rc: %d", rc);
+		cifs_vfs_err("Could not calculate CR1 rc: %d", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
@@ -628,13 +629,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
 		ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set NTLMV2 Hash as a key", __func__);
+		cifs_vfs_err("%s: Could not set NTLMV2 Hash as a key",
+			     __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init hmacmd5", __func__);
+		cifs_vfs_err("%s: Could not init hmacmd5", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
@@ -642,14 +644,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE,
 		CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response", __func__);
+		cifs_vfs_err("%s: Could not update with response", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_vfs_err("%s: Could not generate md5 hash", __func__);
 
 setup_ntlmv2_rsp_ret:
 	kfree(tiblob);
@@ -671,7 +673,7 @@ calc_seckey(struct cifs_ses *ses)
 	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm_arc4)) {
 		rc = PTR_ERR(tfm_arc4);
-		cERROR(1, "could not allocate crypto API arc4");
+		cifs_vfs_err("could not allocate crypto API arc4");
 		return rc;
 	}
 
@@ -680,7 +682,7 @@ calc_seckey(struct cifs_ses *ses)
 	rc = crypto_blkcipher_setkey(tfm_arc4, ses->auth_key.response,
 					CIFS_SESS_KEY_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set response as a key", __func__);
+		cifs_vfs_err("%s: Could not set response as a key", __func__);
 		return rc;
 	}
 
@@ -689,7 +691,7 @@ calc_seckey(struct cifs_ses *ses)
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
 	if (rc) {
-		cERROR(1, "could not encrypt session key rc: %d", rc);
+		cifs_vfs_err("could not encrypt session key rc: %d", rc);
 		crypto_free_blkcipher(tfm_arc4);
 		return rc;
 	}
@@ -731,20 +733,20 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 
 	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
 	if (IS_ERR(server->secmech.hmacmd5)) {
-		cERROR(1, "could not allocate crypto hmacmd5");
+		cifs_vfs_err("could not allocate crypto hmacmd5");
 		return PTR_ERR(server->secmech.hmacmd5);
 	}
 
 	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(server->secmech.md5)) {
-		cERROR(1, "could not allocate crypto md5");
+		cifs_vfs_err("could not allocate crypto md5");
 		rc = PTR_ERR(server->secmech.md5);
 		goto crypto_allocate_md5_fail;
 	}
 
 	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
 	if (IS_ERR(server->secmech.hmacsha256)) {
-		cERROR(1, "could not allocate crypto hmacsha256\n");
+		cifs_vfs_err("could not allocate crypto hmacsha256\n");
 		rc = PTR_ERR(server->secmech.hmacsha256);
 		goto crypto_allocate_hmacsha256_fail;
 	}
@@ -753,7 +755,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.hmacmd5);
 	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdeschmacmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5");
 		rc = -ENOMEM;
 		goto crypto_allocate_hmacmd5_sdesc_fail;
 	}
@@ -764,7 +765,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.md5);
 	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdescmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5");
 		rc = -ENOMEM;
 		goto crypto_allocate_md5_sdesc_fail;
 	}
@@ -775,7 +775,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.hmacsha256);
 	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdeschmacsha256) {
-		cERROR(1, "%s: Can't alloc hmacsha256\n", __func__);
 		rc = -ENOMEM;
 		goto crypto_allocate_hmacsha256_sdesc_fail;
 	}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..f4038e5 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -145,7 +145,7 @@ cifs_read_super(struct super_block *sb)
 	return 0;
 
 out_no_root:
-	cERROR(1, "cifs_read_super: get root inode failed");
+	cifs_vfs_err("%s: get root inode failed", __func__);
 	return rc;
 }
 
@@ -631,7 +631,8 @@ cifs_do_mount(struct file_system_type *fs_type,
 	rc = cifs_mount(cifs_sb, volume_info);
 	if (rc) {
 		if (!(flags & MS_SILENT))
-			cERROR(1, "cifs_mount failed w/return code = %d", rc);
+			cifs_vfs_err("cifs_mount failed w/return code = %d",
+				     rc);
 		root = ERR_PTR(rc);
 		goto out_mountdata;
 	}
@@ -1005,7 +1006,7 @@ cifs_init_request_bufs(void)
 	} else {
 		CIFSMaxBufSize &= 0x1FE00; /* Round size to even 512 byte mult*/
 	}
-/*	cERROR(1, "CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize); */
+/*	cifs_vfs_err("CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize); */
 	cifs_req_cachep = kmem_cache_create("cifs_request",
 					    CIFSMaxBufSize + max_hdr_size, 0,
 					    SLAB_HWCACHE_ALIGN, NULL);
@@ -1016,7 +1017,7 @@ cifs_init_request_bufs(void)
 		cifs_min_rcv = 1;
 	else if (cifs_min_rcv > 64) {
 		cifs_min_rcv = 64;
-		cERROR(1, "cifs_min_rcv set to maximum (64)");
+		cifs_vfs_err("cifs_min_rcv set to maximum (64)");
 	}
 
 	cifs_req_poolp = mempool_create_slab_pool(cifs_min_rcv,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8e2e799..752b4d0 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -447,8 +447,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			(secFlags & CIFSSEC_MAY_PLNTXT))
 			server->secType = LANMAN;
 		else {
-			cERROR(1, "mount failed weak security disabled"
-				   " in /proc/fs/cifs/SecurityFlags");
+			cifs_vfs_err("mount failed weak security disabled in /proc/fs/cifs/SecurityFlags");
 			rc = -EOPNOTSUPP;
 			goto neg_err_exit;
 		}
@@ -519,8 +518,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		goto signing_check;
 #else /* weak security disabled */
 	} else if (pSMBr->hdr.WordCount == 13) {
-		cERROR(1, "mount failed, cifs module not built "
-			  "with CIFS_WEAK_PW_HASH support");
+		cifs_vfs_err("mount failed, cifs module not built with CIFS_WEAK_PW_HASH support");
 		rc = -EOPNOTSUPP;
 #endif /* WEAK_PW_HASH */
 		goto neg_err_exit;
@@ -538,8 +536,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((secFlags & CIFSSEC_MAY_PLNTXT) == 0)
 #endif /* CIFS_WEAK_PW_HASH */
-			cERROR(1, "Server requests plain text password"
-				  " but client support disabled");
+			cifs_vfs_err("Server requests plain text password but client support disabled");
 
 	if ((secFlags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
 		server->secType = NTLMv2;
@@ -555,7 +552,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		server->secType = LANMAN;
 	else {
 		rc = -EOPNOTSUPP;
-		cERROR(1, "Invalid security type");
+		cifs_vfs_err("Invalid security type");
 		goto neg_err_exit;
 	}
 	/* else ... any others ...? */
@@ -635,9 +632,7 @@ signing_check:
 		   so if this is zero it means that signing is disabled */
 		cFYI(1, "Signing disabled");
 		if (server->sec_mode & SECMODE_SIGN_REQUIRED) {
-			cERROR(1, "Server requires "
-				   "packet signing to be enabled in "
-				   "/proc/fs/cifs/SecurityFlags.");
+			cifs_vfs_err("Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags");
 			rc = -EOPNOTSUPP;
 		}
 		server->sec_mode &=
@@ -647,7 +642,7 @@ signing_check:
 		cFYI(1, "Must sign - secFlags 0x%x", secFlags);
 		if ((server->sec_mode &
 			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
-			cERROR(1, "signing required but server lacks support");
+			cifs_vfs_err("signing required but server lacks support");
 			rc = -EOPNOTSUPP;
 		} else
 			server->sec_mode |= SECMODE_SIGN_REQUIRED;
@@ -1113,7 +1108,7 @@ PsxCreat:
 	} else {
 		if (get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)
 					+ sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Open response data too small");
+			cifs_vfs_err("Open response data too small");
 			pRetData->Type = cpu_to_le32(-1);
 			goto psx_create_err;
 		}
@@ -1551,8 +1546,8 @@ cifs_readv_callback(struct mid_q_entry *mid)
 			rc = cifs_verify_signature(&rqst, server,
 						  mid->sequence_number + 1);
 			if (rc)
-				cERROR(1, "SMB signature verification returned "
-				       "error = %d", rc);
+				cifs_vfs_err("SMB signature verification returned error = %d",
+					     rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->bytes);
@@ -1701,7 +1696,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
 	pSMBr = (READ_RSP *)iov[0].iov_base;
 	if (rc) {
-		cERROR(1, "Send error in read = %d", rc);
+		cifs_vfs_err("Send error in read = %d", rc);
 	} else {
 		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
 		data_length = data_length << 16;
@@ -1719,7 +1714,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 			pReadData = (char *) (&pSMBr->hdr.Protocol) +
 					le16_to_cpu(pSMBr->DataOffset);
 /*			if (rc = copy_to_user(buf, pReadData, data_length)) {
-				cERROR(1, "Faulting on read rc = %d",rc);
+				cifs_vfs_err("Faulting on read rc = %d",rc);
 				rc = -EFAULT;
 			}*/ /* can not use copy_to_user when using page cache*/
 			if (*buf)
@@ -1959,7 +1954,7 @@ cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
 
 	/* this would overflow */
 	if (nr_pages == 0) {
-		cERROR(1, "%s: called with nr_pages == 0!", __func__);
+		cifs_vfs_err("%s: called with nr_pages == 0!", __func__);
 		return NULL;
 	}
 
@@ -2482,7 +2477,7 @@ CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	if (rc) {
 		if (rc != -EINTR) {
 			/* EINTR is expected when user ctl-c to kill app */
-			cERROR(1, "Send error in Close = %d", rc);
+			cifs_vfs_err("Send error in Close = %d", rc);
 		}
 	}
 
@@ -2509,7 +2504,7 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_flushes);
 	if (rc)
-		cERROR(1, "Send error in Flush = %d", rc);
+		cifs_vfs_err("Send error in Flush = %d", rc);
 
 	return rc;
 }
@@ -3728,8 +3723,8 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 
 		acl_len = le32_to_cpu(*parm);
 		if (acl_len != *pbuflen) {
-			cERROR(1, "acl length %d does not match %d",
-				   acl_len, *pbuflen);
+			cifs_vfs_err("acl length %d does not match %d",
+				     acl_len, *pbuflen);
 			if (*pbuflen > acl_len)
 				*pbuflen = acl_len;
 		}
@@ -3738,7 +3733,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 		   header followed by the smallest SID */
 		if ((*pbuflen < sizeof(struct cifs_ntsd) + 8) ||
 		    (*pbuflen >= 64 * 1024)) {
-			cERROR(1, "bad acl length %d", *pbuflen);
+			cifs_vfs_err("bad acl length %d", *pbuflen);
 			rc = -EINVAL;
 			*pbuflen = 0;
 		} else {
@@ -4109,9 +4104,7 @@ UnixQFileInfoRetry:
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response. "
-				   "Unix Extensions can be disabled on mount "
-				   "by specifying the nosfu mount option.");
+			cifs_vfs_err("Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.");
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4195,9 +4188,7 @@ UnixQPathInfoRetry:
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response. "
-				   "Unix Extensions can be disabled on mount "
-				   "by specifying the nosfu mount option.");
+			cifs_vfs_err("Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.");
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4352,7 +4343,7 @@ findFirstRetry:
 				psrch_inf->entries_in_buffer;
 			lnoff = le16_to_cpu(parms->LastNameOffset);
 			if (CIFSMaxBufSize < lnoff) {
-				cERROR(1, "ignoring corrupt resume name");
+				cifs_vfs_err("ignoring corrupt resume name");
 				psrch_inf->last_entry = NULL;
 				return rc;
 			}
@@ -4479,7 +4470,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 				psrch_inf->entries_in_buffer;
 			lnoff = le16_to_cpu(parms->LastNameOffset);
 			if (CIFSMaxBufSize < lnoff) {
-				cERROR(1, "ignoring corrupt resume name");
+				cifs_vfs_err("ignoring corrupt resume name");
 				psrch_inf->last_entry = NULL;
 				return rc;
 			} else
@@ -4526,7 +4517,7 @@ CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
-		cERROR(1, "Send error in FindClose = %d", rc);
+		cifs_vfs_err("Send error in FindClose = %d", rc);
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_fclose);
 
@@ -4655,16 +4646,16 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	*num_of_nodes = le16_to_cpu(pSMBr->NumberOfReferrals);
 
 	if (*num_of_nodes < 1) {
-		cERROR(1, "num_referrals: must be at least > 0,"
-			"but we get num_referrals = %d", *num_of_nodes);
+		cifs_vfs_err("num_referrals: must be at least > 0, but we get num_referrals = %d",
+			     *num_of_nodes);
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
 
 	ref = (struct dfs_referral_level_3 *) &(pSMBr->referrals);
 	if (ref->VersionNumber != cpu_to_le16(3)) {
-		cERROR(1, "Referrals of V%d version are not supported,"
-			"should be V3", le16_to_cpu(ref->VersionNumber));
+		cifs_vfs_err("Referrals of V%d version are not supported, should be V3",
+			     le16_to_cpu(ref->VersionNumber));
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
@@ -4680,7 +4671,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	*target_nodes = kzalloc(sizeof(struct dfs_info3_param) *
 			*num_of_nodes, GFP_KERNEL);
 	if (*target_nodes == NULL) {
-		cERROR(1, "Failed to allocate buffer for target_nodes");
+		cifs_vfs_err("Failed to allocate buffer for target_nodes");
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
@@ -5062,7 +5053,7 @@ QFSAttributeRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, "Send error in QFSAttributeInfo = %d", rc);
+		cifs_vfs_err("Send error in QFSAttributeInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5203,7 +5194,7 @@ QFSUnixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, "Send error in QFSUnixInfo = %d", rc);
+		cifs_vfs_err("Send error in QFSUnixInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5286,7 +5277,7 @@ SETFSUnixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, "Send error in SETFSUnixInfo = %d", rc);
+		cifs_vfs_err("Send error in SETFSUnixInfo = %d", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		if (rc)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 991c63c..04b552f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -428,7 +428,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 	if (!server->bigbuf) {
 		server->bigbuf = (char *)cifs_buf_get();
 		if (!server->bigbuf) {
-			cERROR(1, "No memory for large SMB response");
+			cifs_vfs_err("No memory for large SMB response");
 			msleep(3000);
 			/* retry will check if exiting */
 			return false;
@@ -441,7 +441,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 	if (!server->smallbuf) {
 		server->smallbuf = (char *)cifs_small_buf_get();
 		if (!server->smallbuf) {
-			cERROR(1, "No memory for SMB response");
+			cifs_vfs_err("No memory for SMB response");
 			msleep(1000);
 			/* retry will check if exiting */
 			return false;
@@ -471,9 +471,8 @@ server_unresponsive(struct TCP_Server_Info *server)
 	 */
 	if (server->tcpStatus == CifsGood &&
 	    time_after(jiffies, server->lstrp + 2 * SMB_ECHO_INTERVAL)) {
-		cERROR(1, "Server %s has not responded in %d seconds. "
-			  "Reconnecting...", server->hostname,
-			  (2 * SMB_ECHO_INTERVAL) / HZ);
+		cifs_vfs_err("Server %s has not responded in %d seconds. Reconnecting...",
+			     server->hostname, (2 * SMB_ECHO_INTERVAL) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
@@ -643,7 +642,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		wake_up(&server->response_q);
 		break;
 	default:
-		cERROR(1, "RFC 1002 unknown response type 0x%x", type);
+		cifs_vfs_err("RFC 1002 unknown response type 0x%x", type);
 		cifs_reconnect(server);
 	}
 
@@ -782,8 +781,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* make sure this will fit in a large buffer */
 	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) - 4) {
-		cERROR(1, "SMB response too long (%u bytes)",
-			pdu_length);
+		cifs_vfs_err("SMB response too long (%u bytes)", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -EAGAIN;
@@ -877,8 +875,8 @@ cifs_demultiplex_thread(void *p)
 
 		/* make sure we have enough to get to the MID */
 		if (pdu_length < HEADER_SIZE(server) - 1 - 4) {
-			cERROR(1, "SMB response too short (%u bytes)",
-				pdu_length);
+			cifs_vfs_err("SMB response too short (%u bytes)",
+				     pdu_length);
 			cifs_reconnect(server);
 			wake_up(&server->response_q);
 			continue;
@@ -910,8 +908,8 @@ cifs_demultiplex_thread(void *p)
 				mid_entry->callback(mid_entry);
 		} else if (!server->ops->is_oplock_break ||
 			   !server->ops->is_oplock_break(buf, server)) {
-			cERROR(1, "No task to wake, unknown frame received! "
-				   "NumMids %d", atomic_read(&midCount));
+			cifs_vfs_err("No task to wake, unknown frame received! NumMids %d",
+				     atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
 				      HEADER_SIZE(server));
 #ifdef CONFIG_CIFS_DEBUG2
@@ -1037,7 +1035,7 @@ static int cifs_parse_security_flavors(char *value,
 		break;
 	case Opt_sec_krb5p:
 		/* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
-		cERROR(1, "Krb5 cifs privacy not supported");
+		cifs_vfs_err("Krb5 cifs privacy not supported");
 		break;
 	case Opt_sec_ntlmssp:
 		vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
@@ -1067,7 +1065,7 @@ static int cifs_parse_security_flavors(char *value,
 		vol->nullauth = 1;
 		break;
 	default:
-		cERROR(1, "bad security option: %s", value);
+		cifs_vfs_err("bad security option: %s", value);
 		return 1;
 	}
 
@@ -1093,7 +1091,7 @@ cifs_parse_cache_flavor(char *value, struct smb_vol *vol)
 		vol->strict_io = false;
 		break;
 	default:
-		cERROR(1, "bad cache= option: %s", value);
+		cifs_vfs_err("bad cache= option: %s", value);
 		return 1;
 	}
 	return 0;
@@ -1124,7 +1122,7 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 		break;
 #endif
 	default:
-		cERROR(1, "Unknown vers= option specified: %s", value);
+		cifs_vfs_err("Unknown vers= option specified: %s", value);
 		return 1;
 	}
 	return 0;
@@ -1440,8 +1438,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			break;
 		case Opt_fsc:
 #ifndef CONFIG_CIFS_FSCACHE
-			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE "
-				  "kernel config option set");
+			cifs_vfs_err("FS-Cache support needs CONFIG_CIFS_FSCACHE kernel config option set");
 			goto cifs_parse_mount_err;
 #endif
 			vol->fsc = true;
@@ -1459,55 +1456,53 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		/* Numeric Values */
 		case Opt_backupuid:
 			if (get_option_uid(args, &vol->backupuid)) {
-				cERROR(1, "%s: Invalid backupuid value",
-					__func__);
+				cifs_vfs_err("%s: Invalid backupuid value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->backupuid_specified = true;
 			break;
 		case Opt_backupgid:
 			if (get_option_gid(args, &vol->backupgid)) {
-				cERROR(1, "%s: Invalid backupgid value",
-					__func__);
+				cifs_vfs_err("%s: Invalid backupgid value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->backupgid_specified = true;
 			break;
 		case Opt_uid:
 			if (get_option_uid(args, &vol->linux_uid)) {
-				cERROR(1, "%s: Invalid uid value",
-					__func__);
+				cifs_vfs_err("%s: Invalid uid value", __func__);
 				goto cifs_parse_mount_err;
 			}
 			uid_specified = true;
 			break;
 		case Opt_cruid:
 			if (get_option_uid(args, &vol->cred_uid)) {
-				cERROR(1, "%s: Invalid cruid value",
-					__func__);
+				cifs_vfs_err("%s: Invalid cruid value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			break;
 		case Opt_gid:
 			if (get_option_gid(args, &vol->linux_gid)) {
-				cERROR(1, "%s: Invalid gid value",
-						__func__);
+				cifs_vfs_err("%s: Invalid gid value", __func__);
 				goto cifs_parse_mount_err;
 			}
 			gid_specified = true;
 			break;
 		case Opt_file_mode:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid file_mode value",
-					__func__);
+				cifs_vfs_err("%s: Invalid file_mode value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->file_mode = option;
 			break;
 		case Opt_dirmode:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid dir_mode value",
-					__func__);
+				cifs_vfs_err("%s: Invalid dir_mode value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->dir_mode = option;
@@ -1515,37 +1510,37 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_port:
 			if (get_option_ul(args, &option) ||
 			    option > USHRT_MAX) {
-				cERROR(1, "%s: Invalid port value", __func__);
+				cifs_vfs_err("%s: Invalid port value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			port = (unsigned short)option;
 			break;
 		case Opt_rsize:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid rsize value",
-					__func__);
+				cifs_vfs_err("%s: Invalid rsize value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->rsize = option;
 			break;
 		case Opt_wsize:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid wsize value",
-					__func__);
+				cifs_vfs_err("%s: Invalid wsize value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->wsize = option;
 			break;
 		case Opt_actimeo:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid actimeo value",
-					__func__);
+				cifs_vfs_err("%s: Invalid actimeo value",
+					     __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->actimeo = HZ * option;
 			if (vol->actimeo > CIFS_MAX_ACTIMEO) {
-				cERROR(1, "CIFS: attribute cache"
-					  "timeout too large");
+				cifs_vfs_err("attribute cache timeout too large");
 				goto cifs_parse_mount_err;
 			}
 			break;
@@ -1863,20 +1858,18 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (vol->multiuser) {
-		cERROR(1, "Multiuser mounts require kernels with "
-			  "CONFIG_KEYS enabled.");
+		cifs_vfs_err("Multiuser mounts require kernels with CONFIG_KEYS enabled");
 		goto cifs_parse_mount_err;
 	}
 #endif
 	if (!vol->UNC) {
-		cERROR(1, "CIFS mount error: No usable UNC path provided in "
-			  "device string or in unc= option!");
+		cifs_vfs_err("CIFS mount error: No usable UNC path provided in device string or in unc= option!");
 		goto cifs_parse_mount_err;
 	}
 
 	/* make sure UNC has a share name */
 	if (!strchr(vol->UNC + 3, '\\')) {
-		cERROR(1, "Malformed UNC. Unable to find share name.");
+		cifs_vfs_err("Malformed UNC. Unable to find share name.");
 		goto cifs_parse_mount_err;
 	}
 
@@ -2159,7 +2152,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	rc = cifs_crypto_shash_allocate(tcp_ses);
 	if (rc) {
-		cERROR(1, "could not setup hash structures rc %d", rc);
+		cifs_vfs_err("could not setup hash structures rc %d", rc);
 		goto out_err;
 	}
 
@@ -2206,7 +2199,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
-		cERROR(1, "Error connecting to socket. Aborting operation");
+		cifs_vfs_err("Error connecting to socket. Aborting operation.");
 		goto out_err_crypto_release;
 	}
 
@@ -2219,7 +2212,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 				  tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
 		rc = PTR_ERR(tcp_ses->tsk);
-		cERROR(1, "error %d create cifsd thread", rc);
+		cifs_vfs_err("error %d create cifsd thread", rc);
 		module_put(THIS_MODULE);
 		goto out_err_crypto_release;
 	}
@@ -2617,8 +2610,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		/* existing tcon already has a reference */
 		cifs_put_smb_ses(ses);
 		if (tcon->seal != volume_info->seal)
-			cERROR(1, "transport encryption setting "
-				   "conflicts with existing tid");
+			cifs_vfs_err("transport encryption setting conflicts with existing tid");
 		return tcon;
 	}
 
@@ -2888,13 +2880,11 @@ bind_socket(struct TCP_Server_Info *server)
 			saddr4 = (struct sockaddr_in *)&server->srcaddr;
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
-				cERROR(1, "cifs: "
-				       "Failed to bind to: %pI6c, error: %d",
-				       &saddr6->sin6_addr, rc);
+				cifs_vfs_err("Failed to bind to: %pI6c, error: %d",
+					     &saddr6->sin6_addr, rc);
 			else
-				cERROR(1, "cifs: "
-				       "Failed to bind to: %pI4, error: %d",
-				       &saddr4->sin_addr.s_addr, rc);
+				cifs_vfs_err("Failed to bind to: %pI4, error: %d",
+					     &saddr4->sin_addr.s_addr, rc);
 		}
 	}
 	return rc;
@@ -2999,7 +2989,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
 				   IPPROTO_TCP, &socket, 1);
 		if (rc < 0) {
-			cERROR(1, "Error %d creating socket", rc);
+			cifs_vfs_err("Error %d creating socket", rc);
 			server->ssocket = NULL;
 			return rc;
 		}
@@ -3128,16 +3118,16 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 				cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 			if ((saved_cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
 				if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-					cERROR(1, "POSIXPATH support change");
+					cifs_vfs_err("POSIXPATH support change");
 				cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 			} else if ((cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
-				cERROR(1, "possible reconnect error");
-				cERROR(1, "server disabled POSIX path support");
+				cifs_vfs_err("possible reconnect error");
+				cifs_vfs_err("server disabled POSIX path support");
 			}
 		}
 
 		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
-			cERROR(1, "per-share encryption not supported yet");
+			cifs_vfs_err("per-share encryption not supported yet");
 
 		cap &= CIFS_UNIX_CAP_MASK;
 		if (vol_info && vol_info->no_psx_acl)
@@ -3183,12 +3173,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 			if (vol_info == NULL) {
 				cFYI(1, "resetting capabilities failed");
 			} else
-				cERROR(1, "Negotiating Unix capabilities "
-					   "with the server failed. Consider "
-					   "mounting with the Unix Extensions "
-					   "disabled if problems are found "
-					   "by specifying the nounix mount "
-					   "option.");
+				cifs_vfs_err("Negotiating Unix capabilities with the server failed. Consider mounting with the Unix Extensions disabled if problems are found by specifying the nounix mount option.");
 
 		}
 	}
@@ -3268,16 +3253,14 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	}
 	if (pvolume_info->mfsymlinks) {
 		if (pvolume_info->sfu_emul) {
-			cERROR(1,  "mount option mfsymlinks ignored if sfu "
-				   "mount option is used");
+			cifs_vfs_err("mount option mfsymlinks ignored if sfu mount option is used");
 		} else {
 			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
 		}
 	}
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
-		cERROR(1, "mount option dynperm ignored if cifsacl "
-			   "mount option supported");
+		cifs_vfs_err("mount option dynperm ignored if cifsacl mount option supported");
 }
 
 static void
@@ -3407,7 +3390,7 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 		/* BB fixme parse for domain name here */
 		cFYI(1, "Username: %s", volume_info->username);
 	} else {
-		cifserror("No username specified");
+		cifs_vfs_err("No username specified");
 	/* In userspace mount helper we can get user name from alternate
 	   locations such as env variables and files on disk */
 		return -EINVAL;
@@ -3420,8 +3403,8 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 	} else {
 		volume_info->local_nls = load_nls(volume_info->iocharset);
 		if (volume_info->local_nls == NULL) {
-			cERROR(1, "CIFS mount error: iocharset %s not found",
-				 volume_info->iocharset);
+			cifs_vfs_err("CIFS mount error: iocharset %s not found",
+				     volume_info->iocharset);
 			return -ELIBACC;
 		}
 	}
@@ -3882,7 +3865,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		rc = server->ops->sess_setup(xid, ses, nls_info);
 
 	if (rc) {
-		cERROR(1, "Send error in SessSetup = %d", rc);
+		cifs_vfs_err("Send error in SessSetup = %d", rc);
 	} else {
 		mutex_lock(&ses->server->srv_mutex);
 		if (!server->session_estab) {
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 1cd0162..b158e77 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -102,7 +102,7 @@ cifs_bp_rename_retry:
 		namelen += (1 + temp->d_name.len);
 		temp = temp->d_parent;
 		if (temp == NULL) {
-			cERROR(1, "corrupt dentry");
+			cifs_vfs_err("corrupt dentry");
 			rcu_read_unlock();
 			return NULL;
 		}
@@ -129,7 +129,7 @@ cifs_bp_rename_retry:
 		spin_unlock(&temp->d_lock);
 		temp = temp->d_parent;
 		if (temp == NULL) {
-			cERROR(1, "corrupt dentry");
+			cifs_vfs_err("corrupt dentry");
 			rcu_read_unlock();
 			kfree(full_path);
 			return NULL;
@@ -742,7 +742,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	/*	if it was once a directory (but how can we tell?) we could do
 		shrink_dcache_parent(direntry); */
 	} else if (rc != -EACCES) {
-		cERROR(1, "Unexpected lookup error %d", rc);
+		cifs_vfs_err("Unexpected lookup error %d", rc);
 		/* We special case check for Access Denied - since that
 		is a common return code */
 	}
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8c0d855..e742d5a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -470,12 +470,9 @@ int cifs_open(struct inode *inode, struct file *file)
 			posix_open_ok = true;
 		} else if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			if (tcon->ses->serverNOS)
-				cERROR(1, "server %s of type %s returned"
-					   " unexpected error on SMB posix open"
-					   ", disabling posix open support."
-					   " Check if server update available.",
-					   tcon->ses->serverName,
-					   tcon->ses->serverNOS);
+				cifs_vfs_err("server %s of type %s returned unexpected error on SMB posix open, disabling posix open support. Check if server update available.",
+					     tcon->ses->serverName,
+					     tcon->ses->serverNOS);
 			tcon->broken_posix_open = true;
 		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
 			 (rc != -EOPNOTSUPP)) /* path not found or net err */
@@ -1136,7 +1133,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 			 * The list ended. We don't have enough allocated
 			 * structures - something is really wrong.
 			 */
-			cERROR(1, "Can't push all brlocks!");
+			cifs_vfs_err("Can't push all brlocks!");
 			break;
 		}
 		length = 1 + flock->fl_end - flock->fl_start;
@@ -1292,8 +1289,8 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 					    type, 0, 1, false);
 		flock->fl_type = F_UNLCK;
 		if (rc != 0)
-			cERROR(1, "Error unlocking previously locked "
-				  "range %d during test of lock", rc);
+			cifs_vfs_err("Error unlocking previously locked range %d during test of lock",
+				     rc);
 		return 0;
 	}
 
@@ -1312,8 +1309,8 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 			type | server->vals->shared_lock_type, 0, 1, false);
 		flock->fl_type = F_RDLCK;
 		if (rc != 0)
-			cERROR(1, "Error unlocking previously locked "
-				  "range %d during test of lock", rc);
+			cifs_vfs_err("Error unlocking previously locked range %d during test of lock",
+				     rc);
 	} else
 		flock->fl_type = F_WRLCK;
 
@@ -1732,7 +1729,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 	it being zero) during stress testcases so we need to check for it */
 
 	if (cifs_inode == NULL) {
-		cERROR(1, "Null inode passed to cifs_writeable_file");
+		cifs_vfs_err("Null inode passed to cifs_writeable_file");
 		dump_stack();
 		return NULL;
 	}
@@ -2011,7 +2008,7 @@ retry:
 			wdata->cfile = find_writable_file(CIFS_I(mapping->host),
 							  false);
 			if (!wdata->cfile) {
-				cERROR(1, "No writable handles for inode");
+				cifs_vfs_err("No writable handles for inode");
 				rc = -EBADF;
 				break;
 			}
@@ -3610,7 +3607,7 @@ void cifs_oplock_break(struct work_struct *work)
 
 	rc = cifs_push_locks(cfile);
 	if (rc)
-		cERROR(1, "Push locks rc = %d", rc);
+		cifs_vfs_err("Push locks rc = %d", rc);
 
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 42e5363..467b63d 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -173,7 +173,7 @@ int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
 		return 1;
 
 	default:
-		cERROR(1, "unknown error ret = %d", ret);
+		cifs_vfs_err("unknown error ret = %d", ret);
 	}
 	return ret;
 }
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0079696..851ec8d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1683,8 +1683,8 @@ cifs_invalidate_mapping(struct inode *inode)
 	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		rc = invalidate_inode_pages2(inode->i_mapping);
 		if (rc) {
-			cERROR(1, "%s: could not invalidate inode %p", __func__,
-			       inode);
+			cifs_vfs_err("%s: could not invalidate inode %p",
+				     __func__, inode);
 			cifs_i->invalid_mapping = true;
 		}
 	}
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 9f6c4c4..27496f2 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -56,14 +56,14 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 	md5 = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(md5)) {
 		rc = PTR_ERR(md5);
-		cERROR(1, "%s: Crypto md5 allocation error %d", __func__, rc);
+		cifs_vfs_err("%s: Crypto md5 allocation error %d",
+			     __func__, rc);
 		return rc;
 	}
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(md5);
 	sdescmd5 = kmalloc(size, GFP_KERNEL);
 	if (!sdescmd5) {
 		rc = -ENOMEM;
-		cERROR(1, "%s: Memory allocation failure", __func__);
 		goto symlink_hash_err;
 	}
 	sdescmd5->shash.tfm = md5;
@@ -71,17 +71,17 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 
 	rc = crypto_shash_init(&sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5 shash", __func__);
+		cifs_vfs_err("%s: Could not init md5 shash", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with link_str", __func__);
+		cifs_vfs_err("%s: Could not update with link_str", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_vfs_err("%s: Could not generate md5 hash", __func__);
 
 symlink_hash_err:
 	crypto_free_shash(md5);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1b15bf8..d05bfc6 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -282,15 +282,15 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 {
 	/* does it have the right SMB "signature" ? */
 	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
-		cERROR(1, "Bad protocol string signature header 0x%x",
-			*(unsigned int *)smb->Protocol);
+		cifs_vfs_err("Bad protocol string signature header 0x%x",
+			     *(unsigned int *)smb->Protocol);
 		return 1;
 	}
 
 	/* Make sure that message ids match */
 	if (mid != smb->Mid) {
-		cERROR(1, "Mids do not match. received=%u expected=%u",
-			smb->Mid, mid);
+		cifs_vfs_err("Mids do not match. received=%u expected=%u",
+			     smb->Mid, mid);
 		return 1;
 	}
 
@@ -302,7 +302,7 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 	if (smb->Command == SMB_COM_LOCKING_ANDX)
 		return 0;
 
-	cERROR(1, "Server sent request, not response. mid=%u", smb->Mid);
+	cifs_vfs_err("Server sent request, not response. mid=%u", smb->Mid);
 	return 1;
 }
 
@@ -340,9 +340,9 @@ checkSMB(char *buf, unsigned int total_read)
 				tmp[sizeof(struct smb_hdr)+1] = 0;
 				return 0;
 			}
-			cERROR(1, "rcvd invalid byte count (bcc)");
+			cifs_vfs_err("rcvd invalid byte count (bcc)");
 		} else {
-			cERROR(1, "Length less than smb header size");
+			cifs_vfs_err("Length less than smb header size");
 		}
 		return -EIO;
 	}
@@ -353,8 +353,8 @@ checkSMB(char *buf, unsigned int total_read)
 	clc_len = smbCalcSize(smb);
 
 	if (4 + rfclen != total_read) {
-		cERROR(1, "Length read does not match RFC1001 length %d",
-				rfclen);
+		cifs_vfs_err("Length read does not match RFC1001 length %d",
+			     rfclen);
 		return -EIO;
 	}
 
@@ -369,8 +369,8 @@ checkSMB(char *buf, unsigned int total_read)
 				clc_len, 4 + rfclen, smb->Mid);
 
 		if (4 + rfclen < clc_len) {
-			cERROR(1, "RFC1001 size %u smaller than SMB for mid=%u",
-					rfclen, smb->Mid);
+			cifs_vfs_err("RFC1001 size %u smaller than SMB for mid=%u",
+				     rfclen, smb->Mid);
 			return -EIO;
 		} else if (rfclen > clc_len + 512) {
 			/*
@@ -382,8 +382,8 @@ checkSMB(char *buf, unsigned int total_read)
 			 * trailing data, we choose limit the amount of extra
 			 * data to 512 bytes.
 			 */
-			cERROR(1, "RFC1001 size %u more than 512 bytes larger "
-				  "than SMB for mid=%u", rfclen, smb->Mid);
+			cifs_vfs_err("RFC1001 size %u more than 512 bytes larger than SMB for mid=%u",
+				     rfclen, smb->Mid);
 			return -EIO;
 		}
 	}
@@ -536,12 +536,8 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
 		cifs_sb->mnt_cifs_flags &= ~CIFS_MOUNT_SERVER_INUM;
-		cERROR(1, "Autodisabling the use of server inode numbers on "
-			   "%s. This server doesn't seem to support them "
-			   "properly. Hardlinks will not be recognized on this "
-			   "mount. Consider mounting with the \"noserverino\" "
-			   "option to silence this message.",
-			   cifs_sb_master_tcon(cifs_sb)->treeName);
+		cifs_vfs_err("Autodisabling the use of server inode numbers on %s. This server doesn't seem to support them properly. Hardlinks will not be recognized on this mount. Consider mounting with the \"noserverino\" option to silence this message.",
+			     cifs_sb_master_tcon(cifs_sb)->treeName);
 	}
 }
 
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index a82bc51..36f8845 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -956,15 +956,15 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	sec = 2 * st->TwoSeconds;
 	min = st->Minutes;
 	if ((sec > 59) || (min > 59))
-		cERROR(1, "illegal time min %d sec %d", min, sec);
+		cifs_vfs_err("illegal time min %d sec %d", min, sec);
 	sec += (min * 60);
 	sec += 60 * 60 * st->Hours;
 	if (st->Hours > 24)
-		cERROR(1, "illegal hours %d", st->Hours);
+		cifs_vfs_err("illegal hours %d", st->Hours);
 	days = sd->Day;
 	month = sd->Month;
 	if ((days > 31) || (month > 12)) {
-		cERROR(1, "illegal date, month %d day: %d", month, days);
+		cifs_vfs_err("illegal date, month %d day: %d", month, days);
 		if (month > 12)
 			month = 12;
 	}
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index df40cc5..25a1186 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -356,15 +356,15 @@ static char *nxt_dir_entry(char *old_entry, char *end_of_smb, int level)
 	cFYI(1, "new entry %p old entry %p", new_entry, old_entry);
 	/* validate that new_entry is not past end of SMB */
 	if (new_entry >= end_of_smb) {
-		cERROR(1, "search entry %p began after end of SMB %p old entry %p",
-			new_entry, end_of_smb, old_entry);
+		cifs_vfs_err("search entry %p began after end of SMB %p old entry %p",
+			     new_entry, end_of_smb, old_entry);
 		return NULL;
 	} else if (((level == SMB_FIND_FILE_INFO_STANDARD) &&
 		    (new_entry + sizeof(FIND_FILE_STANDARD_INFO) > end_of_smb))
 		  || ((level != SMB_FIND_FILE_INFO_STANDARD) &&
 		   (new_entry + sizeof(FILE_DIRECTORY_INFO) > end_of_smb)))  {
-		cERROR(1, "search entry %p extends after end of SMB %p",
-			new_entry, end_of_smb);
+		cifs_vfs_err("search entry %p extends after end of SMB %p",
+			     new_entry, end_of_smb);
 		return NULL;
 	} else
 		return new_entry;
@@ -640,9 +640,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		if ((cur_ent == NULL) && (i < pos_in_buf)) {
 			/* BB fixme - check if we should flag this error */
-			cERROR(1, "reached end of buf searching for pos in buf"
-				  " %d index to find %lld rc %d", pos_in_buf,
-				  index_to_find, rc);
+			cifs_vfs_err("reached end of buf searching for pos in buf %d index to find %lld rc %d",
+				     pos_in_buf, index_to_find, rc);
 		}
 		rc = 0;
 		*current_entry = cur_ent;
@@ -678,8 +677,8 @@ static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
 		return rc;
 
 	if (de.namelen > max_len) {
-		cERROR(1, "bad search response length %zd past smb end",
-			  de.namelen);
+		cifs_vfs_err("bad search response length %zd past smb end",
+			     de.namelen);
 		return -EINVAL;
 	}
 
@@ -777,7 +776,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	case 0:
 		if (filldir(direntry, ".", 1, file->f_pos,
 		     file_inode(file)->i_ino, DT_DIR) < 0) {
-			cERROR(1, "Filldir for current dir failed");
+			cifs_vfs_err("Filldir for current dir failed");
 			rc = -ENOMEM;
 			break;
 		}
@@ -785,7 +784,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	case 1:
 		if (filldir(direntry, "..", 2, file->f_pos,
 		     parent_ino(file->f_path.dentry), DT_DIR) < 0) {
-			cERROR(1, "Filldir for parent dir failed");
+			cifs_vfs_err("Filldir for parent dir failed");
 			rc = -ENOMEM;
 			break;
 		}
@@ -840,8 +839,8 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
 			if (current_entry == NULL) {
 				/* evaluate whether this case is an error */
-				cERROR(1, "past SMB end,  num to fill %d i %d",
-					  num_to_fill, i);
+				cifs_vfs_err("past SMB end,  num to fill %d i %d",
+					     num_to_fill, i);
 				break;
 			}
 			/*
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 76809f4..64468e8 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -373,16 +373,16 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
-		cERROR(1, "challenge blob len %d too small", blob_len);
+		cifs_vfs_err("challenge blob len %d too small", blob_len);
 		return -EINVAL;
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cERROR(1, "blob signature incorrect %s", pblob->Signature);
+		cifs_vfs_err("blob signature incorrect %s", pblob->Signature);
 		return -EINVAL;
 	}
 	if (pblob->MessageType != NtLmChallenge) {
-		cERROR(1, "Incorrect message type %d", pblob->MessageType);
+		cifs_vfs_err("Incorrect message type %d", pblob->MessageType);
 		return -EINVAL;
 	}
 
@@ -395,13 +395,14 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	tioffset = le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
 	tilen = le16_to_cpu(pblob->TargetInfoArray.Length);
 	if (tioffset > blob_len || tioffset + tilen > blob_len) {
-		cERROR(1, "tioffset + tilen too high %u + %u", tioffset, tilen);
+		cifs_vfs_err("tioffset + tilen too high %u + %u",
+			     tioffset, tilen);
 		return -EINVAL;
 	}
 	if (tilen) {
 		ses->auth_key.response = kmalloc(tilen, GFP_KERNEL);
 		if (!ses->auth_key.response) {
-			cERROR(1, "Challenge target info allocation failure");
+			cifs_vfs_err("Challenge target info allocation failure");
 			return -ENOMEM;
 		}
 		memcpy(ses->auth_key.response, bcc_ptr + tioffset, tilen);
@@ -486,7 +487,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
 	rc = setup_ntlmv2_rsp(ses, nls_cp);
 	if (rc) {
-		cERROR(1, "Error %d during NTLMSSP authentication", rc);
+		cifs_vfs_err("Error %d during NTLMSSP authentication", rc);
 		goto setup_ntlmv2_ret;
 	}
 	memcpy(tmp, ses->auth_key.response + CIFS_SESS_KEY_SIZE,
@@ -688,7 +689,7 @@ ssetup_ntlmssp_authenticate:
 		/* calculate ntlm response and session key */
 		rc = setup_ntlm_response(ses, nls_cp);
 		if (rc) {
-			cERROR(1, "Error %d during NTLM authentication", rc);
+			cifs_vfs_err("Error %d during NTLM authentication", rc);
 			goto ssetup_exit;
 		}
 
@@ -718,7 +719,8 @@ ssetup_ntlmssp_authenticate:
 		/* calculate nlmv2 response and session key */
 		rc = setup_ntlmv2_rsp(ses, nls_cp);
 		if (rc) {
-			cERROR(1, "Error %d during NTLMv2 authentication", rc);
+			cifs_vfs_err("Error %d during NTLMv2 authentication",
+				     rc);
 			goto ssetup_exit;
 		}
 		memcpy(bcc_ptr, ses->auth_key.response + CIFS_SESS_KEY_SIZE,
@@ -754,17 +756,14 @@ ssetup_ntlmssp_authenticate:
 		/* check version field to make sure that cifs.upcall is
 		   sending us a response in an expected form */
 		if (msg->version != CIFS_SPNEGO_UPCALL_VERSION) {
-			cERROR(1, "incorrect version of cifs.upcall (expected"
-				   " %d but got %d)",
-				   CIFS_SPNEGO_UPCALL_VERSION, msg->version);
+			cifs_vfs_err("incorrect version of cifs.upcall (expected %d but got %d)",
+				     CIFS_SPNEGO_UPCALL_VERSION, msg->version);
 			rc = -EKEYREJECTED;
 			goto ssetup_exit;
 		}
 
 		ses->auth_key.response = kmalloc(msg->sesskey_len, GFP_KERNEL);
 		if (!ses->auth_key.response) {
-			cERROR(1, "Kerberos can't allocate (%u bytes) memory",
-					msg->sesskey_len);
 			rc = -ENOMEM;
 			goto ssetup_exit;
 		}
@@ -790,13 +789,13 @@ ssetup_ntlmssp_authenticate:
 		/* BB: is this right? */
 			ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
 #else /* ! CONFIG_CIFS_UPCALL */
-		cERROR(1, "Kerberos negotiated but upcall support disabled!");
+		cifs_vfs_err("Kerberos negotiated but upcall support disabled!");
 		rc = -ENOSYS;
 		goto ssetup_exit;
 #endif /* CONFIG_CIFS_UPCALL */
 	} else if (type == RawNTLMSSP) {
 		if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-			cERROR(1, "NTLMSSP requires Unicode support");
+			cifs_vfs_err("NTLMSSP requires Unicode support");
 			rc = -ENOSYS;
 			goto ssetup_exit;
 		}
@@ -824,7 +823,6 @@ ssetup_ntlmssp_authenticate:
 				5*sizeof(struct _AUTHENTICATE_MESSAGE),
 				GFP_KERNEL);
 			if (!ntlmsspblob) {
-				cERROR(1, "Can't allocate NTLMSSP blob");
 				rc = -ENOMEM;
 				goto ssetup_exit;
 			}
@@ -844,7 +842,7 @@ ssetup_ntlmssp_authenticate:
 			smb_buf->Uid = ses->Suid;
 			break;
 		default:
-			cERROR(1, "invalid phase %d", phase);
+			cifs_vfs_err("invalid phase %d", phase);
 			rc = -ENOSYS;
 			goto ssetup_exit;
 		}
@@ -855,7 +853,7 @@ ssetup_ntlmssp_authenticate:
 		}
 		unicode_oslm_strings(&bcc_ptr, nls_cp);
 	} else {
-		cERROR(1, "secType %d not supported!", type);
+		cifs_vfs_err("secType %d not supported!", type);
 		rc = -ENOSYS;
 		goto ssetup_exit;
 	}
@@ -880,7 +878,7 @@ ssetup_ntlmssp_authenticate:
 	    (smb_buf->Status.CifsError ==
 			cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))) {
 		if (phase != NtLmNegotiate) {
-			cERROR(1, "Unexpected more processing error");
+			cifs_vfs_err("Unexpected more processing error");
 			goto ssetup_exit;
 		}
 		/* NTLMSSP Negotiate sent now processing challenge (response) */
@@ -892,7 +890,7 @@ ssetup_ntlmssp_authenticate:
 
 	if ((smb_buf->WordCount != 3) && (smb_buf->WordCount != 4)) {
 		rc = -EIO;
-		cERROR(1, "bad word count %d", smb_buf->WordCount);
+		cifs_vfs_err("bad word count %d", smb_buf->WordCount);
 		goto ssetup_exit;
 	}
 	action = le16_to_cpu(pSMB->resp.Action);
@@ -908,7 +906,7 @@ ssetup_ntlmssp_authenticate:
 	if (smb_buf->WordCount == 4) {
 		blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
 		if (blob_len > bytes_remaining) {
-			cERROR(1, "bad security blob length %d", blob_len);
+			cifs_vfs_err("bad security blob length %d", blob_len);
 			rc = -EINVAL;
 			goto ssetup_exit;
 		}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 47bc5a8..0a44086 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -271,8 +271,8 @@ check2ndT2(char *buf)
 	cFYI(1, "missing %d bytes from transact2, check next response",
 		remaining);
 	if (total_data_size > CIFSMaxBufSize) {
-		cERROR(1, "TotalDataSize %d is over maximum buffer %d",
-			total_data_size, CIFSMaxBufSize);
+		cifs_vfs_err("TotalDataSize %d is over maximum buffer %d",
+			     total_data_size, CIFSMaxBufSize);
 		return -EINVAL;
 	}
 	return remaining;
@@ -388,7 +388,7 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	}
 	if (!server->large_buf) {
 		/*FIXME: switch to already allocated largebuf?*/
-		cERROR(1, "1st trans2 resp needs bigbuf");
+		cifs_vfs_err("1st trans2 resp needs bigbuf");
 	} else {
 		/* Have first buffer */
 		mid->resp_buf = buf;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 7064824..46247ac 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -92,7 +92,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 				      (FILE_BASIC_INFO *)data);
 		break;
 	default:
-		cERROR(1, "Invalid command");
+		cifs_vfs_err("Invalid command");
 		break;
 	}
 
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b1c5e3..bcfd494 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -45,17 +45,17 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
 			if (hdr->Command == SMB2_OPLOCK_BREAK)
 				return 0;
 			else
-				cERROR(1, "Received Request not response");
+				cifs_vfs_err("Received Request not response");
 		}
 	} else { /* bad signature or mid */
 		if (*(__le32 *)hdr->ProtocolId != SMB2_PROTO_NUMBER)
-			cERROR(1, "Bad protocol string signature header %x",
-				  *(unsigned int *) hdr->ProtocolId);
+			cifs_vfs_err("Bad protocol string signature header %x",
+				     *(unsigned int *) hdr->ProtocolId);
 		if (mid != hdr->MessageId)
-			cERROR(1, "Mids do not match: %llu and %llu", mid,
-				  hdr->MessageId);
+			cifs_vfs_err("Mids do not match: %llu and %llu",
+				     mid, hdr->MessageId);
 	}
-	cERROR(1, "Bad SMB detected. The Mid=%llu", hdr->MessageId);
+	cifs_vfs_err("Bad SMB detected. The Mid=%llu", hdr->MessageId);
 	return 1;
 }
 
@@ -117,12 +117,12 @@ smb2_check_message(char *buf, unsigned int length)
 			 */
 			return 0;
 		} else {
-			cERROR(1, "Length less than SMB header size");
+			cifs_vfs_err("Length less than SMB header size");
 		}
 		return 1;
 	}
 	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
-		cERROR(1, "SMB length greater than maximum, mid=%llu", mid);
+		cifs_vfs_err("SMB length greater than maximum, mid=%llu", mid);
 		return 1;
 	}
 
@@ -130,14 +130,14 @@ smb2_check_message(char *buf, unsigned int length)
 		return 1;
 
 	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
-		cERROR(1, "Illegal structure size %u",
-			  le16_to_cpu(hdr->StructureSize));
+		cifs_vfs_err("Illegal structure size %u",
+			     le16_to_cpu(hdr->StructureSize));
 		return 1;
 	}
 
 	command = le16_to_cpu(hdr->Command);
 	if (command >= NUMBER_OF_SMB2_COMMANDS) {
-		cERROR(1, "Illegal SMB2 command %d", command);
+		cifs_vfs_err("Illegal SMB2 command %d", command);
 		return 1;
 	}
 
@@ -145,22 +145,22 @@ smb2_check_message(char *buf, unsigned int length)
 		if (command != SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0 ||
 		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2)) {
 			/* error packets have 9 byte structure size */
-			cERROR(1, "Illegal response size %u for command %d",
-				   le16_to_cpu(pdu->StructureSize2), command);
+			cifs_vfs_err("Illegal response size %u for command %d",
+				     le16_to_cpu(pdu->StructureSize2), command);
 			return 1;
 		} else if (command == SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0)
 			   && (le16_to_cpu(pdu->StructureSize2) != 44)
 			   && (le16_to_cpu(pdu->StructureSize2) != 36)) {
 			/* special case for SMB2.1 lease break message */
-			cERROR(1, "Illegal response size %d for oplock break",
-				   le16_to_cpu(pdu->StructureSize2));
+			cifs_vfs_err("Illegal response size %d for oplock break",
+				     le16_to_cpu(pdu->StructureSize2));
 			return 1;
 		}
 	}
 
 	if (4 + len != length) {
-		cERROR(1, "Total length %u RFC1002 length %u mismatch mid %llu",
-			  length, 4 + len, mid);
+		cifs_vfs_err("Total length %u RFC1002 length %u mismatch mid %llu",
+			     length, 4 + len, mid);
 		return 1;
 	}
 
@@ -267,7 +267,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	case SMB2_CHANGE_NOTIFY:
 	default:
 		/* BB FIXME for unimplemented cases above */
-		cERROR(1, "no length check for command");
+		cifs_vfs_err("no length check for command");
 		break;
 	}
 
@@ -276,20 +276,20 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	 * we have little choice but to ignore the data area in this case.
 	 */
 	if (*off > 4096) {
-		cERROR(1, "offset %d too large, data area ignored", *off);
+		cifs_vfs_err("offset %d too large, data area ignored", *off);
 		*len = 0;
 		*off = 0;
 	} else if (*off < 0) {
-		cERROR(1, "negative offset %d to data invalid ignore data area",
-			  *off);
+		cifs_vfs_err("negative offset %d to data invalid ignore data area",
+			     *off);
 		*off = 0;
 		*len = 0;
 	} else if (*len < 0) {
-		cERROR(1, "negative data length %d invalid, data area ignored",
-			  *len);
+		cifs_vfs_err("negative data length %d invalid, data area ignored",
+			     *len);
 		*len = 0;
 	} else if (*len > 128 * 1024) {
-		cERROR(1, "data area larger than 128K: %d", *len);
+		cifs_vfs_err("data area larger than 128K: %d", *len);
 		*len = 0;
 	}
 
@@ -335,8 +335,8 @@ smb2_calc_size(void *buf)
 		 * the size of the RFC1001 hdr.
 		 */
 		if (offset + 4 + 1 < len) {
-			cERROR(1, "data area offset %d overlaps SMB2 header %d",
-				  offset + 4 + 1, len);
+			cifs_vfs_err("data area offset %d overlaps SMB2 header %d",
+				     offset + 4 + 1, len);
 			data_length = 0;
 		} else {
 			len = 4 + offset + data_length;
@@ -427,7 +427,7 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 
 	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
 	if (!lw) {
-		cERROR(1, "Memory allocation failed during lease break check");
+		cifs_vfs_err("Memory allocation failed during lease break check");
 		return false;
 	}
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bceffe7..4f0539c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -38,7 +38,7 @@ change_conf(struct TCP_Server_Info *server)
 	case 1:
 		server->echoes = false;
 		server->oplocks = false;
-		cERROR(1, "disabling echoes and oplocks");
+		cifs_vfs_err("disabling echoes and oplocks");
 		break;
 	case 2:
 		server->echoes = true;
@@ -147,10 +147,10 @@ smb2_dump_detail(void *buf)
 #ifdef CONFIG_CIFS_DEBUG2
 	struct smb2_hdr *smb = (struct smb2_hdr *)buf;
 
-	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
-		  smb->Command, smb->Status, smb->Flags, smb->MessageId,
-		  smb->ProcessId);
-	cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
+	cifs_vfs_err("Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
+		     smb->Command, smb->Status, smb->Flags, smb->MessageId,
+		     smb->ProcessId);
+	cifs_vfs_err("smb buf %p len %u", smb, smb2_calc_size(smb));
 #endif
 }
 
@@ -436,7 +436,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		       &oplock, NULL);
 	kfree(utf16_path);
 	if (rc) {
-		cERROR(1, "open dir failed");
+		cifs_vfs_err("open dir failed");
 		return rc;
 	}
 
@@ -448,7 +448,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory(xid, tcon, persistent_fid, volatile_fid, 0,
 				  srch_inf);
 	if (rc) {
-		cERROR(1, "query directory failed");
+		cifs_vfs_err("query directory failed");
 		SMB2_close(xid, tcon, persistent_fid, volatile_fid);
 	}
 	return rc;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 41d9d07..a1e52a1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -400,8 +400,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	else if (rsp->DialectRevision == cpu_to_le16(SMB30_PROT_ID))
 		cFYI(1, "negotiated smb3.0 dialect");
 	else {
-		cERROR(1, "Illegal dialect returned by server %d",
-			   le16_to_cpu(rsp->DialectRevision));
+		cifs_vfs_err("Illegal dialect returned by server %d",
+			     le16_to_cpu(rsp->DialectRevision));
 		rc = -EIO;
 		goto neg_exit;
 	}
@@ -419,7 +419,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
 					       &rsp->hdr);
 	if (blob_length == 0) {
-		cERROR(1, "missing security blob on negprot");
+		cifs_vfs_err("missing security blob on negprot");
 		rc = -EIO;
 		goto neg_exit;
 	}
@@ -429,7 +429,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		cFYI(1, "Signing required");
 		if (!(server->sec_mode & (SMB2_NEGOTIATE_SIGNING_REQUIRED |
 		      SMB2_NEGOTIATE_SIGNING_ENABLED))) {
-			cERROR(1, "signing required but server lacks support");
+			cifs_vfs_err("signing required but server lacks support");
 			rc = -EOPNOTSUPP;
 			goto neg_exit;
 		}
@@ -446,8 +446,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	} else {
 		cFYI(1, "Signing disabled");
 		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
-			cERROR(1, "Server requires packet signing to be enabled"
-				  " in /proc/fs/cifs/SecurityFlags.");
+			cifs_vfs_err("Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags");
 			rc = -EOPNOTSUPP;
 			goto neg_exit;
 		}
@@ -558,7 +557,7 @@ ssetup_ntlmssp_authenticate:
 					sizeof(struct _NEGOTIATE_MESSAGE),
 					ntlmssp_blob); */
 			/* BB eventually need to add this */
-			cERROR(1, "spnego not supported for SMB2 yet");
+			cifs_vfs_err("spnego not supported for SMB2 yet");
 			rc = -EOPNOTSUPP;
 			kfree(ntlmssp_blob);
 			goto ssetup_exit;
@@ -572,7 +571,6 @@ ssetup_ntlmssp_authenticate:
 		ntlmssp_blob = kzalloc(sizeof(struct _NEGOTIATE_MESSAGE) + 500,
 				       GFP_KERNEL);
 		if (ntlmssp_blob == NULL) {
-			cERROR(1, "failed to malloc ntlmssp blob");
 			rc = -ENOMEM;
 			goto ssetup_exit;
 		}
@@ -587,7 +585,7 @@ ssetup_ntlmssp_authenticate:
 							&security_blob,
 							blob_length,
 							ntlmssp_blob); */
-			cERROR(1, "spnego not supported for SMB2 yet");
+			cifs_vfs_err("spnego not supported for SMB2 yet");
 			rc = -EOPNOTSUPP;
 			kfree(ntlmssp_blob);
 			goto ssetup_exit;
@@ -595,7 +593,7 @@ ssetup_ntlmssp_authenticate:
 			security_blob = ntlmssp_blob;
 		}
 	} else {
-		cERROR(1, "illegal ntlmssp phase");
+		cifs_vfs_err("illegal ntlmssp phase");
 		rc = -EIO;
 		goto ssetup_exit;
 	}
@@ -620,13 +618,13 @@ ssetup_ntlmssp_authenticate:
 	if (resp_buftype != CIFS_NO_BUFFER &&
 	    rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED) {
 		if (phase != NtLmNegotiate) {
-			cERROR(1, "Unexpected more processing error");
+			cifs_vfs_err("Unexpected more processing error");
 			goto ssetup_exit;
 		}
 		if (offsetof(struct smb2_sess_setup_rsp, Buffer) - 4 !=
 				le16_to_cpu(rsp->SecurityBufferOffset)) {
-			cERROR(1, "Invalid security buffer offset %d",
-				  le16_to_cpu(rsp->SecurityBufferOffset));
+			cifs_vfs_err("Invalid security buffer offset %d",
+				     le16_to_cpu(rsp->SecurityBufferOffset));
 			rc = -EIO;
 			goto ssetup_exit;
 		}
@@ -783,7 +781,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		tcon->print = true;
 		cFYI(1, "connection to printer");
 	} else {
-		cERROR(1, "unknown share type %d", rsp->ShareType);
+		cifs_vfs_err("unknown share type %d", rsp->ShareType);
 		rc = -EOPNOTSUPP;
 		goto tcon_error_exit;
 	}
@@ -797,7 +795,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
 	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
-		cERROR(1, "DFS capability contradicts DFS flag");
+		cifs_vfs_err("DFS capability contradicts DFS flag");
 
 tcon_exit:
 	free_rsp_buf(resp_buftype, rsp);
@@ -806,7 +804,7 @@ tcon_exit:
 
 tcon_error_exit:
 	if (rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
-		cERROR(1, "BAD_NETWORK_NAME: %s", tree);
+		cifs_vfs_err("BAD_NETWORK_NAME: %s", tree);
 		tcon->bad_network_name = true;
 	}
 	goto tcon_exit;
@@ -1097,20 +1095,20 @@ validate_buf(unsigned int offset, unsigned int buffer_length,
 
 
 	if (buffer_length < min_buf_size) {
-		cERROR(1, "buffer length %d smaller than minimum size %d",
-			   buffer_length, min_buf_size);
+		cifs_vfs_err("buffer length %d smaller than minimum size %d",
+			     buffer_length, min_buf_size);
 		return -EINVAL;
 	}
 
 	/* check if beyond RFC1001 maximum length */
 	if ((smb_len > 0x7FFFFF) || (buffer_length > 0x7FFFFF)) {
-		cERROR(1, "buffer length %d or smb length %d too large",
-			   buffer_length, smb_len);
+		cifs_vfs_err("buffer length %d or smb length %d too large",
+			     buffer_length, smb_len);
 		return -EINVAL;
 	}
 
 	if ((begin_of_buf > end_of_smb) || (end_of_buf > end_of_smb)) {
-		cERROR(1, "illegal server response, bad offset to data");
+		cifs_vfs_err("illegal server response, bad offset to data");
 		return -EINVAL;
 	}
 
@@ -1392,8 +1390,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 
 			rc = smb2_verify_signature(&rqst, server);
 			if (rc)
-				cERROR(1, "SMB signature verification returned "
-				       "error = %d", rc);
+				cifs_vfs_err("SMB signature verification returned error = %d",
+					     rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->bytes);
@@ -1481,7 +1479,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	if (rc) {
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
-		cERROR(1, "Send error in read = %d", rc);
+		cifs_vfs_err("Send error in read = %d", rc);
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
 		if ((*nbytes > CIFS_MAX_MSGSIZE) ||
@@ -1670,7 +1668,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	if (rc) {
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
-		cERROR(1, "Send error in write = %d", rc);
+		cifs_vfs_err("Send error in write = %d", rc);
 	} else
 		*nbytes = le32_to_cpu(rsp->DataLength);
 
@@ -1696,14 +1694,14 @@ num_entries(char *bufstart, char *end_of_buf, char **lastentry, size_t size)
 					((char *)entryptr + next_offset);
 
 		if ((char *)entryptr + size > end_of_buf) {
-			cERROR(1, "malformed search entry would overflow");
+			cifs_vfs_err("malformed search entry would overflow");
 			break;
 		}
 
 		len = le32_to_cpu(entryptr->FileNameLength);
 		if ((char *)entryptr + len + size > end_of_buf) {
-			cERROR(1, "directory entry name would overflow frame "
-				  "end of buf %p", end_of_buf);
+			cifs_vfs_err("directory entry name would overflow frame end of buf %p",
+				     end_of_buf);
 			break;
 		}
 
@@ -1759,8 +1757,8 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
 		break;
 	default:
-		cERROR(1, "info level %u isn't supported",
-		       srch_inf->info_level);
+		cifs_vfs_err("info level %u isn't supported",
+			     srch_inf->info_level);
 		rc = -EINVAL;
 		goto qdir_exit;
 	}
@@ -1832,7 +1830,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	else if (resp_buftype == CIFS_SMALL_BUFFER)
 		srch_inf->smallBuf = true;
 	else
-		cERROR(1, "illegal search buffer type");
+		cifs_vfs_err("illegal search buffer type");
 
 	if (rsp->hdr.Status == STATUS_NO_MORE_FILES)
 		srch_inf->endOfSearch = 1;
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 8dd73e6..1dcf6e7 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -55,13 +55,13 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
 		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response\n", __func__);
+		cifs_vfs_err("%s: Could not update with response", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5\n", __func__);
+		cifs_vfs_err("%s: Could not init md5", __func__);
 		return rc;
 	}
 
@@ -69,7 +69,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "null iovec entry");
+			cifs_vfs_err("null iovec entry");
 			return -EIO;
 		}
 		/*
@@ -90,8 +90,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 				iov[i].iov_base, iov[i].iov_len);
 		}
 		if (rc) {
-			cERROR(1, "%s: Could not update with payload\n",
-							__func__);
+			cifs_vfs_err("%s: Could not update with payload",
+				     __func__);
 			return rc;
 		}
 	}
@@ -109,7 +109,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
 				sigptr);
 	if (rc)
-		cERROR(1, "%s: Could not generate sha256 hash\n", __func__);
+		cifs_vfs_err("%s: Could not generate sha256 hash", __func__);
 
 	memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
 
@@ -205,7 +205,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 	struct mid_q_entry *temp;
 
 	if (server == NULL) {
-		cERROR(1, "Null TCP session in smb2_mid_entry_alloc");
+		cifs_vfs_err("Null TCP session in smb2_mid_entry_alloc");
 		return NULL;
 	}
 
@@ -281,8 +281,8 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 		rc = smb2_verify_signature(&rqst, server);
 		if (rc)
-			cERROR(1, "SMB signature verification returned error = "
-			       "%d", rc);
+			cifs_vfs_err("SMB signature verification returned error = %d",
+				     rc);
 	}
 
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index a0a58fb..e65b788 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -78,7 +78,7 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 	tfm_des = crypto_alloc_blkcipher("ecb(des)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm_des)) {
 		rc = PTR_ERR(tfm_des);
-		cERROR(1, "could not allocate des crypto API");
+		cifs_vfs_err("could not allocate des crypto API");
 		goto smbhash_err;
 	}
 
@@ -91,7 +91,7 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, 8);
 	if (rc)
-		cERROR(1, "could not encrypt crypt key rc: %d", rc);
+		cifs_vfs_err("could not encrypt crypt key rc: %d", rc);
 
 	crypto_free_blkcipher(tfm_des);
 smbhash_err:
@@ -139,14 +139,14 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 	md4 = crypto_alloc_shash("md4", 0, 0);
 	if (IS_ERR(md4)) {
 		rc = PTR_ERR(md4);
-		cERROR(1, "%s: Crypto md4 allocation error %d", __func__, rc);
+		cifs_vfs_err("%s: Crypto md4 allocation error %d",
+			     __func__, rc);
 		return rc;
 	}
 	size = sizeof(struct shash_desc) + crypto_shash_descsize(md4);
 	sdescmd4 = kmalloc(size, GFP_KERNEL);
 	if (!sdescmd4) {
 		rc = -ENOMEM;
-		cERROR(1, "%s: Memory allocation failure", __func__);
 		goto mdfour_err;
 	}
 	sdescmd4->shash.tfm = md4;
@@ -154,17 +154,17 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 
 	rc = crypto_shash_init(&sdescmd4->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md4 shash", __func__);
+		cifs_vfs_err("%s: Could not init md4 shash", __func__);
 		goto mdfour_err;
 	}
 	rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with link_str", __func__);
+		cifs_vfs_err("%s: Could not update with link_str", __func__);
 		goto mdfour_err;
 	}
 	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
 	if (rc)
-		cERROR(1, "%s: Could not genereate md4 hash", __func__);
+		cifs_vfs_err("%s: Could not generate md4 hash", __func__);
 
 mdfour_err:
 	crypto_free_shash(md4);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1a52868..d2a72e4 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -49,7 +49,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	struct mid_q_entry *temp;
 
 	if (server == NULL) {
-		cERROR(1, "Null TCP session in AllocMidQEntry");
+		cifs_vfs_err("Null TCP session in AllocMidQEntry");
 		return NULL;
 	}
 
@@ -188,8 +188,8 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
 			WARN_ON_ONCE(rc == -ENOSPC);
 			i++;
 			if (i >= 14 || (!server->noblocksnd && (i > 2))) {
-				cERROR(1, "sends on sock %p stuck for 15 "
-					  "seconds", ssocket);
+				cifs_vfs_err("sends on sock %p stuck for 15 seconds",
+					     ssocket);
 				rc = -EAGAIN;
 				break;
 			}
@@ -209,14 +209,14 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
 		}
 
 		if (rc > remaining) {
-			cERROR(1, "sent %d requested %d", rc, remaining);
+			cifs_vfs_err("sent %d requested %d", rc, remaining);
 			break;
 		}
 
 		if (rc == 0) {
 			/* should never happen, letting socket clear before
 			   retrying is our only obvious option here */
-			cERROR(1, "tcp sent no data");
+			cifs_vfs_err("tcp sent no data");
 			msleep(500);
 			continue;
 		}
@@ -335,7 +335,7 @@ uncork:
 	}
 
 	if (rc < 0 && rc != -EINTR)
-		cERROR(1, "Error %d sending data on socket to server", rc);
+		cifs_vfs_err("Error %d sending data on socket to server", rc);
 	else
 		rc = 0;
 
@@ -588,8 +588,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		break;
 	default:
 		list_del_init(&mid->qhead);
-		cERROR(1, "%s: invalid mid state mid=%llu state=%d", __func__,
-		       mid->mid, mid->mid_state);
+		cifs_vfs_err("%s: invalid mid state mid=%llu state=%d",
+			     __func__, mid->mid, mid->mid_state);
 		rc = -EIO;
 	}
 	spin_unlock(&GlobalMid_Lock);
@@ -626,8 +626,8 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		rc = cifs_verify_signature(&rqst, server,
 					   mid->sequence_number + 1);
 		if (rc)
-			cERROR(1, "SMB signature verification returned error = "
-			       "%d", rc);
+			cifs_vfs_err("SMB signature verification returned error = %d",
+				     rc);
 	}
 
 	/* BB special case reconnect tid and uid here? */
@@ -672,7 +672,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	if ((ses == NULL) || (ses->server == NULL)) {
 		cifs_small_buf_release(buf);
-		cERROR(1, "Null session");
+		cifs_vfs_err("Null session");
 		return -EIO;
 	}
 
@@ -788,11 +788,11 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	struct mid_q_entry *midQ;
 
 	if (ses == NULL) {
-		cERROR(1, "Null smb session");
+		cifs_vfs_err("Null smb session");
 		return -EIO;
 	}
 	if (ses->server == NULL) {
-		cERROR(1, "Null tcp session");
+		cifs_vfs_err("Null tcp session");
 		return -EIO;
 	}
 
@@ -805,8 +805,8 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
 			MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "Illegal length, greater than maximum frame, %d",
-			   be32_to_cpu(in_buf->smb_buf_length));
+		cifs_vfs_err("Illegal length, greater than maximum frame, %d",
+			     be32_to_cpu(in_buf->smb_buf_length));
 		return -EIO;
 	}
 
@@ -871,7 +871,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (!midQ->resp_buf || !out_buf ||
 	    midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
-		cERROR(1, "Bad MID state?");
+		cifs_vfs_err("Bad MID state?");
 		goto out;
 	}
 
@@ -921,13 +921,13 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses;
 
 	if (tcon == NULL || tcon->ses == NULL) {
-		cERROR(1, "Null smb session");
+		cifs_vfs_err("Null smb session");
 		return -EIO;
 	}
 	ses = tcon->ses;
 
 	if (ses->server == NULL) {
-		cERROR(1, "Null tcp session");
+		cifs_vfs_err("Null tcp session");
 		return -EIO;
 	}
 
@@ -940,8 +940,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
 			MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "Illegal length, greater than maximum frame, %d",
-			   be32_to_cpu(in_buf->smb_buf_length));
+		cifs_vfs_err("Illegal length, greater than maximum frame, %d",
+			     be32_to_cpu(in_buf->smb_buf_length));
 		return -EIO;
 	}
 
@@ -1038,7 +1038,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	/* rcvd frame is ok */
 	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
-		cERROR(1, "Bad MID state?");
+		cifs_vfs_err("Bad MID state?");
 		goto out;
 	}
 
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 5142f2c..01d7de0 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -319,8 +319,8 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 						full_path, &acllen);
 			if (IS_ERR(pacl)) {
 				rc = PTR_ERR(pacl);
-				cERROR(1, "%s: error %zd getting sec desc",
-						__func__, rc);
+				cifs_vfs_err("%s: error %zd getting sec desc",
+					     __func__, rc);
 			} else {
 				if (ea_value) {
 					if (acllen > buf_size)
