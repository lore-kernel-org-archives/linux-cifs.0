Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3105A350D5F
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748792; cv=none; b=nG/W1DR26iTreJfFyCr6P6+ZddroqgKhLwa5823di/8KFO0zBUYIcovIqTslFV24JJczKD2EAVA/bT1GOitpx869onstV+vJxPHwCIyc55+GHKM09OqXk20iNS8jGQ7X79Sr3knQWyktxP5V2A22BYiUlfTEAbtXLN6TMHuygmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748792; c=relaxed/simple;
	bh=81BMxGnNa/extQX/ZkPADD10S9S/rPaPxH9AmDrLfKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSqo5btVPKJpzoUqTyhaDV7XlDBaUIc8274owZ5srUrnDEhc2eGvaalZvqt11U9EQkUfCUlLCNp/hq9TB7zB49Ak8zKSpXcMjLDNUVf6NG0bx9a71cyPxwMSSGLz1gRxWmwU1WR7f6m4362iRjunTPhCzw5BIBKHiq8ttE5prw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YBMnHmOx; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YBMnHmOx"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eba67d4b1bso52870421cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 07:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761748788; x=1762353588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14JwzkkuKznMXow7lU7lEa8LUM0JlpEVee/oNXVeQGc=;
        b=YBMnHmOxbTAyTCCcFg52DI3y8MJHzi0eHLBfpIF4I2xvukdaK9QZpnxZc8jNUPUNzv
         MGD++pY61iYxUdSrUlHKH+EzgZ6+f9uwZEwU3qsw89EqZXaKOJFYd6k7tUcuTyTg1l5F
         uMVWP8vElwMS2NtL6NEl1D5sU++Ih045Tl1pGryljUV+J4LudRlP6GAGgPUDA3NmIT4+
         oF5e3kQgjOvzPm3x8fGsjv43GZRmTGq0qV6pYiHv1hiM7H26fU9OqEtReC94jNkgjXLO
         CZhgRYEGuNuvfG9ypRehAT06yOd+YYzHLMY9oImhRqD4vpjrnTDxOd/joPPDSMjM96G+
         FBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761748788; x=1762353588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14JwzkkuKznMXow7lU7lEa8LUM0JlpEVee/oNXVeQGc=;
        b=JUbU6deel5ADAEWvW8KUdBad1kVMTrNCt6UXekIIWIGJQUeBjn7oLvWD+F7mC3HOGq
         V56wHuPSmE/irhFAtvEeULDd6ZVUpVxhmT+HZJgBrP8LTjHxiuKxA5fRBDLFIOXXN7Tz
         Kw9fDX3NrvA/R147Rm/Ry89apV76szMU+OLg+T2oEdfSSLgsUfs/v5KfKYf77sikW8Rk
         IRLCdyGd+PrQR2EEiuiIj6qUlYd3tB4cOiZaokJ7XnHUbQ0tNaqwu4xr9K01lYooCFUj
         hFZW3F+uy+CqFIFscnKicoudzn8t6+NPP4yjh/ALLMIe/MB+lQirT3qI1sJnMoD38GmP
         DMPw==
X-Forwarded-Encrypted: i=1; AJvYcCVs1kwpGaUfNgCM8/3y8JARvCfmFJ5/isVx00IezcsVkJxxYaW3OWJHK1Q63zk6+qNF2L5tB8st1omd@vger.kernel.org
X-Gm-Message-State: AOJu0YzdO/eLb2YVg662c8mfZhjl7IhON/C1mUNBSKMau99+6qXrNPjx
	Z77o6OJuxL80ZRGrP9fOPbYJgOWiAzooGDe139nItfdrpSYXPmCBionOsb7GrtiSPPw=
X-Gm-Gg: ASbGncv5No8TZZVhWxS4N3SLo/DG7SD8daBnfbFIFAAitKDpkYwJ6L+Zjefbc7vUV6D
	marj3iZXUfZA+Qb13+ce29B/i5SX+fEsC+R0AXO4JKrO00CrwUUyKysfw3iThV4JqmHfir5Z9vT
	8+abBaYv0BrdidhlDhCkVOH4rwLrlLEwV1LYQOvgxJqZfePa/47ntxddgXvvQGWQynAUfxzP7Kj
	cclfK8aFqpHRiwaawNmGM4b/dXX1Sp9LE8YyZpuzlbgw4cg1qp5gnlV90+MGzMFubFplHh8XHDp
	Mo3jdUm6tXbmMTmGPd3PWWruHD+s4U2vpx1GBLtvoYWskDJgRLpPZIkwsIXZz6i9yXOizfaFbt8
	g+Wl2VzsMGJ+qIICUWPZHjzckrFM3BqvH0HtgMLg4iS/4dayvO3vEcHgNm44VyP/Z0z47WfTYr5
	sZVMu1zAJk6rwyrKzKW0eZU7hvb46bT71ko0dIJ5dDpuvIOD158n0=
X-Google-Smtp-Source: AGHT+IGXvEMoqvhTknxcor/JYV+wNq6HoGxsUF0683XmjdfIbHFygZ6lU2NzgrzdVmANdw7YfAjwoQ==
X-Received: by 2002:ac8:5713:0:b0:4b3:4457:feca with SMTP id d75a77b69052e-4ed15bb1f25mr37463751cf.6.1761748787784;
        Wed, 29 Oct 2025 07:39:47 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48a8bc4sm99556176d6.7.2025.10.29.07.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:39:47 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v4 12/15] quic: add crypto packet encryption and decryption
Date: Wed, 29 Oct 2025 10:35:54 -0400
Message-ID: <4976e2a7cb7ca74b0c919427da166d1b336f440e.1761748557.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1761748557.git.lucien.xin@gmail.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds core support for packet-level encryption and decryption
using AEAD, including both payload protection and QUIC header protection.
It introduces helpers to encrypt packets before transmission and to
remove header protection and decrypt payloads upon reception, in line
with QUIC's cryptographic requirements.

- quic_crypto_encrypt(): Perform header protection and payload
  encryption (TX).

- quic_crypto_decrypt(): Perform header protection removal and
  payload decryption (RX).

The patch also includes support for Retry token handling. It provides
helpers to compute the Retry integrity tag, generate tokens for address
validation, and verify tokens received from clients during the
handshake phase.

- quic_crypto_get_retry_tag(): Compute tag for Retry packets.

- quic_crypto_generate_token(): Generate retry token.

- quic_crypto_verify_token(): Verify retry token.

These additions establish the cryptographic primitives necessary for
secure QUIC packet exchange and address validation.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v3:
  - quic_crypto_decrypt(): return -EKEYREVOKED to defer key updates to
    the workqueue when the packet is not marked backlog, since
    quic_crypto_key_update()/crypto_aead_setkey() must run in process
    context.
  - Only perform header decryption if !cb->number_len to avoid double
    decryption when a key-update packet (with flipped key_phase)
    re-enters quic_crypto_decrypt() from the workqueue.
v4:
  - skb_dst_force() is already called in in quic_udp_rcv() on recv path,
    so remove its call from quic_crypto_payload_decrypt(), which may be
    called without RCU protection.
  - Use kfree_sensitive() and memzero_explicit() for sensitive data.
  - Remove the incorrect (void *) cast to quic_crypto_done.
---
 net/quic/crypto.c | 673 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h |  10 +
 2 files changed, 683 insertions(+)

diff --git a/net/quic/crypto.c b/net/quic/crypto.c
index 1623aaa5aafb..563689168a85 100644
--- a/net/quic/crypto.c
+++ b/net/quic/crypto.c
@@ -207,6 +207,345 @@ static int quic_crypto_rx_keys_derive_and_install(struct quic_crypto *crypto)
 	return err;
 }
 
+static void *quic_crypto_skcipher_mem_alloc(struct crypto_skcipher *tfm, u32 mask_size,
+					    u8 **iv, struct skcipher_request **req)
+{
+	unsigned int iv_size, req_size;
+	unsigned int len;
+	u8 *mem;
+
+	iv_size = crypto_skcipher_ivsize(tfm);
+	req_size = sizeof(**req) + crypto_skcipher_reqsize(tfm);
+
+	len = mask_size;
+	len += iv_size;
+	len += crypto_skcipher_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += req_size;
+
+	mem = kzalloc(len, GFP_ATOMIC);
+	if (!mem)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(mem + mask_size, crypto_skcipher_alignmask(tfm) + 1);
+	*req = (struct skcipher_request *)PTR_ALIGN(*iv + iv_size,
+			crypto_tfm_ctx_alignment());
+
+	return (void *)mem;
+}
+
+#define QUIC_SAMPLE_LEN		16
+
+#define QUIC_HEADER_FORM_BIT	0x80
+#define QUIC_LONG_HEADER_MASK	0x0f
+#define QUIC_SHORT_HEADER_MASK	0x1f
+
+/* Header Protection. */
+static int quic_crypto_header_encrypt(struct crypto_skcipher *tfm, struct sk_buff *skb, bool chacha)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct skcipher_request *req;
+	struct scatterlist sg;
+	u8 *mask, *iv, *p;
+	int err, i;
+
+	mask = quic_crypto_skcipher_mem_alloc(tfm, QUIC_SAMPLE_LEN, &iv, &req);
+	if (!mask)
+		return -ENOMEM;
+
+	/* rfc9001#section-5.4.2: Header Protection Sample:
+	 *
+	 *   # pn_offset is the start of the Packet Number field.
+	 *   sample_offset = pn_offset + 4
+	 *
+	 *   sample = packet[sample_offset..sample_offset+sample_length]
+	 *
+	 * rfc9001#section-5.4.3: AES-Based Header Protection:
+	 *
+	 *   header_protection(hp_key, sample):
+	 *     mask = AES-ECB(hp_key, sample)
+	 *
+	 * rfc9001#section-5.4.4: ChaCha20-Based Header Protection:
+	 *
+	 *   header_protection(hp_key, sample):
+	 *     counter = sample[0..3]
+	 *     nonce = sample[4..15]
+	 *     mask = ChaCha20(hp_key, counter, nonce, {0,0,0,0,0})
+	 */
+	memcpy((chacha ? iv : mask), skb->data + cb->number_offset + QUIC_PN_MAX_LEN,
+	       QUIC_SAMPLE_LEN);
+	sg_init_one(&sg, mask, QUIC_SAMPLE_LEN);
+	skcipher_request_set_tfm(req, tfm);
+	skcipher_request_set_crypt(req, &sg, &sg, QUIC_SAMPLE_LEN, iv);
+	err = crypto_skcipher_encrypt(req);
+	if (err)
+		goto err;
+
+	/* rfc9001#section-5.4.1:
+	 *
+	 * mask = header_protection(hp_key, sample)
+	 *
+	 * pn_length = (packet[0] & 0x03) + 1
+	 * if (packet[0] & 0x80) == 0x80:
+	 *    # Long header: 4 bits masked
+	 *    packet[0] ^= mask[0] & 0x0f
+	 * else:
+	 *    # Short header: 5 bits masked
+	 *    packet[0] ^= mask[0] & 0x1f
+	 *
+	 * # pn_offset is the start of the Packet Number field.
+	 * packet[pn_offset:pn_offset+pn_length] ^= mask[1:1+pn_length]
+	 */
+	p = skb->data;
+	*p = (u8)(*p ^ (mask[0] & (((*p & QUIC_HEADER_FORM_BIT) == QUIC_HEADER_FORM_BIT) ?
+				   QUIC_LONG_HEADER_MASK : QUIC_SHORT_HEADER_MASK)));
+	p = skb->data + cb->number_offset;
+	for (i = 1; i <= cb->number_len; i++)
+		*p++ ^= mask[i];
+err:
+	kfree_sensitive(mask);
+	return err;
+}
+
+/* Extracts and reconstructs the packet number from an incoming QUIC packet. */
+static void quic_crypto_get_header(struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	u32 len = QUIC_PN_MAX_LEN;
+	u8 *p = (u8 *)hdr;
+
+	/* rfc9000#section-17.1:
+	 *
+	 * Once header protection is removed, the packet number is decoded by finding the packet
+	 * number value that is closest to the next expected packet. The next expected packet is
+	 * the highest received packet number plus one.
+	 */
+	p += cb->number_offset;
+	cb->key_phase = hdr->key;
+	cb->number_len = hdr->pnl + 1;
+	quic_get_int(&p, &len, &cb->number, cb->number_len);
+	cb->number = quic_get_num(cb->number_max, cb->number, cb->number_len);
+
+	if (cb->number > cb->number_max)
+		cb->number_max = cb->number;
+}
+
+#define QUIC_PN_LEN_BITS_MASK	0x03
+
+static int quic_crypto_header_decrypt(struct crypto_skcipher *tfm, struct sk_buff *skb, bool chacha)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	int err, i, len = cb->length;
+	struct skcipher_request *req;
+	struct scatterlist sg;
+	u8 *mask, *iv, *p;
+
+	mask = quic_crypto_skcipher_mem_alloc(tfm, QUIC_SAMPLE_LEN, &iv, &req);
+	if (!mask)
+		return -ENOMEM;
+
+	if (len < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	/* Similar logic to quic_crypto_header_encrypt(). */
+	p = (u8 *)hdr + cb->number_offset;
+	memcpy((chacha ? iv : mask), p + QUIC_PN_MAX_LEN, QUIC_SAMPLE_LEN);
+	sg_init_one(&sg, mask, QUIC_SAMPLE_LEN);
+	skcipher_request_set_tfm(req, tfm);
+	skcipher_request_set_crypt(req, &sg, &sg, QUIC_SAMPLE_LEN, iv);
+	err = crypto_skcipher_encrypt(req);
+	if (err)
+		goto err;
+
+	p = (u8 *)hdr;
+	*p = (u8)(*p ^ (mask[0] & (((*p & QUIC_HEADER_FORM_BIT) == QUIC_HEADER_FORM_BIT) ?
+				   QUIC_LONG_HEADER_MASK : QUIC_SHORT_HEADER_MASK)));
+	cb->number_len = (*p & QUIC_PN_LEN_BITS_MASK) + 1;
+	p += cb->number_offset;
+	for (i = 0; i < cb->number_len; ++i)
+		*(p + i) = *((u8 *)hdr + cb->number_offset + i) ^ mask[i + 1];
+	quic_crypto_get_header(skb);
+
+err:
+	kfree_sensitive(mask);
+	return err;
+}
+
+static void *quic_crypto_aead_mem_alloc(struct crypto_aead *tfm, u32 ctx_size,
+					u8 **iv, struct aead_request **req,
+					struct scatterlist **sg, u32 nsg)
+{
+	unsigned int iv_size, req_size;
+	unsigned int len;
+	u8 *mem;
+
+	iv_size = crypto_aead_ivsize(tfm);
+	req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
+
+	len = ctx_size;
+	len += iv_size;
+	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += req_size;
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += nsg * sizeof(**sg);
+
+	mem = kzalloc(len, GFP_ATOMIC);
+	if (!mem)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(mem + ctx_size, crypto_aead_alignmask(tfm) + 1);
+	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
+			crypto_tfm_ctx_alignment());
+	*sg = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
+			__alignof__(struct scatterlist));
+
+	return (void *)mem;
+}
+
+static void quic_crypto_destruct_skb(struct sk_buff *skb)
+{
+	kfree_sensitive(skb_shinfo(skb)->destructor_arg);
+	sock_efree(skb);
+}
+
+static void quic_crypto_done(void *data, int err)
+{
+	struct sk_buff *skb = data;
+
+	QUIC_SKB_CB(skb)->crypto_done(skb, err);
+}
+
+/* AEAD Usage. */
+static int quic_crypto_payload_encrypt(struct crypto_aead *tfm, struct sk_buff *skb,
+				       u8 *tx_iv, bool ccm)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	u8 *iv, i, nonce[QUIC_IV_LEN];
+	struct aead_request *req;
+	struct sk_buff *trailer;
+	struct scatterlist *sg;
+	u32 nsg, hlen, len;
+	void *ctx;
+	__be64 n;
+	int err;
+
+	len = skb->len;
+	err = skb_cow_data(skb, QUIC_TAG_LEN, &trailer);
+	if (err < 0)
+		return err;
+	nsg = (u32)err;
+	pskb_put(skb, trailer, QUIC_TAG_LEN);
+	hdr->key = cb->key_phase;
+
+	ctx = quic_crypto_aead_mem_alloc(tfm, 0, &iv, &req, &sg, nsg);
+	if (!ctx)
+		return -ENOMEM;
+
+	sg_init_table(sg, nsg);
+	err = skb_to_sgvec(skb, sg, 0, (int)skb->len);
+	if (err < 0)
+		goto err;
+
+	/* rfc9001#section-5.3:
+	 *
+	 * The associated data, A, for the AEAD is the contents of the QUIC header,
+	 * starting from the first byte of either the short or long header, up to and
+	 * including the unprotected packet number.
+	 *
+	 * The nonce, N, is formed by combining the packet protection IV with the packet
+	 * number.  The 62 bits of the reconstructed QUIC packet number in network byte
+	 * order are left-padded with zeros to the size of the IV. The exclusive OR of the
+	 * padded packet number and the IV forms the AEAD nonce.
+	 */
+	hlen = cb->number_offset + cb->number_len;
+	memcpy(nonce, tx_iv, QUIC_IV_LEN);
+	n = cpu_to_be64(cb->number);
+	for (i = 0; i < sizeof(n); i++)
+		nonce[QUIC_IV_LEN - sizeof(n) + i] ^= ((u8 *)&n)[i];
+
+	/* For CCM based ciphers, first byte of IV is a constant. */
+	iv[0] = TLS_AES_CCM_IV_B0_BYTE;
+	memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, hlen);
+	aead_request_set_crypt(req, sg, sg, len - hlen, iv);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG, quic_crypto_done, skb);
+
+	err = crypto_aead_encrypt(req);
+	if (err == -EINPROGRESS) {
+		/* Will complete asynchronously; set destructor to free context. */
+		skb->destructor = quic_crypto_destruct_skb;
+		skb_shinfo(skb)->destructor_arg = ctx;
+		memzero_explicit(nonce, sizeof(nonce));
+		return err;
+	}
+
+err:
+	kfree_sensitive(ctx);
+	memzero_explicit(nonce, sizeof(nonce));
+	return err;
+}
+
+static int quic_crypto_payload_decrypt(struct crypto_aead *tfm, struct sk_buff *skb,
+				       u8 *rx_iv, bool ccm)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 *iv, i, nonce[QUIC_IV_LEN];
+	struct aead_request *req;
+	struct sk_buff *trailer;
+	int nsg, hlen, len, err;
+	struct scatterlist *sg;
+	void *ctx;
+	__be64 n;
+
+	len = cb->length + cb->number_offset;
+	hlen = cb->number_offset + cb->number_len;
+	if (len - hlen < QUIC_TAG_LEN)
+		return -EINVAL;
+	nsg = skb_cow_data(skb, 0, &trailer);
+	if (nsg < 0)
+		return nsg;
+	ctx = quic_crypto_aead_mem_alloc(tfm, 0, &iv, &req, &sg, nsg);
+	if (!ctx)
+		return -ENOMEM;
+
+	sg_init_table(sg, nsg);
+	err = skb_to_sgvec(skb, sg, 0, len);
+	if (err < 0)
+		goto err;
+
+	/* Similar logic to quic_crypto_payload_encrypt(). */
+	memcpy(nonce, rx_iv, QUIC_IV_LEN);
+	n = cpu_to_be64(cb->number);
+	for (i = 0; i < sizeof(n); i++)
+		nonce[QUIC_IV_LEN - sizeof(n) + i] ^= ((u8 *)&n)[i];
+
+	iv[0] = TLS_AES_CCM_IV_B0_BYTE;
+	memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, hlen);
+	aead_request_set_crypt(req, sg, sg, len - hlen, iv);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG, quic_crypto_done, skb);
+
+	err = crypto_aead_decrypt(req);
+	if (err == -EINPROGRESS) {
+		skb->destructor = quic_crypto_destruct_skb;
+		skb_shinfo(skb)->destructor_arg = ctx;
+		memzero_explicit(nonce, sizeof(nonce));
+		return err;
+	}
+err:
+	kfree_sensitive(ctx);
+	memzero_explicit(nonce, sizeof(nonce));
+	return err;
+}
+
 #define QUIC_CIPHER_MIN TLS_CIPHER_AES_GCM_128
 #define QUIC_CIPHER_MAX TLS_CIPHER_CHACHA20_POLY1305
 
@@ -231,6 +570,135 @@ static struct quic_cipher ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
 		    "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha256)"),
 };
 
+static bool quic_crypto_is_cipher_ccm(struct quic_crypto *crypto)
+{
+	return crypto->cipher_type == TLS_CIPHER_AES_CCM_128;
+}
+
+static bool quic_crypto_is_cipher_chacha(struct quic_crypto *crypto)
+{
+	return crypto->cipher_type == TLS_CIPHER_CHACHA20_POLY1305;
+}
+
+/* Encrypts a QUIC packet before transmission.  This function performs AEAD encryption of
+ * the packet payload and applies header protection. It handles key phase tracking and key
+ * update timing..
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb)
+{
+	u8 *iv, cha, ccm, phase = crypto->key_phase;
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	int err;
+
+	cb->key_phase = phase;
+	iv = crypto->tx_iv[phase];
+	/* Packet payload is already encrypted (e.g., resumed from async), proceed to header
+	 * protection only.
+	 */
+	if (cb->resume)
+		goto out;
+
+	/* If a key update is pending and this is the first packet using the new key, save the
+	 * current time. Later used to clear old keys after some time has passed (see
+	 * quic_crypto_decrypt()).
+	 */
+	if (crypto->key_pending && !crypto->key_update_send_time)
+		crypto->key_update_send_time = jiffies_to_usecs(jiffies);
+
+	ccm = quic_crypto_is_cipher_ccm(crypto);
+	err = quic_crypto_payload_encrypt(crypto->tx_tfm[phase], skb, iv, ccm);
+	if (err)
+		return err;
+out:
+	cha = quic_crypto_is_cipher_chacha(crypto);
+	return quic_crypto_header_encrypt(crypto->tx_hp_tfm, skb, cha);
+}
+
+/* Decrypts a QUIC packet after reception.  This function removes header protection,
+ * decrypts the payload, and processes any key updates if the key phase bit changes.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 *iv, cha, ccm, phase;
+	int err = 0;
+	u32 time;
+
+	/* Payload was decrypted asynchronously.  Proceed with parsing packet number and key
+	 * phase.
+	 */
+	if (cb->resume) {
+		quic_crypto_get_header(skb);
+		goto out;
+	}
+	if (!cb->number_len) { /* Packet header not yet decrypted. */
+		cha = quic_crypto_is_cipher_chacha(crypto);
+		err = quic_crypto_header_decrypt(crypto->rx_hp_tfm, skb, cha);
+		if (err) {
+			pr_debug("%s: hd decrypt err %d\n", __func__, err);
+			return err;
+		}
+	}
+
+	/* rfc9001#section-6:
+	 *
+	 * The Key Phase bit allows a recipient to detect a change in keying material without
+	 * needing to receive the first packet that triggered the change. An endpoint that
+	 * notices a changed Key Phase bit updates keys and decrypts the packet that contains
+	 * the changed value.
+	 */
+	if (cb->key_phase != crypto->key_phase && !crypto->key_pending) {
+		if (!crypto->send_ready) /* Not ready for key update. */
+			return -EINVAL;
+		if (!cb->backlog) /* Key update must be done in process context. */
+			return -EKEYREVOKED;
+		err = quic_crypto_key_update(crypto); /* Perform a key update. */
+		if (err) {
+			cb->errcode = QUIC_TRANSPORT_ERROR_KEY_UPDATE;
+			return err;
+		}
+		cb->key_update = 1; /* Mark packet as triggering key update. */
+	}
+
+	phase = cb->key_phase;
+	iv = crypto->rx_iv[phase];
+	ccm = quic_crypto_is_cipher_ccm(crypto);
+	err = quic_crypto_payload_decrypt(crypto->rx_tfm[phase], skb, iv, ccm);
+	if (err) {
+		if (err == -EINPROGRESS)
+			return err;
+		/* When using the old keys can not decrypt the packets, the peer might
+		 * start another key_update. Thus, clear the last key_pending so that
+		 * next packets will trigger the new key-update.
+		 */
+		if (crypto->key_pending && cb->key_phase != crypto->key_phase) {
+			crypto->key_pending = 0;
+			crypto->key_update_time = 0;
+		}
+		return err;
+	}
+
+out:
+	/* rfc9001#section-6.1:
+	 *
+	 * An endpoint MUST retain old keys until it has successfully unprotected a
+	 * packet sent using the new keys. An endpoint SHOULD retain old keys for
+	 * some time after unprotecting a packet sent using the new keys.
+	 */
+	if (crypto->key_pending && cb->key_phase == crypto->key_phase) {
+		time = crypto->key_update_send_time;
+		if (time && jiffies_to_usecs(jiffies) - time >= crypto->key_update_time) {
+			crypto->key_pending = 0;
+			crypto->key_update_time = 0;
+		}
+	}
+	return err;
+}
+
 int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type, u8 flag)
 {
 	struct quic_cipher *cipher;
@@ -516,6 +984,211 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_con
 	return err;
 }
 
+#define QUIC_RETRY_KEY_V1 "\xbe\x0c\x69\x0b\x9f\x66\x57\x5a\x1d\x76\x6b\x54\xe3\x68\xc8\x4e"
+#define QUIC_RETRY_KEY_V2 "\x8f\xb4\xb0\x1b\x56\xac\x48\xe2\x60\xfb\xcb\xce\xad\x7c\xcc\x92"
+
+#define QUIC_RETRY_NONCE_V1 "\x46\x15\x99\xd3\x5d\x63\x2b\xf2\x23\x98\x25\xbb"
+#define QUIC_RETRY_NONCE_V2 "\xd8\x69\x69\xbc\x2d\x7c\x6d\x99\x90\xef\xb0\x4a"
+
+/* Retry Packet Integrity. */
+int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_buff *skb,
+			      struct quic_conn_id *odcid, u32 version, u8 *tag)
+{
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	u8 *pseudo_retry, *p, *iv, *key;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	u32 plen;
+	int err;
+
+	/* rfc9001#section-5.8:
+	 *
+	 * The Retry Integrity Tag is a 128-bit field that is computed as the output of
+	 * AEAD_AES_128_GCM used with the following inputs:
+	 *
+	 * - The secret key, K, is 128 bits equal to 0xbe0c690b9f66575a1d766b54e368c84e.
+	 * - The nonce, N, is 96 bits equal to 0x461599d35d632bf2239825bb.
+	 * - The plaintext, P, is empty.
+	 * - The associated data, A, is the contents of the Retry Pseudo-Packet,
+	 *
+	 * The Retry Pseudo-Packet is not sent over the wire. It is computed by taking the
+	 * transmitted Retry packet, removing the Retry Integrity Tag, and prepending the
+	 * two following fields: ODCID Length + Original Destination Connection ID (ODCID).
+	 */
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		return err;
+	key = QUIC_RETRY_KEY_V1;
+	if (version == QUIC_VERSION_V2)
+		key = QUIC_RETRY_KEY_V2;
+	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	if (err)
+		return err;
+
+	plen = 1 + odcid->len + skb->len - QUIC_TAG_LEN;
+	pseudo_retry = quic_crypto_aead_mem_alloc(tfm, plen + QUIC_TAG_LEN, &iv, &req, &sg, 1);
+	if (!pseudo_retry)
+		return -ENOMEM;
+
+	p = pseudo_retry;
+	p = quic_put_int(p, odcid->len, 1);
+	p = quic_put_data(p, odcid->data, odcid->len);
+	p = quic_put_data(p, skb->data, skb->len - QUIC_TAG_LEN);
+	sg_init_one(sg, pseudo_retry, plen + QUIC_TAG_LEN);
+
+	memcpy(iv, QUIC_RETRY_NONCE_V1, QUIC_IV_LEN);
+	if (version == QUIC_VERSION_V2)
+		memcpy(iv, QUIC_RETRY_NONCE_V2, QUIC_IV_LEN);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, plen);
+	aead_request_set_crypt(req, sg, sg, 0, iv);
+	err = crypto_aead_encrypt(req);
+	if (!err)
+		memcpy(tag, p, QUIC_TAG_LEN);
+	kfree_sensitive(pseudo_retry);
+	return err;
+}
+
+/* Generate a token for Retry or address validation.
+ *
+ * Builds a token with the format: [client address][timestamp][original DCID][auth tag]
+ *
+ * Encrypts the token (excluding the first flag byte) using AES-GCM with a key and IV
+ * derived via HKDF. The original DCID is stored to be recovered later from a Client
+ * Initial packet.  Ensures the token is bound to the client address and time, preventing
+ * reuse or tampering.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			       struct quic_conn_id *conn_id, u8 *token, u32 *tlen)
+{
+	u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], iv[QUIC_IV_LEN];
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	u32 ts = jiffies_to_usecs(jiffies), len;
+	u8 *retry_token = NULL, *tx_iv, *p;
+	struct quic_data srt = {}, k, i;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err;
+
+	quic_data(&srt, quic_random_data, QUIC_RANDOM_DATA_LEN);
+	quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	quic_data(&i, iv, QUIC_IV_LEN);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &i, NULL, QUIC_VERSION_V1);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	if (err)
+		goto out;
+	token++;
+	len = addrlen + sizeof(ts) + conn_id->len + QUIC_TAG_LEN;
+	retry_token = quic_crypto_aead_mem_alloc(tfm, len, &tx_iv, &req, &sg, 1);
+	if (!retry_token) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	p = retry_token;
+	p = quic_put_data(p, addr, addrlen);
+	p = quic_put_int(p, ts, sizeof(ts));
+	quic_put_data(p, conn_id->data, conn_id->len);
+	sg_init_one(sg, retry_token, len);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, addrlen);
+	aead_request_set_crypt(req, sg, sg, len - addrlen - QUIC_TAG_LEN, iv);
+	err = crypto_aead_encrypt(req);
+	if (err)
+		goto out;
+	memcpy(token, retry_token, len);
+	*tlen = len + 1;
+out:
+	kfree_sensitive(retry_token);
+	memzero_explicit(key, sizeof(key));
+	memzero_explicit(iv, sizeof(iv));
+	return err;
+}
+
+/* Validate a Retry or address validation token.
+ *
+ * Decrypts the token using derived key and IV. Checks that the decrypted address matches
+ * the provided address, validates the embedded timestamp against current time with a
+ * version-specific timeout. If applicable, it extracts and returns the original
+ * destination connection ID (ODCID) for Retry packets.
+ *
+ * Returns 0 if the token is valid, -EINVAL if invalid, or another negative error code.
+ */
+int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			     struct quic_conn_id *conn_id, u8 *token, u32 len)
+{
+	u32 ts = jiffies_to_usecs(jiffies), timeout = QUIC_TOKEN_TIMEOUT_RETRY;
+	u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], iv[QUIC_IV_LEN];
+	u8 *retry_token = NULL, *rx_iv, *p, flag = *token;
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	struct quic_data srt = {}, k, i;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err;
+	u64 t;
+
+	if (len < sizeof(flag) + addrlen + sizeof(ts) + QUIC_TAG_LEN)
+		return -EINVAL;
+	quic_data(&srt, quic_random_data, QUIC_RANDOM_DATA_LEN);
+	quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	quic_data(&i, iv, QUIC_IV_LEN);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &i, NULL, QUIC_VERSION_V1);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	if (err)
+		goto out;
+	len--;
+	token++;
+	retry_token = quic_crypto_aead_mem_alloc(tfm, len, &rx_iv, &req, &sg, 1);
+	if (!retry_token) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(retry_token, token, len);
+	sg_init_one(sg, retry_token, len);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, addrlen);
+	aead_request_set_crypt(req, sg, sg, len - addrlen, iv);
+	err = crypto_aead_decrypt(req);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	p = retry_token;
+	if (memcmp(p, addr, addrlen))
+		goto out;
+	p += addrlen;
+	len -= addrlen;
+	if (flag == QUIC_TOKEN_FLAG_REGULAR)
+		timeout = QUIC_TOKEN_TIMEOUT_REGULAR;
+	if (!quic_get_int(&p, &len, &t, sizeof(ts)) || t + timeout < ts)
+		goto out;
+	len -= QUIC_TAG_LEN;
+	if (len > QUIC_CONN_ID_MAX_LEN)
+		goto out;
+
+	if (flag == QUIC_TOKEN_FLAG_RETRY)
+		quic_conn_id_update(conn_id, p, len);
+	err = 0;
+out:
+	kfree_sensitive(retry_token);
+	memzero_explicit(key, sizeof(key));
+	memzero_explicit(iv, sizeof(iv));
+	return err;
+}
+
 /* Generate a derived key using HKDF-Extract and HKDF-Expand with a given label. */
 static int quic_crypto_generate_key(struct quic_crypto *crypto, void *data, u32 len,
 				    char *label, u8 *token, u32 key_len)
diff --git a/net/quic/crypto.h b/net/quic/crypto.h
index 942a460cf749..ff5e94843932 100644
--- a/net/quic/crypto.h
+++ b/net/quic/crypto.h
@@ -62,6 +62,9 @@ int quic_crypto_get_secret(struct quic_crypto *crypto, struct quic_crypto_secret
 int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type, u8 flag);
 int quic_crypto_key_update(struct quic_crypto *crypto);
 
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb);
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb);
+
 int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_conn_id *conn_id,
 				     u32 version, bool is_serv);
 int quic_crypto_generate_session_ticket_key(struct quic_crypto *crypto, void *data,
@@ -69,5 +72,12 @@ int quic_crypto_generate_session_ticket_key(struct quic_crypto *crypto, void *da
 int quic_crypto_generate_stateless_reset_token(struct quic_crypto *crypto, void *data,
 					       u32 len, u8 *key, u32 key_len);
 
+int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			       struct quic_conn_id *conn_id, u8 *token, u32 *tlen);
+int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_buff *skb,
+			      struct quic_conn_id *odcid, u32 version, u8 *tag);
+int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr, u32 addrlen,
+			     struct quic_conn_id *conn_id, u8 *token, u32 len);
+
 void quic_crypto_free(struct quic_crypto *crypto);
 void quic_crypto_init(void);
-- 
2.47.1

