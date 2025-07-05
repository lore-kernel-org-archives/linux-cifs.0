Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C088721ABC9;
	Sat,  5 Jul 2025 19:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744333; cv=none; b=sIVnsirBVNQzN2T73bKdBW6/fGMqhvSs/k8RbET8uERUg+x3cE//C9nT+a4qKS2WtC/DG3Li/gW0NIsJAW8kahQMSJe1YPjFN3Co/U43QV4OAbUnmPdmLcAXlaal+HLOJIB9DqZm1R3AcRySXhH2rPGS38Xv6zOl2rxcwZqtg8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744333; c=relaxed/simple;
	bh=eb0njzs0Ctqy4bg3dmuY9De4OrZbHHzoQW3oseuP2UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTy7I9rYmMbIGlI0OEjpwP7hbO0GPWlsJ2vwWtLQcoQeVxOoqvFL9XgKv3wd5XW4kOiuo0bjv10jS6jU9MdAfo1vtyI2cM2i0UKz4+mNwPsA7AKHjO8w/WkwUITU3sYbUJHG6HpjNNs/33wpr9XoCY6UcPOpMUWXUvrqNB25AIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J33wN/9H; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J33wN/9H"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso19111096d6.3;
        Sat, 05 Jul 2025 12:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744329; x=1752349129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzJbWABQsJKpkqeVE1gCT4XWb/K+keQ7nQyFMBT+aBU=;
        b=J33wN/9HSxMvttHedklUNgmP+M42iEhMEjFbV51//doGU9GvJLx7nlpgoAa6SxI0+a
         7cH3vel0l5z/7iwn4/bp2lE4dT1Bh33hsBwMhtVGxSycuKpDnYW0sWWDkFBBsxx8fhJn
         OPdUHFcG9NDYQ4MJVe2c+/GT0hB+MgNJihcr2RIUUQJryk/NHYS3/WQDDuvZTMIKdVVm
         y9hyUmwWSAuHXwxpXQJ2b2pNE2MGRksvrDi5mWcu5mF5Sfx3cYyVLJHbpvf+UvTMyUn/
         cp17oKyseZGlrc+cXPoCHdMrViq4NYn9GI6r/nfy0hPwGgZCMfojTcgPioKM8Du/gdUH
         Bx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744329; x=1752349129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vzJbWABQsJKpkqeVE1gCT4XWb/K+keQ7nQyFMBT+aBU=;
        b=Vznlw3s+e018CRBn4gufqCFRkvYZvhV8x+Eyxg+2pW6nWftlsJsnr9bN2Si5nsbWMN
         hO2mq2v/iZanSiM4geRhcrtgd3Jv8cx9IuxEP9ABVcqoz6vm0TGdkpimPlas7EEBVj5v
         pbR8MbG1/pzDPB/f+dyui6q8bc+cttrliWHxhiBnpslJO4SN+gwtzfriKyCmSrP0TggS
         qnYfVEC2JR3HkKVhCgrHQFd+HIEGQsA+YMkgx1eiQ6ALbZs8F79gQVCJzQrRUSPGPzK0
         tL3VXmehIUc7r6DLGHjTEJYBAcDMhmkWRIG4T5gsbGWZZM8hnMtwt1CBmcmHE1DHnM5c
         QVIQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2bAgZIfG7eoYuBdVHPzNzeCafWkLuSdziOGxlL70x57GAZHQ/vHG12cNTI8Wjc8Zdsrhshr1ro67V@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcw+JcOkzpt85D5XXoNoXuuwqQFgU2Hfth1xaJeSskcVdCu683
	5ei1myARzS9h5xIL7wrnZYNujLFQkUqfTgmrugBQTOiolygmWiP2A8DwlgizXd5fecM=
X-Gm-Gg: ASbGnctqJ8G0WzZe1xR3k/PGjV2Sw74EvU6DlqZs4+3ppoYjNQSLGDM3lGQd+wVPzua
	35IeVNQxWG+OksSlNuqcvZrRR7M2/AaqgwAkVF/Xva02rFQlxvuOV3Rfd/T6zn8UdB4T93iJDLe
	DgIIGCTUFf1VXg3l3pkxm8JTJD7phNPCIS+jj1N133vYqJiKx6AUNZkRtjC0TRIOGQigCpfs1Lt
	S01mEf5uZxIqi4PZA2terlrnxIUPE/wHogmoMyrHDqOIFDcaN410IVYGSqMV6x0W6QmRzWNNnYg
	r87wmKbi0/kF95AhpzkmXUsR/FhHMQpLEgqppt2vKEJuoCEzkKMEzQOsU1G5JnUmRVG/nlIsiy8
	bZf2bukK5slPD3Er2B/4g5LfHBO7GxIN3PpO6uQ==
X-Google-Smtp-Source: AGHT+IHRM+PAmSBypdWiMAgSok2KhM50v3DRq+b+nqgsTyUyt20yazWTukNgqP8ZaYzOYapkd6xlpA==
X-Received: by 2002:a05:6214:419e:b0:702:bf75:f0bc with SMTP id 6a1803df08f44-702d16b4f13mr57393766d6.37.1751744329220;
        Sat, 05 Jul 2025 12:38:49 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:48 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
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
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 03/15] quic: provide common utilities and data structures
Date: Sat,  5 Jul 2025 15:31:42 -0400
Message-ID: <1ed6bb92a433be82ab586d783b2e8374d2b4c9ab.1751743914.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1751743914.git.lucien.xin@gmail.com>
References: <cover.1751743914.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch provides foundational data structures and utilities used
throughout the QUIC stack.

It introduces packet header types, connection ID support, and address
handling. Hash tables are added to manage socket lookup and connection
ID mapping.

A flexible binary data type is provided, along with helpers for parsing,
matching, and memory management. Helpers for encoding and decoding
transport parameters and frames are also included.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/quic/Makefile   |   2 +-
 net/quic/common.c   | 482 ++++++++++++++++++++++++++++++++++++++++++++
 net/quic/common.h   | 219 ++++++++++++++++++++
 net/quic/protocol.c |   6 +
 net/quic/socket.c   |   4 +
 net/quic/socket.h   |  21 ++
 6 files changed, 733 insertions(+), 1 deletion(-)
 create mode 100644 net/quic/common.c
 create mode 100644 net/quic/common.h

diff --git a/net/quic/Makefile b/net/quic/Makefile
index 020e4dd133d8..e0067272de7d 100644
--- a/net/quic/Makefile
+++ b/net/quic/Makefile
@@ -5,4 +5,4 @@
 
 obj-$(CONFIG_IP_QUIC) += quic.o
 
-quic-y := protocol.o socket.o
+quic-y := common.o protocol.o socket.o
diff --git a/net/quic/common.c b/net/quic/common.c
new file mode 100644
index 000000000000..5a7a8257565a
--- /dev/null
+++ b/net/quic/common.c
@@ -0,0 +1,482 @@
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
+#include "common.h"
+
+#define QUIC_VARINT_1BYTE_MAX		0x3fULL
+#define QUIC_VARINT_2BYTE_MAX		0x3fffULL
+#define QUIC_VARINT_4BYTE_MAX		0x3fffffffULL
+
+#define QUIC_VARINT_2BYTE_PREFIX	0x40
+#define QUIC_VARINT_4BYTE_PREFIX	0x80
+#define QUIC_VARINT_8BYTE_PREFIX	0xc0
+
+#define QUIC_VARINT_LENGTH(p)		BIT((*(p)) >> 6)
+#define QUIC_VARINT_VALUE_MASK		0x3f
+
+static struct quic_hash_table quic_hash_tables[QUIC_HT_MAX_TABLES];
+
+struct quic_hash_head *quic_sock_hash(u32 hash)
+{
+	return &quic_hash_tables[QUIC_HT_SOCK].hash[hash];
+}
+
+struct quic_hash_head *quic_sock_head(struct net *net, union quic_addr *s, union quic_addr *d)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_SOCK];
+
+	return &ht->hash[quic_ahash(net, s, d) & (ht->size - 1)];
+}
+
+struct quic_hash_head *quic_listen_sock_head(struct net *net, u16 port)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_LISTEN_SOCK];
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+struct quic_hash_head *quic_source_conn_id_head(struct net *net, u8 *scid)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_CONNECTION_ID];
+
+	return &ht->hash[jhash(scid, 4, 0) & (ht->size - 1)];
+}
+
+struct quic_hash_head *quic_udp_sock_head(struct net *net, u16 port)
+{
+	struct quic_hash_table *ht = &quic_hash_tables[QUIC_HT_UDP_SOCK];
+
+	return &ht->hash[port & (ht->size - 1)];
+}
+
+struct quic_hash_head *quic_stream_head(struct quic_hash_table *ht, s64 stream_id)
+{
+	return &ht->hash[stream_id & (ht->size - 1)];
+}
+
+void quic_hash_tables_destroy(void)
+{
+	struct quic_hash_table *ht;
+	int table;
+
+	for (table = 0; table < QUIC_HT_MAX_TABLES; table++) {
+		ht = &quic_hash_tables[table];
+		ht->size = QUIC_HT_SIZE;
+		kfree(ht->hash);
+	}
+}
+
+int quic_hash_tables_init(void)
+{
+	struct quic_hash_head *head;
+	struct quic_hash_table *ht;
+	int table, i;
+
+	for (table = 0; table < QUIC_HT_MAX_TABLES; table++) {
+		ht = &quic_hash_tables[table];
+		ht->size = QUIC_HT_SIZE;
+		head = kmalloc_array(ht->size, sizeof(*head), GFP_KERNEL);
+		if (!head) {
+			quic_hash_tables_destroy();
+			return -ENOMEM;
+		}
+		for (i = 0; i < ht->size; i++) {
+			INIT_HLIST_HEAD(&head[i].head);
+			if (table == QUIC_HT_UDP_SOCK) {
+				mutex_init(&head[i].m_lock);
+				continue;
+			}
+			spin_lock_init(&head[i].s_lock);
+		}
+		ht->hash = head;
+	}
+
+	return 0;
+}
+
+union quic_var {
+	u8	u8;
+	__be16	be16;
+	__be32	be32;
+	__be64	be64;
+};
+
+/* Returns the number of bytes required to encode a QUIC variable-length integer. */
+u8 quic_var_len(u64 n)
+{
+	if (n <= QUIC_VARINT_1BYTE_MAX)
+		return 1;
+	if (n <= QUIC_VARINT_2BYTE_MAX)
+		return 2;
+	if (n <= QUIC_VARINT_4BYTE_MAX)
+		return 4;
+	return 8;
+}
+
+/* Decodes a QUIC variable-length integer from a buffer. */
+u8 quic_get_var(u8 **pp, u32 *plen, u64 *val)
+{
+	union quic_var n = {};
+	u8 *p = *pp, len;
+	u64 v = 0;
+
+	if (!*plen)
+		return 0;
+
+	len = QUIC_VARINT_LENGTH(p);
+	if (*plen < len)
+		return 0;
+
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		memcpy(&n.be16, p, 2);
+		n.u8 &= QUIC_VARINT_VALUE_MASK;
+		v = be16_to_cpu(n.be16);
+		break;
+	case 4:
+		memcpy(&n.be32, p, 4);
+		n.u8 &= QUIC_VARINT_VALUE_MASK;
+		v = be32_to_cpu(n.be32);
+		break;
+	case 8:
+		memcpy(&n.be64, p, 8);
+		n.u8 &= QUIC_VARINT_VALUE_MASK;
+		v = be64_to_cpu(n.be64);
+		break;
+	default:
+		return 0;
+	}
+
+	*plen -= len;
+	*pp = p + len;
+	*val = v;
+	return len;
+}
+
+/* Reads a fixed-length integer from the buffer. */
+u32 quic_get_int(u8 **pp, u32 *plen, u64 *val, u32 len)
+{
+	union quic_var n;
+	u8 *p = *pp;
+	u64 v = 0;
+
+	if (*plen < len)
+		return 0;
+	*plen -= len;
+
+	switch (len) {
+	case 1:
+		v = *p;
+		break;
+	case 2:
+		memcpy(&n.be16, p, 2);
+		v = be16_to_cpu(n.be16);
+		break;
+	case 3:
+		n.be32 = 0;
+		memcpy(((u8 *)&n.be32) + 1, p, 3);
+		v = be32_to_cpu(n.be32);
+		break;
+	case 4:
+		memcpy(&n.be32, p, 4);
+		v = be32_to_cpu(n.be32);
+		break;
+	case 8:
+		memcpy(&n.be64, p, 8);
+		v = be64_to_cpu(n.be64);
+		break;
+	default:
+		return 0;
+	}
+	*pp = p + len;
+	*val = v;
+	return len;
+}
+
+u32 quic_get_data(u8 **pp, u32 *plen, u8 *data, u32 len)
+{
+	if (*plen < len)
+		return 0;
+
+	memcpy(data, *pp, len);
+	*pp += len;
+	*plen -= len;
+
+	return len;
+}
+
+/* Encodes a value into the QUIC variable-length integer format. */
+u8 *quic_put_var(u8 *p, u64 num)
+{
+	union quic_var n;
+
+	if (num <= QUIC_VARINT_1BYTE_MAX) {
+		*p++ = (u8)(num & 0xff);
+		return p;
+	}
+	if (num <= QUIC_VARINT_2BYTE_MAX) {
+		n.be16 = cpu_to_be16((u16)num);
+		*((__be16 *)p) = n.be16;
+		*p |= QUIC_VARINT_2BYTE_PREFIX;
+		return p + 2;
+	}
+	if (num <= QUIC_VARINT_4BYTE_MAX) {
+		n.be32 = cpu_to_be32((u32)num);
+		*((__be32 *)p) = n.be32;
+		*p |= QUIC_VARINT_4BYTE_PREFIX;
+		return p + 4;
+	}
+	n.be64 = cpu_to_be64(num);
+	*((__be64 *)p) = n.be64;
+	*p |= QUIC_VARINT_8BYTE_PREFIX;
+	return p + 8;
+}
+
+/* Writes a fixed-length integer to the buffer in network byte order. */
+u8 *quic_put_int(u8 *p, u64 num, u8 len)
+{
+	union quic_var n;
+
+	switch (len) {
+	case 1:
+		*p++ = (u8)(num & 0xff);
+		return p;
+	case 2:
+		n.be16 = cpu_to_be16((u16)(num & 0xffff));
+		*((__be16 *)p) = n.be16;
+		return p + 2;
+	case 4:
+		n.be32 = cpu_to_be32((u32)num);
+		*((__be32 *)p) = n.be32;
+		return p + 4;
+	default:
+		return NULL;
+	}
+}
+
+/* Encodes a value as a variable-length integer with explicit length. */
+u8 *quic_put_varint(u8 *p, u64 num, u8 len)
+{
+	union quic_var n;
+
+	switch (len) {
+	case 1:
+		*p++ = (u8)(num & 0xff);
+		return p;
+	case 2:
+		n.be16 = cpu_to_be16((u16)(num & 0xffff));
+		*((__be16 *)p) = n.be16;
+		*p |= QUIC_VARINT_2BYTE_PREFIX;
+		return p + 2;
+	case 4:
+		n.be32 = cpu_to_be32((u32)num);
+		*((__be32 *)p) = n.be32;
+		*p |= QUIC_VARINT_4BYTE_PREFIX;
+		return p + 4;
+	default:
+		return NULL;
+	}
+}
+
+u8 *quic_put_data(u8 *p, u8 *data, u32 len)
+{
+	if (!len)
+		return p;
+
+	memcpy(p, data, len);
+	return p + len;
+}
+
+/* Writes a transport parameter as two varints: ID and value length, followed by value. */
+u8 *quic_put_param(u8 *p, u16 id, u64 value)
+{
+	p = quic_put_var(p, id);
+	p = quic_put_var(p, quic_var_len(value));
+	return quic_put_var(p, value);
+}
+
+/* Reads a QUIC transport parameter value. */
+u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen)
+{
+	u64 valuelen;
+
+	if (!quic_get_var(pp, plen, &valuelen))
+		return 0;
+
+	if (*plen < valuelen)
+		return 0;
+
+	if (!quic_get_var(pp, plen, pdest))
+		return 0;
+
+	return (u8)valuelen;
+}
+
+/* rfc9000#section-a.3: DecodePacketNumber()
+ *
+ * Reconstructs the full packet number from a truncated one.
+ */
+s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n)
+{
+	s64 expected = max_pkt_num + 1;
+	s64 win = BIT_ULL(n * 8);
+	s64 hwin = win / 2;
+	s64 mask = win - 1;
+	s64 cand;
+
+	cand = (expected & ~mask) | pkt_num;
+	if (cand <= expected - hwin && cand < (1ULL << 62) - win)
+		return cand + win;
+	if (cand > expected + hwin && cand >= win)
+		return cand - win;
+	return cand;
+}
+
+int quic_data_dup(struct quic_data *to, u8 *data, u32 len)
+{
+	if (!len)
+		return 0;
+
+	data = kmemdup(data, len, GFP_ATOMIC);
+	if (!data)
+		return -ENOMEM;
+
+	kfree(to->data);
+	to->data = data;
+	to->len = len;
+	return 0;
+}
+
+int quic_data_append(struct quic_data *to, u8 *data, u32 len)
+{
+	u8 *p;
+
+	if (!len)
+		return 0;
+
+	p = kzalloc(to->len + len, GFP_ATOMIC);
+	if (!p)
+		return -ENOMEM;
+	p = quic_put_data(p, to->data, to->len);
+	p = quic_put_data(p, data, len);
+
+	kfree(to->data);
+	to->len = to->len + len;
+	to->data = p - to->len;
+	return 0;
+}
+
+/* Check whether 'd2' is equal to any element inside the list 'd1'.
+ *
+ * 'd1' is assumed to be a sequence of length-prefixed elements. Each element
+ * is compared to 'd2' using 'quic_data_cmp()'.
+ *
+ * Returns 1 if a match is found, 0 otherwise.
+ */
+int quic_data_has(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		if (!quic_data_cmp(&d, d2))
+			return 1;
+	}
+	return 0;
+}
+
+/* Check if any element of 'd1' is present in the list 'd2'.
+ *
+ * Iterates through each element in 'd1', and uses 'quic_data_has()' to check
+ * for its presence in 'd2'.
+ *
+ * Returns 1 if any match is found, 0 otherwise.
+ */
+int quic_data_match(struct quic_data *d1, struct quic_data *d2)
+{
+	struct quic_data d;
+	u64 length;
+	u32 len;
+	u8 *p;
+
+	for (p = d1->data, len = d1->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		if (quic_data_has(d2, &d))
+			return 1;
+	}
+	return 0;
+}
+
+/* Serialize a list of 'quic_data' elements into a comma-separated string.
+ *
+ * Each element in 'from' is length-prefixed. This function copies their raw
+ * content into the output buffer 'to', inserting commas in between. The
+ * resulting string length is written to '*plen'.
+ */
+void quic_data_to_string(u8 *to, u32 *plen, struct quic_data *from)
+{
+	struct quic_data d;
+	u8 *data = to, *p;
+	u64 length;
+	u32 len;
+
+	for (p = from->data, len = from->len; len; len -= length, p += length) {
+		quic_get_int(&p, &len, &length, 1);
+		quic_data(&d, p, length);
+		data = quic_put_data(data, d.data, d.len);
+		if (len - length)
+			data = quic_put_int(data, ',', 1);
+	}
+	*plen = data - to;
+}
+
+/* Parse a comma-separated string into a 'quic_data' list format.
+ *
+ * Each comma-separated token is turned into a length-prefixed element. The
+ * first byte of each element stores the length (minus one). Elements are
+ * stored in 'to->data', and 'to->len' is updated.
+ */
+void quic_data_from_string(struct quic_data *to, u8 *from, u32 len)
+{
+	struct quic_data d;
+	u8 *p = to->data;
+
+	to->len = 0;
+	while (len) {
+		d.data = p++;
+		d.len  = 1;
+		while (len && *from == ' ') {
+			from++;
+			len--;
+		}
+		while (len) {
+			if (*from == ',') {
+				from++;
+				len--;
+				break;
+			}
+			*p++ = *from++;
+			len--;
+			d.len++;
+		}
+		*d.data = (u8)(d.len - 1);
+		to->len += d.len;
+	}
+}
diff --git a/net/quic/common.h b/net/quic/common.h
new file mode 100644
index 000000000000..07f8fbc41683
--- /dev/null
+++ b/net/quic/common.h
@@ -0,0 +1,219 @@
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
+#include <net/netns/hash.h>
+#include <linux/jhash.h>
+
+#define QUIC_HT_SIZE		64
+
+#define QUIC_MAX_ACK_DELAY	(16384 * 1000)
+#define QUIC_DEF_ACK_DELAY	25000
+
+#define QUIC_STREAM_BIT_FIN	0x01
+#define QUIC_STREAM_BIT_LEN	0x02
+#define QUIC_STREAM_BIT_OFF	0x04
+#define QUIC_STREAM_BIT_MASK	0x08
+
+#define QUIC_CONN_ID_MAX_LEN	20
+#define QUIC_CONN_ID_DEF_LEN	8
+
+struct quic_conn_id {
+	u8 data[QUIC_CONN_ID_MAX_LEN];
+	u8 len;
+};
+
+static inline void quic_conn_id_update(struct quic_conn_id *conn_id, u8 *data, u32 len)
+{
+	memcpy(conn_id->data, data, len);
+	conn_id->len = (u8)len;
+}
+
+struct quic_skb_cb {
+	/* Callback when encryption/decryption completes in async mode */
+	void (*crypto_done)(struct sk_buff *skb, int err);
+	union {
+		struct sk_buff *last;		/* Last packet in TX bundle */
+		s64 seqno;			/* Dest connection ID number on RX */
+	};
+	s64 number_max;		/* Largest packet number seen before parsing this one */
+	s64 number;		/* Parsed packet number */
+	u16 errcode;		/* Error code if encryption/decryption fails */
+	u16 length;		/* Payload length + packet number length */
+	u32 time;		/* Arrival time in UDP tunnel */
+
+	u16 number_offset;	/* Offset of packet number field */
+	u16 udph_offset;	/* Offset of UDP header */
+	u8 number_len;		/* Length of the packet number field */
+	u8 level;		/* Encryption level: Initial, Handshake, App, or Early */
+
+	u8 key_update:1;	/* Key update triggered by this packet */
+	u8 key_phase:1;		/* Key phase used (0 or 1) */
+	u8 resume:1;		/* Crypto already processed (encrypted or decrypted) */
+	u8 path:1;		/* Packet arrived from a new or migrating path */
+	u8 ecn:2;		/* ECN marking used on TX */
+};
+
+#define QUIC_SKB_CB(skb)	((struct quic_skb_cb *)&((skb)->cb[0]))
+
+static inline struct udphdr *quic_udphdr(const struct sk_buff *skb)
+{
+	return (struct udphdr *)(skb->head + QUIC_SKB_CB(skb)->udph_offset);
+}
+
+struct quichdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 pnl:2,
+	     key:1,
+	     reserved:2,
+	     spin:1,
+	     fixed:1,
+	     form:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 form:1,
+	     fixed:1,
+	     spin:1,
+	     reserved:2,
+	     key:1,
+	     pnl:2;
+#endif
+};
+
+static inline struct quichdr *quic_hdr(struct sk_buff *skb)
+{
+	return (struct quichdr *)skb_transport_header(skb);
+}
+
+struct quichshdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 pnl:2,
+	     reserved:2,
+	     type:2,
+	     fixed:1,
+	     form:1;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 form:1,
+	     fixed:1,
+	     type:2,
+	     reserved:2,
+	     pnl:2;
+#endif
+};
+
+static inline struct quichshdr *quic_hshdr(struct sk_buff *skb)
+{
+	return (struct quichshdr *)skb_transport_header(skb);
+}
+
+union quic_addr {
+	struct sockaddr_in6 v6;
+	struct sockaddr_in v4;
+	struct sockaddr sa;
+};
+
+static inline union quic_addr *quic_addr(const void *addr)
+{
+	return (union quic_addr *)addr;
+}
+
+struct quic_hash_head {
+	struct hlist_head	head;
+	union {
+		spinlock_t	s_lock;	/* Protects 'head' in atomic context */
+		struct mutex	m_lock;	/* Protects 'head' in process context */
+	};
+};
+
+struct quic_hash_table {
+	struct quic_hash_head *hash;
+	int size;
+};
+
+enum  {
+	QUIC_HT_SOCK,		/* Hash table for QUIC sockets */
+	QUIC_HT_UDP_SOCK,	/* Hash table for UDP tunnel sockets */
+	QUIC_HT_LISTEN_SOCK,	/* Hash table for QUIC listening sockets */
+	QUIC_HT_CONNECTION_ID,	/* Hash table for source connection IDs */
+	QUIC_HT_MAX_TABLES,
+};
+
+static inline u32 quic_shash(const struct net *net, const union quic_addr *a)
+{
+	u32 addr = (a->sa.sa_family == AF_INET6) ? jhash(&a->v6.sin6_addr, 16, 0)
+						 : (__force u32)a->v4.sin_addr.s_addr;
+
+	return  jhash_3words(addr, (__force u32)a->v4.sin_port, net_hash_mix(net), 0);
+}
+
+static inline u32 quic_ahash(const struct net *net, const union quic_addr *s,
+			     const union quic_addr *d)
+{
+	u32 ports = ((__force u32)s->v4.sin_port) << 16 | (__force u32)d->v4.sin_port;
+	u32 saddr = (s->sa.sa_family == AF_INET6) ? jhash(&s->v6.sin6_addr, 16, 0)
+						  : (__force u32)s->v4.sin_addr.s_addr;
+	u32 daddr = (d->sa.sa_family == AF_INET6) ? jhash(&d->v6.sin6_addr, 16, 0)
+						  : (__force u32)d->v4.sin_addr.s_addr;
+
+	return  jhash_3words(saddr, ports, net_hash_mix(net), daddr);
+}
+
+struct quic_data {
+	u8 *data;
+	u32 len;
+};
+
+static inline struct quic_data *quic_data(struct quic_data *d, u8 *data, u32 len)
+{
+	d->data = data;
+	d->len  = len;
+	return d;
+}
+
+static inline int quic_data_cmp(struct quic_data *d1, struct quic_data *d2)
+{
+	return d1->len != d2->len || memcmp(d1->data, d2->data, d1->len);
+}
+
+static inline void quic_data_free(struct quic_data *d)
+{
+	kfree(d->data);
+	d->data = NULL;
+	d->len = 0;
+}
+
+struct quic_hash_head *quic_sock_head(struct net *net, union quic_addr *s, union quic_addr *d);
+struct quic_hash_head *quic_listen_sock_head(struct net *net, u16 port);
+struct quic_hash_head *quic_stream_head(struct quic_hash_table *ht, s64 stream_id);
+struct quic_hash_head *quic_source_conn_id_head(struct net *net, u8 *scid);
+struct quic_hash_head *quic_udp_sock_head(struct net *net, u16 port);
+
+struct quic_hash_head *quic_sock_hash(u32 hash);
+void quic_hash_tables_destroy(void);
+int quic_hash_tables_init(void);
+
+u32 quic_get_data(u8 **pp, u32 *plen, u8 *data, u32 len);
+u32 quic_get_int(u8 **pp, u32 *plen, u64 *val, u32 len);
+s64 quic_get_num(s64 max_pkt_num, s64 pkt_num, u32 n);
+u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen);
+u8 quic_get_var(u8 **pp, u32 *plen, u64 *val);
+u8 quic_var_len(u64 n);
+
+u8 *quic_put_param(u8 *p, u16 id, u64 value);
+u8 *quic_put_data(u8 *p, u8 *data, u32 len);
+u8 *quic_put_varint(u8 *p, u64 num, u8 len);
+u8 *quic_put_int(u8 *p, u64 num, u8 len);
+u8 *quic_put_var(u8 *p, u64 num);
+
+void quic_data_from_string(struct quic_data *to, u8 *from, u32 len);
+void quic_data_to_string(u8 *to, u32 *plen, struct quic_data *from);
+
+int quic_data_match(struct quic_data *d1, struct quic_data *d2);
+int quic_data_append(struct quic_data *to, u8 *data, u32 len);
+int quic_data_has(struct quic_data *d1, struct quic_data *d2);
+int quic_data_dup(struct quic_data *to, u8 *data, u32 len);
diff --git a/net/quic/protocol.c b/net/quic/protocol.c
index 01a5fdfb5227..522c194d4577 100644
--- a/net/quic/protocol.c
+++ b/net/quic/protocol.c
@@ -327,6 +327,9 @@ static __init int quic_init(void)
 	if (err)
 		goto err_percpu_counter;
 
+	if (quic_hash_tables_init())
+		goto err_hash;
+
 	err = register_pernet_subsys(&quic_net_ops);
 	if (err)
 		goto err_def_ops;
@@ -344,6 +347,8 @@ static __init int quic_init(void)
 err_protosw:
 	unregister_pernet_subsys(&quic_net_ops);
 err_def_ops:
+	quic_hash_tables_destroy();
+err_hash:
 	percpu_counter_destroy(&quic_sockets_allocated);
 err_percpu_counter:
 	return err;
@@ -356,6 +361,7 @@ static __exit void quic_exit(void)
 #endif
 	quic_protosw_exit();
 	unregister_pernet_subsys(&quic_net_ops);
+	quic_hash_tables_destroy();
 	percpu_counter_destroy(&quic_sockets_allocated);
 	pr_info("quic: exit\n");
 }
diff --git a/net/quic/socket.c b/net/quic/socket.c
index 320a9a5a3c53..9cab01109db7 100644
--- a/net/quic/socket.c
+++ b/net/quic/socket.c
@@ -55,6 +55,10 @@ static int quic_init_sock(struct sock *sk)
 
 static void quic_destroy_sock(struct sock *sk)
 {
+	quic_data_free(quic_ticket(sk));
+	quic_data_free(quic_token(sk));
+	quic_data_free(quic_alpn(sk));
+
 	local_bh_disable();
 	sk_sockets_allocated_dec(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
diff --git a/net/quic/socket.h b/net/quic/socket.h
index b6d4e660cf59..b3dec073e5d6 100644
--- a/net/quic/socket.h
+++ b/net/quic/socket.h
@@ -13,6 +13,8 @@
 
 #include <net/udp_tunnel.h>
 
+#include "common.h"
+
 #include "protocol.h"
 
 extern struct proto quic_prot;
@@ -28,6 +30,10 @@ enum quic_state {
 struct quic_sock {
 	struct inet_sock		inet;
 	struct list_head		reqs;
+
+	struct quic_data		ticket;
+	struct quic_data		token;
+	struct quic_data		alpn;
 };
 
 struct quic6_sock {
@@ -45,6 +51,21 @@ static inline struct list_head *quic_reqs(const struct sock *sk)
 	return &quic_sk(sk)->reqs;
 }
 
+static inline struct quic_data *quic_token(const struct sock *sk)
+{
+	return &quic_sk(sk)->token;
+}
+
+static inline struct quic_data *quic_ticket(const struct sock *sk)
+{
+	return &quic_sk(sk)->ticket;
+}
+
+static inline struct quic_data *quic_alpn(const struct sock *sk)
+{
+	return &quic_sk(sk)->alpn;
+}
+
 static inline bool quic_is_establishing(struct sock *sk)
 {
 	return sk->sk_state == QUIC_SS_ESTABLISHING;
-- 
2.47.1

