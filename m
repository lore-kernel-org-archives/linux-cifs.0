Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793596216;
	b=pdb47Vhd/31JTYuH1S8J/g8YAImxT6pAFx0K6iZ5HvcaVP+xN0WWesSugLcfIYZmtfNn
	 BhuiTyQZ4XKj7ZchXIAgYSg7c6PeX7Wox/DdAYMRWDYYi5fEzJd/zgdXCHcfAIBcA0X60
	 QufAflDAoxblzlz98QbYp9mucAnLsxbUS/TIZVcsXKD0pp9SXZY77rKgpusBhRFk3jQsG
	 iQqHdqb5NX+0JUbmdK9Sg2blzbv8dqW/bFtOTBqzEbAN53IYn5LMb8ShFabTN9OxFX+v8
	 wEZwXyH2lq0/eFo/v3WiSOHOKUa3aKJonJtZl+ieYwciZgdC6Vg+Q/KirZAjBWDm80A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793596216;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D5QSQm4M1iOF9ifVVH/QLh34xRT2v7bR5+D0b5MMq+0=;
	b=RKaEacKMAl6Kjph8bbaMoz0RxQdZlGPJFha9NDhgWwPP/xmMIlGbqspOG8dOSyYO2ypD
	 awvFuHqERzg1+yBabyqKVQgv8Cy/XfxwPGfv/qZLLW7C8meUkHc9ZfpOvgsZRd7rqmzyv
	 J1DfRyGQzba5W1SW7yfe5Oo+VU3bE8ykBQhCqCKZ7DYzjCtGVw3HygvlHdQPr/2Ch8Zux
	 b+xfdNrPO3j0If37Gi2Qe8bVkxq4hPi2PLYS49X6AaXChr3A5U6Mqoy061onKNh+VisRv
	 hng3e8rnC7bsjwrDYVemdk/BdzE+l/bMuz8QhkONkyUPLewgOyC84z9GDojJ/xyrecQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=j8V7DDOQ;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="nUCioCF/";
	arc=none smtp.remote-ip=202.12.124.155
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BDB606A32D
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 05:10:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39BDB606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=j8V7DDOQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=nUCioCF/
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 56B807A019E
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 00:10:15 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 02 Nov 2026 00:10:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793596214; x=1793682614; bh=D5QSQm4M1iOF9ifVVH/QL
	h34xRT2v7bR5+D0b5MMq+0=; b=j8V7DDOQ74o6MT+OxZg7060myDX6b6Lz2rWgB
	kIGMojA8o3AqVFTbGAFfXAO8grZUJLIYFo+6eBPEPmhO0zMEewueLBspPvBd2Bbz
	W/2vqj8LKMwkrc2J/osl4UcFTIvtfcHHeV8DbxTQuFCY8ixXk+/y8xliqtIzceon
	GiQ/cKWDVtXsaItnyVtFRKnm4qtFtgCNlH+0BBRk4ho+7nKGqMCewS6unkcfTt7r
	o1yAIudm2PjNLwJMt5u8PGr/6jmueSPgVUi0Py399IYrUlhSOIQvbPPQafsndK5b
	Lo7fGS1ILSBRdbUrmGy+mMbfyEMR3LB6W+9nPNOmjtonK1kkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793596214; x=1793682614; bh=D5QSQm4M1iOF9ifVVH/QLh34xRT2v7bR5+D
	0b5MMq+0=; b=nUCioCF/94OH+1vooWdgFn4JDhpE7BsNmTHChDXYSaXiWANPzVh
	c6OI+eMQ4nix1BpcsfHQe9m/x8g8J9h3EzTJ+42RKPxUYUJzLfH+2RFjQ2pwDA7e
	oZAn9kEsbn5gwkg20r60GivmH2JgNNBxQsl5TQEevYyxQa5Jvqd8tewJORld4O/t
	ejc6Frxu2SFEyYz1vEo6o21UjIemRAfkraITUHgp+XEylVhYItTJMRMhB5uY5pNL
	ccoixMhyUuNKSc1nKbl5LFToP3lgQVwcBLXmcNGqOg6XJrpejbVL0aA3EyDzZGqQ
	R9A8rFF8AGp9tZCKvqmRo/WAF7mGHK7rv2w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793596214; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:kysllQoYAji/ZvGmFLuxEJ6mxA73AH7K66NtmTc03PT9wwT
	fe7Ie5LoVqsCwISd9ODyJ8TdtdoMUKskd2gvKGphgd0KtlXoqHqrpopoyxtFPvX4
	s5IVyzwb0tx67qmg/YDNCcQgRLFP71IXThKyjwS7T0Dl/fK2sqKiPRtoNEoLdO0x
	22xb+7845pbNzmlm58hM1kUOhgv30GlX6uhUbwW1tVhuej/ikiSOf9qdvBi6ExN0
	nIPEUT0ctDF7oxyAl8ug32QmyxiNnS1BclotVmgoWh8y2FOBlW4wdZMImPXy3INY
	zo88ggvf6irlNsSOzk8OTmpqqOdgYzTNTZL3Ejg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:t9pQkznsMKz/oO8WIV30CMqxBulu6bOVuERse6paSUk=:PL0FvH96kVnJF2L3ppS6jdwQnkdMLwy+FrS6zxof6SE=;
X-ME-Sender: <xms:NRvoavOMeKp6YHQ5wGbvIpV5fPpLDYHdGUvYs55lgtRnRcdJI8513w>
    <xme:NRvoal9Tsm4NNhQKsTOHGe_-rQVIqCJGz9PIjna0b_vSzy0muU14UCsjBfGUsD3cA
    masgvEzFiwk2oxQf5SBfKMODWOJDeZ8SZaFnmc6alej6m5-U5GyxJ0k>
X-ME-Received: <xmr:NRvoagcqLBksxnIsAjJE9ziIRRD3gjDd2B3rH3JopqO_hT6WOg2LbUn1J7J3jApy>
X-ME-Proxy-Cause: dmFkZTFwO7Gjy9Skl7bA4lKKWiHb9m+IpkPfofdtQlcAfSF456pEiqDu6M9bDIdezGgjpF
    SxPKaa1nkxQo02v5W8Z3xoJktwmH36B/WXf6rz3MNM/a6kMLO231n6z2/KFdrI2/SQuaHK
    +PSKq77YMFNbzNMw8oBKHe/HoqzqziMmaCATfu9MQHjUt3sKgOslZr+86ojndc4TrwgoAn
    3RUmz28RRMLByzysrDeoXVe8rj2aQExP46aU8nLFBXggA9HXtHbcFiZIf77nk3KBw/dwyj
    gN6/lZs5uJQWwUQ7bID3EMkyVNulAebs0DpL2qldsXuDxn8aMXtgdnHxNW76IMEzJgcBcs
    NT9tb76AGqsHtdhJxuGOkAqqkgO2/y+v543FXvWKH30Rus16VpdWCu6PdOtYpc4slJKS3y
    gmI1tc4hhQnJKyhddfB+SU/txyLdB2IEFHboYZM0zEYd4VD9p69oGjxOFx5u951uwguZet
    jrXWQU0ujaBnM65oH/8D2UhOhX/zqL3tGVB0mjQf0r/UM6axIvMspXlJ5x8T9dHAAaBxqW
    5lmsYHdFO5qoE0eIa1r6/DmYAy3NyovSRcswjZRwzBesp59oETetaRFGdDpONj6UENlQvG
    7QhLvVIyvNGgX09TI/QtEKFHJ75QdnMTR4Z7se71lcklN+XlwexmXraZTxTA
X-ME-Proxy: <xmx:NRvoakwPuGjMwv354N7ApgJ3r5zx6AJDM306oC7xU_0NAtgkpWDXoA>
    <xmx:NRvoalKgSn2bJ7prR7RTtOv4QkU7V4GR_moq2E2JOm4sig0rT_SiVQ>
    <xmx:NRvoamGk9FlBAsaeNF15BG99SPuSPvATv_xryGche9IcMG1WKNtwSw>
    <xmx:NRvoah9TxUHjCc2qBnApEkmvTPLRjDtcSOyHFsbzIohPG71PQsgVgw>
    <xmx:NhvoakWIXnvYvGif6Xy9o4xn1dFe6J_jWvk9ZHi1X-5jHJB5i-y1RsA2>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 00:10:13 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [PATCH] ksmbd: do not read past the DACL in the access denied debug message
Date: Sun,  1 Nov 2026 23:09:15 -0600
Message-ID: <20261102050915.816373-1-icb@fastmail.org>
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

When smb_check_perm_dacl() falls back to the POSIX ACL and then denies
the request, its debug message prints the access mask of the ACE that
the second DACL walk stopped at. On that path the walk ran to the end
of the DACL, so the pointer is one past the last ACE. If the DACL is
the last part of the stored security descriptor, the message reads 4
bytes past the buffer, and KASAN reports a slab-out-of-bounds read in
smb_check_perm_dacl().

Print the requested and allowed masks instead. They are what the check
compares.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    ksmbd_debug() evaluates its arguments only when SMB debug output is on
    (/sys/class/ksmbd-control/debug). The 4 bytes go to the kernel log.
    
    Tested on ksmbd-for-next d13da43938d1 with KASAN. With SMB debug
    enabled, a WRITE_DATA request reaches the POSIX ACL fallback and is
    denied. Before the fix, the denial triggers a KASAN report. After the
    fix, the request remains denied and KASAN reports no error. No other
    access result changes. smbtorture gives the same results as on the base.
    
    A reproducer is available on request.
    
    This fix was developed with LLM assistance.

 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664f01263611..cdb04d29ed09 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1672,8 +1672,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	}
 
 	if (granted & ~access_bits) {
-		ksmbd_debug(SMB, "Access denied with winACL, granted : %x, access_req : %x\n",
-			    granted, le32_to_cpu(ace->access_req));
+		ksmbd_debug(SMB, "Access denied with winACL, requested : %x, allowed : %x\n",
+			    granted, access_bits);
 		rc = -EACCES;
 		goto err_out;
 	}

base-commit: d13da43938d15b0b719827d8f2b32df8eaec5def
-- 
2.47.3

