From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v8 02/20] crypto: ccp: use -EAGAIN for transient busy indication
Date: Tue,  5 Sep 2017 15:38:41 +0300
Message-ID: <1504615144-29770-3-git-send-email-gilad__931.801883462135$1504615251$gmane$org@benyossef.com>
References: <1504615144-29770-1-git-send-email-gilad@benyossef.com>
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
        Steffen Klassert <steffen.klassert-opNxpl+3fjRBDgjK7y7TUQ@public.gmane.org>,
        Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>,
        Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>,
        Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504615144-29770-1-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Replace -EBUSY with -EAGAIN when reporting transient busy
indication in the absence of backlog.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Reviewed-by: Gary R Hook <gary.hook-5C7GfCeVMHo@public.gmane.org>

---

Please squash this patch with the previous one when merging upstream.
---
 drivers/crypto/ccp/ccp-crypto-main.c | 8 +++-----
 drivers/crypto/ccp/ccp-dev.c         | 7 +++++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 35a9de7..403ff0a 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -222,9 +222,10 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 
 	/* Check if the cmd can/should be queued */
 	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
-		ret = -EBUSY;
-		if (!(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
+		if (!(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG)) {
+			ret = -EAGAIN;
 			goto e_lock;
+		}
 	}
 
 	/* Look for an entry with the same tfm.  If there is a cmd
@@ -243,9 +244,6 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 		ret = ccp_enqueue_cmd(crypto_cmd->cmd);
 		if (!ccp_crypto_success(ret))
 			goto e_lock;	/* Error, don't queue it */
-		if ((ret == -EBUSY) &&
-		    !(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
-			goto e_lock;	/* Not backlogging, don't queue it */
 	}
 
 	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 4e029b1..3d637e3 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -292,9 +292,12 @@ int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 	i = ccp->cmd_q_count;
 
 	if (ccp->cmd_count >= MAX_CMD_QLEN) {
-		ret = -EBUSY;
-		if (cmd->flags & CCP_CMD_MAY_BACKLOG)
+		if (cmd->flags & CCP_CMD_MAY_BACKLOG) {
+			ret = -EBUSY;
 			list_add_tail(&cmd->entry, &ccp->backlog);
+		} else {
+			ret = -EAGAIN;
+		}
 	} else {
 		ret = -EINPROGRESS;
 		ccp->cmd_count++;
-- 
2.1.4
