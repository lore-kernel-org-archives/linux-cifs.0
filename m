Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817439;
	b=y1N62F30TOgYDQ5wjOZ0nwfQ8aAONc3IkCAH4A6xlCeZ7z5WoLwKt/o3Kut9iygHuUXf
	 bWpy5v93wYASyaI8E6yhMMTXLPs4LwZavWtvP73GbTTSudnfVCbC+KrGDKKsWScNshz5K
	 ydz6QJqPUENomEREgslC318M0hq6G6DOAOhALo3hFJxmT63E6cEjhz8BjjWgmLYiuI8X9
	 onBXJL8YI6iZH9qNIJtB0jvxHFVDcimCKD8h+Duu5xbzuZ0go24azVqmwHgDGrYhCrxvp
	 jifItW1Do7GAPD1QS3E6l56kgW4jz3K3DTM4y106deZPiGCTdPFxmtcqvDqZHmMaNcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817439;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=uTQKWhv6qDaS9Ce13nmHd5vH29F477/AQuILC98uzec=;
	b=3ZPDNTjpNP+wocf5MctkV33bLWiJRW49Gb+fWEW+zfPt3ByHjMFOhevyM4uCAZsNerr3
	 5tiksc9TRPSgol0+09Ab3MHjm2/QKAfYH2HwT54wTXfK/78UqALj8O3Fkaw4rRL5Er55n
	 fL61kRkd68XbARrJpJToEyBYDI1YDP+XZs6KwV0IOSnWb4akGmmJ/H2ruAA29LNHwXEFJ
	 mxtYhzVy4b+LXXnbUZG87AO0H4SrSjoEHOcZKbhLCNf1LPAHZudAZUyebVMkPMv/f6Y4N
	 7enMUxkHNk2qhtR2rwEGSLkx4xWSznKvTvpgvLj2rJcfDH30wSlFH0cA2/wC6eRlJxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Bk3BsH2w;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=nx13xKSs;
	arc=none smtp.remote-ip=103.168.172.144
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F7F606A31B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 18:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7F7F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=Bk3BsH2w;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=nx13xKSs
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 01DACEC22A1
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 13:37:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 04 Nov 2026 13:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1793817437; x=
	1793903837; bh=uTQKWhv6qDaS9Ce13nmHd5vH29F477/AQuILC98uzec=; b=B
	k3BsH2wuIULrOMyTEb5PHnQ56xxuUvF9wDh5rlUycXkKhyHr1odO6kUh/Po+4OOv
	WYrtjjuhMzyhnq+eofhKDwLD9gA+CBInc8rwgXJtAS904htQqKTJp2gYBLBZZnTd
	gjRn88hhyERhyZRcGo+htpJWTKpmxwDa2deHXIOPY61eEqNe/sVQYDd3yxEhBLE6
	X1ma8OvpeqDgeCSyHjIVwTxnXlbF2yTC+DXhdLGuSrdcZpBq3zl+9u0fszK+GtWf
	otGBy7uuCXtiGDTnHvew+V5Fiy/8Y30otUjjbmWoVB1RiwSjtq/D5btqIlDbM+nV
	kmeu3vru4Hliov3kTCtlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793817437; x=1793903837; bh=u
	TQKWhv6qDaS9Ce13nmHd5vH29F477/AQuILC98uzec=; b=nx13xKSsu7/GjRd4N
	57wQqqYQ1MyLwtT7EUeGalOOCmt9bK+0gNDy0X17y/1HpFuB4dFKGF5g7lmuqIUc
	Rlc5QvQnzgIqi+QioQ4tP64dqZQ52CJhiWZJmuF/LI+PwN8RNWOs8weN2hSjvjKt
	6Jo3ck7lGhojvd3dqI1SAg8fNROG5H2Fw2YgE89VPhBEHT4eAr6eTJPdx/I4dwuq
	4nn++a2/U5iWS/b6AeveDdH7IwX40WDsPvbRlCn/QX4FXaoIGjNUd6i9G58UAX/Y
	pkPJrMMjBVD3t06s6PfkXOAqHw5r0wKv0y5mjzwRcm9Z4HxSMJlEgo03HWK6Bcek
	ZszXw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793817437; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:AuJ6klBytLbLSspVaVL+MU0SyKp0p75V+BDNYhXCE65aLmj
	3C6JhggvQdbQrH6eo34s8kLq3IQ/N+Y0FYRqspRwvS/VSj02H3qg3mlGDT4vcgcO
	AFaftMSvqStFDloTw+Wvtoe/7YgCR9pECeHuMZ+Ejws82uDSjO967kEQfnbkRDAd
	hIAfqW7/PVZHUfntoqsIVEkC2JpseCC0zTNRCPwRpwdxJBHGt/QR6F8wafEHD2aD
	T0UFG+FjQoyz9zv9ZnEhbjjRsBid3Vc5//dAnVPJAzPwnKtMmgYRPbTfkWJ+7s12
	EbY/E0VWGUGEVEeqUDXI3HX/Vv1wmByjQJjbJXg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:bYeUlbYB/VuhywXjoMvYgNNaQTtSnKfYjbwr9M4DO6E=:aCH4P2JKwQkkWN3GnwUvAMttwBYLyoBgQYaR57TgSbc=;
X-ME-Sender: <xms:XXvramAbfOottiPFpJeQ_dRWi22LZoBExIq4NReNXsuoLmOja512Qg>
    <xme:XXvrasjlp7SxzmfkgryhWzn6gObr2qLocW0CGo9cuVEFsmA2JfrI56BEUQi9zpj-u
    jLJ25hBoRIj_9ntt1fMjPfWDeUcwzMCgcftvr8f9bCUOudhcTwixduv>
X-ME-Received: <xmr:XXvrarzWEYtkOAePi6yxp3X6FTKoJpl7fe2qtBAbeoONHFeFQTSFcotiSK-HaOBy>
X-ME-Proxy-Cause: dmFkZTEblcHx/HDxFYlMFcbymSWqyds+9SvV1QaPrW0QEo3CjxLejIUk7IoZMnIcIcK09t
    Sf2DPWxDNGVGfZTEvJSbeR6vwwpsAEP6dBoZF+eYZB/kBLgv+8+qbCiKM2Nje78vp3KEHx
    wF6XnfC0SMLcn/gNeYt8cZ1zXEu/47jXRWfqT7uBEZOGVFQ9t3lywBMwd8cUYUPfmVOucN
    pQJBumNoS4lDaYUyss/ZCJHxCr55seI2WewamYMIvpaIRnjWBWAiUYQ3QsSpYCsWmmQ4Pf
    YC9iNbxaAMc9qav/iJNwWsZnOcuojuf1PmKSHkIfmC9QentwYhBT71RjRhruw5g9bsfdWV
    pgn9wK5ePc0n5O6l/u+YL2Dj0aBFIakcsrSxwU/9PP3PdU8tRcUY6kfpUvmDEj1axp/R7g
    LT9XlPbVqdVC0lIg9L2/Qs4KfFEn4aO05PV3Y4g4tcsx6cuR2/baUA3szRrttqC51DCOdE
    IgDTHkk4jDN2woPdQ613FRRjukejDFdudZ2APeIMavCtIggjGGv9c5NGcb50q1imukKrW4
    lwXUUS+eP5Nr0DsZT4762oCqhovxKf9TlbXs/MAaPlV8r1UZV91BZlenzVlpS4eMrDztE4
    UAVStI/1ojsZgf3yrekKP3xtiAYx6S4GqVzRG15fKZJMvpXFcqv+97VsyJtQ
X-ME-Proxy: <xmx:XXvral02iW0MZCwF0ojD8MvEFEZ4wWK9GL-1xxlVnBvkGo-FF1UH5w>
    <xmx:XXvrao-IHTVEqpmh3pSWHxsruJLy_HxUCnTwcxYXSBLj5gkezO6sIg>
    <xmx:XXvralpUpBlAQ_Ans4q5w8xw9YV-B1hZcc69IwCXLVJYzdteNIHbyA>
    <xmx:XXvraiT2ON-R7oVUr4VIFNp_uJuW9CjolZWIuOYKYKMhJqS57F73KQ>
    <xmx:XXvravquITrrac0DbkyQ3xJPRnxwOwWabAFw-7rSlgWfMiuqopRNCQ8x>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 13:37:17 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] ksmbd: skip metadata-only opens in sharing checks
Date: Wed,  4 Nov 2026 12:37:01 -0600
Message-ID: <20261104183702.192452-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104183702.192452-1-icb@fastmail.org>
References: <20261104183702.192452-1-icb@fastmail.org>
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

A READ_CONTROL open without FILE_SHARE_DELETE makes a later DELETE open
of the file fail with STATUS_SHARING_VIOLATION.

ksmbd_smb_check_shared_mode() compares the sharing modes of two opens
even when one holds none of FILE_EXECUTE, FILE_READ_DATA,
FILE_WRITE_DATA, FILE_APPEND_DATA and DELETE. It skips a pair only when
exactly one of them asks for nothing but attribute rights.

Skip a pair of opens unless both hold one of those rights.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    An authenticated user can trigger it on any share, and a guest can on a
    share with "guest ok = yes". On a share without stored DACLs an open for
    FILE_READ_ATTRIBUTES and READ_CONTROL needs only search permission on
    the directory. A user with that permission can hold such an open without
    sharing and block the owner's reads, writes and deletes of a file in it.
    
    Tested on ksmbd-for-next e49296d51ccb with KASAN, with no reports or
    warnings. In targeted sharing tests and a KUnit matrix every changed
    result removes a sharing violation that MS-FSA does not make.
    smbtorture gives the same results as on the base.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smb_common.c | 9 +++++++++
 fs/smb/server/smb_common.h | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index f9fb3741ada3..920e94017bf6 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -719,6 +719,15 @@ int ksmbd_smb_check_shared_mode(struct file *filp, struct ksmbd_file *curr_fp)
 		if (prev_fp->attrib_only != curr_fp->attrib_only)
 			continue;
 
+		/*
+		 * Two opens conflict only if both hold a right in
+		 * FILE_SHARE_CHECKED_ACCESS_LE (MS-FSA 2.1.5.1.2.1 and
+		 * 2.1.5.1.2.2)
+		 */
+		if (!(prev_fp->daccess & FILE_SHARE_CHECKED_ACCESS_LE) ||
+		    !(curr_fp->daccess & FILE_SHARE_CHECKED_ACCESS_LE))
+			continue;
+
 		if (!(prev_fp->saccess & FILE_SHARE_DELETE_LE) &&
 		    curr_fp->daccess & FILE_DELETE_LE) {
 			smb_shared_mode_error(SHARE_DELETE_ERROR,
diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
index a9cc09e31721..4d404d1592c6 100644
--- a/fs/smb/server/smb_common.h
+++ b/fs/smb/server/smb_common.h
@@ -69,6 +69,10 @@
 		FILE_EXECUTE | FILE_DELETE_CHILD | \
 		FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
 
+/* Rights that make an open take part in sharing checks */
+#define FILE_SHARE_CHECKED_ACCESS_LE	(FILE_EXECUTE_LE | FILE_READ_DATA_LE | \
+		FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE | FILE_DELETE_LE)
+
 #define SMB_COM_NEGOTIATE		0x72 /* See MS-CIFS 2.2.2.1 */
 
 /* See MS-CIFS 2.2.3.1 */
-- 
2.47.3

