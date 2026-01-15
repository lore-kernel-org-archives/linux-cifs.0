Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DA9313529
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768490228; cv=none; b=kWxm8OflH4B5ZR6VhyXuKLqb15xCFJvT7kOHErvpSYmP7AgPhxoRkq8UKKyJ6f+u6Unf10CKDmG7wL0UxP4lyOzm2LWQuB7agwUXAnXWqwWmq79Er1rshazQj43MEPwoJSx71xx+5dGxByQ2htSeF3fxNK/m1IfmJQXRGJZ03fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768490228; c=relaxed/simple;
	bh=9qUWacfD09KgHI4uHvyDH3fJyUC3b8Lia1tfXOHyB60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xro+/ns4UZiv6zyZ8UbiX/2vgHC9TKQR4nF8rlkIVVlmpe7pit+tBr/sD3omwxcgzXKCrbay0ineu8gMbHClj+CTq20xckxXF5p6lX0UCCv4FtCqkCGk7POVO2bl/J9sDs+gzKGpTgY3Nr6OHcBmupHDGcXRDk9Lb6FLocV3clU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G4PTMSQH; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4PTMSQH"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-56365984503so745357e0c.0
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 07:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768490218; x=1769095018; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYunKGHzuTELe0KxGrMziSmaOFUrGJRhxe6MHqPo/j4=;
        b=G4PTMSQHGWqzyvsB62sLdgms0SDbQmioGB8zOKMvL2BJWjHgQMiJjuL+qlcVEntSTd
         8ZZ4R6ZgXCAL8oo+z4Ve4pcxbXIku3KHbc19DorIWuMFBabd/YiQtnfaeTAUG4tmap0k
         Or8XbQU/tw1QNY3YMesqupHONX7AhIE3fi3mHfsCMEd0fq+QLIP4RwPmS/TuYmQWVkdb
         WR5EVD3wcwsAEchW+t8NLMPTTpgHggd+U2J1Vlw6XPuXf7EKfEnrSfkPMBN5UZJ//4oE
         uNMz9HSahXQMgFuyBYdoUQh9rbs5kLC1v0BAL10ZxmmYTL+uTkvjo1dxGTFl1zOk/njk
         +W7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768490218; x=1769095018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GYunKGHzuTELe0KxGrMziSmaOFUrGJRhxe6MHqPo/j4=;
        b=bcyCEX3CIv2oPa64IeJSq+d5Fj7mtohnzr5tuZt6mnir/yRidtJklDUJkT+x4uiIEm
         o8MEtStSpbEilI07eBFpBTyJWsf1Oor5XwfAkNLgEb6IwA7D1ln41R69T95hmJ+euis/
         GBH7iWLndYoM3OhZNfSMABhLKyuBhznbYYKiwB3dz9gMU050Pk3V8ji20MoiE7xKMx1n
         Hf3HOhJuFH1Badi7fxROdeMIrX/9kDrfnlVJVQG0vqd2r65b2mv7jWjoTHgWhQHwv+VY
         wZqlvwPO8w+hA7VUwm87Zc5hlzhtsppR/VWYNj7bUGBvgeSR+l96ZljGVDOv2sKoAHPI
         PF2A==
X-Forwarded-Encrypted: i=1; AJvYcCVy6ZmbWefZL2DYtxNEV/z8CffcK0z4iJJoPHUKTu1RnsleZntMSrSBjDwT6WdMqu8jo6uOssxXAsWg@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhtv1MpsjNSra9UuBdz0HgxuJQe/K5J+cY5ed9jtdbpnt6oO28
	menbAIy0/q4+x0cdvslScE/fsjYKz3zT9265cyVgEkiuUCj5cboTvJGI
X-Gm-Gg: AY/fxX7TmjyxUFRy28cGrUghhv8sNIH1xigZFsxdCw0LNeZcu0vkkT/jHw4n/iQSG3x
	GcficLfOqYJxaSl34FMbQr+Ybj4inwOq+mfhDZw62y7r/EDu+GnA7eFvGV1+v7TLnxXm/eb+E/m
	VVUnVqyfNVNM4+bTGsp3NrsQ06m/T0TsBhcH+QGUytHDLFoNSfRcGF41V7SIcbVnKHbVoMytOA2
	4C2eESiht9f1moKEP1p+tGBa8teA6AvrsewRkDEoEDQQmtmM2nypKW7Abv8BISIbJSh7zfzZy3m
	Vkp+RWGYY+aLnc5p+ZyPiplFEtQfngAoZRSvqJ2Qf3HkYs7MRVvrQxj9/5KSRvd8ryHDE0Af8CV
	XkM8KZtwFyzRa8dcTEOqIz8d4tD5SC5t/gnWmcTznSg+mbFmRhbyev8j9VbRPZAeKH8aR0/l0rA
	sC5NIVDToBRQYt68WYXKeSzYEoSRJzBB7O6rwondQnrcaVfqssoss=
X-Received: by 2002:a05:6122:c86:b0:55b:14ec:6fb9 with SMTP id 71dfb90a1353d-563b5c7d391mr72716e0c.14.1768490215960;
        Thu, 15 Jan 2026 07:16:55 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc6edsm201030056d6.4.2026.01.15.07.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 07:16:55 -0800 (PST)
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
Subject: [PATCH net-next v7 12/16] quic: add crypto packet encryption and decryption
Date: Thu, 15 Jan 2026 10:11:12 -0500
Message-ID: <2cf41cc1a6c52aa2cafb8b4ddef2f82d179cf931.1768489876.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1768489876.git.lucien.xin@gmail.com>
References: <cover.1768489876.git.lucien.xin@gmail.com>
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
  - Remove the incorrect (void *) cast to quic_crypto_done.
v5:
  - Use skb_cb->crypto_ctx for async crypto context freeing, which is
    safer than using skb_shinfo(skb)->destructor_arg.
  - skb_cb->number_max is removed and number is reused as the largest
    previously seen and update quic_crypto_get_header() accordingly.
  - Change timestamp variables from u32 to u64 and use quic_ktime_get_us()
    for current timestamps, as jiffies_to_usecs() is not accurate enough.
v6:
  - Rename quic_crypto_get_header() to quic_crypto_get_number(), move
    key_phase parsing out of it, check cb->length when parsing packet
    number, and update all callers.
  - Use hdr->pnl + 1 instead of (*p & QUIC_PN_LEN_BITS_MASK) + 1 to get
    packet number length, and remove the unnecessary the len variable
    and QUIC_PN_LEN_BITS_MASK macro from quic_crypto_header_decrypt().
---
 net/quic/crypto.c | 662 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h |  10 +
 2 files changed, 672 insertions(+)

diff --git a/net/quic/crypto.c b/net/quic/crypto.c
index 1623aaa5aafb..11d6e7a6161d 100644
--- a/net/quic/crypto.c
+++ b/net/quic/crypto.c
@@ -207,6 +207,333 @@ static int quic_crypto_rx_keys_derive_and_install(struct quic_crypto *crypto)
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
+static int quic_crypto_get_number(struct sk_buff *skb)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	s64 number_max = cb->number;
+	u32 len = cb->length;
+	u8 *p;
+
+	/* rfc9000#section-17.1:
+	 *
+	 * Once header protection is removed, the packet number is decoded by finding the packet
+	 * number value that is closest to the next expected packet. The next expected packet is
+	 * the highest received packet number plus one.
+	 */
+	p = (u8 *)quic_hdr(skb) + cb->number_offset;
+	if (!quic_get_int(&p, &len, &cb->number, cb->number_len))
+		return -EINVAL;
+	cb->number = quic_get_num(number_max, cb->number, cb->number_len);
+	return 0;
+}
+
+static int quic_crypto_header_decrypt(struct crypto_skcipher *tfm, struct sk_buff *skb, bool chacha)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	struct quichdr *hdr = quic_hdr(skb);
+	struct skcipher_request *req;
+	struct scatterlist sg;
+	u8 *mask, *iv, *p;
+	int err, i;
+
+	mask = quic_crypto_skcipher_mem_alloc(tfm, QUIC_SAMPLE_LEN, &iv, &req);
+	if (!mask)
+		return -ENOMEM;
+
+	if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN) {
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
+	cb->number_len = hdr->pnl + 1;
+	cb->key_phase = hdr->key;
+	p += cb->number_offset;
+	for (i = 0; i < cb->number_len; ++i)
+		*(p + i) = *((u8 *)hdr + cb->number_offset + i) ^ mask[i + 1];
+	err = quic_crypto_get_number(skb);
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
+static void quic_crypto_done(void *data, int err)
+{
+	struct sk_buff *skb = data;
+
+	kfree_sensitive(QUIC_SKB_CB(skb)->crypto_ctx);
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
+	cb->crypto_ctx = ctx; /* Set crypto_ctx for async free in quic_crypto_done(). */
+	err = crypto_aead_encrypt(req);
+	if (err == -EINPROGRESS) {
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
+	cb->crypto_ctx = ctx;
+	err = crypto_aead_decrypt(req);
+	if (err == -EINPROGRESS) {
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
 
@@ -231,6 +558,137 @@ static struct quic_cipher ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
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
+		crypto->key_update_send_time = quic_ktime_get_us();
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
+	u64 time;
+
+	/* Payload was decrypted asynchronously.  Proceed with parsing packet number and key
+	 * phase.
+	 */
+	if (cb->resume) {
+		err = quic_crypto_get_number(skb);
+		if (err)
+			return err;
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
+		if (time && quic_ktime_get_us() - time >= crypto->key_update_time) {
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
@@ -516,6 +974,210 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_con
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
+	u8 *retry_token = NULL, *tx_iv, *p;
+	struct quic_data srt = {}, k, i;
+	u64 ts = quic_ktime_get_us();
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err, len;
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
+	u64 t, ts = quic_ktime_get_us(), timeout = QUIC_TOKEN_TIMEOUT_RETRY;
+	u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], iv[QUIC_IV_LEN];
+	u8 *retry_token = NULL, *rx_iv, *p, flag = *token;
+	struct crypto_aead *tfm = crypto->tag_tfm;
+	struct quic_data srt = {}, k, i;
+	struct aead_request *req;
+	struct scatterlist *sg;
+	int err;
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
index fc562035271c..51891ae9852e 100644
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

