Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674989;
	b=ZWsVBUb3KH166AlQIW/HeTXSUU8akUXb7eq0GXxkJzGWfMp1znxqK1uBmSXyX9j8OdR3
	 ytmfbabrl6yxMsn7LPxPWO/k654uOOcbSlgyiBvzpjrYIpImHjp39fzGZNBxLvcMksqDr
	 vqRSDvbfVGIq30uA+r+hg9XnyotFtxUlqc+ri4jH8FY9BHBT+RRFU65ebuoKZqfdn3Zeb
	 giSAPWBaxqH97+FBkqVLaQYq7pArlMKM6q+qzPM2Eeos7hdPGqq6YEsCA0uqaPt34c2b8
	 z3VcjQI59qZjCKEpnZP4KAVkGnjNkwMlGJPhlHB+SqGLl0MCAMvSeHE20SAGA+kGS0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=xLbp+xxVl/0FXNA+V2OAjVavj4EIHRzk8LqsslJat+s=;
	b=YfHtz+pktV/tFcKFB6MQ0sBcG1HDbsrGcSzkJIYvHd4y8WORzsH6ypGgO7jIc12KC2Hk
	 OuT4rq7Aj9QmdfHxmu1gjpcl3GbrC0IRnZ9c4bCx3WvJsJSQEZmi0GZmqqCkNxulGHqFm
	 fXEkmdEB5e7E+KM/9bkCxtc2nQj3QKMuiw6PFHCC6+/SmUksDXm0jgcjtXTed4lzJ91b7
	 Pew+GjIQEWs1uoMysF3U8H7cc4NAEkc7/M+O8o+4pR5IILJQXynsdBzkN4EvJkXCosbwZ
	 lHoFuWp8IIu0vaEPFXv+tu6siikKyMsgQ1MtrFtSF5m0DAN2j+/BAo40iLr3zaa3bvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="OyN51/jZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A4C5D606D809;
	Tue,  3 Nov 2026 03:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OyN51/jZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 036301F00A1A;
	Tue,  3 Nov 2026 03:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793674988;
	bh=xLbp+xxVl/0FXNA+V2OAjVavj4EIHRzk8LqsslJat+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyN51/jZcNLy8vIwYJ1a34SZA/fa+VYUPK2E7YnpHALmsGXdJOPrnX6nQ7ttwi0JP
	 6/UGFVYrs/laf0ZnL6JgqQBl3H3bIMCF/crzFu60zg67HZjKGcKDraPCmxedNuMmcK
	 ZgEr0W13jMtckroXKgZM8k8S2K+2NevCgfnxLI2eHOkSF4RXyBGWqb11BKf7CbIWAY
	 Bt1ebFAUjlr8AiAVMweLWNfuiquI1RSf1TokXh4b7dzJo4D7s+4OylDLBTyA+CXWD8
	 4dgn3zpPpA41daBzx+XJassZaTFxu/Bmq8/RHqeihUpPYPql85s7OB1S4WCLH2TJaZ
	 92gU/eIsLyYKQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-integrity@vger.kernel.org,
	Mimi Zohar <zohar@linux.ibm.com>,
	keyrings@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-cifs@vger.kernel.org (open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	samba-technical@lists.samba.org (moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)),
	linux-kernel@vger.kernel.org (open list),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [RFC PATCH v2 05/11] smb: client: Clear idmap/SPNEGO caches when the last session is unloaded
Date: Tue,  3 Nov 2026 05:02:10 +0200
Message-ID: <20261103030226.2685251-6-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103030226.2685251-1-jarkko@kernel.org>
References: <20261103030226.2685251-1-jarkko@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs caches cifs.idmap and cifs.spnego keys in module-owned thread
keyrings that are only destroyed in module_exit(). Once live keys pin
the key type, cached entries keep cifs pinned after the last SMB session
is torn down.

Serialize session count transitions with a mutex and clear the idmap and
SPNEGO cache keyrings when the last session is freed.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/smb/client/cifs_debug.c  |  2 +-
 fs/smb/client/cifs_spnego.c |  8 ++++++++
 fs/smb/client/cifsacl.c     |  8 ++++++++
 fs/smb/client/cifsfs.c      |  4 ++--
 fs/smb/client/cifsglob.h    |  2 +-
 fs/smb/client/cifsproto.h   |  8 ++++++++
 fs/smb/client/misc.c        | 19 +++++++++++++++++--
 7 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 577f0ddede90..2eecd2516dfe 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -790,7 +790,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 	struct cifs_tcon *tcon;
 
 	seq_printf(m, "Resources in use\nCIFS Session: %d\n",
-			sesInfoAllocCount.counter);
+			cifs_ses_alloc_count.counter);
 	seq_printf(m, "Share (unique mount targets): %d\n",
 			tconInfoAllocCount.counter);
 	seq_printf(m, "SMB Request/Response Buffer: %d Pool size: %d\n",
diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index 44c407275680..3bd272c7d9fe 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -242,6 +242,14 @@ init_cifs_spnego(void)
 	return ret;
 }
 
+void cifs_spnego_clear_cache(void)
+{
+	int ret;
+
+	ret = keyring_clear(spnego_cred->thread_keyring);
+	WARN_ON(ret);
+}
+
 void
 exit_cifs_spnego(void)
 {
diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 346899da91eb..7504cedf6417 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -590,6 +590,14 @@ init_cifs_idmap(void)
 	return ret;
 }
 
+void cifs_idmap_clear_cache(void)
+{
+	int ret;
+
+	ret = keyring_clear(root_cred->thread_keyring);
+	WARN_ON(ret);
+}
+
 void
 exit_cifs_idmap(void)
 {
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 9788052599ce..f8a9a6f7dc49 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -84,7 +84,7 @@ DEFINE_SPINLOCK(GlobalMid_Lock); /* protects above & list operations on midQ ent
 /*
  *  Global counters, updated atomically
  */
-atomic_t sesInfoAllocCount;
+atomic_t cifs_ses_alloc_count;
 atomic_t tconInfoAllocCount;
 atomic_t tcpSesNextId;
 atomic_t tcpSesAllocCount;
@@ -2024,7 +2024,7 @@ init_cifs(void)
 /*
  *  Initialize Global counters
  */
-	atomic_set(&sesInfoAllocCount, 0);
+	atomic_set(&cifs_ses_alloc_count, 0);
 	atomic_set(&tconInfoAllocCount, 0);
 	atomic_set(&tcpSesNextId, 0);
 	atomic_set(&tcpSesAllocCount, 0);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index d3ca688b6aba..c6e8d1340517 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2095,7 +2095,7 @@ extern spinlock_t GlobalMid_Lock; /* protects above & list operations on midQ en
 /*
  *  Global counters, updated atomically
  */
-extern atomic_t sesInfoAllocCount;
+extern atomic_t cifs_ses_alloc_count;
 extern atomic_t tconInfoAllocCount;
 extern atomic_t tcpSesNextId;
 extern atomic_t tcpSesAllocCount;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f9ea35597bc2..2930a40d1b67 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -58,8 +58,16 @@ do {									\
 } while (0)
 int init_cifs_idmap(void);
 void exit_cifs_idmap(void);
+void cifs_idmap_clear_cache(void);
 int init_cifs_spnego(void);
 void exit_cifs_spnego(void);
+#ifdef CONFIG_CIFS_UPCALL
+void cifs_spnego_clear_cache(void);
+#else
+static inline void cifs_spnego_clear_cache(void)
+{
+}
+#endif
 const char *build_path_from_dentry(struct dentry *direntry, void *page);
 char *__build_path_from_dentry_optional_prefix(struct dentry *direntry,
 					       void *page, const char *tree,
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ec28f102ea08..4503434942f9 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -9,6 +9,8 @@
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/mempool.h>
+#include <linux/key.h>
+#include <linux/mutex.h>
 #include <linux/vmalloc.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -33,6 +35,9 @@ struct tcon_list {
 	struct cifs_tcon *tcon;
 };
 
+/* Serialize session admission with the last session's cache clear. */
+static DEFINE_MUTEX(cifs_session_mutex);
+
 /* The xid serves as a useful identifier for each incoming vfs request,
    in a similar way to the mid which is useful to track each sent smb,
    and CurrentXid can also provide a running counter (although it
@@ -74,7 +79,6 @@ sesInfoAlloc(void)
 
 	ret_buf = kzalloc_obj(struct cifs_ses);
 	if (ret_buf) {
-		atomic_inc(&sesInfoAllocCount);
 		spin_lock_init(&ret_buf->ses_lock);
 		ret_buf->ses_status = SES_NEW;
 		++ret_buf->ses_count;
@@ -84,6 +88,10 @@ sesInfoAlloc(void)
 		spin_lock_init(&ret_buf->iface_lock);
 		INIT_LIST_HEAD(&ret_buf->iface_list);
 		spin_lock_init(&ret_buf->chan_lock);
+
+		mutex_lock(&cifs_session_mutex);
+		atomic_inc(&cifs_ses_alloc_count);
+		mutex_unlock(&cifs_session_mutex);
 	}
 	return ret_buf;
 }
@@ -99,7 +107,6 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 	}
 
 	unload_nls(buf_to_free->local_nls);
-	atomic_dec(&sesInfoAllocCount);
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
@@ -115,6 +122,14 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 		kref_put(&iface->refcount, release_iface);
 	spin_unlock(&buf_to_free->iface_lock);
 	kfree_sensitive(buf_to_free);
+
+	mutex_lock(&cifs_session_mutex);
+	if (atomic_dec_and_test(&cifs_ses_alloc_count)) {
+		cifs_idmap_clear_cache();
+		cifs_spnego_clear_cache();
+		key_gc_flush();
+	}
+	mutex_unlock(&cifs_session_mutex);
 }
 
 struct cifs_tcon *
-- 
2.47.3

