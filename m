From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] cifs: Rename cERROR and cFYI to cifs_dbg
Date: Thu, 14 Mar 2013 12:24:37 -0700
Message-ID: <1363289077.2146.19.camel@joe-AO722>
References: <1363128287.23052.21.camel@joe-AO722>
	 <1363174614.2031.9.camel@joe-AO722>
	 <20130313075155.7464a34a@tlielax.poochiereds.net>
	 <1363178421.2031.29.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1363178421.2031.29.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

It's not obvious from reading the macro names that these macros
are for debugging.  Convert the names to a single more typical
kernel style cifs_dbg macro.

	cERROR(1, ...)   -> cifs_dbg(VFS, ...)
	cFYI(1, ...)     -> cifs_dbg(FYI, ...)
	cFYI(DBG2, ...)  -> cifs_dbg(NOISY, ...)

Move the terminating format newline from the macro to the call site.

Add CONFIG_CIFS_DEBUG function cifs_vfs_err to emit the
"CIFS VFS: " prefix for VFS messages.

Size is reduced ~ 1% when CONFIG_CIFS_DEBUG is set (default y)

$ size fs/cifs/cifs.ko*
   text    data     bss     dec     hex filename
 265245	   2525	    132	 267902	  4167e	fs/cifs/cifs.ko.new
 268359    2525     132  271016   422a8 fs/cifs/cifs.ko.old

Other miscellaneous changes around these conversions:

o Miscellaneous typo fixes
o Add terminating \n's to almost all formats and remove them
  from the macros to be more kernel style like.  A few formats
  previously had defective \n's
o Remove unnecessary OOM messages as kmalloc() calls dump_stack
o Coalesce formats to make grep easier,
  added missing spaces when coalescing formats
o Use %s, __func__ instead of embedded function name
o Removed unnecessary "cifs: " prefixes
o Convert kzalloc with multiply to kcalloc
o Remove unused cifswarn macro

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/cifs/asn1.c          |  68 +++----
 fs/cifs/cache.c         |   6 +-
 fs/cifs/cifs_debug.c    |  67 ++++---
 fs/cifs/cifs_debug.h    |  70 +++----
 fs/cifs/cifs_dfs_ref.c  |  41 ++--
 fs/cifs/cifs_spnego.c   |   2 +-
 fs/cifs/cifs_unicode.c  |   4 +-
 fs/cifs/cifsacl.c       | 127 ++++++-------
 fs/cifs/cifsencrypt.c   | 102 +++++-----
 fs/cifs/cifsfs.c        |  36 ++--
 fs/cifs/cifsproto.h     |  10 +-
 fs/cifs/cifssmb.c       | 483 ++++++++++++++++++++++++------------------------
 fs/cifs/connect.c       | 310 +++++++++++++++----------------
 fs/cifs/dir.c           |  44 ++---
 fs/cifs/dns_resolve.c   |  17 +-
 fs/cifs/export.c        |   2 +-
 fs/cifs/file.c          | 166 ++++++++---------
 fs/cifs/fscache.c       |  58 +++---
 fs/cifs/inode.c         | 109 +++++------
 fs/cifs/ioctl.c         |   6 +-
 fs/cifs/link.c          |  24 +--
 fs/cifs/misc.c          |  78 ++++----
 fs/cifs/netmisc.c       |  16 +-
 fs/cifs/readdir.c       |  77 ++++----
 fs/cifs/sess.c          |  73 ++++----
 fs/cifs/smb1ops.c       |  47 ++---
 fs/cifs/smb2file.c      |   8 +-
 fs/cifs/smb2inode.c     |   2 +-
 fs/cifs/smb2maperror.c  |   2 +-
 fs/cifs/smb2misc.c      |  96 +++++-----
 fs/cifs/smb2ops.c       |  16 +-
 fs/cifs/smb2pdu.c       | 157 ++++++++--------
 fs/cifs/smb2transport.c |  26 +--
 fs/cifs/smbencrypt.c    |  17 +-
 fs/cifs/transport.c     |  61 +++---
 fs/cifs/xattr.c         |  54 +++---
 36 files changed, 1237 insertions(+), 1245 deletions(-)

diff --git a/fs/cifs/asn1.c b/fs/cifs/asn1.c
index cfd1ce3..ea5bb2e 100644
--- a/fs/cifs/asn1.c
+++ b/fs/cifs/asn1.c
@@ -506,11 +506,11 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 
 	/* GSSAPI header */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding negTokenInit header");
+		cifs_dbg(FYI, "Error decoding negTokenInit header\n");
 		return 0;
 	} else if ((cls != ASN1_APL) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cFYI(1, "cls = %d con = %d tag = %d", cls, con, tag);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d\n", cls, con, tag);
 		return 0;
 	}
 
@@ -531,52 +531,52 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 
 	/* SPNEGO OID not present or garbled -- bail out */
 	if (!rc) {
-		cFYI(1, "Error decoding negTokenInit header");
+		cifs_dbg(FYI, "Error decoding negTokenInit header\n");
 		return 0;
 	}
 
 	/* SPNEGO */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding negTokenInit");
+		cifs_dbg(FYI, "Error decoding negTokenInit\n");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
-		     cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 0\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* negTokenInit */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding negTokenInit");
+		cifs_dbg(FYI, "Error decoding negTokenInit\n");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
-		     cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 1\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* sequence */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding 2nd part of negTokenInit");
+		cifs_dbg(FYI, "Error decoding 2nd part of negTokenInit\n");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)
 		   || (tag != ASN1_EOC)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 0",
-		     cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 0\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* sequence of */
 	if (asn1_header_decode
 	    (&ctx, &sequence_end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding 2nd part of negTokenInit");
+		cifs_dbg(FYI, "Error decoding 2nd part of negTokenInit\n");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d) exit 1",
-		     cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d) exit 1\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
 
@@ -584,15 +584,15 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 	while (!asn1_eoc_decode(&ctx, sequence_end)) {
 		rc = asn1_header_decode(&ctx, &end, &cls, &con, &tag);
 		if (!rc) {
-			cFYI(1, "Error decoding negTokenInit hdr exit2");
+			cifs_dbg(FYI, "Error decoding negTokenInit hdr exit2\n");
 			return 0;
 		}
 		if ((tag == ASN1_OJI) && (con == ASN1_PRI)) {
 			if (asn1_oid_decode(&ctx, end, &oid, &oidlen)) {
 
-				cFYI(1, "OID len = %d oid = 0x%lx 0x%lx "
-					"0x%lx 0x%lx", oidlen, *oid,
-					*(oid + 1), *(oid + 2), *(oid + 3));
+				cifs_dbg(FYI, "OID len = %d oid = 0x%lx 0x%lx 0x%lx 0x%lx\n",
+					 oidlen, *oid, *(oid + 1), *(oid + 2),
+					 *(oid + 3));
 
 				if (compare_oid(oid, oidlen, MSKRB5_OID,
 						MSKRB5_OID_LEN))
@@ -610,7 +610,7 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 				kfree(oid);
 			}
 		} else {
-			cFYI(1, "Should be an oid what is going on?");
+			cifs_dbg(FYI, "Should be an oid what is going on?\n");
 		}
 	}
 
@@ -620,47 +620,47 @@ decode_negTokenInit(unsigned char *security_blob, int length,
 		   no mechListMic (e.g. NTLMSSP instead of KRB5) */
 		if (ctx.error == ASN1_ERR_DEC_EMPTY)
 			goto decode_negtoken_exit;
-		cFYI(1, "Error decoding last part negTokenInit exit3");
+		cifs_dbg(FYI, "Error decoding last part negTokenInit exit3\n");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
 		/* tag = 3 indicating mechListMIC */
-		cFYI(1, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
+		cifs_dbg(FYI, "Exit 4 cls = %d con = %d tag = %d end = %p (%d)\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* sequence */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit5");
+		cifs_dbg(FYI, "Error decoding last part negTokenInit exit5\n");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_CON)
 		   || (tag != ASN1_SEQ)) {
-		cFYI(1, "cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
+		cifs_dbg(FYI, "cls = %d con = %d tag = %d end = %p (%d)\n",
+			 cls, con, tag, end, *end);
 	}
 
 	/* sequence of */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit 7");
+		cifs_dbg(FYI, "Error decoding last part negTokenInit exit7\n");
 		return 0;
 	} else if ((cls != ASN1_CTX) || (con != ASN1_CON)) {
-		cFYI(1, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
+		cifs_dbg(FYI, "Exit 8 cls = %d con = %d tag = %d end = %p (%d)\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
 
 	/* general string */
 	if (asn1_header_decode(&ctx, &end, &cls, &con, &tag) == 0) {
-		cFYI(1, "Error decoding last part negTokenInit exit9");
+		cifs_dbg(FYI, "Error decoding last part negTokenInit exit9\n");
 		return 0;
 	} else if ((cls != ASN1_UNI) || (con != ASN1_PRI)
 		   || (tag != ASN1_GENSTR)) {
-		cFYI(1, "Exit10 cls = %d con = %d tag = %d end = %p (%d)",
-			cls, con, tag, end, *end);
+		cifs_dbg(FYI, "Exit10 cls = %d con = %d tag = %d end = %p (%d)\n",
+			 cls, con, tag, end, *end);
 		return 0;
 	}
-	cFYI(1, "Need to call asn1_octets_decode() function for %s",
-		ctx.pointer);	/* is this UTF-8 or ASCII? */
+	cifs_dbg(FYI, "Need to call asn1_octets_decode() function for %s\n",
+		 ctx.pointer);	/* is this UTF-8 or ASCII? */
 decode_negtoken_exit:
 	return 1;
 }
diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
index 282d6de..6c665bf 100644
--- a/fs/cifs/cache.c
+++ b/fs/cifs/cache.c
@@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
 		break;
 
 	default:
-		cERROR(1, "Unknown network family '%d'", sa->sa_family);
+		cifs_dbg(VFS, "Unknown network family '%d'\n", sa->sa_family);
 		key_len = 0;
 		break;
 	}
@@ -152,7 +152,7 @@ static uint16_t cifs_super_get_key(const void *cookie_netfs_data, void *buffer,
 
 	sharename = extract_sharename(tcon->treeName);
 	if (IS_ERR(sharename)) {
-		cFYI(1, "%s: couldn't extract sharename", __func__);
+		cifs_dbg(FYI, "%s: couldn't extract sharename\n", __func__);
 		sharename = NULL;
 		return 0;
 	}
@@ -302,7 +302,7 @@ static void cifs_fscache_inode_now_uncached(void *cookie_netfs_data)
 	pagevec_init(&pvec, 0);
 	first = 0;
 
-	cFYI(1, "%s: cifs inode 0x%p now uncached", __func__, cifsi);
+	cifs_dbg(FYI, "%s: cifs inode 0x%p now uncached\n", __func__, cifsi);
 
 	for (;;) {
 		nr_pages = pagevec_lookup(&pvec,
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d9ea6ed..d597483 100644
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
+	printk(KERN_ERR "CIFS VFS: %pV", &vaf);
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
+	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d\n",
+		 smb->Command, smb->Status.CifsError,
+		 smb->Flags, smb->Flags2, smb->Mid, smb->Pid);
+	cifs_dbg(VFS, "smb buf %p len %u\n", smb, smbCalcSize(smb));
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
@@ -78,25 +95,25 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	if (server == NULL)
 		return;
 
-	cERROR(1, "Dump pending requests:");
+	cifs_dbg(VFS, "Dump pending requests:\n");
 	spin_lock(&GlobalMid_Lock);
 	list_for_each(tmp, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		cERROR(1, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu",
-			mid_entry->mid_state,
-			le16_to_cpu(mid_entry->command),
-			mid_entry->pid,
-			mid_entry->callback_data,
-			mid_entry->mid);
+		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
+			 mid_entry->mid_state,
+			 le16_to_cpu(mid_entry->command),
+			 mid_entry->pid,
+			 mid_entry->callback_data,
+			 mid_entry->mid);
 #ifdef CONFIG_CIFS_STATS2
-		cERROR(1, "IsLarge: %d buf: %p time rcv: %ld now: %ld",
-			mid_entry->large_buf,
-			mid_entry->resp_buf,
-			mid_entry->when_received,
-			jiffies);
+		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
+			 mid_entry->large_buf,
+			 mid_entry->resp_buf,
+			 mid_entry->when_received,
+			 jiffies);
 #endif /* STATS2 */
-		cERROR(1, "IsMult: %d IsEnd: %d", mid_entry->multiRsp,
-			  mid_entry->multiEnd);
+		cifs_dbg(VFS, "IsMult: %d IsEnd: %d\n",
+			 mid_entry->multiRsp, mid_entry->multiEnd);
 		if (mid_entry->resp_buf) {
 			cifs_dump_detail(mid_entry->resp_buf);
 			cifs_dump_mem("existing buf: ",
@@ -603,7 +620,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 			global_secflags = CIFSSEC_MAX;
 			return count;
 		} else if (!isdigit(c)) {
-			cERROR(1, "invalid flag %c", c);
+			cifs_dbg(VFS, "invalid flag %c\n", c);
 			return -EINVAL;
 		}
 	}
@@ -611,16 +628,16 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 
 	flags = simple_strtoul(flags_string, NULL, 0);
 
-	cFYI(1, "sec flags 0x%x", flags);
+	cifs_dbg(FYI, "sec flags 0x%x\n", flags);
 
 	if (flags <= 0)  {
-		cERROR(1, "invalid security flags %s", flags_string);
+		cifs_dbg(VFS, "invalid security flags %s\n", flags_string);
 		return -EINVAL;
 	}
 
 	if (flags & ~CIFSSEC_MASK) {
-		cERROR(1, "attempt to set unsupported security flags 0x%x",
-			flags & ~CIFSSEC_MASK);
+		cifs_dbg(VFS, "attempt to set unsupported security flags 0x%x\n",
+			 flags & ~CIFSSEC_MASK);
 		return -EINVAL;
 	}
 	/* flags look ok - update the global security flags for cifs module */
@@ -628,9 +645,9 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	if (global_secflags & CIFSSEC_MUST_SIGN) {
 		/* requiring signing implies signing is allowed */
 		global_secflags |= CIFSSEC_MAY_SIGN;
-		cFYI(1, "packet signing now required");
+		cifs_dbg(FYI, "packet signing now required\n");
 	} else if ((global_secflags & CIFSSEC_MAY_SIGN) == 0) {
-		cFYI(1, "packet signing disabled");
+		cifs_dbg(FYI, "packet signing disabled\n");
 	}
 	/* BB should we turn on MAY flags for other MUST options? */
 	return count;
diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 69ae3d3..c99b40f 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -25,18 +25,20 @@
 void cifs_dump_mem(char *label, void *data, int length);
 void cifs_dump_detail(void *);
 void cifs_dump_mids(struct TCP_Server_Info *);
-#ifdef CONFIG_CIFS_DEBUG2
-#define DBG2 2
-#else
-#define DBG2 0
-#endif
 extern int traceSMB;		/* flag which enables the function below */
 void dump_smb(void *, int);
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
 
+#define VFS 1
+#define FYI 2
 extern int cifsFYI;
+#ifdef CONFIG_CIFS_DEBUG2
+#define NOISY 4
+#else
+#define NOISY 0
+#endif
 
 /*
  *	debug ON
@@ -44,31 +46,21 @@ extern int cifsFYI;
  */
 #ifdef CONFIG_CIFS_DEBUG
 
-/* information message: e.g., configuration, major event */
-#define cifsfyi(fmt, ...)						\
-do {									\
-	if (cifsFYI & CIFS_INFO)					\
-		printk(KERN_DEBUG "%s: " fmt "\n",			\
-		       __FILE__, ##__VA_ARGS__);			\
-} while (0)
-
-#define cFYI(set, fmt, ...)						\
-do {									\
-	if (set)							\
-		cifsfyi(fmt, ##__VA_ARGS__);				\
-} while (0)
+__printf(1, 2) void cifs_vfs_err(const char *fmt, ...);
 
-#define cifswarn(fmt, ...)						\
-	printk(KERN_WARNING fmt "\n", ##__VA_ARGS__)
-
-/* error event message: e.g., i/o error */
-#define cifserror(fmt, ...)						\
-	printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);		\
-
-#define cERROR(set, fmt, ...)						\
+/* information message: e.g., configuration, major event */
+#define cifs_dbg(type, fmt, ...)					\
 do {									\
-	if (set)							\
-		cifserror(fmt, ##__VA_ARGS__);				\
+	if (type == FYI) {						\
+		if (cifsFYI & CIFS_INFO) {				\
+			printk(KERN_DEBUG "%s: " fmt,			\
+			       __FILE__, ##__VA_ARGS__);		\
+		}							\
+	} else if (type == VFS) {					\
+		cifs_vfs_err(fmt, ##__VA_ARGS__);			\
+	} else if (type == NOISY && type != 0) {			\
+		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
+	}								\
 } while (0)
 
 /*
@@ -76,27 +68,11 @@ do {									\
  *	---------
  */
 #else		/* _CIFS_DEBUG */
-#define cifsfyi(fmt, ...)						\
+#define cifs_dbg(type, fmt, ...)					\
 do {									\
 	if (0)								\
-		printk(KERN_DEBUG "%s: " fmt "\n",			\
-		       __FILE__, ##__VA_ARGS__);			\
+		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
 } while (0)
-#define cFYI(set, fmt, ...)						\
-do {									\
-	if (0 && set)							\
-		cifsfyi(fmt, ##__VA_ARGS__);				\
-} while (0)
-#define cifserror(fmt, ...)						\
-do {									\
-	if (0)								\
-		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);	\
-} while (0)
-#define cERROR(set, fmt, ...)						\
-do {									\
-	if (0 && set)							\
-		cifserror(fmt, ##__VA_ARGS__);				\
-} while (0)
-#endif		/* _CIFS_DEBUG */
+#endif
 
 #endif				/* _H_CIFS_DEBUG */
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 210fce2..99d8e98 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -84,8 +84,8 @@ static char *cifs_get_share_name(const char *node_name)
 	/* find server name end */
 	pSep = memchr(UNC+2, '\\', len-2);
 	if (!pSep) {
-		cERROR(1, "%s: no server name end in node name: %s",
-			__func__, node_name);
+		cifs_dbg(VFS, "%s: no server name end in node name: %s\n",
+			 __func__, node_name);
 		kfree(UNC);
 		return ERR_PTR(-EINVAL);
 	}
@@ -141,8 +141,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc < 0) {
-		cFYI(1, "%s: Failed to resolve server part of %s to IP: %d",
-			__func__, *devname, rc);
+		cifs_dbg(FYI, "%s: Failed to resolve server part of %s to IP: %d\n",
+			 __func__, *devname, rc);
 		goto compose_mount_options_err;
 	}
 
@@ -216,8 +216,8 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		strcat(mountdata, fullpath + ref->path_consumed);
 	}
 
-	/*cFYI(1, "%s: parent mountdata: %s", __func__,sb_mountdata);*/
-	/*cFYI(1, "%s: submount mountdata: %s", __func__, mountdata );*/
+	/*cifs_dbg(FYI, "%s: parent mountdata: %s\n", __func__, sb_mountdata);*/
+	/*cifs_dbg(FYI, "%s: submount mountdata: %s\n", __func__, mountdata );*/
 
 compose_mount_options_out:
 	kfree(srvIP);
@@ -260,11 +260,12 @@ static struct vfsmount *cifs_dfs_do_refmount(struct cifs_sb_info *cifs_sb,
 
 static void dump_referral(const struct dfs_info3_param *ref)
 {
-	cFYI(1, "DFS: ref path: %s", ref->path_name);
-	cFYI(1, "DFS: node path: %s", ref->node_name);
-	cFYI(1, "DFS: fl: %hd, srv_type: %hd", ref->flags, ref->server_type);
-	cFYI(1, "DFS: ref_flags: %hd, path_consumed: %hd", ref->ref_flag,
-				ref->path_consumed);
+	cifs_dbg(FYI, "DFS: ref path: %s\n", ref->path_name);
+	cifs_dbg(FYI, "DFS: node path: %s\n", ref->node_name);
+	cifs_dbg(FYI, "DFS: fl: %hd, srv_type: %hd\n",
+		 ref->flags, ref->server_type);
+	cifs_dbg(FYI, "DFS: ref_flags: %hd, path_consumed: %hd\n",
+		 ref->ref_flag, ref->path_consumed);
 }
 
 /*
@@ -283,7 +284,7 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 	struct vfsmount *mnt;
 	struct tcon_link *tlink;
 
-	cFYI(1, "in %s", __func__);
+	cifs_dbg(FYI, "in %s\n", __func__);
 	BUG_ON(IS_ROOT(mntpt));
 
 	/*
@@ -320,15 +321,15 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 		/* connect to a node */
 		len = strlen(referrals[i].node_name);
 		if (len < 2) {
-			cERROR(1, "%s: Net Address path too short: %s",
-					__func__, referrals[i].node_name);
+			cifs_dbg(VFS, "%s: Net Address path too short: %s\n",
+				 __func__, referrals[i].node_name);
 			mnt = ERR_PTR(-EINVAL);
 			break;
 		}
 		mnt = cifs_dfs_do_refmount(cifs_sb,
 				full_path, referrals + i);
-		cFYI(1, "%s: cifs_dfs_do_refmount:%s , mnt:%p", __func__,
-					referrals[i].node_name, mnt);
+		cifs_dbg(FYI, "%s: cifs_dfs_do_refmount:%s , mnt:%p\n",
+			 __func__, referrals[i].node_name, mnt);
 		if (!IS_ERR(mnt))
 			goto success;
 	}
@@ -343,7 +344,7 @@ success:
 free_full_path:
 	kfree(full_path);
 cdda_exit:
-	cFYI(1, "leaving %s" , __func__);
+	cifs_dbg(FYI, "leaving %s\n" , __func__);
 	return mnt;
 }
 
@@ -354,11 +355,11 @@ struct vfsmount *cifs_dfs_d_automount(struct path *path)
 {
 	struct vfsmount *newmnt;
 
-	cFYI(1, "in %s", __func__);
+	cifs_dbg(FYI, "in %s\n", __func__);
 
 	newmnt = cifs_dfs_do_automount(path->dentry);
 	if (IS_ERR(newmnt)) {
-		cFYI(1, "leaving %s [automount failed]" , __func__);
+		cifs_dbg(FYI, "leaving %s [automount failed]\n" , __func__);
 		return newmnt;
 	}
 
@@ -366,7 +367,7 @@ struct vfsmount *cifs_dfs_d_automount(struct path *path)
 	mnt_set_expiry(newmnt, &cifs_dfs_automount_list);
 	schedule_delayed_work(&cifs_dfs_automount_task,
 			      cifs_dfs_mountpoint_expiry_timeout);
-	cFYI(1, "leaving %s [ok]" , __func__);
+	cifs_dbg(FYI, "leaving %s [ok]\n" , __func__);
 	return newmnt;
 }
 
diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 10e7747..c557bf1 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -164,7 +164,7 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
 	dp = description + strlen(description);
 	sprintf(dp, ";pid=0x%x", current->pid);
 
-	cFYI(1, "key description = %s", description);
+	cifs_dbg(FYI, "key description = %s\n", description);
 	spnego_key = request_key(&cifs_spnego_key_type, description, "");
 
 #ifdef CONFIG_CIFS_DEBUG2
diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 71d5d0a..0227b45 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -227,8 +227,8 @@ cifs_strtoUTF16(__le16 *to, const char *from, int len,
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
 		charlen = codepage->char2uni(from, len, &wchar_to);
 		if (charlen < 1) {
-			cERROR(1, "strtoUTF16: char2uni of 0x%x returned %d",
-				*from, charlen);
+			cifs_dbg(VFS, "strtoUTF16: char2uni of 0x%x returned %d\n",
+				 *from, charlen);
 			/* A question mark */
 			wchar_to = 0x003f;
 			charlen = 1;
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f1e3f25..8e9c0b7 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -219,13 +219,13 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 	sidkey = request_key(&cifs_idmap_key_type, desc, "");
 	if (IS_ERR(sidkey)) {
 		rc = -EINVAL;
-		cFYI(1, "%s: Can't map %cid %u to a SID", __func__,
-			sidtype == SIDOWNER ? 'u' : 'g', cid);
+		cifs_dbg(FYI, "%s: Can't map %cid %u to a SID\n",
+			 __func__, sidtype == SIDOWNER ? 'u' : 'g', cid);
 		goto out_revert_creds;
 	} else if (sidkey->datalen < CIFS_SID_BASE_SIZE) {
 		rc = -EIO;
-		cFYI(1, "%s: Downcall contained malformed key "
-			"(datalen=%hu)", __func__, sidkey->datalen);
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
+			 __func__, sidkey->datalen);
 		goto invalidate_key;
 	}
 
@@ -241,8 +241,8 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 	ksid_size = CIFS_SID_BASE_SIZE + (ksid->num_subauth * sizeof(__le32));
 	if (ksid_size > sidkey->datalen) {
 		rc = -EIO;
-		cFYI(1, "%s: Downcall contained malformed key (datalen=%hu, "
-			"ksid_size=%u)", __func__, sidkey->datalen, ksid_size);
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu, ksid_size=%u)\n",
+			 __func__, sidkey->datalen, ksid_size);
 		goto invalidate_key;
 	}
 
@@ -274,8 +274,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	 * Just return an error.
 	 */
 	if (unlikely(psid->num_subauth > SID_MAX_SUB_AUTHORITIES)) {
-		cFYI(1, "%s: %u subauthorities is too many!", __func__,
-			psid->num_subauth);
+		cifs_dbg(FYI, "%s: %u subauthorities is too many!\n",
+			 __func__, psid->num_subauth);
 		return -EIO;
 	}
 
@@ -287,8 +287,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
 	if (IS_ERR(sidkey)) {
 		rc = -EINVAL;
-		cFYI(1, "%s: Can't map SID %s to a %cid", __func__, sidstr,
-			sidtype == SIDOWNER ? 'u' : 'g');
+		cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
+			 __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
 		goto out_revert_creds;
 	}
 
@@ -300,8 +300,8 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
 	if (sidkey->datalen != sizeof(uid_t)) {
 		rc = -EIO;
-		cFYI(1, "%s: Downcall contained malformed key "
-			"(datalen=%hu)", __func__, sidkey->datalen);
+		cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
+			 __func__, sidkey->datalen);
 		key_invalidate(sidkey);
 		goto out_key_put;
 	}
@@ -346,7 +346,8 @@ init_cifs_idmap(void)
 	struct key *keyring;
 	int ret;
 
-	cFYI(1, "Registering the %s key type", cifs_idmap_key_type.name);
+	cifs_dbg(FYI, "Registering the %s key type\n",
+		 cifs_idmap_key_type.name);
 
 	/* create an override credential set with a special thread keyring in
 	 * which requests are cached
@@ -379,7 +380,7 @@ init_cifs_idmap(void)
 	cred->jit_keyring = KEY_REQKEY_DEFL_THREAD_KEYRING;
 	root_cred = cred;
 
-	cFYI(1, "cifs idmap keyring: %d", key_serial(keyring));
+	cifs_dbg(FYI, "cifs idmap keyring: %d\n", key_serial(keyring));
 	return 0;
 
 failed_put_key:
@@ -395,7 +396,7 @@ exit_cifs_idmap(void)
 	key_revoke(root_cred->thread_keyring);
 	unregister_key_type(&cifs_idmap_key_type);
 	put_cred(root_cred);
-	cFYI(1, "Unregistered %s key type", cifs_idmap_key_type.name);
+	cifs_dbg(FYI, "Unregistered %s key type\n", cifs_idmap_key_type.name);
 }
 
 /* copy ntsd, owner sid, and group sid from a security descriptor to another */
@@ -462,14 +463,14 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			*pbits_to_set &= ~S_IXUGO;
 		return;
 	} else if (type != ACCESS_ALLOWED) {
-		cERROR(1, "unknown access control type %d", type);
+		cifs_dbg(VFS, "unknown access control type %d\n", type);
 		return;
 	}
 	/* else ACCESS_ALLOWED type */
 
 	if (flags & GENERIC_ALL) {
 		*pmode |= (S_IRWXUGO & (*pbits_to_set));
-		cFYI(DBG2, "all perms");
+		cifs_dbg(NOISY, "all perms\n");
 		return;
 	}
 	if ((flags & GENERIC_WRITE) ||
@@ -482,7 +483,7 @@ static void access_flags_to_mode(__le32 ace_flags, int type, umode_t *pmode,
 			((flags & FILE_EXEC_RIGHTS) == FILE_EXEC_RIGHTS))
 		*pmode |= (S_IXUGO & (*pbits_to_set));
 
-	cFYI(DBG2, "access flags 0x%x mode now 0x%x", flags, *pmode);
+	cifs_dbg(NOISY, "access flags 0x%x mode now 0x%x\n", flags, *pmode);
 	return;
 }
 
@@ -511,7 +512,8 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	if (mode & S_IXUGO)
 		*pace_flags |= SET_FILE_EXEC_RIGHTS;
 
-	cFYI(DBG2, "mode: 0x%x, access flags now 0x%x", mode, *pace_flags);
+	cifs_dbg(NOISY, "mode: 0x%x, access flags now 0x%x\n",
+		 mode, *pace_flags);
 	return;
 }
 
@@ -551,24 +553,24 @@ static void dump_ace(struct cifs_ace *pace, char *end_of_acl)
 	/* validate that we do not go past end of acl */
 
 	if (le16_to_cpu(pace->size) < 16) {
-		cERROR(1, "ACE too small %d", le16_to_cpu(pace->size));
+		cifs_dbg(VFS, "ACE too small %d\n", le16_to_cpu(pace->size));
 		return;
 	}
 
 	if (end_of_acl < (char *)pace + le16_to_cpu(pace->size)) {
-		cERROR(1, "ACL too small to parse ACE");
+		cifs_dbg(VFS, "ACL too small to parse ACE\n");
 		return;
 	}
 
 	num_subauth = pace->sid.num_subauth;
 	if (num_subauth) {
 		int i;
-		cFYI(1, "ACE revision %d num_auth %d type %d flags %d size %d",
-			pace->sid.revision, pace->sid.num_subauth, pace->type,
-			pace->flags, le16_to_cpu(pace->size));
+		cifs_dbg(FYI, "ACE revision %d num_auth %d type %d flags %d size %d\n",
+			 pace->sid.revision, pace->sid.num_subauth, pace->type,
+			 pace->flags, le16_to_cpu(pace->size));
 		for (i = 0; i < num_subauth; ++i) {
-			cFYI(1, "ACE sub_auth[%d]: 0x%x", i,
-				le32_to_cpu(pace->sid.sub_auth[i]));
+			cifs_dbg(FYI, "ACE sub_auth[%d]: 0x%x\n",
+				 i, le32_to_cpu(pace->sid.sub_auth[i]));
 		}
 
 		/* BB add length check to make sure that we do not have huge
@@ -601,13 +603,13 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 
 	/* validate that we do not go past end of acl */
 	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
-		cERROR(1, "ACL too small to parse DACL");
+		cifs_dbg(VFS, "ACL too small to parse DACL\n");
 		return;
 	}
 
-	cFYI(DBG2, "DACL revision %d size %d num aces %d",
-		le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
-		le32_to_cpu(pdacl->num_aces));
+	cifs_dbg(NOISY, "DACL revision %d size %d num aces %d\n",
+		 le16_to_cpu(pdacl->revision), le16_to_cpu(pdacl->size),
+		 le32_to_cpu(pdacl->num_aces));
 
 	/* reset rwx permissions for user/group/other.
 	   Also, if num_aces is 0 i.e. DACL has no ACEs,
@@ -627,10 +629,8 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 			return;
 		ppace = kmalloc(num_aces * sizeof(struct cifs_ace *),
 				GFP_KERNEL);
-		if (!ppace) {
-			cERROR(1, "DACL memory allocation error");
+		if (!ppace)
 			return;
-		}
 
 		for (i = 0; i < num_aces; ++i) {
 			ppace[i] = (struct cifs_ace *) (acl_base + acl_size);
@@ -703,25 +703,25 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 	/* validate that we do not go past end of ACL - sid must be at least 8
 	   bytes long (assuming no sub-auths - e.g. the null SID */
 	if (end_of_acl < (char *)psid + 8) {
-		cERROR(1, "ACL too small to parse SID %p", psid);
+		cifs_dbg(VFS, "ACL too small to parse SID %p\n", psid);
 		return -EINVAL;
 	}
 
 #ifdef CONFIG_CIFS_DEBUG2
 	if (psid->num_subauth) {
 		int i;
-		cFYI(1, "SID revision %d num_auth %d",
-			psid->revision, psid->num_subauth);
+		cifs_dbg(FYI, "SID revision %d num_auth %d\n",
+			 psid->revision, psid->num_subauth);
 
 		for (i = 0; i < psid->num_subauth; i++) {
-			cFYI(1, "SID sub_auth[%d]: 0x%x ", i,
-				le32_to_cpu(psid->sub_auth[i]));
+			cifs_dbg(FYI, "SID sub_auth[%d]: 0x%x\n",
+				 i, le32_to_cpu(psid->sub_auth[i]));
 		}
 
 		/* BB add length check to make sure that we do not have huge
 			num auths and therefore go off the end */
-		cFYI(1, "RID 0x%x",
-			le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
+		cifs_dbg(FYI, "RID 0x%x\n",
+			 le32_to_cpu(psid->sub_auth[psid->num_subauth-1]));
 	}
 #endif
 
@@ -748,31 +748,33 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 				le32_to_cpu(pntsd->gsidoffset));
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	dacl_ptr = (struct cifs_acl *)((char *)pntsd + dacloffset);
-	cFYI(DBG2, "revision %d type 0x%x ooffset 0x%x goffset 0x%x "
-		 "sacloffset 0x%x dacloffset 0x%x",
+	cifs_dbg(NOISY, "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
 		 pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
 		 le32_to_cpu(pntsd->gsidoffset),
 		 le32_to_cpu(pntsd->sacloffset), dacloffset);
 /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc) {
-		cFYI(1, "%s: Error %d parsing Owner SID", __func__, rc);
+		cifs_dbg(FYI, "%s: Error %d parsing Owner SID\n", __func__, rc);
 		return rc;
 	}
 	rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
 	if (rc) {
-		cFYI(1, "%s: Error %d mapping Owner SID to uid", __func__, rc);
+		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to uid\n",
+			 __func__, rc);
 		return rc;
 	}
 
 	rc = parse_sid(group_sid_ptr, end_of_acl);
 	if (rc) {
-		cFYI(1, "%s: Error %d mapping Owner SID to gid", __func__, rc);
+		cifs_dbg(FYI, "%s: Error %d mapping Owner SID to gid\n",
+			 __func__, rc);
 		return rc;
 	}
 	rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
 	if (rc) {
-		cFYI(1, "%s: Error %d mapping Group SID to gid", __func__, rc);
+		cifs_dbg(FYI, "%s: Error %d mapping Group SID to gid\n",
+			 __func__, rc);
 		return rc;
 	}
 
@@ -780,7 +782,7 @@ static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
 			   group_sid_ptr, fattr);
 	else
-		cFYI(1, "no ACL"); /* BB grant all or default perms? */
+		cifs_dbg(FYI, "no ACL\n"); /* BB grant all or default perms? */
 
 	return rc;
 }
@@ -830,8 +832,8 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 			id = from_kuid(&init_user_ns, uid);
 			rc = id_to_sid(id, SIDOWNER, nowner_sid_ptr);
 			if (rc) {
-				cFYI(1, "%s: Mapping error %d for owner id %d",
-						__func__, rc, id);
+				cifs_dbg(FYI, "%s: Mapping error %d for owner id %d\n",
+					 __func__, rc, id);
 				kfree(nowner_sid_ptr);
 				return rc;
 			}
@@ -850,8 +852,8 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 			id = from_kgid(&init_user_ns, gid);
 			rc = id_to_sid(id, SIDGROUP, ngroup_sid_ptr);
 			if (rc) {
-				cFYI(1, "%s: Mapping error %d for group id %d",
-						__func__, rc, id);
+				cifs_dbg(FYI, "%s: Mapping error %d for group id %d\n",
+					 __func__, rc, id);
 				kfree(ngroup_sid_ptr);
 				return rc;
 			}
@@ -881,7 +883,7 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb,
 
 	cifs_put_tlink(tlink);
 
-	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
+	cifs_dbg(FYI, "%s: rc = %d ACL len %d\n", __func__, rc, *pacllen);
 	if (rc)
 		return ERR_PTR(rc);
 	return pntsd;
@@ -918,7 +920,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 	cifs_put_tlink(tlink);
 	free_xid(xid);
 
-	cFYI(1, "%s: rc = %d ACL len %d", __func__, rc, *pacllen);
+	cifs_dbg(FYI, "%s: rc = %d ACL len %d\n", __func__, rc, *pacllen);
 	if (rc)
 		return ERR_PTR(rc);
 	return pntsd;
@@ -972,12 +974,12 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 			create_options, &fid, &oplock, NULL, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc) {
-		cERROR(1, "Unable to open file to set ACL");
+		cifs_dbg(VFS, "Unable to open file to set ACL\n");
 		goto out;
 	}
 
 	rc = CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, acllen, aclflag);
-	cFYI(DBG2, "SetCIFSACL rc = %d", rc);
+	cifs_dbg(NOISY, "SetCIFSACL rc = %d\n", rc);
 
 	CIFSSMBClose(xid, tcon, fid);
 out:
@@ -995,7 +997,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	u32 acllen = 0;
 	int rc = 0;
 
-	cFYI(DBG2, "converting ACL to mode for %s", path);
+	cifs_dbg(NOISY, "converting ACL to mode for %s\n", path);
 
 	if (pfid)
 		pntsd = get_cifs_acl_by_fid(cifs_sb, *pfid, &acllen);
@@ -1005,12 +1007,12 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
 	/* if we can retrieve the ACL, now parse Access Control Entries, ACEs */
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
-		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
+		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
 	} else {
 		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr);
 		kfree(pntsd);
 		if (rc)
-			cERROR(1, "parse sec desc failed rc = %d", rc);
+			cifs_dbg(VFS, "parse sec desc failed rc = %d\n", rc);
 	}
 
 	return rc;
@@ -1027,13 +1029,13 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	struct cifs_ntsd *pntsd = NULL; /* acl obtained from server */
 	struct cifs_ntsd *pnntsd = NULL; /* modified acl to be sent to server */
 
-	cFYI(DBG2, "set ACL from mode for %s", path);
+	cifs_dbg(NOISY, "set ACL from mode for %s\n", path);
 
 	/* Get the security descriptor */
 	pntsd = get_cifs_acl(CIFS_SB(inode->i_sb), inode, path, &secdesclen);
 	if (IS_ERR(pntsd)) {
 		rc = PTR_ERR(pntsd);
-		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
+		cifs_dbg(VFS, "%s: error %d getting sec desc\n", __func__, rc);
 		goto out;
 	}
 
@@ -1046,7 +1048,6 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	secdesclen = max_t(u32, secdesclen, DEFAULT_SEC_DESC_LEN);
 	pnntsd = kmalloc(secdesclen, GFP_KERNEL);
 	if (!pnntsd) {
-		cERROR(1, "Unable to allocate security descriptor");
 		kfree(pntsd);
 		return -ENOMEM;
 	}
@@ -1054,12 +1055,12 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmode,
 	rc = build_sec_desc(pntsd, pnntsd, secdesclen, nmode, uid, gid,
 				&aclflag);
 
-	cFYI(DBG2, "build_sec_desc rc: %d", rc);
+	cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
 
 	if (!rc) {
 		/* Set the security descriptor */
 		rc = set_cifs_acl(pnntsd, secdesclen, inode, path, aclflag);
-		cFYI(DBG2, "set_cifs_acl rc: %d", rc);
+		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
 	}
 
 	kfree(pnntsd);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 652f505..2cbbec6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -50,20 +50,20 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 		return -EINVAL;
 
 	if (!server->secmech.sdescmd5) {
-		cERROR(1, "%s: Can't generate signature", __func__);
+		cifs_dbg(VFS, "%s: Can't generate signature\n", __func__);
 		return -1;
 	}
 
 	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5", __func__);
+		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
 		server->session_key.response, server->session_key.len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response", __func__);
+		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
@@ -71,7 +71,7 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "null iovec entry");
+			cifs_dbg(VFS, "null iovec entry\n");
 			return -EIO;
 		}
 		/* The first entry includes a length field (which does not get
@@ -88,8 +88,8 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 				iov[i].iov_base, iov[i].iov_len);
 		}
 		if (rc) {
-			cERROR(1, "%s: Could not update with payload",
-							__func__);
+			cifs_dbg(VFS, "%s: Could not update with payload\n",
+				 __func__);
 			return rc;
 		}
 	}
@@ -106,7 +106,7 @@ static int cifs_calc_signature(struct smb_rqst *rqst,
 
 	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
 	return rc;
 }
@@ -196,8 +196,8 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 
 	/* Do not need to verify session setups with signature "BSRSPYL "  */
 	if (memcmp(cifs_pdu->Signature.SecuritySignature, "BSRSPYL ", 8) == 0)
-		cFYI(1, "dummy signature received for smb command 0x%x",
-			cifs_pdu->Command);
+		cifs_dbg(FYI, "dummy signature received for smb command 0x%x\n",
+			 cifs_pdu->Command);
 
 	/* save off the origiginal signature so we can modify the smb and check
 		its signature against what the server sent */
@@ -235,30 +235,30 @@ int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		return -EINVAL;
 
 	ses->auth_key.response = kmalloc(temp_len, GFP_KERNEL);
-	if (!ses->auth_key.response) {
-		cERROR(1, "NTLM can't allocate (%u bytes) memory", temp_len);
+	if (!ses->auth_key.response)
 		return -ENOMEM;
-	}
+
 	ses->auth_key.len = temp_len;
 
 	rc = SMBNTencrypt(ses->password, ses->server->cryptkey,
 			ses->auth_key.response + CIFS_SESS_KEY_SIZE, nls_cp);
 	if (rc) {
-		cFYI(1, "%s Can't generate NTLM response, error: %d",
-			__func__, rc);
+		cifs_dbg(FYI, "%s Can't generate NTLM response, error: %d\n",
+			 __func__, rc);
 		return rc;
 	}
 
 	rc = E_md4hash(ses->password, temp_key, nls_cp);
 	if (rc) {
-		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
+		cifs_dbg(FYI, "%s Can't generate NT hash, error: %d\n",
+			 __func__, rc);
 		return rc;
 	}
 
 	rc = mdfour(ses->auth_key.response, temp_key, CIFS_SESS_KEY_SIZE);
 	if (rc)
-		cFYI(1, "%s Can't generate NTLM session key, error: %d",
-			__func__, rc);
+		cifs_dbg(FYI, "%s Can't generate NTLM session key, error: %d\n",
+			 __func__, rc);
 
 	return rc;
 }
@@ -334,7 +334,6 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
 		ses->auth_key.len = 0;
-		cERROR(1, "Challenge target info allocation failure");
 		return -ENOMEM;
 	}
 
@@ -420,7 +419,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	wchar_t *server;
 
 	if (!ses->server->secmech.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash");
+		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
 		return -1;
 	}
 
@@ -430,13 +429,13 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
 				CIFS_NTHASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set NT Hash as a key", __func__);
+		cifs_dbg(VFS, "%s: Could not set NT Hash as a key\n", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "calc_ntlmv2_hash: could not init hmacmd5");
+		cifs_dbg(VFS, "%s: could not init hmacmd5\n", __func__);
 		return rc;
 	}
 
@@ -444,7 +443,6 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
-		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure");
 		rc = -ENOMEM;
 		return rc;
 	}
@@ -460,7 +458,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 				(char *)user, 2 * len);
 	kfree(user);
 	if (rc) {
-		cERROR(1, "%s: Could not update with user", __func__);
+		cifs_dbg(VFS, "%s: Could not update with user\n", __func__);
 		return rc;
 	}
 
@@ -470,7 +468,6 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 		domain = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (domain == NULL) {
-			cERROR(1, "calc_ntlmv2_hash: domain mem alloc failure");
 			rc = -ENOMEM;
 			return rc;
 		}
@@ -481,8 +478,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 					(char *)domain, 2 * len);
 		kfree(domain);
 		if (rc) {
-			cERROR(1, "%s: Could not update with domain",
-								__func__);
+			cifs_dbg(VFS, "%s: Could not update with domain\n",
+				 __func__);
 			return rc;
 		}
 	} else if (ses->serverName) {
@@ -490,7 +487,6 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
 		if (server == NULL) {
-			cERROR(1, "calc_ntlmv2_hash: server mem alloc failure");
 			rc = -ENOMEM;
 			return rc;
 		}
@@ -501,8 +497,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 					(char *)server, 2 * len);
 		kfree(server);
 		if (rc) {
-			cERROR(1, "%s: Could not update with server",
-								__func__);
+			cifs_dbg(VFS, "%s: Could not update with server\n",
+				 __func__);
 			return rc;
 		}
 	}
@@ -510,7 +506,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 					ntlmv2_hash);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
 	return rc;
 }
@@ -522,20 +518,21 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
 
 	if (!ses->server->secmech.sdeschmacmd5) {
-		cERROR(1, "calc_ntlmv2_hash: can't generate ntlmv2 hash");
+		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
 		return -1;
 	}
 
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
 				ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set NTLMV2 Hash as a key", __func__);
+		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
+			 __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "CalcNTLMv2_response: could not init hmacmd5");
+		cifs_dbg(VFS, "%s: could not init hmacmd5\n", __func__);
 		return rc;
 	}
 
@@ -548,14 +545,14 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + offset, ses->auth_key.len - offset);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response", __func__);
+		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
 	return rc;
 }
@@ -575,14 +572,15 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		if (!ses->domainName) {
 			rc = find_domain_name(ses, nls_cp);
 			if (rc) {
-				cERROR(1, "error %d finding domain name", rc);
+				cifs_dbg(VFS, "error %d finding domain name\n",
+					 rc);
 				goto setup_ntlmv2_rsp_ret;
 			}
 		}
 	} else {
 		rc = build_avpair_blob(ses, nls_cp);
 		if (rc) {
-			cERROR(1, "error %d building av pair blob", rc);
+			cifs_dbg(VFS, "error %d building av pair blob\n", rc);
 			goto setup_ntlmv2_rsp_ret;
 		}
 	}
@@ -595,7 +593,6 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	if (!ses->auth_key.response) {
 		rc = ENOMEM;
 		ses->auth_key.len = 0;
-		cERROR(1, "%s: Can't allocate auth blob", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 	ses->auth_key.len += baselen;
@@ -613,14 +610,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	/* calculate ntlmv2_hash */
 	rc = calc_ntlmv2_hash(ses, ntlmv2_hash, nls_cp);
 	if (rc) {
-		cERROR(1, "could not get v2 hash rc %d", rc);
+		cifs_dbg(VFS, "could not get v2 hash rc %d\n", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	/* calculate first part of the client response (CR1) */
 	rc = CalcNTLMv2_response(ses, ntlmv2_hash);
 	if (rc) {
-		cERROR(1, "Could not calculate CR1  rc: %d", rc);
+		cifs_dbg(VFS, "Could not calculate CR1 rc: %d\n", rc);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
@@ -628,13 +625,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
 		ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set NTLMV2 Hash as a key", __func__);
+		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
+			 __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	rc = crypto_shash_init(&ses->server->secmech.sdeschmacmd5->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init hmacmd5", __func__);
+		cifs_dbg(VFS, "%s: Could not init hmacmd5\n", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
@@ -642,14 +640,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 		ses->auth_key.response + CIFS_SESS_KEY_SIZE,
 		CIFS_HMAC_MD5_HASH_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response", __func__);
+		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		goto setup_ntlmv2_rsp_ret;
 	}
 
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
 		ses->auth_key.response);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
 setup_ntlmv2_rsp_ret:
 	kfree(tiblob);
@@ -671,7 +669,7 @@ calc_seckey(struct cifs_ses *ses)
 	tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm_arc4)) {
 		rc = PTR_ERR(tfm_arc4);
-		cERROR(1, "could not allocate crypto API arc4");
+		cifs_dbg(VFS, "could not allocate crypto API arc4\n");
 		return rc;
 	}
 
@@ -680,7 +678,8 @@ calc_seckey(struct cifs_ses *ses)
 	rc = crypto_blkcipher_setkey(tfm_arc4, ses->auth_key.response,
 					CIFS_SESS_KEY_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not set response as a key", __func__);
+		cifs_dbg(VFS, "%s: Could not set response as a key\n",
+			 __func__);
 		return rc;
 	}
 
@@ -689,7 +688,7 @@ calc_seckey(struct cifs_ses *ses)
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, CIFS_CPHTXT_SIZE);
 	if (rc) {
-		cERROR(1, "could not encrypt session key rc: %d", rc);
+		cifs_dbg(VFS, "could not encrypt session key rc: %d\n", rc);
 		crypto_free_blkcipher(tfm_arc4);
 		return rc;
 	}
@@ -731,20 +730,20 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 
 	server->secmech.hmacmd5 = crypto_alloc_shash("hmac(md5)", 0, 0);
 	if (IS_ERR(server->secmech.hmacmd5)) {
-		cERROR(1, "could not allocate crypto hmacmd5");
+		cifs_dbg(VFS, "could not allocate crypto hmacmd5\n");
 		return PTR_ERR(server->secmech.hmacmd5);
 	}
 
 	server->secmech.md5 = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(server->secmech.md5)) {
-		cERROR(1, "could not allocate crypto md5");
+		cifs_dbg(VFS, "could not allocate crypto md5\n");
 		rc = PTR_ERR(server->secmech.md5);
 		goto crypto_allocate_md5_fail;
 	}
 
 	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
 	if (IS_ERR(server->secmech.hmacsha256)) {
-		cERROR(1, "could not allocate crypto hmacsha256\n");
+		cifs_dbg(VFS, "could not allocate crypto hmacsha256\n");
 		rc = PTR_ERR(server->secmech.hmacsha256);
 		goto crypto_allocate_hmacsha256_fail;
 	}
@@ -753,7 +752,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.hmacmd5);
 	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdeschmacmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc hmacmd5");
 		rc = -ENOMEM;
 		goto crypto_allocate_hmacmd5_sdesc_fail;
 	}
@@ -764,7 +762,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.md5);
 	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdescmd5) {
-		cERROR(1, "cifs_crypto_shash_allocate: can't alloc md5");
 		rc = -ENOMEM;
 		goto crypto_allocate_md5_sdesc_fail;
 	}
@@ -775,7 +772,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.hmacsha256);
 	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdeschmacsha256) {
-		cERROR(1, "%s: Can't alloc hmacsha256\n", __func__);
 		rc = -ENOMEM;
 		goto crypto_allocate_hmacsha256_sdesc_fail;
 	}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 1a052c0..a3adf7a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -137,7 +137,7 @@ cifs_read_super(struct super_block *sb)
 
 #ifdef CONFIG_CIFS_NFSD_EXPORT
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
-		cFYI(1, "export ops supported");
+		cifs_dbg(FYI, "export ops supported\n");
 		sb->s_export_op = &cifs_export_ops;
 	}
 #endif /* CONFIG_CIFS_NFSD_EXPORT */
@@ -145,7 +145,7 @@ cifs_read_super(struct super_block *sb)
 	return 0;
 
 out_no_root:
-	cERROR(1, "cifs_read_super: get root inode failed");
+	cifs_dbg(VFS, "%s: get root inode failed\n", __func__);
 	return rc;
 }
 
@@ -478,7 +478,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
 	/* cancel_notify_requests(tcon); */
 	if (tcon->ses && tcon->ses->server) {
-		cFYI(1, "wake up tasks now - umount begin not complete");
+		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
 		wake_up_all(&tcon->ses->server->request_q);
 		wake_up_all(&tcon->ses->server->response_q);
 		msleep(1); /* yield */
@@ -549,7 +549,7 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	cFYI(1, "Get root dentry for %s", full_path);
+	cifs_dbg(FYI, "Get root dentry for %s\n", full_path);
 
 	sep = CIFS_DIR_SEP(cifs_sb);
 	dentry = dget(sb->s_root);
@@ -608,7 +608,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 	struct cifs_mnt_data mnt_data;
 	struct dentry *root;
 
-	cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
+	cifs_dbg(FYI, "Devname: %s flags: %d\n", dev_name, flags);
 
 	volume_info = cifs_get_volume_info((char *)data, dev_name);
 	if (IS_ERR(volume_info))
@@ -631,7 +631,8 @@ cifs_do_mount(struct file_system_type *fs_type,
 	rc = cifs_mount(cifs_sb, volume_info);
 	if (rc) {
 		if (!(flags & MS_SILENT))
-			cERROR(1, "cifs_mount failed w/return code = %d", rc);
+			cifs_dbg(VFS, "cifs_mount failed w/return code = %d\n",
+				 rc);
 		root = ERR_PTR(rc);
 		goto out_mountdata;
 	}
@@ -651,7 +652,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 	}
 
 	if (sb->s_root) {
-		cFYI(1, "Use existing superblock");
+		cifs_dbg(FYI, "Use existing superblock\n");
 		cifs_umount(cifs_sb);
 	} else {
 		rc = cifs_read_super(sb);
@@ -667,7 +668,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 	if (IS_ERR(root))
 		goto out_super;
 
-	cFYI(1, "dentry root is: %p", root);
+	cifs_dbg(FYI, "dentry root is: %p\n", root);
 	goto out;
 
 out_super:
@@ -699,7 +700,8 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	rc = filemap_fdatawrite(inode->i_mapping);
 	if (rc)
-		cFYI(1, "cifs_file_aio_write: %d rc on %p inode", rc, inode);
+		cifs_dbg(FYI, "cifs_file_aio_write: %d rc on %p inode\n",
+			 rc, inode);
 
 	return written;
 }
@@ -1005,7 +1007,10 @@ cifs_init_request_bufs(void)
 	} else {
 		CIFSMaxBufSize &= 0x1FE00; /* Round size to even 512 byte mult*/
 	}
-/*	cERROR(1, "CIFSMaxBufSize %d 0x%x",CIFSMaxBufSize,CIFSMaxBufSize); */
+/*
+	cifs_dbg(VFS, "CIFSMaxBufSize %d 0x%x\n",
+		 CIFSMaxBufSize, CIFSMaxBufSize);
+*/
 	cifs_req_cachep = kmem_cache_create("cifs_request",
 					    CIFSMaxBufSize + max_hdr_size, 0,
 					    SLAB_HWCACHE_ALIGN, NULL);
@@ -1016,7 +1021,7 @@ cifs_init_request_bufs(void)
 		cifs_min_rcv = 1;
 	else if (cifs_min_rcv > 64) {
 		cifs_min_rcv = 64;
-		cERROR(1, "cifs_min_rcv set to maximum (64)");
+		cifs_dbg(VFS, "cifs_min_rcv set to maximum (64)\n");
 	}
 
 	cifs_req_poolp = mempool_create_slab_pool(cifs_min_rcv,
@@ -1047,7 +1052,7 @@ cifs_init_request_bufs(void)
 		cifs_min_small = 2;
 	else if (cifs_min_small > 256) {
 		cifs_min_small = 256;
-		cFYI(1, "cifs_min_small set to maximum (256)");
+		cifs_dbg(FYI, "cifs_min_small set to maximum (256)\n");
 	}
 
 	cifs_sm_req_poolp = mempool_create_slab_pool(cifs_min_small,
@@ -1138,10 +1143,11 @@ init_cifs(void)
 
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
-		cFYI(1, "cifs_max_pending set to min of 2");
+		cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
 	} else if (cifs_max_pending > CIFS_MAX_REQ) {
 		cifs_max_pending = CIFS_MAX_REQ;
-		cFYI(1, "cifs_max_pending set to max of %u", CIFS_MAX_REQ);
+		cifs_dbg(FYI, "cifs_max_pending set to max of %u\n",
+			 CIFS_MAX_REQ);
 	}
 
 	cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
@@ -1210,7 +1216,7 @@ out_clean_proc:
 static void __exit
 exit_cifs(void)
 {
-	cFYI(DBG2, "exit_cifs");
+	cifs_dbg(NOISY, "exit_cifs\n");
 	unregister_filesystem(&cifs_fs_type);
 	cifs_dfs_release_automount_timer();
 #ifdef CONFIG_CIFS_ACL
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f450f06..dda188a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -45,17 +45,17 @@ extern void _free_xid(unsigned int);
 #define get_xid()						\
 ({								\
 	unsigned int __xid = _get_xid();				\
-	cFYI(1, "CIFS VFS: in %s as Xid: %u with uid: %d",	\
-	     __func__, __xid,					\
-	     from_kuid(&init_user_ns, current_fsuid()));	\
+	cifs_dbg(FYI, "CIFS VFS: in %s as Xid: %u with uid: %d\n",	\
+		 __func__, __xid,					\
+		 from_kuid(&init_user_ns, current_fsuid()));		\
 	__xid;							\
 })
 
 #define free_xid(curr_xid)					\
 do {								\
 	_free_xid(curr_xid);					\
-	cFYI(1, "CIFS VFS: leaving %s (xid = %u) rc = %d",	\
-	     __func__, curr_xid, (int)rc);			\
+	cifs_dbg(FYI, "CIFS VFS: leaving %s (xid = %u) rc = %d\n",	\
+		 __func__, curr_xid, (int)rc);				\
 } while (0)
 extern int init_cifs_idmap(void);
 extern void exit_cifs_idmap(void);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8e2e799..076d7ed 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -139,8 +139,8 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		if (smb_command != SMB_COM_WRITE_ANDX &&
 		    smb_command != SMB_COM_OPEN_ANDX &&
 		    smb_command != SMB_COM_TREE_DISCONNECT) {
-			cFYI(1, "can not send cmd %d while umounting",
-				smb_command);
+			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
+				 smb_command);
 			return -ENODEV;
 		}
 	}
@@ -163,7 +163,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		 * back on-line
 		 */
 		if (!tcon->retry) {
-			cFYI(1, "gave up waiting on reconnect in smb_init");
+			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
 			return -EHOSTDOWN;
 		}
 	}
@@ -191,7 +191,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	cifs_mark_open_files_invalid(tcon);
 	rc = CIFSTCon(0, ses, tcon->treeName, tcon, nls_codepage);
 	mutex_unlock(&ses->session_mutex);
-	cFYI(1, "reconnect tcon rc = %d", rc);
+	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 
 	if (rc)
 		goto out;
@@ -396,7 +396,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	else /* if override flags set only sign/seal OR them with global auth */
 		secFlags = global_secflags | ses->overrideSecFlg;
 
-	cFYI(1, "secFlags 0x%x", secFlags);
+	cifs_dbg(FYI, "secFlags 0x%x\n", secFlags);
 
 	pSMB->hdr.Mid = get_next_mid(server);
 	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
@@ -404,12 +404,12 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5) {
-		cFYI(1, "Kerberos only mechanism, enable extended security");
+		cifs_dbg(FYI, "Kerberos only mechanism, enable extended security\n");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	} else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP) {
-		cFYI(1, "NTLMSSP only mechanism, enable extended security");
+		cifs_dbg(FYI, "NTLMSSP only mechanism, enable extended security\n");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	}
 
@@ -428,7 +428,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		goto neg_err_exit;
 
 	server->dialect = le16_to_cpu(pSMBr->DialectIndex);
-	cFYI(1, "Dialect: %d", server->dialect);
+	cifs_dbg(FYI, "Dialect: %d\n", server->dialect);
 	/* Check wct = 1 error case */
 	if ((pSMBr->hdr.WordCount < 13) || (server->dialect == BAD_PROT)) {
 		/* core returns wct = 1, but we do not ask for core - otherwise
@@ -447,8 +447,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			(secFlags & CIFSSEC_MAY_PLNTXT))
 			server->secType = LANMAN;
 		else {
-			cERROR(1, "mount failed weak security disabled"
-				   " in /proc/fs/cifs/SecurityFlags");
+			cifs_dbg(VFS, "mount failed weak security disabled in /proc/fs/cifs/SecurityFlags\n");
 			rc = -EOPNOTSUPP;
 			goto neg_err_exit;
 		}
@@ -482,9 +481,9 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			utc = CURRENT_TIME;
 			ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
 					    rsp->SrvTime.Time, 0);
-			cFYI(1, "SrvTime %d sec since 1970 (utc: %d) diff: %d",
-				(int)ts.tv_sec, (int)utc.tv_sec,
-				(int)(utc.tv_sec - ts.tv_sec));
+			cifs_dbg(FYI, "SrvTime %d sec since 1970 (utc: %d) diff: %d\n",
+				 (int)ts.tv_sec, (int)utc.tv_sec,
+				 (int)(utc.tv_sec - ts.tv_sec));
 			val = (int)(utc.tv_sec - ts.tv_sec);
 			seconds = abs(val);
 			result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
@@ -498,7 +497,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			server->timeAdj = (int)tmp;
 			server->timeAdj *= 60; /* also in seconds */
 		}
-		cFYI(1, "server->timeAdj: %d seconds", server->timeAdj);
+		cifs_dbg(FYI, "server->timeAdj: %d seconds\n", server->timeAdj);
 
 
 		/* BB get server time for time conversions and add
@@ -513,14 +512,13 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			goto neg_err_exit;
 		}
 
-		cFYI(1, "LANMAN negotiated");
+		cifs_dbg(FYI, "LANMAN negotiated\n");
 		/* we will not end up setting signing flags - as no signing
 		was in LANMAN and server did not return the flags on */
 		goto signing_check;
 #else /* weak security disabled */
 	} else if (pSMBr->hdr.WordCount == 13) {
-		cERROR(1, "mount failed, cifs module not built "
-			  "with CIFS_WEAK_PW_HASH support");
+		cifs_dbg(VFS, "mount failed, cifs module not built with CIFS_WEAK_PW_HASH support\n");
 		rc = -EOPNOTSUPP;
 #endif /* WEAK_PW_HASH */
 		goto neg_err_exit;
@@ -532,14 +530,13 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	/* else wct == 17 NTLM */
 	server->sec_mode = pSMBr->SecurityMode;
 	if ((server->sec_mode & SECMODE_USER) == 0)
-		cFYI(1, "share mode security");
+		cifs_dbg(FYI, "share mode security\n");
 
 	if ((server->sec_mode & SECMODE_PW_ENCRYPT) == 0)
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((secFlags & CIFSSEC_MAY_PLNTXT) == 0)
 #endif /* CIFS_WEAK_PW_HASH */
-			cERROR(1, "Server requests plain text password"
-				  " but client support disabled");
+			cifs_dbg(VFS, "Server requests plain text password but client support disabled\n");
 
 	if ((secFlags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
 		server->secType = NTLMv2;
@@ -555,7 +552,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		server->secType = LANMAN;
 	else {
 		rc = -EOPNOTSUPP;
-		cERROR(1, "Invalid security type");
+		cifs_dbg(VFS, "Invalid security type\n");
 		goto neg_err_exit;
 	}
 	/* else ... any others ...? */
@@ -568,7 +565,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	/* probably no need to store and check maxvcs */
 	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
-	cFYI(DBG2, "Max buf = %d", ses->server->maxBuf);
+	cifs_dbg(NOISY, "Max buf = %d\n", ses->server->maxBuf);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
@@ -590,7 +587,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			if (memcmp(server->server_GUID,
 				   pSMBr->u.extended_response.
 				   GUID, 16) != 0) {
-				cFYI(1, "server UID changed");
+				cifs_dbg(FYI, "server UID changed\n");
 				memcpy(server->server_GUID,
 					pSMBr->u.extended_response.GUID,
 					16);
@@ -633,21 +630,19 @@ signing_check:
 	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
 		/* MUST_SIGN already includes the MAY_SIGN FLAG
 		   so if this is zero it means that signing is disabled */
-		cFYI(1, "Signing disabled");
+		cifs_dbg(FYI, "Signing disabled\n");
 		if (server->sec_mode & SECMODE_SIGN_REQUIRED) {
-			cERROR(1, "Server requires "
-				   "packet signing to be enabled in "
-				   "/proc/fs/cifs/SecurityFlags.");
+			cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
 			rc = -EOPNOTSUPP;
 		}
 		server->sec_mode &=
 			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
 	} else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
 		/* signing required */
-		cFYI(1, "Must sign - secFlags 0x%x", secFlags);
+		cifs_dbg(FYI, "Must sign - secFlags 0x%x\n", secFlags);
 		if ((server->sec_mode &
 			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
-			cERROR(1, "signing required but server lacks support");
+			cifs_dbg(VFS, "signing required but server lacks support\n");
 			rc = -EOPNOTSUPP;
 		} else
 			server->sec_mode |= SECMODE_SIGN_REQUIRED;
@@ -661,7 +656,7 @@ signing_check:
 neg_err_exit:
 	cifs_buf_release(pSMB);
 
-	cFYI(1, "negprot rc %d", rc);
+	cifs_dbg(FYI, "negprot rc %d\n", rc);
 	return rc;
 }
 
@@ -671,7 +666,7 @@ CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
 	struct smb_hdr *smb_buffer;
 	int rc = 0;
 
-	cFYI(1, "In tree disconnect");
+	cifs_dbg(FYI, "In tree disconnect\n");
 
 	/* BB: do we need to check this? These should never be NULL. */
 	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
@@ -693,7 +688,7 @@ CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *)smb_buffer, 0);
 	if (rc)
-		cFYI(1, "Tree disconnect failed %d", rc);
+		cifs_dbg(FYI, "Tree disconnect failed %d\n", rc);
 
 	/* No need to return error on this operation if tid invalidated and
 	   closed on server already e.g. due to tcp session crashing */
@@ -728,7 +723,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	struct smb_rqst rqst = { .rq_iov = &iov,
 				 .rq_nvec = 1 };
 
-	cFYI(1, "In echo request");
+	cifs_dbg(FYI, "In echo request\n");
 
 	rc = small_smb_init(SMB_COM_ECHO, 0, NULL, (void **)&smb);
 	if (rc)
@@ -747,7 +742,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback,
 			     server, CIFS_ASYNC_OP | CIFS_ECHO_OP);
 	if (rc)
-		cFYI(1, "Echo request failed: %d", rc);
+		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
 	cifs_small_buf_release(smb);
 
@@ -760,7 +755,7 @@ CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses)
 	LOGOFF_ANDX_REQ *pSMB;
 	int rc = 0;
 
-	cFYI(1, "In SMBLogoff for session disconnect");
+	cifs_dbg(FYI, "In SMBLogoff for session disconnect\n");
 
 	/*
 	 * BB: do we need to check validity of ses and server? They should
@@ -814,7 +809,7 @@ CIFSPOSIXDelFile(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, "In POSIX delete");
+	cifs_dbg(FYI, "In POSIX delete\n");
 PsxDelete:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -866,7 +861,7 @@ PsxDelete:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "Posix delete returned %d", rc);
+		cifs_dbg(FYI, "Posix delete returned %d\n", rc);
 	cifs_buf_release(pSMB);
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
@@ -914,7 +909,7 @@ DelFileRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_deletes);
 	if (rc)
-		cFYI(1, "Error in RMFile = %d", rc);
+		cifs_dbg(FYI, "Error in RMFile = %d\n", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -934,7 +929,7 @@ CIFSSMBRmDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	int name_len;
 	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
-	cFYI(1, "In CIFSSMBRmDir");
+	cifs_dbg(FYI, "In CIFSSMBRmDir\n");
 RmDirRetry:
 	rc = smb_init(SMB_COM_DELETE_DIRECTORY, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -960,7 +955,7 @@ RmDirRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_rmdirs);
 	if (rc)
-		cFYI(1, "Error in RMDir = %d", rc);
+		cifs_dbg(FYI, "Error in RMDir = %d\n", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -979,7 +974,7 @@ CIFSSMBMkDir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	int name_len;
 	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
-	cFYI(1, "In CIFSSMBMkDir");
+	cifs_dbg(FYI, "In CIFSSMBMkDir\n");
 MkDirRetry:
 	rc = smb_init(SMB_COM_CREATE_DIRECTORY, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -1005,7 +1000,7 @@ MkDirRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_mkdirs);
 	if (rc)
-		cFYI(1, "Error in Mkdir = %d", rc);
+		cifs_dbg(FYI, "Error in Mkdir = %d\n", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -1029,7 +1024,7 @@ CIFSPOSIXCreate(const unsigned int xid, struct cifs_tcon *tcon,
 	OPEN_PSX_REQ *pdata;
 	OPEN_PSX_RSP *psx_rsp;
 
-	cFYI(1, "In POSIX Create");
+	cifs_dbg(FYI, "In POSIX Create\n");
 PsxCreat:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -1083,11 +1078,11 @@ PsxCreat:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Posix create returned %d", rc);
+		cifs_dbg(FYI, "Posix create returned %d\n", rc);
 		goto psx_create_err;
 	}
 
-	cFYI(1, "copying inode info");
+	cifs_dbg(FYI, "copying inode info\n");
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 	if (rc || get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)) {
@@ -1109,11 +1104,11 @@ PsxCreat:
 	/* check to make sure response data is there */
 	if (psx_rsp->ReturnedLevel != cpu_to_le16(SMB_QUERY_FILE_UNIX_BASIC)) {
 		pRetData->Type = cpu_to_le32(-1); /* unknown */
-		cFYI(DBG2, "unknown type");
+		cifs_dbg(NOISY, "unknown type\n");
 	} else {
 		if (get_bcc(&pSMBr->hdr) < sizeof(OPEN_PSX_RSP)
 					+ sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Open response data too small");
+			cifs_dbg(VFS, "Open response data too small\n");
 			pRetData->Type = cpu_to_le32(-1);
 			goto psx_create_err;
 		}
@@ -1160,7 +1155,7 @@ static __u16 convert_disposition(int disposition)
 			ofun = SMBOPEN_OCREATE | SMBOPEN_OTRUNC;
 			break;
 		default:
-			cFYI(1, "unknown disposition %d", disposition);
+			cifs_dbg(FYI, "unknown disposition %d\n", disposition);
 			ofun =  SMBOPEN_OAPPEND; /* regular open */
 	}
 	return ofun;
@@ -1251,7 +1246,7 @@ OldOpenRetry:
 			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
 	if (rc) {
-		cFYI(1, "Error in Open = %d", rc);
+		cifs_dbg(FYI, "Error in Open = %d\n", rc);
 	} else {
 	/* BB verify if wct == 15 */
 
@@ -1364,7 +1359,7 @@ openRetry:
 			(struct smb_hdr *)pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_opens);
 	if (rc) {
-		cFYI(1, "Error in Open = %d", rc);
+		cifs_dbg(FYI, "Error in Open = %d\n", rc);
 	} else {
 		*pOplock = pSMBr->OplockLevel; /* 1 byte no need to le_to_cpu */
 		*netfid = pSMBr->Fid;	/* cifs fid stays in le */
@@ -1425,8 +1420,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	char *buf = server->smallbuf;
 	unsigned int buflen = get_rfc1002_length(buf) + 4;
 
-	cFYI(1, "%s: mid=%llu offset=%llu bytes=%u", __func__,
-		mid->mid, rdata->offset, rdata->bytes);
+	cifs_dbg(FYI, "%s: mid=%llu offset=%llu bytes=%u\n",
+		 __func__, mid->mid, rdata->offset, rdata->bytes);
 
 	/*
 	 * read the rest of READ_RSP header (sans Data array), or whatever we
@@ -1447,16 +1442,16 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	/* Was the SMB read successful? */
 	rdata->result = server->ops->map_error(buf, false);
 	if (rdata->result != 0) {
-		cFYI(1, "%s: server returned error %d", __func__,
-			rdata->result);
+		cifs_dbg(FYI, "%s: server returned error %d\n",
+			 __func__, rdata->result);
 		return cifs_readv_discard(server, mid);
 	}
 
 	/* Is there enough to get to the rest of the READ_RSP header? */
 	if (server->total_read < server->vals->read_rsp_size) {
-		cFYI(1, "%s: server returned short header. got=%u expected=%zu",
-			__func__, server->total_read,
-			server->vals->read_rsp_size);
+		cifs_dbg(FYI, "%s: server returned short header. got=%u expected=%zu\n",
+			 __func__, server->total_read,
+			 server->vals->read_rsp_size);
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
 	}
@@ -1468,19 +1463,19 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		 * is beyond the EOF. Treat it as if the data starts just after
 		 * the header.
 		 */
-		cFYI(1, "%s: data offset (%u) inside read response header",
-			__func__, data_offset);
+		cifs_dbg(FYI, "%s: data offset (%u) inside read response header\n",
+			 __func__, data_offset);
 		data_offset = server->total_read;
 	} else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
 		/* data_offset is beyond the end of smallbuf */
-		cFYI(1, "%s: data offset (%u) beyond end of smallbuf",
-			__func__, data_offset);
+		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
+			 __func__, data_offset);
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
 	}
 
-	cFYI(1, "%s: total_read=%u data_offset=%u", __func__,
-		server->total_read, data_offset);
+	cifs_dbg(FYI, "%s: total_read=%u data_offset=%u\n",
+		 __func__, server->total_read, data_offset);
 
 	len = data_offset - server->total_read;
 	if (len > 0) {
@@ -1496,8 +1491,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	/* set up first iov for signature check */
 	rdata->iov.iov_base = buf;
 	rdata->iov.iov_len = server->total_read;
-	cFYI(1, "0: iov_base=%p iov_len=%zu",
-		rdata->iov.iov_base, rdata->iov.iov_len);
+	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
+		 rdata->iov.iov_base, rdata->iov.iov_len);
 
 	/* how much data is in the response? */
 	data_len = server->ops->read_data_length(buf);
@@ -1514,8 +1509,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	server->total_read += length;
 	rdata->bytes = length;
 
-	cFYI(1, "total_read=%u buflen=%u remaining=%u", server->total_read,
-		buflen, data_len);
+	cifs_dbg(FYI, "total_read=%u buflen=%u remaining=%u\n",
+		 server->total_read, buflen, data_len);
 
 	/* discard anything left over */
 	if (server->total_read < buflen)
@@ -1538,8 +1533,9 @@ cifs_readv_callback(struct mid_q_entry *mid)
 				 .rq_pagesz = rdata->pagesz,
 				 .rq_tailsz = rdata->tailsz };
 
-	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
-		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
+	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%u\n",
+		 __func__, mid->mid, mid->mid_state, rdata->result,
+		 rdata->bytes);
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -1551,8 +1547,8 @@ cifs_readv_callback(struct mid_q_entry *mid)
 			rc = cifs_verify_signature(&rqst, server,
 						  mid->sequence_number + 1);
 			if (rc)
-				cERROR(1, "SMB signature verification returned "
-				       "error = %d", rc);
+				cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
+					 rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->bytes);
@@ -1582,8 +1578,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1 };
 
-	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
-		rdata->offset, rdata->bytes);
+	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
+		 __func__, rdata->offset, rdata->bytes);
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES)
 		wct = 12;
@@ -1653,7 +1649,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	struct cifs_tcon *tcon = io_parms->tcon;
 	unsigned int count = io_parms->length;
 
-	cFYI(1, "Reading %d bytes on fid %d", count, netfid);
+	cifs_dbg(FYI, "Reading %d bytes on fid %d\n", count, netfid);
 	if (tcon->ses->capabilities & CAP_LARGE_FILES)
 		wct = 12;
 	else {
@@ -1701,7 +1697,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
 	pSMBr = (READ_RSP *)iov[0].iov_base;
 	if (rc) {
-		cERROR(1, "Send error in read = %d", rc);
+		cifs_dbg(VFS, "Send error in read = %d\n", rc);
 	} else {
 		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
 		data_length = data_length << 16;
@@ -1711,7 +1707,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 		/*check that DataLength would not go beyond end of SMB */
 		if ((data_length > CIFSMaxBufSize)
 				|| (data_length > count)) {
-			cFYI(1, "bad length %d for count %d",
+			cifs_dbg(FYI, "bad length %d for count %d\n",
 				 data_length, count);
 			rc = -EIO;
 			*nbytes = 0;
@@ -1719,7 +1715,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 			pReadData = (char *) (&pSMBr->hdr.Protocol) +
 					le16_to_cpu(pSMBr->DataOffset);
 /*			if (rc = copy_to_user(buf, pReadData, data_length)) {
-				cERROR(1, "Faulting on read rc = %d",rc);
+				cifs_dbg(VFS, "Faulting on read rc = %d\n",rc);
 				rc = -EFAULT;
 			}*/ /* can not use copy_to_user when using page cache*/
 			if (*buf)
@@ -1767,7 +1763,7 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	*nbytes = 0;
 
-	/* cFYI(1, "write at %lld %d bytes", offset, count);*/
+	/* cifs_dbg(FYI, "write at %lld %d bytes\n", offset, count);*/
 	if (tcon->ses == NULL)
 		return -ECONNABORTED;
 
@@ -1852,7 +1848,7 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, long_op);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
-		cFYI(1, "Send error in write = %d", rc);
+		cifs_dbg(FYI, "Send error in write = %d\n", rc);
 	} else {
 		*nbytes = le16_to_cpu(pSMBr->CountHigh);
 		*nbytes = (*nbytes) << 16;
@@ -1959,7 +1955,7 @@ cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
 
 	/* this would overflow */
 	if (nr_pages == 0) {
-		cERROR(1, "%s: called with nr_pages == 0!", __func__);
+		cifs_dbg(VFS, "%s: called with nr_pages == 0!\n", __func__);
 		return NULL;
 	}
 
@@ -2075,7 +2071,8 @@ cifs_async_writev(struct cifs_writedata *wdata)
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
 
-	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
+	cifs_dbg(FYI, "async write at %llu %u bytes\n",
+		 wdata->offset, wdata->bytes);
 
 	smb->DataLengthLow = cpu_to_le16(wdata->bytes & 0xFFFF);
 	smb->DataLengthHigh = cpu_to_le16(wdata->bytes >> 16);
@@ -2123,7 +2120,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	*nbytes = 0;
 
-	cFYI(1, "write2 at %lld %d bytes", (long long)offset, count);
+	cifs_dbg(FYI, "write2 at %lld %d bytes\n", (long long)offset, count);
 
 	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
 		wct = 14;
@@ -2182,7 +2179,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
-		cFYI(1, "Send error Write2 = %d", rc);
+		cifs_dbg(FYI, "Send error Write2 = %d\n", rc);
 	} else if (resp_buf_type == 0) {
 		/* presumably this can not happen, but best to be safe */
 		rc = -EIO;
@@ -2223,7 +2220,8 @@ int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buf_type;
 	__u16 count;
 
-	cFYI(1, "cifs_lockv num lock %d num unlock %d", num_lock, num_unlock);
+	cifs_dbg(FYI, "cifs_lockv num lock %d num unlock %d\n",
+		 num_lock, num_unlock);
 
 	rc = small_smb_init(SMB_COM_LOCKING_ANDX, 8, tcon, (void **) &pSMB);
 	if (rc)
@@ -2249,7 +2247,7 @@ int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
 	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
 	if (rc)
-		cFYI(1, "Send error in cifs_lockv = %d", rc);
+		cifs_dbg(FYI, "Send error in cifs_lockv = %d\n", rc);
 
 	return rc;
 }
@@ -2268,7 +2266,8 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 	int flags = 0;
 	__u16 count;
 
-	cFYI(1, "CIFSSMBLock timeout %d numLock %d", (int)waitFlag, numLock);
+	cifs_dbg(FYI, "CIFSSMBLock timeout %d numLock %d\n",
+		 (int)waitFlag, numLock);
 	rc = small_smb_init(SMB_COM_LOCKING_ANDX, 8, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -2317,7 +2316,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
 	if (rc)
-		cFYI(1, "Send error in Lock = %d", rc);
+		cifs_dbg(FYI, "Send error in Lock = %d\n", rc);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 	since file handle passed in no longer valid */
@@ -2341,7 +2340,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 params, param_offset, offset, byte_count, count;
 	struct kvec iov[1];
 
-	cFYI(1, "Posix Lock");
+	cifs_dbg(FYI, "Posix Lock\n");
 
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
@@ -2408,7 +2407,7 @@ CIFSSMBPosixLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	if (rc) {
-		cFYI(1, "Send error in Posix Lock = %d", rc);
+		cifs_dbg(FYI, "Send error in Posix Lock = %d\n", rc);
 	} else if (pLockData) {
 		/* lock structure can be returned on get */
 		__u16 data_offset;
@@ -2465,7 +2464,7 @@ CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 {
 	int rc = 0;
 	CLOSE_REQ *pSMB = NULL;
-	cFYI(1, "In CIFSSMBClose");
+	cifs_dbg(FYI, "In CIFSSMBClose\n");
 
 /* do not retry on dead session on close */
 	rc = small_smb_init(SMB_COM_CLOSE, 3, tcon, (void **) &pSMB);
@@ -2482,7 +2481,7 @@ CIFSSMBClose(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	if (rc) {
 		if (rc != -EINTR) {
 			/* EINTR is expected when user ctl-c to kill app */
-			cERROR(1, "Send error in Close = %d", rc);
+			cifs_dbg(VFS, "Send error in Close = %d\n", rc);
 		}
 	}
 
@@ -2498,7 +2497,7 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 {
 	int rc = 0;
 	FLUSH_REQ *pSMB = NULL;
-	cFYI(1, "In CIFSSMBFlush");
+	cifs_dbg(FYI, "In CIFSSMBFlush\n");
 
 	rc = small_smb_init(SMB_COM_FLUSH, 1, tcon, (void **) &pSMB);
 	if (rc)
@@ -2509,7 +2508,7 @@ CIFSSMBFlush(const unsigned int xid, struct cifs_tcon *tcon, int smb_file_id)
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_flushes);
 	if (rc)
-		cERROR(1, "Send error in Flush = %d", rc);
+		cifs_dbg(VFS, "Send error in Flush = %d\n", rc);
 
 	return rc;
 }
@@ -2527,7 +2526,7 @@ CIFSSMBRename(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 count;
 	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
-	cFYI(1, "In CIFSSMBRename");
+	cifs_dbg(FYI, "In CIFSSMBRename\n");
 renameRetry:
 	rc = smb_init(SMB_COM_RENAME, 1, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -2574,7 +2573,7 @@ renameRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_renames);
 	if (rc)
-		cFYI(1, "Send error in rename = %d", rc);
+		cifs_dbg(FYI, "Send error in rename = %d\n", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -2598,7 +2597,7 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 	int len_of_str;
 	__u16 params, param_offset, offset, count, byte_count;
 
-	cFYI(1, "Rename to File by handle");
+	cifs_dbg(FYI, "Rename to File by handle\n");
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, pTcon, (void **) &pSMB,
 			(void **) &pSMBr);
 	if (rc)
@@ -2655,7 +2654,8 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&pTcon->stats.cifs_stats.num_t2renames);
 	if (rc)
-		cFYI(1, "Send error in Rename (by file handle) = %d", rc);
+		cifs_dbg(FYI, "Send error in Rename (by file handle) = %d\n",
+			 rc);
 
 	cifs_buf_release(pSMB);
 
@@ -2677,7 +2677,7 @@ CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len, name_len2;
 	__u16 count;
 
-	cFYI(1, "In CIFSSMBCopy");
+	cifs_dbg(FYI, "In CIFSSMBCopy\n");
 copyRetry:
 	rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
 			(void **) &pSMBr);
@@ -2722,8 +2722,8 @@ copyRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in copy = %d with %d files copied",
-			rc, le16_to_cpu(pSMBr->CopyCount));
+		cifs_dbg(FYI, "Send error in copy = %d with %d files copied\n",
+			 rc, le16_to_cpu(pSMBr->CopyCount));
 	}
 	cifs_buf_release(pSMB);
 
@@ -2747,7 +2747,7 @@ CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, "In Symlink Unix style");
+	cifs_dbg(FYI, "In Symlink Unix style\n");
 createSymLinkRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -2812,7 +2812,8 @@ createSymLinkRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_symlinks);
 	if (rc)
-		cFYI(1, "Send error in SetPathInfo create symlink = %d", rc);
+		cifs_dbg(FYI, "Send error in SetPathInfo create symlink = %d\n",
+			 rc);
 
 	cifs_buf_release(pSMB);
 
@@ -2836,7 +2837,7 @@ CIFSUnixCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, "In Create Hard link Unix style");
+	cifs_dbg(FYI, "In Create Hard link Unix style\n");
 createHardLinkRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -2898,7 +2899,8 @@ createHardLinkRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
 	if (rc)
-		cFYI(1, "Send error in SetPathInfo (hard link) = %d", rc);
+		cifs_dbg(FYI, "Send error in SetPathInfo (hard link) = %d\n",
+			 rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -2920,7 +2922,7 @@ CIFSCreateHardLink(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 count;
 	int remap = cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR;
 
-	cFYI(1, "In CIFSCreateHardLink");
+	cifs_dbg(FYI, "In CIFSCreateHardLink\n");
 winCreateHardLinkRetry:
 
 	rc = smb_init(SMB_COM_NT_RENAME, 4, tcon, (void **) &pSMB,
@@ -2972,7 +2974,7 @@ winCreateHardLinkRetry:
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_hardlinks);
 	if (rc)
-		cFYI(1, "Send error in hard link (NT rename) = %d", rc);
+		cifs_dbg(FYI, "Send error in hard link (NT rename) = %d\n", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -2995,7 +2997,7 @@ CIFSSMBUnixQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 params, byte_count;
 	char *data_start;
 
-	cFYI(1, "In QPathSymLinkInfo (Unix) for path %s", searchName);
+	cifs_dbg(FYI, "In QPathSymLinkInfo (Unix) for path %s\n", searchName);
 
 querySymLinkRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -3042,7 +3044,7 @@ querySymLinkRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QuerySymLinkInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QuerySymLinkInfo = %d\n", rc);
 	} else {
 		/* decode response */
 
@@ -3097,7 +3099,8 @@ CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb_com_transaction_ioctl_req *pSMB;
 	struct smb_com_transaction_ioctl_rsp *pSMBr;
 
-	cFYI(1, "In Windows reparse style QueryLink for path %s", searchName);
+	cifs_dbg(FYI, "In Windows reparse style QueryLink for path %s\n",
+		 searchName);
 	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
 	if (rc)
@@ -3125,7 +3128,7 @@ CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QueryReparseLinkInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QueryReparseLinkInfo = %d\n", rc);
 	} else {		/* decode response */
 		__u32 data_offset = le32_to_cpu(pSMBr->DataOffset);
 		__u32 data_count = le32_to_cpu(pSMBr->DataCount);
@@ -3149,7 +3152,7 @@ CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			if ((reparse_buf->LinkNamesBuf +
 				reparse_buf->TargetNameOffset +
 				reparse_buf->TargetNameLen) > end_of_smb) {
-				cFYI(1, "reparse buf beyond SMB");
+				cifs_dbg(FYI, "reparse buf beyond SMB\n");
 				rc = -EIO;
 				goto qreparse_out;
 			}
@@ -3170,12 +3173,11 @@ CIFSSMBQueryReparseLinkInfo(const unsigned int xid, struct cifs_tcon *tcon,
 			}
 		} else {
 			rc = -EIO;
-			cFYI(1, "Invalid return data count on "
-				 "get reparse info ioctl");
+			cifs_dbg(FYI, "Invalid return data count on get reparse info ioctl\n");
 		}
 		symlinkinfo[buflen] = 0; /* just in case so the caller
 					does not go off the end of the buffer */
-		cFYI(1, "readlink result - %s", symlinkinfo);
+		cifs_dbg(FYI, "readlink result - %s\n", symlinkinfo);
 	}
 
 qreparse_out:
@@ -3198,7 +3200,10 @@ static void cifs_convert_ace(posix_acl_xattr_entry *ace,
 	ace->e_perm = cpu_to_le16(cifs_ace->cifs_e_perm);
 	ace->e_tag  = cpu_to_le16(cifs_ace->cifs_e_tag);
 	ace->e_id   = cpu_to_le32(le64_to_cpu(cifs_ace->cifs_uid));
-	/* cFYI(1, "perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id); */
+/*
+	cifs_dbg(FYI, "perm %d tag %d id %d\n",
+		 ace->e_perm, ace->e_tag, ace->e_id);
+*/
 
 	return;
 }
@@ -3224,8 +3229,8 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
 		size += sizeof(struct cifs_posix_ace) * count;
 		/* check if we would go beyond end of SMB */
 		if (size_of_data_area < size) {
-			cFYI(1, "bad CIFS POSIX ACL size %d vs. %d",
-				size_of_data_area, size);
+			cifs_dbg(FYI, "bad CIFS POSIX ACL size %d vs. %d\n",
+				 size_of_data_area, size);
 			return -EINVAL;
 		}
 	} else if (acl_type & ACL_TYPE_DEFAULT) {
@@ -3272,7 +3277,10 @@ static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
 		cifs_ace->cifs_uid = cpu_to_le64(-1);
 	} else
 		cifs_ace->cifs_uid = cpu_to_le64(le32_to_cpu(local_ace->e_id));
-	/*cFYI(1, "perm %d tag %d id %d",ace->e_perm,ace->e_tag,ace->e_id);*/
+/*
+	cifs_dbg(FYI, "perm %d tag %d id %d\n",
+		 ace->e_perm, ace->e_tag, ace->e_id);
+*/
 	return rc;
 }
 
@@ -3290,12 +3298,11 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 		return 0;
 
 	count = posix_acl_xattr_count((size_t)buflen);
-	cFYI(1, "setting acl with %d entries from buf of length %d and "
-		"version of %d",
-		count, buflen, le32_to_cpu(local_acl->a_version));
+	cifs_dbg(FYI, "setting acl with %d entries from buf of length %d and version of %d\n",
+		 count, buflen, le32_to_cpu(local_acl->a_version));
 	if (le32_to_cpu(local_acl->a_version) != 2) {
-		cFYI(1, "unknown POSIX ACL version %d",
-		     le32_to_cpu(local_acl->a_version));
+		cifs_dbg(FYI, "unknown POSIX ACL version %d\n",
+			 le32_to_cpu(local_acl->a_version));
 		return 0;
 	}
 	cifs_acl->version = cpu_to_le16(1);
@@ -3304,7 +3311,7 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 	else if (acl_type == ACL_TYPE_DEFAULT)
 		cifs_acl->default_entry_count = cpu_to_le16(count);
 	else {
-		cFYI(1, "unknown ACL type %d", acl_type);
+		cifs_dbg(FYI, "unknown ACL type %d\n", acl_type);
 		return 0;
 	}
 	for (i = 0; i < count; i++) {
@@ -3337,7 +3344,7 @@ CIFSSMBGetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, "In GetPosixACL (Unix) for path %s", searchName);
+	cifs_dbg(FYI, "In GetPosixACL (Unix) for path %s\n", searchName);
 
 queryAclRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -3390,7 +3397,7 @@ queryAclRetry:
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
 	if (rc) {
-		cFYI(1, "Send error in Query POSIX ACL = %d", rc);
+		cifs_dbg(FYI, "Send error in Query POSIX ACL = %d\n", rc);
 	} else {
 		/* decode response */
 
@@ -3427,7 +3434,7 @@ CIFSSMBSetPosixACL(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
 
-	cFYI(1, "In SetPosixACL (Unix) for path %s", fileName);
+	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3482,7 +3489,7 @@ setAclRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "Set POSIX ACL returned %d", rc);
+		cifs_dbg(FYI, "Set POSIX ACL returned %d\n", rc);
 
 setACLerrorExit:
 	cifs_buf_release(pSMB);
@@ -3502,7 +3509,7 @@ CIFSGetExtAttr(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	__u16 params, byte_count;
 
-	cFYI(1, "In GetExtAttr");
+	cifs_dbg(FYI, "In GetExtAttr\n");
 	if (tcon == NULL)
 		return -ENODEV;
 
@@ -3541,7 +3548,7 @@ GetExtAttrRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "error %d in GetExtAttr", rc);
+		cifs_dbg(FYI, "error %d in GetExtAttr\n", rc);
 	} else {
 		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -3556,7 +3563,7 @@ GetExtAttrRetry:
 			struct file_chattr_info *pfinfo;
 			/* BB Do we need a cast or hash here ? */
 			if (count != 16) {
-				cFYI(1, "Illegal size ret in GetExtAttr");
+				cifs_dbg(FYI, "Illegal size ret in GetExtAttr\n");
 				rc = -EIO;
 				goto GetExtAttrOut;
 			}
@@ -3644,21 +3651,21 @@ validate_ntransact(char *buf, char **ppparm, char **ppdata,
 
 	/* should we also check that parm and data areas do not overlap? */
 	if (*ppparm > end_of_smb) {
-		cFYI(1, "parms start after end of smb");
+		cifs_dbg(FYI, "parms start after end of smb\n");
 		return -EINVAL;
 	} else if (parm_count + *ppparm > end_of_smb) {
-		cFYI(1, "parm end after end of smb");
+		cifs_dbg(FYI, "parm end after end of smb\n");
 		return -EINVAL;
 	} else if (*ppdata > end_of_smb) {
-		cFYI(1, "data starts after end of smb");
+		cifs_dbg(FYI, "data starts after end of smb\n");
 		return -EINVAL;
 	} else if (data_count + *ppdata > end_of_smb) {
-		cFYI(1, "data %p + count %d (%p) past smb end %p start %p",
-			*ppdata, data_count, (data_count + *ppdata),
-			end_of_smb, pSMBr);
+		cifs_dbg(FYI, "data %p + count %d (%p) past smb end %p start %p\n",
+			 *ppdata, data_count, (data_count + *ppdata),
+			 end_of_smb, pSMBr);
 		return -EINVAL;
 	} else if (parm_count + data_count > bcc) {
-		cFYI(1, "parm count and data count larger than SMB");
+		cifs_dbg(FYI, "parm count and data count larger than SMB\n");
 		return -EINVAL;
 	}
 	*pdatalen = data_count;
@@ -3676,7 +3683,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 	QUERY_SEC_DESC_REQ *pSMB;
 	struct kvec iov[1];
 
-	cFYI(1, "GetCifsACL");
+	cifs_dbg(FYI, "GetCifsACL\n");
 
 	*pbuflen = 0;
 	*acl_inf = NULL;
@@ -3701,7 +3708,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 			 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_acl_get);
 	if (rc) {
-		cFYI(1, "Send error in QuerySecDesc = %d", rc);
+		cifs_dbg(FYI, "Send error in QuerySecDesc = %d\n", rc);
 	} else {                /* decode response */
 		__le32 *parm;
 		__u32 parm_len;
@@ -3716,7 +3723,8 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 			goto qsec_out;
 		pSMBr = (struct smb_com_ntransact_rsp *)iov[0].iov_base;
 
-		cFYI(1, "smb %p parm %p data %p", pSMBr, parm, *acl_inf);
+		cifs_dbg(FYI, "smb %p parm %p data %p\n",
+			 pSMBr, parm, *acl_inf);
 
 		if (le32_to_cpu(pSMBr->ParameterCount) != 4) {
 			rc = -EIO;      /* bad smb */
@@ -3728,8 +3736,8 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 
 		acl_len = le32_to_cpu(*parm);
 		if (acl_len != *pbuflen) {
-			cERROR(1, "acl length %d does not match %d",
-				   acl_len, *pbuflen);
+			cifs_dbg(VFS, "acl length %d does not match %d\n",
+				 acl_len, *pbuflen);
 			if (*pbuflen > acl_len)
 				*pbuflen = acl_len;
 		}
@@ -3738,7 +3746,7 @@ CIFSSMBGetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 		   header followed by the smallest SID */
 		if ((*pbuflen < sizeof(struct cifs_ntsd) + 8) ||
 		    (*pbuflen >= 64 * 1024)) {
-			cERROR(1, "bad acl length %d", *pbuflen);
+			cifs_dbg(VFS, "bad acl length %d\n", *pbuflen);
 			rc = -EINVAL;
 			*pbuflen = 0;
 		} else {
@@ -3809,9 +3817,10 @@ setCifsAclRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 
-	cFYI(1, "SetCIFSACL bytes_returned: %d, rc: %d", bytes_returned, rc);
+	cifs_dbg(FYI, "SetCIFSACL bytes_returned: %d, rc: %d\n",
+		 bytes_returned, rc);
 	if (rc)
-		cFYI(1, "Set CIFS ACL returned %d", rc);
+		cifs_dbg(FYI, "Set CIFS ACL returned %d\n", rc);
 	cifs_buf_release(pSMB);
 
 	if (rc == -EAGAIN)
@@ -3835,7 +3844,7 @@ SMBQueryInformation(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, "In SMBQPath path %s", search_name);
+	cifs_dbg(FYI, "In SMBQPath path %s\n", search_name);
 QInfRetry:
 	rc = smb_init(SMB_COM_QUERY_INFORMATION, 0, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -3862,7 +3871,7 @@ QInfRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QueryInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QueryInfo = %d\n", rc);
 	} else if (data) {
 		struct timespec ts;
 		__u32 time = le32_to_cpu(pSMBr->last_write_time);
@@ -3936,7 +3945,7 @@ QFileInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QPathInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -3973,7 +3982,7 @@ CIFSSMBQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	/* cFYI(1, "In QPathInfo path %s", search_name); */
+	/* cifs_dbg(FYI, "In QPathInfo path %s\n", search_name); */
 QPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4023,7 +4032,7 @@ QPathInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QPathInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4104,14 +4113,12 @@ UnixQFileInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QPathInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response. "
-				   "Unix Extensions can be disabled on mount "
-				   "by specifying the nosfu mount option.");
+			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4143,7 +4150,7 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, "In QPathInfo (Unix) the path %s", searchName);
+	cifs_dbg(FYI, "In QPathInfo (Unix) the path %s\n", searchName);
 UnixQPathInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4190,14 +4197,12 @@ UnixQPathInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QPathInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QPathInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
 		if (rc || get_bcc(&pSMBr->hdr) < sizeof(FILE_UNIX_BASIC_INFO)) {
-			cERROR(1, "Malformed FILE_UNIX_BASIC_INFO response. "
-				   "Unix Extensions can be disabled on mount "
-				   "by specifying the nosfu mount option.");
+			cifs_dbg(VFS, "Malformed FILE_UNIX_BASIC_INFO response. Unix Extensions can be disabled on mount by specifying the nosfu mount option.\n");
 			rc = -EIO;	/* bad smb */
 		} else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
@@ -4231,7 +4236,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 params, byte_count;
 	struct nls_table *nls_codepage;
 
-	cFYI(1, "In FindFirst for %s", searchName);
+	cifs_dbg(FYI, "In FindFirst for %s\n", searchName);
 
 findFirstRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -4314,7 +4319,7 @@ findFirstRetry:
 	if (rc) {/* BB add logic to retry regular search if Unix search
 			rejected unexpectedly by server */
 		/* BB Add code to handle unsupported level rc */
-		cFYI(1, "Error in FindFirst = %d", rc);
+		cifs_dbg(FYI, "Error in FindFirst = %d\n", rc);
 
 		cifs_buf_release(pSMB);
 
@@ -4352,7 +4357,7 @@ findFirstRetry:
 				psrch_inf->entries_in_buffer;
 			lnoff = le16_to_cpu(parms->LastNameOffset);
 			if (CIFSMaxBufSize < lnoff) {
-				cERROR(1, "ignoring corrupt resume name");
+				cifs_dbg(VFS, "ignoring corrupt resume name\n");
 				psrch_inf->last_entry = NULL;
 				return rc;
 			}
@@ -4383,7 +4388,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int name_len;
 	__u16 params, byte_count;
 
-	cFYI(1, "In FindNext");
+	cifs_dbg(FYI, "In FindNext\n");
 
 	if (psrch_inf->endOfSearch)
 		return -ENOENT;
@@ -4444,7 +4449,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 			cifs_buf_release(pSMB);
 			rc = 0; /* search probably was closed at end of search*/
 		} else
-			cFYI(1, "FindNext returned = %d", rc);
+			cifs_dbg(FYI, "FindNext returned = %d\n", rc);
 	} else {                /* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4479,15 +4484,15 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 				psrch_inf->entries_in_buffer;
 			lnoff = le16_to_cpu(parms->LastNameOffset);
 			if (CIFSMaxBufSize < lnoff) {
-				cERROR(1, "ignoring corrupt resume name");
+				cifs_dbg(VFS, "ignoring corrupt resume name\n");
 				psrch_inf->last_entry = NULL;
 				return rc;
 			} else
 				psrch_inf->last_entry =
 					psrch_inf->srch_entries_start + lnoff;
 
-/*  cFYI(1, "fnxt2 entries in buf %d index_of_last %d",
-	    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry); */
+/*  cifs_dbg(FYI, "fnxt2 entries in buf %d index_of_last %d\n",
+    psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry); */
 
 			/* BB fixme add unlock here */
 		}
@@ -4512,7 +4517,7 @@ CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	FINDCLOSE_REQ *pSMB = NULL;
 
-	cFYI(1, "In CIFSSMBFindClose");
+	cifs_dbg(FYI, "In CIFSSMBFindClose\n");
 	rc = small_smb_init(SMB_COM_FIND_CLOSE2, 1, tcon, (void **)&pSMB);
 
 	/* no sense returning error if session restarted
@@ -4526,7 +4531,7 @@ CIFSFindClose(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->ByteCount = 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
-		cERROR(1, "Send error in FindClose = %d", rc);
+		cifs_dbg(VFS, "Send error in FindClose = %d\n", rc);
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_fclose);
 
@@ -4548,7 +4553,7 @@ CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 	int name_len, bytes_returned;
 	__u16 params, byte_count;
 
-	cFYI(1, "In GetSrvInodeNum for %s", search_name);
+	cifs_dbg(FYI, "In GetSrvInodeNum for %s\n", search_name);
 	if (tcon == NULL)
 		return -ENODEV;
 
@@ -4599,7 +4604,7 @@ GetInodeNumberRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "error %d in QueryInternalInfo", rc);
+		cifs_dbg(FYI, "error %d in QueryInternalInfo\n", rc);
 	} else {
 		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -4614,7 +4619,7 @@ GetInodeNumberRetry:
 			struct file_internal_info *pfinfo;
 			/* BB Do we need a cast or hash here ? */
 			if (count < 8) {
-				cFYI(1, "Illegal size ret in QryIntrnlInf");
+				cifs_dbg(FYI, "Illegal size ret in QryIntrnlInf\n");
 				rc = -EIO;
 				goto GetInodeNumOut;
 			}
@@ -4655,16 +4660,16 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	*num_of_nodes = le16_to_cpu(pSMBr->NumberOfReferrals);
 
 	if (*num_of_nodes < 1) {
-		cERROR(1, "num_referrals: must be at least > 0,"
-			"but we get num_referrals = %d", *num_of_nodes);
+		cifs_dbg(VFS, "num_referrals: must be at least > 0, but we get num_referrals = %d\n",
+			 *num_of_nodes);
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
 
 	ref = (struct dfs_referral_level_3 *) &(pSMBr->referrals);
 	if (ref->VersionNumber != cpu_to_le16(3)) {
-		cERROR(1, "Referrals of V%d version are not supported,"
-			"should be V3", le16_to_cpu(ref->VersionNumber));
+		cifs_dbg(VFS, "Referrals of V%d version are not supported, should be V3\n",
+			 le16_to_cpu(ref->VersionNumber));
 		rc = -EINVAL;
 		goto parse_DFS_referrals_exit;
 	}
@@ -4673,14 +4678,12 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 	data_end = (char *)(&(pSMBr->PathConsumed)) +
 				le16_to_cpu(pSMBr->t2.DataCount);
 
-	cFYI(1, "num_referrals: %d dfs flags: 0x%x ...",
-			*num_of_nodes,
-			le32_to_cpu(pSMBr->DFSFlags));
+	cifs_dbg(FYI, "num_referrals: %d dfs flags: 0x%x ...\n",
+		 *num_of_nodes, le32_to_cpu(pSMBr->DFSFlags));
 
-	*target_nodes = kzalloc(sizeof(struct dfs_info3_param) *
-			*num_of_nodes, GFP_KERNEL);
+	*target_nodes = kcalloc(*num_of_nodes, sizeof(struct dfs_info3_param),
+				GFP_KERNEL);
 	if (*target_nodes == NULL) {
-		cERROR(1, "Failed to allocate buffer for target_nodes");
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
@@ -4759,7 +4762,7 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 	*num_of_nodes = 0;
 	*target_nodes = NULL;
 
-	cFYI(1, "In GetDFSRefer the path %s", search_name);
+	cifs_dbg(FYI, "In GetDFSRefer the path %s\n", search_name);
 	if (ses == NULL)
 		return -ENODEV;
 getDFSRetry:
@@ -4827,7 +4830,7 @@ getDFSRetry:
 	rc = SendReceive(xid, ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in GetDFSRefer = %d", rc);
+		cifs_dbg(FYI, "Send error in GetDFSRefer = %d\n", rc);
 		goto GetDFSRefExit;
 	}
 	rc = validate_t2((struct smb_t2_rsp *)pSMBr);
@@ -4838,9 +4841,8 @@ getDFSRetry:
 		goto GetDFSRefExit;
 	}
 
-	cFYI(1, "Decoding GetDFSRefer response BCC: %d  Offset %d",
-				get_bcc(&pSMBr->hdr),
-				le16_to_cpu(pSMBr->t2.DataOffset));
+	cifs_dbg(FYI, "Decoding GetDFSRefer response BCC: %d  Offset %d\n",
+		 get_bcc(&pSMBr->hdr), le16_to_cpu(pSMBr->t2.DataOffset));
 
 	/* parse returned result into more usable form */
 	rc = parse_DFS_referrals(pSMBr, num_of_nodes,
@@ -4869,7 +4871,7 @@ SMBOldQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, "OldQFSInfo");
+	cifs_dbg(FYI, "OldQFSInfo\n");
 oldQFSInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		(void **) &pSMBr);
@@ -4902,7 +4904,7 @@ oldQFSInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 		(struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QFSInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {                /* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -4910,7 +4912,7 @@ oldQFSInfoRetry:
 			rc = -EIO;      /* bad smb */
 		else {
 			__u16 data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
-			cFYI(1, "qfsinf resp BCC: %d  Offset %d",
+			cifs_dbg(FYI, "qfsinf resp BCC: %d  Offset %d\n",
 				 get_bcc(&pSMBr->hdr), data_offset);
 
 			response_data = (FILE_SYSTEM_ALLOC_INFO *)
@@ -4923,10 +4925,10 @@ oldQFSInfoRetry:
 			       le32_to_cpu(response_data->TotalAllocationUnits);
 			FSData->f_bfree = FSData->f_bavail =
 				le32_to_cpu(response_data->FreeAllocationUnits);
-			cFYI(1, "Blocks: %lld  Free: %lld Block size %ld",
-			     (unsigned long long)FSData->f_blocks,
-			     (unsigned long long)FSData->f_bfree,
-			     FSData->f_bsize);
+			cifs_dbg(FYI, "Blocks: %lld  Free: %lld Block size %ld\n",
+				 (unsigned long long)FSData->f_blocks,
+				 (unsigned long long)FSData->f_bfree,
+				 FSData->f_bsize);
 		}
 	}
 	cifs_buf_release(pSMB);
@@ -4949,7 +4951,7 @@ CIFSSMBQFSInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, "In QFSInfo");
+	cifs_dbg(FYI, "In QFSInfo\n");
 QFSInfoRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -4982,7 +4984,7 @@ QFSInfoRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QFSInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QFSInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5003,10 +5005,10 @@ QFSInfoRetry:
 			    le64_to_cpu(response_data->TotalAllocationUnits);
 			FSData->f_bfree = FSData->f_bavail =
 			    le64_to_cpu(response_data->FreeAllocationUnits);
-			cFYI(1, "Blocks: %lld  Free: %lld Block size %ld",
-			     (unsigned long long)FSData->f_blocks,
-			     (unsigned long long)FSData->f_bfree,
-			     FSData->f_bsize);
+			cifs_dbg(FYI, "Blocks: %lld  Free: %lld Block size %ld\n",
+				 (unsigned long long)FSData->f_blocks,
+				 (unsigned long long)FSData->f_bfree,
+				 FSData->f_bsize);
 		}
 	}
 	cifs_buf_release(pSMB);
@@ -5028,7 +5030,7 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, "In QFSAttributeInfo");
+	cifs_dbg(FYI, "In QFSAttributeInfo\n");
 QFSAttributeRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5062,7 +5064,7 @@ QFSAttributeRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, "Send error in QFSAttributeInfo = %d", rc);
+		cifs_dbg(VFS, "Send error in QFSAttributeInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5098,7 +5100,7 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, "In QFSDeviceInfo");
+	cifs_dbg(FYI, "In QFSDeviceInfo\n");
 QFSDeviceRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5133,7 +5135,7 @@ QFSDeviceRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QFSDeviceInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QFSDeviceInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5169,7 +5171,7 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon)
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, "In QFSUnixInfo");
+	cifs_dbg(FYI, "In QFSUnixInfo\n");
 QFSUnixRetry:
 	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, tcon,
 				   (void **) &pSMB, (void **) &pSMBr);
@@ -5203,7 +5205,7 @@ QFSUnixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, "Send error in QFSUnixInfo = %d", rc);
+		cifs_dbg(VFS, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5238,7 +5240,7 @@ CIFSSMBSetFSUnixInfo(const unsigned int xid, struct cifs_tcon *tcon, __u64 cap)
 	int bytes_returned = 0;
 	__u16 params, param_offset, offset, byte_count;
 
-	cFYI(1, "In SETFSUnixInfo");
+	cifs_dbg(FYI, "In SETFSUnixInfo\n");
 SETFSUnixRetry:
 	/* BB switch to small buf init to save memory */
 	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, tcon,
@@ -5286,7 +5288,7 @@ SETFSUnixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cERROR(1, "Send error in SETFSUnixInfo = %d", rc);
+		cifs_dbg(VFS, "Send error in SETFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 		if (rc)
@@ -5314,7 +5316,7 @@ CIFSSMBQFSPosixInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, byte_count;
 
-	cFYI(1, "In QFSPosixInfo");
+	cifs_dbg(FYI, "In QFSPosixInfo\n");
 QFSPosixRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5348,7 +5350,7 @@ QFSPosixRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QFSUnixInfo = %d", rc);
+		cifs_dbg(FYI, "Send error in QFSUnixInfo = %d\n", rc);
 	} else {		/* decode response */
 		rc = validate_t2((struct smb_t2_rsp *)pSMBr);
 
@@ -5410,7 +5412,7 @@ CIFSSMBSetEOF(const unsigned int xid, struct cifs_tcon *tcon,
 
 	__u16 params, byte_count, data_count, param_offset, offset;
 
-	cFYI(1, "In SetEOF");
+	cifs_dbg(FYI, "In SetEOF\n");
 SetEOFRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5476,7 +5478,7 @@ SetEOFRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "SetPathInfo (file size) returned %d", rc);
+		cifs_dbg(FYI, "SetPathInfo (file size) returned %d\n", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -5495,8 +5497,8 @@ CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, "SetFileSize (via SetFileInfo) %lld",
-			(long long)size);
+	cifs_dbg(FYI, "SetFileSize (via SetFileInfo) %lld\n",
+		 (long long)size);
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -5553,7 +5555,8 @@ CIFSSMBSetFileSize(const unsigned int xid, struct cifs_tcon *tcon,
 	pSMB->ByteCount = cpu_to_le16(byte_count);
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc) {
-		cFYI(1, "Send error in SetFileInfo (SetFileSize) = %d", rc);
+		cifs_dbg(FYI, "Send error in SetFileInfo (SetFileSize) = %d\n",
+			 rc);
 	}
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
@@ -5577,7 +5580,7 @@ CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, "Set Times (via SetFileInfo)");
+	cifs_dbg(FYI, "Set Times (via SetFileInfo)\n");
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -5623,7 +5626,8 @@ CIFSSMBSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
-		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
+		cifs_dbg(FYI, "Send error in Set Time (SetFileInfo) = %d\n",
+			 rc);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 		since file handle passed in no longer valid */
@@ -5640,7 +5644,7 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, "Set File Disposition (via SetFileInfo)");
+	cifs_dbg(FYI, "Set File Disposition (via SetFileInfo)\n");
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -5682,7 +5686,7 @@ CIFSSMBSetFileDisposition(const unsigned int xid, struct cifs_tcon *tcon,
 	*data_offset = delete_file ? 1 : 0;
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
-		cFYI(1, "Send error in SetFileDisposition = %d", rc);
+		cifs_dbg(FYI, "Send error in SetFileDisposition = %d\n", rc);
 
 	return rc;
 }
@@ -5700,7 +5704,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	char *data_offset;
 	__u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, "In SetTimes");
+	cifs_dbg(FYI, "In SetTimes\n");
 
 SetTimesRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
@@ -5756,7 +5760,7 @@ SetTimesRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "SetPathInfo (times) returned %d", rc);
+		cifs_dbg(FYI, "SetPathInfo (times) returned %d\n", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -5781,7 +5785,7 @@ CIFSSMBSetAttrLegacy(unsigned int xid, struct cifs_tcon *tcon, char *fileName,
 	int bytes_returned;
 	int name_len;
 
-	cFYI(1, "In SetAttrLegacy");
+	cifs_dbg(FYI, "In SetAttrLegacy\n");
 
 SetAttrLgcyRetry:
 	rc = smb_init(SMB_COM_SETATTR, 8, tcon, (void **) &pSMB,
@@ -5807,7 +5811,7 @@ SetAttrLgcyRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "Error in LegacySetAttr = %d", rc);
+		cifs_dbg(FYI, "Error in LegacySetAttr = %d\n", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -5875,7 +5879,7 @@ CIFSSMBUnixSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	u16 params, param_offset, offset, byte_count, count;
 
-	cFYI(1, "Set Unix Info (via SetFileInfo)");
+	cifs_dbg(FYI, "Set Unix Info (via SetFileInfo)\n");
 	rc = small_smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB);
 
 	if (rc)
@@ -5921,7 +5925,8 @@ CIFSSMBUnixSetFileInfo(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
-		cFYI(1, "Send error in Set Time (SetFileInfo) = %d", rc);
+		cifs_dbg(FYI, "Send error in Set Time (SetFileInfo) = %d\n",
+			 rc);
 
 	/* Note: On -EAGAIN error only caller can retry on handle based calls
 		since file handle passed in no longer valid */
@@ -5943,7 +5948,7 @@ CIFSSMBUnixSetPathInfo(const unsigned int xid, struct cifs_tcon *tcon,
 	FILE_UNIX_BASIC_INFO *data_offset;
 	__u16 params, param_offset, offset, count, byte_count;
 
-	cFYI(1, "In SetUID/GID/Mode");
+	cifs_dbg(FYI, "In SetUID/GID/Mode\n");
 setPermsRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -5999,7 +6004,7 @@ setPermsRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "SetPathInfo (perms) returned %d", rc);
+		cifs_dbg(FYI, "SetPathInfo (perms) returned %d\n", rc);
 
 	cifs_buf_release(pSMB);
 	if (rc == -EAGAIN)
@@ -6036,7 +6041,7 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
 	__u16 params, byte_count, data_offset;
 	unsigned int ea_name_len = ea_name ? strlen(ea_name) : 0;
 
-	cFYI(1, "In Query All EAs path %s", searchName);
+	cifs_dbg(FYI, "In Query All EAs path %s\n", searchName);
 QAllEAsRetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -6083,7 +6088,7 @@ QAllEAsRetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc) {
-		cFYI(1, "Send error in QueryAllEAs = %d", rc);
+		cifs_dbg(FYI, "Send error in QueryAllEAs = %d\n", rc);
 		goto QAllEAsOut;
 	}
 
@@ -6111,16 +6116,16 @@ QAllEAsRetry:
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);
 
 	list_len = le32_to_cpu(ea_response_data->list_len);
-	cFYI(1, "ea length %d", list_len);
+	cifs_dbg(FYI, "ea length %d\n", list_len);
 	if (list_len <= 8) {
-		cFYI(1, "empty EA list returned from server");
+		cifs_dbg(FYI, "empty EA list returned from server\n");
 		goto QAllEAsOut;
 	}
 
 	/* make sure list_len doesn't go past end of SMB */
 	end_of_smb = (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);
 	if ((char *)ea_response_data + list_len > end_of_smb) {
-		cFYI(1, "EA list appears to go beyond SMB");
+		cifs_dbg(FYI, "EA list appears to go beyond SMB\n");
 		rc = -EIO;
 		goto QAllEAsOut;
 	}
@@ -6137,7 +6142,7 @@ QAllEAsRetry:
 		temp_ptr += 4;
 		/* make sure we can read name_len and value_len */
 		if (list_len < 0) {
-			cFYI(1, "EA entry goes beyond length of list");
+			cifs_dbg(FYI, "EA entry goes beyond length of list\n");
 			rc = -EIO;
 			goto QAllEAsOut;
 		}
@@ -6146,7 +6151,7 @@ QAllEAsRetry:
 		value_len = le16_to_cpu(temp_fea->value_len);
 		list_len -= name_len + 1 + value_len;
 		if (list_len < 0) {
-			cFYI(1, "EA entry goes beyond length of list");
+			cifs_dbg(FYI, "EA entry goes beyond length of list\n");
 			rc = -EIO;
 			goto QAllEAsOut;
 		}
@@ -6214,7 +6219,7 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	int bytes_returned = 0;
 	__u16 params, param_offset, byte_count, offset, count;
 
-	cFYI(1, "In SetEA");
+	cifs_dbg(FYI, "In SetEA\n");
 SetEARetry:
 	rc = smb_init(SMB_COM_TRANSACTION2, 15, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
@@ -6296,7 +6301,7 @@ SetEARetry:
 	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
 			 (struct smb_hdr *) pSMBr, &bytes_returned, 0);
 	if (rc)
-		cFYI(1, "SetPathInfo (EA) returned %d", rc);
+		cifs_dbg(FYI, "SetPathInfo (EA) returned %d\n", rc);
 
 	cifs_buf_release(pSMB);
 
@@ -6339,7 +6344,7 @@ int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
 	struct dir_notify_req *dnotify_req;
 	int bytes_returned;
 
-	cFYI(1, "In CIFSSMBNotify for file handle %d", (int)netfid);
+	cifs_dbg(FYI, "In CIFSSMBNotify for file handle %d\n", (int)netfid);
 	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
 		      (void **) &pSMBr);
 	if (rc)
@@ -6368,7 +6373,7 @@ int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
 			 (struct smb_hdr *)pSMBr, &bytes_returned,
 			 CIFS_ASYNC_OP);
 	if (rc) {
-		cFYI(1, "Error in Notify = %d", rc);
+		cifs_dbg(FYI, "Error in Notify = %d\n", rc);
 	} else {
 		/* Add file to outstanding requests */
 		/* BB change to kmem cache alloc */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 991c63c..8cac0ba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -318,11 +318,12 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	server->max_read = 0;
 #endif
 
-	cFYI(1, "Reconnecting tcp session");
+	cifs_dbg(FYI, "Reconnecting tcp session\n");
 
 	/* before reconnecting the tcp session, mark the smb session (uid)
 		and the tid bad so they are not used until reconnected */
-	cFYI(1, "%s: marking sessions and tcons for reconnect", __func__);
+	cifs_dbg(FYI, "%s: marking sessions and tcons for reconnect\n",
+		 __func__);
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
@@ -336,15 +337,14 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* do not want to be sending data on a socket we are freeing */
-	cFYI(1, "%s: tearing down socket", __func__);
+	cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
 	mutex_lock(&server->srv_mutex);
 	if (server->ssocket) {
-		cFYI(1, "State: 0x%x Flags: 0x%lx", server->ssocket->state,
-			server->ssocket->flags);
+		cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
+			 server->ssocket->state, server->ssocket->flags);
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
-		cFYI(1, "Post shutdown state: 0x%x Flags: 0x%lx",
-			server->ssocket->state,
-			server->ssocket->flags);
+		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
+			 server->ssocket->state, server->ssocket->flags);
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	}
@@ -358,7 +358,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 
 	/* mark submitted MIDs for retry and issue callback */
 	INIT_LIST_HEAD(&retry_list);
-	cFYI(1, "%s: moving mids to private list", __func__);
+	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
@@ -368,7 +368,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	}
 	spin_unlock(&GlobalMid_Lock);
 
-	cFYI(1, "%s: issuing mid callbacks", __func__);
+	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 	list_for_each_safe(tmp, tmp2, &retry_list) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
@@ -381,7 +381,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		/* we should try only the port we connected to before */
 		rc = generic_ip_connect(server);
 		if (rc) {
-			cFYI(1, "reconnect error %d", rc);
+			cifs_dbg(FYI, "reconnect error %d\n", rc);
 			msleep(3000);
 		} else {
 			atomic_inc(&tcpSesReconnectCount);
@@ -415,8 +415,8 @@ cifs_echo_request(struct work_struct *work)
 
 	rc = server->ops->echo ? server->ops->echo(server) : -ENOSYS;
 	if (rc)
-		cFYI(1, "Unable to send echo request to server: %s",
-			server->hostname);
+		cifs_dbg(FYI, "Unable to send echo request to server: %s\n",
+			 server->hostname);
 
 requeue_echo:
 	queue_delayed_work(cifsiod_wq, &server->echo, SMB_ECHO_INTERVAL);
@@ -428,7 +428,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 	if (!server->bigbuf) {
 		server->bigbuf = (char *)cifs_buf_get();
 		if (!server->bigbuf) {
-			cERROR(1, "No memory for large SMB response");
+			cifs_dbg(VFS, "No memory for large SMB response\n");
 			msleep(3000);
 			/* retry will check if exiting */
 			return false;
@@ -441,7 +441,7 @@ allocate_buffers(struct TCP_Server_Info *server)
 	if (!server->smallbuf) {
 		server->smallbuf = (char *)cifs_small_buf_get();
 		if (!server->smallbuf) {
-			cERROR(1, "No memory for SMB response");
+			cifs_dbg(VFS, "No memory for SMB response\n");
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
+		cifs_dbg(VFS, "Server %s has not responded in %d seconds. Reconnecting...\n",
+			 server->hostname, (2 * SMB_ECHO_INTERVAL) / HZ);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
@@ -584,8 +583,8 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			length = 0;
 			continue;
 		} else if (length <= 0) {
-			cFYI(1, "Received no data or error: expecting %d "
-				"got %d", to_read, length);
+			cifs_dbg(FYI, "Received no data or error: expecting %d\n"
+				 "got %d", to_read, length);
 			cifs_reconnect(server);
 			total_read = -EAGAIN;
 			break;
@@ -619,17 +618,17 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		/* Regular SMB response */
 		return true;
 	case RFC1002_SESSION_KEEP_ALIVE:
-		cFYI(1, "RFC 1002 session keep alive");
+		cifs_dbg(FYI, "RFC 1002 session keep alive\n");
 		break;
 	case RFC1002_POSITIVE_SESSION_RESPONSE:
-		cFYI(1, "RFC 1002 positive session response");
+		cifs_dbg(FYI, "RFC 1002 positive session response\n");
 		break;
 	case RFC1002_NEGATIVE_SESSION_RESPONSE:
 		/*
 		 * We get this from Windows 98 instead of an error on
 		 * SMB negprot response.
 		 */
-		cFYI(1, "RFC 1002 negative session response");
+		cifs_dbg(FYI, "RFC 1002 negative session response\n");
 		/* give server a second to clean up */
 		msleep(1000);
 		/*
@@ -643,7 +642,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		wake_up(&server->response_q);
 		break;
 	default:
-		cERROR(1, "RFC 1002 unknown response type 0x%x", type);
+		cifs_dbg(VFS, "RFC 1002 unknown response type 0x%x\n", type);
 		cifs_reconnect(server);
 	}
 
@@ -729,7 +728,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&GlobalMid_Lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Clearing mid 0x%llx", mid_entry->mid);
+			cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
 		}
@@ -738,7 +737,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cFYI(1, "Callback mid 0x%llx", mid_entry->mid);
+			cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
 			mid_entry->callback(mid_entry);
 		}
@@ -755,7 +754,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 * least 45 seconds before giving up on a request getting a
 		 * response and going ahead and killing cifsd.
 		 */
-		cFYI(1, "Wait for exit from demultiplex thread");
+		cifs_dbg(FYI, "Wait for exit from demultiplex thread\n");
 		msleep(46000);
 		/*
 		 * If threads still have not exited they are probably never
@@ -782,8 +781,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* make sure this will fit in a large buffer */
 	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server) - 4) {
-		cERROR(1, "SMB response too long (%u bytes)",
-			pdu_length);
+		cifs_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return -EAGAIN;
@@ -841,7 +839,7 @@ cifs_demultiplex_thread(void *p)
 	struct mid_q_entry *mid_entry;
 
 	current->flags |= PF_MEMALLOC;
-	cFYI(1, "Demultiplex PID: %d", task_pid_nr(current));
+	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
 
 	length = atomic_inc_return(&tcpSesAllocCount);
 	if (length > 1)
@@ -871,14 +869,14 @@ cifs_demultiplex_thread(void *p)
 		 */
 		pdu_length = get_rfc1002_length(buf);
 
-		cFYI(1, "RFC1002 header 0x%x", pdu_length);
+		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
 		if (!is_smb_response(server, buf[0]))
 			continue;
 
 		/* make sure we have enough to get to the MID */
 		if (pdu_length < HEADER_SIZE(server) - 1 - 4) {
-			cERROR(1, "SMB response too short (%u bytes)",
-				pdu_length);
+			cifs_dbg(VFS, "SMB response too short (%u bytes)\n",
+				 pdu_length);
 			cifs_reconnect(server);
 			wake_up(&server->response_q);
 			continue;
@@ -910,8 +908,8 @@ cifs_demultiplex_thread(void *p)
 				mid_entry->callback(mid_entry);
 		} else if (!server->ops->is_oplock_break ||
 			   !server->ops->is_oplock_break(buf, server)) {
-			cERROR(1, "No task to wake, unknown frame received! "
-				   "NumMids %d", atomic_read(&midCount));
+			cifs_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
+				 atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
 				      HEADER_SIZE(server));
 #ifdef CONFIG_CIFS_DEBUG2
@@ -1037,7 +1035,7 @@ static int cifs_parse_security_flavors(char *value,
 		break;
 	case Opt_sec_krb5p:
 		/* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
-		cERROR(1, "Krb5 cifs privacy not supported");
+		cifs_dbg(VFS, "Krb5 cifs privacy not supported\n");
 		break;
 	case Opt_sec_ntlmssp:
 		vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
@@ -1067,7 +1065,7 @@ static int cifs_parse_security_flavors(char *value,
 		vol->nullauth = 1;
 		break;
 	default:
-		cERROR(1, "bad security option: %s", value);
+		cifs_dbg(VFS, "bad security option: %s\n", value);
 		return 1;
 	}
 
@@ -1093,7 +1091,7 @@ cifs_parse_cache_flavor(char *value, struct smb_vol *vol)
 		vol->strict_io = false;
 		break;
 	default:
-		cERROR(1, "bad cache= option: %s", value);
+		cifs_dbg(VFS, "bad cache= option: %s\n", value);
 		return 1;
 	}
 	return 0;
@@ -1124,7 +1122,7 @@ cifs_parse_smb_version(char *value, struct smb_vol *vol)
 		break;
 #endif
 	default:
-		cERROR(1, "Unknown vers= option specified: %s", value);
+		cifs_dbg(VFS, "Unknown vers= option specified: %s\n", value);
 		return 1;
 	}
 	return 0;
@@ -1255,7 +1253,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			separator[0] = options[4];
 			options += 5;
 		} else {
-			cFYI(1, "Null separator not allowed");
+			cifs_dbg(FYI, "Null separator not allowed\n");
 		}
 	}
 	vol->backupuid_specified = false; /* no backup intent for a user */
@@ -1440,8 +1438,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			break;
 		case Opt_fsc:
 #ifndef CONFIG_CIFS_FSCACHE
-			cERROR(1, "FS-Cache support needs CONFIG_CIFS_FSCACHE "
-				  "kernel config option set");
+			cifs_dbg(VFS, "FS-Cache support needs CONFIG_CIFS_FSCACHE kernel config option set\n");
 			goto cifs_parse_mount_err;
 #endif
 			vol->fsc = true;
@@ -1459,55 +1456,55 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		/* Numeric Values */
 		case Opt_backupuid:
 			if (get_option_uid(args, &vol->backupuid)) {
-				cERROR(1, "%s: Invalid backupuid value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid backupuid value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->backupuid_specified = true;
 			break;
 		case Opt_backupgid:
 			if (get_option_gid(args, &vol->backupgid)) {
-				cERROR(1, "%s: Invalid backupgid value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid backupgid value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->backupgid_specified = true;
 			break;
 		case Opt_uid:
 			if (get_option_uid(args, &vol->linux_uid)) {
-				cERROR(1, "%s: Invalid uid value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid uid value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			uid_specified = true;
 			break;
 		case Opt_cruid:
 			if (get_option_uid(args, &vol->cred_uid)) {
-				cERROR(1, "%s: Invalid cruid value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid cruid value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			break;
 		case Opt_gid:
 			if (get_option_gid(args, &vol->linux_gid)) {
-				cERROR(1, "%s: Invalid gid value",
-						__func__);
+				cifs_dbg(VFS, "%s: Invalid gid value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			gid_specified = true;
 			break;
 		case Opt_file_mode:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid file_mode value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid file_mode value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->file_mode = option;
 			break;
 		case Opt_dirmode:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid dir_mode value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid dir_mode value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->dir_mode = option;
@@ -1515,37 +1512,37 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_port:
 			if (get_option_ul(args, &option) ||
 			    option > USHRT_MAX) {
-				cERROR(1, "%s: Invalid port value", __func__);
+				cifs_dbg(VFS, "%s: Invalid port value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			port = (unsigned short)option;
 			break;
 		case Opt_rsize:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid rsize value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid rsize value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->rsize = option;
 			break;
 		case Opt_wsize:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid wsize value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid wsize value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->wsize = option;
 			break;
 		case Opt_actimeo:
 			if (get_option_ul(args, &option)) {
-				cERROR(1, "%s: Invalid actimeo value",
-					__func__);
+				cifs_dbg(VFS, "%s: Invalid actimeo value\n",
+					 __func__);
 				goto cifs_parse_mount_err;
 			}
 			vol->actimeo = HZ * option;
 			if (vol->actimeo > CIFS_MAX_ACTIMEO) {
-				cERROR(1, "CIFS: attribute cache"
-					  "timeout too large");
+				cifs_dbg(VFS, "attribute cache timeout too large\n");
 				goto cifs_parse_mount_err;
 			}
 			break;
@@ -1568,11 +1565,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 			vol->username = kstrdup(string, GFP_KERNEL);
-			if (!vol->username) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for username\n");
+			if (!vol->username)
 				goto cifs_parse_mount_err;
-			}
 			break;
 		case Opt_blank_pass:
 			vol->password = NULL;
@@ -1691,7 +1685,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 						    "for domainname\n");
 				goto cifs_parse_mount_err;
 			}
-			cFYI(1, "Domain name set");
+			cifs_dbg(FYI, "Domain name set\n");
 			break;
 		case Opt_srcaddr:
 			string = match_strdup(args);
@@ -1749,7 +1743,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			/* if iocharset not set then load_nls_default
 			 * is used by caller
 			 */
-			cFYI(1, "iocharset set to %s", string);
+			 cifs_dbg(FYI, "iocharset set to %s\n", string);
 			break;
 		case Opt_netbiosname:
 			string = match_strdup(args);
@@ -1863,20 +1857,18 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 #ifndef CONFIG_KEYS
 	/* Muliuser mounts require CONFIG_KEYS support */
 	if (vol->multiuser) {
-		cERROR(1, "Multiuser mounts require kernels with "
-			  "CONFIG_KEYS enabled.");
+		cifs_dbg(VFS, "Multiuser mounts require kernels with CONFIG_KEYS enabled\n");
 		goto cifs_parse_mount_err;
 	}
 #endif
 	if (!vol->UNC) {
-		cERROR(1, "CIFS mount error: No usable UNC path provided in "
-			  "device string or in unc= option!");
+		cifs_dbg(VFS, "CIFS mount error: No usable UNC path provided in device string or in unc= option!\n");
 		goto cifs_parse_mount_err;
 	}
 
 	/* make sure UNC has a share name */
 	if (!strchr(vol->UNC + 3, '\\')) {
-		cERROR(1, "Malformed UNC. Unable to find share name.");
+		cifs_dbg(VFS, "Malformed UNC. Unable to find share name.\n");
 		goto cifs_parse_mount_err;
 	}
 
@@ -2097,7 +2089,7 @@ cifs_find_tcp_session(struct smb_vol *vol)
 
 		++server->srv_count;
 		spin_unlock(&cifs_tcp_ses_lock);
-		cFYI(1, "Existing tcp session with server found");
+		cifs_dbg(FYI, "Existing tcp session with server found\n");
 		return server;
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -2144,7 +2136,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	struct TCP_Server_Info *tcp_ses = NULL;
 	int rc;
 
-	cFYI(1, "UNC: %s", volume_info->UNC);
+	cifs_dbg(FYI, "UNC: %s\n", volume_info->UNC);
 
 	/* see if we already have a matching tcp_ses */
 	tcp_ses = cifs_find_tcp_session(volume_info);
@@ -2159,7 +2151,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	rc = cifs_crypto_shash_allocate(tcp_ses);
 	if (rc) {
-		cERROR(1, "could not setup hash structures rc %d", rc);
+		cifs_dbg(VFS, "could not setup hash structures rc %d\n", rc);
 		goto out_err;
 	}
 
@@ -2206,7 +2198,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
-		cERROR(1, "Error connecting to socket. Aborting operation");
+		cifs_dbg(VFS, "Error connecting to socket. Aborting operation.\n");
 		goto out_err_crypto_release;
 	}
 
@@ -2219,7 +2211,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 				  tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
 		rc = PTR_ERR(tcp_ses->tsk);
-		cERROR(1, "error %d create cifsd thread", rc);
+		cifs_dbg(VFS, "error %d create cifsd thread\n", rc);
 		module_put(THIS_MODULE);
 		goto out_err_crypto_release;
 	}
@@ -2306,7 +2298,7 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	unsigned int xid;
 	struct TCP_Server_Info *server = ses->server;
 
-	cFYI(1, "%s: ses_count=%d", __func__, ses->ses_count);
+	cifs_dbg(FYI, "%s: ses_count=%d\n", __func__, ses->ses_count);
 	spin_lock(&cifs_tcp_ses_lock);
 	if (--ses->ses_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -2358,23 +2350,24 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 		sprintf(desc, "cifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
 		break;
 	default:
-		cFYI(1, "Bad ss_family (%hu)", server->dstaddr.ss_family);
+		cifs_dbg(FYI, "Bad ss_family (%hu)\n",
+			 server->dstaddr.ss_family);
 		rc = -EINVAL;
 		goto out_err;
 	}
 
-	cFYI(1, "%s: desc=%s", __func__, desc);
+	cifs_dbg(FYI, "%s: desc=%s\n", __func__, desc);
 	key = request_key(&key_type_logon, desc, "");
 	if (IS_ERR(key)) {
 		if (!ses->domainName) {
-			cFYI(1, "domainName is NULL");
+			cifs_dbg(FYI, "domainName is NULL\n");
 			rc = PTR_ERR(key);
 			goto out_err;
 		}
 
 		/* didn't work, try to find a domain key */
 		sprintf(desc, "cifs:d:%s", ses->domainName);
-		cFYI(1, "%s: desc=%s", __func__, desc);
+		cifs_dbg(FYI, "%s: desc=%s\n", __func__, desc);
 		key = request_key(&key_type_logon, desc, "");
 		if (IS_ERR(key)) {
 			rc = PTR_ERR(key);
@@ -2392,32 +2385,34 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	/* find first : in payload */
 	payload = (char *)upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cFYI(1, "payload=%s", payload);
+	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
-		cFYI(1, "Unable to find ':' in payload (datalen=%d)",
-				upayload->datalen);
+		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
+			 upayload->datalen);
 		rc = -EINVAL;
 		goto out_key_put;
 	}
 
 	len = delim - payload;
 	if (len > MAX_USERNAME_SIZE || len <= 0) {
-		cFYI(1, "Bad value from username search (len=%zd)", len);
+		cifs_dbg(FYI, "Bad value from username search (len=%zd)\n",
+			 len);
 		rc = -EINVAL;
 		goto out_key_put;
 	}
 
 	vol->username = kstrndup(payload, len, GFP_KERNEL);
 	if (!vol->username) {
-		cFYI(1, "Unable to allocate %zd bytes for username", len);
+		cifs_dbg(FYI, "Unable to allocate %zd bytes for username\n",
+			 len);
 		rc = -ENOMEM;
 		goto out_key_put;
 	}
-	cFYI(1, "%s: username=%s", __func__, vol->username);
+	cifs_dbg(FYI, "%s: username=%s\n", __func__, vol->username);
 
 	len = key->datalen - (len + 1);
 	if (len > MAX_PASSWORD_SIZE || len <= 0) {
-		cFYI(1, "Bad len for password search (len=%zd)", len);
+		cifs_dbg(FYI, "Bad len for password search (len=%zd)\n", len);
 		rc = -EINVAL;
 		kfree(vol->username);
 		vol->username = NULL;
@@ -2427,7 +2422,8 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	++delim;
 	vol->password = kstrndup(delim, len, GFP_KERNEL);
 	if (!vol->password) {
-		cFYI(1, "Unable to allocate %zd bytes for password", len);
+		cifs_dbg(FYI, "Unable to allocate %zd bytes for password\n",
+			 len);
 		rc = -ENOMEM;
 		kfree(vol->username);
 		vol->username = NULL;
@@ -2439,7 +2435,7 @@ out_key_put:
 	key_put(key);
 out_err:
 	kfree(desc);
-	cFYI(1, "%s: returning %d", __func__, rc);
+	cifs_dbg(FYI, "%s: returning %d\n", __func__, rc);
 	return rc;
 }
 #else /* ! CONFIG_KEYS */
@@ -2464,7 +2460,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 
 	ses = cifs_find_smb_ses(server, volume_info);
 	if (ses) {
-		cFYI(1, "Existing smb sess found (status=%d)", ses->status);
+		cifs_dbg(FYI, "Existing smb sess found (status=%d)\n",
+			 ses->status);
 
 		mutex_lock(&ses->session_mutex);
 		rc = cifs_negotiate_protocol(xid, ses);
@@ -2476,7 +2473,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 			return ERR_PTR(rc);
 		}
 		if (ses->need_reconnect) {
-			cFYI(1, "Session needs reconnect");
+			cifs_dbg(FYI, "Session needs reconnect\n");
 			rc = cifs_setup_session(xid, ses,
 						volume_info->local_nls);
 			if (rc) {
@@ -2495,7 +2492,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 		return ses;
 	}
 
-	cFYI(1, "Existing smb sess not found");
+	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)
 		goto get_ses_fail;
@@ -2585,7 +2582,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	unsigned int xid;
 	struct cifs_ses *ses = tcon->ses;
 
-	cFYI(1, "%s: tc_count=%d", __func__, tcon->tc_count);
+	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
 	if (--tcon->tc_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -2613,12 +2610,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 
 	tcon = cifs_find_tcon(ses, volume_info->UNC);
 	if (tcon) {
-		cFYI(1, "Found match on UNC path");
+		cifs_dbg(FYI, "Found match on UNC path\n");
 		/* existing tcon already has a reference */
 		cifs_put_smb_ses(ses);
 		if (tcon->seal != volume_info->seal)
-			cERROR(1, "transport encryption setting "
-				   "conflicts with existing tid");
+			cifs_dbg(VFS, "transport encryption setting conflicts with existing tid\n");
 		return tcon;
 	}
 
@@ -2650,13 +2646,13 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	rc = ses->server->ops->tree_connect(xid, ses, volume_info->UNC, tcon,
 					    volume_info->local_nls);
 	free_xid(xid);
-	cFYI(1, "Tcon rc = %d", rc);
+	cifs_dbg(FYI, "Tcon rc = %d\n", rc);
 	if (rc)
 		goto out_fail;
 
 	if (volume_info->nodfs) {
 		tcon->Flags &= ~SMB_SHARE_IS_IN_DFS;
-		cFYI(1, "DFS disabled (%d)", tcon->Flags);
+		cifs_dbg(FYI, "DFS disabled (%d)\n", tcon->Flags);
 	}
 	tcon->seal = volume_info->seal;
 	/*
@@ -2810,7 +2806,7 @@ get_dfs_path(const unsigned int xid, struct cifs_ses *ses, const char *old_path,
 		strcpy(temp_unc + 2 + strlen(ses->serverName), "\\IPC$");
 		rc = ses->server->ops->tree_connect(xid, ses, temp_unc, NULL,
 						    nls_codepage);
-		cFYI(1, "Tcon rc = %d ipc_tid = %d", rc, ses->ipc_tid);
+		cifs_dbg(FYI, "Tcon rc = %d ipc_tid = %d\n", rc, ses->ipc_tid);
 		kfree(temp_unc);
 	}
 	if (rc == 0)
@@ -2888,13 +2884,11 @@ bind_socket(struct TCP_Server_Info *server)
 			saddr4 = (struct sockaddr_in *)&server->srcaddr;
 			saddr6 = (struct sockaddr_in6 *)&server->srcaddr;
 			if (saddr6->sin6_family == AF_INET6)
-				cERROR(1, "cifs: "
-				       "Failed to bind to: %pI6c, error: %d",
-				       &saddr6->sin6_addr, rc);
+				cifs_dbg(VFS, "Failed to bind to: %pI6c, error: %d\n",
+					 &saddr6->sin6_addr, rc);
 			else
-				cERROR(1, "cifs: "
-				       "Failed to bind to: %pI4, error: %d",
-				       &saddr4->sin_addr.s_addr, rc);
+				cifs_dbg(VFS, "Failed to bind to: %pI4, error: %d\n",
+					 &saddr4->sin_addr.s_addr, rc);
 		}
 	}
 	return rc;
@@ -2999,13 +2993,13 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		rc = __sock_create(cifs_net_ns(server), sfamily, SOCK_STREAM,
 				   IPPROTO_TCP, &socket, 1);
 		if (rc < 0) {
-			cERROR(1, "Error %d creating socket", rc);
+			cifs_dbg(VFS, "Error %d creating socket\n", rc);
 			server->ssocket = NULL;
 			return rc;
 		}
 
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
-		cFYI(1, "Socket created");
+		cifs_dbg(FYI, "Socket created\n");
 		server->ssocket = socket;
 		socket->sk->sk_allocation = GFP_NOFS;
 		if (sfamily == AF_INET6)
@@ -3039,16 +3033,17 @@ generic_ip_connect(struct TCP_Server_Info *server)
 		rc = kernel_setsockopt(socket, SOL_TCP, TCP_NODELAY,
 				(char *)&val, sizeof(val));
 		if (rc)
-			cFYI(1, "set TCP_NODELAY socket option error %d", rc);
+			cifs_dbg(FYI, "set TCP_NODELAY socket option error %d\n",
+				 rc);
 	}
 
-	 cFYI(1, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx",
+	cifs_dbg(FYI, "sndbuf %d rcvbuf %d rcvtimeo 0x%lx\n",
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
 	rc = socket->ops->connect(socket, saddr, slen, 0);
 	if (rc < 0) {
-		cFYI(1, "Error %d connecting to server", rc);
+		cifs_dbg(FYI, "Error %d connecting to server\n", rc);
 		sock_release(socket);
 		server->ssocket = NULL;
 		return rc;
@@ -3106,19 +3101,19 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 	if (vol_info && vol_info->no_linux_ext) {
 		tcon->fsUnixInfo.Capability = 0;
 		tcon->unix_ext = 0; /* Unix Extensions disabled */
-		cFYI(1, "Linux protocol extensions disabled");
+		cifs_dbg(FYI, "Linux protocol extensions disabled\n");
 		return;
 	} else if (vol_info)
 		tcon->unix_ext = 1; /* Unix Extensions supported */
 
 	if (tcon->unix_ext == 0) {
-		cFYI(1, "Unix extensions disabled so not set on reconnect");
+		cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
 		return;
 	}
 
 	if (!CIFSSMBQFSUnixInfo(xid, tcon)) {
 		__u64 cap = le64_to_cpu(tcon->fsUnixInfo.Capability);
-		cFYI(1, "unix caps which server supports %lld", cap);
+		cifs_dbg(FYI, "unix caps which server supports %lld\n", cap);
 		/* check for reconnect case in which we do not
 		   want to change the mount behavior if we can avoid it */
 		if (vol_info == NULL) {
@@ -3128,22 +3123,22 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 				cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 			if ((saved_cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
 				if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-					cERROR(1, "POSIXPATH support change");
+					cifs_dbg(VFS, "POSIXPATH support change\n");
 				cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 			} else if ((cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) == 0) {
-				cERROR(1, "possible reconnect error");
-				cERROR(1, "server disabled POSIX path support");
+				cifs_dbg(VFS, "possible reconnect error\n");
+				cifs_dbg(VFS, "server disabled POSIX path support\n");
 			}
 		}
 
 		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
-			cERROR(1, "per-share encryption not supported yet");
+			cifs_dbg(VFS, "per-share encryption not supported yet\n");
 
 		cap &= CIFS_UNIX_CAP_MASK;
 		if (vol_info && vol_info->no_psx_acl)
 			cap &= ~CIFS_UNIX_POSIX_ACL_CAP;
 		else if (CIFS_UNIX_POSIX_ACL_CAP & cap) {
-			cFYI(1, "negotiated posix acl support");
+			cifs_dbg(FYI, "negotiated posix acl support\n");
 			if (cifs_sb)
 				cifs_sb->mnt_cifs_flags |=
 					CIFS_MOUNT_POSIXACL;
@@ -3152,43 +3147,38 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 		if (vol_info && vol_info->posix_paths == 0)
 			cap &= ~CIFS_UNIX_POSIX_PATHNAMES_CAP;
 		else if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP) {
-			cFYI(1, "negotiate posix pathnames");
+			cifs_dbg(FYI, "negotiate posix pathnames\n");
 			if (cifs_sb)
 				cifs_sb->mnt_cifs_flags |=
 					CIFS_MOUNT_POSIX_PATHS;
 		}
 
-		cFYI(1, "Negotiate caps 0x%x", (int)cap);
+		cifs_dbg(FYI, "Negotiate caps 0x%x\n", (int)cap);
 #ifdef CONFIG_CIFS_DEBUG2
 		if (cap & CIFS_UNIX_FCNTL_CAP)
-			cFYI(1, "FCNTL cap");
+			cifs_dbg(FYI, "FCNTL cap\n");
 		if (cap & CIFS_UNIX_EXTATTR_CAP)
-			cFYI(1, "EXTATTR cap");
+			cifs_dbg(FYI, "EXTATTR cap\n");
 		if (cap & CIFS_UNIX_POSIX_PATHNAMES_CAP)
-			cFYI(1, "POSIX path cap");
+			cifs_dbg(FYI, "POSIX path cap\n");
 		if (cap & CIFS_UNIX_XATTR_CAP)
-			cFYI(1, "XATTR cap");
+			cifs_dbg(FYI, "XATTR cap\n");
 		if (cap & CIFS_UNIX_POSIX_ACL_CAP)
-			cFYI(1, "POSIX ACL cap");
+			cifs_dbg(FYI, "POSIX ACL cap\n");
 		if (cap & CIFS_UNIX_LARGE_READ_CAP)
-			cFYI(1, "very large read cap");
+			cifs_dbg(FYI, "very large read cap\n");
 		if (cap & CIFS_UNIX_LARGE_WRITE_CAP)
-			cFYI(1, "very large write cap");
+			cifs_dbg(FYI, "very large write cap\n");
 		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_CAP)
-			cFYI(1, "transport encryption cap");
+			cifs_dbg(FYI, "transport encryption cap\n");
 		if (cap & CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)
-			cFYI(1, "mandatory transport encryption cap");
+			cifs_dbg(FYI, "mandatory transport encryption cap\n");
 #endif /* CIFS_DEBUG2 */
 		if (CIFSSMBSetFSUnixInfo(xid, tcon, cap)) {
 			if (vol_info == NULL) {
-				cFYI(1, "resetting capabilities failed");
+				cifs_dbg(FYI, "resetting capabilities failed\n");
 			} else
-				cERROR(1, "Negotiating Unix capabilities "
-					   "with the server failed. Consider "
-					   "mounting with the Unix Extensions "
-					   "disabled if problems are found "
-					   "by specifying the nounix mount "
-					   "option.");
+				cifs_dbg(VFS, "Negotiating Unix capabilities with the server failed. Consider mounting with the Unix Extensions disabled if problems are found by specifying the nounix mount option.\n");
 
 		}
 	}
@@ -3213,8 +3203,8 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	cifs_sb->mnt_gid = pvolume_info->linux_gid;
 	cifs_sb->mnt_file_mode = pvolume_info->file_mode;
 	cifs_sb->mnt_dir_mode = pvolume_info->dir_mode;
-	cFYI(1, "file mode: 0x%hx  dir mode: 0x%hx",
-		cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
+	cifs_dbg(FYI, "file mode: 0x%hx  dir mode: 0x%hx\n",
+		 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir_mode);
 
 	cifs_sb->actimeo = pvolume_info->actimeo;
 	cifs_sb->local_nls = pvolume_info->local_nls;
@@ -3263,21 +3253,19 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 	if (pvolume_info->strict_io)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_STRICT_IO;
 	if (pvolume_info->direct_io) {
-		cFYI(1, "mounting share using direct i/o");
+		cifs_dbg(FYI, "mounting share using direct i/o\n");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
 	}
 	if (pvolume_info->mfsymlinks) {
 		if (pvolume_info->sfu_emul) {
-			cERROR(1,  "mount option mfsymlinks ignored if sfu "
-				   "mount option is used");
+			cifs_dbg(VFS, "mount option mfsymlinks ignored if sfu mount option is used\n");
 		} else {
 			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
 		}
 	}
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
-		cERROR(1, "mount option dynperm ignored if cifsacl "
-			   "mount option supported");
+		cifs_dbg(VFS, "mount option dynperm ignored if cifsacl mount option supported\n");
 }
 
 static void
@@ -3329,7 +3317,7 @@ build_unc_path_to_root(const struct smb_vol *vol,
 
 	*pos = '\0'; /* add trailing null */
 	convert_delimiter(full_path, CIFS_DIR_SEP(cifs_sb));
-	cFYI(1, "%s: full_path=%s", __func__, full_path);
+	cifs_dbg(FYI, "%s: full_path=%s\n", __func__, full_path);
 	return full_path;
 }
 
@@ -3400,14 +3388,14 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 		return -EINVAL;
 
 	if (volume_info->nullauth) {
-		cFYI(1, "Anonymous login");
+		cifs_dbg(FYI, "Anonymous login\n");
 		kfree(volume_info->username);
 		volume_info->username = NULL;
 	} else if (volume_info->username) {
 		/* BB fixme parse for domain name here */
-		cFYI(1, "Username: %s", volume_info->username);
+		cifs_dbg(FYI, "Username: %s\n", volume_info->username);
 	} else {
-		cifserror("No username specified");
+		cifs_dbg(VFS, "No username specified\n");
 	/* In userspace mount helper we can get user name from alternate
 	   locations such as env variables and files on disk */
 		return -EINVAL;
@@ -3420,7 +3408,7 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 	} else {
 		volume_info->local_nls = load_nls(volume_info->iocharset);
 		if (volume_info->local_nls == NULL) {
-			cERROR(1, "CIFS mount error: iocharset %s not found",
+			cifs_dbg(VFS, "CIFS mount error: iocharset %s not found\n",
 				 volume_info->iocharset);
 			return -ELIBACC;
 		}
@@ -3770,13 +3758,13 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		if (length == 3) {
 			if ((bcc_ptr[0] == 'I') && (bcc_ptr[1] == 'P') &&
 			    (bcc_ptr[2] == 'C')) {
-				cFYI(1, "IPC connection");
+				cifs_dbg(FYI, "IPC connection\n");
 				tcon->ipc = 1;
 			}
 		} else if (length == 2) {
 			if ((bcc_ptr[0] == 'A') && (bcc_ptr[1] == ':')) {
 				/* the most common case */
-				cFYI(1, "disk share connection");
+				cifs_dbg(FYI, "disk share connection\n");
 			}
 		}
 		bcc_ptr += length + 1;
@@ -3789,7 +3777,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 						      bytes_left, is_unicode,
 						      nls_codepage);
 
-		cFYI(1, "nativeFileSystem=%s", tcon->nativeFileSystem);
+		cifs_dbg(FYI, "nativeFileSystem=%s\n", tcon->nativeFileSystem);
 
 		if ((smb_buffer_response->WordCount == 3) ||
 			 (smb_buffer_response->WordCount == 7))
@@ -3797,7 +3785,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 			tcon->Flags = le16_to_cpu(pSMBr->OptionalSupport);
 		else
 			tcon->Flags = 0;
-		cFYI(1, "Tcon flags: 0x%x ", tcon->Flags);
+		cifs_dbg(FYI, "Tcon flags: 0x%x\n", tcon->Flags);
 	} else if ((rc == 0) && tcon == NULL) {
 		/* all we need to save for IPC$ connection */
 		ses->ipc_tid = smb_buffer_response->Tid;
@@ -3875,14 +3863,14 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (linuxExtEnabled == 0)
 		ses->capabilities &= (~server->vals->cap_unix);
 
-	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
+	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
 	if (server->ops->sess_setup)
 		rc = server->ops->sess_setup(xid, ses, nls_info);
 
 	if (rc) {
-		cERROR(1, "Send error in SessSetup = %d", rc);
+		cifs_dbg(VFS, "Send error in SessSetup = %d\n", rc);
 	} else {
 		mutex_lock(&ses->server->srv_mutex);
 		if (!server->session_estab) {
@@ -3894,7 +3882,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		}
 		mutex_unlock(&server->srv_mutex);
 
-		cFYI(1, "CIFS Session Established successfully");
+		cifs_dbg(FYI, "CIFS Session Established successfully\n");
 		spin_lock(&GlobalMid_Lock);
 		ses->status = CifsGood;
 		ses->need_reconnect = false;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 1cd0162..46e455e 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -102,7 +102,7 @@ cifs_bp_rename_retry:
 		namelen += (1 + temp->d_name.len);
 		temp = temp->d_parent;
 		if (temp == NULL) {
-			cERROR(1, "corrupt dentry");
+			cifs_dbg(VFS, "corrupt dentry\n");
 			rcu_read_unlock();
 			return NULL;
 		}
@@ -124,12 +124,12 @@ cifs_bp_rename_retry:
 			full_path[namelen] = dirsep;
 			strncpy(full_path + namelen + 1, temp->d_name.name,
 				temp->d_name.len);
-			cFYI(0, "name: %s", full_path + namelen);
+			cifs_dbg(FYI, "name: %s\n", full_path + namelen);
 		}
 		spin_unlock(&temp->d_lock);
 		temp = temp->d_parent;
 		if (temp == NULL) {
-			cERROR(1, "corrupt dentry");
+			cifs_dbg(VFS, "corrupt dentry\n");
 			rcu_read_unlock();
 			kfree(full_path);
 			return NULL;
@@ -137,8 +137,8 @@ cifs_bp_rename_retry:
 	}
 	rcu_read_unlock();
 	if (namelen != dfsplen || read_seqretry(&rename_lock, seq)) {
-		cFYI(1, "did not end path lookup where expected. namelen=%d "
-			"dfsplen=%d", namelen, dfsplen);
+		cifs_dbg(FYI, "did not end path lookup where expected. namelen=%ddfsplen=%d\n",
+			 namelen, dfsplen);
 		/* presumably this is only possible if racing with a rename
 		of one of the parent directories  (we can not lock the dentries
 		above us to prevent this, but retrying should be harmless) */
@@ -178,7 +178,7 @@ check_name(struct dentry *direntry)
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)) {
 		for (i = 0; i < direntry->d_name.len; i++) {
 			if (direntry->d_name.name[i] == '\\') {
-				cFYI(1, "Invalid file name");
+				cifs_dbg(FYI, "Invalid file name\n");
 				return -EINVAL;
 			}
 		}
@@ -291,7 +291,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	else if ((oflags & O_CREAT) == O_CREAT)
 		disposition = FILE_OPEN_IF;
 	else
-		cFYI(1, "Create flag not set in create function");
+		cifs_dbg(FYI, "Create flag not set in create function\n");
 
 	/*
 	 * BB add processing to set equivalent of mode - e.g. via CreateX with
@@ -323,7 +323,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 			       desired_access, create_options, fid, oplock,
 			       buf, cifs_sb);
 	if (rc) {
-		cFYI(1, "cifs_create returned 0x%x", rc);
+		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
 		goto out;
 	}
 
@@ -389,7 +389,8 @@ cifs_create_get_file_info:
 
 cifs_create_set_dentry:
 	if (rc != 0) {
-		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
+		cifs_dbg(FYI, "Create worked, get_inode_info failed rc = %d\n",
+			 rc);
 		if (server->ops->close)
 			server->ops->close(xid, tcon, fid);
 		goto out;
@@ -452,8 +453,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 
 	xid = get_xid();
 
-	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
-	     inode, direntry->d_name.name, direntry);
+	cifs_dbg(FYI, "parent inode = 0x%p name is: %s and dentry = 0x%p\n",
+		 inode, direntry->d_name.name, direntry);
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	if (IS_ERR(tlink))
@@ -518,8 +519,8 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	__u32 oplock;
 	int created = FILE_CREATED;
 
-	cFYI(1, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p",
-	     inode, direntry->d_name.name, direntry);
+	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p\n",
+		 inode, direntry->d_name.name, direntry);
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
@@ -613,7 +614,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 		goto mknod_out;
 
 
-	cFYI(1, "sfu compat create special file");
+	cifs_dbg(FYI, "sfu compat create special file\n");
 
 	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
 	if (buf == NULL) {
@@ -688,8 +689,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 	xid = get_xid();
 
-	cFYI(1, "parent inode = 0x%p name is: %s and dentry = 0x%p",
-	      parent_dir_inode, direntry->d_name.name, direntry);
+	cifs_dbg(FYI, "parent inode = 0x%p name is: %s and dentry = 0x%p\n",
+		 parent_dir_inode, direntry->d_name.name, direntry);
 
 	/* check whether path exists */
 
@@ -715,11 +716,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 
 	if (direntry->d_inode != NULL) {
-		cFYI(1, "non-NULL inode in lookup");
+		cifs_dbg(FYI, "non-NULL inode in lookup\n");
 	} else {
-		cFYI(1, "NULL inode in lookup");
+		cifs_dbg(FYI, "NULL inode in lookup\n");
 	}
-	cFYI(1, "Full path: %s inode = 0x%p", full_path, direntry->d_inode);
+	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
+		 full_path, direntry->d_inode);
 
 	if (pTcon->unix_ext) {
 		rc = cifs_get_inode_info_unix(&newInode, full_path,
@@ -742,7 +744,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	/*	if it was once a directory (but how can we tell?) we could do
 		shrink_dcache_parent(direntry); */
 	} else if (rc != -EACCES) {
-		cERROR(1, "Unexpected lookup error %d", rc);
+		cifs_dbg(VFS, "Unexpected lookup error %d\n", rc);
 		/* We special case check for Access Denied - since that
 		is a common return code */
 	}
@@ -807,7 +809,7 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
 	int rc = 0;
 
-	cFYI(1, "In cifs d_delete, name = %s", direntry->d_name.name);
+	cifs_dbg(FYI, "In cifs d_delete, name = %s\n", direntry->d_name.name);
 
 	return rc;
 }     */
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 1d2d91d..e7512e4 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -55,7 +55,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 
 	len = strlen(unc);
 	if (len < 3) {
-		cFYI(1, "%s: unc is too short: %s", __func__, unc);
+		cifs_dbg(FYI, "%s: unc is too short: %s\n", __func__, unc);
 		return -EINVAL;
 	}
 
@@ -68,8 +68,8 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	if (sep)
 		len = sep - hostname;
 	else
-		cFYI(1, "%s: probably server name is whole unc: %s",
-		     __func__, unc);
+		cifs_dbg(FYI, "%s: probably server name is whole unc: %s\n",
+			 __func__, unc);
 
 	/* Try to interpret hostname as an IPv4 or IPv6 address */
 	rc = cifs_convert_address((struct sockaddr *)&ss, hostname, len);
@@ -79,11 +79,11 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	/* Perform the upcall */
 	rc = dns_query(NULL, hostname, len, NULL, ip_addr, NULL);
 	if (rc < 0)
-		cFYI(1, "%s: unable to resolve: %*.*s",
-			__func__, len, len, hostname);
+		cifs_dbg(FYI, "%s: unable to resolve: %*.*s\n",
+			 __func__, len, len, hostname);
 	else
-		cFYI(1, "%s: resolved: %*.*s to %s",
-		     __func__, len, len, hostname, *ip_addr);
+		cifs_dbg(FYI, "%s: resolved: %*.*s to %s\n",
+			 __func__, len, len, hostname, *ip_addr);
 	return rc;
 
 name_is_IP_address:
@@ -92,7 +92,8 @@ name_is_IP_address:
 		return -ENOMEM;
 	memcpy(name, hostname, len);
 	name[len] = 0;
-	cFYI(1, "%s: unc is IP, skipping dns upcall: %s", __func__, name);
+	cifs_dbg(FYI, "%s: unc is IP, skipping dns upcall: %s\n",
+		 __func__, name);
 	*ip_addr = name;
 	return 0;
 }
diff --git a/fs/cifs/export.c b/fs/cifs/export.c
index 9c7ecdc..ce8b7f6 100644
--- a/fs/cifs/export.c
+++ b/fs/cifs/export.c
@@ -49,7 +49,7 @@
 static struct dentry *cifs_get_parent(struct dentry *dentry)
 {
 	/* BB need to add code here eventually to enable export via NFSD */
-	cFYI(1, "get parent for %p", dentry);
+	cifs_dbg(FYI, "get parent for %p\n", dentry);
 	return ERR_PTR(-EACCES);
 }
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8c0d855..7d3eca1 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -78,9 +78,8 @@ static u32 cifs_posix_convert_flags(unsigned int flags)
 		if (flags & O_EXCL)
 			posix_flags |= SMB_O_EXCL;
 	} else if (flags & O_EXCL)
-		cFYI(1, "Application %s pid %d has incorrectly set O_EXCL flag"
-			"but not O_CREAT on file open. Ignoring O_EXCL",
-			current->comm, current->tgid);
+		cifs_dbg(FYI, "Application %s pid %d has incorrectly set O_EXCL flag but not O_CREAT on file open. Ignoring O_EXCL\n",
+			 current->comm, current->tgid);
 
 	if (flags & O_TRUNC)
 		posix_flags |= SMB_O_TRUNC;
@@ -123,7 +122,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
 
-	cFYI(1, "posix open %s", full_path);
+	cifs_dbg(FYI, "posix open %s\n", full_path);
 
 	presp_data = kzalloc(sizeof(FILE_UNIX_BASIC_INFO), GFP_KERNEL);
 	if (presp_data == NULL)
@@ -306,7 +305,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	 */
 	if (oplock == server->vals->oplock_read &&
 						cifs_has_mand_locks(cinode)) {
-		cFYI(1, "Reset oplock val from read to None due to mand locks");
+		cifs_dbg(FYI, "Reset oplock val from read to None due to mand locks\n");
 		oplock = 0;
 	}
 
@@ -371,8 +370,8 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	list_del(&cifs_file->tlist);
 
 	if (list_empty(&cifsi->openFileList)) {
-		cFYI(1, "closing last open instance for inode %p",
-			cifs_file->dentry->d_inode);
+		cifs_dbg(FYI, "closing last open instance for inode %p\n",
+			 cifs_file->dentry->d_inode);
 		/*
 		 * In strict cache mode we need invalidate mapping on the last
 		 * close  because it may cause a error when we open this file
@@ -450,7 +449,7 @@ int cifs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
+	cifs_dbg(FYI, "inode = 0x%p file flags are 0x%x for %s\n",
 		 inode, file->f_flags, full_path);
 
 	if (server->oplocks)
@@ -466,16 +465,13 @@ int cifs_open(struct inode *inode, struct file *file)
 				cifs_sb->mnt_file_mode /* ignored */,
 				file->f_flags, &oplock, &fid.netfid, xid);
 		if (rc == 0) {
-			cFYI(1, "posix open succeeded");
+			cifs_dbg(FYI, "posix open succeeded\n");
 			posix_open_ok = true;
 		} else if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			if (tcon->ses->serverNOS)
-				cERROR(1, "server %s of type %s returned"
-					   " unexpected error on SMB posix open"
-					   ", disabling posix open support."
-					   " Check if server update available.",
-					   tcon->ses->serverName,
-					   tcon->ses->serverNOS);
+				cifs_dbg(VFS, "server %s of type %s returned unexpected error on SMB posix open, disabling posix open support. Check if server update available.\n",
+					 tcon->ses->serverName,
+					 tcon->ses->serverNOS);
 			tcon->broken_posix_open = true;
 		} else if ((rc != -EIO) && (rc != -EREMOTE) &&
 			 (rc != -EOPNOTSUPP)) /* path not found or net err */
@@ -617,8 +613,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		return rc;
 	}
 
-	cFYI(1, "inode = 0x%p file flags 0x%x for %s", inode, cfile->f_flags,
-	     full_path);
+	cifs_dbg(FYI, "inode = 0x%p file flags 0x%x for %s\n",
+		 inode, cfile->f_flags, full_path);
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
@@ -639,7 +635,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 				     cifs_sb->mnt_file_mode /* ignored */,
 				     oflags, &oplock, &fid.netfid, xid);
 		if (rc == 0) {
-			cFYI(1, "posix reopen succeeded");
+			cifs_dbg(FYI, "posix reopen succeeded\n");
 			goto reopen_success;
 		}
 		/*
@@ -668,8 +664,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 			       NULL, cifs_sb);
 	if (rc) {
 		mutex_unlock(&cfile->fh_mutex);
-		cFYI(1, "cifs_reopen returned 0x%x", rc);
-		cFYI(1, "oplock: %d", oplock);
+		cifs_dbg(FYI, "cifs_reopen returned 0x%x\n", rc);
+		cifs_dbg(FYI, "oplock: %d\n", oplock);
 		goto reopen_error_exit;
 	}
 
@@ -725,7 +721,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	struct TCP_Server_Info *server;
 	char *buf;
 
-	cFYI(1, "Closedir inode = 0x%p", inode);
+	cifs_dbg(FYI, "Closedir inode = 0x%p\n", inode);
 
 	if (cfile == NULL)
 		return rc;
@@ -734,7 +730,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	tcon = tlink_tcon(cfile->tlink);
 	server = tcon->ses->server;
 
-	cFYI(1, "Freeing private data in close dir");
+	cifs_dbg(FYI, "Freeing private data in close dir\n");
 	spin_lock(&cifs_file_list_lock);
 	if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
 		cfile->invalidHandle = true;
@@ -743,7 +739,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 			rc = server->ops->close_dir(xid, tcon, &cfile->fid);
 		else
 			rc = -ENOSYS;
-		cFYI(1, "Closing uncompleted readdir with rc %d", rc);
+		cifs_dbg(FYI, "Closing uncompleted readdir with rc %d\n", rc);
 		/* not much we can do if it fails anyway, ignore rc */
 		rc = 0;
 	} else
@@ -751,7 +747,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 
 	buf = cfile->srch_inf.ntwrk_buf_start;
 	if (buf) {
-		cFYI(1, "closedir free smb buf in srch struct");
+		cifs_dbg(FYI, "closedir free smb buf in srch struct\n");
 		cfile->srch_inf.ntwrk_buf_start = NULL;
 		if (cfile->srch_inf.smallBuf)
 			cifs_small_buf_release(buf);
@@ -1136,7 +1132,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 			 * The list ended. We don't have enough allocated
 			 * structures - something is really wrong.
 			 */
-			cERROR(1, "Can't push all brlocks!");
+			cifs_dbg(VFS, "Can't push all brlocks!\n");
 			break;
 		}
 		length = 1 + flock->fl_end - flock->fl_start;
@@ -1209,47 +1205,46 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
 		bool *wait_flag, struct TCP_Server_Info *server)
 {
 	if (flock->fl_flags & FL_POSIX)
-		cFYI(1, "Posix");
+		cifs_dbg(FYI, "Posix\n");
 	if (flock->fl_flags & FL_FLOCK)
-		cFYI(1, "Flock");
+		cifs_dbg(FYI, "Flock\n");
 	if (flock->fl_flags & FL_SLEEP) {
-		cFYI(1, "Blocking lock");
+		cifs_dbg(FYI, "Blocking lock\n");
 		*wait_flag = true;
 	}
 	if (flock->fl_flags & FL_ACCESS)
-		cFYI(1, "Process suspended by mandatory locking - "
-			"not implemented yet");
+		cifs_dbg(FYI, "Process suspended by mandatory locking - not implemented yet\n");
 	if (flock->fl_flags & FL_LEASE)
-		cFYI(1, "Lease on file - not implemented yet");
+		cifs_dbg(FYI, "Lease on file - not implemented yet\n");
 	if (flock->fl_flags &
 	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP |
 	       FL_ACCESS | FL_LEASE | FL_CLOSE)))
-		cFYI(1, "Unknown lock flags 0x%x", flock->fl_flags);
+		cifs_dbg(FYI, "Unknown lock flags 0x%x\n", flock->fl_flags);
 
 	*type = server->vals->large_lock_type;
 	if (flock->fl_type == F_WRLCK) {
-		cFYI(1, "F_WRLCK ");
+		cifs_dbg(FYI, "F_WRLCK\n");
 		*type |= server->vals->exclusive_lock_type;
 		*lock = 1;
 	} else if (flock->fl_type == F_UNLCK) {
-		cFYI(1, "F_UNLCK");
+		cifs_dbg(FYI, "F_UNLCK\n");
 		*type |= server->vals->unlock_lock_type;
 		*unlock = 1;
 		/* Check if unlock includes more than one lock range */
 	} else if (flock->fl_type == F_RDLCK) {
-		cFYI(1, "F_RDLCK");
+		cifs_dbg(FYI, "F_RDLCK\n");
 		*type |= server->vals->shared_lock_type;
 		*lock = 1;
 	} else if (flock->fl_type == F_EXLCK) {
-		cFYI(1, "F_EXLCK");
+		cifs_dbg(FYI, "F_EXLCK\n");
 		*type |= server->vals->exclusive_lock_type;
 		*lock = 1;
 	} else if (flock->fl_type == F_SHLCK) {
-		cFYI(1, "F_SHLCK");
+		cifs_dbg(FYI, "F_SHLCK\n");
 		*type |= server->vals->shared_lock_type;
 		*lock = 1;
 	} else
-		cFYI(1, "Unknown type of lock");
+		cifs_dbg(FYI, "Unknown type of lock\n");
 }
 
 static int
@@ -1292,8 +1287,8 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 					    type, 0, 1, false);
 		flock->fl_type = F_UNLCK;
 		if (rc != 0)
-			cERROR(1, "Error unlocking previously locked "
-				  "range %d during test of lock", rc);
+			cifs_dbg(VFS, "Error unlocking previously locked range %d during test of lock\n",
+				 rc);
 		return 0;
 	}
 
@@ -1312,8 +1307,8 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 			type | server->vals->shared_lock_type, 0, 1, false);
 		flock->fl_type = F_RDLCK;
 		if (rc != 0)
-			cERROR(1, "Error unlocking previously locked "
-				  "range %d during test of lock", rc);
+			cifs_dbg(VFS, "Error unlocking previously locked range %d during test of lock\n",
+				 rc);
 	} else
 		flock->fl_type = F_WRLCK;
 
@@ -1504,8 +1499,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		if (!CIFS_I(inode)->clientCanCacheAll &&
 					CIFS_I(inode)->clientCanCacheRead) {
 			cifs_invalidate_mapping(inode);
-			cFYI(1, "Set no oplock for inode=%p due to mand locks",
-			     inode);
+			cifs_dbg(FYI, "Set no oplock for inode=%p due to mand locks\n",
+				 inode);
 			CIFS_I(inode)->clientCanCacheRead = false;
 		}
 
@@ -1542,9 +1537,9 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
 	rc = -EACCES;
 	xid = get_xid();
 
-	cFYI(1, "Lock parm: 0x%x flockflags: 0x%x flocktype: 0x%x start: %lld "
-		"end: %lld", cmd, flock->fl_flags, flock->fl_type,
-		flock->fl_start, flock->fl_end);
+	cifs_dbg(FYI, "Lock parm: 0x%x flockflags: 0x%x flocktype: 0x%x start: %lld end: %lld\n",
+		 cmd, flock->fl_flags, flock->fl_type,
+		 flock->fl_start, flock->fl_end);
 
 	cfile = (struct cifsFileInfo *)file->private_data;
 	tcon = tlink_tcon(cfile->tlink);
@@ -1616,8 +1611,8 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 
 	cifs_sb = CIFS_SB(dentry->d_sb);
 
-	cFYI(1, "write %zd bytes to offset %lld of %s", write_size,
-	     *offset, dentry->d_name.name);
+	cifs_dbg(FYI, "write %zd bytes to offset %lld of %s\n",
+		 write_size, *offset, dentry->d_name.name);
 
 	tcon = tlink_tcon(open_file->tlink);
 	server = tcon->ses->server;
@@ -1732,7 +1727,7 @@ struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 	it being zero) during stress testcases so we need to check for it */
 
 	if (cifs_inode == NULL) {
-		cERROR(1, "Null inode passed to cifs_writeable_file");
+		cifs_dbg(VFS, "Null inode passed to cifs_writeable_file\n");
 		dump_stack();
 		return NULL;
 	}
@@ -1844,7 +1839,7 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 		else if (bytes_written < 0)
 			rc = bytes_written;
 	} else {
-		cFYI(1, "No writeable filehandles for inode");
+		cifs_dbg(FYI, "No writeable filehandles for inode\n");
 		rc = -EIO;
 	}
 
@@ -2011,7 +2006,7 @@ retry:
 			wdata->cfile = find_writable_file(CIFS_I(mapping->host),
 							  false);
 			if (!wdata->cfile) {
-				cERROR(1, "No writable handles for inode");
+				cifs_dbg(VFS, "No writable handles for inode\n");
 				rc = -EBADF;
 				break;
 			}
@@ -2072,7 +2067,7 @@ cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 /* BB add check for wbc flags */
 	page_cache_get(page);
 	if (!PageUptodate(page))
-		cFYI(1, "ppw - page not up to date");
+		cifs_dbg(FYI, "ppw - page not up to date\n");
 
 	/*
 	 * Set the "writeback" flag, and clear "dirty" in the radix tree.
@@ -2123,7 +2118,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 	else
 		pid = current->tgid;
 
-	cFYI(1, "write_end for page %p from pos %lld with %d bytes",
+	cifs_dbg(FYI, "write_end for page %p from pos %lld with %d bytes\n",
 		 page, pos, copied);
 
 	if (PageChecked(page)) {
@@ -2187,13 +2182,13 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 
 	xid = get_xid();
 
-	cFYI(1, "Sync file - name: %s datasync: 0x%x",
-		file->f_path.dentry->d_name.name, datasync);
+	cifs_dbg(FYI, "Sync file - name: %s datasync: 0x%x\n",
+		 file->f_path.dentry->d_name.name, datasync);
 
 	if (!CIFS_I(inode)->clientCanCacheRead) {
 		rc = cifs_invalidate_mapping(inode);
 		if (rc) {
-			cFYI(1, "rc: %d during invalidate phase", rc);
+			cifs_dbg(FYI, "rc: %d during invalidate phase\n", rc);
 			rc = 0; /* don't care about it in fsync */
 		}
 	}
@@ -2229,8 +2224,8 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 	xid = get_xid();
 
-	cFYI(1, "Sync file - name: %s datasync: 0x%x",
-		file->f_path.dentry->d_name.name, datasync);
+	cifs_dbg(FYI, "Sync file - name: %s datasync: 0x%x\n",
+		 file->f_path.dentry->d_name.name, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
@@ -2258,7 +2253,7 @@ int cifs_flush(struct file *file, fl_owner_t id)
 	if (file->f_mode & FMODE_WRITE)
 		rc = filemap_write_and_wait(inode->i_mapping);
 
-	cFYI(1, "Flush inode %p file %p rc %d", inode, file, rc);
+	cifs_dbg(FYI, "Flush inode %p file %p rc %d\n", inode, file, rc);
 
 	return rc;
 }
@@ -2578,8 +2573,8 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
 		 * an old data.
 		 */
 		cifs_invalidate_mapping(inode);
-		cFYI(1, "Set no oplock for inode=%p after a write operation",
-		     inode);
+		cifs_dbg(FYI, "Set no oplock for inode=%p after a write operation\n",
+			 inode);
 		cinode->clientCanCacheRead = false;
 	}
 	return written;
@@ -2755,15 +2750,15 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 			/* enough data to fill the page */
 			iov.iov_base = kmap(page);
 			iov.iov_len = PAGE_SIZE;
-			cFYI(1, "%u: iov_base=%p iov_len=%zu",
-				i, iov.iov_base, iov.iov_len);
+			cifs_dbg(FYI, "%u: iov_base=%p iov_len=%zu\n",
+				 i, iov.iov_base, iov.iov_len);
 			len -= PAGE_SIZE;
 		} else if (len > 0) {
 			/* enough for partial page, fill and zero the rest */
 			iov.iov_base = kmap(page);
 			iov.iov_len = len;
-			cFYI(1, "%u: iov_base=%p iov_len=%zu",
-				i, iov.iov_base, iov.iov_len);
+			cifs_dbg(FYI, "%u: iov_base=%p iov_len=%zu\n",
+				 i, iov.iov_base, iov.iov_len);
 			memset(iov.iov_base + len, '\0', PAGE_SIZE - len);
 			rdata->tailsz = len;
 			len = 0;
@@ -2823,7 +2818,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 		pid = current->tgid;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		cFYI(1, "attempting read on write only file instance");
+		cifs_dbg(FYI, "attempting read on write only file instance\n");
 
 	do {
 		cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
@@ -3002,7 +2997,7 @@ cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 		pid = current->tgid;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
-		cFYI(1, "attempting read on write only file instance");
+		cifs_dbg(FYI, "attempting read on write only file instance\n");
 
 	for (total_read = 0, cur_offset = read_data; read_size > total_read;
 	     total_read += bytes_read, cur_offset += bytes_read) {
@@ -3093,7 +3088,8 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	xid = get_xid();
 	rc = cifs_revalidate_file(file);
 	if (rc) {
-		cFYI(1, "Validation prior to mmap failed, error=%d", rc);
+		cifs_dbg(FYI, "Validation prior to mmap failed, error=%d\n",
+			 rc);
 		free_xid(xid);
 		return rc;
 	}
@@ -3146,7 +3142,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 	/* determine the eof that the server (probably) has */
 	eof = CIFS_I(rdata->mapping->host)->server_eof;
 	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
-	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
+	cifs_dbg(FYI, "eof=%llu eof_index=%lu\n", eof, eof_index);
 
 	rdata->tailsz = PAGE_CACHE_SIZE;
 	for (i = 0; i < nr_pages; i++) {
@@ -3156,15 +3152,15 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 			/* enough data to fill the page */
 			iov.iov_base = kmap(page);
 			iov.iov_len = PAGE_CACHE_SIZE;
-			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				i, page->index, iov.iov_base, iov.iov_len);
+			cifs_dbg(FYI, "%u: idx=%lu iov_base=%p iov_len=%zu\n",
+				 i, page->index, iov.iov_base, iov.iov_len);
 			len -= PAGE_CACHE_SIZE;
 		} else if (len > 0) {
 			/* enough for partial page, fill and zero the rest */
 			iov.iov_base = kmap(page);
 			iov.iov_len = len;
-			cFYI(1, "%u: idx=%lu iov_base=%p iov_len=%zu",
-				i, page->index, iov.iov_base, iov.iov_len);
+			cifs_dbg(FYI, "%u: idx=%lu iov_base=%p iov_len=%zu\n",
+				 i, page->index, iov.iov_base, iov.iov_len);
 			memset(iov.iov_base + len,
 				'\0', PAGE_CACHE_SIZE - len);
 			rdata->tailsz = len;
@@ -3244,8 +3240,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	rc = 0;
 	INIT_LIST_HEAD(&tmplist);
 
-	cFYI(1, "%s: file=%p mapping=%p num_pages=%u", __func__, file,
-		mapping, num_pages);
+	cifs_dbg(FYI, "%s: file=%p mapping=%p num_pages=%u\n",
+		 __func__, file, mapping, num_pages);
 
 	/*
 	 * Start with the page at end of list and move it to private
@@ -3375,7 +3371,7 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 	if (rc < 0)
 		goto io_error;
 	else
-		cFYI(1, "Bytes read %d", rc);
+		cifs_dbg(FYI, "Bytes read %d\n", rc);
 
 	file_inode(file)->i_atime =
 		current_fs_time(file_inode(file)->i_sb);
@@ -3413,7 +3409,7 @@ static int cifs_readpage(struct file *file, struct page *page)
 		return rc;
 	}
 
-	cFYI(1, "readpage %p at offset %d 0x%x",
+	cifs_dbg(FYI, "readpage %p at offset %d 0x%x\n",
 		 page, (int)offset, (int)offset);
 
 	rc = cifs_readpage_worker(file, page, &offset);
@@ -3480,7 +3476,7 @@ static int cifs_write_begin(struct file *file, struct address_space *mapping,
 	struct page *page;
 	int rc = 0;
 
-	cFYI(1, "write_begin from %lld len %d", (long long)pos, len);
+	cifs_dbg(FYI, "write_begin from %lld len %d\n", (long long)pos, len);
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
@@ -3569,7 +3565,7 @@ static int cifs_launder_page(struct page *page)
 		.range_end = range_end,
 	};
 
-	cFYI(1, "Launder page: %p", page);
+	cifs_dbg(FYI, "Launder page: %p\n", page);
 
 	if (clear_page_dirty_for_io(page))
 		rc = cifs_writepage_locked(page, &wbc);
@@ -3589,8 +3585,8 @@ void cifs_oplock_break(struct work_struct *work)
 
 	if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead &&
 						cifs_has_mand_locks(cinode)) {
-		cFYI(1, "Reset oplock to None for inode=%p due to mand locks",
-		     inode);
+		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
+			 inode);
 		cinode->clientCanCacheRead = false;
 	}
 
@@ -3605,12 +3601,12 @@ void cifs_oplock_break(struct work_struct *work)
 			mapping_set_error(inode->i_mapping, rc);
 			cifs_invalidate_mapping(inode);
 		}
-		cFYI(1, "Oplock flush inode %p rc %d", inode, rc);
+		cifs_dbg(FYI, "Oplock flush inode %p rc %d\n", inode, rc);
 	}
 
 	rc = cifs_push_locks(cfile);
 	if (rc)
-		cERROR(1, "Push locks rc = %d", rc);
+		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
 
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
@@ -3621,7 +3617,7 @@ void cifs_oplock_break(struct work_struct *work)
 	if (!cfile->oplock_break_cancelled) {
 		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
 							     cinode);
-		cFYI(1, "Oplock release rc = %d", rc);
+		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
 }
 
diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
index 42e5363..2f4bc5a 100644
--- a/fs/cifs/fscache.c
+++ b/fs/cifs/fscache.c
@@ -28,14 +28,14 @@ void cifs_fscache_get_client_cookie(struct TCP_Server_Info *server)
 	server->fscache =
 		fscache_acquire_cookie(cifs_fscache_netfs.primary_index,
 				&cifs_fscache_server_index_def, server);
-	cFYI(1, "%s: (0x%p/0x%p)", __func__, server,
-			server->fscache);
+	cifs_dbg(FYI, "%s: (0x%p/0x%p)\n",
+		 __func__, server, server->fscache);
 }
 
 void cifs_fscache_release_client_cookie(struct TCP_Server_Info *server)
 {
-	cFYI(1, "%s: (0x%p/0x%p)", __func__, server,
-			server->fscache);
+	cifs_dbg(FYI, "%s: (0x%p/0x%p)\n",
+		 __func__, server, server->fscache);
 	fscache_relinquish_cookie(server->fscache, 0);
 	server->fscache = NULL;
 }
@@ -47,13 +47,13 @@ void cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
 	tcon->fscache =
 		fscache_acquire_cookie(server->fscache,
 				&cifs_fscache_super_index_def, tcon);
-	cFYI(1, "%s: (0x%p/0x%p)", __func__, server->fscache,
-			tcon->fscache);
+	cifs_dbg(FYI, "%s: (0x%p/0x%p)\n",
+		 __func__, server->fscache, tcon->fscache);
 }
 
 void cifs_fscache_release_super_cookie(struct cifs_tcon *tcon)
 {
-	cFYI(1, "%s: (0x%p)", __func__, tcon->fscache);
+	cifs_dbg(FYI, "%s: (0x%p)\n", __func__, tcon->fscache);
 	fscache_relinquish_cookie(tcon->fscache, 0);
 	tcon->fscache = NULL;
 }
@@ -70,8 +70,8 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE) {
 		cifsi->fscache = fscache_acquire_cookie(tcon->fscache,
 				&cifs_fscache_inode_object_def, cifsi);
-		cFYI(1, "%s: got FH cookie (0x%p/0x%p)", __func__,
-				tcon->fscache, cifsi->fscache);
+		cifs_dbg(FYI, "%s: got FH cookie (0x%p/0x%p)\n",
+			 __func__, tcon->fscache, cifsi->fscache);
 	}
 }
 
@@ -80,7 +80,7 @@ void cifs_fscache_release_inode_cookie(struct inode *inode)
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 
 	if (cifsi->fscache) {
-		cFYI(1, "%s: (0x%p)", __func__, cifsi->fscache);
+		cifs_dbg(FYI, "%s: (0x%p)\n", __func__, cifsi->fscache);
 		fscache_relinquish_cookie(cifsi->fscache, 0);
 		cifsi->fscache = NULL;
 	}
@@ -91,7 +91,7 @@ static void cifs_fscache_disable_inode_cookie(struct inode *inode)
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 
 	if (cifsi->fscache) {
-		cFYI(1, "%s: (0x%p)", __func__, cifsi->fscache);
+		cifs_dbg(FYI, "%s: (0x%p)\n", __func__, cifsi->fscache);
 		fscache_uncache_all_inode_pages(cifsi->fscache, inode);
 		fscache_relinquish_cookie(cifsi->fscache, 1);
 		cifsi->fscache = NULL;
@@ -120,8 +120,8 @@ void cifs_fscache_reset_inode_cookie(struct inode *inode)
 					cifs_sb_master_tcon(cifs_sb)->fscache,
 					&cifs_fscache_inode_object_def,
 					cifsi);
-		cFYI(1, "%s: new cookie 0x%p oldcookie 0x%p",
-				__func__, cifsi->fscache, old);
+		cifs_dbg(FYI, "%s: new cookie 0x%p oldcookie 0x%p\n",
+			 __func__, cifsi->fscache, old);
 	}
 }
 
@@ -131,8 +131,8 @@ int cifs_fscache_release_page(struct page *page, gfp_t gfp)
 		struct inode *inode = page->mapping->host;
 		struct cifsInodeInfo *cifsi = CIFS_I(inode);
 
-		cFYI(1, "%s: (0x%p/0x%p)", __func__, page,
-				cifsi->fscache);
+		cifs_dbg(FYI, "%s: (0x%p/0x%p)\n",
+			 __func__, page, cifsi->fscache);
 		if (!fscache_maybe_release_page(cifsi->fscache, page, gfp))
 			return 0;
 	}
@@ -143,7 +143,7 @@ int cifs_fscache_release_page(struct page *page, gfp_t gfp)
 static void cifs_readpage_from_fscache_complete(struct page *page, void *ctx,
 						int error)
 {
-	cFYI(1, "%s: (0x%p/%d)", __func__, page, error);
+	cifs_dbg(FYI, "%s: (0x%p/%d)\n", __func__, page, error);
 	if (!error)
 		SetPageUptodate(page);
 	unlock_page(page);
@@ -156,8 +156,8 @@ int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
 {
 	int ret;
 
-	cFYI(1, "%s: (fsc:%p, p:%p, i:0x%p", __func__,
-			CIFS_I(inode)->fscache, page, inode);
+	cifs_dbg(FYI, "%s: (fsc:%p, p:%p, i:0x%p\n",
+		 __func__, CIFS_I(inode)->fscache, page, inode);
 	ret = fscache_read_or_alloc_page(CIFS_I(inode)->fscache, page,
 					 cifs_readpage_from_fscache_complete,
 					 NULL,
@@ -165,15 +165,15 @@ int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
 	switch (ret) {
 
 	case 0: /* page found in fscache, read submitted */
-		cFYI(1, "%s: submitted", __func__);
+		cifs_dbg(FYI, "%s: submitted\n", __func__);
 		return ret;
 	case -ENOBUFS:	/* page won't be cached */
 	case -ENODATA:	/* page not in cache */
-		cFYI(1, "%s: %d", __func__, ret);
+		cifs_dbg(FYI, "%s: %d\n", __func__, ret);
 		return 1;
 
 	default:
-		cERROR(1, "unknown error ret = %d", ret);
+		cifs_dbg(VFS, "unknown error ret = %d\n", ret);
 	}
 	return ret;
 }
@@ -188,8 +188,8 @@ int __cifs_readpages_from_fscache(struct inode *inode,
 {
 	int ret;
 
-	cFYI(1, "%s: (0x%p/%u/0x%p)", __func__,
-			CIFS_I(inode)->fscache, *nr_pages, inode);
+	cifs_dbg(FYI, "%s: (0x%p/%u/0x%p)\n",
+		 __func__, CIFS_I(inode)->fscache, *nr_pages, inode);
 	ret = fscache_read_or_alloc_pages(CIFS_I(inode)->fscache, mapping,
 					  pages, nr_pages,
 					  cifs_readpage_from_fscache_complete,
@@ -197,16 +197,16 @@ int __cifs_readpages_from_fscache(struct inode *inode,
 					  mapping_gfp_mask(mapping));
 	switch (ret) {
 	case 0:	/* read submitted to the cache for all pages */
-		cFYI(1, "%s: submitted", __func__);
+		cifs_dbg(FYI, "%s: submitted\n", __func__);
 		return ret;
 
 	case -ENOBUFS:	/* some pages are not cached and can't be */
 	case -ENODATA:	/* some pages are not cached */
-		cFYI(1, "%s: no page", __func__);
+		cifs_dbg(FYI, "%s: no page\n", __func__);
 		return 1;
 
 	default:
-		cFYI(1, "unknown error ret = %d", ret);
+		cifs_dbg(FYI, "unknown error ret = %d\n", ret);
 	}
 
 	return ret;
@@ -216,8 +216,8 @@ void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
 {
 	int ret;
 
-	cFYI(1, "%s: (fsc: %p, p: %p, i: %p)", __func__,
-			CIFS_I(inode)->fscache, page, inode);
+	cifs_dbg(FYI, "%s: (fsc: %p, p: %p, i: %p)\n",
+		 __func__, CIFS_I(inode)->fscache, page, inode);
 	ret = fscache_write_page(CIFS_I(inode)->fscache, page, GFP_KERNEL);
 	if (ret != 0)
 		fscache_uncache_page(CIFS_I(inode)->fscache, page);
@@ -228,7 +228,7 @@ void __cifs_fscache_invalidate_page(struct page *page, struct inode *inode)
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct fscache_cookie *cookie = cifsi->fscache;
 
-	cFYI(1, "%s: (0x%p/0x%p)", __func__, page, cookie);
+	cifs_dbg(FYI, "%s: (0x%p/0x%p)\n", __func__, page, cookie);
 	fscache_wait_on_page_write(cookie, page);
 	fscache_uncache_page(cookie, page);
 }
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0079696..f167655 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -91,30 +91,32 @@ cifs_revalidate_cache(struct inode *inode, struct cifs_fattr *fattr)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 
-	cFYI(1, "%s: revalidating inode %llu", __func__, cifs_i->uniqueid);
+	cifs_dbg(FYI, "%s: revalidating inode %llu\n",
+		 __func__, cifs_i->uniqueid);
 
 	if (inode->i_state & I_NEW) {
-		cFYI(1, "%s: inode %llu is new", __func__, cifs_i->uniqueid);
+		cifs_dbg(FYI, "%s: inode %llu is new\n",
+			 __func__, cifs_i->uniqueid);
 		return;
 	}
 
 	/* don't bother with revalidation if we have an oplock */
 	if (cifs_i->clientCanCacheRead) {
-		cFYI(1, "%s: inode %llu is oplocked", __func__,
-			 cifs_i->uniqueid);
+		cifs_dbg(FYI, "%s: inode %llu is oplocked\n",
+			 __func__, cifs_i->uniqueid);
 		return;
 	}
 
 	 /* revalidate if mtime or size have changed */
 	if (timespec_equal(&inode->i_mtime, &fattr->cf_mtime) &&
 	    cifs_i->server_eof == fattr->cf_eof) {
-		cFYI(1, "%s: inode %llu is unchanged", __func__,
-			 cifs_i->uniqueid);
+		cifs_dbg(FYI, "%s: inode %llu is unchanged\n",
+			 __func__, cifs_i->uniqueid);
 		return;
 	}
 
-	cFYI(1, "%s: invalidating inode %llu mapping", __func__,
-		 cifs_i->uniqueid);
+	cifs_dbg(FYI, "%s: invalidating inode %llu mapping\n",
+		 __func__, cifs_i->uniqueid);
 	cifs_i->invalid_mapping = true;
 }
 
@@ -240,7 +242,7 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fattr, FILE_UNIX_BASIC_INFO *info,
 		/* safest to call it a file if we do not know */
 		fattr->cf_mode |= S_IFREG;
 		fattr->cf_dtype = DT_REG;
-		cFYI(1, "unknown type %d", le32_to_cpu(info->Type));
+		cifs_dbg(FYI, "unknown type %d\n", le32_to_cpu(info->Type));
 		break;
 	}
 
@@ -279,7 +281,7 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	cFYI(1, "creating fake fattr for DFS referral");
+	cifs_dbg(FYI, "creating fake fattr for DFS referral\n");
 
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
@@ -329,7 +331,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	cFYI(1, "Getting info on %s", full_path);
+	cifs_dbg(FYI, "Getting info on %s\n", full_path);
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -355,7 +357,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
 		int tmprc = CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, xid);
 		if (tmprc)
-			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
+			cifs_dbg(FYI, "CIFSCheckMFSymlink: %d\n", tmprc);
 	}
 
 	if (*pinode == NULL) {
@@ -422,7 +424,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 				 &buf_type);
 		if ((rc == 0) && (bytes_read >= 8)) {
 			if (memcmp("IntxBLK", pbuf, 8) == 0) {
-				cFYI(1, "Block device");
+				cifs_dbg(FYI, "Block device\n");
 				fattr->cf_mode |= S_IFBLK;
 				fattr->cf_dtype = DT_BLK;
 				if (bytes_read == 24) {
@@ -434,7 +436,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 					fattr->cf_rdev = MKDEV(mjr, mnr);
 				}
 			} else if (memcmp("IntxCHR", pbuf, 8) == 0) {
-				cFYI(1, "Char device");
+				cifs_dbg(FYI, "Char device\n");
 				fattr->cf_mode |= S_IFCHR;
 				fattr->cf_dtype = DT_CHR;
 				if (bytes_read == 24) {
@@ -446,7 +448,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 					fattr->cf_rdev = MKDEV(mjr, mnr);
 				}
 			} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
-				cFYI(1, "Symlink");
+				cifs_dbg(FYI, "Symlink\n");
 				fattr->cf_mode |= S_IFLNK;
 				fattr->cf_dtype = DT_LNK;
 			} else {
@@ -497,10 +499,10 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 	else if (rc > 3) {
 		mode = le32_to_cpu(*((__le32 *)ea_value));
 		fattr->cf_mode &= ~SFBITS_MASK;
-		cFYI(1, "special bits 0%o org mode 0%o", mode,
-			 fattr->cf_mode);
+		cifs_dbg(FYI, "special bits 0%o org mode 0%o\n",
+			 mode, fattr->cf_mode);
 		fattr->cf_mode = (mode & SFBITS_MASK) | fattr->cf_mode;
-		cFYI(1, "special mode bits 0%o", mode);
+		cifs_dbg(FYI, "special mode bits 0%o\n", mode);
 	}
 
 	return 0;
@@ -635,11 +637,11 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	cFYI(1, "Getting info on %s", full_path);
+	cifs_dbg(FYI, "Getting info on %s\n", full_path);
 
 	if ((data == NULL) && (*inode != NULL)) {
 		if (CIFS_I(*inode)->clientCanCacheRead) {
-			cFYI(1, "No need to revalidate cached inode sizes");
+			cifs_dbg(FYI, "No need to revalidate cached inode sizes\n");
 			goto cgii_exit;
 		}
 	}
@@ -714,7 +716,8 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 						tcon, cifs_sb, full_path,
 						&fattr.cf_uniqueid, data);
 				if (tmprc) {
-					cFYI(1, "GetSrvInodeNum rc %d", tmprc);
+					cifs_dbg(FYI, "GetSrvInodeNum rc %d\n",
+						 tmprc);
 					fattr.cf_uniqueid = iunique(sb, ROOT_I);
 					cifs_autodisable_serverino(cifs_sb);
 				}
@@ -729,7 +732,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	    cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
 		tmprc = cifs_sfu_type(&fattr, full_path, cifs_sb, xid);
 		if (tmprc)
-			cFYI(1, "cifs_sfu_type failed: %d", tmprc);
+			cifs_dbg(FYI, "cifs_sfu_type failed: %d\n", tmprc);
 	}
 
 #ifdef CONFIG_CIFS_ACL
@@ -737,8 +740,8 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
 		rc = cifs_acl_to_fattr(cifs_sb, &fattr, *inode, full_path, fid);
 		if (rc) {
-			cFYI(1, "%s: Getting ACL failed with error: %d",
-				__func__, rc);
+			cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
+				 __func__, rc);
 			goto cgii_exit;
 		}
 	}
@@ -752,7 +755,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
 		tmprc = CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, xid);
 		if (tmprc)
-			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
+			cifs_dbg(FYI, "CIFSCheckMFSymlink: %d\n", tmprc);
 	}
 
 	if (!*inode) {
@@ -836,7 +839,7 @@ cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
 	struct inode *inode;
 
 retry_iget5_locked:
-	cFYI(1, "looking for uniqueid=%llu", fattr->cf_uniqueid);
+	cifs_dbg(FYI, "looking for uniqueid=%llu\n", fattr->cf_uniqueid);
 
 	/* hash down to 32-bits on 32-bit arch */
 	hash = cifs_uniqueid_to_ino_t(fattr->cf_uniqueid);
@@ -899,7 +902,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 #endif
 
 	if (rc && tcon->ipc) {
-		cFYI(1, "ipc connection - fake read inode");
+		cifs_dbg(FYI, "ipc connection - fake read inode\n");
 		spin_lock(&inode->i_lock);
 		inode->i_mode |= S_IFDIR;
 		set_nlink(inode, 2);
@@ -958,7 +961,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 	 * server times.
 	 */
 	if (set_time && (attrs->ia_valid & ATTR_CTIME)) {
-		cFYI(1, "CIFS - CTIME changed");
+		cifs_dbg(FYI, "CIFS - CTIME changed\n");
 		info_buf.ChangeTime =
 		    cpu_to_le64(cifs_UnixTimeToNT(attrs->ia_ctime));
 	} else
@@ -1127,7 +1130,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct iattr *attrs = NULL;
 	__u32 dosattr = 0, origattr = 0;
 
-	cFYI(1, "cifs_unlink, dir=0x%p, dentry=0x%p", dir, dentry);
+	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
 
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
@@ -1150,7 +1153,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 		rc = CIFSPOSIXDelFile(xid, tcon, full_path,
 			SMB_POSIX_UNLINK_FILE_TARGET, cifs_sb->local_nls,
 			cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
-		cFYI(1, "posix del rc %d", rc);
+		cifs_dbg(FYI, "posix del rc %d\n", rc);
 		if ((rc == 0) || (rc == -ENOENT))
 			goto psx_del_no_retry;
 	}
@@ -1322,7 +1325,7 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 	if (rc == -EOPNOTSUPP)
 		goto posix_mkdir_out;
 	else if (rc) {
-		cFYI(1, "posix mkdir returned 0x%x", rc);
+		cifs_dbg(FYI, "posix mkdir returned 0x%x\n", rc);
 		d_drop(dentry);
 		goto posix_mkdir_out;
 	}
@@ -1344,11 +1347,12 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 	d_instantiate(dentry, newinode);
 
 #ifdef CONFIG_CIFS_DEBUG2
-	cFYI(1, "instantiated dentry %p %s to inode %p", dentry,
-	     dentry->d_name.name, newinode);
+	cifs_dbg(FYI, "instantiated dentry %p %s to inode %p\n",
+		 dentry, dentry->d_name.name, newinode);
 
 	if (newinode->i_nlink != 2)
-		cFYI(1, "unexpected number of links %d", newinode->i_nlink);
+		cifs_dbg(FYI, "unexpected number of links %d\n",
+			 newinode->i_nlink);
 #endif
 
 posix_mkdir_out:
@@ -1370,7 +1374,8 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	struct TCP_Server_Info *server;
 	char *full_path;
 
-	cFYI(1, "In cifs_mkdir, mode = 0x%hx inode = 0x%p", mode, inode);
+	cifs_dbg(FYI, "In cifs_mkdir, mode = 0x%hx inode = 0x%p\n",
+		 mode, inode);
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
@@ -1404,7 +1409,7 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, umode_t mode)
 	/* BB add setting the equivalent of mode via CreateX w/ACLs */
 	rc = server->ops->mkdir(xid, tcon, full_path, cifs_sb);
 	if (rc) {
-		cFYI(1, "cifs_mkdir returned 0x%x", rc);
+		cifs_dbg(FYI, "cifs_mkdir returned 0x%x\n", rc);
 		d_drop(direntry);
 		goto mkdir_out;
 	}
@@ -1434,7 +1439,7 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	char *full_path = NULL;
 	struct cifsInodeInfo *cifsInode;
 
-	cFYI(1, "cifs_rmdir, inode = 0x%p", inode);
+	cifs_dbg(FYI, "cifs_rmdir, inode = 0x%p\n", inode);
 
 	xid = get_xid();
 
@@ -1683,8 +1688,8 @@ cifs_invalidate_mapping(struct inode *inode)
 	if (inode->i_mapping && inode->i_mapping->nrpages != 0) {
 		rc = invalidate_inode_pages2(inode->i_mapping);
 		if (rc) {
-			cERROR(1, "%s: could not invalidate inode %p", __func__,
-			       inode);
+			cifs_dbg(VFS, "%s: could not invalidate inode %p\n",
+				 __func__, inode);
 			cifs_i->invalid_mapping = true;
 		}
 	}
@@ -1734,8 +1739,8 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 		goto out;
 	}
 
-	cFYI(1, "Update attributes: %s inode 0x%p count %d dentry: 0x%p d_time "
-		 "%ld jiffies %ld", full_path, inode, inode->i_count.counter,
+	cifs_dbg(FYI, "Update attributes: %s inode 0x%p count %d dentry: 0x%p d_time %ld jiffies %ld\n",
+		 full_path, inode, inode->i_count.counter,
 		 dentry, dentry->d_time, jiffies);
 
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
@@ -1885,7 +1890,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 		else
 			rc = -ENOSYS;
 		cifsFileInfo_put(open_file);
-		cFYI(1, "SetFSize for attrs rc = %d", rc);
+		cifs_dbg(FYI, "SetFSize for attrs rc = %d\n", rc);
 		if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			unsigned int bytes_written;
 
@@ -1896,7 +1901,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 			io_parms.length = attrs->ia_size;
 			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written,
 					  NULL, NULL, 1);
-			cFYI(1, "Wrt seteof rc %d", rc);
+			cifs_dbg(FYI, "Wrt seteof rc %d\n", rc);
 		}
 	} else
 		rc = -EINVAL;
@@ -1922,7 +1927,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 						attrs->ia_size, cifs_sb, false);
 	else
 		rc = -ENOSYS;
-	cFYI(1, "SetEOF by path (setattrs) rc = %d", rc);
+	cifs_dbg(FYI, "SetEOF by path (setattrs) rc = %d\n", rc);
 	if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 		__u16 netfid;
 		int oplock = 0;
@@ -1942,7 +1947,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 			io_parms.length = attrs->ia_size;
 			rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, NULL,
 					  NULL,  1);
-			cFYI(1, "wrt seteof rc %d", rc);
+			cifs_dbg(FYI, "wrt seteof rc %d\n", rc);
 			CIFSSMBClose(xid, tcon, netfid);
 		}
 	}
@@ -1973,7 +1978,7 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	struct cifs_unix_set_info_args *args = NULL;
 	struct cifsFileInfo *open_file;
 
-	cFYI(1, "setattr_unix on file %s attrs->ia_valid=0x%x",
+	cifs_dbg(FYI, "setattr_unix on file %s attrs->ia_valid=0x%x\n",
 		 direntry->d_name.name, attrs->ia_valid);
 
 	xid = get_xid();
@@ -2116,7 +2121,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	cFYI(1, "setattr on file %s attrs->iavalid 0x%x",
+	cifs_dbg(FYI, "setattr on file %s attrs->iavalid 0x%x\n",
 		 direntry->d_name.name, attrs->ia_valid);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
@@ -2168,8 +2173,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			rc = id_mode_to_cifs_acl(inode, full_path, NO_CHANGE_64,
 							uid, gid);
 			if (rc) {
-				cFYI(1, "%s: Setting id failed with error: %d",
-					__func__, rc);
+				cifs_dbg(FYI, "%s: Setting id failed with error: %d\n",
+					 __func__, rc);
 				goto cifs_setattr_exit;
 			}
 		}
@@ -2190,8 +2195,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 			rc = id_mode_to_cifs_acl(inode, full_path, mode,
 						INVALID_UID, INVALID_GID);
 			if (rc) {
-				cFYI(1, "%s: Setting ACL failed with error: %d",
-					__func__, rc);
+				cifs_dbg(FYI, "%s: Setting ACL failed with error: %d\n",
+					 __func__, rc);
 				goto cifs_setattr_exit;
 			}
 		} else
@@ -2279,7 +2284,7 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 #if 0
 void cifs_delete_inode(struct inode *inode)
 {
-	cFYI(1, "In cifs_delete_inode, inode = 0x%p", inode);
+	cifs_dbg(FYI, "In cifs_delete_inode, inode = 0x%p\n", inode);
 	/* may have to add back in if and when safe distributed caching of
 	   directories added e.g. via FindNotify */
 }
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 6c9f121..3e08455 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -44,7 +44,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 
 	xid = get_xid();
 
-	cFYI(1, "ioctl file %p  cmd %u  arg %lu", filep, command, arg);
+	cifs_dbg(FYI, "ioctl file %p  cmd %u  arg %lu\n", filep, command, arg);
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
@@ -83,11 +83,11 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				 *		       &ExtAttrMask);
 				 */
 			}
-			cFYI(1, "set flags not implemented yet");
+			cifs_dbg(FYI, "set flags not implemented yet\n");
 			break;
 #endif /* CONFIG_CIFS_POSIX */
 		default:
-			cFYI(1, "unsupported ioctl");
+			cifs_dbg(FYI, "unsupported ioctl\n");
 			break;
 	}
 
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 9f6c4c4..b83c3f5 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -56,14 +56,14 @@ symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
 	md5 = crypto_alloc_shash("md5", 0, 0);
 	if (IS_ERR(md5)) {
 		rc = PTR_ERR(md5);
-		cERROR(1, "%s: Crypto md5 allocation error %d", __func__, rc);
+		cifs_dbg(VFS, "%s: Crypto md5 allocation error %d\n",
+			 __func__, rc);
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
+		cifs_dbg(VFS, "%s: Could not init md5 shash\n", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_update(&sdescmd5->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with link_str", __func__);
+		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
 		goto symlink_hash_err;
 	}
 	rc = crypto_shash_final(&sdescmd5->shash, md5_hash);
 	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash", __func__);
+		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
 symlink_hash_err:
 	crypto_free_shash(md5);
@@ -115,7 +115,7 @@ CIFSParseMFSymlink(const u8 *buf,
 
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
-		cFYI(1, "%s: MD5 hash failure: %d", __func__, rc);
+		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
 		return rc;
 	}
 
@@ -154,7 +154,7 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
 
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
-		cFYI(1, "%s: MD5 hash failure: %d", __func__, rc);
+		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
 		return rc;
 	}
 
@@ -521,7 +521,7 @@ cifs_follow_link(struct dentry *direntry, struct nameidata *nd)
 	if (!full_path)
 		goto out;
 
-	cFYI(1, "Full path: %s inode = 0x%p", full_path, inode);
+	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n", full_path, inode);
 
 	rc = -EACCES;
 	/*
@@ -578,8 +578,8 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 		goto symlink_exit;
 	}
 
-	cFYI(1, "Full path: %s", full_path);
-	cFYI(1, "symname is %s", symname);
+	cifs_dbg(FYI, "Full path: %s\n", full_path);
+	cifs_dbg(FYI, "symname is %s\n", symname);
 
 	/* BB what if DFS and this volume is on different share? BB */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
@@ -601,8 +601,8 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 						 inode->i_sb, xid, NULL);
 
 		if (rc != 0) {
-			cFYI(1, "Create symlink ok, getinodeinfo fail rc = %d",
-			      rc);
+			cifs_dbg(FYI, "Create symlink ok, getinodeinfo fail rc = %d\n",
+				 rc);
 		} else {
 			d_instantiate(direntry, newinode);
 		}
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1b15bf8..1bec014 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -54,7 +54,7 @@ _get_xid(void)
 	if (GlobalTotalActiveXid > GlobalMaxActiveXid)
 		GlobalMaxActiveXid = GlobalTotalActiveXid;
 	if (GlobalTotalActiveXid > 65000)
-		cFYI(1, "warning: more than 65000 requests active");
+		cifs_dbg(FYI, "warning: more than 65000 requests active\n");
 	xid = GlobalCurrentXid++;
 	spin_unlock(&GlobalMid_Lock);
 	return xid;
@@ -91,7 +91,7 @@ void
 sesInfoFree(struct cifs_ses *buf_to_free)
 {
 	if (buf_to_free == NULL) {
-		cFYI(1, "Null buffer passed to sesInfoFree");
+		cifs_dbg(FYI, "Null buffer passed to sesInfoFree\n");
 		return;
 	}
 
@@ -130,7 +130,7 @@ void
 tconInfoFree(struct cifs_tcon *buf_to_free)
 {
 	if (buf_to_free == NULL) {
-		cFYI(1, "Null buffer passed to tconInfoFree");
+		cifs_dbg(FYI, "Null buffer passed to tconInfoFree\n");
 		return;
 	}
 	atomic_dec(&tconInfoAllocCount);
@@ -180,7 +180,7 @@ void
 cifs_buf_release(void *buf_to_free)
 {
 	if (buf_to_free == NULL) {
-		/* cFYI(1, "Null buffer passed to cifs_buf_release");*/
+		/* cifs_dbg(FYI, "Null buffer passed to cifs_buf_release\n");*/
 		return;
 	}
 	mempool_free(buf_to_free, cifs_req_poolp);
@@ -216,7 +216,7 @@ cifs_small_buf_release(void *buf_to_free)
 {
 
 	if (buf_to_free == NULL) {
-		cFYI(1, "Null buffer passed to cifs_small_buf_release");
+		cifs_dbg(FYI, "Null buffer passed to cifs_small_buf_release\n");
 		return;
 	}
 	mempool_free(buf_to_free, cifs_sm_req_poolp);
@@ -282,15 +282,15 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 {
 	/* does it have the right SMB "signature" ? */
 	if (*(__le32 *) smb->Protocol != cpu_to_le32(0x424d53ff)) {
-		cERROR(1, "Bad protocol string signature header 0x%x",
-			*(unsigned int *)smb->Protocol);
+		cifs_dbg(VFS, "Bad protocol string signature header 0x%x\n",
+			 *(unsigned int *)smb->Protocol);
 		return 1;
 	}
 
 	/* Make sure that message ids match */
 	if (mid != smb->Mid) {
-		cERROR(1, "Mids do not match. received=%u expected=%u",
-			smb->Mid, mid);
+		cifs_dbg(VFS, "Mids do not match. received=%u expected=%u\n",
+			 smb->Mid, mid);
 		return 1;
 	}
 
@@ -302,7 +302,7 @@ check_smb_hdr(struct smb_hdr *smb, __u16 mid)
 	if (smb->Command == SMB_COM_LOCKING_ANDX)
 		return 0;
 
-	cERROR(1, "Server sent request, not response. mid=%u", smb->Mid);
+	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n", smb->Mid);
 	return 1;
 }
 
@@ -313,8 +313,8 @@ checkSMB(char *buf, unsigned int total_read)
 	__u16 mid = smb->Mid;
 	__u32 rfclen = be32_to_cpu(smb->smb_buf_length);
 	__u32 clc_len;  /* calculated length */
-	cFYI(0, "checkSMB Length: 0x%x, smb_buf_length: 0x%x",
-		total_read, rfclen);
+	cifs_dbg(FYI, "checkSMB Length: 0x%x, smb_buf_length: 0x%x\n",
+		 total_read, rfclen);
 
 	/* is this frame too small to even get to a BCC? */
 	if (total_read < 2 + sizeof(struct smb_hdr)) {
@@ -340,9 +340,9 @@ checkSMB(char *buf, unsigned int total_read)
 				tmp[sizeof(struct smb_hdr)+1] = 0;
 				return 0;
 			}
-			cERROR(1, "rcvd invalid byte count (bcc)");
+			cifs_dbg(VFS, "rcvd invalid byte count (bcc)\n");
 		} else {
-			cERROR(1, "Length less than smb header size");
+			cifs_dbg(VFS, "Length less than smb header size\n");
 		}
 		return -EIO;
 	}
@@ -353,8 +353,8 @@ checkSMB(char *buf, unsigned int total_read)
 	clc_len = smbCalcSize(smb);
 
 	if (4 + rfclen != total_read) {
-		cERROR(1, "Length read does not match RFC1001 length %d",
-				rfclen);
+		cifs_dbg(VFS, "Length read does not match RFC1001 length %d\n",
+			 rfclen);
 		return -EIO;
 	}
 
@@ -365,12 +365,12 @@ checkSMB(char *buf, unsigned int total_read)
 			if (((4 + rfclen) & 0xFFFF) == (clc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
-		cFYI(1, "Calculated size %u vs length %u mismatch for mid=%u",
-				clc_len, 4 + rfclen, smb->Mid);
+		cifs_dbg(FYI, "Calculated size %u vs length %u mismatch for mid=%u\n",
+			 clc_len, 4 + rfclen, smb->Mid);
 
 		if (4 + rfclen < clc_len) {
-			cERROR(1, "RFC1001 size %u smaller than SMB for mid=%u",
-					rfclen, smb->Mid);
+			cifs_dbg(VFS, "RFC1001 size %u smaller than SMB for mid=%u\n",
+				 rfclen, smb->Mid);
 			return -EIO;
 		} else if (rfclen > clc_len + 512) {
 			/*
@@ -382,8 +382,8 @@ checkSMB(char *buf, unsigned int total_read)
 			 * trailing data, we choose limit the amount of extra
 			 * data to 512 bytes.
 			 */
-			cERROR(1, "RFC1001 size %u more than 512 bytes larger "
-				  "than SMB for mid=%u", rfclen, smb->Mid);
+			cifs_dbg(VFS, "RFC1001 size %u more than 512 bytes larger than SMB for mid=%u\n",
+				 rfclen, smb->Mid);
 			return -EIO;
 		}
 	}
@@ -401,7 +401,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	struct cifsInodeInfo *pCifsInode;
 	struct cifsFileInfo *netfile;
 
-	cFYI(1, "Checking for oplock break or dnotify response");
+	cifs_dbg(FYI, "Checking for oplock break or dnotify response\n");
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
 	   (pSMB->hdr.Flags & SMBFLG_RESPONSE)) {
 		struct smb_com_transaction_change_notify_rsp *pSMBr =
@@ -413,15 +413,15 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 
 			pnotify = (struct file_notify_information *)
 				((char *)&pSMBr->hdr.Protocol + data_offset);
-			cFYI(1, "dnotify on %s Action: 0x%x",
+			cifs_dbg(FYI, "dnotify on %s Action: 0x%x\n",
 				 pnotify->FileName, pnotify->Action);
 			/*   cifs_dump_mem("Rcvd notify Data: ",buf,
 				sizeof(struct smb_hdr)+60); */
 			return true;
 		}
 		if (pSMBr->hdr.Status.CifsError) {
-			cFYI(1, "notify err 0x%d",
-				pSMBr->hdr.Status.CifsError);
+			cifs_dbg(FYI, "notify err 0x%d\n",
+				 pSMBr->hdr.Status.CifsError);
 			return true;
 		}
 		return false;
@@ -435,7 +435,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 		   large dirty files cached on the client */
 		if ((NT_STATUS_INVALID_HANDLE) ==
 		   le32_to_cpu(pSMB->hdr.Status.CifsError)) {
-			cFYI(1, "invalid handle on oplock break");
+			cifs_dbg(FYI, "invalid handle on oplock break\n");
 			return true;
 		} else if (ERRbadfid ==
 		   le16_to_cpu(pSMB->hdr.Status.DosError.Error)) {
@@ -447,7 +447,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	if (pSMB->hdr.WordCount != 8)
 		return false;
 
-	cFYI(1, "oplock type 0x%d level 0x%d",
+	cifs_dbg(FYI, "oplock type 0x%d level 0x%d\n",
 		 pSMB->LockType, pSMB->OplockLevel);
 	if (!(pSMB->LockType & LOCKING_ANDX_OPLOCK_RELEASE))
 		return false;
@@ -469,7 +469,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 				if (pSMB->Fid != netfile->fid.netfid)
 					continue;
 
-				cFYI(1, "file id match, oplock break");
+				cifs_dbg(FYI, "file id match, oplock break\n");
 				pCifsInode = CIFS_I(netfile->dentry->d_inode);
 
 				cifs_set_oplock_level(pCifsInode,
@@ -484,12 +484,12 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 			}
 			spin_unlock(&cifs_file_list_lock);
 			spin_unlock(&cifs_tcp_ses_lock);
-			cFYI(1, "No matching file for oplock break");
+			cifs_dbg(FYI, "No matching file for oplock break\n");
 			return true;
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	cFYI(1, "Can not process oplock break for non-existent connection");
+	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
 	return true;
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
+		cifs_dbg(VFS, "Autodisabling the use of server inode numbers on %s. This server doesn't seem to support them properly. Hardlinks will not be recognized on this mount. Consider mounting with the \"noserverino\" option to silence this message.\n",
+			 cifs_sb_master_tcon(cifs_sb)->treeName);
 	}
 }
 
@@ -552,13 +548,13 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 	if (oplock == OPLOCK_EXCLUSIVE) {
 		cinode->clientCanCacheAll = true;
 		cinode->clientCanCacheRead = true;
-		cFYI(1, "Exclusive Oplock granted on inode %p",
-		     &cinode->vfs_inode);
+		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
 	} else if (oplock == OPLOCK_READ) {
 		cinode->clientCanCacheAll = false;
 		cinode->clientCanCacheRead = true;
-		cFYI(1, "Level II Oplock granted on inode %p",
-		    &cinode->vfs_inode);
+		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
 	} else {
 		cinode->clientCanCacheAll = false;
 		cinode->clientCanCacheRead = false;
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index a82bc51..aefe8b4 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -150,8 +150,8 @@ cifs_inet_pton(const int address_family, const char *cp, int len, void *dst)
 	else if (address_family == AF_INET6)
 		ret = in6_pton(cp, len, dst , '\\', NULL);
 
-	cFYI(DBG2, "address conversion returned %d for %*.*s",
-	     ret, len, len, cp);
+	cifs_dbg(NOISY, "address conversion returned %d for %*.*s\n",
+		 ret, len, len, cp);
 	if (ret > 0)
 		ret = 1;
 	return ret;
@@ -887,7 +887,7 @@ map_smb_to_linux_error(char *buf, bool logErr)
 	}
 	/* else ERRHRD class errors or junk  - return EIO */
 
-	cFYI(1, "Mapping smb error code 0x%x to POSIX err %d",
+	cifs_dbg(FYI, "Mapping smb error code 0x%x to POSIX err %d\n",
 		 le32_to_cpu(smb->Status.CifsError), rc);
 
 	/* generic corrective action e.g. reconnect SMB session on
@@ -951,20 +951,20 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 	SMB_TIME *st = (SMB_TIME *)&time;
 	SMB_DATE *sd = (SMB_DATE *)&date;
 
-	cFYI(1, "date %d time %d", date, time);
+	cifs_dbg(FYI, "date %d time %d\n", date, time);
 
 	sec = 2 * st->TwoSeconds;
 	min = st->Minutes;
 	if ((sec > 59) || (min > 59))
-		cERROR(1, "illegal time min %d sec %d", min, sec);
+		cifs_dbg(VFS, "illegal time min %d sec %d\n", min, sec);
 	sec += (min * 60);
 	sec += 60 * 60 * st->Hours;
 	if (st->Hours > 24)
-		cERROR(1, "illegal hours %d", st->Hours);
+		cifs_dbg(VFS, "illegal hours %d\n", st->Hours);
 	days = sd->Day;
 	month = sd->Month;
 	if ((days > 31) || (month > 12)) {
-		cERROR(1, "illegal date, month %d day: %d", month, days);
+		cifs_dbg(VFS, "illegal date, month %d day: %d\n", month, days);
 		if (month > 12)
 			month = 12;
 	}
@@ -990,7 +990,7 @@ struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time, int offset)
 
 	ts.tv_sec = sec + offset;
 
-	/* cFYI(1, "sec after cnvrt dos to unix time %d",sec); */
+	/* cifs_dbg(FYI, "sec after cnvrt dos to unix time %d\n",sec); */
 
 	ts.tv_nsec = 0;
 	return ts;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index df40cc5..770d5a9 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -48,15 +48,15 @@ static void dump_cifs_file_struct(struct file *file, char *label)
 	if (file) {
 		cf = file->private_data;
 		if (cf == NULL) {
-			cFYI(1, "empty cifs private file data");
+			cifs_dbg(FYI, "empty cifs private file data\n");
 			return;
 		}
 		if (cf->invalidHandle)
-			cFYI(1, "invalid handle");
+			cifs_dbg(FYI, "invalid handle\n");
 		if (cf->srch_inf.endOfSearch)
-			cFYI(1, "end of search");
+			cifs_dbg(FYI, "end of search\n");
 		if (cf->srch_inf.emptyDir)
-			cFYI(1, "empty dir");
+			cifs_dbg(FYI, "empty dir\n");
 	}
 }
 #else
@@ -80,7 +80,7 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 	struct super_block *sb = parent->d_inode->i_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
-	cFYI(1, "%s: for %s", __func__, name->name);
+	cifs_dbg(FYI, "%s: for %s\n", __func__, name->name);
 
 	dentry = d_hash_and_lookup(parent, name);
 	if (unlikely(IS_ERR(dentry)))
@@ -233,7 +233,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 				fid,
 				cifs_sb->local_nls);
 		if (CIFSSMBClose(xid, ptcon, fid)) {
-			cFYI(1, "Error closing temporary reparsepoint open");
+			cifs_dbg(FYI, "Error closing temporary reparsepoint open\n");
 		}
 	}
 }
@@ -285,7 +285,7 @@ initiate_cifs_search(const unsigned int xid, struct file *file)
 		goto error_exit;
 	}
 
-	cFYI(1, "Full path: %s start at: %lld", full_path, file->f_pos);
+	cifs_dbg(FYI, "Full path: %s start at: %lld\n", full_path, file->f_pos);
 
 ffirst_retry:
 	/* test for Unix extensions */
@@ -336,7 +336,7 @@ static int cifs_unicode_bytelen(const char *str)
 		if (ustr[len] == 0)
 			return len << 1;
 	}
-	cFYI(1, "Unicode string longer than PATH_MAX found");
+	cifs_dbg(FYI, "Unicode string longer than PATH_MAX found\n");
 	return len << 1;
 }
 
@@ -353,18 +353,18 @@ static char *nxt_dir_entry(char *old_entry, char *end_of_smb, int level)
 				pfData->FileNameLength;
 	} else
 		new_entry = old_entry + le32_to_cpu(pDirInfo->NextEntryOffset);
-	cFYI(1, "new entry %p old entry %p", new_entry, old_entry);
+	cifs_dbg(FYI, "new entry %p old entry %p\n", new_entry, old_entry);
 	/* validate that new_entry is not past end of SMB */
 	if (new_entry >= end_of_smb) {
-		cERROR(1, "search entry %p began after end of SMB %p old entry %p",
-			new_entry, end_of_smb, old_entry);
+		cifs_dbg(VFS, "search entry %p began after end of SMB %p old entry %p\n",
+			 new_entry, end_of_smb, old_entry);
 		return NULL;
 	} else if (((level == SMB_FIND_FILE_INFO_STANDARD) &&
 		    (new_entry + sizeof(FIND_FILE_STANDARD_INFO) > end_of_smb))
 		  || ((level != SMB_FIND_FILE_INFO_STANDARD) &&
 		   (new_entry + sizeof(FILE_DIRECTORY_INFO) > end_of_smb)))  {
-		cERROR(1, "search entry %p extends after end of SMB %p",
-			new_entry, end_of_smb);
+		cifs_dbg(VFS, "search entry %p extends after end of SMB %p\n",
+			 new_entry, end_of_smb);
 		return NULL;
 	} else
 		return new_entry;
@@ -457,7 +457,7 @@ static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
 		cifs_fill_dirent_std(de, info);
 		break;
 	default:
-		cFYI(1, "Unknown findfirst level %d", level);
+		cifs_dbg(FYI, "Unknown findfirst level %d\n", level);
 		return -EINVAL;
 	}
 
@@ -572,7 +572,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 	if (((index_to_find < cfile->srch_inf.index_of_last_entry) &&
 	     is_dir_changed(file)) || (index_to_find < first_entry_in_buffer)) {
 		/* close and restart search */
-		cFYI(1, "search backing up - close and restart search");
+		cifs_dbg(FYI, "search backing up - close and restart search\n");
 		spin_lock(&cifs_file_list_lock);
 		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
 			cfile->invalidHandle = true;
@@ -582,7 +582,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cfile->srch_inf.ntwrk_buf_start) {
-			cFYI(1, "freeing SMB ff cache buf on search rewind");
+			cifs_dbg(FYI, "freeing SMB ff cache buf on search rewind\n");
 			if (cfile->srch_inf.smallBuf)
 				cifs_small_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
@@ -593,7 +593,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		rc = initiate_cifs_search(xid, file);
 		if (rc) {
-			cFYI(1, "error %d reinitiating a search on rewind",
+			cifs_dbg(FYI, "error %d reinitiating a search on rewind\n",
 				 rc);
 			return rc;
 		}
@@ -608,7 +608,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 
 	while ((index_to_find >= cfile->srch_inf.index_of_last_entry) &&
 	       (rc == 0) && !cfile->srch_inf.endOfSearch) {
-		cFYI(1, "calling findnext2");
+		cifs_dbg(FYI, "calling findnext2\n");
 		rc = server->ops->query_dir_next(xid, tcon, &cfile->fid,
 						 search_flags,
 						 &cfile->srch_inf);
@@ -631,7 +631,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 		first_entry_in_buffer = cfile->srch_inf.index_of_last_entry
 					- cfile->srch_inf.entries_in_buffer;
 		pos_in_buf = index_to_find - first_entry_in_buffer;
-		cFYI(1, "found entry - pos_in_buf %d", pos_in_buf);
+		cifs_dbg(FYI, "found entry - pos_in_buf %d\n", pos_in_buf);
 
 		for (i = 0; (i < (pos_in_buf)) && (cur_ent != NULL); i++) {
 			/* go entry by entry figuring out which is first */
@@ -640,19 +640,18 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		if ((cur_ent == NULL) && (i < pos_in_buf)) {
 			/* BB fixme - check if we should flag this error */
-			cERROR(1, "reached end of buf searching for pos in buf"
-				  " %d index to find %lld rc %d", pos_in_buf,
-				  index_to_find, rc);
+			cifs_dbg(VFS, "reached end of buf searching for pos in buf %d index to find %lld rc %d\n",
+				 pos_in_buf, index_to_find, rc);
 		}
 		rc = 0;
 		*current_entry = cur_ent;
 	} else {
-		cFYI(1, "index not in buffer - could not findnext into it");
+		cifs_dbg(FYI, "index not in buffer - could not findnext into it\n");
 		return 0;
 	}
 
 	if (pos_in_buf >= cfile->srch_inf.entries_in_buffer) {
-		cFYI(1, "can not return entries pos_in_buf beyond last");
+		cifs_dbg(FYI, "can not return entries pos_in_buf beyond last\n");
 		*num_to_ret = 0;
 	} else
 		*num_to_ret = cfile->srch_inf.entries_in_buffer - pos_in_buf;
@@ -678,8 +677,8 @@ static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
 		return rc;
 
 	if (de.namelen > max_len) {
-		cERROR(1, "bad search response length %zd past smb end",
-			  de.namelen);
+		cifs_dbg(VFS, "bad search response length %zd past smb end\n",
+			 de.namelen);
 		return -EINVAL;
 	}
 
@@ -768,7 +767,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	 */
 	if (file->private_data == NULL) {
 		rc = initiate_cifs_search(xid, file);
-		cFYI(1, "initiate cifs search rc %d", rc);
+		cifs_dbg(FYI, "initiate cifs search rc %d\n", rc);
 		if (rc)
 			goto rddir2_exit;
 	}
@@ -777,7 +776,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	case 0:
 		if (filldir(direntry, ".", 1, file->f_pos,
 		     file_inode(file)->i_ino, DT_DIR) < 0) {
-			cERROR(1, "Filldir for current dir failed");
+			cifs_dbg(VFS, "Filldir for current dir failed\n");
 			rc = -ENOMEM;
 			break;
 		}
@@ -785,7 +784,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	case 1:
 		if (filldir(direntry, "..", 2, file->f_pos,
 		     parent_ino(file->f_path.dentry), DT_DIR) < 0) {
-			cERROR(1, "Filldir for parent dir failed");
+			cifs_dbg(VFS, "Filldir for parent dir failed\n");
 			rc = -ENOMEM;
 			break;
 		}
@@ -804,7 +803,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		cifsFile = file->private_data;
 		if (cifsFile->srch_inf.endOfSearch) {
 			if (cifsFile->srch_inf.emptyDir) {
-				cFYI(1, "End of search, empty dir");
+				cifs_dbg(FYI, "End of search, empty dir\n");
 				rc = 0;
 				break;
 			}
@@ -817,16 +816,16 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		rc = find_cifs_entry(xid, tcon, file, &current_entry,
 				     &num_to_fill);
 		if (rc) {
-			cFYI(1, "fce error %d", rc);
+			cifs_dbg(FYI, "fce error %d\n", rc);
 			goto rddir2_exit;
 		} else if (current_entry != NULL) {
-			cFYI(1, "entry %lld found", file->f_pos);
+			cifs_dbg(FYI, "entry %lld found\n", file->f_pos);
 		} else {
-			cFYI(1, "could not find entry");
+			cifs_dbg(FYI, "could not find entry\n");
 			goto rddir2_exit;
 		}
-		cFYI(1, "loop through %d times filling dir for net buf %p",
-			num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
+		cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n",
+			 num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
 		max_len = tcon->ses->server->ops->calc_smb_size(
 				cifsFile->srch_inf.ntwrk_buf_start);
 		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
@@ -840,8 +839,8 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
 			if (current_entry == NULL) {
 				/* evaluate whether this case is an error */
-				cERROR(1, "past SMB end,  num to fill %d i %d",
-					  num_to_fill, i);
+				cifs_dbg(VFS, "past SMB end,  num to fill %d i %d\n",
+					 num_to_fill, i);
 				break;
 			}
 			/*
@@ -858,8 +857,8 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			file->f_pos++;
 			if (file->f_pos ==
 				cifsFile->srch_inf.index_of_last_entry) {
-				cFYI(1, "last entry in buf at pos %lld %s",
-					file->f_pos, tmp_buf);
+				cifs_dbg(FYI, "last entry in buf at pos %lld %s\n",
+					 file->f_pos, tmp_buf);
 				cifs_save_resume_key(current_entry, cifsFile);
 				break;
 			} else
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 76809f4..06c8644 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -283,11 +283,11 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 	int len;
 	char *data = *pbcc_area;
 
-	cFYI(1, "bleft %d", bleft);
+	cifs_dbg(FYI, "bleft %d\n", bleft);
 
 	kfree(ses->serverOS);
 	ses->serverOS = cifs_strndup_from_utf16(data, bleft, true, nls_cp);
-	cFYI(1, "serverOS=%s", ses->serverOS);
+	cifs_dbg(FYI, "serverOS=%s\n", ses->serverOS);
 	len = (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + 2;
 	data += len;
 	bleft -= len;
@@ -296,7 +296,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 
 	kfree(ses->serverNOS);
 	ses->serverNOS = cifs_strndup_from_utf16(data, bleft, true, nls_cp);
-	cFYI(1, "serverNOS=%s", ses->serverNOS);
+	cifs_dbg(FYI, "serverNOS=%s\n", ses->serverNOS);
 	len = (UniStrnlen((wchar_t *) data, bleft / 2) * 2) + 2;
 	data += len;
 	bleft -= len;
@@ -305,7 +305,7 @@ decode_unicode_ssetup(char **pbcc_area, int bleft, struct cifs_ses *ses,
 
 	kfree(ses->serverDomain);
 	ses->serverDomain = cifs_strndup_from_utf16(data, bleft, true, nls_cp);
-	cFYI(1, "serverDomain=%s", ses->serverDomain);
+	cifs_dbg(FYI, "serverDomain=%s\n", ses->serverDomain);
 
 	return;
 }
@@ -318,7 +318,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	int len;
 	char *bcc_ptr = *pbcc_area;
 
-	cFYI(1, "decode sessetup ascii. bleft %d", bleft);
+	cifs_dbg(FYI, "decode sessetup ascii. bleft %d\n", bleft);
 
 	len = strnlen(bcc_ptr, bleft);
 	if (len >= bleft)
@@ -330,7 +330,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	if (ses->serverOS)
 		strncpy(ses->serverOS, bcc_ptr, len);
 	if (strncmp(ses->serverOS, "OS/2", 4) == 0) {
-			cFYI(1, "OS/2 server");
+		cifs_dbg(FYI, "OS/2 server\n");
 			ses->flags |= CIFS_SES_OS2;
 	}
 
@@ -359,7 +359,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	/* BB For newer servers which do not support Unicode,
 	   but thus do return domain here we could add parsing
 	   for it later, but it is not very important */
-	cFYI(1, "ascii: bytes left %d", bleft);
+	cifs_dbg(FYI, "ascii: bytes left %d\n", bleft);
 
 	return rc;
 }
@@ -373,16 +373,18 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	CHALLENGE_MESSAGE *pblob = (CHALLENGE_MESSAGE *)bcc_ptr;
 
 	if (blob_len < sizeof(CHALLENGE_MESSAGE)) {
-		cERROR(1, "challenge blob len %d too small", blob_len);
+		cifs_dbg(VFS, "challenge blob len %d too small\n", blob_len);
 		return -EINVAL;
 	}
 
 	if (memcmp(pblob->Signature, "NTLMSSP", 8)) {
-		cERROR(1, "blob signature incorrect %s", pblob->Signature);
+		cifs_dbg(VFS, "blob signature incorrect %s\n",
+			 pblob->Signature);
 		return -EINVAL;
 	}
 	if (pblob->MessageType != NtLmChallenge) {
-		cERROR(1, "Incorrect message type %d", pblob->MessageType);
+		cifs_dbg(VFS, "Incorrect message type %d\n",
+			 pblob->MessageType);
 		return -EINVAL;
 	}
 
@@ -395,15 +397,15 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	tioffset = le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
 	tilen = le16_to_cpu(pblob->TargetInfoArray.Length);
 	if (tioffset > blob_len || tioffset + tilen > blob_len) {
-		cERROR(1, "tioffset + tilen too high %u + %u", tioffset, tilen);
+		cifs_dbg(VFS, "tioffset + tilen too high %u + %u\n",
+			 tioffset, tilen);
 		return -EINVAL;
 	}
 	if (tilen) {
 		ses->auth_key.response = kmalloc(tilen, GFP_KERNEL);
-		if (!ses->auth_key.response) {
-			cERROR(1, "Challenge target info allocation failure");
+		if (!ses->auth_key.response)
 			return -ENOMEM;
-		}
+
 		memcpy(ses->auth_key.response, bcc_ptr + tioffset, tilen);
 		ses->auth_key.len = tilen;
 	}
@@ -486,7 +488,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 	sec_blob->NtChallengeResponse.BufferOffset = cpu_to_le32(tmp - pbuffer);
 	rc = setup_ntlmv2_rsp(ses, nls_cp);
 	if (rc) {
-		cERROR(1, "Error %d during NTLMSSP authentication", rc);
+		cifs_dbg(VFS, "Error %d during NTLMSSP authentication\n", rc);
 		goto setup_ntlmv2_ret;
 	}
 	memcpy(tmp, ses->auth_key.response + CIFS_SESS_KEY_SIZE,
@@ -580,7 +582,7 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 		return -EINVAL;
 
 	type = ses->server->secType;
-	cFYI(1, "sess setup type %d", type);
+	cifs_dbg(FYI, "sess setup type %d\n", type);
 	if (type == RawNTLMSSP) {
 		/* if memory allocation is successful, caller of this function
 		 * frees it.
@@ -674,7 +676,7 @@ ssetup_ntlmssp_authenticate:
 		changed to do higher than lanman dialect and
 		we reconnected would we ever calc signing_key? */
 
-		cFYI(1, "Negotiating LANMAN setting up strings");
+		cifs_dbg(FYI, "Negotiating LANMAN setting up strings\n");
 		/* Unicode not allowed for LANMAN dialects */
 		ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
 #endif
@@ -688,7 +690,8 @@ ssetup_ntlmssp_authenticate:
 		/* calculate ntlm response and session key */
 		rc = setup_ntlm_response(ses, nls_cp);
 		if (rc) {
-			cERROR(1, "Error %d during NTLM authentication", rc);
+			cifs_dbg(VFS, "Error %d during NTLM authentication\n",
+				 rc);
 			goto ssetup_exit;
 		}
 
@@ -718,7 +721,8 @@ ssetup_ntlmssp_authenticate:
 		/* calculate nlmv2 response and session key */
 		rc = setup_ntlmv2_rsp(ses, nls_cp);
 		if (rc) {
-			cERROR(1, "Error %d during NTLMv2 authentication", rc);
+			cifs_dbg(VFS, "Error %d during NTLMv2 authentication\n",
+				 rc);
 			goto ssetup_exit;
 		}
 		memcpy(bcc_ptr, ses->auth_key.response + CIFS_SESS_KEY_SIZE,
@@ -754,17 +758,14 @@ ssetup_ntlmssp_authenticate:
 		/* check version field to make sure that cifs.upcall is
 		   sending us a response in an expected form */
 		if (msg->version != CIFS_SPNEGO_UPCALL_VERSION) {
-			cERROR(1, "incorrect version of cifs.upcall (expected"
-				   " %d but got %d)",
-				   CIFS_SPNEGO_UPCALL_VERSION, msg->version);
+			cifs_dbg(VFS, "incorrect version of cifs.upcall (expected %d but got %d)\n",
+				 CIFS_SPNEGO_UPCALL_VERSION, msg->version);
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
@@ -790,18 +791,18 @@ ssetup_ntlmssp_authenticate:
 		/* BB: is this right? */
 			ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
 #else /* ! CONFIG_CIFS_UPCALL */
-		cERROR(1, "Kerberos negotiated but upcall support disabled!");
+		cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
 		rc = -ENOSYS;
 		goto ssetup_exit;
 #endif /* CONFIG_CIFS_UPCALL */
 	} else if (type == RawNTLMSSP) {
 		if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-			cERROR(1, "NTLMSSP requires Unicode support");
+			cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
 			rc = -ENOSYS;
 			goto ssetup_exit;
 		}
 
-		cFYI(1, "ntlmssp session setup phase %d", phase);
+		cifs_dbg(FYI, "ntlmssp session setup phase %d\n", phase);
 		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
 		capabilities |= CAP_EXTENDED_SECURITY;
 		pSMB->req.Capabilities |= cpu_to_le32(capabilities);
@@ -824,7 +825,6 @@ ssetup_ntlmssp_authenticate:
 				5*sizeof(struct _AUTHENTICATE_MESSAGE),
 				GFP_KERNEL);
 			if (!ntlmsspblob) {
-				cERROR(1, "Can't allocate NTLMSSP blob");
 				rc = -ENOMEM;
 				goto ssetup_exit;
 			}
@@ -844,7 +844,7 @@ ssetup_ntlmssp_authenticate:
 			smb_buf->Uid = ses->Suid;
 			break;
 		default:
-			cERROR(1, "invalid phase %d", phase);
+			cifs_dbg(VFS, "invalid phase %d\n", phase);
 			rc = -ENOSYS;
 			goto ssetup_exit;
 		}
@@ -855,7 +855,7 @@ ssetup_ntlmssp_authenticate:
 		}
 		unicode_oslm_strings(&bcc_ptr, nls_cp);
 	} else {
-		cERROR(1, "secType %d not supported!", type);
+		cifs_dbg(VFS, "secType %d not supported!\n", type);
 		rc = -ENOSYS;
 		goto ssetup_exit;
 	}
@@ -880,7 +880,7 @@ ssetup_ntlmssp_authenticate:
 	    (smb_buf->Status.CifsError ==
 			cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))) {
 		if (phase != NtLmNegotiate) {
-			cERROR(1, "Unexpected more processing error");
+			cifs_dbg(VFS, "Unexpected more processing error\n");
 			goto ssetup_exit;
 		}
 		/* NTLMSSP Negotiate sent now processing challenge (response) */
@@ -892,14 +892,14 @@ ssetup_ntlmssp_authenticate:
 
 	if ((smb_buf->WordCount != 3) && (smb_buf->WordCount != 4)) {
 		rc = -EIO;
-		cERROR(1, "bad word count %d", smb_buf->WordCount);
+		cifs_dbg(VFS, "bad word count %d\n", smb_buf->WordCount);
 		goto ssetup_exit;
 	}
 	action = le16_to_cpu(pSMB->resp.Action);
 	if (action & GUEST_LOGIN)
-		cFYI(1, "Guest login"); /* BB mark SesInfo struct? */
+		cifs_dbg(FYI, "Guest login\n"); /* BB mark SesInfo struct? */
 	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
-	cFYI(1, "UID = %llu ", ses->Suid);
+	cifs_dbg(FYI, "UID = %llu\n", ses->Suid);
 	/* response can have either 3 or 4 word count - Samba sends 3 */
 	/* and lanman response is 3 */
 	bytes_remaining = get_bcc(smb_buf);
@@ -908,7 +908,8 @@ ssetup_ntlmssp_authenticate:
 	if (smb_buf->WordCount == 4) {
 		blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
 		if (blob_len > bytes_remaining) {
-			cERROR(1, "bad security blob length %d", blob_len);
+			cifs_dbg(VFS, "bad security blob length %d\n",
+				 blob_len);
 			rc = -EINVAL;
 			goto ssetup_exit;
 		}
@@ -946,7 +947,7 @@ ssetup_exit:
 	kfree(ntlmsspblob);
 	ntlmsspblob = NULL;
 	if (resp_buf_type == CIFS_SMALL_BUFFER) {
-		cFYI(1, "ssetup freeing small buf %p", iov[0].iov_base);
+		cifs_dbg(FYI, "ssetup freeing small buf %p\n", iov[0].iov_base);
 		cifs_small_buf_release(iov[0].iov_base);
 	} else if (resp_buf_type == CIFS_LARGE_BUFFER)
 		cifs_buf_release(iov[0].iov_base);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 47bc5a8..23bcd11 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -63,8 +63,8 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
 	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	mutex_unlock(&server->srv_mutex);
 
-	cFYI(1, "issued NT_CANCEL for mid %u, rc = %d",
-		in_buf->Mid, rc);
+	cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc = %d\n",
+		 in_buf->Mid, rc);
 
 	return rc;
 }
@@ -249,7 +249,7 @@ check2ndT2(char *buf)
 	/* check for plausible wct, bcc and t2 data and parm sizes */
 	/* check for parm and data offset going beyond end of smb */
 	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
-		cFYI(1, "invalid transact2 word count");
+		cifs_dbg(FYI, "invalid transact2 word count\n");
 		return -EINVAL;
 	}
 
@@ -261,18 +261,18 @@ check2ndT2(char *buf)
 	if (total_data_size == data_in_this_rsp)
 		return 0;
 	else if (total_data_size < data_in_this_rsp) {
-		cFYI(1, "total data %d smaller than data in frame %d",
-			total_data_size, data_in_this_rsp);
+		cifs_dbg(FYI, "total data %d smaller than data in frame %d\n",
+			 total_data_size, data_in_this_rsp);
 		return -EINVAL;
 	}
 
 	remaining = total_data_size - data_in_this_rsp;
 
-	cFYI(1, "missing %d bytes from transact2, check next response",
-		remaining);
+	cifs_dbg(FYI, "missing %d bytes from transact2, check next response\n",
+		 remaining);
 	if (total_data_size > CIFSMaxBufSize) {
-		cERROR(1, "TotalDataSize %d is over maximum buffer %d",
-			total_data_size, CIFSMaxBufSize);
+		cifs_dbg(VFS, "TotalDataSize %d is over maximum buffer %d\n",
+			 total_data_size, CIFSMaxBufSize);
 		return -EINVAL;
 	}
 	return remaining;
@@ -293,28 +293,28 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
 
 	if (tgt_total_cnt != src_total_cnt)
-		cFYI(1, "total data count of primary and secondary t2 differ "
-			"source=%hu target=%hu", src_total_cnt, tgt_total_cnt);
+		cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%hu\n",
+			 src_total_cnt, tgt_total_cnt);
 
 	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
 
 	remaining = tgt_total_cnt - total_in_tgt;
 
 	if (remaining < 0) {
-		cFYI(1, "Server sent too much data. tgt_total_cnt=%hu "
-			"total_in_tgt=%hu", tgt_total_cnt, total_in_tgt);
+		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%hu\n",
+			 tgt_total_cnt, total_in_tgt);
 		return -EPROTO;
 	}
 
 	if (remaining == 0) {
 		/* nothing to do, ignore */
-		cFYI(1, "no more data remains");
+		cifs_dbg(FYI, "no more data remains\n");
 		return 0;
 	}
 
 	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
 	if (remaining < total_in_src)
-		cFYI(1, "transact2 2nd response contains too much data");
+		cifs_dbg(FYI, "transact2 2nd response contains too much data\n");
 
 	/* find end of first SMB data area */
 	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
@@ -329,7 +329,8 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	total_in_tgt += total_in_src;
 	/* is the result too big for the field? */
 	if (total_in_tgt > USHRT_MAX) {
-		cFYI(1, "coalesced DataCount too large (%u)", total_in_tgt);
+		cifs_dbg(FYI, "coalesced DataCount too large (%u)\n",
+			 total_in_tgt);
 		return -EPROTO;
 	}
 	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
@@ -339,7 +340,7 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	byte_count += total_in_src;
 	/* is the result too big for the field? */
 	if (byte_count > USHRT_MAX) {
-		cFYI(1, "coalesced BCC too large (%u)", byte_count);
+		cifs_dbg(FYI, "coalesced BCC too large (%u)\n", byte_count);
 		return -EPROTO;
 	}
 	put_bcc(byte_count, target_hdr);
@@ -348,7 +349,8 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	byte_count += total_in_src;
 	/* don't allow buffer to overflow */
 	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4) {
-		cFYI(1, "coalesced BCC exceeds buffer size (%u)", byte_count);
+		cifs_dbg(FYI, "coalesced BCC exceeds buffer size (%u)\n",
+			 byte_count);
 		return -ENOBUFS;
 	}
 	target_hdr->smb_buf_length = cpu_to_be32(byte_count);
@@ -358,12 +360,12 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 
 	if (remaining != total_in_src) {
 		/* more responses to go */
-		cFYI(1, "waiting for more secondary responses");
+		cifs_dbg(FYI, "waiting for more secondary responses\n");
 		return 1;
 	}
 
 	/* we are done */
-	cFYI(1, "found the last secondary response");
+	cifs_dbg(FYI, "found the last secondary response\n");
 	return 0;
 }
 
@@ -388,7 +390,7 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	}
 	if (!server->large_buf) {
 		/*FIXME: switch to already allocated largebuf?*/
-		cERROR(1, "1st trans2 resp needs bigbuf");
+		cifs_dbg(VFS, "1st trans2 resp needs bigbuf\n");
 	} else {
 		/* Have first buffer */
 		mid->resp_buf = buf;
@@ -776,8 +778,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 			goto out;
 	}
 
-	cFYI(1, "calling SetFileInfo since SetPathInfo for times not supported "
-		"by this server");
+	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for times not supported by this server\n");
 	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_OPEN,
 			 SYNCHRONIZE | FILE_WRITE_ATTRIBUTES, CREATE_NOT_DIR,
 			 &netfid, &oplock, NULL, cifs_sb->local_nls,
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 71e6aed..5da1b55 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -43,13 +43,13 @@ smb2_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		cinode->clientCanCacheAll = true;
 		cinode->clientCanCacheRead = true;
-		cFYI(1, "Exclusive Oplock granted on inode %p",
-		     &cinode->vfs_inode);
+		cifs_dbg(FYI, "Exclusive Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
 	} else if (oplock == SMB2_OPLOCK_LEVEL_II) {
 		cinode->clientCanCacheAll = false;
 		cinode->clientCanCacheRead = true;
-		cFYI(1, "Level II Oplock granted on inode %p",
-		    &cinode->vfs_inode);
+		cifs_dbg(FYI, "Level II Oplock granted on inode %p\n",
+			 &cinode->vfs_inode);
 	} else {
 		cinode->clientCanCacheAll = false;
 		cinode->clientCanCacheRead = false;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 7064824..fff6dfb 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -92,7 +92,7 @@ smb2_open_op_close(const unsigned int xid, struct cifs_tcon *tcon,
 				      (FILE_BASIC_INFO *)data);
 		break;
 	default:
-		cERROR(1, "Invalid command");
+		cifs_dbg(VFS, "Invalid command\n");
 		break;
 	}
 
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 494c912..7c2f45c 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2472,7 +2472,7 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 
 	/* on error mapping not found  - return EIO */
 
-	cFYI(1, "Mapping SMB2 status code %d to POSIX err %d",
+	cifs_dbg(FYI, "Mapping SMB2 status code %d to POSIX err %d\n",
 		 smb2err, rc);
 
 	return rc;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b1c5e3..10383d8 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -45,17 +45,17 @@ check_smb2_hdr(struct smb2_hdr *hdr, __u64 mid)
 			if (hdr->Command == SMB2_OPLOCK_BREAK)
 				return 0;
 			else
-				cERROR(1, "Received Request not response");
+				cifs_dbg(VFS, "Received Request not response\n");
 		}
 	} else { /* bad signature or mid */
 		if (*(__le32 *)hdr->ProtocolId != SMB2_PROTO_NUMBER)
-			cERROR(1, "Bad protocol string signature header %x",
-				  *(unsigned int *) hdr->ProtocolId);
+			cifs_dbg(VFS, "Bad protocol string signature header %x\n",
+				 *(unsigned int *) hdr->ProtocolId);
 		if (mid != hdr->MessageId)
-			cERROR(1, "Mids do not match: %llu and %llu", mid,
-				  hdr->MessageId);
+			cifs_dbg(VFS, "Mids do not match: %llu and %llu\n",
+				 mid, hdr->MessageId);
 	}
-	cERROR(1, "Bad SMB detected. The Mid=%llu", hdr->MessageId);
+	cifs_dbg(VFS, "Bad SMB detected. The Mid=%llu\n", hdr->MessageId);
 	return 1;
 }
 
@@ -101,7 +101,8 @@ smb2_check_message(char *buf, unsigned int length)
 	int command;
 
 	/* BB disable following printk later */
-	cFYI(1, "%s length: 0x%x, smb_buf_length: 0x%x", __func__, length, len);
+	cifs_dbg(FYI, "%s length: 0x%x, smb_buf_length: 0x%x\n",
+		 __func__, length, len);
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
@@ -117,12 +118,13 @@ smb2_check_message(char *buf, unsigned int length)
 			 */
 			return 0;
 		} else {
-			cERROR(1, "Length less than SMB header size");
+			cifs_dbg(VFS, "Length less than SMB header size\n");
 		}
 		return 1;
 	}
 	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - 4) {
-		cERROR(1, "SMB length greater than maximum, mid=%llu", mid);
+		cifs_dbg(VFS, "SMB length greater than maximum, mid=%llu\n",
+			 mid);
 		return 1;
 	}
 
@@ -130,14 +132,14 @@ smb2_check_message(char *buf, unsigned int length)
 		return 1;
 
 	if (hdr->StructureSize != SMB2_HEADER_STRUCTURE_SIZE) {
-		cERROR(1, "Illegal structure size %u",
-			  le16_to_cpu(hdr->StructureSize));
+		cifs_dbg(VFS, "Illegal structure size %u\n",
+			 le16_to_cpu(hdr->StructureSize));
 		return 1;
 	}
 
 	command = le16_to_cpu(hdr->Command);
 	if (command >= NUMBER_OF_SMB2_COMMANDS) {
-		cERROR(1, "Illegal SMB2 command %d", command);
+		cifs_dbg(VFS, "Illegal SMB2 command %d\n", command);
 		return 1;
 	}
 
@@ -145,30 +147,30 @@ smb2_check_message(char *buf, unsigned int length)
 		if (command != SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0 ||
 		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2)) {
 			/* error packets have 9 byte structure size */
-			cERROR(1, "Illegal response size %u for command %d",
-				   le16_to_cpu(pdu->StructureSize2), command);
+			cifs_dbg(VFS, "Illegal response size %u for command %d\n",
+				 le16_to_cpu(pdu->StructureSize2), command);
 			return 1;
 		} else if (command == SMB2_OPLOCK_BREAK_HE && (hdr->Status == 0)
 			   && (le16_to_cpu(pdu->StructureSize2) != 44)
 			   && (le16_to_cpu(pdu->StructureSize2) != 36)) {
 			/* special case for SMB2.1 lease break message */
-			cERROR(1, "Illegal response size %d for oplock break",
-				   le16_to_cpu(pdu->StructureSize2));
+			cifs_dbg(VFS, "Illegal response size %d for oplock break\n",
+				 le16_to_cpu(pdu->StructureSize2));
 			return 1;
 		}
 	}
 
 	if (4 + len != length) {
-		cERROR(1, "Total length %u RFC1002 length %u mismatch mid %llu",
-			  length, 4 + len, mid);
+		cifs_dbg(VFS, "Total length %u RFC1002 length %u mismatch mid %llu\n",
+			 length, 4 + len, mid);
 		return 1;
 	}
 
 	clc_len = smb2_calc_size(hdr);
 
 	if (4 + len != clc_len) {
-		cFYI(1, "Calculated size %u length %u mismatch mid %llu",
-			clc_len, 4 + len, mid);
+		cifs_dbg(FYI, "Calculated size %u length %u mismatch mid %llu\n",
+			 clc_len, 4 + len, mid);
 		/* Windows 7 server returns 24 bytes more */
 		if (clc_len + 20 == len && command == SMB2_OPLOCK_BREAK_HE)
 			return 0;
@@ -267,7 +269,7 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	case SMB2_CHANGE_NOTIFY:
 	default:
 		/* BB FIXME for unimplemented cases above */
-		cERROR(1, "no length check for command");
+		cifs_dbg(VFS, "no length check for command\n");
 		break;
 	}
 
@@ -276,20 +278,20 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 	 * we have little choice but to ignore the data area in this case.
 	 */
 	if (*off > 4096) {
-		cERROR(1, "offset %d too large, data area ignored", *off);
+		cifs_dbg(VFS, "offset %d too large, data area ignored\n", *off);
 		*len = 0;
 		*off = 0;
 	} else if (*off < 0) {
-		cERROR(1, "negative offset %d to data invalid ignore data area",
-			  *off);
+		cifs_dbg(VFS, "negative offset %d to data invalid ignore data area\n",
+			 *off);
 		*off = 0;
 		*len = 0;
 	} else if (*len < 0) {
-		cERROR(1, "negative data length %d invalid, data area ignored",
-			  *len);
+		cifs_dbg(VFS, "negative data length %d invalid, data area ignored\n",
+			 *len);
 		*len = 0;
 	} else if (*len > 128 * 1024) {
-		cERROR(1, "data area larger than 128K: %d", *len);
+		cifs_dbg(VFS, "data area larger than 128K: %d\n", *len);
 		*len = 0;
 	}
 
@@ -324,7 +326,7 @@ smb2_calc_size(void *buf)
 		goto calc_size_exit;
 
 	smb2_get_data_area_len(&offset, &data_length, hdr);
-	cFYI(1, "SMB2 data length %d offset %d", data_length, offset);
+	cifs_dbg(FYI, "SMB2 data length %d offset %d\n", data_length, offset);
 
 	if (data_length > 0) {
 		/*
@@ -335,15 +337,15 @@ smb2_calc_size(void *buf)
 		 * the size of the RFC1001 hdr.
 		 */
 		if (offset + 4 + 1 < len) {
-			cERROR(1, "data area offset %d overlaps SMB2 header %d",
-				  offset + 4 + 1, len);
+			cifs_dbg(VFS, "data area offset %d overlaps SMB2 header %d\n",
+				 offset + 4 + 1, len);
 			data_length = 0;
 		} else {
 			len = 4 + offset + data_length;
 		}
 	}
 calc_size_exit:
-	cFYI(1, "SMB2 len %d", len);
+	cifs_dbg(FYI, "SMB2 len %d\n", len);
 	return len;
 }
 
@@ -405,7 +407,7 @@ cifs_ses_oplock_break(struct work_struct *work)
 
 	rc = SMB2_lease_break(0, tlink_tcon(lw->tlink), lw->lease_key,
 			      lw->lease_state);
-	cFYI(1, "Lease release rc %d", rc);
+	cifs_dbg(FYI, "Lease release rc %d\n", rc);
 	cifs_put_tlink(lw->tlink);
 	kfree(lw);
 }
@@ -426,15 +428,13 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
 
 	lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
-	if (!lw) {
-		cERROR(1, "Memory allocation failed during lease break check");
+	if (!lw)
 		return false;
-	}
 
 	INIT_WORK(&lw->lease_break, cifs_ses_oplock_break);
 	lw->lease_state = rsp->NewLeaseState;
 
-	cFYI(1, "Checking for lease break");
+	cifs_dbg(FYI, "Checking for lease break\n");
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
@@ -455,9 +455,9 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 					   SMB2_LEASE_KEY_SIZE))
 					continue;
 
-				cFYI(1, "found in the open list");
-				cFYI(1, "lease key match, lease break 0x%d",
-				     le32_to_cpu(rsp->NewLeaseState));
+				cifs_dbg(FYI, "found in the open list\n");
+				cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
+					 le32_to_cpu(rsp->NewLeaseState));
 
 				smb2_set_oplock_level(cinode,
 				  smb2_map_lease_to_oplock(rsp->NewLeaseState));
@@ -489,9 +489,9 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 						   &lw->lease_break);
 				}
 
-				cFYI(1, "found in the pending open list");
-				cFYI(1, "lease key match, lease break 0x%d",
-				     le32_to_cpu(rsp->NewLeaseState));
+				cifs_dbg(FYI, "found in the pending open list\n");
+				cifs_dbg(FYI, "lease key match, lease break 0x%d\n",
+					 le32_to_cpu(rsp->NewLeaseState));
 
 				open->oplock =
 				  smb2_map_lease_to_oplock(rsp->NewLeaseState);
@@ -506,7 +506,7 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	kfree(lw);
-	cFYI(1, "Can not process lease break - no lease matched");
+	cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
 	return false;
 }
 
@@ -520,7 +520,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
 
-	cFYI(1, "Checking for oplock break");
+	cifs_dbg(FYI, "Checking for oplock break\n");
 
 	if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
 		return false;
@@ -533,7 +533,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 			return false;
 	}
 
-	cFYI(1, "oplock level 0x%d", rsp->OplockLevel);
+	cifs_dbg(FYI, "oplock level 0x%d\n", rsp->OplockLevel);
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
@@ -553,7 +553,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 				    cfile->fid.volatile_fid)
 					continue;
 
-				cFYI(1, "file id match, oplock break");
+				cifs_dbg(FYI, "file id match, oplock break\n");
 				cinode = CIFS_I(cfile->dentry->d_inode);
 
 				if (!cinode->clientCanCacheAll &&
@@ -573,11 +573,11 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 			}
 			spin_unlock(&cifs_file_list_lock);
 			spin_unlock(&cifs_tcp_ses_lock);
-			cFYI(1, "No matching file for oplock break");
+			cifs_dbg(FYI, "No matching file for oplock break\n");
 			return true;
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	cFYI(1, "Can not process oplock break for non-existent connection");
+	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
 	return false;
 }
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index bceffe7..f2e76f3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -38,13 +38,13 @@ change_conf(struct TCP_Server_Info *server)
 	case 1:
 		server->echoes = false;
 		server->oplocks = false;
-		cERROR(1, "disabling echoes and oplocks");
+		cifs_dbg(VFS, "disabling echoes and oplocks\n");
 		break;
 	case 2:
 		server->echoes = true;
 		server->oplocks = false;
 		server->echo_credits = 1;
-		cFYI(1, "disabling oplocks");
+		cifs_dbg(FYI, "disabling oplocks\n");
 		break;
 	default:
 		server->echoes = true;
@@ -147,10 +147,10 @@ smb2_dump_detail(void *buf)
 #ifdef CONFIG_CIFS_DEBUG2
 	struct smb2_hdr *smb = (struct smb2_hdr *)buf;
 
-	cERROR(1, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d",
-		  smb->Command, smb->Status, smb->Flags, smb->MessageId,
-		  smb->ProcessId);
-	cERROR(1, "smb buf %p len %u", smb, smb2_calc_size(smb));
+	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
+		 smb->Command, smb->Status, smb->Flags, smb->MessageId,
+		 smb->ProcessId);
+	cifs_dbg(VFS, "smb buf %p len %u\n", smb, smb2_calc_size(smb));
 #endif
 }
 
@@ -436,7 +436,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		       &oplock, NULL);
 	kfree(utf16_path);
 	if (rc) {
-		cERROR(1, "open dir failed");
+		cifs_dbg(VFS, "open dir failed\n");
 		return rc;
 	}
 
@@ -448,7 +448,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SMB2_query_directory(xid, tcon, persistent_fid, volatile_fid, 0,
 				  srch_inf);
 	if (rc) {
-		cERROR(1, "query directory failed");
+		cifs_dbg(VFS, "query directory failed\n");
 		SMB2_close(xid, tcon, persistent_fid, volatile_fid);
 	}
 	return rc;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 41d9d07..b3f264e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -155,8 +155,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 		if ((smb2_command != SMB2_WRITE) &&
 		   (smb2_command != SMB2_CREATE) &&
 		   (smb2_command != SMB2_TREE_DISCONNECT)) {
-			cFYI(1, "can not send cmd %d while umounting",
-				smb2_command);
+			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
+				 smb2_command);
 			return -ENODEV;
 		}
 	}
@@ -200,7 +200,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 		 * back on-line
 		 */
 		if (!tcon->retry) {
-			cFYI(1, "gave up waiting on reconnect in smb_init");
+			cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
 			return -EHOSTDOWN;
 		}
 	}
@@ -227,7 +227,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	cifs_mark_open_files_invalid(tcon);
 	rc = SMB2_tcon(0, tcon->ses, tcon->treeName, tcon, nls_codepage);
 	mutex_unlock(&tcon->ses->session_mutex);
-	cFYI(1, "reconnect tcon rc = %d", rc);
+	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 	if (rc)
 		goto out;
 	atomic_inc(&tconInfoReconnectCount);
@@ -335,7 +335,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	char *security_blob;
 	int flags = CIFS_NEG_OP;
 
-	cFYI(1, "Negotiate protocol");
+	cifs_dbg(FYI, "Negotiate protocol\n");
 
 	if (ses->server)
 		server = ses->server;
@@ -354,7 +354,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	else /* if override flags set only sign/seal OR them with global auth */
 		sec_flags = global_secflags | ses->overrideSecFlg;
 
-	cFYI(1, "sec_flags 0x%x", sec_flags);
+	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
 
 	req->hdr.SessionId = 0;
 
@@ -389,19 +389,19 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc != 0)
 		goto neg_exit;
 
-	cFYI(1, "mode 0x%x", rsp->SecurityMode);
+	cifs_dbg(FYI, "mode 0x%x\n", rsp->SecurityMode);
 
 	/* BB we may eventually want to match the negotiated vs. requested
 	   dialect, even though we are only requesting one at a time */
 	if (rsp->DialectRevision == cpu_to_le16(SMB20_PROT_ID))
-		cFYI(1, "negotiated smb2.0 dialect");
+		cifs_dbg(FYI, "negotiated smb2.0 dialect\n");
 	else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID))
-		cFYI(1, "negotiated smb2.1 dialect");
+		cifs_dbg(FYI, "negotiated smb2.1 dialect\n");
 	else if (rsp->DialectRevision == cpu_to_le16(SMB30_PROT_ID))
-		cFYI(1, "negotiated smb3.0 dialect");
+		cifs_dbg(FYI, "negotiated smb3.0 dialect\n");
 	else {
-		cERROR(1, "Illegal dialect returned by server %d",
-			   le16_to_cpu(rsp->DialectRevision));
+		cifs_dbg(VFS, "Illegal dialect returned by server %d\n",
+			 le16_to_cpu(rsp->DialectRevision));
 		rc = -EIO;
 		goto neg_exit;
 	}
@@ -419,35 +419,34 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
 					       &rsp->hdr);
 	if (blob_length == 0) {
-		cERROR(1, "missing security blob on negprot");
+		cifs_dbg(VFS, "missing security blob on negprot\n");
 		rc = -EIO;
 		goto neg_exit;
 	}
 
-	cFYI(1, "sec_flags 0x%x", sec_flags);
+	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
 	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
-		cFYI(1, "Signing required");
+		cifs_dbg(FYI, "Signing required\n");
 		if (!(server->sec_mode & (SMB2_NEGOTIATE_SIGNING_REQUIRED |
 		      SMB2_NEGOTIATE_SIGNING_ENABLED))) {
-			cERROR(1, "signing required but server lacks support");
+			cifs_dbg(VFS, "signing required but server lacks support\n");
 			rc = -EOPNOTSUPP;
 			goto neg_exit;
 		}
 		server->sec_mode |= SECMODE_SIGN_REQUIRED;
 	} else if (sec_flags & CIFSSEC_MAY_SIGN) {
-		cFYI(1, "Signing optional");
+		cifs_dbg(FYI, "Signing optional\n");
 		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
-			cFYI(1, "Server requires signing");
+			cifs_dbg(FYI, "Server requires signing\n");
 			server->sec_mode |= SECMODE_SIGN_REQUIRED;
 		} else {
 			server->sec_mode &=
 				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
 		}
 	} else {
-		cFYI(1, "Signing disabled");
+		cifs_dbg(FYI, "Signing disabled\n");
 		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
-			cERROR(1, "Server requires packet signing to be enabled"
-				  " in /proc/fs/cifs/SecurityFlags.");
+			cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
 			rc = -EOPNOTSUPP;
 			goto neg_exit;
 		}
@@ -489,7 +488,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	char *ntlmssp_blob = NULL;
 	bool use_spnego = false; /* else use raw ntlmssp */
 
-	cFYI(1, "Session Setup");
+	cifs_dbg(FYI, "Session Setup\n");
 
 	if (ses->server)
 		server = ses->server;
@@ -522,7 +521,7 @@ ssetup_ntlmssp_authenticate:
 	else /* if override flags set only sign/seal OR them with global auth */
 		sec_flags = global_secflags | ses->overrideSecFlg;
 
-	cFYI(1, "sec_flags 0x%x", sec_flags);
+	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
 
 	req->hdr.SessionId = 0; /* First session, not a reauthenticate */
 	req->VcNumber = 0; /* MBZ */
@@ -558,7 +557,7 @@ ssetup_ntlmssp_authenticate:
 					sizeof(struct _NEGOTIATE_MESSAGE),
 					ntlmssp_blob); */
 			/* BB eventually need to add this */
-			cERROR(1, "spnego not supported for SMB2 yet");
+			cifs_dbg(VFS, "spnego not supported for SMB2 yet\n");
 			rc = -EOPNOTSUPP;
 			kfree(ntlmssp_blob);
 			goto ssetup_exit;
@@ -572,14 +571,14 @@ ssetup_ntlmssp_authenticate:
 		ntlmssp_blob = kzalloc(sizeof(struct _NEGOTIATE_MESSAGE) + 500,
 				       GFP_KERNEL);
 		if (ntlmssp_blob == NULL) {
-			cERROR(1, "failed to malloc ntlmssp blob");
 			rc = -ENOMEM;
 			goto ssetup_exit;
 		}
 		rc = build_ntlmssp_auth_blob(ntlmssp_blob, &blob_length, ses,
 					     nls_cp);
 		if (rc) {
-			cFYI(1, "build_ntlmssp_auth_blob failed %d", rc);
+			cifs_dbg(FYI, "build_ntlmssp_auth_blob failed %d\n",
+				 rc);
 			goto ssetup_exit; /* BB double check error handling */
 		}
 		if (use_spnego) {
@@ -587,7 +586,7 @@ ssetup_ntlmssp_authenticate:
 							&security_blob,
 							blob_length,
 							ntlmssp_blob); */
-			cERROR(1, "spnego not supported for SMB2 yet");
+			cifs_dbg(VFS, "spnego not supported for SMB2 yet\n");
 			rc = -EOPNOTSUPP;
 			kfree(ntlmssp_blob);
 			goto ssetup_exit;
@@ -595,7 +594,7 @@ ssetup_ntlmssp_authenticate:
 			security_blob = ntlmssp_blob;
 		}
 	} else {
-		cERROR(1, "illegal ntlmssp phase");
+		cifs_dbg(VFS, "illegal ntlmssp phase\n");
 		rc = -EIO;
 		goto ssetup_exit;
 	}
@@ -620,13 +619,13 @@ ssetup_ntlmssp_authenticate:
 	if (resp_buftype != CIFS_NO_BUFFER &&
 	    rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED) {
 		if (phase != NtLmNegotiate) {
-			cERROR(1, "Unexpected more processing error");
+			cifs_dbg(VFS, "Unexpected more processing error\n");
 			goto ssetup_exit;
 		}
 		if (offsetof(struct smb2_sess_setup_rsp, Buffer) - 4 !=
 				le16_to_cpu(rsp->SecurityBufferOffset)) {
-			cERROR(1, "Invalid security buffer offset %d",
-				  le16_to_cpu(rsp->SecurityBufferOffset));
+			cifs_dbg(VFS, "Invalid security buffer offset %d\n",
+				 le16_to_cpu(rsp->SecurityBufferOffset));
 			rc = -EIO;
 			goto ssetup_exit;
 		}
@@ -667,7 +666,7 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	int rc = 0;
 	struct TCP_Server_Info *server;
 
-	cFYI(1, "disconnect session %p", ses);
+	cifs_dbg(FYI, "disconnect session %p\n", ses);
 
 	if (ses && (ses->server))
 		server = ses->server;
@@ -711,7 +710,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	struct TCP_Server_Info *server;
 	__le16 *unc_path = NULL;
 
-	cFYI(1, "TCON");
+	cifs_dbg(FYI, "TCON\n");
 
 	if ((ses->server) && tree)
 		server = ses->server;
@@ -775,15 +774,15 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	}
 
 	if (rsp->ShareType & SMB2_SHARE_TYPE_DISK)
-		cFYI(1, "connection to disk share");
+		cifs_dbg(FYI, "connection to disk share\n");
 	else if (rsp->ShareType & SMB2_SHARE_TYPE_PIPE) {
 		tcon->ipc = true;
-		cFYI(1, "connection to pipe share");
+		cifs_dbg(FYI, "connection to pipe share\n");
 	} else if (rsp->ShareType & SMB2_SHARE_TYPE_PRINT) {
 		tcon->print = true;
-		cFYI(1, "connection to printer");
+		cifs_dbg(FYI, "connection to printer\n");
 	} else {
-		cERROR(1, "unknown share type %d", rsp->ShareType);
+		cifs_dbg(VFS, "unknown share type %d\n", rsp->ShareType);
 		rc = -EOPNOTSUPP;
 		goto tcon_error_exit;
 	}
@@ -797,7 +796,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
 	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
-		cERROR(1, "DFS capability contradicts DFS flag");
+		cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
 
 tcon_exit:
 	free_rsp_buf(resp_buftype, rsp);
@@ -806,7 +805,7 @@ tcon_exit:
 
 tcon_error_exit:
 	if (rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
-		cERROR(1, "BAD_NETWORK_NAME: %s", tree);
+		cifs_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 		tcon->bad_network_name = true;
 	}
 	goto tcon_exit;
@@ -820,7 +819,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
 
-	cFYI(1, "Tree Disconnect");
+	cifs_dbg(FYI, "Tree Disconnect\n");
 
 	if (ses && (ses->server))
 		server = ses->server;
@@ -925,7 +924,7 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 	int rc = 0;
 	int num_iovecs = 2;
 
-	cFYI(1, "create/open");
+	cifs_dbg(FYI, "create/open\n");
 
 	if (ses && (ses->server))
 		server = ses->server;
@@ -1051,7 +1050,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype;
 	int rc = 0;
 
-	cFYI(1, "Close");
+	cifs_dbg(FYI, "Close\n");
 
 	if (ses && (ses->server))
 		server = ses->server;
@@ -1097,20 +1096,20 @@ validate_buf(unsigned int offset, unsigned int buffer_length,
 
 
 	if (buffer_length < min_buf_size) {
-		cERROR(1, "buffer length %d smaller than minimum size %d",
-			   buffer_length, min_buf_size);
+		cifs_dbg(VFS, "buffer length %d smaller than minimum size %d\n",
+			 buffer_length, min_buf_size);
 		return -EINVAL;
 	}
 
 	/* check if beyond RFC1001 maximum length */
 	if ((smb_len > 0x7FFFFF) || (buffer_length > 0x7FFFFF)) {
-		cERROR(1, "buffer length %d or smb length %d too large",
-			   buffer_length, smb_len);
+		cifs_dbg(VFS, "buffer length %d or smb length %d too large\n",
+			 buffer_length, smb_len);
 		return -EINVAL;
 	}
 
 	if ((begin_of_buf > end_of_smb) || (end_of_buf > end_of_smb)) {
-		cERROR(1, "illegal server response, bad offset to data");
+		cifs_dbg(VFS, "illegal server response, bad offset to data\n");
 		return -EINVAL;
 	}
 
@@ -1155,7 +1154,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses = tcon->ses;
 
-	cFYI(1, "Query Info");
+	cifs_dbg(FYI, "Query Info\n");
 
 	if (ses && (ses->server))
 		server = ses->server;
@@ -1247,7 +1246,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	struct smb_rqst rqst = { .rq_iov = &iov,
 				 .rq_nvec = 1 };
 
-	cFYI(1, "In echo request");
+	cifs_dbg(FYI, "In echo request\n");
 
 	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req);
 	if (rc)
@@ -1262,7 +1261,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, server,
 			     CIFS_ECHO_OP);
 	if (rc)
-		cFYI(1, "Echo request failed: %d", rc);
+		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
 	cifs_small_buf_release(req);
 	return rc;
@@ -1279,7 +1278,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int resp_buftype;
 	int rc = 0;
 
-	cFYI(1, "Flush");
+	cifs_dbg(FYI, "Flush\n");
 
 	if (ses && (ses->server))
 		server = ses->server;
@@ -1379,8 +1378,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				 .rq_pagesz = rdata->pagesz,
 				 .rq_tailsz = rdata->tailsz };
 
-	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
-		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
+	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%u\n",
+		 __func__, mid->mid, mid->mid_state, rdata->result,
+		 rdata->bytes);
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -1392,8 +1392,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 
 			rc = smb2_verify_signature(&rqst, server);
 			if (rc)
-				cERROR(1, "SMB signature verification returned "
-				       "error = %d", rc);
+				cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
+					 rc);
 		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->bytes);
@@ -1426,8 +1426,8 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1 };
 
-	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
-		rdata->offset, rdata->bytes);
+	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
+		 __func__, rdata->offset, rdata->bytes);
 
 	io_parms.tcon = tlink_tcon(rdata->cfile->tlink);
 	io_parms.offset = rdata->offset;
@@ -1481,13 +1481,13 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	if (rc) {
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
-		cERROR(1, "Send error in read = %d", rc);
+		cifs_dbg(VFS, "Send error in read = %d\n", rc);
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
 		if ((*nbytes > CIFS_MAX_MSGSIZE) ||
 		    (*nbytes > io_parms->length)) {
-			cFYI(1, "bad length %d for count %d", *nbytes,
-				io_parms->length);
+			cifs_dbg(FYI, "bad length %d for count %d\n",
+				 *nbytes, io_parms->length);
 			rc = -EIO;
 			*nbytes = 0;
 		}
@@ -1597,7 +1597,8 @@ smb2_async_writev(struct cifs_writedata *wdata)
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
 
-	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
+	cifs_dbg(FYI, "async write at %llu %u bytes\n",
+		 wdata->offset, wdata->bytes);
 
 	req->Length = cpu_to_le32(wdata->bytes);
 
@@ -1670,7 +1671,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	if (rc) {
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
-		cERROR(1, "Send error in write = %d", rc);
+		cifs_dbg(VFS, "Send error in write = %d\n", rc);
 	} else
 		*nbytes = le32_to_cpu(rsp->DataLength);
 
@@ -1696,14 +1697,14 @@ num_entries(char *bufstart, char *end_of_buf, char **lastentry, size_t size)
 					((char *)entryptr + next_offset);
 
 		if ((char *)entryptr + size > end_of_buf) {
-			cERROR(1, "malformed search entry would overflow");
+			cifs_dbg(VFS, "malformed search entry would overflow\n");
 			break;
 		}
 
 		len = le32_to_cpu(entryptr->FileNameLength);
 		if ((char *)entryptr + len + size > end_of_buf) {
-			cERROR(1, "directory entry name would overflow frame "
-				  "end of buf %p", end_of_buf);
+			cifs_dbg(VFS, "directory entry name would overflow frame end of buf %p\n",
+				 end_of_buf);
 			break;
 		}
 
@@ -1759,8 +1760,8 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		info_buf_size = sizeof(SEARCH_ID_FULL_DIR_INFO) - 1;
 		break;
 	default:
-		cERROR(1, "info level %u isn't supported",
-		       srch_inf->info_level);
+		cifs_dbg(VFS, "info level %u isn't supported\n",
+			 srch_inf->info_level);
 		rc = -EINVAL;
 		goto qdir_exit;
 	}
@@ -1824,15 +1825,15 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 			num_entries(srch_inf->srch_entries_start, end_of_smb,
 				    &srch_inf->last_entry, info_buf_size);
 	srch_inf->index_of_last_entry += srch_inf->entries_in_buffer;
-	cFYI(1, "num entries %d last_index %lld srch start %p srch end %p",
-		srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
-		srch_inf->srch_entries_start, srch_inf->last_entry);
+	cifs_dbg(FYI, "num entries %d last_index %lld srch start %p srch end %p\n",
+		 srch_inf->entries_in_buffer, srch_inf->index_of_last_entry,
+		 srch_inf->srch_entries_start, srch_inf->last_entry);
 	if (resp_buftype == CIFS_LARGE_BUFFER)
 		srch_inf->smallBuf = false;
 	else if (resp_buftype == CIFS_SMALL_BUFFER)
 		srch_inf->smallBuf = true;
 	else
-		cERROR(1, "illegal search buffer type");
+		cifs_dbg(VFS, "illegal search buffer type\n");
 
 	if (rsp->hdr.Status == STATUS_NO_MORE_FILES)
 		srch_inf->endOfSearch = 1;
@@ -2017,7 +2018,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_oplock_break *req = NULL;
 
-	cFYI(1, "SMB2_oplock_break");
+	cifs_dbg(FYI, "SMB2_oplock_break\n");
 	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
 
 	if (rc)
@@ -2033,7 +2034,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
-		cFYI(1, "Send error in Oplock Break = %d", rc);
+		cifs_dbg(FYI, "Send error in Oplock Break = %d\n", rc);
 	}
 
 	return rc;
@@ -2058,7 +2059,7 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
 	int rc;
 	struct smb2_query_info_req *req;
 
-	cFYI(1, "Query FSInfo level %d", level);
+	cifs_dbg(FYI, "Query FSInfo level %d\n", level);
 
 	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
 		return -EIO;
@@ -2131,7 +2132,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buf_type;
 	unsigned int count;
 
-	cFYI(1, "smb2_lockv num lock %d", num_lock);
+	cifs_dbg(FYI, "smb2_lockv num lock %d\n", num_lock);
 
 	rc = small_smb2_init(SMB2_LOCK, tcon, (void **) &req);
 	if (rc)
@@ -2155,7 +2156,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
 	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP);
 	if (rc) {
-		cFYI(1, "Send error in smb2_lockv = %d", rc);
+		cifs_dbg(FYI, "Send error in smb2_lockv = %d\n", rc);
 		cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
 	}
 
@@ -2186,7 +2187,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc;
 	struct smb2_lease_ack *req = NULL;
 
-	cFYI(1, "SMB2_lease_break");
+	cifs_dbg(FYI, "SMB2_lease_break\n");
 	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
 
 	if (rc)
@@ -2204,7 +2205,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
-		cFYI(1, "Send error in Lease Break = %d", rc);
+		cifs_dbg(FYI, "Send error in Lease Break = %d\n", rc);
 	}
 
 	return rc;
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 8dd73e6..01f0ac8 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -55,13 +55,13 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = crypto_shash_setkey(server->secmech.hmacsha256,
 		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
 	if (rc) {
-		cERROR(1, "%s: Could not update with response\n", __func__);
+		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
 	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
 	if (rc) {
-		cERROR(1, "%s: Could not init md5\n", __func__);
+		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
 		return rc;
 	}
 
@@ -69,7 +69,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 		if (iov[i].iov_len == 0)
 			continue;
 		if (iov[i].iov_base == NULL) {
-			cERROR(1, "null iovec entry");
+			cifs_dbg(VFS, "null iovec entry\n");
 			return -EIO;
 		}
 		/*
@@ -90,8 +90,8 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 				iov[i].iov_base, iov[i].iov_len);
 		}
 		if (rc) {
-			cERROR(1, "%s: Could not update with payload\n",
-							__func__);
+			cifs_dbg(VFS, "%s: Could not update with payload\n",
+				 __func__);
 			return rc;
 		}
 	}
@@ -109,7 +109,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
 				sigptr);
 	if (rc)
-		cERROR(1, "%s: Could not generate sha256 hash\n", __func__);
+		cifs_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
 
 	memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
 
@@ -119,7 +119,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 int
 smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
-	cFYI(1, "smb3 signatures not supported yet");
+	cifs_dbg(FYI, "smb3 signatures not supported yet\n");
 	return -EOPNOTSUPP;
 }
 
@@ -163,8 +163,8 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 
 	/* Do not need to verify session setups with signature "BSRSPYL " */
 	if (memcmp(smb2_pdu->Signature, "BSRSPYL ", 8) == 0)
-		cFYI(1, "dummy signature received for smb command 0x%x",
-			smb2_pdu->Command);
+		cifs_dbg(FYI, "dummy signature received for smb command 0x%x\n",
+			 smb2_pdu->Command);
 
 	/*
 	 * Save off the origiginal signature so we can modify the smb and check
@@ -205,7 +205,7 @@ smb2_mid_entry_alloc(const struct smb2_hdr *smb_buffer,
 	struct mid_q_entry *temp;
 
 	if (server == NULL) {
-		cERROR(1, "Null TCP session in smb2_mid_entry_alloc");
+		cifs_dbg(VFS, "Null TCP session in smb2_mid_entry_alloc\n");
 		return NULL;
 	}
 
@@ -241,7 +241,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
 		return -ENOENT;
 
 	if (ses->server->tcpStatus == CifsNeedReconnect) {
-		cFYI(1, "tcp session dead - return to caller to retry");
+		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
@@ -281,8 +281,8 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 		rc = smb2_verify_signature(&rqst, server);
 		if (rc)
-			cERROR(1, "SMB signature verification returned error = "
-			       "%d", rc);
+			cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
+				 rc);
 	}
 
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index a0a58fb..43eb136 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -78,7 +78,7 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 	tfm_des = crypto_alloc_blkcipher("ecb(des)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm_des)) {
 		rc = PTR_ERR(tfm_des);
-		cERROR(1, "could not allocate des crypto API");
+		cifs_dbg(VFS, "could not allocate des crypto API\n");
 		goto smbhash_err;
 	}
 
@@ -91,7 +91,7 @@ smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 
 	rc = crypto_blkcipher_encrypt(&desc, &sgout, &sgin, 8);
 	if (rc)
-		cERROR(1, "could not encrypt crypt key rc: %d", rc);
+		cifs_dbg(VFS, "could not encrypt crypt key rc: %d\n", rc);
 
 	crypto_free_blkcipher(tfm_des);
 smbhash_err:
@@ -139,14 +139,14 @@ mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
 	md4 = crypto_alloc_shash("md4", 0, 0);
 	if (IS_ERR(md4)) {
 		rc = PTR_ERR(md4);
-		cERROR(1, "%s: Crypto md4 allocation error %d", __func__, rc);
+		cifs_dbg(VFS, "%s: Crypto md4 allocation error %d\n",
+			 __func__, rc);
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
+		cifs_dbg(VFS, "%s: Could not init md4 shash\n", __func__);
 		goto mdfour_err;
 	}
 	rc = crypto_shash_update(&sdescmd4->shash, link_str, link_len);
 	if (rc) {
-		cERROR(1, "%s: Could not update with link_str", __func__);
+		cifs_dbg(VFS, "%s: Could not update with link_str\n", __func__);
 		goto mdfour_err;
 	}
 	rc = crypto_shash_final(&sdescmd4->shash, md4_hash);
 	if (rc)
-		cERROR(1, "%s: Could not genereate md4 hash", __func__);
+		cifs_dbg(VFS, "%s: Could not generate md4 hash\n", __func__);
 
 mdfour_err:
 	crypto_free_shash(md4);
@@ -238,7 +238,8 @@ SMBNTencrypt(unsigned char *passwd, unsigned char *c8, unsigned char *p24,
 
 	rc = E_md4hash(passwd, p16, codepage);
 	if (rc) {
-		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
+		cifs_dbg(FYI, "%s Can't generate NT hash, error: %d\n",
+			 __func__, rc);
 		return rc;
 	}
 	memcpy(p21, p16, 16);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 1a52868..cf8bf69 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -49,7 +49,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	struct mid_q_entry *temp;
 
 	if (server == NULL) {
-		cERROR(1, "Null TCP session in AllocMidQEntry");
+		cifs_dbg(VFS, "Null TCP session in AllocMidQEntry\n");
 		return NULL;
 	}
 
@@ -61,7 +61,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 		temp->mid = smb_buffer->Mid;	/* always LE */
 		temp->pid = current->pid;
 		temp->command = cpu_to_le16(smb_buffer->Command);
-		cFYI(1, "For smb_command %d", smb_buffer->Command);
+		cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 		/* when mid allocated can be before when sent */
 		temp->when_alloc = jiffies;
@@ -188,8 +188,8 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
 			WARN_ON_ONCE(rc == -ENOSPC);
 			i++;
 			if (i >= 14 || (!server->noblocksnd && (i > 2))) {
-				cERROR(1, "sends on sock %p stuck for 15 "
-					  "seconds", ssocket);
+				cifs_dbg(VFS, "sends on sock %p stuck for 15 seconds\n",
+					 ssocket);
 				rc = -EAGAIN;
 				break;
 			}
@@ -209,14 +209,14 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
 		}
 
 		if (rc > remaining) {
-			cERROR(1, "sent %d requested %d", rc, remaining);
+			cifs_dbg(VFS, "sent %d requested %d\n", rc, remaining);
 			break;
 		}
 
 		if (rc == 0) {
 			/* should never happen, letting socket clear before
 			   retrying is our only obvious option here */
-			cERROR(1, "tcp sent no data");
+			cifs_dbg(VFS, "tcp sent no data\n");
 			msleep(500);
 			continue;
 		}
@@ -291,7 +291,7 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
-	cFYI(1, "Sending smb: smb_len=%u", smb_buf_length);
+	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", smb_buf_length);
 	dump_smb(iov[0].iov_base, iov[0].iov_len);
 
 	/* cork the socket */
@@ -324,8 +324,8 @@ uncork:
 				(char *)&val, sizeof(val));
 
 	if ((total_len > 0) && (total_len != smb_buf_length + 4)) {
-		cFYI(1, "partial send (wanted=%u sent=%zu): terminating "
-			"session", smb_buf_length + 4, total_len);
+		cifs_dbg(FYI, "partial send (wanted=%u sent=%zu): terminating session\n",
+			 smb_buf_length + 4, total_len);
 		/*
 		 * If we have only sent part of an SMB then the next SMB could
 		 * be taken as the remainder of this one. We need to kill the
@@ -335,7 +335,8 @@ uncork:
 	}
 
 	if (rc < 0 && rc != -EINTR)
-		cERROR(1, "Error %d sending data on socket to server", rc);
+		cifs_dbg(VFS, "Error %d sending data on socket to server\n",
+			 rc);
 	else
 		rc = 0;
 
@@ -427,7 +428,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	}
 
 	if (ses->server->tcpStatus == CifsNeedReconnect) {
-		cFYI(1, "tcp session dead - return to caller to retry");
+		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
@@ -559,7 +560,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
 	flags |= CIFS_NO_RESP;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags);
-	cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
+	cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
 
 	return rc;
 }
@@ -569,8 +570,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
-	cFYI(1, "%s: cmd=%d mid=%llu state=%d", __func__,
-	     le16_to_cpu(mid->command), mid->mid, mid->mid_state);
+	cifs_dbg(FYI, "%s: cmd=%d mid=%llu state=%d\n",
+		 __func__, le16_to_cpu(mid->command), mid->mid, mid->mid_state);
 
 	spin_lock(&GlobalMid_Lock);
 	switch (mid->mid_state) {
@@ -588,8 +589,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		break;
 	default:
 		list_del_init(&mid->qhead);
-		cERROR(1, "%s: invalid mid state mid=%llu state=%d", __func__,
-		       mid->mid, mid->mid_state);
+		cifs_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
+			 __func__, mid->mid, mid->mid_state);
 		rc = -EIO;
 	}
 	spin_unlock(&GlobalMid_Lock);
@@ -626,8 +627,8 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		rc = cifs_verify_signature(&rqst, server,
 					   mid->sequence_number + 1);
 		if (rc)
-			cERROR(1, "SMB signature verification returned error = "
-			       "%d", rc);
+			cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
+				 rc);
 	}
 
 	/* BB special case reconnect tid and uid here? */
@@ -672,7 +673,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	if ((ses == NULL) || (ses->server == NULL)) {
 		cifs_small_buf_release(buf);
-		cERROR(1, "Null session");
+		cifs_dbg(VFS, "Null session\n");
 		return -EIO;
 	}
 
@@ -752,7 +753,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	if (!midQ->resp_buf || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
-		cFYI(1, "Bad MID state?");
+		cifs_dbg(FYI, "Bad MID state?\n");
 		goto out;
 	}
 
@@ -788,11 +789,11 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	struct mid_q_entry *midQ;
 
 	if (ses == NULL) {
-		cERROR(1, "Null smb session");
+		cifs_dbg(VFS, "Null smb session\n");
 		return -EIO;
 	}
 	if (ses->server == NULL) {
-		cERROR(1, "Null tcp session");
+		cifs_dbg(VFS, "Null tcp session\n");
 		return -EIO;
 	}
 
@@ -805,8 +806,8 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
 			MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "Illegal length, greater than maximum frame, %d",
-			   be32_to_cpu(in_buf->smb_buf_length));
+		cifs_dbg(VFS, "Illegal length, greater than maximum frame, %d\n",
+			 be32_to_cpu(in_buf->smb_buf_length));
 		return -EIO;
 	}
 
@@ -871,7 +872,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (!midQ->resp_buf || !out_buf ||
 	    midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
-		cERROR(1, "Bad MID state?");
+		cifs_dbg(VFS, "Bad MID state?\n");
 		goto out;
 	}
 
@@ -921,13 +922,13 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_ses *ses;
 
 	if (tcon == NULL || tcon->ses == NULL) {
-		cERROR(1, "Null smb session");
+		cifs_dbg(VFS, "Null smb session\n");
 		return -EIO;
 	}
 	ses = tcon->ses;
 
 	if (ses->server == NULL) {
-		cERROR(1, "Null tcp session");
+		cifs_dbg(VFS, "Null tcp session\n");
 		return -EIO;
 	}
 
@@ -940,8 +941,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (be32_to_cpu(in_buf->smb_buf_length) > CIFSMaxBufSize +
 			MAX_CIFS_HDR_SIZE - 4) {
-		cERROR(1, "Illegal length, greater than maximum frame, %d",
-			   be32_to_cpu(in_buf->smb_buf_length));
+		cifs_dbg(VFS, "Illegal length, greater than maximum frame, %d\n",
+			 be32_to_cpu(in_buf->smb_buf_length));
 		return -EIO;
 	}
 
@@ -1038,7 +1039,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	/* rcvd frame is ok */
 	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_RECEIVED) {
 		rc = -EIO;
-		cERROR(1, "Bad MID state?");
+		cifs_dbg(VFS, "Bad MID state?\n");
 		goto out;
 	}
 
diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index 5142f2c..09afda4 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -68,12 +68,12 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
 		goto remove_ea_exit;
 	}
 	if (ea_name == NULL) {
-		cFYI(1, "Null xattr names not supported");
+		cifs_dbg(FYI, "Null xattr names not supported\n");
 	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
 		&& (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
-		cFYI(1,
-		     "illegal xattr request %s (only user namespace supported)",
-		     ea_name);
+		cifs_dbg(FYI,
+			 "illegal xattr request %s (only user namespace supported)\n",
+			 ea_name);
 		/* BB what if no namespace prefix? */
 		/* Should we just pass them to server, except for
 		system and perhaps security prefixes? */
@@ -134,19 +134,19 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 		search server for EAs or streams to
 		returns as xattrs */
 	if (value_size > MAX_EA_VALUE_SIZE) {
-		cFYI(1, "size of EA value too large");
+		cifs_dbg(FYI, "size of EA value too large\n");
 		rc = -EOPNOTSUPP;
 		goto set_ea_exit;
 	}
 
 	if (ea_name == NULL) {
-		cFYI(1, "Null xattr names not supported");
+		cifs_dbg(FYI, "Null xattr names not supported\n");
 	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
 		   == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto set_ea_exit;
 		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
-			cFYI(1, "attempt to set cifs inode metadata");
+			cifs_dbg(FYI, "attempt to set cifs inode metadata\n");
 
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
 		rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
@@ -167,8 +167,6 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 		struct cifs_ntsd *pacl;
 		pacl = kmalloc(value_size, GFP_KERNEL);
 		if (!pacl) {
-			cFYI(1, "%s: Can't allocate memory for ACL",
-					__func__);
 			rc = -ENOMEM;
 		} else {
 			memcpy(pacl, ea_value, value_size);
@@ -179,7 +177,7 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 			kfree(pacl);
 		}
 #else
-			cFYI(1, "Set CIFS ACL not supported yet");
+		cifs_dbg(FYI, "Set CIFS ACL not supported yet\n");
 #endif /* CONFIG_CIFS_ACL */
 	} else {
 		int temp;
@@ -193,9 +191,9 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 					ACL_TYPE_ACCESS, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			cFYI(1, "set POSIX ACL rc %d", rc);
+			cifs_dbg(FYI, "set POSIX ACL rc %d\n", rc);
 #else
-			cFYI(1, "set POSIX ACL not supported");
+			cifs_dbg(FYI, "set POSIX ACL not supported\n");
 #endif
 		} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
 				   strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
@@ -206,13 +204,13 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
 					ACL_TYPE_DEFAULT, cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			cFYI(1, "set POSIX default ACL rc %d", rc);
+			cifs_dbg(FYI, "set POSIX default ACL rc %d\n", rc);
 #else
-			cFYI(1, "set default POSIX ACL not supported");
+			cifs_dbg(FYI, "set default POSIX ACL not supported\n");
 #endif
 		} else {
-			cFYI(1, "illegal xattr request %s (only user namespace"
-				" supported)", ea_name);
+			cifs_dbg(FYI, "illegal xattr request %s (only user namespace supported)\n",
+				 ea_name);
 		  /* BB what if no namespace prefix? */
 		  /* Should we just pass them to server, except for
 		  system and perhaps security prefixes? */
@@ -263,14 +261,14 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 	/* return dos attributes as pseudo xattr */
 	/* return alt name if available as pseudo attr */
 	if (ea_name == NULL) {
-		cFYI(1, "Null xattr names not supported");
+		cifs_dbg(FYI, "Null xattr names not supported\n");
 	} else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
 		   == 0) {
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto get_ea_exit;
 
 		if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0) {
-			cFYI(1, "attempt to query cifs inode metadata");
+			cifs_dbg(FYI, "attempt to query cifs inode metadata\n");
 			/* revalidate/getattr then populate from inode */
 		} /* BB add else when above is implemented */
 		ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
@@ -295,7 +293,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 #else
-		cFYI(1, "Query POSIX ACL not supported yet");
+		cifs_dbg(FYI, "Query POSIX ACL not supported yet\n");
 #endif /* CONFIG_CIFS_POSIX */
 	} else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
 			  strlen(POSIX_ACL_XATTR_DEFAULT)) == 0) {
@@ -307,7 +305,7 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 				cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 #else
-		cFYI(1, "Query POSIX default ACL not supported yet");
+		cifs_dbg(FYI, "Query POSIX default ACL not supported yet\n");
 #endif /* CONFIG_CIFS_POSIX */
 	} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
 				strlen(CIFS_XATTR_CIFS_ACL)) == 0) {
@@ -319,8 +317,8 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 						full_path, &acllen);
 			if (IS_ERR(pacl)) {
 				rc = PTR_ERR(pacl);
-				cERROR(1, "%s: error %zd getting sec desc",
-						__func__, rc);
+				cifs_dbg(VFS, "%s: error %zd getting sec desc\n",
+					 __func__, rc);
 			} else {
 				if (ea_value) {
 					if (acllen > buf_size)
@@ -332,18 +330,18 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
 				kfree(pacl);
 			}
 #else
-		cFYI(1, "Query CIFS ACL not supported yet");
+			cifs_dbg(FYI, "Query CIFS ACL not supported yet\n");
 #endif /* CONFIG_CIFS_ACL */
 	} else if (strncmp(ea_name,
 		  XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
-		cFYI(1, "Trusted xattr namespace not supported yet");
+		cifs_dbg(FYI, "Trusted xattr namespace not supported yet\n");
 	} else if (strncmp(ea_name,
 		  XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
-		cFYI(1, "Security xattr namespace not supported yet");
+		cifs_dbg(FYI, "Security xattr namespace not supported yet\n");
 	} else
-		cFYI(1,
-		    "illegal xattr request %s (only user namespace supported)",
-		     ea_name);
+		cifs_dbg(FYI,
+			 "illegal xattr request %s (only user namespace supported)\n",
+			 ea_name);
 
 	/* We could add an additional check for streams ie
 	    if proc/fs/cifs/streamstoxattr is set then
-- 
1.8.1.2.459.gbcd45b4.dirty
