Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.145
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793064608;
	b=yBpeDzw4d4EWWBfwYsQQXX6pguhEQDD0QIK0xX/7Qvbl1kS28LTY2cSYNiLbduTdNziL
	 qUbO7GiahIU1eiTEU/B4gl3FgF6gG4Fk3QaG272zyaP7oGpWaicKF9XtUkAm+90vLKChc
	 tQyY90uqKvT7HmvQOm1EM/WtKBgfV62ghIR0ZiOhQhxzYi67lQDrKCz1o+EcLtpoVM5UE
	 gr0gs21nLsycf/4jHhILk7gqOd9lNLjv8seJ7XgIE/I1sKmKcEJ4LR3k+4TA8WoEU88B8
	 7Tn6kmysgnFC3+OtJDNmMy+DRhL2bKlPWkrIvi8UlCsVRorprewoP4YDBI5/ANoJHng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793064608;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Nw6sAIOlxyEJPZz8sIrCLx9P5iIUS4/rUwm28WaKwHs=;
	b=lYs9KKuogZH1h9hzktV7wyBkMAoeAC4omEMYAv3zeUjWzR1CdmuDGzAKPM5qXSUYIDSR
	 E4NNfgRwYE+PFGtO3Nz+6NAfHlM1gPxjEdjFFMWlRkt7jtXZQVp13/DVdubTglXD+t8gY
	 sC7NVeWR4y9VWYlLpjAru6QLxTmDVej2yJjrOyYdqd2vH8duYi5/Zk/AOc4E/a5ISJEet
	 Ld1iJ8EuH2trQSq7VLwj8JCRA80QHJCV0E6gNCd1CakParLcjJVq85rlsm79gOX3GlDQH
	 ih46iAp6aKdCqCpYljCOJenG7QW/ntKQRr0BRjjQUeoosxPGLzct0wJIAaEFDXkRHoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b="bceoZ/TA";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=NTeeqMk3;
	arc=none smtp.remote-ip=103.168.172.145
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A62606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 01:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7A62606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=bceoZ/TA;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=NTeeqMk3
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id E847AEC0823
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 21:30:06 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Mon, 26 Oct 2026 21:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793064606; x=1793151006; bh=Nw6sAIOlxyEJPZz8sIrCL
	x9P5iIUS4/rUwm28WaKwHs=; b=bceoZ/TATPBixN0j80VTBRSRt4qFvBbR5aI17
	xkJjhMGLZmrsd6Xbhf9liEAvn+LSP0eVpYtPg5rm+xgiLGMap2HMtRj3LASbZDfT
	rZvUszjnJ53BZ48cTyNp0Cx3uOi9sc07z797rHGJGYbpjmkf9RNBu71SUn31spYN
	n0PTLo++PxnqDtm3q5h8Oihc/jdeKNmPnjHX57dyaGFuQ+24ywtYkISylgODnoS2
	lluB31No6XxKqbuCOEin3361Cuy+VYFdw/40JjRMgkj7/01Q1/dCVTAySeWTTuGS
	qRIXKg41QTEzuPwC2QOT9SFSqc2MSY3TPXFNoIWm+oxkLzwYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793064606; x=1793151006; bh=Nw6sAIOlxyEJPZz8sIrCLx9P5iIUS4/rUwm
	28WaKwHs=; b=NTeeqMk3Tja3eaio+fFvTPzNvry0D0kKWirMCeQb3yh7UPhdHIn
	7ZAWAxhC6sQ/aS9pQCrwZB8/0O3nZGttfFKZZtKeOdmEvKrgkDBwnTymDqGKzmbJ
	i3oUaO6t1pHt2RfnC2DLCobFVqqDn0qZI6/ov9nVD9Hf237WAVqiK3UEopYWtBrC
	6G8fv+FkRFssf2yQyp1GUg51P2zZN2MMGkZo/MTxG4M05tegcdkwS3nZfIwMAgwj
	hPs4D0dTD+s+uPKTi4bOw8KIxLX8GrXRLdVK90ZNFkkbitGqmOfvFl9+Tqfl2wn9
	MAqW5moLs+4GuEHbX5bgaZhIQEfDpWF3qBQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793064606; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:k14NFc6Fmz4iEldaTbNvSeITnMwFGyMoejvAOrEEVU2FI6k
	qfKJu0iVMhLMmwEEYRW7FiF5QcVPj7SjQnFXtKlY6XLUR2KtCSseTs69kRy/dPft
	Befr9xCRKTTMmJBLYGZRMIpnYmyq6uylHVTspnz5CF4HAhbmY81bNLMafS8RF2IL
	xcnGB+5LXSea6tFbrbEW8ye8pInsJXYhItXgrLPukPfYTzesun11mhwOKGQcfwRJ
	KWGL7kMJ3SLIij901kHmKGd2muwFg19xkYDe/eRNWQHNBzhJ3k8DPeNqNAtHNJC3
	B3WpMbZ1Z17uLfE0hWsr7uLX9gOIEdHF04MmtHQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:sAGhZIz/NOe+xUOOF/0QtX+gTH+KTsC2GX7PpaEuRJM=:zC2zVA7/UVzZsvQu4vMW4UxLD0oh9ArSq6JDOjgbqME=;
X-ME-Sender: <xms:nf7fatOZTzTTmniQOlLLGCyrBaKqg_WdvxJyuv9eYiKhTO1EX2W_gg>
    <xme:nf7fasj3ZwrlY68mXlB_OJF2CgwqSEHVecmR3K71D1iO_HQS8baks8M0d0JqkA8Qw
    d8U5I_sTNbcPMwSGtE-4xxdPVMZYUM-7XA8EpiDNCJ_ZRPpSpOdlw>
X-ME-Received: <xmr:nf7fagtp6CYdyeL_xs1sszkvCl110wIG5XeJ6glsDq_BL5wV3TwR1CXsf2h-nKPT>
X-ME-Proxy-Cause: dmFkZTEpp17IL1do7w68l88CNNMIlrDD2itkOhM5AWkaeXa/vm9O/8LEwLeYktRhF1hBld
    nwfrGcfvfvFqrEadI+viedAE7J4cgnGIjooFyvKHcNc/OjHnc+YWYUZklImqJzYwbeR/xZ
    tjipQfNgfUAnVywwRJvAR60QpL8lIdn9B5EluGfSSPGWPjTj5bTW+7Qg1rkf3xBfhwFS5s
    4XmTzCfNdPHiSRu4Yz/kqZOeT9U14pyJ7RjWvmoTuqKM4HDuYco3n68Mqjn3cCjfci+LAu
    A/ID6mYFS/CPavI7GC0ArGyIEDdyl1ubRTKfa9k4IG+1+rFWX42RjdngYPMMAayA5ulZeb
    s/dlQrHypTT2FwTBbLmv19zIIExajaW+jtpkFOy3YzZulCfjelZseTAIYDwOqNgb8uqHHe
    B+BMIBZ21rRGxnro8bL6vbB+iUo0AIn5N8GReuCnq0c7Ps2e7zpiq5TtV02xS4h4HQ27lN
    6lNTJTAWaqvMIkFMsAaSAQ0+m2bTR0pr4S7nhKgr+iT75czzhvTljQBbEZqhdgLOurecr8
    eFjaXCA+Lu4gdyknKszRPSWbRG1XYtQaFAmYcRrUqWKYwx2OkhBFLaOWacPSKwTKWr/a4W
    nPTZ0hepek5u59rT0tQAoMAlecgJSmTTTd1pzv/iDP6p1h7SWk9+d3+6vcag
X-ME-Proxy: <xmx:nf7fagid7e8ROCyxQRbuiRT4I2r7GCwpPM2N4ZtXungxGYj4h1soMw>
    <xmx:nf7fambkvrKptqld0QPMoDd5ofDd6tcvjMH4vfVutF5VF3UiC_k9fg>
    <xmx:nf7favZahXfapJnQm7hHV6z614jBL5EupxV3L0k7s8z6vfKlzL_nOg>
    <xmx:nf7farwnCXb7tldqqFYQGeGgW9MPHredzYz6HXg5Vvkx8eYNyB38FQ>
    <xmx:nv7fapFOpOZaKLulU5oZyHmM96s8t5NLpBCD6NsESuzUXP64FKtyrD3A>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 21:30:04 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Gael Blivet <gael.blivet@gmail.com>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: fix SMB2 CREATE response buffer overflow in compound requests
Date: Mon, 26 Oct 2026 20:29:47 -0500
Message-ID: <20261027012947.107852-1-icb@fastmail.org>
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

A CREATE response that carries an AAPL create context can reach
create_rsp_size (572 bytes for SMB 3.1.1). Commit 713c31a3a225
("ksmbd: fix SMB2 CREATE response buffer overflow") makes
smb2_allocate_rsp_buf() reserve that much, but only for the first
command of a compound. A CREATE later in the compound is guarded by
is_chained_smb2_message() instead, which reserves only
MAX_CIFS_SMALL_BUFFER_SIZE (448 bytes) for the next response. smb2_open()
then appends the create contexts without checking the space left.

That check also uses the unpadded length of the response so far.
init_chained_smb2_rsp() pads the previous response to 8 bytes before the
next command runs, so the next response can start up to 7 bytes later
than the check assumes.

When a CREATE follows a command that fills the response buffer, such as
QUERY_DIRECTORY, it writes its create contexts past the end of the
buffer. The AAPL context is written last.

  BUG: KASAN: slab-out-of-bounds in create_aapl_rsp_buf+0x31/0x6e0 [ksmbd]
  Call Trace:
   create_aapl_rsp_buf+0x31/0x6e0 [ksmbd]
   smb2_open+0x4fa8/0xd900 [ksmbd]
   handle_ksmbd_work+0x88c/0x1cb0 [ksmbd]

When the next command is a CREATE, reserve create_rsp_size, as
smb2_allocate_rsp_buf() does for a single CREATE, and check the reserve
against the 8-byte aligned offset where the next response starts.

Fixes: 8f1b796ff113 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context support")
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs a client on a share with "time machine = yes" to send a
    compound whose earlier commands fill the response buffer (for example
    QUERY_DIRECTORY), followed by a related CREATE that requests an AAPL
    create context. Where that share also allows guest access (guest ok),
    it is reachable without credentials.

    A reproducer is available on request.

    This fix was developed with LLM assistance (code review and KASAN
    reproduction).

    Tested on ksmbd-for-next 146c3fc6540e with only this patch applied,
    under KASAN. "smb2 max trans" was lowered (65536, 65560, 65564) so that
    the response buffer ends in a KASAN redzone. Before the patch, a CREATE
    after QUERY_DIRECTORY commands that fill the buffer overruns it by 68
    bytes, and a CREATE after an ECHO (68-byte response, padded to 72)
    overruns it by 4 bytes. With this patch both are refused ("next response
    offset exceeds response buffer size") and KASAN stays quiet. A chained
    CREATE that ends exactly at the end of the buffer is still accepted and
    returns all its contexts. Standalone and compounded CREATEs, including
    CREATE+AAPL, are unaffected.

 fs/smb/server/smb2pdu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f5fe3cf8ba32..db3a0500f9f3 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -691,6 +691,9 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 	hdr = ksmbd_req_buf_next(work);
 	next_cmd = le32_to_cpu(hdr->NextCommand);
 	if (next_cmd > 0) {
+		size_t next_rsp_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
+		struct smb2_hdr *next_hdr;
+
 		if ((u64)work->next_smb2_rcv_hdr_off + next_cmd +
 			__SMB2_HEADER_STRUCTURE_SIZE >
 		    get_rfc1002_len(work->request_buf)) {
@@ -699,8 +702,19 @@ bool is_chained_smb2_message(struct ksmbd_work *work)
 			return false;
 		}
 
-		if ((u64)get_rfc1002_len(work->response_buf) + MAX_CIFS_SMALL_BUFFER_SIZE >
-		    work->response_sz) {
+		/*
+		 * The next response starts at the 8-byte aligned end of this one.
+		 * smb2_open() appends create contexts without checking the space
+		 * left, so reserve the largest CREATE response for a chained
+		 * CREATE, as smb2_allocate_rsp_buf() does for a single one.
+		 */
+		next_hdr = (struct smb2_hdr *)((char *)hdr + next_cmd);
+		if (le16_to_cpu(next_hdr->Command) == SMB2_CREATE_HE)
+			next_rsp_sz = max_t(size_t, next_rsp_sz,
+					    work->conn->vals->create_rsp_size);
+
+		if ((u64)ALIGN(get_rfc1002_len(work->response_buf), 8) +
+		    next_rsp_sz > work->response_sz) {
 			pr_err("next response offset exceeds response buffer size\n");
 			return false;
 		}

base-commit: 146c3fc6540e24eef6296395a35bf5b924182e8b
-- 
2.47.3

