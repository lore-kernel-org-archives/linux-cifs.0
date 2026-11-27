Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795782623;
	b=PRr+rlIZoJDCFFMXnisXyBe6i2fXPTVxN4Vs/iai6QGhk9TTCZxrGifAtzGAZqNSzREi
	 73o2GzE6OIZkP9saDVfFLeYuzON27Vni40GPIT/y5l3Hv5Veiiy7V9rXs7QzYO00Y+Zku
	 ISVF9CdD8evcJwjuDQwB1JgZpy0Fty0LRB7O4k8k4FwMJhbzxM38smViOVN5WvihH3u7T
	 vJtuXnv8zwerg9svdh4uCEZ7CVD9APwWMVg7o/p6MGbIyr9rpzW2BmfHjObrDWC2wcm5u
	 bNwkIhsbiKO2sfOAJmFj5Piiz82XGtiPkQr4UuqACVJ7kbWzryvUew2V/BTh4Ff5ksg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795782623;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Px6oQu/+YXlBGjcwOwuY9O/TtoFIV63D/vvY74zG5uQ=;
	b=N3xIvkuHXlID0fugsNTPLXGI4LJrVCUo4lGN33DwVANnTfZL6OnXgy7xco62wPDVpCZm
	 gIV/d3QUKEkWGozAqJor53jz6e3ZUSusCeSmri8hmUNwMssomFdXBMOjCBo11MBzQvhwa
	 ZSw6hdBQurqRFghiZkY0qP/StX2zo+V+Agjy/GguKbebcNmlGH4UR4h1mReCwg9Sk8pwy
	 FDhQLI0hTkyJVKQi4qasv+D7BsNFljMneI+7jW047SkJ4DnXes0gLSd4xK3SaY+tUUItn
	 P1B78IaB43TKVPjXgAVyDi/YBtHtv6aPn0SMj3u+ycBdup5uSVzL3ozrKwlopkJKiKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=n7uH0j5I;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3474606A31C;
	Fri, 27 Nov 2026 12:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3474606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=n7uH0j5I
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Px6oQu/+YXlBGjcwOwuY9O/TtoFIV63D/vvY74zG5uQ=; b=n7uH0j5ITV6/SZXCJDshZKCear
	EG1RoS2NtERssbshOPzWMiJ7ALLAHvgbN3VRwgnCbPiaHoAfcQqRJsytzD+UiDQ+qR4IWxoFk7Oq2
	SGDT2248fG8gz1IErDEYFefz6yoppPePl+pCiAks8am56bDy9uzBBCWqNz5K2vg+Pm71XW7uKoxWg
	qa8BdAC/DQ5ry9LviYKl1z9IUJYw4rYgtE75xeu1YIZ7+HmSRRA7lMGU0l2W1mYDCC/hBDAB26c+b
	AYXKsjHDtVAFH89DdCZtU3luaT4rj9qofGmHPeQVsOiomK7nKVDMd7YScHLxsx92Su7ku88ZcZvyw
	vtsKWMtGjMTLE2B6pCBOdJ8HTMjwEk5Xz2lHsdnh0VBgyh8fFeqtCx4iQEqWXbIUK6cXiz2S7tOv9
	mgLXckngTjPWG4AEFNsdRbF6W0nz+//J8f9G+a5zoTg6yrbpSsm2afuRxJDlxK29GEM06Jet8zCeT
	gG49LAJVL3cnqoAquBMulvZt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWv5m-00000001Lho-387A;
	Fri, 27 Nov 2026 12:30:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jacob Moroni <jmoroni@google.com>,
	linux-rdma@vger.kernel.org
Subject: [PATCH 10/10] smb: smbdirect: don't expose DMA addresses as iova of our MRs
Date: Fri, 27 Nov 2026 13:29:07 +0100
Message-ID: <98fe98df62a28f8842f5ed2bf0e375e5ada6bea7.1795781300.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795781300.git.metze@samba.org>
References: <cover.1795781300.git.metze@samba.org>
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

ib_map_mr_sg() uses the DMA address of the first page as iova of the
MR and smbdirect sends that iova to the peer as offset of the buffer
descriptor, so the peer learns our DMA addresses, without an IOMMU
these are the physical addresses of the buffers.

The peer just uses the offset as base address of its RDMA READs and
WRITEs, so the value is up to us, the hardware only needs the offset
within the first page in the low bits of the iova. So keep these bits,
leave the rest of the low 24 bits zero (more for a page size above
16 MiB), so that the addresses the peer uses show the position within
the MR in traces, and put random bits above them up to bit 55, which
also makes it harder to reuse an old offset with a token whose key
wrapped around.

The top byte is always 0, so iova + length stays far below 2^64 even
for a length of U32_MAX. This also avoids a problem with irdma: with
an IOMMU that allocates IOVAs top-down, the first 64-bit IOVA range of
a device ends exactly at 2^64. If that is the buffer of an MR,
iova + length is 0 and irdma rejects the RDMA READ of the peer with
IRDMA_AE_AMP_TO_WRAP (ae_id 0x10a), even if the last byte of the MR is
at 2^64 - 1, so the connection is torn down.

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: Jacob Moroni <jmoroni@google.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/mr.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
index 70fc4a2fc7a8..03d3b2fb3f97 100644
--- a/fs/smb/smbdirect/mr.c
+++ b/fs/smb/smbdirect/mr.c
@@ -5,6 +5,7 @@
  */
 
 #include "internal.h"
+#include <linux/random.h>
 
 /*
  * Allocate MRs used for RDMA read/write
@@ -300,6 +301,8 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 	struct smbdirect_mr_io *mr;
 	int ret, num_pages, num_mapped;
 	struct ib_reg_wr *reg_wr;
+	u64 random_bits, page_offset;
+	unsigned int shift;
 	unsigned long flags;
 
 	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
@@ -373,6 +376,32 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
 		goto map_mr_error;
 	}
 
+	/*
+	 * ib_map_mr_sg() uses the DMA address of the first page as
+	 * iova, which goes to the peer as offset of the buffer
+	 * descriptor. Don't expose DMA addresses (without an IOMMU
+	 * physical addresses) to the peer, the hardware only needs
+	 * the offset within the first page in the low bits, all
+	 * other bits are up to us.
+	 *
+	 * The low 24 bits (or more for a page size above 16 MiB) are
+	 * only that page offset, so in traces they show the position
+	 * within the MR plus that offset (an SMB3 READ/WRITE is at
+	 * most 16 MiB). The bits above up to bit 55 are random, which
+	 * makes it harder to reuse an old offset with a token whose
+	 * key wrapped around.
+	 *
+	 * The top byte is always 0, so iova + length stays far below
+	 * 2^64 even for a length of U32_MAX. irdma rejects the access
+	 * to an MR ending exactly at 2^64 with IRDMA_AE_AMP_TO_WRAP,
+	 * which happened with an IOMMU that allocates the first
+	 * 64-bit IOVA range at the very top.
+	 */
+	shift = max_t(unsigned int, 24, ilog2(mr->mr->page_size));
+	random_bits = ((u64)get_random_u32() << shift) & GENMASK_ULL(55, 24);
+	page_offset = mr->mr->iova & (mr->mr->page_size - 1);
+	mr->mr->iova = random_bits | page_offset;
+
 	ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
 	if (mr->mr->rkey == mr->base_tag)
 		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
-- 
2.43.0

