From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH v8 05/20] crypto: marvell/cesa: remove redundant backlog checks on EBUSY
Date: Tue,  5 Sep 2017 15:38:44 +0300
Message-ID: <1504615144-29770-6-git-send-email-gilad__9081.29227250374$1504615753$gmane$org@benyossef.com>
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

Now that -EBUSY return code only indicates backlog queueing
we can safely remove the now redundant check for the
CRYPTO_TFM_REQ_MAY_BACKLOG flag when -EBUSY is returned.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Acked-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/crypto/marvell/cesa.c | 3 +--
 drivers/crypto/marvell/cesa.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 6e7a5c7..0c3909d 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -183,8 +183,7 @@ int mv_cesa_queue_req(struct crypto_async_request *req,
 	spin_lock_bh(&engine->lock);
 	ret = crypto_enqueue_request(&engine->queue, req);
 	if ((mv_cesa_req_get_type(creq) == CESA_DMA_REQ) &&
-	    (ret == -EINPROGRESS ||
-	    (ret == -EBUSY && req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)))
+	    (ret == -EINPROGRESS || ret == -EBUSY))
 		mv_cesa_tdma_chain(engine, creq);
 	spin_unlock_bh(&engine->lock);
 
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index b7872f6..63c8457 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -763,7 +763,7 @@ static inline int mv_cesa_req_needs_cleanup(struct crypto_async_request *req,
 	 * the backlog and will be processed later. There's no need to
 	 * clean it up.
 	 */
-	if (ret == -EBUSY && req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+	if (ret == -EBUSY)
 		return false;
 
 	/* Request wasn't queued, we need to clean it up */
-- 
2.1.4
