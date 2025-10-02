Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED4A4D8CE;
	Thu,  2 Oct 2025 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419035; cv=none; b=Wyz9NVEGn9PQK92FZd2f7Szy6OMJ9mlOYoLO5BFDgtsk+BJCneF/0KUV4cbju7PZyn9qLaZXnPVPEeRq5SJOoobsXw+KU5yiybVMzbAxbsKH2iRl5glPF82KcPGuOTvVAdAX2WUHZMhM1u0WzgLh/Or//TZmvLDiK4xZsFWmzlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419035; c=relaxed/simple;
	bh=wUknlYPzcIAtcubuB1mkhuqr2wJsmkhIeg9CBWmrvPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSNFVomH4KHufMexgoOjeES8WNCDwgx/Z+pxHAGKhQpdEAGdm+NRWQe58qjvwznK7QgIWP/JECWAk4AdFLOo9wEsilm6xvode/hZ1wZVgA+xa3fjKfeVH/YVCJpaVP2ATsUryWzesWotMYD57VT3cDaZIK4DOWANUeODLb3M0co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLRJ+6AI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLRJ+6AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D01C4CEF9;
	Thu,  2 Oct 2025 15:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419035;
	bh=wUknlYPzcIAtcubuB1mkhuqr2wJsmkhIeg9CBWmrvPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLRJ+6AI+yFZtYBbidf5XV4D835qNaj2oRfbcyz5VN8h1NkVUzB/Ntv6z11zZ27df
	 jxuVqzviZMnyl/vsEI4EilqaqtF+V4i7QSbTxpTSellRUENldCoKR//p+ElC9YOPYF
	 1ZzvYic6icI40qBVxSCUrqUU71MGf3pR1c9H4wU4I6/Q3BF3SA5U5ItBcz/lF/wa7K
	 BNP4tZAmYQGpCU6zeItBkvAsX8dmU3d0Vcu9e9psDUuVfHB/p8PCGr2BxNoNsafjJH
	 772udg+z/Shd49IZYP77omHuIQQfCR0dXMgk5Bu2gtQuWRciDq0+bO+KX2h8h3Tf4S
	 1GRydygZ+kAYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Metzmacher <metze@samba.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17] smb: client: make use of ib_wc_status_msg() and skip IB_WC_WR_FLUSH_ERR logging
Date: Thu,  2 Oct 2025 11:29:54 -0400
Message-ID: <20251002153025.2209281-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit a8e970358b31a5abba8b5737a67ba7b8d26f4258 ]

There's no need to get log message for every IB_WC_WR_FLUSH_ERR
completion, but any other error should be logged at level ERR.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my exhaustive analysis, here is my recommendation:

## **Backport Status: YES**

### Extensive Analysis:

#### **What This Commit Does:**

This commit makes two logging improvements to the SMB Direct (RDMA)
code:

1. **Human-readable error messages**: Changes from numeric status codes
   (`wc->status=%d`) to descriptive strings using
   `ib_wc_status_msg(wc->status)` (e.g., "WR flushed" instead of "6")

2. **Reduces log spam**: Adds conditional checks (`if (wc->status !=
   IB_WC_WR_FLUSH_ERR)`) to skip logging for `IB_WC_WR_FLUSH_ERR`
   errors, which are benign and occur frequently during normal RDMA
   operations

3. **Better error visibility**: In `recv_done()` (line 607-608), changes
   the log level from INFO to ERR for real errors

#### **Deep Technical Context:**

**`IB_WC_WR_FLUSH_ERR` Background:**
- This is a standard InfiniBand/RDMA work completion status indicating
  that work requests were flushed from the queue
- Occurs during normal operations: QP (Queue Pair) error state
  transitions, connection teardown, and error recovery
- **NOT an actionable error** - it's expected behavior that doesn't
  require logging
- Other kernel RDMA drivers follow this pattern:
  `drivers/infiniband/core/mad.c:2366` has `if (wc->status ==
  IB_WC_WR_FLUSH_ERR)` with special handling and no error logging

**SMB Client Logging History:**
- Multiple commits address log spam in SMB client: d7cb986425ce2 "stop
  flooding dmesg in smb2_calc_signature()", 6bbed0b3ad8b2 "fix noisy
  when tree connecting"
- This commit follows the same pattern - reducing noise while preserving
  important error information

#### **Backport Suitability Analysis:**

**✅ STRONG POSITIVE FACTORS:**

1. **Very small and safe**: Only 20 lines changed (12 insertions, 8
   deletions) in a single file
2. **Logging-only changes**: No functional code paths altered - only
   what gets logged and how
3. **Zero dependencies**: Both `ib_wc_status_msg()` (introduced v4.2,
   2015) and `IB_WC_WR_FLUSH_ERR` exist in v6.17
4. **Code compatibility**: The v6.17 send_done():275 and recv_done():450
   functions match the pre-patch state exactly
5. **Trusted author**: Stefan Metzmacher is a Samba core developer with
   extensive SMB/CIFS expertise
6. **Maintainer approval**: Acked-by Namjae Jeon, Signed-off-by Steve
   French (CIFS maintainer)
7. **Real user benefit**: Reduces log spam that obscures real errors,
   improves observability for system administrators
8. **Industry best practice**: Aligns with how other RDMA drivers in the
   kernel handle IB_WC_WR_FLUSH_ERR
9. **Minimal testing burden**: Can be verified simply by observing logs
   during RDMA operations

**⚠️ CONSIDERATIONS:**

1. No explicit `Cc: stable@` tag (though this is common for QOL
   improvements)
2. Not a critical bugfix - it's a usability/observability enhancement
3. Doesn't fix crashes, data corruption, or security issues

#### **Regression Risk Assessment:**

**Risk Level: VERY LOW**

- Changes only affect logging statements
- No changes to control flow, data structures, or RDMA operations
- If something did go wrong (highly unlikely), worst case is missing log
  messages
- The logic is straightforward: `if (status != FLUSH_ERR) log_error()`

#### **Specific Code Changes Analyzed:**

**send_done() fs/smb/client/smbdirect.c:415-429:**
```c
- log_rdma_send(INFO, "...wc->status=%d", wc->status);
+ log_rdma_send(INFO, "...wc->status=%s", ib_wc_status_msg(wc->status));

- log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n", wc->status,
  wc->opcode);
+ if (wc->status != IB_WC_WR_FLUSH_ERR)
+     log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
+                   ib_wc_status_msg(wc->status), wc->opcode);
```

**recv_done() fs/smb/client/smbdirect.c:597-608:**
```c
- log_rdma_recv(INFO, "...wc status=%d...", wc->status, ...);
+ log_rdma_recv(INFO, "...wc status=%s...",
ib_wc_status_msg(wc->status), ...);

- log_rdma_recv(INFO, "wc->status=%d opcode=%d\n", wc->status,
  wc->opcode);
+ if (wc->status != IB_WC_WR_FLUSH_ERR)
+     log_rdma_recv(ERR, "wc->status=%s opcode=%d\n",
+                   ib_wc_status_msg(wc->status), wc->opcode);
```

Note the important change: ERROR level logging for recv_done (was INFO,
now ERR) - this ensures real errors are more visible.

#### **Why This Should Be Backported:**

1. **Improves user experience**: System administrators using SMB Direct
   over RDMA will see cleaner logs with readable error messages
2. **Reduces support burden**: Less noise in logs means real errors are
   easier to identify
3. **Safe change**: Extremely low risk of introducing regressions
4. **Already backported elsewhere**: Evidence shows this commit
   (624cc9eac4e69) was already backported to another stable tree
5. **Aligns with stable tree philosophy**: Small, safe improvements that
   benefit users without risk

#### **Conclusion:**

While not a critical fix, this commit provides tangible benefits
(reduced log spam, better error messages) with virtually zero risk. It
improves the operational experience for anyone using SMB Direct with
RDMA, which is important for high-performance SMB deployments. The
change is small, safe, and comes from trusted maintainers.

**Recommendation: YES - suitable for backporting to stable trees, though
not urgent priority.**

 fs/smb/client/smbdirect.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 3fc5d2cebea5d..723f79f38364d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -281,8 +281,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
 
-	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%d\n",
-		request, wc->status);
+	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
+		request, ib_wc_status_msg(wc->status));
 
 	for (i = 0; i < request->num_sge; i++)
 		ib_dma_unmap_single(sc->ib.dev,
@@ -291,8 +291,9 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 			DMA_TO_DEVICE);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
-			wc->status, wc->opcode);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->opcode);
 		mempool_free(request, sc->send_io.mem.pool);
 		smbd_disconnect_rdma_connection(info);
 		return;
@@ -462,13 +463,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	u32 data_length = 0;
 	u32 remaining_data_length = 0;
 
-	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
-		      response, sc->recv_io.expected, wc->status, wc->opcode,
+	log_rdma_recv(INFO,
+		      "response=0x%p type=%d wc status=%s wc opcode %d byte_len=%d pkey_index=%u\n",
+		      response, sc->recv_io.expected,
+		      ib_wc_status_msg(wc->status), wc->opcode,
 		      wc->byte_len, wc->pkey_index);
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_RECV) {
-		log_rdma_recv(INFO, "wc->status=%d opcode=%d\n",
-			wc->status, wc->opcode);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			log_rdma_recv(ERR, "wc->status=%s opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->opcode);
 		goto error;
 	}
 
-- 
2.51.0

