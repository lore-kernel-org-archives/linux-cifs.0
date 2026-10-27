Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114743;
	b=TD7kyOYA9YjxHZzHwNQwaKaeBaZBw0/AyueGPezzYYrDGicoX52iiCw2prGNBN26blcs
	 uvat/WU2HNbVNCKxn4Yevqti1I5uWWuXyG6X2X/ZdZkaijPol8u4L1Y6rzFVcyKRsmra3
	 L0piuwhJUl1kU/NsO+7PAWjGJ0ScN/CesZSni5bcjMw9a/ZZleJgmE8R1/Jrr2a74r5uL
	 a0tCDObCl1oI+xaxEF4hUtV/xn8TybzWW4B+h6imLqvBVCVHPMkuyRJim6E2nWRBWVH3G
	 Cj1I98fCvaNGY6e4nhcgruU4pLEugul4mHcbhJzRc1nZDQtry2FNbmrAXqb47KASXUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114743;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CrzYlOiXndQJ0pSCxiyKgUhvgnFRy32acr/NLV6t3y4=;
	b=EHWcEGQtHQ4sSySyDyiDaWaWRCXkxf2rSoFqklSUkOBWqjMFn49TiI32i3JfTEPPhz5x
	 /RriC0NMGrpDHHgxY99mK843g0Suxjh+7BTf++dZk3037cU2QV6dyC2vQEdvc1+WaNozS
	 kWbA3IOoiYFEhTpupfJH0fAi7YtwYoe8t9W4/6U0fMGFC/aZka3saDToIOKlhUsW8X6tV
	 BFbwJrj7WDJoGKlFJSPklpV2l/NdLlQnFB120byThp+7xB3IQj4crrqSIp5+rPRCzRyoU
	 mYKzDCFoYlSrV0AMeoyOX7aqHm0UzcRpFC25Of4/QQCecSPNcKA1R6BB+5JTwoyIFHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b="Lwn/44NF";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="i/c9sucX";
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A66606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 15:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2A66606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=Lwn/44NF;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=i/c9sucX
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 61BA0EC0105
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 11:25:42 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 27 Oct 2026 11:25:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793114742; x=1793201142; bh=CrzYlOiXndQJ0pSCxiyKg
	UhvgnFRy32acr/NLV6t3y4=; b=Lwn/44NFrIO92Tyt7zOOuol4nbbGjg8xPX8rG
	lJJ6SMJcb1FPsD+Smzowcm1K/Zj9UyecPIoQVmysgg5OnVReDyblL3s6ZZdNWUpG
	8RAA8d+i5uztpIWpjGGkE6DhfcFDOTIEulUDiJvQOazc2Tc8TBmoE3TiOX+Fy+le
	WJP+GGvfFuQh+YU1Dps5W51f4R2uUPbZWCO91pgYXBfXkkYsM22Zbnws9c/1SR/j
	Qg55n2WOVt3dlOn8JQNxAqHys2Ca5U/Tj/e7HCVcH+Mq5i8Yj2PZqWD0onC4yeLy
	q0Cd8bPEQ83FwrnAZ3roHDm0lskLOxLw2JdM6tFbq+UMPXnqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793114742; x=1793201142; bh=CrzYlOiXndQJ0pSCxiyKgUhvgnFRy32acr/
	NLV6t3y4=; b=i/c9sucX+GK9xN1coEyB0efrQLnycDI9JkfbtK18cSDIaLV+yL9
	cxzv8dnIkf/pDQpphUF+TW9Td+/dH/dILDknd0T7b3MiQA1xKnI+f+W0W+ATrMzi
	xrP9U7QxwEx9r1Wvk0fjXB7iJ8IsiknjbUXbZl1hdCnnps039tPv20m+wX5mqGJe
	/rHN4CopDca4TXaNKpT8cC3li2XB1emUxV5KfaNtuw7J8Zv4Sgx0JnB1op6DrxQC
	2ks1ZfMLjIkh6LKJ5QrYrmeaUlLrTFporUCECNGEkN2wP4EON/RzUdCLdaEge7zK
	xZHNQu0e5wwsT1DWIIz0I9mn3IIeyBc8hMA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793114742; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:iwy4Zt5yS6RV24ta8ishjTpEKYRCx2DuxqAL3nqXTFGWk7+
	llbl1FXKYRZUbJvb4aEjeWAGTObC8Eca+9erPGdvapvyFagstvqx28fw9tFqQ658
	zQ4da4SIyOevdybIW/D9SszLZIwZUZ8nrgBMSrZcydybOV18XnY0cQqoxUS5oRgN
	QGk1tIMaYEVRuh2B7LSBKZNqUyEgodXrmMfmf5hvI2vEt5CYEFg6/HzpMiC4/QHC
	y0e7ubuoC9Tb3Fx6R6+qt5uJxyUx54OZnKwOBNnpUaEA7lW87n/ttL4XnASAyajx
	RcCMhlKHda7TLwQkfPyxl2y3kTqqyedfA6b6Xtw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:LeOpmESBzsCkTdRKz7HBI1WnP9d0MbIlEffVUU8Wbgs=:S79AsNeZJcr5jN8008YDzIAHTFExo7Dhsh/auCRi8kc=;
X-ME-Sender: <xms:dsLgaucppVFyIJmgrmBjfb4_HjXTxmVBr0NmlIB-ESoLCsN6K9AbzA>
    <xme:dsLgauPY7vJHGSlmvB4LL6UYtxG5aDQ1Bk34stb10eMGgbRKQmn_eNJ3TknMmRXh_
    nxiUpCYlT4AlQb7uqjAZ3uf4mQWNBcWoWMGbrMAAVAZkS4I2Ec0mSQZ>
X-ME-Received: <xmr:dsLgaqWzkmVh7764_asPEm9jg3Ch1oikHUSxsrCOzXQQ3FLiPMIcU9lSPxqYDC5e>
X-ME-Proxy-Cause: dmFkZTGbBFLvq44vFIUxr3zCaJHCHgNFIpbBMDnoLBb+EWwQS1bWou5/MorY+i0IxFWr1v
    vRg+duKKE9jikI8mSx+2VjGwf/e92ShZl3yCU7SkAV3OwtTLuwFKSkWJfkgG9QMJeKDz3t
    rn/19fmFapCFPFmvO0GDnbopS7aLs7W9TkW7gh6N4oxTTcVlzRgSTKL0iKTxFr7ZqtoCjc
    AaRY2mmnBFn9XhfWsJvSXugzJT5kQewHU/MI29AHAp3io0T4ll+eDK29jYQxuZ9Rp8pWau
    Af9ez/i1Vv1b1sYxL1TnM3zgtL4xA5XBTA43kp0RFjEHLtV94BJKxJyR047vlYr9shekcW
    XWS96DN313jWGOtgypAP5P3NgxTEhvvW/Enw6unBeJScbQc5+zTSSo9tuBJpahCjPgHysr
    n5mVax4y9FTdS9wizcqndlL9ZWzcLix6DDE2CvRx5wiWcpUt7HtYeqWULsdz6HTIp57EBc
    3IKTg+ayvOJDWKRe10tanFb4eatKyOHjH9vQZBtXlTaVMW+IKossZ2NKDpemb+L+M37YHO
    RLsy5qGxUAMhG5mxIjO/X+VVyx1qI3v1g3sgklpvVxk73tEhE3bmKopfqxEOimHNOjnbPm
    1rhI7Teu5sRy1DboIWMTf4Z0YJhFow8PeSrEO7iRggTLHy1QAW/EWQFRHepw
X-ME-Proxy: <xmx:dsLgauzLaoFIjJ8fE6KTUL73ffi6d-pOLnbQqaY0TcCk86sKgrIJLg>
    <xmx:dsLgap-duTwWPRvvwhlsrTwbyrOEwywn0NkE6NAOjvpC1vBL4fY-eA>
    <xmx:dsLgar98sTExe1zg7ooNzhbz5uFfeoLu_aVPJKFZssTx2gkYT2J-xA>
    <xmx:dsLgagX7BzjrqAg9GEZYJlxHyPUF0-9-Z65iipqNoayi8ZDG8HqDvw>
    <xmx:dsLgauSYN0-CWTF3EYJEySFbk37cAGNyP9CKYHBDA0u0ETgn9gmba3sS>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 11:25:40 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Steve French <stfrench@microsoft.com>,
	Junyi Liu <moss80199@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix use-after-free after a failed durable reconnect
Date: Tue, 27 Oct 2026 10:25:19 -0500
Message-ID: <20261027152519.138444-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
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

ksmbd_reopen_durable_fd() republishes a detached durable handle in the
reconnecting session's file table and takes no reference for that entry.
If smb2_open() then fails, cleanup relies on the final ksmbd_fd_put() to
remove the volatile id.

Two reconnects of the same handle can both take a lookup reference before
either attaches it. If the one that reopens first then fails and drops
its references first, the other request makes the final put through
ksmbd_put_durable_fd(). That frees the handle without removing the first
session's table entry, so tearing that session down writes to freed
memory.

  BUG: KASAN: slab-use-after-free in __close_file_table_ids+0x14d/0x740 [ksmbd]
  Call Trace:
   __close_file_table_ids+0x14d/0x740 [ksmbd]
   ksmbd_destroy_file_table+0x76/0x100 [ksmbd]
   ksmbd_session_destroy+0xf8/0x480 [ksmbd]
   ksmbd_dispose_sessions+0x13e/0x200 [ksmbd]
   ksmbd_conn_sessions_cleanup+0x4c3/0x6d0 [ksmbd]
  Freed by task 1030:
   __ksmbd_close_fd+0x97d/0x1000 [ksmbd]
   smb2_open+0x14eb/0xd9f0 [ksmbd]

Commit 3515503322f4 ("ksmbd: fix durable reconnect error path file
lifetime") handles a final put made by the reconnecting request, but not
one made by another holder.

Remove the volatile id under the file-table lock on this error path,
before the references are dropped, as ksmbd_close_fd() does on the
request_open path just above. Removal then no longer depends on which
holder makes the final put. The stale comment in the reconnect cleanup
is updated to match. A successful reconnect is unchanged.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs "durable handles = yes" (the default is no, but macOS Time
    Machine destinations need it) and a durable handle (v1 or v2) that is
    detached and waiting for reconnect. Two things must then overlap. A
    reconnect of the handle must fail after ksmbd_reopen_durable_fd()
    succeeds. Another holder must take a global-table reference before that
    reopen and drop it after the failed reconnect's puts. The other holder can
    be a second reconnect of the same handle, and a durable v1
    reconnect needs only the persistent id. A durable v2 create with the
    same CreateGuid also takes a short-lived reference. These lookups run
    before the owner check, so the second request does not need the owner's
    credentials.
    
    The affected early error path is reached if ksmbd_override_fsids() fails
    or ksmbd_vfs_getattr() returns an error after a successful reopen. The
    reproduction forced the getattr failure. Naturally occurring failures
    were not tested.
    
    The race dates from c8efcc786146, where a ksmbd_iov_pin_rsp() failure
    after the reconnect leaves the same stale id. 1baff47b81f9 ("ksmbd: fix
    use-after-free in smb2_open during durable reconnect") moved the lookup
    put to the end of smb2_open(), which made a getattr failure a trigger as
    well.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance (code review and KASAN
    reproduction).
    
    Tested on ksmbd-for-next 714f27729121 under KASAN, on a fresh boot. With
    only this patch applied, an ordinary durable v2 reconnect succeeds, the
    handle reads back the data written before the disconnect and closes
    cleanly, and no handle or KASAN report is left (kmemleak shows only one
    unrelated object with no ksmbd frames). The race and the getattr failure
    were made deterministic with temporary debug hooks. They are a barrier
    that lets both reconnects take their lookup reference before either
    reopens, a forced getattr failure, and a wait that makes the second
    reconnect drop its reference last. That instrumentation is not part of
    this patch.
    Without the patch, the hooked run triggers the KASAN report above when
    the first session is torn down. With it, both reconnects fail with an
    error status, the volatile id is already gone before the last put, no
    handle is left, and no KASAN report fires over two runs. A single
    failing reconnect behaves the same. The injected-failure paths still
    emit a pre-existing warning from ksmbd_free_work_struct() that this fix
    does not touch.

 fs/smb/server/smb2pdu.c   |  9 +++++----
 fs/smb/server/vfs_cache.c | 28 ++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  2 ++
 3 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b306bc6e21ee..4dc91d4f1a94 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5628,6 +5628,8 @@ int smb2_open(struct ksmbd_work *work)
 				ksmbd_close_fd(work, fp->volatile_id);
 				smb2_complete_request_open(work);
 			} else {
+				if (dh_info.reconnected && fp == dh_info.fp)
+					ksmbd_unpublish_reopened_fd(work, fp);
 				ksmbd_fd_put(work, fp);
 			}
 		}
@@ -5641,10 +5643,9 @@ int smb2_open(struct ksmbd_work *work)
 	if (dh_info.reconnected) {
 		/*
 		 * If reconnect succeeded, fp was republished in the
-		 * session file table.  On a later error, ksmbd_fd_put()
-		 * above drops the session reference; drop the durable
-		 * lookup reference through the same session-aware path so
-		 * final close removes the volatile id before freeing fp.
+		 * session file table, and the error path above has
+		 * already removed its volatile id.  Drop the durable
+		 * lookup reference through the same session-aware path.
 		 */
 		if (rc && fp == dh_info.fp)
 			ksmbd_fd_put(work, dh_info.fp);
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 4368e069fd5e..f9079c529d07 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1074,6 +1074,34 @@ void ksmbd_wake_session_blocked_works(struct ksmbd_session *sess)
 	read_unlock(&ft->lock);
 }
 
+/**
+ * ksmbd_unpublish_reopened_fd() - remove a reopened durable handle from the
+ *	session file table after its CREATE failed
+ * @work:	smb work of the failed CREATE
+ * @fp:		durable handle republished by ksmbd_reopen_durable_fd()
+ *
+ * The reopen publishes @fp in this session's table without taking a reference
+ * for the entry, so the CREATE error path's puts need not be the last ones.
+ * Another holder of a global-table reference, such as a concurrent reconnect
+ * of the same handle, can drop the last one through ksmbd_put_durable_fd(),
+ * which frees @fp without touching this table.  Remove the id here, while
+ * the caller still holds its references.
+ *
+ * Every path that removes the id before the final put also clears
+ * @fp->volatile_id under ft->lock, so a valid id is still @fp's entry.
+ */
+void ksmbd_unpublish_reopened_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
+{
+	struct ksmbd_file_table *ft = &work->sess->file_table;
+
+	write_lock(&ft->lock);
+	if (has_file_id(fp->volatile_id)) {
+		idr_remove(ft->idr, fp->volatile_id);
+		fp->volatile_id = KSMBD_NO_FID;
+	}
+	write_unlock(&ft->lock);
+}
+
 int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 {
 	struct ksmbd_file	*fp;
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index c00d92fdf94a..a0239ec178d8 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -205,6 +205,8 @@ static inline bool ksmbd_stream_fd(struct ksmbd_file *fp)
 int ksmbd_init_file_table(struct ksmbd_file_table *ft);
 void ksmbd_destroy_file_table(struct ksmbd_session *sess);
 int ksmbd_close_fd(struct ksmbd_work *work, u64 id);
+void ksmbd_unpublish_reopened_fd(struct ksmbd_work *work,
+				 struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_fast(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_foreign_fd(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_work *work, u64 id,

base-commit: 714f27729121d59f103ca4dad7b0c2d1c125cd71
-- 
2.47.3

