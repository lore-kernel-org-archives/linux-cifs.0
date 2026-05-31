Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875633859F7
	for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780233101; cv=none; b=G18rrzoMe8VNIwrM3e1n1JHWbr5yhdeFAAIPI54qWzaUV8KLsKt+/a1aQY2ifSMeR23FjO1cvZubTqkqA+2k9dVsStdpLcBRz4uRyPjsnwNNy1yGTbMGvJnXEgmEtkDhG+pjw7lLvgDU8Qm5TH2L2BbcM1DncGSs4RZz+u6OV2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780233101; c=relaxed/simple;
	bh=7oVZnhPE74XIEa2WxrLdG6rDgMsyQ8IAHoAqOm9If3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzjXYgTX8WkxBeP5Xv1xbj0ToqgwTeaORXu1pUmWhM+2nYpBnbYHPbyd9U2uEUHlge3HVfk3ApKNaq+0IY+TUAofdn2Rs83AUesIdZFmpzHtM3Z+D+Oz3V0AC0fC+ECyjcHGvU6rXEzc8Mxfv/SSdpiS8rNeznmqhRHO4MtMglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LH7S41OT; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LH7S41OT"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8ccf18ef922so19713926d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 31 May 2026 06:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780233096; x=1780837896; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wJWekLx+odk/cjw3a/2SxKGuWr4jj2LuXeyVLduohJ0=;
        b=LH7S41OTfUnnj+6Mh4CrLHhhSwFfcYbmVn0d/vP64pxP4hunOBDzDq/pGNiLplXEdm
         ELkVVVoKr82zjDTVp3RQ5Y5uO+N+8p4gwyQ2rT6qw0SxdJ4cjqC7SBMPAO6SvjSbrWCr
         tqGeNhqRVY9wLO5qg5XluCkPPVNBMygTXLFaI6vZBJjgoE2mbvTEJjKBTmUGBVpzvu+k
         BE70n0Qmm7dUDT1VDuUziN+4MQhP58GtlZ/4iu75bdS8xkxkJZGW9c4N8/mnVGYfLDcb
         x7miiaci2qqtQJQ+3ky7U7tDhfHDm/qM9ptz0mZkLUOVMvpi3YS/ewdfpcUePtQBzsjo
         O4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780233096; x=1780837896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wJWekLx+odk/cjw3a/2SxKGuWr4jj2LuXeyVLduohJ0=;
        b=Ter88r56iJfkmDpc5AHjDJUMbHV6v2ihp50pT3OdGP+hCwGDIVFrXTPrcAbOukrQH9
         GGHDqkIyL+XNMwjAWRMG3zD25crCC0MKRFyw1tE5yvOKg0Ir7X9lcyulPMQiJI/RIChv
         3Kc9LIB5k2ZOJPMocJ9DORP6fdb/jc1fIj2XmsF+7y0zwNyq77kc53TwQrFM5lUGaRsz
         DU2YMrwM22KeOKkSchU2kjk0HI/qrX+IXLD1Xde16//dcMd3mLAzEW8/2Q8+UwfhGhod
         Eyxqu1y3+/m/WiUbGTVB9wprL3VXYMxOcbdXCUrQTmTywzY6L/4c/ASUOvrass5+6QEA
         swkQ==
X-Forwarded-Encrypted: i=1; AFNElJ/AeCH6uLmDXYxtM7IKHIJeq/rx9BZNV4LIxxoVq72A/SJxhs3iZo71pBhc7qAgkaoWR3BAVM1dG2Pk@vger.kernel.org
X-Gm-Message-State: AOJu0YxcN8QTau8bU2FTes7mFJHtqT4zbCokRp+rYHa0D1V1UKFM3d8C
	CPM7MU8CDJDzDL3dGRrn00dCfNrrLeLrsJHcaTAquKQ67gN+7QCB4x+Q
X-Gm-Gg: Acq92OE4EEVAIDYt5CxnEXiM9kH5zv4VC0KQbll4MY+PZtnUxUiDDmtsS0fVfdkjgqU
	BSNrYPvd4rL29I7L55PLX2D8sfQhqBOFyrh6gFUMinivWXNQ8Wb8olJEYGz1eNYwkbdg8I4MwBZ
	OW1VV6z0+SptXaq7rh42HpqK8a9YpSR6j8F2Ena5V2JRQtEkTtvghjZiW3JWIUAmpNKi21+2cp3
	BxQE3PADhh+6FOOrFcWtbIfz5n9gIeex839qPgpIcJNJAHjEwfLfhgG2aLwJJ8erqC6e+SP7FRV
	eBhv120eRuBn8V3nhEZv1zQWXM3PiIAO2aauxGA0YpeKHW0DlMB4FHjmPzcztRS+ventOAA/Eeg
	u0Wwl1bOdtAlnB9bIX5sVkg10QvdRS3Onhz51MQd6oTA4oH/qcQ3K8K7Kjv49ywnLt2Hm8O9rAt
	qxQ7qqg3F2HFkQc5JVB63HUAOKWCvyh1N0jA6W3wWLvTu4A58yo3xmBOLAvCLN0ztp0slM/LiXe
	Psq5JrxE2tb2Pmmk87Uv3WsfUNn3jYewAggQ577VYd72qBp3y3ieabXaKhr9jjJ+tvBRI2mJDnw
X-Received: by 2002:a05:6214:d0e:b0:8ac:b1ad:3a29 with SMTP id 6a1803df08f44-8ccefdda224mr122395276d6.35.1780233096245;
        Sun, 31 May 2026 06:11:36 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea2163b0sm69609746d6.38.2026.05.31.06.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 06:11:35 -0700 (PDT)
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
Subject: [PATCH net-next v12 12/15] quic: add crypto packet encryption and decryption
Date: Sun, 31 May 2026 09:08:48 -0400
Message-ID: <e3a67009a4f07ebf09ca6907afc4894ba266c120.1780232931.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1780232930.git.lucien.xin@gmail.com>
References: <cover.1780232930.git.lucien.xin@gmail.com>
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
---
 net/quic/crypto.c | 680 ++++++++++++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h |  12 +
 2 files changed, 692 insertions(+)

diff --git a/net/quic/crypto.c b/net/quic/crypto.c
index 606139899261..06be2dcfa376 100644
--- a/net/quic/crypto.c
+++ b/net/quic/crypto.c
@@ -257,6 +257,450 @@ static struct quic_cipher ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
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
+					    struct skcipher_request **req)
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
+	mem = kzalloc(len, GFP_ATOMIC);
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
+				      struct sk_buff *skb, bool enc)
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
+				       struct sk_buff *skb, bool enc)
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
+					 nsg);
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
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb)
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
+	err = quic_crypto_payload_protect(crypto, skb, true);
+	if (err)
+		return err;
+out:
+	return quic_crypto_header_protect(crypto, skb, true);
+}
+
+/* Decrypts a QUIC packet after reception.  This function removes header
+ * protection, decrypts the payload, and processes any key updates if the key
+ * phase bit changes.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb)
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
+		err = quic_crypto_header_protect(crypto, skb, false);
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
+	err = quic_crypto_payload_protect(crypto, skb, false);
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
 	struct quic_cipher *cipher;
@@ -517,6 +961,242 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
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
+	if (skb->len < QUIC_TAG_LEN)
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
+	/* The caller must ensure skb->len > QUIC_TAG_LEN. */
+	plen = 1 + odcid->len + skb->len - QUIC_TAG_LEN;
+	pseudo_retry = quic_crypto_aead_mem_alloc(tfm, plen + QUIC_TAG_LEN, &iv,
+						  &req, &sg, 1);
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
+	u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], iv[QUIC_IV_LEN], *tiv;
+	/* Reuse TX AEAD (phase 1) in Initial crypto. */
+	struct crypto_aead *tfm = crypto->tx_tfm[1];
+	u32 extra = enc ? QUIC_TAG_LEN : 0;
+	struct quic_data srt = {}, k, i;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	struct scatterlist *sg;
+	void *ctx = NULL;
+	int err;
+
+	quic_data(&srt, quic_random_data, QUIC_RANDOM_DATA_LEN);
+	quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	quic_data(&i, iv, QUIC_IV_LEN);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &i, NULL,
+				      QUIC_VERSION_V1);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
+	if (err)
+		goto out;
+	ctx = quic_crypto_aead_mem_alloc(tfm, 0, &tiv, &req, &sg, 1);
+	if (!ctx) {
+		err = -ENOMEM;
+		goto out;
+	}
+	memcpy(tiv, iv, QUIC_IV_LEN);
+
+	sg_init_one(sg, token, len);
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_ad(req, adlen);
+	aead_request_set_crypt(req, sg, sg, len - adlen - extra, tiv);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
+	err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		err = crypto_wait_req(err, &wait);
+
+out:
+	memzero_explicit(key, sizeof(key));
+	memzero_explicit(iv, sizeof(iv));
+	kfree_sensitive(ctx);
+	return err;
+}
+
+/* Generate a token for Retry or address validation.
+ *
+ * Builds a token with the format: [client address][timestamp][original
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
+	int err, len;
+
+	len = sizeof(flag) + addrlen + sizeof(ts) + conn_id->len + QUIC_TAG_LEN;
+	token_buf = kzalloc(len, GFP_KERNEL);
+	if (!token_buf)
+		return -ENOMEM;
+
+	p = token_buf;
+	p = quic_put_int(p, flag, sizeof(flag));
+	p = quic_put_data(p, addr, addrlen);
+	p = quic_put_int(p, ts, sizeof(ts));
+	quic_put_data(p, conn_id->data, conn_id->len);
+
+	err = quic_crypto_token_protect(crypto, token_buf, len,
+					sizeof(flag) + addrlen, true);
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
+	int err;
+
+	if (len < sizeof(flag) + addrlen + sizeof(ts) + QUIC_TAG_LEN)
+		return -EINVAL;
+	token_buf = kzalloc(len, GFP_KERNEL);
+	if (!token_buf)
+		return -ENOMEM;
+	memcpy(token_buf, token, len);
+
+	err = quic_crypto_token_protect(crypto, token_buf, len,
+					sizeof(flag) + addrlen, false);
+	if (err)
+		goto out;
+
+	err = -EINVAL;
+	p = token_buf;
+	flag = *p++;
+	len -= sizeof(flag);
+	if (memcmp(p, addr, addrlen))
+		goto out;
+
+	p += addrlen;
+	len -= addrlen;
+	if (flag == QUIC_TOKEN_FLAG_REGULAR)
+		timeout = QUIC_TOKEN_TIMEOUT_REGULAR;
+	if (!quic_get_int(&p, &len, &t, sizeof(ts)) || t + timeout < ts)
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
 /* Generate a derived key using HKDF-Extract and HKDF-Expand with a given
  * label.
  */
diff --git a/net/quic/crypto.h b/net/quic/crypto.h
index 08b23df06e31..37a5687fad9f 100644
--- a/net/quic/crypto.h
+++ b/net/quic/crypto.h
@@ -63,6 +63,9 @@ int quic_crypto_set_secret(struct quic_crypto *crypto,
 int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type);
 int quic_crypto_key_update(struct quic_crypto *crypto);
 
+int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb);
+int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb);
+
 int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
 				     struct quic_conn_id *conn_id,
 				     u32 version, bool is_serv);
@@ -73,5 +76,14 @@ int quic_crypto_generate_stateless_reset_token(struct quic_crypto *crypto,
 					       void *data, u32 len, u8 *key,
 					       u32 key_len);
 
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
 void quic_crypto_init(void);
-- 
2.47.1

