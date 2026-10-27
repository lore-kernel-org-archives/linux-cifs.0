Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793065231;
	b=5N4+e+uloS7hcGObm/CZAOYGtGDIfiJ9YGvwbXqylAMtj2HSN5OHgFLE8H3utzqU7obc
	 614BNR85rogyxzFORgteDDSMnzjU0+SJ94Br4CYKlfs00CH6nLB7GvwBDh6pVRAebLDrI
	 ujyeTbVMAlyuwJDazhfVfnuMxYk7gQ2hswbzSOUW3ob0+ybKltORP/6AjmKG33xf8fcYB
	 UoQPQuH+qWuMzONn63AjP6YGX3KDuJWZxuyeCJfC5mgKuumFIEsFNjlHmaZgy31KP2yfW
	 7/h+z734lMutdTPJ1ah95lrw8lY9Y83753dBY4osopkTjLQpPFm+TibxUY2Tuuf0gdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793065231;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BkXkcM2hnjFWl9v28Vxsd/Upl1qj7NsrUbXI+iAyTm0=;
	b=eh8hmgE5LXzuyt4aMHlpDZdf57XaDdWjlvAg08wpAXMkR6hboGDg7YU+3L46XayZ/gBU
	 Nz2561mOfE+fqiLkT5Ay/mB9MtGKpOIMmjCpR1Q3YPY83rus2Eh3AarXelhe6ZEFXxKRR
	 O7VoyTiTK+byYa40umJ4UxFqN6tx4Slgyy8RCo/h7FyLs6rhqpBo2KPb+ltscWYBBUx++
	 4vzw6bue8ZamVRrX1txYmpvUwOAMi82V8yRmm3EnZgPfbPyu4ywc0gN6md2TIcmFjZGWf
	 /UPyYMgpmYCtaiB3yt53ExOYWurmjKGozGXHaJFkF8mIqk5Pp3npJMHMVNvJuiySy0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=guSmXYdq;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=iH2nk1m6;
	arc=none smtp.remote-ip=103.168.172.145
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFDD606A321
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 01:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4DFDD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=guSmXYdq;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=iH2nk1m6
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 8ABA2EC0823
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 21:40:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 26 Oct 2026 21:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793065230; x=1793151630; bh=BkXkcM2hnjFWl9v28Vxsd
	/Upl1qj7NsrUbXI+iAyTm0=; b=guSmXYdq4YiKcYclTRsHh19DXM7aaAC6bndgs
	SUaJFDriiz+z9YMjqjXCyj+kbLspsq0xV8+2Al57GILG3bZWGM8G5Aojp1imOEJm
	Lapd6ZSuCwOmks7BfwF7i0bKoaohdHJryoMzjObO7rmAoDnu27m4Rjqq40kyJchW
	bIL039KtdO5aKxSRaSheyngDqETwZdg9+1SK21EiJRfUPZW9v/a/DxGm/AscpUSL
	7wgf6fBh6O4Pi8zWv+5u6RTkffv1sqY15NQOWKOn6dH3r61Rmkx3neCwa3y3ZzUQ
	ZEf5DM/5xPY6bNPnVadDZQaBg0Zqw8OaYOv2nDcZOsrSDYf9A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793065230; x=1793151630; bh=BkXkcM2hnjFWl9v28Vxsd/Upl1qj7NsrUbX
	I+iAyTm0=; b=iH2nk1m6zM5xucMo85aPLmwlayauindkEQvGcGv7d9z+oo7USyw
	zmXxDuXg44SDd8+Uh8mDj2sGD10Kmdr5wTSozAIj7ObW9p6CH7RSb3wF0M3XPcfZ
	Egd55lCFrur1QvICdhrKb6XLTraUz9CRTnlnmxCUGawdhiF0zdYKI7s9wvIO5aby
	hC5naFBa4/+uvoWfmgdPuKSGynbhJ4BYOk3Z38FFz53IkTH+iYhfarYT/gZuYnzk
	vYAl4g1sYi6Lv6l/6i07zD62liSSTXJ4Txg18UJ+2+Dbnx39bqLB4XU3YIclI+UJ
	73Al+ylBTbGvEf+5Nj/mJ5v0NorOcydPaCg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793065230; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:FxF2seLtZLioOy2h6YnKJXrRJa+jw6BbVFltRmEcS/9yS7w
	ZHLMdOgbFHDk1wuHepwJxLU/JNopbPQa5Mo6x/SQ7SMWpH6cksIKLbzLbk9QMx0v
	3B1/Kj6kEtqgqq+nuVY/tP4mqII4/7Lla3GLQT5xujXEU1evP14Z6VzLO/YPFndx
	0ZAgYwYNEJLEE4atOiBhw3jEdMWLoQ3nDhpE8b3z+g2k50A9iIPY54wsjvQ1jNO9
	ongGTVBLI1wJytlR7mvqbgxTvgVTH3ESqtLUxM0F9QZG/dblfm9ayS0q+rJCuJHh
	pUtSOZ94nAB/rphODbAuvoxBYRf0EMFrmzNZ7IQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:JSKyhtfkzb8SipyzlO9D8s9e93a5mzMBI+TrfaaqzRk=:gZoN+jJWo6aBR/Y71g9u2luMhMBya8Sq+nCG+t54gDg=;
X-ME-Sender: <xms:DQHgaj13oUTIeLNBE1hR-RUmNEbdu3nO3dZ3SgCQL2Dh04yP_aLXhA>
    <xme:DQHgat9lARM8Y_ZABdEk3MVz7fpDFZEiTzasB42EJJNLepwbESF3pyQk45gVTgcjO
    pWCN3w2AHVgYMf4rxw1txNxJCkrjvdFT9DGKheegiACWz1-C0FSVbs>
X-ME-Received: <xmr:DQHgag7VfXTwJGPY3-jN4CPQU9u4s8VNJu294VrkVfreRy3Pj86lw9cs7Awn1oFA>
X-ME-Proxy-Cause: dmFkZTFxZ8iPiYUXlVN1g41AZDpnk6ig7exYgtvZ7ivnbLC/ZuFvE+cYT6vZLYlRY+LN4f
    OIan/aaRo71bUQaVqjn4W2dKlVF8rgSEOWzUg5cctUSR+07ZodC0w67WuGvxMoQfrEx088
    1estAJIxI0N6YTj9FZYPnF1UCCBTOy1ZRZk0qiM3hh3zHxI7wylrRH6F3cBHzgRA/SW1Um
    FIWv80//Vo8bJPxypfKJWY6dvJufqVWRuchRtTzmPPpgT4caiQ8BhyX/DY7T+7hcAxAnxb
    0oOI4+H/HavlDoiEHTgyW+ysRbrRrKkxJGG4sczShh+fDS9LgaZQEraHHWPPAy/6A/NhKq
    PkbGGiIjC+U/cGKJW/NumsjLnIAtcS5f01kE9jMKuI8M87ZGM0t77VzK7k9cqTh87PPKPj
    kXOSw9VCTGTXMyHuZy2VMyCYyqhqAE7FggxYrmrUpMLsSfeQupz/Zkn4QIulEf/t8+AgI0
    ioWgDg9ezGcPka9JdvYsC81V5ua00dzy6hFfYNs21v1NFWGFtAeRyWYFEZuf5rdtfzVpoJ
    Stech4QNNSM6013DEGKZfNtPt8b2c8gDIMFnvhQjAwymJWN0eOgMwO3iA1vWwkQVfiWYwS
    rrm/FqqKK5OzKxlqdHd6AwfAdtSwZKDNUqE3R9I7flOSqqNl8ZLvMJh7HvmQ
X-ME-Proxy: <xmx:DQHgatu1F_Hz9oyse-AfBxgUgj1dtz0aIqs1VbGRBQCifX8OAHcbPA>
    <xmx:DQHgaq1psExUvnVEOq_bXMA8PKqR0OmfnYdVaUl6tAA2Uag5lc7tGQ>
    <xmx:DQHgauqpOMqcK6O6V9VsURMdWGU5dN-KRZTvbAdJBCCnGeFYUlqqzA>
    <xmx:DQHgaiIrC9kepgh3V5RVqTWyFlC9oeXnol7pcbSgtohz0rQnPDcoJg>
    <xmx:DgHgaghlb7UUU0x8g3naJ3efVVHsNwhrSzdfMxyObyvnKCWBsdxEar78>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 21:40:28 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix out-of-bounds read when padding the final compound response
Date: Mon, 26 Oct 2026 20:40:21 -0500
Message-ID: <20261027014021.108390-1-icb@fastmail.org>
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

Compound response handling pads the last response of a compound to an
8-byte boundary by growing the final iov and the RFC1002 length.
smb2_allocate_rsp_buf() allocates exactly response_sz. A command can
fill the response buffer to within 7 bytes of its end, for example a
QUERY_INFO whose output is bounded only by the space left. The padding
can then run past the allocation, and ksmbd_tcp_writev() reads those
bytes when it sends the response.

  BUG: KASAN: slab-out-of-bounds in _copy_from_iter+0x744/0x10e0
  Call Trace:
   _copy_from_iter+0x744/0x10e0
   tcp_sendmsg_locked+0x2290/0x3f80
   ksmbd_tcp_writev+0x10c7/0x1ab0 [ksmbd]

Allocate room for the padding when the request is a compound, as
smb2_read() and smb2_read_pipe() do for their payloads. response_sz is
unchanged, so commands still fill only up to it, and kvzalloc() zeroes
the padding.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs a client to send a compound request whose last command
    fills the response buffer to within 7 bytes of its end, at an offset
    that is not a multiple of 8. The reproducer uses QUERY_INFO
    FILE_ALL_INFORMATION as the last command, after QUERY_DIRECTORY
    commands that fill the buffer. On a share that allows guest access
    (guest ok) it is reachable without credentials.
    
    This follows 73f860489e3b ("ksmbd: zero pipe read compound padding"),
    which fixed the same padding for smb2_read_pipe()'s payload buffer.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance (code review and KASAN
    reproduction).
    
    Tested on ksmbd-for-next 146c3fc6540e with only this patch applied,
    under KASAN. "smb2 max trans" was lowered to 65560 so that response_sz
    ends at a KASAN redzone. Before the patch, the compound above triggers a
    KASAN slab-out-of-bounds read in _copy_from_iter() during the socket
    send. After it, the last response is still padded to 8 bytes, the
    padding is zero, QUERY_INFO returns its full output and KASAN stays
    quiet.

 fs/smb/server/smb2pdu.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5fe3cf8ba32..140604099bb0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -955,7 +955,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	struct smb_version_values *vals = work->conn->vals;
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
 	size_t large_sz = small_sz + vals->max_trans_size;
-	size_t sz = small_sz;
+	size_t sz = small_sz, pad_sz = 0;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
@@ -981,10 +981,17 @@ int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 	}
 
 	/* allocate large response buf for chained commands */
-	if (le32_to_cpu(hdr->NextCommand) > 0)
+	if (le32_to_cpu(hdr->NextCommand) > 0) {
 		sz = large_sz;
+		/*
+		 * is_chained_smb2_message() pads the last response of a
+		 * compound to 8 bytes, which can take it past response_sz.
+		 * Leave room for the padding. kvzalloc() zeroes it.
+		 */
+		pad_sz = ALIGN(sz - sizeof(__be32), 8) - (sz - sizeof(__be32));
+	}
 
-	work->response_buf = kvzalloc(sz, KSMBD_DEFAULT_GFP);
+	work->response_buf = kvzalloc(sz + pad_sz, KSMBD_DEFAULT_GFP);
 	if (!work->response_buf)
 		return -ENOMEM;
 

base-commit: 146c3fc6540e24eef6296395a35bf5b924182e8b
-- 
2.47.3

