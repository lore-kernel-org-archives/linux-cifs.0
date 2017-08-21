From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v6 05/19] crypto: introduce crypto wait for async op
Date: Mon, 21 Aug 2017 17:04:51 +0300
Message-ID: <1503324309-13673-6-git-send-email-gilad__5026.81249422512$1503324907$gmane$org@benyossef.com>
References: <1503324309-13673-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>,
        Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
        David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>,
        Gary Hook <gary.hook-5C7GfCeVMHo@public.gmane.org>,
        Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
        Matthias Brugger <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,
        Jaegeuk Kim <jaegeuk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-crypto@v
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503324309-13673-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Invoking a possibly async. crypto op and waiting for completion
while correctly handling backlog processing is a common task
in the crypto API implementation and outside users of it.

This patch adds a generic implementation for doing so in
preparation for using it across the board instead of hand
rolled versions.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
CC: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Jonathan Cameron <Jonathan.Cameron-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 crypto/api.c           | 13 +++++++++++++
 include/linux/crypto.h | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/crypto/api.c b/crypto/api.c
index 941cd4c..2a2479d 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -24,6 +24,7 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/completion.h>
 #include "internal.h"
 
 LIST_HEAD(crypto_alg_list);
@@ -595,5 +596,17 @@ int crypto_has_alg(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_alg);
 
+void crypto_req_done(struct crypto_async_request *req, int err)
+{
+	struct crypto_wait *wait = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	wait->err = err;
+	complete(&wait->completion);
+}
+EXPORT_SYMBOL_GPL(crypto_req_done);
+
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 84da997..78508ca 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
+#include <linux/completion.h>
 
 /*
  * Autoloaded crypto modules should only use a prefixed name to avoid allowing
@@ -468,6 +469,45 @@ struct crypto_alg {
 } CRYPTO_MINALIGN_ATTR;
 
 /*
+ * A helper struct for waiting for completion of async crypto ops
+ */
+struct crypto_wait {
+	struct completion completion;
+	int err;
+};
+
+/*
+ * Macro for declaring a crypto op async wait object on stack
+ */
+#define DECLARE_CRYPTO_WAIT(_wait) \
+	struct crypto_wait _wait = { \
+		COMPLETION_INITIALIZER_ONSTACK((_wait).completion), 0 }
+
+/*
+ * Async ops completion helper functioons
+ */
+void crypto_req_done(struct crypto_async_request *req, int err);
+
+static inline int crypto_wait_req(int err, struct crypto_wait *wait)
+{
+	switch (err) {
+	case -EINPROGRESS:
+	case -EBUSY:
+		wait_for_completion(&wait->completion);
+		reinit_completion(&wait->completion);
+		err = wait->err;
+		break;
+	};
+
+	return err;
+}
+
+static inline void crypto_init_wait(struct crypto_wait *wait)
+{
+	init_completion(&wait->completion);
+}
+
+/*
  * Algorithm registration interface.
  */
 int crypto_register_alg(struct crypto_alg *alg);
-- 
2.1.4
