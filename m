Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794801985;
	b=kMV4pCcaYXKouuqFzMyzsn5dv9y/S6ZsvboLpghHsBI7WP4xiUnghxFJFX87a0sqR6Xj
	 SuoCmKRAy7R9pobnx55K4P7i8jxnlj+VMroZ3YBjTBKwTi4Nt2T8QxGXUp5f6CK/8Y5LY
	 PRx1dCLf0r1JJClzlpNyDryeR3Plg2RzSAAdpbsKGSU6fCwjNI8b88BBjhG3eJO3O/yr/
	 sKCqqc9t3bJV4cCeFxLcXGsnUowSvSK0BFe5PojQr31QEBJMpxMYP1w8i3INP7fxFG4Sb
	 BNFBFo+ISkGdJ45Ej6A1heeZtBjtRdD3sZcNZqcdi9RaWXvM7vkGCMzSpEoAq2WfvPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794801985;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=iZHFyvnzhyIqtSFCRuC0TZuvDD03Lre6+cb++4bzmQ8=;
	b=ZSaftuKZp5urEIGv1gW5Th7N5ufpNpxBUmdi+36GDJe5+Lulxysj5jKV9eXvDQGB0wHN
	 L8OZIkibpipIvxwiedJuiiluVtrXJGvgihbtQZc9T4F+HeIYcMdEN5ldZPSfuKVaIAebn
	 kv9swNlbyMGYhNZXlv7Xuvo3W2rBDeX7OkiVW+Ym0qZxmNwEEnZrHZun6Fwrksbos9qr1
	 Cgi5KCYs/OctStfQGXzswsJzSp2EwBWBEH8+pU4U7OzCZRDLHGoF11Vg3XZBWOI3R84JZ
	 nQ5ZOLvxUzXjRGwZaIMbYQ/7lgqqTZmpTnQwv/reLJBKRmlyOssrRw67xEPJCSHtYeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jF8KEgFa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B87606A31C;
	Mon, 16 Nov 2026 04:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jF8KEgFa
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794801985;
	b=yBk5bsLC1djhgMzKaqa8PG7HKAE8MZvZYBnbpOQAQpwtkXD24WmIb2x1t1b79Sd3EKjB
	 6tC628p6AV5DF7b0gOizNqNYzDSf4W9Ue5nXdslOe5QLBCM18x5mp+kOf57ABrvzR9+XV
	 fgrPltPVn76fT+a/X1vgKyUeFPWZrvDtRGT1eYGwiQCjfntrTlef2tgCfBN4UtGUgCUwH
	 /h2T/tBU2xTIXO61H1q5hhJt0NNEvnEJ1ON73aKXk1GmQF3U7goTZu07xHFfpR/IRS9Vu
	 Fnebsc7Iy92ghZ6z4dhXDTioXWK0WKwvZZOUOKuKPlt+V6nCNxah/nhoEwZk3xJ710Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794801985;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=iZHFyvnzhyIqtSFCRuC0TZuvDD03Lre6+cb++4bzmQ8=;
	b=Amr9C8Zb3KCAJqTQcgD6x6gfim75ZDV2UNUYaTrCuMTAbeW+V5RC//+/YjtWEy7JrbAW
	 VWDxjpuBhcch3YVHECUwAp2tZfaPKigf5NxWpFcD0xMAWTV+oWbNiWlB79iHP4i7jS5Aw
	 p39QVi2BS92MT/HvQAk1c99yHxlFwkDeobaVQWKhX3dskDM9+b6JgqNFUwIQBaDQzsIOs
	 Sx7gU0EPVTpWEui8W0W87sENHbnXF6JTBq4gG/45w8GCN8cwFs+GwvnzX5J8FamKWRDhy
	 cB8ht26wrYJbeK42Tfix5SYrRkoejLG/B2s091Zg5weoUv0w0Cu1bIIMDIYT6/YZJBw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AA8DA1F000C6;
	Mon, 16 Nov 2026 04:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794801985;
	bh=iZHFyvnzhyIqtSFCRuC0TZuvDD03Lre6+cb++4bzmQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jF8KEgFaqrDFzjpVP3sIlnmJSwmDE0yZpiHUnKf8bsz9yNg54tykmumoRc5Si6cl3
	 Wy5a/nJ4NnUlXg045rximPPtmBcrZn6nBB7k3LRR2NYDHBmv/H4lomqyLu0FcOYUDk
	 NL1QJEzaNuqeznpepIlQvgbyBlflU+IsCd0Qt795pzW6ybTzkcE9HyoLWSGaUwYZfI
	 tkNF7Y1NqXpFsDxP5fXyY7NksxSIDaoOOrlJxenEYec78yp7pwx60bp8LKbjgtwW8k
	 rQfLmF7E7ebIqHbtuHjbDQkR4UNAf4BJJcmiIL6uWKJ9xN8qo6quzBnSPzMRNCwFnG
	 OZiNoei/fBr8w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 372E74A30F;
	Mon, 16 Nov 2026 04:06:24 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Date: Mon, 16 Nov 2026 04:06:24 +0000
Subject: [PATCH v2 2/2] smb: client: don't use read data that failed
 signature verification
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-smb2-sign-v2-2-a823a90d0db4@gmail.com>
References: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
In-Reply-To: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
To: linkinjeon@kernel.org, pc@manguebit.org
Cc: ematsumiya@suse.de, sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
 bharathsm@microsoft.com, ronniesahlberg@gmail.com, 
 samba-technical@lists.samba.org, daniel.birtwhistle@gehealthcare.com, 
 linux-kernel@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com, 
 tom@talpey.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794801982; l=1617;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=3pzHhLlm0VqsPqETYBr3UUbM6tyVccoN6rYtsY79lWg=;
 b=kg87p8B0s9W/1FD9ZZXQa62y0j/jVxUBkqXQ5+WZF38sbgreIiaL9vp5wlgcWRaqoIafSg/fQ
 GjW8gMy8jFPBRDcFFJgdy2x/mLiZUhADpZQxZQG3LtY5imST+cU8TiH
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

From: Suyuan Wang <stevewong@hust.edu.cn>

When smb2_readv_callback() finds a bad signature, it sets the error in
rdata->result but leaves rdata->got_bytes alone. Further down, a short
read that reaches the remote EOF clears the error again:

    size_t trans = rdata->subreq.transferred + rdata->got_bytes;
    if (trans < rdata->subreq.len &&
        rdata->subreq.start + trans >= netfs_read_remote_i_size(inode)) {
            rdata->result = 0;

and got_bytes is then added to subreq.transferred. So the last part of a
file, or all of a small one, is returned even though its signature is
wrong.

Clear got_bytes when the signature check fails, as the retry path in the
same function already does.

Found with a static analysis tool and checked by hand.

Fixes: 1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read")
Cc: stable@vger.kernel.org
Co-developed-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Kaixuan Li <kaixuan.li@ntu.edu.sg>
Signed-off-by: Suyuan Wang <stevewong@hust.edu.cn>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f85595136ef8..1245572c022e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4723,6 +4723,8 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 					      rc);
 				rdata->subreq.error = rc;
 				rdata->result = rc;
+				/* the data can't be trusted, don't count it */
+				rdata->got_bytes = 0;
 
 				if (is_replayable_error(rc)) {
 					trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);

-- 
2.34.1


