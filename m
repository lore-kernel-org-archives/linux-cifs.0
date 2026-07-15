Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8DD3C8731
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 20:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784147544; cv=none; b=K8LWNGhiw3yV2lHJTlYx/9g/Kns5E/FD0FUWzinBqm0dc5ayzVlgieXQ5hu4Bf3J3TUGjnRfH011RF9U4tyhiRrtKv6Ji7gyvTZpXkjZpSJFczVZYUhVK620tqZRcCj+q3pytiXqlB0PxAYhHPREgRkk59CHSOz691P1OubsGX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784147544; c=relaxed/simple;
	bh=/bQtKC6CiR6fNQOT7TMdECeKriz4+4qjBxiQLUVGFj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfebqbOT0LrwBIDloCvmu4tRbv0q0rrj9PYFDMwWwfaIn413yXWgej8OG8wlqxMQSw5n2+YJy+InbhHIDXdRNnX2w0RgTERjBcKFvG8GKUJviHguCl3A6KLVYdlsXbD6iW8FKMjnbH+L3gVw7S2CbfU85NIOL5rykzOkg1VKIcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pNhtszM/; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pNhtszM/"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so23189206d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 13:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784147540; x=1784752340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZJySqPYHEI/JLIixeNzlwDYvPURO+z0Hy5bMGLRVvxA=;
        b=pNhtszM/MgAK0MZisjPg+u8dWnnIYorn1pu4yrzykbHI3hTj6Xzcq3+VT6kaAFw6oW
         sTWF9pzzObfqiRgyHBrW6mvCxwqeWXFZRPybKotUo8aH2XUjLo1ZBP8+dUJCmjja92xU
         F5RxRWrtu025mZx3znxSd5FI9Hws0Sv550AGnqCRZvgyoChxtcUTN/GOjTiLN/WEROer
         U3SYfKbpRG51bYVL5zpEwzdKcZHAhVzfvYT6SNAwil5sfv3Uq1KyvPBqu59RsgDRhf2O
         j7EniYsfvFLi+utDg7VH0BSABpVX02cCsm2g1McaGUGMPB4Qh+DxYsezEPk/Y39X+M66
         GkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784147540; x=1784752340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZJySqPYHEI/JLIixeNzlwDYvPURO+z0Hy5bMGLRVvxA=;
        b=MIfdc7+ReqqxsoMc7ox31O+/UEA47+5cwhF41K/9Od6hnHffg1UOawZ7XBglG4TeIO
         gP0fqEgDiJtb58UNcupBx790jOEJjhL7EWfHIIzMpSWAOwzRQOlcMkRCnZOV5zY9dVoz
         UYb/UYS+jwVhIxQcEkL1j1bTwrUvyDuhwtvWQVit92WqFN3r4DRygmkxLpcZj8f+3nPX
         coi5ZySUR/0fAd888bbp9KAgHILsICgrMQhR6fwWGY3EhPwk4PIP+gl+2P3nP9xogbUa
         tjW9sJQvQeOGJEwz99tVmbICm9GhDq3qCN2VjhqQuIYG21C8ZoqnWPL1IC0P0Np4LN/I
         azPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrG2+0FpgzaRRc8IQf9MfFbITQPNTe0q0TigXqfUY2ElP+MEjZjcMsOmPZ5SHmwRpmFYcQSJdkux3a0@vger.kernel.org
X-Gm-Message-State: AOJu0YxfWBeydl7nb+OTCAAl4WnLul3L62YwFOwrtqMSb8RageEyRmbg
	myirlyARgql82BLPf2P0o1/K/5w6Emf8gRqDDN5GqO7PbqsOTABt3E2B
X-Gm-Gg: AfdE7cmLUkZyZNO1e0IM/5vw5yVJySLfkGVPxXQ4AYUrb+n+7pBcJZbMZZjz8wc1JYc
	eI1rZDPYltcrR1TgUS4wifawPG4lpu7euuJ6XXqXGxtM7yYqAZCY0pySdlSASdPqXshDYM0w3No
	mXvS3JhGffbmTfTuozRfWPQRcGPFe3Noinry03ZfRY7nbwKf30LJg8Q4SYs3C4LQ1tpd3P9neL7
	CWac86+90lQbtABcxqL531cnIneZ9erOsR0prC45d/Xiktmo2jtbctZiSXK9Pc68KMM42P2LvEG
	4LujNZDr/PcnKri4KLrtL5BviBbSBeIJIJlT+Ycr3Mi3UDPtcy8Sfjy+T7JjLou79oakufv0n5D
	sDDCwMllU418vytudSaWjI2tp8vwivaU+7lEwsA86XtfK0UvGDgIwa6p3Euy9KXf7nydPzdyMS9
	Fn8s1aWl5NeVQY+3EXkxd2+mIO99rc43QoCYRaLRb5VmA+fqtTweTnAsZIeD/2euEBEy18+YEZ1
	dbh7n+mUECuvD7JvJ9CdEtWoqQFAb/e6MTR37DsynsWorm6rJZW77M=
X-Received: by 2002:ad4:5765:0:b0:8e9:cd74:87bb with SMTP id 6a1803df08f44-9076545da33mr11289706d6.18.1784147539809;
        Wed, 15 Jul 2026 13:32:19 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd248e666sm201326506d6.0.2026.07.15.13.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 13:32:19 -0700 (PDT)
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
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	mef@scarletmail.rutgers.edu,
	paul@jakma.org
Subject: [PATCH net-next v14 12/15] quic: add crypto packet encryption and decryption
Date: Wed, 15 Jul 2026 16:27:15 -0400
Message-ID: <34953facd615c0410ea3d68701c8fa50e0c8c784.1784147238.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1784147238.git.lucien.xin@gmail.com>
References: <cover.1784147238.git.lucien.xin@gmail.com>
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
v8:
  - Move skb_cow_data() from quic_crypto_payload_decrypt() to
    quic_crypto_header_decrypt(), as header decryption also writes to
    the skb and is invoked earlier than payload decryption on RX path.
v10:
  - Fix double period at end of the comment for quic_crypto_encrypt().
v11:
  - Note for AI review: call quic_crypto_aead_mem_alloc() after
    skb_cow_data() as it uses the return value for nsg. If the allocation
    fails, skb is dropped, so no rollback of prior skb modifications is
    needed.
  - Set maximum line length to 80 characters.
  - Add a check for skb->len in quic_crypto_get_retry_tag().
  - Also reset key_update_send_time when key_pending is cleared in
    quic_crypto_decrypt().
  - Handle -EBUSY returned from crypto_aead_en/decrypt() and return when
    err == -EINPROGRESS in quic_crypto_done().
  - Extract quic_crypto_token_init() from quic_crypto_generate_token() and
    quic_crypto_verify_token().
  - Merge quic_crypto_header_en/decrypt() to quic_crypto_header_protect()
    with an extra parameter to reduce code duplication.
  - Merge quic_crypto_payload_en/decrypt() to quic_crypto_payload_protect()
    with an extra parameter to reduce code duplication (noted by AI
    review).
v12:
  - Move ciphers definitions to above the encryption/decryption functions.
  - Fix some indentations in quic_crypto_skcipher_mem_alloc() and
    quic_crypto_header_protect().
  - Pass crypto and fetch the key phase only for short header packets in
    quic_crypto_header_protect() and quic_crypto_payload_protect().
  - Increment async_pending[phase] for asynchronous encryption/decryption
    operations, and pass crypto to quic_crypto_done() to decrement it.
  - Update key_phase and key_pending only after successful payload
    decryption in quic_crypto_decrypt() to comply with RFC9001.
  - Take the token flag into account when calling aead_request_set_ad() in
    quic_crypto_generate_token() and quic_crypto_verify_token().
  - Replace quic_crypto_token_init() with quic_crypto_token_protect() to
    perform AEAD encryption/decryption for the provided token, and update
    quic_crypto_generate/verify_token() accordingly.
  - Reuse TX AEAD (phase 1) from listen socket initial crypto in
    quic_crypto_token_protect(), and use crypto_wait for sync mode.
  - Reuse RX AEAD (phase 1) from listen socket initial crypto in
    quic_crypto_get_retry_tag(), using crypto_wait for sync mode.
  - Check cb->sync in quic_crypto_payload_protect() to enforce sync mode;
    set cb->sync in quic_crypto_decrypt() after key update in process
    context.
  - Change the label name 'err:' to 'out:' in quic_crypto_payload_protect()
    and quic_crypto_header_protect().
  - Reset crypto->key_derived if crypo->key_phase is flipped by key_update
    in quic_crypto_decrypt().
v13:
  - Fix the opportunity for kmemdup warning from cocci-check by replacing
    kzalloc() + memcpy() with kmemdup() in quic_crypto_verify_token().
v14:
  - Pass gfp flags to quic_crypto_encrypt(), quic_crypto_decrypt(),
    quic_crypto_header_protect(), quic_crypto_payload_protect(),
    quic_crypto_aead_mem_alloc(), and quic_crypto_skcipher_mem_alloc().
  - Change the skb->len < QUIC_TAG_LEN check to skb->len <= QUIC_TAG_LEN
    to match the comment.
  - Remove key derivation from quic_crypto_token_protect(), as it is
    already performed by quic_crypto_set_token_secret().
  - Move the timestamp from the encrypted part to AAD in
    quic_crypto_generate_token() and quic_crypto_verify_token(), so it can
    be used to generate the nonce by XORing it with the IV in
    quic_crypto_token_protect().
  - Replace memcmp() with crypto_memneq() in quic_crypto_verify_token()
    (noted by Sashiko AI review).
  - Reject tokens in quic_crypto_verify_token() if the timestamp is in the
    future or older than the allowed timeout.
---
 net/quic/crypto.c | 682 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h |  14 +
 2 files changed, 696 insertions(+)

diff --git a/net/quic/crypto.c b/net/quic/crypto.c
index 910557b68052..8b254bb0556c 100644
--- a/net/quic/crypto.c
+++ b/net/quic/crypto.c
@@ -12,6 +12,7 @@
 
 #include <crypto/skcipher.h>
 #include <linux/skbuff.h>
+#include <crypto/utils.h>
 #include <crypto/aead.h>
 #include <crypto/hash.h>
 #include <linux/quic.h>
@@ -252,6 +253,455 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
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
+static void *quic_crypto_skcipher_mem_alloc(struct crypto_skcipher *tfm,
+					    u32 mask_size, u8 **iv,
+					    struct skcipher_request **req,
+					    gfp_t gfp)
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
+	len += crypto_skcipher_alignmask(tfm) &
+	       ~(crypto_tfm_ctx_alignment() - 1);
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += req_size;
+
+	mem = kzalloc(len, gfp);
+	if (!mem)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(mem + mask_size,
+			      crypto_skcipher_alignmask(tfm) + 1);
+	*req = (struct skcipher_request *)PTR_ALIGN(*iv + iv_size,
+						    crypto_tfm_ctx_alignment());
+
+	return (void *)mem;
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
+	 * Once header protection is removed, the packet number is decoded by
+	 * finding the packet number value that is closest to the next expected
+	 * packet. The next expected packet is the highest received packet
+	 * number plus one.
+	 */
+	p = (u8 *)quic_hdr(skb) + cb->number_offset;
+	if (!quic_get_int(&p, &len, &cb->number, cb->number_len))
+		return -EINVAL;
+	cb->number = quic_get_num(number_max, cb->number, cb->number_len);
+	return 0;
+}
+
+#define QUIC_SAMPLE_LEN		16
+
+#define QUIC_HEADER_FORM_BIT	0x80
+#define QUIC_LONG_HEADER_MASK	0x0f
+#define QUIC_SHORT_HEADER_MASK	0x1f
+
+/* Header Protection. */
+static int quic_crypto_header_protect(struct quic_crypto *crypto,
+				      struct sk_buff *skb, bool enc, gfp_t gfp)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u8 *mask, *iv, *p, h_mask, chacha;
+	struct skcipher_request *req;
+	struct crypto_skcipher *tfm;
+	struct sk_buff *trailer;
+	struct scatterlist sg;
+	int err, i;
+
+	chacha = quic_crypto_is_cipher_chacha(crypto);
+	if (!enc) {
+		tfm = crypto->rx_hp_tfm;
+		if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN)
+			return -EINVAL;
+
+		err = skb_cow_data(skb, 0, &trailer);
+		if (err < 0)
+			return err;
+	} else {
+		tfm = crypto->tx_hp_tfm;
+	}
+
+	mask = quic_crypto_skcipher_mem_alloc(tfm, QUIC_SAMPLE_LEN, &iv, &req,
+					      gfp);
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
+	p = skb->data + cb->number_offset + QUIC_PN_MAX_LEN;
+	memcpy((chacha ? iv : mask), p, QUIC_SAMPLE_LEN);
+	sg_init_one(&sg, mask, QUIC_SAMPLE_LEN);
+	skcipher_request_set_tfm(req, tfm);
+	skcipher_request_set_crypt(req, &sg, &sg, QUIC_SAMPLE_LEN, iv);
+	err = crypto_skcipher_encrypt(req);
+	if (err)
+		goto out;
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
+	h_mask = ((*p & QUIC_HEADER_FORM_BIT) == QUIC_HEADER_FORM_BIT) ?
+		 QUIC_LONG_HEADER_MASK : QUIC_SHORT_HEADER_MASK;
+	*p = (u8)(*p ^ (mask[0] & h_mask));
+	if (!enc) {
+		if (!quic_hdr(skb)->form)
+			cb->key_phase = quic_hdr(skb)->key;
+		cb->number_len = quic_hdr(skb)->pnl + 1;
+	}
+	p += cb->number_offset;
+	for (i = 1; i <= cb->number_len; i++)
+		*p++ ^= mask[i];
+
+	if (!enc)
+		err = quic_crypto_get_number(skb);
+out:
+	kfree_sensitive(mask);
+	return err;
+}
+
+static void *quic_crypto_aead_mem_alloc(struct crypto_aead *tfm, u32 ctx_size,
+					u8 **iv, struct aead_request **req,
+					struct scatterlist **sg, u32 nsg,
+					gfp_t gfp)
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
+	mem = kzalloc(len, gfp);
+	if (!mem)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(mem + ctx_size, crypto_aead_alignmask(tfm) + 1);
+	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
+						crypto_tfm_ctx_alignment());
+	*sg = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
+					      __alignof__(struct scatterlist));
+
+	return (void *)mem;
+}
+
+static void quic_crypto_done(void *data, int err)
+{
+	struct sk_buff *skb = data;
+	struct quic_crypto *crypto;
+	struct quic_skb_cb *cb;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	cb = QUIC_SKB_CB(skb);
+	crypto = *(struct quic_crypto **)cb->crypto_ctx;
+	atomic_dec(&crypto->async_pending[cb->key_phase]);
+
+	kfree_sensitive(cb->crypto_ctx);
+	cb->crypto_done(skb, err);
+}
+
+/* AEAD Usage. */
+static int quic_crypto_payload_protect(struct quic_crypto *crypto,
+				       struct sk_buff *skb, bool enc, gfp_t gfp)
+{
+	u8 *base_iv, *iv, i, nonce[QUIC_IV_LEN], ccm, phase;
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	u32 len, hlen, sglen, nsg;
+	struct aead_request *req;
+	struct crypto_aead *tfm;
+	struct sk_buff *trailer;
+	struct scatterlist *sg;
+	void *ctx;
+	__be64 n;
+	int err;
+
+	ccm = quic_crypto_is_cipher_ccm(crypto);
+	phase = cb->key_phase;
+	hlen = cb->number_offset + cb->number_len;
+	if (enc) {
+		tfm = crypto->tx_tfm[phase];
+		base_iv = crypto->tx_iv[phase];
+		len = skb->len;
+		err = skb_cow_data(skb, QUIC_TAG_LEN, &trailer);
+		if (err < 0)
+			return err;
+		pskb_put(skb, trailer, QUIC_TAG_LEN);
+		if (!quic_hdr(skb)->form)
+			quic_hdr(skb)->key = phase;
+		sglen = skb->len;
+		nsg = (u32)err;
+	} else {
+		tfm = crypto->rx_tfm[phase];
+		base_iv = crypto->rx_iv[phase];
+		len = cb->length + cb->number_offset;
+		if (len - hlen < QUIC_TAG_LEN)
+			return -EINVAL;
+		sglen = len;
+		nsg = 1;
+	}
+
+	ctx = quic_crypto_aead_mem_alloc(tfm, sizeof(void *), &iv, &req, &sg,
+					 nsg, gfp);
+	if (!ctx)
+		return -ENOMEM;
+
+	sg_init_table(sg, nsg);
+	err = skb_to_sgvec(skb, sg, 0, sglen);
+	if (err < 0)
+		goto out;
+
+	/* rfc9001#section-5.3:
+	 *
+	 * The associated data, A, for the AEAD is the contents of the QUIC
+	 * header, starting from the first byte of either the short or long
+	 * header, up to and including the unprotected packet number.
+	 *
+	 * The nonce, N, is formed by combining the packet protection IV with
+	 * the packet number.  The 62 bits of the reconstructed QUIC packet
+	 * number in network byte order are left-padded with zeros to the size
+	 * of the IV. The exclusive OR of the padded packet number and the IV
+	 * forms the AEAD nonce.
+	 */
+	memcpy(nonce, base_iv, QUIC_IV_LEN);
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
+	if (cb->sync) {
+		DECLARE_CRYPTO_WAIT(wait);
+
+		aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  crypto_req_done, &wait);
+		err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			err = crypto_wait_req(err, &wait);
+		goto out;
+	}
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  quic_crypto_done, skb);
+	*(struct quic_crypto **)ctx = crypto;
+	cb->crypto_ctx = ctx; /* Async free context for quic_crypto_done() */
+	err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+	if (err == -EINPROGRESS || err == -EBUSY) {
+		atomic_inc(&crypto->async_pending[phase]);
+		memzero_explicit(nonce, sizeof(nonce));
+		return -EINPROGRESS;
+	}
+
+out:
+	kfree_sensitive(ctx);
+	memzero_explicit(nonce, sizeof(nonce));
+	return err;
+}
+
+/* Encrypts a QUIC packet before transmission.  This function performs AEAD
+ * encryption of the packet payload and applies header protection. It handles
+ * key phase tracking and key update timing.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb,
+			gfp_t gfp)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	int err;
+
+	cb->key_phase = crypto->key_phase;
+	/* Packet payload is already encrypted (e.g., resumed from async),
+	 * proceed to header protection only.
+	 */
+	if (cb->resume)
+		goto out;
+
+	/* If a key update is pending and this is the first packet using the
+	 * new key, save the current time. Later used to clear old keys after
+	 * some time has passed (see quic_crypto_decrypt()).
+	 */
+	if (crypto->key_pending && !crypto->key_update_send_time)
+		crypto->key_update_send_time = quic_ktime_get_us();
+
+	err = quic_crypto_payload_protect(crypto, skb, true, gfp);
+	if (err)
+		return err;
+out:
+	return quic_crypto_header_protect(crypto, skb, true, gfp);
+}
+
+/* Decrypts a QUIC packet after reception.  This function removes header
+ * protection, decrypts the payload, and processes any key updates if the key
+ * phase bit changes.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb,
+			gfp_t gfp)
+{
+	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
+	int err = 0;
+	u64 time;
+	u8 phase;
+
+	/* Payload was decrypted asynchronously.  Proceed with parsing packet
+	 * number and key phase.
+	 */
+	if (cb->resume) {
+		err = quic_crypto_get_number(skb);
+		if (err)
+			return err;
+		goto out;
+	}
+	if (!cb->number_len) { /* Packet header not yet decrypted. */
+		err = quic_crypto_header_protect(crypto, skb, false, gfp);
+		if (err) {
+			pr_debug("%s: hd decrypt err %d\n", __func__, err);
+			return err;
+		}
+	}
+
+	/* rfc9001#section-6:
+	 *
+	 * The Key Phase bit allows a recipient to detect a change in keying
+	 * material without needing to receive the first packet that triggered
+	 * the change. An endpoint that notices a changed Key Phase bit updates
+	 * keys and decrypts the packet that contains the changed value.
+	 */
+	phase = cb->key_phase;
+	if (phase != crypto->key_phase && !crypto->key_pending) {
+		if (!crypto->send_ready) /* Not ready for key update. */
+			return -EINVAL;
+		if (!cb->backlog) /* Key update requires process context. */
+			return -EKEYREVOKED;
+		/* Cannot do key update while async crypto is in progress. */
+		if (unlikely(atomic_read(&crypto->async_pending[phase])))
+			return -EBUSY;
+		err = quic_crypto_key_update(crypto); /* Perform key update. */
+		if (err) {
+			cb->errcode = QUIC_TRANSPORT_ERROR_KEY_UPDATE;
+			return err;
+		}
+		cb->sync = 1;
+		cb->key_update = 1; /* Mark packet as triggering key update. */
+	}
+
+	err = quic_crypto_payload_protect(crypto, skb, false, gfp);
+	if (err) {
+		if (err == -EINPROGRESS)
+			return err;
+		/* When using the old keys can not decrypt the packets, the
+		 * peer might start another key_update. Thus, clear the last
+		 * key_pending so that next packets will trigger the new
+		 * key-update.
+		 */
+		if (crypto->key_pending && phase != crypto->key_phase) {
+			crypto->key_pending = 0;
+			crypto->key_update_time = 0;
+			crypto->key_update_send_time = 0;
+		}
+		return err;
+	}
+
+out:
+	/* rfc9001#section-6.2:
+	 *
+	 * If a packet is successfully processed using the next key and IV,
+	 * then the peer has initiated a key update.
+	 */
+	if (cb->key_update) {
+		crypto->key_pending = 1;
+		crypto->key_derived = 0;
+		crypto->key_phase = !crypto->key_phase;
+	}
+	/* rfc9001#section-6.1:
+	 *
+	 * An endpoint MUST retain old keys until it has successfully
+	 * unprotected a packet sent using the new keys. An endpoint SHOULD
+	 * retain old keys for some time after unprotecting a packet sent using
+	 * the new keys.
+	 */
+	if (crypto->key_pending && cb->key_phase == crypto->key_phase) {
+		time = crypto->key_update_send_time;
+		if (time &&
+		    quic_ktime_get_us() - time >= crypto->key_update_time) {
+			crypto->key_pending = 0;
+			crypto->key_update_time = 0;
+			crypto->key_update_send_time = 0;
+		}
+	}
+	return err;
+}
+
 int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
 {
 	const struct quic_cipher *cipher;
@@ -540,6 +990,238 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
 	return err;
 }
 
+#define QUIC_RETRY_KEY_V1 \
+	"\xbe\x0c\x69\x0b\x9f\x66\x57\x5a\x1d\x76\x6b\x54\xe3\x68\xc8\x4e"
+#define QUIC_RETRY_KEY_V2 \
+	"\x8f\xb4\xb0\x1b\x56\xac\x48\xe2\x60\xfb\xcb\xce\xad\x7c\xcc\x92"
+
+#define QUIC_RETRY_NONCE_V1 "\x46\x15\x99\xd3\x5d\x63\x2b\xf2\x23\x98\x25\xbb"
+#define QUIC_RETRY_NONCE_V2 "\xd8\x69\x69\xbc\x2d\x7c\x6d\x99\x90\xef\xb0\x4a"
+
+/* Retry Packet Integrity. */
+int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_buff *skb,
+			      struct quic_conn_id *odcid, u32 version, u8 *tag)
+{
+	/* Reuse RX AEAD (phase 1) in Initial crypto. */
+	struct crypto_aead *tfm = crypto->rx_tfm[1];
+	u8 *pseudo_retry, *p, *iv, *key;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	struct scatterlist *sg;
+	u32 plen;
+	int err;
+
+	/* The caller must ensure skb->len > QUIC_TAG_LEN. */
+	if (skb->len <= QUIC_TAG_LEN)
+		return -EINVAL;
+
+	/* rfc9001#section-5.8:
+	 *
+	 * The Retry Integrity Tag is a 128-bit field that is computed as the
+	 * output of AEAD_AES_128_GCM used with the following inputs:
+	 *
+	 * - The secret key, K, is 128 bits equal to
+	 *   0xbe0c690b9f66575a1d766b54e368c84e.
+	 * - The nonce, N, is 96 bits equal to 0x461599d35d632bf2239825bb.
+	 * - The plaintext, P, is empty.
+	 * - The associated data, A, is the contents of the Retry
+	 *   Pseudo-Packet,
+	 *
+	 * The Retry Pseudo-Packet is not sent over the wire. It is computed by
+	 * taking the transmitted Retry packet, removing the Retry Integrity
+	 * Tag, and prepending the two following fields: ODCID Length +
+	 * Original Destination Connection ID (ODCID).
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
+	pseudo_retry = quic_crypto_aead_mem_alloc(tfm, plen + QUIC_TAG_LEN, &iv,
+						  &req, &sg, 1, GFP_KERNEL);
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
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
+	err = crypto_aead_encrypt(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		err = crypto_wait_req(err, &wait);
+	if (!err)
+		memcpy(tag, p, QUIC_TAG_LEN);
+
+	kfree_sensitive(pseudo_retry);
+	return err;
+}
+
+/* Derives a key and IV using HKDF, configures the AEAD transform and performs
+ * AEAD encryption/decryption for the provided token.
+ */
+static int quic_crypto_token_protect(struct quic_crypto *crypto, u8 *token,
+				     u32 len, u32 adlen, bool enc)
+{
+	/* Reuse TX AEAD (phase 1) in Initial crypto. */
+	struct crypto_aead *tfm = crypto->tx_tfm[1];
+	u32 extra = enc ? QUIC_TAG_LEN : 0, tslen;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	struct scatterlist *sg;
+	void *ctx = NULL;
+	u8 *nonce, *p, i;
+	__be64 n;
+	int err;
+	u64 ts;
+
+	ctx = quic_crypto_aead_mem_alloc(tfm, 0, &nonce, &req, &sg, 1,
+					 GFP_KERNEL);
+	if (!ctx) {
+		err = -ENOMEM;
+		goto out;
+	}
+	memcpy(nonce, crypto->tx_iv[1], QUIC_IV_LEN);
+
+	tslen = sizeof(ts);
+	p = token + adlen - tslen;
+	quic_get_int(&p, &tslen, &ts, tslen);
+
+	n = cpu_to_be64(ts);
+	for (i = 0; i < sizeof(n); i++)
+		nonce[QUIC_IV_LEN - sizeof(n) + i] ^= ((u8 *)&n)[i];
+
+	sg_init_one(sg, token, len);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, adlen);
+	aead_request_set_crypt(req, sg, sg, len - adlen - extra, nonce);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
+	err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		err = crypto_wait_req(err, &wait);
+
+out:
+	kfree_sensitive(ctx);
+	return err;
+}
+
+/* Generate a token for Retry or address validation.
+ *
+ * Builds a token with the format: [flag][client address][timestamp][original
+ * DCID][auth tag]
+ *
+ * Encrypts the token (excluding the first flag byte) using AES-GCM with a key
+ * and IV derived via HKDF. The original DCID is stored to be recovered later
+ * from a Client Initial packet.  Ensures the token is bound to the client
+ * address and time, preventing reuse or tampering.
+ *
+ * Returns 0 on success or a negative error code on failure.
+ */
+int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
+			       u32 addrlen, struct quic_conn_id *conn_id,
+			       u8 *token, u32 *tlen)
+{
+	u8 *token_buf, *p, flag = *token;
+	u64 ts = quic_ktime_get_us();
+	u32 tslen = sizeof(ts);
+	int err, len;
+
+	len = sizeof(flag) + addrlen + tslen + conn_id->len + QUIC_TAG_LEN;
+	token_buf = kmalloc(len, GFP_KERNEL);
+	if (!token_buf)
+		return -ENOMEM;
+
+	p = token_buf;
+	p = quic_put_int(p, flag, sizeof(flag));
+	p = quic_put_data(p, addr, addrlen);
+	p = quic_put_int(p, ts, tslen);
+	quic_put_data(p, conn_id->data, conn_id->len);
+
+	err = quic_crypto_token_protect(crypto, token_buf, len,
+					sizeof(flag) + addrlen + tslen, true);
+	if (err)
+		goto out;
+
+	memcpy(token, token_buf, len);
+	*tlen = len;
+out:
+	kfree(token_buf);
+	return err;
+}
+
+/* Validate a Retry or address validation token.
+ *
+ * Decrypts the token using derived key and IV. Checks that the decrypted
+ * address matches the provided address, validates the embedded timestamp
+ * against current time with a version-specific timeout. If applicable, it
+ * extracts and returns the original destination connection ID (ODCID) for
+ * Retry packets.
+ *
+ * Returns 0 if the token is valid, -EINVAL if invalid, or another negative
+ * error code.
+ */
+int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr,
+			     u32 addrlen, struct quic_conn_id *conn_id,
+			     u8 *token, u32 len)
+{
+	u64 t, ts = quic_ktime_get_us(), timeout = QUIC_TOKEN_TIMEOUT_RETRY;
+	u8 *token_buf, *p, flag;
+	u32 tslen = sizeof(ts);
+	int err;
+
+	if (len < sizeof(flag) + addrlen + tslen + QUIC_TAG_LEN)
+		return -EINVAL;
+	token_buf = kmemdup(token, len, GFP_KERNEL);
+	if (!token_buf)
+		return -ENOMEM;
+
+	err = quic_crypto_token_protect(crypto, token_buf, len,
+					sizeof(flag) + addrlen + tslen, false);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	p = token_buf;
+	flag = *p++;
+	len -= sizeof(flag);
+	if (crypto_memneq(p, addr, addrlen))
+		goto out;
+
+	p += addrlen;
+	len -= addrlen;
+	if (flag == QUIC_TOKEN_FLAG_REGULAR)
+		timeout = QUIC_TOKEN_TIMEOUT_REGULAR;
+	if (!quic_get_int(&p, &len, &t, tslen) || t > ts || ts - t > timeout)
+		goto out;
+
+	len -= QUIC_TAG_LEN;
+	if (len > QUIC_CONN_ID_MAX_LEN)
+		goto out;
+
+	if (flag == QUIC_TOKEN_FLAG_RETRY)
+		quic_conn_id_update(conn_id, p, len);
+	err = 0;
+out:
+	kfree(token_buf);
+	return err;
+}
+
 /* Derive a secret using HKDF-Extract and HKDF-Expand with the given label.
  * Used to generate a stateless reset token or session resumption master key.
  */
diff --git a/net/quic/crypto.h b/net/quic/crypto.h
index 6d61044fccd3..77281a824f72 100644
--- a/net/quic/crypto.h
+++ b/net/quic/crypto.h
@@ -64,6 +64,11 @@ int quic_crypto_set_secret(struct quic_crypto *crypto,
 int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type);
 int quic_crypto_key_update(struct quic_crypto *crypto);
 
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb,
+			gfp_t gfp);
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb,
+			gfp_t gfp);
+
 int quic_crypto_derive_secret(struct quic_crypto *crypto, void *data, u32 len,
 			      char *label, u8 *srt, u32 srt_len);
 int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
@@ -71,4 +76,13 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
 				     u32 version, bool is_serv);
 int quic_crypto_set_token_secret(struct quic_crypto *crypto);
 
+int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
+			       u32 addrlen, struct quic_conn_id *conn_id,
+			       u8 *token, u32 *tlen);
+int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_buff *skb,
+			      struct quic_conn_id *odcid, u32 version, u8 *tag);
+int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr,
+			     u32 addrlen, struct quic_conn_id *conn_id,
+			     u8 *token, u32 len);
+
 void quic_crypto_free(struct quic_crypto *crypto);
-- 
2.47.1

