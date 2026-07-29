Received: from mail-yx2-f3.google.com (mail-yx2-f3.google.com [74.125.224.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0113BC668
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 22:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785362439; cv=none; b=uF+DHpazHgSQD/xQT5Y85rm9Pn5soyrZ5+OTQ3+wKZUQekzv+2OfnoDbWsYAwsd6wG6YoZeWq8OHRLlNbJTCPbOOcJBbt3e8Yu546j9GgzRZoRpyG+JuCQK6ruBmJlILWl2fzzEftYwUNf+uIvH6IH6d+QDWzd7RoiNzg8P63g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785362439; c=relaxed/simple;
	bh=c0G3dmuuNY0dy2CHcZLFb3guPHeaGhZwlrnovkufTfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bwlOEsQ7lbeNLBeph4DoGt+Q20eKlZlME8ZX2Z4HxDqVwqF9bIaf5BQyL4hOhpRR4z0TZFMHI43xLMJ3zUGQ5VAjOiIqSoPyBWtMLtjy5ELOk3do1DalIwEPxUMZtlmget2/HawiHhY7nUKOJ1/LHryWtJ39zoq2SDfmO1NS0Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=northecho.dev; spf=none smtp.mailfrom=northecho.dev; dkim=pass (2048-bit key) header.d=northecho-dev.20251104.gappssmtp.com header.i=@northecho-dev.20251104.gappssmtp.com header.b=0DCmtErN; arc=none smtp.client-ip=74.125.224.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=northecho.dev
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=northecho.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=northecho-dev.20251104.gappssmtp.com header.i=@northecho-dev.20251104.gappssmtp.com header.b="0DCmtErN"
Received: by mail-yx2-f3.google.com with SMTP id 00721157ae682-81bedd55c10so396987b3.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=northecho-dev.20251104.gappssmtp.com; s=20251104; t=1785362435; x=1785967235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZUAsb9HYPBzr1dnWu/lrqicq+GYlgqjjIxv1YNlsFGk=;
        b=0DCmtErNWOnGrpZDJ4XvOOmkL0AfY4SRhs2y5vHP4gDWrJTGh4UryyoUQhRLOoIf4l
         vdrdV0PtMtEtL6y3dT1FiFTn0wvBhapDMhITSiBtA4pe52quzPFzu9L1YqcjeGINXWKO
         HZr8/bymqsYOb1j5JIWevTBKM9mInWx3JrPvI5eP52Bg/zBkxTBSGsoALnj02ckjv35P
         DX82lct1124vP2S+hTAIh6QJ5uVeSHoC3BiWCQcs6/WQvxQ1xrHb8KaBzvdWqh4V4mdM
         QO6zjeO/4wHb9LQIAM6sn1Fzaxl4FXxmXXGh9pqBNHQBstnlcQE/qN6JyYnbnx0V9q0P
         rWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785362435; x=1785967235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZUAsb9HYPBzr1dnWu/lrqicq+GYlgqjjIxv1YNlsFGk=;
        b=nx1Caa1lcDwp2/VtotpiHVNokMfgruZ93IUXbDWf3woh6Lz0z0/obkL/lQIVWH8SsE
         yoDQuKhjvWogZGPUCqFQZNRZy5fr3HI/l8il3xcH54SIMoyoxMSvadDdUDizBcZfh2yQ
         A2K7fWfzPXuoHZG/PvBNn1HQEz5yBVWEClnjCpyzrcPY1VqUcgzZq3qPlJawRFq+Qq8H
         C+rCCizNsuYmoUyKZY9e2O5V8NngwXgXK15Sdq9CnI4SU7ntw5Ke+M28fc/BQqM1mHek
         W/we7iXaXI68Zff36DnTQHEk6Em06jVVvQUe0vxYKg62IB5TmBZK2rKYwVgISYJtOsq4
         idRg==
X-Gm-Message-State: AOJu0YzjZ4nVXWfHBlWTjnJWS1Z/12I7jjz602YKEmjK+DRVPRPmo/jt
	zFYKuDdjSnEiuNZSh2rZWDO0dSEg1H0FO20Fk8pJDMFCg/kGJU7K14a0Sxk9OSutKoX5
X-Gm-Gg: AR+sD11TjcsNv7de1RUMjYtasklHP27jJ28QoBgB0aXuZhHGBEnzfaJgkkAnaS5Kthk
	Q2PfRYrRjYkKvMZxuLNmegm96dIZjJNXtm2xz3mg63ZJjetPc4B+YU+U5ZR/02JyR6UUAxX59GH
	ASP6QYX1FT0bKJ0vQ0fVZmRxB7Ziy+Svh8paipR9QzA7ckwnPQHH6aKnHLXNdZm0YCCXOknaZ4x
	LnSaEo4lHq/NV7V9yuvp6Tu0T7qptOsGyTORfdrqRVyx2qfiAP/pGQdMxIZo+Zz0ptPmOyBkeQ3
	96JyjlCVm1KO4lrQUwH2DYrk0siHiSi6+GQn4vzzsiEOUbh2L5nciIljnlrCXlope01XpyKKXk1
	vtYf/uLuj1L0CqTeYN0f4eIzSGMK1EsDuncz6lE448wUiSjWpRMjGT1+qkSUWoe5bCiXGfvUWMY
	z2Veu8w/fMp1wsVeY5smcKc3fje9wf3KEoz7ujg+c5EQb0RrnvZegyQS2Wjdc0JMk/nvltsXkT5
	OMG38eGXVzFFZICYYtOHXJjEH2WZFyQc0yd2jCLvLpXiMZ9tuWo
X-Received: by 2002:a05:690c:6987:b0:81e:ba5b:97d2 with SMTP id 00721157ae682-81fb5e800f1mr8501767b3.2.1785362434907;
        Wed, 29 Jul 2026 15:00:34 -0700 (PDT)
Received: from kelso.tail8e61da.ts.net (99-10-92-174.lightspeed.rlghnc.sbcglobal.net. [99.10.92.174])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fb7de8f28sm557587b3.28.2026.07.29.15.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 15:00:33 -0700 (PDT)
From: Christopher Lusk <clusk@northecho.dev>
To: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilov@microsoft.com,
	longli@microsoft.com,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	netfs@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: fix request buffer leak in smb2_new_read_req()
Date: Wed, 29 Jul 2026 18:00:17 -0400
Message-ID: <20260729220017.944651-1-clusk@northecho.dev>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_new_read_req() allocates the request buffer with
smb2_plain_req_init() but only publishes it to the caller with
*buf = req at the very end of the function. Two error returns sit in
between:

	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, server,
				 (void **) &req, total_len);
	if (rc)
		return rc;

	if (server == NULL)
		return -ECONNABORTED;
	[...]
		rdata->mr = smbd_register_mr(server->smbd_conn,
					     &rdata->subreq.io_iter,
					     true, need_invalidate);
		if (!rdata->mr)
			return -EAGAIN;

On either of them the buffer is neither released nor handed back, so
it is leaked. The caller cannot clean up after it: smb2_async_readv()
does 'goto out' on a non-zero return, which skips the
cifs_small_buf_release(buf) at async_readv_out, and buf has not been
assigned at that point in any case.

The write path has never had this problem. smb2_async_writev()
registers the memory region inline and jumps to its release label
instead of returning:

	wdata->mr = smbd_register_mr(...);
	if (!wdata->mr) {
		rc = -EAGAIN;
		goto async_writev_out;
	}

Commit b7972092199f ("cifs: smbd: Retry on memory registration
failure") changed both sides from -ENOBUFS to -EAGAIN in a single
patch, which puts the two shapes next to each other.

Only the -EAGAIN return is reachable in practice, because
smb2_plain_req_init() calls smb2_reconnect() first and that already
fails with -EIO when server is NULL, before anything is allocated.
Both returns are given the same treatment here rather than leaving
one of them correct only by accident.

Because -EAGAIN is a replayable error, the failure also reaches the
retry block at the end of smb2_async_readv(), which marks the
subrequest NETFS_SREQ_NEED_RETRY, so a failing registration can be
retried rather than ending the I/O, and every attempt that reaches it
leaks another buffer. smb2_should_replay() short-circuits on
tcon->retry, so on a hard mount the attempt count is not bounded by
the retrans setting.

Only the asynchronous read path is affected. The synchronous
SMB2_read() caller passes rdata == NULL and the memory registration
block is guarded on rdata.

The memory registration failure path was pointed out by the Sashiko
AI reviewer while it was reviewing an unrelated patch to
smb2_async_readv().

Fixes: bd3dcc6a22a9 ("CIFS: SMBD: Upper layer performs SMB read via RDMA write through memory registration")
Link: https://sashiko.dev/#/patchset/20260729192002.876156-1-clusk%40northecho.dev
Link: https://lore.kernel.org/all/20260729192002.876156-1-clusk@northecho.dev/
Assisted-by: Claude:claude-opus-5
Signed-off-by: Christopher Lusk <clusk@northecho.dev>
---
Tested by fault injection, not on real hardware. I have no SMB Direct
setup, so a throwaway debug patch forced the memory registration
failure branch on both the read and the write side, with a countdown
module parameter, and the resulting error paths were measured. The
mount was ordinary SMB2 over TCP; nothing was simulated beyond making
the registration return NULL.

Detector: small_buf_alloc_count, the counter behind "SMB Small
Req/Resp Buffer" in /proc/fs/cifs/Stats, incremented in
cifs_small_buf_get() and decremented in cifs_small_buf_release().
Second detector: kmemleak.

Same kernel, same test, without and with the patch:

                                        unpatched   patched
  clean read, no injection                    +0        +0
  5 reads, one forced read MR failure each    +5         0
  5 writes, one forced write MR failure each  +0        +0
  buffers still allocated after umount         5         0
  kmemleak objects under smb2_new_read_req     1         0

Both runs consumed all five injected failures on each side and
returned the same errors to userspace, so the only difference is the
leak. The write column is the control: the same forced failure on the
path that already has the release does not leak.

kmemleak on the unpatched run, the 448 byte object's contents
starting \xfeSMB:

  unreferenced object 0xffffa241013cca80 (size 448):
    comm "dd"
    backtrace:
      cifs_small_buf_get+0x15/0x30
      __smb2_plain_req_init+0x33/0x230
      smb2_new_read_req.constprop.0+0x93/0x2e0
      smb2_async_readv+0xfd/0x3c0
      cifs_issue_read+0x87/0x170

kmemleak found one of the five, which is the usual false negative
when the address is still lying around in stale stack memory. The
counter found all five.

Two limits worth stating. The five failures came from five separate
reads rather than five retries of one read: in this configuration the
read was unbuffered and netfs returned EAGAIN to userspace instead of
reissuing, while the write side did retry and completed successfully.
And forcing the branch says nothing about how often a real memory
registration fails, so the reachability argument in the changelog is
from reading the code, not from measurement.

Build: x86_64, gcc 15.2.1, W=1, clean in both
CONFIG_CIFS_SMB_DIRECT=y, which is what compiles the changed hunk,
and CONFIG_CIFS_SMB_DIRECT=n, which checks that the new label is
still reached. checkpatch --strict reports 0 errors, 0 warnings, 0
checks. Applies to cifs-2.6/for-next at fa724e235cfd and on top of
the earlier patch in this thread.

Not marked for stable. The leak is real but I cannot say how often
the path is taken in the field. If you think an unbounded leak under
persistent memory registration failure warrants a backport, please
add the tag.

Per Documentation/process/generated-content.rst: this patch, the
analysis in its changelog and the test harness were produced with the
assistance of Claude (claude-opus-5). The memory registration failure
path was surfaced by the Sashiko AI reviewer on an unrelated patch.
The claims were checked against the tree rather than taken from the
tools, and the numbers above are from runs I can reproduce.
 fs/smb/client/smb2pdu.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4ce165e40657..b885060be200 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4564,8 +4564,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	if (rc)
 		return rc;
 
-	if (server == NULL)
-		return -ECONNABORTED;
+	if (!server) {
+		rc = -ECONNABORTED;
+		goto free_req;
+	}
 
 	shdr = &req->hdr;
 	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
@@ -4596,8 +4598,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 
 		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
 					     true, need_invalidate);
-		if (!rdata->mr)
-			return -EAGAIN;
+		if (!rdata->mr) {
+			rc = -EAGAIN;
+			goto free_req;
+		}
 
 		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
 		if (need_invalidate)
@@ -4638,6 +4642,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 
 	*buf = req;
 	return rc;
+
+free_req:
+	cifs_small_buf_release(req);
+	return rc;
 }
 
 static void
-- 
2.54.0

