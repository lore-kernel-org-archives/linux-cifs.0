Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACC93AE6F5
	for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768490223; cv=none; b=mnpJcxvDN3VzBEC8VQcJt8t3yUZFqTP4YrODnOjIc3tNJznonHdtpmXHVGnN/j1576+ulGJRUIXUV07PpJJXVfp79cOmaPGsUWwAJRrAlHUe1+PlM61zXUyHJPaN0aG/Ho5kbFb3tTQ7FRfLtw866GdM+pmj0CFe6E7PpdM7Ljw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768490223; c=relaxed/simple;
	bh=1feCgurXyJbeHbqF9juko3V9GO6gIvrOtabCwhyhbmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTrioDj/yCkn1TNItKURRFNwhGOg+ID0MV6tXPIpiTbxERnrIwg84F8UfpSzyGbpC1LMhVqprIk3nuiUV0DCuHugoi3Yn7MjZD8CDmzjdz0R8lu02RCTTBHDJa/cUfQ0wsaZxWXy2ksQ9Q+DGBeg//ytNi6a4naSDe14l+UsBjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e9Uy7AV8; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9Uy7AV8"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88a3d2f3299so9578106d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Jan 2026 07:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768490212; x=1769095012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGRH9Xp8Pdpy5ZGylJ6ekurktpNBs4V5gwO2v01zM7Y=;
        b=e9Uy7AV82zEpIZ2+g4jKmxwiZJhugiw/MnoXgkd4ZVSCXi8Yt/tPjCYUj69TCOvZl/
         YXb0THirUJrJ8q7SFX7ur/IpxRQNzs3691qT28/s0gsgKdOZZtL76d65R1BejaLo+j9f
         DrM2mkFDxVG+lZsxt0x+ls6A1H/4qKHv2chUhgF8DpOEJs3HGrKp9qKTiM/oi8Mcu41m
         KjxY8kJMBkLey5jABjmbRR73tniL34hLDMwq9J1mad7rGgYgoIZY+XNPDRx93SNyzMe9
         Ma6mPOpbwiBVcZnlIH+f2qdjBiSS+MP4TW1jJROsYASQ2KxwXEUQmtmfsJp+uNGDH9Zz
         ZHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768490212; x=1769095012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nGRH9Xp8Pdpy5ZGylJ6ekurktpNBs4V5gwO2v01zM7Y=;
        b=inuY5iHdKzz3FPImqn0OaReMCpB5KojEW/AantCHg7P8SQPI4gFwsJ5GMpia1pZ/Pc
         6WzsdpvcnPs754NPummPhPZp6bl1W1uG1Dj+vIIl/NpTTHUQlxWvAmgGWcHXapts0QQ5
         MAvZH2W7MJI7lkokCUH90jqKOEXXi+MBFQ4hAU2nDTZmJdtx+4eXeFFMViVOgKViOtwX
         LRu0nNbQwZdJKbTFctDlvYTZsvx5BrgMjKOHl+nabGo/06RVzRKBH5Br1T8OQWRlPEfC
         eZEXxbRvuwax7SfI0rzC0KvSnfN2YlC+BcsdgIDqCXNSfZEm0R4vlh9fGM1K1srjvLhR
         niqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUU+ph3thsbIGEC7eZHYHfklZPu56GpMe+BhsjqTRDWILmCx2Bn1TErlAghWMyxd738r02H46qvXzrm@vger.kernel.org
X-Gm-Message-State: AOJu0YyUCNyLcryaFJnMcHUlEUzZytDJYqojJs1tHivfcpWh1/NYcuLm
	D+x5ezGWOOQVqgiDZEwrTPlXRedcwSFmzTIjV1Kz54+0mwvVf/xfX5zY
X-Gm-Gg: AY/fxX4vrbvWA81+A8oM6Uu0q/usqtH0mXCVZ3gUcJMMUzj4PYfHObD7lwIENEAA/5w
	1wkkuZ4yCzmsLr2KFHnswrWkLFueiiWDGy+UUP5+eiRNu04FCI137gweA6SR4KCljf6H2M/6pQu
	8JcCAh9VE2r7blPPV2K6zG2Lcqjl6dZWUcxH9JUokjyjqNbZpZKlWKKiCsYqDMkH0mVnwcyImTE
	NRHLA9rC3A1/yCutOu6czsWnEv+vIuH7zOa1RG2r4Lz2XtokYF3457MKe67J3Se4G/M6tSClbJd
	4eJvjizsx+/ZsE+Me3sNOaR5PdnldPyLGb7q3YsPSCALKxp2ag2Hd47q779a7pbB6zkEvHN2T3W
	I68u8aStXIhss0WwKyP2Y/7g9Z9jtt9BsBKdJPsSvi/+/Mxd6DJFVqk2Y8uKqklNDbvCZpCsPUl
	U8s0mGjBaP2Kn288EW2fYYaKrBTIUosXdedOrzr7yCm/8vXFp2NccyHgsVvig3Lg==
X-Received: by 2002:a05:6214:21e7:b0:890:7f0b:4108 with SMTP id 6a1803df08f44-892743670acmr74714286d6.25.1768490203657;
        Thu, 15 Jan 2026 07:16:43 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770cc6edsm201030056d6.4.2026.01.15.07.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 07:16:43 -0800 (PST)
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
Subject: [PATCH net-next v7 11/16] quic: add crypto key derivation and installation
Date: Thu, 15 Jan 2026 10:11:11 -0500
Message-ID: <84a079a073c334141a30970214d7c93aaf030624.1768489876.git.lucien.xin@gmail.com>
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

This patch introduces 'quic_crypto', a component responsible for QUIC
encryption key derivation and installation across the various key
levels: Initial, Handshake, 0-RTT (Early), and 1-RTT (Application).

It provides helpers to derive and install initial secrets, set traffic
secrets and install the corresponding keys, and perform key updates to
enable forward secrecy. Additionally, it implements stateless reset
token generation, used to support connection reset without state.

- quic_crypto_initial_keys_install(): Derive and install initial keys.

- quic_crypto_set_cipher(): Allocate all transforms based on the cipher
  type provided.

- quic_crypto_set_secret(): Set the traffic secret and install derived
  keys.

- quic_crypto_key_update(): Rekey and install new keys to the !phase
  side.

- quic_crypto_generate_stateless_reset_token(): Generate token for
  stateless reset.

These mechanisms are essential for establishing and maintaining secure
communication throughout the QUIC connection lifecycle.

Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
Signed-off-by: Moritz Buhl <mbuhl@openbsd.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
v3:
  - Remove lock from quic_net, since Initial packet decryption for ALPN
    will be handled serially in a workqueue when ALPN demux is enabled.
v4:
  - Use local cipher pointer in quic_crypto_set_secret() to avoid a
    warning from Smatch.
v5:
  - Change the timestamp variables from u32 to u64, which provides
    sufficient precision for timestamps in microsecond.
---
 net/quic/Makefile   |   2 +-
 net/quic/crypto.c   | 560 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h   |  73 ++++++
 net/quic/protocol.c |  11 +
 net/quic/protocol.h |   1 +
 net/quic/socket.c   |   2 +
 net/quic/socket.h   |   7 +
 7 files changed, 655 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/crypto.c
 create mode 100644 net/quic/crypto.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 9d8e18297911..58bb18f7926d 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IP_QUIC) += quic.o
 
 quic-y := common.o family.o protocol.o socket.o stream.o connid.o path.o \
-	  cong.o pnspace.o
+	  cong.o pnspace.o crypto.o
diff --git a/net/quic/crypto.c b/net/quic/crypto.c
new file mode 100644
index 000000000000..1623aaa5aafb
--- /dev/null
+++ b/net/quic/crypto.c
@@ -0,0 +1,560 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Initialization/cleanup for QUIC protocol support.
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <crypto/skcipher.h>
+#include <linux/skbuff.h>
+#include <crypto/aead.h>
+#include <crypto/hkdf.h>
+#include <linux/quic.h>
+#include <net/tls.h>
+
+#include "common.h"
+#include "crypto.h"
+
+#define QUIC_RANDOM_DATA_LEN	32
+
+static u8 quic_random_data[QUIC_RANDOM_DATA_LEN] __read_mostly;
+
+/* HKDF-Extract. */
+static int quic_crypto_hkdf_extract(struct crypto_shash *tfm, struct quic_data *srt,
+				    struct quic_data *hash, struct quic_data *key)
+{
+	return hkdf_extract(tfm, hash->data, hash->len, srt->data, srt->len, key->data);
+}
+
+#define QUIC_MAX_INFO_LEN	256
+
+/* HKDF-Expand-Label. */
+static int quic_crypto_hkdf_expand(struct crypto_shash *tfm, struct quic_data *srt,
+				   struct quic_data *label, struct quic_data *hash,
+				   struct quic_data *key)
+{
+	u8 info[QUIC_MAX_INFO_LEN], *p = info;
+	u8 LABEL[] = "tls13 ";
+	u32 infolen;
+	int err;
+
+	/* rfc8446#section-7.1:
+	 *
+	 *  HKDF-Expand-Label(Secret, Label, Context, Length) =
+	 *       HKDF-Expand(Secret, HkdfLabel, Length)
+	 *
+	 *  Where HkdfLabel is specified as:
+	 *
+	 *  struct {
+	 *      uint16 length = Length;
+	 *      opaque label<7..255> = "tls13 " + Label;
+	 *      opaque context<0..255> = Context;
+	 *  } HkdfLabel;
+	 */
+	*p++ = (u8)(key->len / QUIC_MAX_INFO_LEN);
+	*p++ = (u8)(key->len % QUIC_MAX_INFO_LEN);
+	*p++ = (u8)(sizeof(LABEL) - 1 + label->len);
+	p = quic_put_data(p, LABEL, sizeof(LABEL) - 1);
+	p = quic_put_data(p, label->data, label->len);
+	if (hash) {
+		*p++ = (u8)hash->len;
+		p = quic_put_data(p, hash->data, hash->len);
+	} else {
+		*p++ = 0;
+	}
+	infolen = (u32)(p - info);
+
+	err = crypto_shash_setkey(tfm, srt->data, srt->len);
+	if (err)
+		return err;
+
+	return hkdf_expand(tfm, info, infolen, key->data, key->len);
+}
+
+#define KEY_LABEL_V1		"quic key"
+#define IV_LABEL_V1		"quic iv"
+#define HP_KEY_LABEL_V1		"quic hp"
+
+#define KU_LABEL_V1		"quic ku"
+
+/* rfc9369#section-3.3.2:
+ *
+ * The labels used in rfc9001 to derive packet protection keys, header protection keys, Retry
+ * Integrity Tag keys, and key updates change from "quic key" to "quicv2 key", from "quic iv"
+ * to "quicv2 iv", from "quic hp" to "quicv2 hp", and from "quic ku" to "quicv2 ku".
+ */
+#define KEY_LABEL_V2		"quicv2 key"
+#define IV_LABEL_V2		"quicv2 iv"
+#define HP_KEY_LABEL_V2		"quicv2 hp"
+
+#define KU_LABEL_V2		"quicv2 ku"
+
+/* Packet Protection Keys. */
+static int quic_crypto_keys_derive(struct crypto_shash *tfm, struct quic_data *s,
+				   struct quic_data *k, struct quic_data *i,
+				   struct quic_data *hp_k, u32 version)
+{
+	struct quic_data hp_k_l = {HP_KEY_LABEL_V1, strlen(HP_KEY_LABEL_V1)};
+	struct quic_data k_l = {KEY_LABEL_V1, strlen(KEY_LABEL_V1)};
+	struct quic_data i_l = {IV_LABEL_V1, strlen(IV_LABEL_V1)};
+	struct quic_data z = {};
+	int err;
+
+	/* rfc9001#section-5.1:
+	 *
+	 * The current encryption level secret and the label "quic key" are input to the
+	 * KDF to produce the AEAD key; the label "quic iv" is used to derive the
+	 * Initialization Vector (IV). The header protection key uses the "quic hp" label.
+	 * Using these labels provides key separation between QUIC and TLS.
+	 */
+	if (version == QUIC_VERSION_V2) {
+		quic_data(&hp_k_l, HP_KEY_LABEL_V2, strlen(HP_KEY_LABEL_V2));
+		quic_data(&k_l, KEY_LABEL_V2, strlen(KEY_LABEL_V2));
+		quic_data(&i_l, IV_LABEL_V2, strlen(IV_LABEL_V2));
+	}
+
+	err = quic_crypto_hkdf_expand(tfm, s, &k_l, &z, k);
+	if (err)
+		return err;
+	err = quic_crypto_hkdf_expand(tfm, s, &i_l, &z, i);
+	if (err)
+		return err;
+	/* Don't change hp key for key update. */
+	if (!hp_k)
+		return 0;
+
+	return quic_crypto_hkdf_expand(tfm, s, &hp_k_l, &z, hp_k);
+}
+
+/* Derive and install transmission (TX) packet protection keys for the current key phase.
+ * This involves generating AEAD encryption key, IV, and optionally header protection key.
+ */
+static int quic_crypto_tx_keys_derive_and_install(struct quic_crypto *crypto)
+{
+	struct quic_data srt = {}, k, iv, hp_k = {}, *hp = NULL;
+	u8 tx_key[QUIC_KEY_LEN], tx_hp_key[QUIC_KEY_LEN];
+	int err, phase = crypto->key_phase;
+	u32 keylen, ivlen = QUIC_IV_LEN;
+
+	keylen = crypto->cipher->keylen;
+	quic_data(&srt, crypto->tx_secret, crypto->cipher->secretlen);
+	quic_data(&k, tx_key, keylen);
+	quic_data(&iv, crypto->tx_iv[phase], ivlen);
+	/* Only derive header protection key when not in key update. */
+	if (!crypto->key_pending)
+		hp = quic_data(&hp_k, tx_hp_key, keylen);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv, hp, crypto->version);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(crypto->tx_tfm[phase], QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(crypto->tx_tfm[phase], tx_key, keylen);
+	if (err)
+		goto out;
+	if (hp) {
+		err = crypto_skcipher_setkey(crypto->tx_hp_tfm, tx_hp_key, keylen);
+		if (err)
+			goto out;
+	}
+	pr_debug("%s: k: %16phN, iv: %12phN, hp_k:%16phN\n", __func__, k.data, iv.data, hp_k.data);
+out:
+	memzero_explicit(tx_key, sizeof(tx_key));
+	memzero_explicit(tx_hp_key, sizeof(tx_hp_key));
+	return err;
+}
+
+/* Derive and install reception (RX) packet protection keys for the current key phase.
+ * This installs AEAD decryption key, IV, and optionally header protection key.
+ */
+static int quic_crypto_rx_keys_derive_and_install(struct quic_crypto *crypto)
+{
+	struct quic_data srt = {}, k, iv, hp_k = {}, *hp = NULL;
+	u8 rx_key[QUIC_KEY_LEN], rx_hp_key[QUIC_KEY_LEN];
+	int err, phase = crypto->key_phase;
+	u32 keylen, ivlen = QUIC_IV_LEN;
+
+	keylen = crypto->cipher->keylen;
+	quic_data(&srt, crypto->rx_secret, crypto->cipher->secretlen);
+	quic_data(&k, rx_key, keylen);
+	quic_data(&iv, crypto->rx_iv[phase], ivlen);
+	/* Only derive header protection key when not in key update. */
+	if (!crypto->key_pending)
+		hp = quic_data(&hp_k, rx_hp_key, keylen);
+	err = quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv, hp, crypto->version);
+	if (err)
+		goto out;
+	err = crypto_aead_setauthsize(crypto->rx_tfm[phase], QUIC_TAG_LEN);
+	if (err)
+		goto out;
+	err = crypto_aead_setkey(crypto->rx_tfm[phase], rx_key, keylen);
+	if (err)
+		goto out;
+	if (hp) {
+		err = crypto_skcipher_setkey(crypto->rx_hp_tfm, rx_hp_key, keylen);
+		if (err)
+			goto out;
+	}
+	pr_debug("%s: k: %16phN, iv: %12phN, hp_k:%16phN\n", __func__, k.data, iv.data, hp_k.data);
+out:
+	memzero_explicit(rx_key, sizeof(rx_key));
+	memzero_explicit(rx_hp_key, sizeof(rx_hp_key));
+	return err;
+}
+
+#define QUIC_CIPHER_MIN TLS_CIPHER_AES_GCM_128
+#define QUIC_CIPHER_MAX TLS_CIPHER_CHACHA20_POLY1305
+
+#define TLS_CIPHER_AES_GCM_128_SECRET_SIZE		32
+#define TLS_CIPHER_AES_GCM_256_SECRET_SIZE		48
+#define TLS_CIPHER_AES_CCM_128_SECRET_SIZE		32
+#define TLS_CIPHER_CHACHA20_POLY1305_SECRET_SIZE	32
+
+#define CIPHER_DESC(type, aead_name, skc_name, sha_name)[type - QUIC_CIPHER_MIN] = { \
+	.secretlen = type ## _SECRET_SIZE, \
+	.keylen = type ## _KEY_SIZE, \
+	.aead = aead_name, \
+	.skc = skc_name, \
+	.shash = sha_name, \
+}
+
+static struct quic_cipher ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_128, "gcm(aes)", "ecb(aes)", "hmac(sha256)"),
+	CIPHER_DESC(TLS_CIPHER_AES_GCM_256, "gcm(aes)", "ecb(aes)", "hmac(sha384)"),
+	CIPHER_DESC(TLS_CIPHER_AES_CCM_128, "ccm(aes)", "ecb(aes)", "hmac(sha256)"),
+	CIPHER_DESC(TLS_CIPHER_CHACHA20_POLY1305,
+		    "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha256)"),
+};
+
+int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type, u8 flag)
+{
+	struct quic_cipher *cipher;
+	int err = -EINVAL;
+	void *tfm;
+
+	if (type < QUIC_CIPHER_MIN || type > QUIC_CIPHER_MAX)
+		return -EINVAL;
+
+	cipher = &ciphers[type - QUIC_CIPHER_MIN];
+	tfm = crypto_alloc_shash(cipher->shash, 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	crypto->secret_tfm = tfm;
+
+	/* Request only synchronous crypto by specifying CRYPTO_ALG_ASYNC.  This
+	 * ensures tag generation does not rely on async callbacks.
+	 */
+	tfm = crypto_alloc_aead(cipher->aead, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tag_tfm = tfm;
+
+	/* Allocate AEAD and HP transform for each RX key phase. */
+	tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->rx_tfm[0] = tfm;
+	tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->rx_tfm[1] = tfm;
+	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->rx_hp_tfm = tfm;
+
+	/* Allocate AEAD and HP transform for each TX key phase. */
+	tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_tfm[0] = tfm;
+	tfm = crypto_alloc_aead(cipher->aead, 0, flag);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_tfm[1] = tfm;
+	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
+	if (IS_ERR(tfm)) {
+		err = PTR_ERR(tfm);
+		goto err;
+	}
+	crypto->tx_hp_tfm = tfm;
+
+	crypto->cipher = cipher;
+	crypto->cipher_type = type;
+	return 0;
+err:
+	quic_crypto_free(crypto);
+	return err;
+}
+
+int quic_crypto_set_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt,
+			   u32 version, u8 flag)
+{
+	struct quic_cipher *cipher;
+	int err;
+
+	/* If no cipher has been initialized yet, set it up. */
+	if (!crypto->cipher) {
+		err = quic_crypto_set_cipher(crypto, srt->type, flag);
+		if (err)
+			return err;
+	}
+	cipher = crypto->cipher;
+
+	/* Handle RX path setup. */
+	if (!srt->send) {
+		crypto->version = version;
+		memcpy(crypto->rx_secret, srt->secret, cipher->secretlen);
+		err = quic_crypto_rx_keys_derive_and_install(crypto);
+		if (err)
+			return err;
+		crypto->recv_ready = 1;
+		return 0;
+	}
+
+	/* Handle TX path setup. */
+	crypto->version = version;
+	memcpy(crypto->tx_secret, srt->secret, cipher->secretlen);
+	err = quic_crypto_tx_keys_derive_and_install(crypto);
+	if (err)
+		return err;
+	crypto->send_ready = 1;
+	return 0;
+}
+
+int quic_crypto_get_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt)
+{
+	u8 *secret;
+
+	if (!crypto->cipher)
+		return -EINVAL;
+	srt->type = crypto->cipher_type;
+	secret = srt->send ? crypto->tx_secret : crypto->rx_secret;
+	memcpy(srt->secret, secret, crypto->cipher->secretlen);
+	return 0;
+}
+
+/* Initiating a Key Update. */
+int quic_crypto_key_update(struct quic_crypto *crypto)
+{
+	u8 tx_secret[QUIC_SECRET_LEN], rx_secret[QUIC_SECRET_LEN];
+	struct quic_data l = {KU_LABEL_V1, strlen(KU_LABEL_V1)};
+	struct quic_data z = {}, k, srt;
+	u32 secret_len;
+	int err;
+
+	if (crypto->key_pending || !crypto->recv_ready)
+		return -EINVAL;
+
+	/* rfc9001#section-6.1:
+	 *
+	 * Endpoints maintain separate read and write secrets for packet protection. An
+	 * endpoint initiates a key update by updating its packet protection write secret
+	 * and using that to protect new packets. The endpoint creates a new write secret
+	 * from the existing write secret. This uses the KDF function provided by TLS with
+	 * a label of "quic ku". The corresponding key and IV are created from that
+	 * secret. The header protection key is not updated.
+	 *
+	 * For example,to update write keys with TLS 1.3, HKDF-Expand-Label is used as:
+	 *   secret_<n+1> = HKDF-Expand-Label(secret_<n>, "quic ku",
+	 *                                    "", Hash.length)
+	 */
+	secret_len = crypto->cipher->secretlen;
+	if (crypto->version == QUIC_VERSION_V2)
+		quic_data(&l, KU_LABEL_V2, strlen(KU_LABEL_V2));
+
+	crypto->key_pending = 1;
+	memcpy(tx_secret, crypto->tx_secret, secret_len);
+	memcpy(rx_secret, crypto->rx_secret, secret_len);
+	crypto->key_phase = !crypto->key_phase;
+
+	quic_data(&srt, tx_secret, secret_len);
+	quic_data(&k, crypto->tx_secret, secret_len);
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &srt, &l, &z, &k);
+	if (err)
+		goto err;
+	err = quic_crypto_tx_keys_derive_and_install(crypto);
+	if (err)
+		goto err;
+
+	quic_data(&srt, rx_secret, secret_len);
+	quic_data(&k, crypto->rx_secret, secret_len);
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &srt, &l, &z, &k);
+	if (err)
+		goto err;
+	err = quic_crypto_rx_keys_derive_and_install(crypto);
+	if (err)
+		goto err;
+out:
+	memzero_explicit(tx_secret, sizeof(tx_secret));
+	memzero_explicit(rx_secret, sizeof(rx_secret));
+	return err;
+err:
+	crypto->key_pending = 0;
+	memcpy(crypto->tx_secret, tx_secret, secret_len);
+	memcpy(crypto->rx_secret, rx_secret, secret_len);
+	crypto->key_phase = !crypto->key_phase;
+	goto out;
+}
+
+void quic_crypto_free(struct quic_crypto *crypto)
+{
+	if (crypto->tag_tfm)
+		crypto_free_aead(crypto->tag_tfm);
+	if (crypto->rx_tfm[0])
+		crypto_free_aead(crypto->rx_tfm[0]);
+	if (crypto->rx_tfm[1])
+		crypto_free_aead(crypto->rx_tfm[1]);
+	if (crypto->tx_tfm[0])
+		crypto_free_aead(crypto->tx_tfm[0]);
+	if (crypto->tx_tfm[1])
+		crypto_free_aead(crypto->tx_tfm[1]);
+	if (crypto->secret_tfm)
+		crypto_free_shash(crypto->secret_tfm);
+	if (crypto->rx_hp_tfm)
+		crypto_free_skcipher(crypto->rx_hp_tfm);
+	if (crypto->tx_hp_tfm)
+		crypto_free_skcipher(crypto->tx_hp_tfm);
+
+	memzero_explicit(crypto, offsetof(struct quic_crypto, send_offset));
+}
+
+#define QUIC_INITIAL_SALT_V1    \
+	"\x38\x76\x2c\xf7\xf5\x59\x34\xb3\x4d\x17\x9a\xe6\xa4\xc8\x0c\xad\xcc\xbb\x7f\x0a"
+#define QUIC_INITIAL_SALT_V2    \
+	"\x0d\xed\xe3\xde\xf7\x00\xa6\xdb\x81\x93\x81\xbe\x6e\x26\x9d\xcb\xf9\xbd\x2e\xd9"
+
+#define QUIC_INITIAL_SALT_LEN	20
+
+/* Initial Secrets. */
+int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_conn_id *conn_id,
+				     u32 version, bool is_serv)
+{
+	u8 secret[TLS_CIPHER_AES_GCM_128_SECRET_SIZE];
+	struct quic_data salt, s, k, l, dcid, z = {};
+	struct quic_crypto_secret srt = {};
+	char *tl, *rl, *sal;
+	int err;
+
+	/* rfc9001#section-5.2:
+	 *
+	 * The secret used by clients to construct Initial packets uses the PRK and the
+	 * label "client in" as input to the HKDF-Expand-Label function from TLS [TLS13]
+	 * to produce a 32-byte secret. Packets constructed by the server use the same
+	 * process with the label "server in". The hash function for HKDF when deriving
+	 * initial secrets and keys is SHA-256 [SHA].
+	 *
+	 * This process in pseudocode is:
+	 *
+	 *   initial_salt = 0x38762cf7f55934b34d179ae6a4c80cadccbb7f0a
+	 *   initial_secret = HKDF-Extract(initial_salt,
+	 *                                 client_dst_connection_id)
+	 *
+	 *   client_initial_secret = HKDF-Expand-Label(initial_secret,
+	 *                                             "client in", "",
+	 *                                             Hash.length)
+	 *   server_initial_secret = HKDF-Expand-Label(initial_secret,
+	 *                                             "server in", "",
+	 *                                             Hash.length)
+	 */
+	if (is_serv) {
+		rl = "client in";
+		tl = "server in";
+	} else {
+		tl = "client in";
+		rl = "server in";
+	}
+	sal = QUIC_INITIAL_SALT_V1;
+	if (version == QUIC_VERSION_V2)
+		sal = QUIC_INITIAL_SALT_V2;
+	quic_data(&salt, sal, QUIC_INITIAL_SALT_LEN);
+	quic_data(&dcid, conn_id->data, conn_id->len);
+	quic_data(&s, secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	err = quic_crypto_hkdf_extract(crypto->secret_tfm, &salt, &dcid, &s);
+	if (err)
+		goto out;
+
+	quic_data(&l, tl, strlen(tl));
+	quic_data(&k, srt.secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	srt.send = 1;
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &s, &l, &z, &k);
+	if (err)
+		goto out;
+	err = quic_crypto_set_secret(crypto, &srt, version, 0);
+	if (err)
+		goto out;
+
+	quic_data(&l, rl, strlen(rl));
+	quic_data(&k, srt.secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	srt.type = TLS_CIPHER_AES_GCM_128;
+	srt.send = 0;
+	err = quic_crypto_hkdf_expand(crypto->secret_tfm, &s, &l, &z, &k);
+	if (err)
+		goto out;
+	err = quic_crypto_set_secret(crypto, &srt, version, 0);
+out:
+	memzero_explicit(secret, sizeof(secret));
+	memzero_explicit(&srt, sizeof(srt));
+	return err;
+}
+
+/* Generate a derived key using HKDF-Extract and HKDF-Expand with a given label. */
+static int quic_crypto_generate_key(struct quic_crypto *crypto, void *data, u32 len,
+				    char *label, u8 *token, u32 key_len)
+{
+	struct crypto_shash *tfm = crypto->secret_tfm;
+	u8 secret[TLS_CIPHER_AES_GCM_128_SECRET_SIZE];
+	struct quic_data salt, s, l, k, z = {};
+	int err;
+
+	quic_data(&salt, data, len);
+	quic_data(&k, quic_random_data, QUIC_RANDOM_DATA_LEN);
+	quic_data(&s, secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
+	err = quic_crypto_hkdf_extract(tfm, &salt, &k, &s);
+	if (err)
+		goto out;
+
+	quic_data(&l, label, strlen(label));
+	quic_data(&k, token, key_len);
+	err = quic_crypto_hkdf_expand(tfm, &s, &l, &z, &k);
+out:
+	memzero_explicit(secret, sizeof(secret));
+	return err;
+}
+
+/* Derive a stateless reset token from connection-specific input. */
+int quic_crypto_generate_stateless_reset_token(struct quic_crypto *crypto, void *data,
+					       u32 len, u8 *key, u32 key_len)
+{
+	return quic_crypto_generate_key(crypto, data, len, "stateless_reset", key, key_len);
+}
+
+/* Derive a session ticket key using HKDF from connection-specific input. */
+int quic_crypto_generate_session_ticket_key(struct quic_crypto *crypto, void *data,
+					    u32 len, u8 *key, u32 key_len)
+{
+	return quic_crypto_generate_key(crypto, data, len, "session_ticket", key, key_len);
+}
+
+void quic_crypto_init(void)
+{
+	get_random_bytes(quic_random_data, QUIC_RANDOM_DATA_LEN);
+}
diff --git a/net/quic/crypto.h b/net/quic/crypto.h
new file mode 100644
index 000000000000..fc562035271c
--- /dev/null
+++ b/net/quic/crypto.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* QUIC kernel implementation
+ * (C) Copyright Red Hat Corp. 2023
+ *
+ * This file is part of the QUIC kernel implementation
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#define QUIC_TAG_LEN	16
+#define QUIC_IV_LEN	12
+#define QUIC_KEY_LEN	32
+#define QUIC_SECRET_LEN	48
+
+#define QUIC_TOKEN_FLAG_REGULAR		0
+#define QUIC_TOKEN_FLAG_RETRY		1
+#define QUIC_TOKEN_TIMEOUT_RETRY	3000000
+#define QUIC_TOKEN_TIMEOUT_REGULAR	600000000
+
+struct quic_cipher {
+	u32 secretlen;			/* Length of the traffic secret */
+	u32 keylen;			/* Length of the AEAD key */
+
+	char *shash;			/* Name of hash algorithm used for key derivation */
+	char *aead;			/* Name of AEAD algorithm used for payload en/decryption */
+	char *skc;			/* Name of cipher algorithm used for header protection */
+};
+
+struct quic_crypto {
+	struct crypto_skcipher *tx_hp_tfm;	/* Transform for TX header protection */
+	struct crypto_skcipher *rx_hp_tfm;	/* Transform for RX header protection */
+	struct crypto_shash *secret_tfm;	/* Transform for key derivation (HKDF) */
+	struct crypto_aead *tx_tfm[2];		/* AEAD transform for TX (key phase 0 and 1) */
+	struct crypto_aead *rx_tfm[2];		/* AEAD transform for RX (key phase 0 and 1) */
+	struct crypto_aead *tag_tfm;		/* AEAD transform used for Retry token validation */
+	struct quic_cipher *cipher;		/* Cipher information (selected cipher suite) */
+	u32 cipher_type;			/* Cipher suite (e.g., AES_GCM_128, etc.) */
+
+	u8 tx_secret[QUIC_SECRET_LEN];		/* TX secret derived or provided by user space */
+	u8 rx_secret[QUIC_SECRET_LEN];		/* RX secret derived or provided by user space */
+	u8 tx_iv[2][QUIC_IV_LEN];		/* IVs for TX (key phase 0 and 1) */
+	u8 rx_iv[2][QUIC_IV_LEN];		/* IVs for RX (key phase 0 and 1) */
+
+	u64 key_update_send_time;	/* Timestamp when 1st packet is sent after key update */
+	u64 key_update_time;		/* Timestamp until old keys are retained after key update */
+	u32 version;			/* QUIC version in use */
+
+	u8 ticket_ready:1;		/* True if a session ticket is ready to read */
+	u8 key_pending:1;		/* A key update is in progress */
+	u8 send_ready:1;		/* TX encryption context is initialized */
+	u8 recv_ready:1;		/* RX decryption context is initialized */
+	u8 key_phase:1;			/* Current key phase being used (0 or 1) */
+
+	u64 send_offset;	/* Number of handshake bytes sent by user at this level */
+	u64 recv_offset;	/* Number of handshake bytes read by user at this level */
+};
+
+int quic_crypto_set_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt,
+			   u32 version, u8 flag);
+int quic_crypto_get_secret(struct quic_crypto *crypto, struct quic_crypto_secret *srt);
+int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type, u8 flag);
+int quic_crypto_key_update(struct quic_crypto *crypto);
+
+int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struct quic_conn_id *conn_id,
+				     u32 version, bool is_serv);
+int quic_crypto_generate_session_ticket_key(struct quic_crypto *crypto, void *data,
+					    u32 len, u8 *key, u32 key_len);
+int quic_crypto_generate_stateless_reset_token(struct quic_crypto *crypto, void *data,
+					       u32 len, u8 *key, u32 key_len);
+
+void quic_crypto_free(struct quic_crypto *crypto);
+void quic_crypto_init(void);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 8cb85ee8e0be..8c357eaa1c9b 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -266,9 +266,17 @@ static int __net_init quic_net_init(struct net *net)
 	if (!qn->stat)
 		return -ENOMEM;
 
+	err = quic_crypto_set_cipher(&qn->crypto, TLS_CIPHER_AES_GCM_128, CRYPTO_ALG_ASYNC);
+	if (err) {
+		free_percpu(qn->stat);
+		qn->stat = NULL;
+		return err;
+	}
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	err = quic_net_proc_init(net);
 	if (err) {
+		quic_crypto_free(&qn->crypto);
 		free_percpu(qn->stat);
 		qn->stat = NULL;
 	}
@@ -283,6 +291,7 @@ static void __net_exit quic_net_exit(struct net *net)
 #if IS_ENABLED(CONFIG_PROC_FS)
 	quic_net_proc_exit(net);
 #endif
+	quic_crypto_free(&qn->crypto);
 	free_percpu(qn->stat);
 	qn->stat = NULL;
 }
@@ -331,6 +340,8 @@ static __init int quic_init(void)
 	sysctl_quic_wmem[1] = 16 * 1024;
 	sysctl_quic_wmem[2] = max(64 * 1024, max_share);
 
+	quic_crypto_init();
+
 	err = percpu_counter_init(&quic_sockets_allocated, 0, GFP_KERNEL);
 	if (err)
 		goto err_percpu_counter;
diff --git a/net/quic/protocol.h b/net/quic/protocol.h
index 042313c084da..6a31ccd4699e 100644
--- a/net/quic/protocol.h
+++ b/net/quic/protocol.h
@@ -48,6 +48,7 @@ struct quic_net {
 #if IS_ENABLED(CONFIG_PROC_FS)
 	struct proc_dir_entry *proc_net;	/* procfs entry for dumping QUIC socket stats */
 #endif
+	struct quic_crypto crypto;	/* Context for decrypting Initial packets for ALPN */
 };
 
 struct quic_net *quic_net(struct net *net);
diff --git a/net/quic/socket.c b/net/quic/socket.c
index a52484d78646..7fd6955824bc 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -70,6 +70,8 @@ static void quic_destroy_sock(struct sock *sk)
 
 	for (i = 0; i < QUIC_PNSPACE_MAX; i++)
 		quic_pnspace_free(quic_pnspace(sk, i));
+	for (i = 0; i < QUIC_CRYPTO_MAX; i++)
+		quic_crypto_free(quic_crypto(sk, i));
 
 	quic_path_unbind(sk, quic_paths(sk), 0);
 	quic_path_unbind(sk, quic_paths(sk), 1);
diff --git a/net/quic/socket.h b/net/quic/socket.h
index d8a264a1eddc..fc203eecbb8b 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -16,6 +16,7 @@
 #include "family.h"
 #include "stream.h"
 #include "connid.h"
+#include "crypto.h"
 #include "path.h"
 #include "cong.h"
 
@@ -46,6 +47,7 @@ struct quic_sock {
 	struct quic_path_group		paths;
 	struct quic_cong		cong;
 	struct quic_pnspace		space[QUIC_PNSPACE_MAX];
+	struct quic_crypto		crypto[QUIC_CRYPTO_MAX];
 };
 
 struct quic6_sock {
@@ -118,6 +120,11 @@ static inline struct quic_pnspace *quic_pnspace(const struct sock *sk, u8 level)
 	return &quic_sk(sk)->space[level % QUIC_CRYPTO_EARLY];
 }
 
+static inline struct quic_crypto *quic_crypto(const struct sock *sk, u8 level)
+{
+	return &quic_sk(sk)->crypto[level];
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

