From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v3 03/28] crypto: ccm: use -EIOCBQUEUED for backlog indication
Date: Sun,  2 Jul 2017 17:41:45 +0300
Message-ID: <1499006535-19760-4-git-send-email-gilad__37030.1452851438$1499007091$gmane$org@benyossef.com>
References: <1499006535-19760-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
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
In-Reply-To: <1499006535-19760-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Replace -EBUSY with -EIOCBQUEUED for backlog queueing indication
as part of new API

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
---

This patch should be squashed with the first patch in the series
when applied.

 drivers/crypto/ccp/ccp-crypto-main.c | 10 +++++-----
 drivers/crypto/ccp/ccp-dev.c         |  8 +++++---
 drivers/crypto/ccp/ccp-dmaengine.c   |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 8dccbdd..dff1998 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -84,7 +84,7 @@ struct ccp_crypto_cpu {
 
 static inline bool ccp_crypto_success(int err)
 {
-	if (err && (err != -EINPROGRESS) && (err != -EBUSY))
+	if (err && (err != -EINPROGRESS) && (err != -EIOCBQUEUED))
 		return false;
 
 	return true;
@@ -148,7 +148,7 @@ static void ccp_crypto_complete(void *data, int err)
 
 	if (err == -EINPROGRESS) {
 		/* Only propagate the -EINPROGRESS if necessary */
-		if (crypto_cmd->ret == -EBUSY) {
+		if (crypto_cmd->ret == -EIOCBQUEUED) {
 			crypto_cmd->ret = -EINPROGRESS;
 			req->complete(req, -EINPROGRESS);
 		}
@@ -166,8 +166,8 @@ static void ccp_crypto_complete(void *data, int err)
 		backlog->req->complete(backlog->req, -EINPROGRESS);
 	}
 
-	/* Transition the state from -EBUSY to -EINPROGRESS first */
-	if (crypto_cmd->ret == -EBUSY)
+	/* Transition the state from -EIOCBQUEUED to -EINPROGRESS first */
+	if (crypto_cmd->ret == -EIOCBQUEUED)
 		req->complete(req, -EINPROGRESS);
 
 	/* Completion callbacks */
@@ -243,7 +243,7 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 	}
 
 	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
-		ret = -EBUSY;
+		ret = -EIOCBQUEUED;
 		if (req_queue.backlog == &req_queue.cmds)
 			req_queue.backlog = &crypto_cmd->entry;
 	}
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 2506b50..b7006d7 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -269,7 +269,7 @@ EXPORT_SYMBOL_GPL(ccp_version);
  * Queue a cmd to be processed by the CCP. If queueing the cmd
  * would exceed the defined length of the cmd queue the cmd will
  * only be queued if the CCP_CMD_MAY_BACKLOG flag is set and will
- * result in a return code of -EBUSY.
+ * result in a return code of -EIOCBQUEUED;
  *
  * The callback routine specified in the ccp_cmd struct will be
  * called to notify the caller of completion (if the cmd was not
@@ -280,7 +280,7 @@ EXPORT_SYMBOL_GPL(ccp_version);
  *
  * The cmd has been successfully queued if:
  *   the return code is -EINPROGRESS or
- *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
+ *   the return code is -EIOCBQUEUED
  */
 int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 {
@@ -307,8 +307,10 @@ int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 
 	if (ccp->cmd_count >= MAX_CMD_QLEN) {
 		ret = -EBUSY;
-		if (cmd->flags & CCP_CMD_MAY_BACKLOG)
+		if (cmd->flags & CCP_CMD_MAY_BACKLOG) {
 			list_add_tail(&cmd->entry, &ccp->backlog);
+			ret = -EIOCBQUEUED;
+		}
 	} else {
 		ret = -EINPROGRESS;
 		ccp->cmd_count++;
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index e00be01..ab67304 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -146,7 +146,7 @@ static int ccp_issue_next_cmd(struct ccp_dma_desc *desc)
 		desc->tx_desc.cookie, cmd);
 
 	ret = ccp_enqueue_cmd(&cmd->ccp_cmd);
-	if (!ret || (ret == -EINPROGRESS) || (ret == -EBUSY))
+	if (!ret || (ret == -EINPROGRESS) || (ret == -EIOCBQUEUED))
 		return 0;
 
 	dev_dbg(desc->ccp->dev, "%s - error: ret=%d, tx %d, cmd=%p\n", __func__,
-- 
2.1.4
