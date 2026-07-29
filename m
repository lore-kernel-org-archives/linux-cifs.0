Received: from mail-yx2-f4.google.com (mail-yx2-f4.google.com [74.125.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542083E3145
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 22:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785363061; cv=none; b=jc7edhijZQyJ2r4Dsiob9f16MBsyOc/jAFv89ftSkYTYdNHmmDHgJehUZIBdUFuPveSxMm0XzW+dc2XMrt2e5IhEjzxXFFzo8ipmzZnkbZX4GaNu0RrL2/zLUyJuyurnPDPyKytXBKdHSgZbINXw15M8koln48k6qUBhiewfz7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785363061; c=relaxed/simple;
	bh=Fm/ZsjlZUEnQKQVa9Pkq2OJ7WqamyVNg0vZrQ+JWmY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNQLSBhqPfsmfT6Oyo6WzRyNPU8U1AT/DCEjrvSwE9djc49wPsVM1XEPS1pe7Jy0v5Jim5vl6gFExvMwWI8k9lzXoH5pxjMawX7Wh2qfrJUBH/6j1FEYL1qhUar5AAVAwJJNy7gX2u7gA225xtUdPQ7iD8fAuT91PFxffk7iamg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=northecho.dev; spf=none smtp.mailfrom=northecho.dev; dkim=pass (2048-bit key) header.d=northecho-dev.20251104.gappssmtp.com header.i=@northecho-dev.20251104.gappssmtp.com header.b=iAm/zN07; arc=none smtp.client-ip=74.125.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=northecho.dev
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=northecho.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=northecho-dev.20251104.gappssmtp.com header.i=@northecho-dev.20251104.gappssmtp.com header.b="iAm/zN07"
Received: by mail-yx2-f4.google.com with SMTP id 00721157ae682-81e8f17ae82so271717b3.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jul 2026 15:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=northecho-dev.20251104.gappssmtp.com; s=20251104; t=1785363056; x=1785967856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bzbqd6cHw14arRCmdANVMgvo7OgWV+NcW27pLqH0Jzo=;
        b=iAm/zN07n6mmsEmq2xLb9OMRWGCbViwJZFnz0cV4dU8lqYYBdMrA5hDRrIGoKPMlAc
         F1jS4CnzX9xOF2n0LSZZT8jfMKxVDbRfBdpNIcMKqEr8NvFeXvD4ySaI9ON4kjAfSBjX
         5LajDAaTP+qOwYkYH+A3Sli7mrfRCFiue6YPEtgGGvuYbVtl2lfPIpuoPhBrBazaZ3P5
         SSJ9rRN6LLj4X+gPLMEzj5da70tx1T2HPU9CbjBxV4UdX8wVedg4RvwcopQEVlQsSCre
         H8h4ByAVZOTjncTDC/1O8PWVb3iQrSkvxrdydQ+YIqxijZgOtMfWsli1E/jS6OVlpsCb
         85DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785363056; x=1785967856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bzbqd6cHw14arRCmdANVMgvo7OgWV+NcW27pLqH0Jzo=;
        b=seMCfJwVLpy2glaDT0Xn6XuaOnHLnawKdoxZUIOTSAyF7I65rrrg/jkMm3c+reMJcL
         o43BvlKGhApzTqXqqNK8liD8QwWdzbR4nRAoNuCXlswqev76HAEqrJani49YinLS0I1Y
         rI0N5pCYaotADBpFhlQrHS0B/x4jd8eTYLq35FVBRTkiqUqWtyHB38+7+o+Ilc78U1Wf
         3BRI1eIYxg9SWH0spNbpnUopP64MoFAWSdBpLXaKlO2OsJV0SR4mW8j+ITd3o4AZPCC6
         R5qC7qoaRexTnHevOuW6pQ8oxkuyMvw6vbHFokM8KTgdKSuqQ7GkCx1cAVlniVIEeN8J
         QQKg==
X-Gm-Message-State: AOJu0Yz4/rowyY0qCNbLt9r2qryFnvV4EkqxrwPArwlb9SbHWKdDOmaX
	QIQa0J4rWOSwptOeu2yyEMieM6r0Qtej/PtJPUJW0ESRvvdZ5pyKbVGQo0WmAxQJwVJ6
X-Gm-Gg: AR+sD10fZHGdGOGqPdz8rGZ8E+cfMZoFVOTz78TQKDfKXMoKG3oYt6K+F2QHg/OSdJz
	aqEa4nnXAhxZlZ4gPSwLpLFgRGgyz7tlMb3LpMvK9dv2Twqss8JsENpZw4ligVaGWki/cXnowZU
	iA1ubAPI698+pYvEygVZaEd4AR3vsfOkNsJUVVTEoZ6rmqQ9L3Ar8nGAGOmAagnpeR1Y4oOKCi0
	Vtdsa5CAZH3k8eSjJjjlGjc+zIGmrbZscCkHXiJCSI1bNbaeqPSWSSDBml7oEavvIVjfZMZJMfh
	lNepfCzWVeLTrdSaBEWF2trNqvZa1qrCw3Q3Vht9xh9IhxiangPntCCLBcDXYmjqlmPwQTwQyQo
	5WU1IBLZRTEnJMvQ4bmHxh/EP+6DWIG4DWmN4ufSc6uH0ZS39qjZ7ubk8syk49g6K7jSm8dbbnV
	Tvm2iRLTGqrpzRx/Z/XnoUtD76b/sri/SdtxTgMagw47KftzYtmd58IVkoLuW1EbiaOjBg7vN5a
	uBQxieLqjE/tSlknjV04lf9CT8JCwjrdnoiPv2Rz/CELpSrs01pKsj6hzkBl+z6AB7kmo54Ab8=
X-Received: by 2002:a05:690c:298:b0:81d:45a:977b with SMTP id 00721157ae682-81fb5dded86mr9179807b3.4.1785363056078;
        Wed, 29 Jul 2026 15:10:56 -0700 (PDT)
Received: from kelso.tail8e61da.ts.net (99-10-92-174.lightspeed.rlghnc.sbcglobal.net. [99.10.92.174])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81fb7ded638sm658137b3.27.2026.07.29.15.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 15:10:55 -0700 (PDT)
From: Christopher Lusk <clusk@northecho.dev>
To: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	netfs@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smb: client: set replay flag on the read send-error retry path
Date: Wed, 29 Jul 2026 18:10:35 -0400
Message-ID: <20260729221035.944949-1-clusk@northecho.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260729192002.876156-1-clusk@northecho.dev>
References: <20260729192002.876156-1-clusk@northecho.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026, Steve French <smfrench@gmail.com> wrote:
> Any thoughts on the AI review comments from Sashiko?

Yes. Both comments are about pre-existing code rather than the line
this patch adds, and Sashiko says so itself in both cases. One of
them is a real bug, and I have sent a fix for it as a separate patch.
The other is a real property of the code, but it is symmetric with
the write path and this patch does not create it.

Details below. The code reading is against cifs-2.6/for-next at
fa724e23. I have no SMB Direct hardware, so the one thing I could
measure I measured by forcing the failure; the numbers are under
point 1.

1. The request buffer leak in smb2_new_read_req()

This one is real, and it is narrower than the comment suggests, and
it turns out to be another instance of exactly the read/write
asymmetry this patch is about.

smb2_new_read_req() allocates via smb2_plain_req_init() and then has
two early returns before it assigns *buf:

	rc = smb2_plain_req_init(SMB2_READ, ..., (void **)&req, total_len);
	if (rc)
		return rc;
	if (server == NULL)
		return -ECONNABORTED;
	...
	rdata->mr = smbd_register_mr(...);
	if (!rdata->mr)
		return -EAGAIN;

Only the -EAGAIN one is reachable. smb2_plain_req_init() calls
smb2_reconnect() first, and that already returns -EIO when !server,
before anything is allocated, so the -ECONNABORTED return is dead
code for any caller with a tcon.

On the -EAGAIN path the caller cannot clean up, because *buf was
never assigned and smb2_async_readv() does "goto out", which skips
cifs_small_buf_release(buf). So one small buf is leaked per attempt.

The write path already gets this right: smb2_async_writev() does the
MR registration itself and on failure does

	rc = -EAGAIN;
	goto async_writev_out;

which lands on cifs_small_buf_release(req). The read path leaks only
because the allocation is hidden inside the helper.

It is also not necessarily a one-shot leak. -EAGAIN is a replayable
error, so the failure reaches the retry block at the bottom of
smb2_async_readv(), which marks the subrequest
NETFS_SREQ_NEED_RETRY, and smb2_should_replay() starts with

	if (tcon->retry || (*pretries)++ < ...->retrans)

so on a hard mount the attempt count is not bounded by retrans. Every
attempt that reaches the failed registration leaks another buffer.

I want to be careful about how far I push that, because the testing
below only partly bears it out. Under forced failure the write side
was reissued and completed, but the read in my configuration was
unbuffered and netfs returned EAGAIN to userspace rather than
reissuing, so I got my per-attempt figure from five separate reads
rather than five retries of one. The per-attempt leak is measured;
how many attempts a real failure produces is not.

Scope: CONFIG_CIFS_SMB_DIRECT, and smb3_use_rdma_offload() true for
the I/O. The synchronous SMB2_read() caller passes rdata == NULL, and
the RDMA block is guarded on rdata, so it is the async read path
only.

None of this is new in my patch. The __set_bit(NETFS_SREQ_NEED_RETRY)
that closes the loop has been there since 2c1238a7477a. If anything
this patch slows the leak down, because the reissue now honours the
back-off that smb2_should_replay() had already computed.

The fix is on the list already, sent just before this mail:

  https://lore.kernel.org/linux-cifs/20260729220017.944651-1-clusk@northecho.dev/

It gives the function a common error label so both returns release
the buffer, rather than fixing only the one that can be reached
today:

	if (!server) {
		rc = -ECONNABORTED;
		goto free_req;
	}
	[...]
		if (!rdata->mr) {
			rc = -EAGAIN;
			goto free_req;
		}
	[...]
	*buf = req;
	return rc;

free_req:
	cifs_small_buf_release(req);
	return rc;

Fixes: bd3dcc6a22a9 ("CIFS: SMBD: Upper layer performs SMB read via
RDMA write through memory registration").

I could not test it on real hardware, so I forced the registration
failure with a throwaway debug patch, on both the read and the write
side, over an ordinary SMB2 TCP mount, and measured
small_buf_alloc_count from /proc/fs/cifs/Stats. Same kernel, same
test, without and with the fix:

                                        unpatched   patched
  clean read, no injection                    +0        +0
  5 reads, one forced read MR failure each    +5         0
  5 writes, one forced write MR failure each  +0        +0
  buffers still allocated after umount         5         0
  kmemleak objects under smb2_new_read_req     1         0

The write column is the control: the same forced failure on the path
that already has the release does not leak. kmemleak on the unpatched
run points at the 448 byte object with contents starting \xfeSMB and
a backtrace through cifs_small_buf_get, __smb2_plain_req_init,
smb2_new_read_req, smb2_async_readv, cifs_issue_read.

Full numbers, the injector diff, and the two caveats I want on the
record are in the patch's below-fold.

2. rdata->replay is never cleared

The mechanism is right. netfs reuses the same subrequest object for
retries and short-read continuations (netfs_reissue_read() and
netfs_retry_read_subrequests() adjust start/len and reissue the same
netfs_io_subrequest), so the enclosing cifs_io_subrequest, and with
it ->replay and ->cur_sleep, survives. Nothing in fs/smb/client ever
clears either field. So after one genuine replayable error on a
subrequest, a later continuation for the remaining bytes will sleep
up to CIFS_MAX_SLEEP and set SMB2_FLAGS_REPLAY_OPERATION on a request
that is not a replay.

But this is symmetric, and it predates this patch on both sides.
wdata->replay is set in smb2_writev_callback() and in
smb2_async_writev()'s out: block, and is likewise never cleared, so
short-write continuations behave the same way today. On the read
side, smb2_readv_callback() already sets rdata->replay. What this
patch changes is that the read send-error path now behaves like the
read response path and like both write paths. It widens an existing
condition rather than introducing one.

Worth noting that the async read and write paths are the only replay
users in the file that carry the flag in a structure. Every other
caller uses the replay_again: loop and recomputes .replay = !!(retries)
from a local counter on each attempt, so the flag cannot outlive the
attempt that set it.

If you and Shyam agree that the stickiness is wrong, the fix is to
clear ->replay and ->cur_sleep on both paths when a reissue is not a
retry after a replayable error. That is a behaviour change to the
read and write paths both, so it belongs in its own patch, and I did
not want to assume: a subrequest that has already failed once staying
in back-off mode is a defensible design, and I would rather hear
whether it was the intent.

So: the leak fix is out as a standalone patch, and I will write the
replay-clearing one only if you want it. If you would rather have all
of this as one series together with the patch this is a reply to, say
so and I will respin.

Analysis and test harness assisted by Claude (claude-opus-5). The
numbers under point 1 are measured; everything else above is from
reading the code at fa724e23.
