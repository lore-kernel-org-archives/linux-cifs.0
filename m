Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795537427;
	b=ttYyGI344OhGsSbmWQEpujr+Iz0gIAfhgn5CsoF6hRMRFeOG6kBmEELlHGAg8rFrlnms
	 P3pVZWHzgzPGJhvVzi4SfzW7EtCRAHhs5GN7RVCZWveH1re8/42iDHr04d5B/AWnfAaNf
	 csNTyHec6LAmCVtkVgk3XKuj6nYLitY+s9QwXv74Cy8opkHLfqH+oo7n+GgFd94STvbSL
	 SHi34sCjoWAPoz1ZbmTqgb1coYnGDw9M/Ktx1nQt/4wMZig9MGzYpG1MW7tNRwSIy6JQf
	 LSlmHRzJzryr2kgGdP8B/bwcjVg7KlHdEaMLXnu8ySbrbHRm1bREJYflR/gb2+s681g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795537427;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=UPJaFcasLEtKrEgIxll2l1F9fc4txscBJzugZ88bpno=;
	b=Adups86/zEMOJqqrUBjgDMi70bNNT7Ly4/jdOpLM6IApwK3EjFjvMC6f4uk2ExdQ1tUX
	 GYuUrWuVnmPIE0uzSKhtNoLnedqXkHghQeMw9hNkm1ghctN19weS17nwUYPqCDNOEZ9YT
	 sfZDC3+ItpuzPgp0Y97xLeNYVPUfwf2xREbRxMWeK2Y+yYLfn+C2BkMbY+V7iMUVoPwUE
	 7VvmMZJT7vX95U8+rRCazC2p0IgGKR/pQPqMCQ3gJ/dXqiaa7vCi16eusuo01Hhtt12Z4
	 BZErEpvkxSHr8olqXhiSCk1a6HHPUSalZVDe5YID5odS6D5kHzDkh5zGAOfCF6xycYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=iLIgkP1n;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=vY7b1llG;
	arc=none smtp.remote-ip=103.168.172.148
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1233606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 16:23:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1233606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=iLIgkP1n;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=vY7b1llG
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id E34A6EC09B6
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 11:23:44 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 24 Nov 2026 11:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1795537424; x=
	1795623824; bh=UPJaFcasLEtKrEgIxll2l1F9fc4txscBJzugZ88bpno=; b=i
	LIgkP1nFZyDDvdxdUSF3GN0kZ8Pz3Y9AIJoQ8avjmUnD56eQYcYqSXi7noe9AE7l
	UZO3HYo2JV6ptS6U6Ijrw0rNTOHehFdHQnclbv7ocoq2QYvojyr6UJbzzrnDUn+6
	tmJi8tbTYtnysuaZ8AZB2cA+1PeYMFgol1FajZ+3A9sopya65N0kNUOdZtmYdXIA
	QAcnP9ZiMsp4qGKaJTYQ6KmuwOaFnaeufxh580QiDiVCCvhLCRNsldfTCWRr6YCC
	qL6a3Q8faCz3QaiBKKn3vpn/chgs3wXEDP1xMVp2Y1+AoTXKtmvE+LxJ1vijQZcI
	B6mpAyHAyKM8JVwulKcAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1795537424; x=1795623824; bh=U
	PJaFcasLEtKrEgIxll2l1F9fc4txscBJzugZ88bpno=; b=vY7b1llGgR57KGLpt
	CpLgfSfLxYWGGZB4M8SdjJvpRxyafg6xIqkbGu74yQl0tTw3pvNjDHfd024V4ZFg
	9Cb4JWoUxYhxu0hUvUTH+Uhhx5YTAIRZxfs1b2wHgifMhiqPGtgx+cJ1gaOUKrtI
	KH7zR8ZRWTvRke2xGh5vhJX5HvISlMa+ZGQ3LZKziNWlosv8iPvTb6QBA2Di2BaK
	j5QiqmlbjhmOlDtf8vRF7kgguiHDYtKw7edx/EIom0JpJCRKQJBlbchQ6PAjxbNn
	2aNHjjdrRGXfwQTAI6vBWW0h/lDARkr8d40Kk6bvcMFSvTmzfFcNHuI4vxp2OsOH
	FtfIg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795537424; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:LIaMTXQrOLlRdDwmVas0v6Ct5uQCzTrNwUYkqJrQ8Xy3Oeb
	FUwpOj2aDeG8WUdU38H4k1ilD3Yx/QikvU3A03CC8LsC2tD9Q3ISx3Z4qC3q26zk
	VHxzvEzqRcvlgCAdWTvg5PAIqhJ6YkXF8NLrrOy8GzF+1WrrYFVnWETrZde8K6wx
	p9/4W9EiERk1sUaci60ieeRKHNlDYNainNUcCoWVW4q+AfTiK4ubn9J7QSd+duu7
	/dYgdN37tCoupfSWz58BOOVgqx194R1O3N1UvbzOGhLtEZliKZYZBgfpbzJ5Bt0v
	8Hv7f1aQM0KMrY0QtIge+C4b3EcW3V+7L6pfO2g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:CaroM3K3vgTBhK8hsl2678fmOjUAeO7F46TD2NIZhg4=:x+2kpCAYtkS6bNVB6DJLDCgqKalIJ1vYHcpSDnFaeHw=;
X-ME-Sender: <xms:ELoFa3lKbnOAQpqxQdOuNWS9D5JJKOT6rxvk2nNq5o05g2bhaxIRBA>
    <xme:ELoFa-is28kesTkOedegykw_GDmiEc2XVPIOPTLXHncPfL9tX0gjkP_xHlwJYTyrs
    NX_W1Npni710xephvHjjBX5K9271wqNib5qsBMhwYR4Zi9pnzGJCeEF>
X-ME-Received: <xmr:ELoFa3dphC6WW-8BdzW3TpVJM0wPiUs0HwxXT0RPiOUD6kyrnuwwKYeakuYn_mFh>
X-ME-Proxy-Cause: dmFkZTFSvR4e8buJ4s5HUUAHFKsx2Z9PD7zteb3cvtRYBs6KziXojcHnUhxaMTbajLD3Qc
    U8uFI9I9QBEs1XxGKvZfo2owRGEpKW7T40pTmbTgzKffyaflL+zKYJKM3WkL673uo/p7xQ
    G4WYbu9KbEa9c47odxt+aN6nS0SOG0Jl2Rh89gAwCFHATP7tDTpe3QP+o1E8OygIeWvcUQ
    F07Gy3guqbhOxv5028m13yjZtEBmwJ2EpZBMCp6cI94RVgSWAmsTi4fBOScVRzriJ1Uhxt
    yTNek8gtH6jJwSlLWi97jk0zcXjfLGhXSvaSM40KoDBjwzmoBk9PnHyCCdpU7pUlVjjMC3
    ig4Jpw+70VDpX/Z+8ezPAydOsKE2TdhRcnWHZ2VXfnZg1lc6T4StlyFTwc6QeYNtBneUaf
    6tdDvsbQiNIJ4dhnjqkXvKxvLzYzncqUIKKQxY6uBfMXH+lovgdr5NG6Cuumkj0DxvjmY5
    Ls1OFghgRAKzCzHfvxJEyWmx2SYZdcfparWgNO2hNwsZpdnRUXPJntr37Jm7H9rsmcrF7w
    X+4cAbBEcFiSHfW4vbxGsY98P7TzBFUriLPTmAjvkHWYUZt+qWp0PFeAJoLXKCX8Ah+W0W
    56m4Lmhm28NLhMr6H5pWa8buXjNhXsctYDJK4q7Mc09yQfXytwLQ0WM4vOgQ
X-ME-Proxy: <xmx:ELoFa2hBwxT9MzYZQB_Dtk-52Usm6LZe4L3Mg9uU6RmplM9GzEnAxQ>
    <xmx:ELoFa3wYPCZ3nPBdz21bAk0Hpvra1GZhy5CrWc-1RV3Zhx6YGOmbAA>
    <xmx:ELoFa6PzFe_T9-TiARq2UN9zYbB_XentR3TAUu-bOmHuV6rj9YbNVg>
    <xmx:ELoFawWliYcu_YrUrR4vg-MKJyzBIy8gR2TgeXAWbJbkuYElwrYFGA>
    <xmx:ELoFa4AW39fLxsXmVE4vkKIe-OjbIWQPxZs4V19ITLjepZwej40uaIiu>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Nov 2026 11:23:44 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: [RFC PATCH 1/2] ksmbd: add a security descriptor decoder and encoder
Date: Tue, 24 Nov 2026 10:23:30 -0600
Message-ID: <20261124162331.895789-2-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124162331.895789-1-icb@fastmail.org>
References: <20261124162331.895789-1-icb@fastmail.org>
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

ksmbd currently reads and writes security descriptors (SDs) by walking
the wire format. Each walk repeats the bounds checks for the offsets,
the ACL sizes, the ACE sizes, and the SID lengths.

Add one decoder and one encoder for the self-relative SD defined in
MS-DTYP 2.4.6, with struct ksmbd_sd between them. ksmbd_sd_decode()
validates a whole SD and returns it as a single allocation. The owner,
the group, and the SID of each ACE are pointers to bytes it has
checked. ksmbd_sd_encode() checks the struct a caller filled in, works
out the size, and writes the SD to a buffer it allocates.

The decoder returns -EBADMSG for an SD that breaks a structural rule of
MS-DTYP. It keeps what it does not interpret. An ACE of any type that
MS-DTYP gives a structure is kept with its object GUIDs and its
application data. The SACL is kept as bytes. Every Control bit is kept
except SELF_RELATIVE, DACL_PRESENT, and SACL_PRESENT, which the encoder
sets from the SD it writes.

A malformed SACL does not fail the decode. The decoder drops the SACL
and sets sacl_dropped, and the caller decides whether to use the rest
of the SD.

Nothing calls the two functions yet. The KUnit suite has cases for what
the decoder accepts and refuses and for what the encoder refuses.

Signed-off-by: Ian Bridges <icb@fastmail.org>
---
 fs/smb/server/Makefile              |   2 +-
 fs/smb/server/secdesc.c             | 775 ++++++++++++++++++++++++
 fs/smb/server/secdesc.h             |  66 +++
 fs/smb/server/tests/Makefile        |   3 +
 fs/smb/server/tests/secdesc_kunit.c | 879 ++++++++++++++++++++++++++++
 5 files changed, 1724 insertions(+), 1 deletion(-)
 create mode 100644 fs/smb/server/secdesc.c
 create mode 100644 fs/smb/server/secdesc.h
 create mode 100644 fs/smb/server/tests/secdesc_kunit.c

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index 9bc87695a53c..a1b988212a0a 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -8,7 +8,7 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		misc.o oplock.o connection.o ksmbd_work.o crypto_ctx.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
-		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
+		transport_tcp.o transport_ipc.o smbacl.o secdesc.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
 		ksmbd_spnego_negtokentarg.asn1.o asn1.o compress.o
 
diff --git a/fs/smb/server/secdesc.c b/fs/smb/server/secdesc.c
new file mode 100644
index 000000000000..b6c380081a53
--- /dev/null
+++ b/fs/smb/server/secdesc.c
@@ -0,0 +1,775 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Security descriptor decoder and encoder (MS-DTYP 2.4.6) */
+
+#include <linux/align.h>
+#include <linux/array_size.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/cleanup.h>
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+#include <linux/uuid.h>
+#include <asm/byteorder.h>
+#include <kunit/visibility.h>
+
+#include "glob.h"
+#include "smbacl.h"
+#include "secdesc.h"
+
+/*
+ * The 16-bit revision field of struct smb_ntsd and of struct smb_acl holds
+ * the Revision byte in its low half and the Sbz1 byte in its high half.
+ */
+#define SD_REVISION_MASK	0xff
+#define SD_SBZ1_SHIFT		8
+
+/* The part of an ACE before its SID, or before its object section */
+#define SD_ACE_HDR_SIZE		offsetof(struct smb_ace, sid)
+#define SD_ACE_MIN_SIZE		(SD_ACE_HDR_SIZE + CIFS_SID_BASE_SIZE)
+
+#define SD_SID_REVISION		1
+#define SD_ACL_REVISION		2
+#define SD_ACL_REVISION_DS	4
+
+#define SD_ALIGN		4
+
+/* Control bits that the encoder sets from the SD, not from sd->control */
+#define SD_CONTROL_DERIVED	(SELF_RELATIVE | DACL_PRESENT | SACL_PRESENT)
+
+/*
+ * An encoded SID is 8 bytes plus 4 bytes per sub-authority, but struct
+ * smb_sid always has room for 15 sub-authorities. The decoder pads its
+ * allocation by the difference, so that a short SID at the end of the
+ * allocation can be read through a struct smb_sid pointer without going
+ * out of bounds.
+ */
+#define SD_SID_SLACK	(sizeof(struct smb_sid) - CIFS_SID_BASE_SIZE)
+
+/*
+ * The Flags of an object ACE (MS-DTYP 2.4.4.3). Each one says that a GUID
+ * is present before the SID.
+ */
+#define ACE_OBJECT_TYPE_PRESENT			0x1
+#define ACE_INHERITED_OBJECT_TYPE_PRESENT	0x2
+#define SD_OBJ_GUID_FLAGS \
+	(ACE_OBJECT_TYPE_PRESENT | ACE_INHERITED_OBJECT_TYPE_PRESENT)
+
+enum sd_ace_layout {
+	SD_ACE_NONE,
+	SD_ACE_PLAIN,
+	SD_ACE_OBJECT,
+};
+
+struct sd_in {
+	const u8 *p __counted_by_ptr(len);
+	size_t len;
+};
+
+struct sd_parsed {
+	u16 control;
+	u8 sbz1;
+	struct sd_in owner;
+	struct sd_in group;
+	enum ksmbd_acl_state dacl_state;
+	struct sd_in dacl;
+	struct smb_acl dacl_hdr;
+	enum ksmbd_acl_state sacl_state;
+	struct sd_in sacl;
+	bool sacl_dropped;
+};
+
+struct sd_writer {
+	u8 *p __counted_by_ptr(cap);
+	size_t cap;
+	size_t pos;
+	bool bad;
+};
+
+struct sd_layout {
+	bool object;
+	/* Each offset is 0 if the SD does not have that part */
+	size_t owner_off, group_off, dacl_off, sacl_off;
+	size_t dacl_size;
+	size_t total;
+};
+
+/*
+ * Every ACE type that MS-DTYP defines a structure for (2.4.4.2 to
+ * 2.4.4.16). The types meant for a SACL are included because a client can
+ * put them in a DACL, and ksmbd has always accepted a DACL that has them.
+ */
+static const u8 sd_ace_layouts[] = {
+	[ACCESS_ALLOWED_ACE_TYPE]		  = SD_ACE_PLAIN,
+	[ACCESS_DENIED_ACE_TYPE]		  = SD_ACE_PLAIN,
+	[SYSTEM_AUDIT_ACE_TYPE]			  = SD_ACE_PLAIN,
+	[ACCESS_ALLOWED_OBJECT_ACE_TYPE]	  = SD_ACE_OBJECT,
+	[ACCESS_DENIED_OBJECT_ACE_TYPE]		  = SD_ACE_OBJECT,
+	[SYSTEM_AUDIT_OBJECT_ACE_TYPE]		  = SD_ACE_OBJECT,
+	[ACCESS_ALLOWED_CALLBACK_ACE_TYPE]	  = SD_ACE_PLAIN,
+	[ACCESS_DENIED_CALLBACK_ACE_TYPE]	  = SD_ACE_PLAIN,
+	[ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE] = SD_ACE_OBJECT,
+	[ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE]  = SD_ACE_OBJECT,
+	[SYSTEM_AUDIT_CALLBACK_ACE_TYPE]	  = SD_ACE_PLAIN,
+	[SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE]	  = SD_ACE_OBJECT,
+	[SYSTEM_MANDATORY_LABEL_ACE_TYPE]	  = SD_ACE_PLAIN,
+	[SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE]	  = SD_ACE_PLAIN,
+	[SYSTEM_SCOPED_POLICY_ID_ACE_TYPE]	  = SD_ACE_PLAIN,
+};
+
+static enum sd_ace_layout sd_ace_layout(u8 type)
+{
+	return type < ARRAY_SIZE(sd_ace_layouts) ? sd_ace_layouts[type] :
+						   SD_ACE_NONE;
+}
+
+static size_t sd_sid_len(unsigned int num_subauth)
+{
+	return CIFS_SID_BASE_SIZE + num_subauth * sizeof(__le32);
+}
+
+/*
+ * In an object ACE, the mask is followed by a Flags field, then by an
+ * ObjectType GUID if ACE_OBJECT_TYPE_PRESENT is set, then by an
+ * InheritedObjectType GUID if ACE_INHERITED_OBJECT_TYPE_PRESENT is set, and
+ * then by the SID (MS-DTYP 2.4.4.3). Returns the size of what lies between
+ * the mask and the SID, which is the Flags field and the GUIDs.
+ */
+static size_t sd_obj_len(u32 obj_flags)
+{
+	unsigned int num_guids = hweight32(obj_flags & SD_OBJ_GUID_FLAGS);
+
+	return sizeof(obj_flags) + num_guids * sizeof(guid_t);
+}
+
+static const u8 *sd_in_at(const struct sd_in *input, size_t off, size_t len)
+{
+	if (!len || off > input->len || len > input->len - off)
+		return NULL;
+	return input->p + off;
+}
+
+static int sd_malformed(const char *why)
+{
+	ksmbd_debug(SMB, "malformed security descriptor: %s\n", why);
+	return -EBADMSG;
+}
+
+/* On success, *@sid points to the SID at @off */
+static int sd_check_sid(const struct sd_in *input, size_t off,
+			const struct smb_sid **sid)
+{
+	const struct smb_sid *candidate;
+
+	candidate = (const void *)sd_in_at(input, off, CIFS_SID_BASE_SIZE);
+	if (!candidate)
+		return sd_malformed("SID out of bounds");
+	if (candidate->revision != SD_SID_REVISION)
+		return sd_malformed("SID revision is not 1");
+	if (candidate->num_subauth > SID_MAX_SUB_AUTHORITIES)
+		return sd_malformed("SID has more than 15 sub-authorities");
+	if (!sd_in_at(input, off, sd_sid_len(candidate->num_subauth)))
+		return sd_malformed("SID out of bounds");
+	*sid = candidate;
+	return 0;
+}
+
+/*
+ * Validates the ACE at @pos and returns its size in *@size. If @out is not
+ * NULL, the ACE is decoded into it, and its pointers point into @aces.
+ * This is forced inline because the decoder calls it once for every ACE.
+ */
+static __always_inline int
+sd_parse_ace(const struct sd_in *aces, size_t pos, struct ksmbd_ace *out,
+	     size_t *size)
+{
+	size_t len, end, off = SD_ACE_HDR_SIZE;
+	enum sd_ace_layout layout;
+	const struct smb_sid *sid;
+	struct sd_in ace;
+	const u8 *p;
+	int rc;
+
+	p = sd_in_at(aces, pos, SD_ACE_HDR_SIZE);
+	if (!p)
+		return sd_malformed("ACE count exceeds ACL size");
+	len = get_unaligned_le16(&p[offsetof(struct smb_ace, size)]);
+	if (len % SD_ALIGN)
+		return sd_malformed("ACE size not a multiple of 4");
+	if (!sd_in_at(aces, pos, len))
+		return sd_malformed("ACE out of bounds");
+	ace = (struct sd_in){ .len = len, .p = p };
+	layout = sd_ace_layout(p[offsetof(struct smb_ace, type)]);
+	if (layout == SD_ACE_NONE)
+		return sd_malformed("unknown ACE type");
+
+	if (layout == SD_ACE_OBJECT) {
+		u32 obj_flags;
+
+		p = sd_in_at(&ace, off, sizeof(obj_flags));
+		if (!p)
+			return sd_malformed("object ACE flags out of bounds");
+		obj_flags = get_unaligned_le32(p);
+		if (obj_flags & ~(u32)SD_OBJ_GUID_FLAGS)
+			return sd_malformed("undefined object ACE flags");
+		off += sd_obj_len(obj_flags);
+	}
+
+	rc = sd_check_sid(&ace, off, &sid);
+	if (rc)
+		return rc;
+	*size = len;
+	if (!out)
+		return 0;
+
+	end = off + sd_sid_len(sid->num_subauth);
+	*out = (struct ksmbd_ace){
+		.type = ace.p[offsetof(struct smb_ace, type)],
+		.flags = ace.p[offsetof(struct smb_ace, flags)],
+		.mask = get_unaligned_le32(&ace.p[offsetof(struct smb_ace, access_req)]),
+		.sid = sid,
+		.obj_len = off - SD_ACE_HDR_SIZE,
+		.data_len = len - end,
+		.obj = off > SD_ACE_HDR_SIZE ? &ace.p[SD_ACE_HDR_SIZE] : NULL,
+		.data = len > end ? &ace.p[end] : NULL,
+	};
+	return 0;
+}
+
+static int sd_parse_acl(const struct sd_in *src, size_t off,
+			struct sd_in *acl, struct smb_acl *hdr)
+{
+	const u8 *p = sd_in_at(src, off, sizeof(*hdr));
+	unsigned int size, rev;
+
+	if (!p)
+		return sd_malformed("ACL header out of bounds");
+	memcpy(hdr, p, sizeof(*hdr));
+	rev = le16_to_cpu(hdr->revision) & SD_REVISION_MASK;
+	if (rev != SD_ACL_REVISION && rev != SD_ACL_REVISION_DS)
+		return sd_malformed("ACL revision is not 2 or 4");
+	size = le16_to_cpu(hdr->size);
+	if (size < sizeof(*hdr) || !sd_in_at(src, off, size))
+		return sd_malformed("ACL size out of bounds");
+	if (le16_to_cpu(hdr->num_aces) > (size - sizeof(*hdr)) / SD_ACE_MIN_SIZE)
+		return sd_malformed("ACE count exceeds ACL size");
+	*acl = (struct sd_in){ .len = size, .p = p };
+	return 0;
+}
+
+static struct sd_in sd_acl_aces(const struct sd_in *acl)
+{
+	struct sd_in aces = { .len = acl->len - sizeof(struct smb_acl) };
+
+	aces.p = sd_in_at(acl, sizeof(struct smb_acl), aces.len);
+	return aces;
+}
+
+/*
+ * Validates an ACL without decoding it. This is for the SACL, which is kept
+ * as raw bytes.
+ */
+static int sd_check_acl(const struct sd_in *src)
+{
+	struct sd_in acl, aces;
+	size_t pos = 0, size;
+	struct smb_acl hdr;
+	unsigned int i;
+	int rc;
+
+	rc = sd_parse_acl(src, 0, &acl, &hdr);
+	if (rc)
+		return rc;
+	aces = sd_acl_aces(&acl);
+	for (i = 0; i < le16_to_cpu(hdr.num_aces); i++) {
+		rc = sd_parse_ace(&aces, pos, NULL, &size);
+		if (rc)
+			return rc;
+		pos += size;
+	}
+	return 0;
+}
+
+static int sd_parse_sid_at(const struct sd_in *src, size_t off,
+			   struct sd_in *sid)
+{
+	const struct smb_sid *checked;
+	int rc;
+
+	rc = sd_check_sid(src, off, &checked);
+	if (!rc)
+		*sid = (struct sd_in){ .len = sd_sid_len(checked->num_subauth),
+				       .p = (const u8 *)checked };
+	return rc;
+}
+
+static int sd_parse_header(const struct sd_in *src,
+			   struct sd_parsed *parsed)
+{
+	const u8 *p = sd_in_at(src, 0, sizeof(struct smb_ntsd));
+	u32 owner, group, dacl, sacl;
+	struct smb_acl sacl_hdr;
+	struct smb_ntsd hdr;
+	u16 rev;
+	int rc;
+
+	if (!p)
+		return sd_malformed("header out of bounds");
+	memcpy(&hdr, p, sizeof(hdr));
+	rev = le16_to_cpu(hdr.revision);
+	if ((rev & SD_REVISION_MASK) != SD_REVISION)
+		return sd_malformed("revision is not 1");
+	parsed->sbz1 = rev >> SD_SBZ1_SHIFT;
+	parsed->control = le16_to_cpu(hdr.type);
+	owner = le32_to_cpu(hdr.osidoffset);
+	group = le32_to_cpu(hdr.gsidoffset);
+	dacl = le32_to_cpu(hdr.dacloffset);
+	if ((owner && owner < sizeof(hdr)) || (group && group < sizeof(hdr)) ||
+	    (dacl && dacl < sizeof(hdr)))
+		return sd_malformed("owner, group, or DACL offset inside header");
+
+	if (owner) {
+		rc = sd_parse_sid_at(src, owner, &parsed->owner);
+		if (rc)
+			return rc;
+	}
+	if (group) {
+		rc = sd_parse_sid_at(src, group, &parsed->group);
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * A nonzero OffsetDacl with DACL_PRESENT clear is refused, because
+	 * the two fields disagree about whether the SD has a DACL (MS-DTYP
+	 * 2.4.6).
+	 */
+	if (!(parsed->control & DACL_PRESENT)) {
+		if (dacl)
+			return sd_malformed("DACL offset without DACL_PRESENT");
+	} else if (!dacl) {
+		parsed->dacl_state = KSMBD_ACL_NULL;
+	} else {
+		parsed->dacl_state = KSMBD_ACL_PRESENT;
+		rc = sd_parse_acl(src, dacl, &parsed->dacl, &parsed->dacl_hdr);
+		if (rc)
+			return rc;
+	}
+
+	/*
+	 * A malformed SACL does not fail the decode. The SD is decoded
+	 * without it and sacl_dropped is set. OffsetSacl is ignored when
+	 * SACL_PRESENT is clear, as ksmbd has always done.
+	 */
+	sacl = le32_to_cpu(hdr.sacloffset);
+	if (!(parsed->control & SACL_PRESENT))
+		return 0;
+	if (!sacl) {
+		parsed->sacl_state = KSMBD_ACL_NULL;
+	} else if (sacl < sizeof(hdr)) {
+		sd_malformed("SACL offset inside header");
+		parsed->sacl_dropped = true;
+	} else if (sd_parse_acl(src, sacl, &parsed->sacl, &sacl_hdr)) {
+		parsed->sacl_dropped = true;
+	} else {
+		parsed->sacl_state = KSMBD_ACL_PRESENT;
+	}
+	return 0;
+}
+
+/*
+ * Copies the ACEs of the DACL to @kept and decodes the copy, so that the
+ * bytes that were validated are the bytes the SD keeps.
+ */
+static int sd_decode_dacl(struct ksmbd_sd *sd,
+			  const struct sd_parsed *parsed,
+			  const struct sd_in *wire, u8 *kept)
+{
+	struct sd_in aces = { .len = wire->len, .p = kept };
+	u16 rev = le16_to_cpu(parsed->dacl_hdr.revision);
+	size_t pos = 0, size;
+	bool object = false;
+	unsigned int i;
+	int rc;
+
+	if (wire->len)
+		memcpy(kept, wire->p, wire->len);
+	for (i = 0; i < sd->num_aces; i++) {
+		rc = sd_parse_ace(&aces, pos, &sd->aces[i], &size);
+		if (rc)
+			return rc;
+		if (sd->aces[i].obj_len)
+			object = true;
+		pos += size;
+	}
+	/* A DACL that contains an object ACE has revision 4 (MS-DTYP 2.4.5) */
+	sd->dacl_revision = object ? SD_ACL_REVISION_DS : rev & SD_REVISION_MASK;
+	sd->dacl_sbz1 = rev >> SD_SBZ1_SHIFT;
+	sd->dacl_sbz2 = le16_to_cpu(parsed->dacl_hdr.reserved);
+	return 0;
+}
+
+static const struct smb_sid *sd_keep_sid(const struct sd_in *sid, u8 *kept)
+{
+	if (!sid->len)
+		return NULL;
+	return memcpy(kept, sid->p, sid->len);
+}
+
+/**
+ * ksmbd_sd_decode() - decode a self-relative security descriptor
+ * @buf:	the encoded SD, which must not change during the call
+ * @len:	the length of @buf in bytes
+ * @out:	set to the decoded SD on success and to NULL on error. The
+ *		caller frees it with kvfree().
+ *
+ * The SD is read as self-relative whether or not SELF_RELATIVE is set in
+ * its Control field. ksmbd has stored SDs with the bit clear, and those
+ * must still decode.
+ *
+ * The decoded SD is a single allocation, and every pointer in it points
+ * into that allocation and not into @buf.
+ *
+ * A well-formed SACL is kept as bytes in sacl_data. A malformed SACL does
+ * not fail the decode. In that case only, the decoded SD has no SACL and
+ * sacl_dropped is set.
+ *
+ * Return: 0 on success, -EBADMSG if any part of the SD other than the SACL
+ * is malformed, or -ENOMEM.
+ */
+int ksmbd_sd_decode(const u8 *buf, size_t len, struct ksmbd_sd **out)
+{
+	struct ksmbd_sd *sd __free(kvfree) = NULL;
+	struct sd_in src = { .len = len, .p = buf };
+	struct sd_parsed parsed = {};
+	struct sd_in wire = {};
+	size_t fixed, kept_len;
+	unsigned int num_aces;
+	u8 *kept;
+	int rc;
+
+	*out = NULL;
+	rc = sd_parse_header(&src, &parsed);
+	if (rc)
+		return rc;
+	if (parsed.dacl_state == KSMBD_ACL_PRESENT)
+		wire = sd_acl_aces(&parsed.dacl);
+	num_aces = le16_to_cpu(parsed.dacl_hdr.num_aces);
+
+	/*
+	 * The allocation holds the struct and its array of ACEs, followed by
+	 * copies of the owner SID, the group SID, the ACEs of the DACL, and
+	 * the SACL.
+	 */
+	fixed = struct_size(sd, aces, num_aces);
+	kept_len = parsed.owner.len + parsed.group.len + wire.len +
+		   parsed.sacl.len;
+	sd = kvmalloc(size_add(fixed, kept_len + SD_SID_SLACK), KSMBD_DEFAULT_GFP);
+	if (!sd)
+		return -ENOMEM;
+	kept = (u8 *)sd + fixed;
+	memset(kept + kept_len, 0, SD_SID_SLACK);
+
+	sd->num_aces = num_aces;
+	sd->control = parsed.control & ~SD_CONTROL_DERIVED;
+	sd->sbz1 = parsed.sbz1;
+	sd->dacl = parsed.dacl_state;
+	sd->dacl_revision = 0;
+	sd->dacl_sbz1 = 0;
+	sd->dacl_sbz2 = 0;
+	sd->sacl = parsed.sacl_state;
+	sd->sacl_len = 0;
+	sd->sacl_data = NULL;
+	sd->sacl_dropped = parsed.sacl_dropped;
+
+	sd->owner = sd_keep_sid(&parsed.owner, kept);
+	kept += parsed.owner.len;
+	sd->group = sd_keep_sid(&parsed.group, kept);
+	kept += parsed.group.len;
+	if (parsed.dacl_state == KSMBD_ACL_PRESENT) {
+		rc = sd_decode_dacl(sd, &parsed, &wire, kept);
+		if (rc)
+			return rc;
+	}
+	kept += wire.len;
+	if (parsed.sacl.len) {
+		struct sd_in copy = { .len = parsed.sacl.len, .p = kept };
+
+		memcpy(kept, parsed.sacl.p, parsed.sacl.len);
+		if (sd_check_acl(&copy)) {
+			sd->sacl = KSMBD_ACL_ABSENT;
+			sd->sacl_dropped = true;
+		} else {
+			sd->sacl_len = parsed.sacl.len;
+			sd->sacl_data = kept;
+		}
+	}
+
+	*out = no_free_ptr(sd);
+	return 0;
+}
+EXPORT_SYMBOL_IF_KUNIT(ksmbd_sd_decode);
+
+/*
+ * Appends @len bytes to the output. A write that does not fit sets
+ * writer->bad instead, and every later write is skipped.
+ */
+static void sd_put(struct sd_writer *writer, const void *src, size_t len)
+{
+	if (!len || writer->bad)
+		return;
+	if (WARN_ON_ONCE(writer->pos > writer->cap ||
+			 len > writer->cap - writer->pos)) {
+		writer->bad = true;
+		return;
+	}
+	memcpy(&writer->p[writer->pos], src, len);
+	writer->pos += len;
+}
+
+static bool sd_sid_fits(const struct smb_sid *sid)
+{
+	return sid->revision == SD_SID_REVISION &&
+	       sid->num_subauth <= SID_MAX_SUB_AUTHORITIES;
+}
+
+/*
+ * Returns true if the encoder can write @ace. An object ACE must have an
+ * object section whose length matches its Flags, and any other ACE must
+ * have no object section.
+ */
+static bool sd_ace_fits(const struct ksmbd_ace *ace)
+{
+	enum sd_ace_layout layout = sd_ace_layout(ace->type);
+	u32 obj_flags;
+
+	if (layout == SD_ACE_NONE || !ace->sid || !sd_sid_fits(ace->sid) ||
+	    ace->data_len % SD_ALIGN || (ace->data_len && !ace->data))
+		return false;
+	if (layout != SD_ACE_OBJECT)
+		return !ace->obj_len;
+	if (!ace->obj || ace->obj_len < sizeof(obj_flags))
+		return false;
+	obj_flags = get_unaligned_le32(ace->obj);
+	return !(obj_flags & ~(u32)SD_OBJ_GUID_FLAGS) &&
+	       ace->obj_len == sd_obj_len(obj_flags);
+}
+
+static size_t sd_ace_size(const struct ksmbd_ace *ace)
+{
+	return SD_ACE_HDR_SIZE + ace->obj_len +
+	       sd_sid_len(ace->sid->num_subauth) + ace->data_len;
+}
+
+/*
+ * Returns true if the SACL bytes are exactly one ACL that the decoder would
+ * accept, with nothing after it.
+ */
+static bool sd_sacl_fits(const struct ksmbd_sd *sd)
+{
+	struct sd_in sacl = { .len = sd->sacl_len, .p = sd->sacl_data };
+	const u8 *p;
+
+	if (!sd->sacl_data || sd_check_acl(&sacl))
+		return false;
+	p = sd_in_at(&sacl, offsetof(struct smb_acl, size), sizeof(__le16));
+	return p && get_unaligned_le16(p) == sd->sacl_len;
+}
+
+static int __must_check sd_lay_out(const struct ksmbd_sd *sd,
+				   struct sd_layout *layout)
+{
+	size_t off = sizeof(struct smb_ntsd), dacl_size = sizeof(struct smb_acl);
+	unsigned int i;
+	size_t size;
+
+	*layout = (struct sd_layout){};
+	if (sd->control & SD_CONTROL_DERIVED)
+		return -EINVAL;
+	if ((sd->owner && !sd_sid_fits(sd->owner)) ||
+	    (sd->group && !sd_sid_fits(sd->group)))
+		return -EINVAL;
+	if (sd->dacl > KSMBD_ACL_PRESENT ||
+	    (sd->dacl != KSMBD_ACL_PRESENT && sd->num_aces))
+		return -EINVAL;
+	if (sd->dacl_revision && sd->dacl_revision != SD_ACL_REVISION &&
+	    sd->dacl_revision != SD_ACL_REVISION_DS)
+		return -EINVAL;
+	if (sd->sacl > KSMBD_ACL_PRESENT ||
+	    (sd->sacl != KSMBD_ACL_PRESENT && sd->sacl_len) ||
+	    (sd->sacl == KSMBD_ACL_PRESENT && !sd_sacl_fits(sd)))
+		return -EINVAL;
+
+	for (i = 0; i < sd->num_aces; i++) {
+		const struct ksmbd_ace *ace = &sd->aces[i];
+
+		if (!sd_ace_fits(ace))
+			return -EINVAL;
+		size = sd_ace_size(ace);
+		if (size > U16_MAX - dacl_size)
+			return -E2BIG;
+		dacl_size += size;
+		if (ace->obj_len)
+			layout->object = true;
+	}
+	if (sd->dacl_revision == SD_ACL_REVISION_DS)
+		layout->object = true;
+
+	if (sd->owner) {
+		layout->owner_off = off;
+		off += sd_sid_len(sd->owner->num_subauth);
+	}
+	if (sd->group) {
+		layout->group_off = off;
+		off += sd_sid_len(sd->group->num_subauth);
+	}
+	if (sd->dacl == KSMBD_ACL_PRESENT) {
+		layout->dacl_size = dacl_size;
+		layout->dacl_off = off;
+		off += dacl_size;
+	}
+	if (sd->sacl == KSMBD_ACL_PRESENT) {
+		layout->sacl_off = off;
+		off += ALIGN(sd->sacl_len, SD_ALIGN);
+	}
+	layout->total = off;
+	return 0;
+}
+
+static void sd_put_header(struct sd_writer *writer, const struct ksmbd_sd *sd,
+			  const struct sd_layout *layout)
+{
+	u16 control = SELF_RELATIVE | sd->control;
+	struct smb_ntsd hdr;
+
+	if (sd->dacl != KSMBD_ACL_ABSENT)
+		control |= DACL_PRESENT;
+	if (sd->sacl != KSMBD_ACL_ABSENT)
+		control |= SACL_PRESENT;
+	hdr = (struct smb_ntsd){
+		.revision = cpu_to_le16(SD_REVISION | sd->sbz1 << SD_SBZ1_SHIFT),
+		.type = cpu_to_le16(control),
+		.osidoffset = cpu_to_le32(layout->owner_off),
+		.gsidoffset = cpu_to_le32(layout->group_off),
+		.sacloffset = cpu_to_le32(layout->sacl_off),
+		.dacloffset = cpu_to_le32(layout->dacl_off),
+	};
+	sd_put(writer, &hdr, sizeof(hdr));
+}
+
+static void sd_put_ace(struct sd_writer *writer, const struct ksmbd_ace *ace)
+{
+	size_t sid_len = sd_sid_len(ace->sid->num_subauth);
+	size_t size = sd_ace_size(ace);
+	u8 *p;
+
+	if (writer->bad)
+		return;
+	if (WARN_ON_ONCE(writer->pos > writer->cap ||
+			 size > writer->cap - writer->pos)) {
+		writer->bad = true;
+		return;
+	}
+	p = &writer->p[writer->pos];
+	p[offsetof(struct smb_ace, type)] = ace->type;
+	p[offsetof(struct smb_ace, flags)] = ace->flags;
+	put_unaligned_le16(size, &p[offsetof(struct smb_ace, size)]);
+	put_unaligned_le32(ace->mask, &p[offsetof(struct smb_ace, access_req)]);
+	p += SD_ACE_HDR_SIZE;
+	if (ace->obj_len) {
+		memcpy(p, ace->obj, ace->obj_len);
+		p += ace->obj_len;
+	}
+	memcpy(p, ace->sid, sid_len);
+	if (ace->data_len)
+		memcpy(p + sid_len, ace->data, ace->data_len);
+	writer->pos += size;
+}
+
+static void sd_put_dacl(struct sd_writer *writer, const struct ksmbd_sd *sd,
+			const struct sd_layout *layout)
+{
+	u16 rev = layout->object ? SD_ACL_REVISION_DS : SD_ACL_REVISION;
+	const struct smb_acl acl = {
+		.revision = cpu_to_le16(rev | sd->dacl_sbz1 << SD_SBZ1_SHIFT),
+		.size = cpu_to_le16(layout->dacl_size),
+		.num_aces = cpu_to_le16(sd->num_aces),
+		.reserved = cpu_to_le16(sd->dacl_sbz2),
+	};
+	unsigned int i;
+
+	sd_put(writer, &acl, sizeof(acl));
+	for (i = 0; i < sd->num_aces; i++)
+		sd_put_ace(writer, &sd->aces[i]);
+}
+
+/**
+ * ksmbd_sd_encode() - encode a security descriptor
+ * @sd:		the SD to encode, which must not change during the call
+ * @buf:	set to the encoded SD on success and to NULL on error. The
+ *		caller frees it with kvfree().
+ * @len:	set to the length of *@buf in bytes on success and to 0 on
+ *		error
+ *
+ * The owner and the group are written if @sd has them. An ACL is written
+ * if its state is KSMBD_ACL_PRESENT.
+ *
+ * The Control field is written as the bits in @sd plus SELF_RELATIVE, plus
+ * DACL_PRESENT and SACL_PRESENT for each ACL whose state is not
+ * KSMBD_ACL_ABSENT.
+ *
+ * The DACL is written with revision 4 if it contains an object ACE or if
+ * dacl_revision in @sd is 4, and with revision 2 otherwise.
+ *
+ * Return:
+ * * 0 - success
+ * * -EINVAL - @sd is not valid. It has a field that is out of range, an ACE
+ *   with no SID, a SID, ACE, or SACL that the decoder would refuse, or ACEs
+ *   or SACL bytes for an ACL whose state is not KSMBD_ACL_PRESENT.
+ * * -E2BIG - the DACL would be larger than U16_MAX bytes
+ * * -ENOMEM - the output buffer could not be allocated
+ * * -EIO - the bytes written do not match the layout that was computed,
+ *   which means a bug in the encoder or a change to @sd during the call.
+ *   A warning is logged.
+ */
+int ksmbd_sd_encode(const struct ksmbd_sd *sd, u8 **buf, size_t *len)
+{
+	struct sd_layout layout;
+	struct sd_writer writer;
+	u8 *bytes;
+	int rc;
+
+	*buf = NULL;
+	*len = 0;
+	rc = sd_lay_out(sd, &layout);
+	if (rc)
+		return rc;
+	bytes = kvzalloc(layout.total, KSMBD_DEFAULT_GFP);
+	if (!bytes)
+		return -ENOMEM;
+	writer = (struct sd_writer){ .cap = layout.total, .p = bytes };
+	sd_put_header(&writer, sd, &layout);
+	if (layout.owner_off)
+		sd_put(&writer, sd->owner, sd_sid_len(sd->owner->num_subauth));
+	if (layout.group_off)
+		sd_put(&writer, sd->group, sd_sid_len(sd->group->num_subauth));
+	if (layout.dacl_off)
+		sd_put_dacl(&writer, sd, &layout);
+	if (layout.sacl_off) {
+		sd_put(&writer, sd->sacl_data, sd->sacl_len);
+		/* The padding is already zero, because the buffer was zeroed */
+		writer.pos = ALIGN(writer.pos, SD_ALIGN);
+	}
+	if (WARN_ON_ONCE(writer.bad || writer.pos != layout.total)) {
+		kvfree(bytes);
+		return -EIO;
+	}
+	*buf = bytes;
+	*len = layout.total;
+	return 0;
+}
+EXPORT_SYMBOL_IF_KUNIT(ksmbd_sd_encode);
diff --git a/fs/smb/server/secdesc.h b/fs/smb/server/secdesc.h
new file mode 100644
index 000000000000..32675d2b0c8d
--- /dev/null
+++ b/fs/smb/server/secdesc.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* Security descriptor decoder and encoder (MS-DTYP 2.4.6) */
+
+#ifndef __KSMBD_SECDESC_H
+#define __KSMBD_SECDESC_H
+
+#include <linux/types.h>
+
+#include "../common/smbacl.h"
+
+enum ksmbd_acl_state {
+	KSMBD_ACL_ABSENT,	/* DACL_PRESENT or SACL_PRESENT is clear */
+	KSMBD_ACL_NULL,		/* the bit is set and there is no ACL */
+	KSMBD_ACL_PRESENT,	/* the bit is set and there is an ACL */
+};
+
+struct ksmbd_ace {
+	u8	type;
+	u8	flags;
+	u32	mask;
+	const struct smb_sid *sid;
+
+	/*
+	 * Kept for the encoder, as ksmbd reads neither: the Flags and GUIDs
+	 * of an object type (MS-DTYP 2.4.4.3), and what follows the SID,
+	 * such as the ApplicationData of a callback type. An ACE is of an
+	 * object type if and only if @obj_len is not 0.
+	 */
+	const u8 *obj __counted_by_ptr(obj_len);
+	const u8 *data __counted_by_ptr(data_len);
+	u16	obj_len;
+	u16	data_len;
+};
+
+struct ksmbd_sd {
+	const struct smb_sid *owner;
+	const struct smb_sid *group;
+	/*
+	 * The Control bits other than SELF_RELATIVE, DACL_PRESENT, and
+	 * SACL_PRESENT. The encoder sets those three itself.
+	 */
+	u16	control;
+	enum ksmbd_acl_state dacl;
+
+	/* Kept for the encoder, as ksmbd reads none of these */
+	const u8 *sacl_data __counted_by_ptr(sacl_len);
+	u16	sacl_len;
+	enum ksmbd_acl_state sacl;
+	u8	sbz1;
+	u8	dacl_revision;
+	u8	dacl_sbz1;
+	u16	dacl_sbz2;
+
+	/* The decoder left out a SACL that was malformed */
+	bool	sacl_dropped;
+
+	unsigned int num_aces;		/* of the DACL */
+	struct ksmbd_ace aces[] __counted_by(num_aces);
+};
+
+int __must_check ksmbd_sd_decode(const u8 *buf, size_t len,
+				 struct ksmbd_sd **out);
+int __must_check ksmbd_sd_encode(const struct ksmbd_sd *sd, u8 **buf,
+				 size_t *len);
+
+#endif /* __KSMBD_SECDESC_H */
diff --git a/fs/smb/server/tests/Makefile b/fs/smb/server/tests/Makefile
index 8738ab0b0667..753b09cde4a7 100644
--- a/fs/smb/server/tests/Makefile
+++ b/fs/smb/server/tests/Makefile
@@ -2,3 +2,6 @@
 # Copyright (C) 2026 Hang Nan <nanx95726@gmail.com>
 
 obj-$(CONFIG_SMB_SERVER_KUNIT_TESTS) += smbacl_kunit.o
+
+ksmbd_secdesc_kunit-y := secdesc_kunit.o
+obj-$(CONFIG_SMB_SERVER_KUNIT_TESTS) += ksmbd_secdesc_kunit.o
diff --git a/fs/smb/server/tests/secdesc_kunit.c b/fs/smb/server/tests/secdesc_kunit.c
new file mode 100644
index 000000000000..4308ffcce978
--- /dev/null
+++ b/fs/smb/server/tests/secdesc_kunit.c
@@ -0,0 +1,879 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit tests for the security descriptor decoder and encoder.
+ *
+ * The SDs are fixed bytes. Most cases use base_sd. t_base_fields() gives the
+ * same SD as a struct ksmbd_sd filled in by hand, and a malformed SD is
+ * base_sd with one byte changed.
+ *
+ * base_sd and its parts come first, then the helpers, and then the test
+ * cases in the order they run. The data that only one case uses is just
+ * above that case.
+ */
+
+#include <kunit/test.h>
+#include <linux/array_size.h>
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+#include <asm/byteorder.h>
+
+#include "../smbacl.h"
+#include "../secdesc.h"
+
+/*
+ * Offsets of the fields in the structures of MS-DTYP 2.4.6, 2.4.5, 2.4.4,
+ * and 2.4.2.2
+ */
+enum {
+	O_SD_REVISION = 0, O_SD_CONTROL = 2, O_SD_OWNER = 4, O_SD_GROUP = 8,
+	O_SD_SACL = 12, O_SD_DACL = 16, O_SD_HDR_LEN = 20,
+	O_ACL_REVISION = 0, O_ACL_SIZE = 2, O_ACL_COUNT = 4, O_ACL_HDR_LEN = 8,
+	O_ACE_TYPE = 0, O_ACE_SIZE = 2, O_ACE_MASK = 4, O_ACE_OBJ_FLAGS = 8,
+	O_SID_REVISION = 0, O_SID_COUNT = 1, O_SID_AUTHORITY = 7,
+};
+
+/*
+ * An SD with every part: an owner, a group, a DACL with a plain allow ACE,
+ * a plain deny ACE, an object ACE and a callback ACE, and a SACL with an
+ * audit ACE and a label ACE. It is laid out as the encoder writes an SD,
+ * which is owner, group, DACL, and SACL.
+ */
+static const u8 base_sd[] = {
+	/*
+	 * the header: Control SR|DI|SP|DP, owner at 20, group at 48, SACL
+	 * at 204, DACL at 76
+	 */
+	0x01, 0x00, 0x14, 0x84, 0x14, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00,
+	0xcc, 0x00, 0x00, 0x00, 0x4c, 0x00, 0x00, 0x00,
+	/* the owner S-1-5-21-1-2-3-1000 */
+	0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0xe8, 0x03, 0x00, 0x00,
+	/* the group S-1-5-21-1-2-3-513 */
+	0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x01, 0x02, 0x00, 0x00,
+	/* the DACL: revision 4, 128 bytes, 4 ACEs */
+	0x04, 0x00, 0x80, 0x00, 0x04, 0x00, 0x00, 0x00,
+	/* allow, OI|CI, 36 bytes, 0x1f01ff, S-1-5-21-1-2-3-1000 */
+	0x00, 0x03, 0x24, 0x00, 0xff, 0x01, 0x1f, 0x00, 0x01, 0x05, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xe8, 0x03, 0x00, 0x00,
+	/* deny, 20 bytes, 0x2, S-1-1-0 */
+	0x01, 0x00, 0x14, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	/* allow object, 40 bytes, 0x10, Flags 1 and a GUID, S-1-1-0 */
+	0x05, 0x00, 0x28, 0x00, 0x10, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
+	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b,
+	0x3c, 0x3d, 0x3e, 0x3f, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
+	0x00, 0x00, 0x00, 0x00,
+	/* allow callback, 24 bytes, 0x1, S-1-1-0, 4 bytes of data */
+	0x09, 0x00, 0x18, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/* the SACL: revision 2, 48 bytes, 2 ACEs */
+	0x02, 0x00, 0x30, 0x00, 0x02, 0x00, 0x00, 0x00,
+	/* audit, 0x80, 20 bytes, 0x10000, S-1-1-0 */
+	0x02, 0x80, 0x14, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	/* mandatory label, 20 bytes, 0x1, S-1-16-8192 */
+	0x11, 0x00, 0x14, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x10, 0x00, 0x20, 0x00, 0x00,
+};
+
+/* Where the parts of base_sd start */
+enum {
+	B_OWNER	= 20,
+	B_DACL	= 76,
+	B_ACE0	= 84,
+	B_ACE1	= 120,
+	B_ACE2	= 140,
+	B_ACE3	= 180,
+	B_SACL	= 204,
+	B_SACE0	= 212,
+};
+
+static const struct smb_sid base_owner = {
+	1, 5, {0, 0, 0, 0, 0, 5},
+	{cpu_to_le32(21), cpu_to_le32(1), cpu_to_le32(2), cpu_to_le32(3),
+	 cpu_to_le32(1000)} };
+static const struct smb_sid base_group = {
+	1, 5, {0, 0, 0, 0, 0, 5},
+	{cpu_to_le32(21), cpu_to_le32(1), cpu_to_le32(2), cpu_to_le32(3),
+	 cpu_to_le32(513)} };
+static const struct smb_sid everyone = { 1, 1, {0, 0, 0, 0, 0, 1}, {0} };
+
+/* The object section of ACE 2 of base_sd: Flags 1 and one GUID */
+static const u8 base_obj[20] = {
+	0x01, 0x00, 0x00, 0x00,
+	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+	0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
+};
+
+/* The data after the SID of ACE 3 of base_sd (MS-DTYP 2.4.4.17) */
+static const u8 base_data[4] = { 'a', 'r', 't', 'x' };
+
+static void t_sd_free(void *sd)
+{
+	kvfree(sd);
+}
+
+/* Arranges for @sd to be freed when the test case ends, and returns it */
+static struct ksmbd_sd *t_keep_sd(struct kunit *test, struct ksmbd_sd *sd)
+{
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, t_sd_free, sd), 0);
+	return sd;
+}
+
+/*
+ * Returns a zeroed SD with room for @num_aces ACEs. It is freed when the
+ * test case ends.
+ */
+static struct ksmbd_sd *t_alloc(struct kunit *test, size_t num_aces)
+{
+	struct ksmbd_sd *sd = kvzalloc(struct_size(sd, aces, num_aces), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, sd);
+	sd->num_aces = num_aces;
+	return t_keep_sd(test, sd);
+}
+
+/* Returns a copy of base_sd that a test can change */
+static u8 *t_base_copy(struct kunit *test)
+{
+	u8 *buf = kunit_kzalloc(test, sizeof(base_sd), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+	memcpy(buf, base_sd, sizeof(base_sd));
+	return buf;
+}
+
+/* Returns base_sd as a caller of the encoder would fill it in */
+static struct ksmbd_sd *t_base_fields(struct kunit *test)
+{
+	struct ksmbd_sd *sd = t_alloc(test, 4);
+
+	sd->owner = &base_owner;
+	sd->group = &base_group;
+	sd->control = DACL_AUTO_INHERITED;
+	sd->dacl = KSMBD_ACL_PRESENT;
+	sd->dacl_revision = 4;
+	sd->aces[0] = (struct ksmbd_ace){
+		.type = ACCESS_ALLOWED_ACE_TYPE,
+		.flags = OBJECT_INHERIT_ACE | CONTAINER_INHERIT_ACE,
+		.mask = 0x001f01ff, .sid = &base_owner,
+	};
+	sd->aces[1] = (struct ksmbd_ace){
+		.type = ACCESS_DENIED_ACE_TYPE, .mask = 0x2, .sid = &everyone,
+	};
+	sd->aces[2] = (struct ksmbd_ace){
+		.type = ACCESS_ALLOWED_OBJECT_ACE_TYPE, .mask = 0x10,
+		.sid = &everyone, .obj_len = sizeof(base_obj), .obj = base_obj,
+	};
+	sd->aces[3] = (struct ksmbd_ace){
+		.type = ACCESS_ALLOWED_CALLBACK_ACE_TYPE, .mask = 0x1,
+		.sid = &everyone, .data_len = sizeof(base_data), .data = base_data,
+	};
+	sd->sacl = KSMBD_ACL_PRESENT;
+	sd->sacl_len = sizeof(base_sd) - B_SACL;
+	sd->sacl_data = &base_sd[B_SACL];
+	return sd;
+}
+
+/* Decodes bytes that the decoder must accept with nothing left out */
+static struct ksmbd_sd *t_decode(struct kunit *test, const u8 *buf, size_t len)
+{
+	struct ksmbd_sd *sd = NULL;
+
+	KUNIT_ASSERT_EQ(test, ksmbd_sd_decode(buf, len, &sd), 0);
+	KUNIT_ASSERT_NOT_NULL(test, sd);
+	KUNIT_EXPECT_FALSE(test, sd->sacl_dropped);
+	return t_keep_sd(test, sd);
+}
+
+/*
+ * Calls the encoder and returns what it returns. On an error the encoder
+ * must leave no buffer and a length of 0.
+ */
+static int t_try_encode(struct kunit *test, const struct ksmbd_sd *sd)
+{
+	u8 *buf = (u8 *)sd;
+	size_t len = 7;
+	int rc = ksmbd_sd_encode(sd, &buf, &len);
+
+	if (rc) {
+		KUNIT_EXPECT_NULL(test, buf);
+		KUNIT_EXPECT_EQ(test, len, 0);
+	} else {
+		kvfree(buf);
+	}
+	return rc;
+}
+
+/* Expects the encoder to write exactly @want for @sd */
+static void t_expect_encoding(struct kunit *test, const struct ksmbd_sd *sd,
+			      const u8 *want, size_t want_len)
+{
+	size_t len = 0;
+	u8 *buf = NULL;
+	int rc = ksmbd_sd_encode(sd, &buf, &len);
+
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	if (!rc) {
+		KUNIT_EXPECT_EQ(test, len, want_len);
+		if (len == want_len)
+			KUNIT_EXPECT_MEMEQ(test, buf, want, len);
+	}
+	kvfree(buf);
+}
+
+/* Returns true if both are the same SID, or if neither is there */
+static bool t_sid_same(const struct smb_sid *sid, const struct smb_sid *want)
+{
+	if (!sid || !want)
+		return sid == want;
+	return sid->num_subauth == want->num_subauth &&
+	       !memcmp(sid, want, CIFS_SID_BASE_SIZE + 4 * want->num_subauth);
+}
+
+/*
+ * Returns true if both are the same bytes. A pointer with no bytes behind
+ * it has to be NULL.
+ */
+static bool t_bytes_same(const u8 *p, size_t len, const u8 *want, size_t want_len)
+{
+	return len == want_len && !p == !len && (!len || !memcmp(p, want, len));
+}
+
+/*
+ * Expects @sd to have the fields of @want, and the same bytes behind each
+ * pointer
+ */
+static void t_expect_same(struct kunit *test, const struct ksmbd_sd *sd,
+			  const struct ksmbd_sd *want)
+{
+	unsigned int i;
+
+	KUNIT_EXPECT_TRUE(test, t_sid_same(sd->owner, want->owner));
+	KUNIT_EXPECT_TRUE(test, t_sid_same(sd->group, want->group));
+	KUNIT_EXPECT_EQ(test, sd->control, want->control);
+	KUNIT_EXPECT_EQ(test, sd->sbz1, want->sbz1);
+	KUNIT_EXPECT_EQ(test, (int)sd->dacl, (int)want->dacl);
+	KUNIT_EXPECT_EQ(test, sd->dacl_revision, want->dacl_revision);
+	KUNIT_EXPECT_EQ(test, sd->dacl_sbz1, want->dacl_sbz1);
+	KUNIT_EXPECT_EQ(test, sd->dacl_sbz2, want->dacl_sbz2);
+	KUNIT_EXPECT_EQ(test, (int)sd->sacl, (int)want->sacl);
+	KUNIT_EXPECT_EQ(test, sd->sacl_dropped, want->sacl_dropped);
+	KUNIT_EXPECT_TRUE(test, t_bytes_same(sd->sacl_data, sd->sacl_len,
+					     want->sacl_data, want->sacl_len));
+	KUNIT_ASSERT_EQ(test, sd->num_aces, want->num_aces);
+	for (i = 0; i < sd->num_aces; i++) {
+		const struct ksmbd_ace *a = &sd->aces[i], *w = &want->aces[i];
+
+		KUNIT_EXPECT_TRUE_MSG(test, a->type == w->type &&
+				      a->flags == w->flags && a->mask == w->mask &&
+				      t_sid_same(a->sid, w->sid), "ACE %u", i);
+		KUNIT_EXPECT_TRUE_MSG(test, t_bytes_same(a->obj, a->obj_len,
+							 w->obj, w->obj_len),
+				      "object section of ACE %u", i);
+		KUNIT_EXPECT_TRUE_MSG(test, t_bytes_same(a->data, a->data_len,
+							 w->data, w->data_len),
+				      "data of ACE %u", i);
+	}
+}
+
+/*
+ * Decode base_sd and compare the result with t_base_fields(). Then encode
+ * the struct of t_base_fields(), which no decoder made, and compare the
+ * bytes with base_sd.
+ */
+static void ksmbd_sd_decode_encode_base_test(struct kunit *test)
+{
+	struct ksmbd_sd *want = t_base_fields(test);
+
+	t_expect_same(test, t_decode(test, base_sd, sizeof(base_sd)), want);
+	t_expect_encoding(test, want, base_sd, sizeof(base_sd));
+}
+
+/*
+ * base_sd in another layout that MS-DTYP 2.4.6 allows. The parts are in
+ * the order SACL, DACL, owner, and group, with unused bytes between them
+ * and after the last ACE of the DACL, and the DACL has revision 2 although
+ * it holds an object ACE. It decodes to the same SD as base_sd.
+ */
+static const u8 base_other_layout[] = {
+	/*
+	 * the header: Control SR|DI|SP|DP, owner at 205, group at 241, SACL
+	 * at 20, DACL at 71
+	 */
+	0x01, 0x00, 0x14, 0x84, 0xcd, 0x00, 0x00, 0x00, 0xf1, 0x00, 0x00, 0x00,
+	0x14, 0x00, 0x00, 0x00, 0x47, 0x00, 0x00, 0x00,
+	/* the SACL: revision 2, 48 bytes, 2 ACEs */
+	0x02, 0x00, 0x30, 0x00, 0x02, 0x00, 0x00, 0x00,
+	/* audit, 0x80, 20 bytes, 0x10000, S-1-1-0 */
+	0x02, 0x80, 0x14, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	/* mandatory label, 20 bytes, 0x1, S-1-16-8192 */
+	0x11, 0x00, 0x14, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x10, 0x00, 0x20, 0x00, 0x00,
+	/* 3 unused bytes */
+	0xa5, 0xa5, 0xa5,
+	/* the DACL: revision 2, 134 bytes, 4 ACEs */
+	0x02, 0x00, 0x86, 0x00, 0x04, 0x00, 0x00, 0x00,
+	/* allow, OI|CI, 36 bytes, 0x1f01ff, S-1-5-21-1-2-3-1000 */
+	0x00, 0x03, 0x24, 0x00, 0xff, 0x01, 0x1f, 0x00, 0x01, 0x05, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xe8, 0x03, 0x00, 0x00,
+	/* deny, 20 bytes, 0x2, S-1-1-0 */
+	0x01, 0x00, 0x14, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	/* allow object, 40 bytes, 0x10, Flags 1 and a GUID, S-1-1-0 */
+	0x05, 0x00, 0x28, 0x00, 0x10, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
+	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b,
+	0x3c, 0x3d, 0x3e, 0x3f, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
+	0x00, 0x00, 0x00, 0x00,
+	/* allow callback, 24 bytes, 0x1, S-1-1-0, 4 bytes of data */
+	0x09, 0x00, 0x18, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/* 6 unused bytes of the DACL */
+	0xee, 0xee, 0xee, 0xee, 0xee, 0xee,
+	/* the owner S-1-5-21-1-2-3-1000 */
+	0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0xe8, 0x03, 0x00, 0x00,
+	/* 8 unused bytes */
+	0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5, 0xa5,
+	/* the group S-1-5-21-1-2-3-513 */
+	0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x01, 0x02, 0x00, 0x00,
+	/* 5 unused bytes */
+	0xa5, 0xa5, 0xa5, 0xa5, 0xa5,
+};
+
+/*
+ * DACL_PRESENT with no DACL, and OWNER_DEFAULTED and GROUP_DEFAULTED with no
+ * SID
+ */
+static const u8 null_dacl_sd[] = {
+	/*
+	 * the header: Control SR|DP|GD|OD, no owner, no group, no SACL, no
+	 * DACL
+	 */
+	0x01, 0x00, 0x07, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+/* No DACL, an owner, a nonzero Sbz1, and every Control bit that is kept */
+static const u8 no_dacl_sd[] = {
+	/*
+	 * the header: Control 0xffeb, Sbz1 0x5a, owner at 20, no group, no
+	 * SACL, no DACL
+	 */
+	0x01, 0x5a, 0xeb, 0xff, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	/* the owner S-1-5-21-1-2-3-1000 */
+	0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0xe8, 0x03, 0x00, 0x00,
+};
+
+/* A group, a DACL with no ACE, and SACL_PRESENT with no SACL */
+static const u8 empty_dacl_sd[] = {
+	/*
+	 * the header: Control SR|SP|DP, no owner, group at 20, no SACL,
+	 * DACL at 48
+	 */
+	0x01, 0x00, 0x14, 0x80, 0x00, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00,
+	/* the group S-1-5-21-1-2-3-513 */
+	0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x15, 0x00, 0x00, 0x00,
+	0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x01, 0x02, 0x00, 0x00,
+	/* the DACL: revision 2, 8 bytes, 0 ACEs */
+	0x02, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+/*
+ * An owner and a group with 15 sub-authorities each, ACEs whose SIDs have
+ * none and 15, and an empty SACL with two unused bytes
+ */
+static const u8 sids_sd[] = {
+	/*
+	 * the header: Control SR|SP|DP, owner at 20, group at 88, SACL at
+	 * 256, DACL at 156
+	 */
+	0x01, 0x00, 0x14, 0x80, 0x14, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00,
+	0x00, 0x01, 0x00, 0x00, 0x9c, 0x00, 0x00, 0x00,
+	/* the owner S-1-5-1-2-3-4-5-6-7-8-9-10-11-12-13-14-15 */
+	0x01, 0x0f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x01, 0x00, 0x00, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00,
+	0x05, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00,
+	0x08, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x00,
+	0x0b, 0x00, 0x00, 0x00, 0x0c, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x00,
+	0x0e, 0x00, 0x00, 0x00, 0x0f, 0x00, 0x00, 0x00,
+	/* the group S-1-5-1-2-3-4-5-6-7-8-9-10-11-12-13-14-15 */
+	0x01, 0x0f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05, 0x01, 0x00, 0x00, 0x00,
+	0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00,
+	0x05, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00,
+	0x08, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x00,
+	0x0b, 0x00, 0x00, 0x00, 0x0c, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x00,
+	0x0e, 0x00, 0x00, 0x00, 0x0f, 0x00, 0x00, 0x00,
+	/* the DACL: revision 2, 100 bytes, 2 ACEs */
+	0x02, 0x00, 0x64, 0x00, 0x02, 0x00, 0x00, 0x00,
+	/* allow, 16 bytes, 0x1, S-1-5 */
+	0x00, 0x00, 0x10, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x05,
+	/* deny, 76 bytes, 0x2, S-1-5-1-2-3-4-5-6-7-8-9-10-11-12-13-14-15 */
+	0x01, 0x00, 0x4c, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x0f, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x05, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
+	0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00,
+	0x06, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00,
+	0x09, 0x00, 0x00, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x00, 0x00,
+	0x0c, 0x00, 0x00, 0x00, 0x0d, 0x00, 0x00, 0x00, 0x0e, 0x00, 0x00, 0x00,
+	0x0f, 0x00, 0x00, 0x00,
+	/* the SACL: revision 2, 10 bytes, 0 ACEs */
+	0x02, 0x00, 0x0a, 0x00, 0x00, 0x00, 0x00, 0x00,
+	/* 2 unused bytes of the SACL */
+	0xee, 0xee,
+	/* 2 unused bytes */
+	0x00, 0x00,
+};
+
+/*
+ * A plain ACE with data after its SID and with the one AceFlags bit that
+ * MS-DTYP 2.4.4.1 does not define (0x20), and nonzero reserved fields in
+ * the DACL
+ */
+static const u8 ace_fields_sd[] = {
+	/* the header: Control SR|DP, no owner, no group, no SACL, DACL at 20 */
+	0x01, 0x00, 0x04, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00,
+	/* the DACL: revision 2, 52 bytes, 2 ACEs, Sbz1 7, Sbz2 0x1234 */
+	0x02, 0x07, 0x34, 0x00, 0x02, 0x00, 0x34, 0x12,
+	/* allow, 0xa0, 24 bytes, 0x120089, S-1-1-0, 4 bytes of data */
+	0x00, 0xa0, 0x18, 0x00, 0x89, 0x00, 0x12, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/* deny, CI|IO, 20 bytes, 0x10000, S-1-3-4 */
+	0x01, 0x0a, 0x14, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x00, 0x00,
+};
+
+/*
+ * The object and callback layouts (MS-DTYP 2.4.4.3 and 2.4.4.5 to 2.4.4.9):
+ * object ACEs with no GUID, one GUID of each kind, and both, with and
+ * without data
+ */
+static const u8 layouts_sd[] = {
+	/* the header: Control SR|DP, no owner, no group, no SACL, DACL at 20 */
+	0x01, 0x00, 0x04, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00,
+	/* the DACL: revision 4, 220 bytes, 6 ACEs */
+	0x04, 0x00, 0xdc, 0x00, 0x06, 0x00, 0x00, 0x00,
+	/* deny object, 24 bytes, 0x1, Flags 0 and no GUID, S-1-3-4 */
+	0x06, 0x00, 0x18, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x00, 0x00,
+	/*
+	 * allow callback object, 60 bytes, 0x2, Flags 3 and two GUIDs,
+	 * S-1-1-0, 4 bytes of data
+	 */
+	0x0b, 0x00, 0x3c, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00,
+	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b,
+	0x3c, 0x3d, 0x3e, 0x3f, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47,
+	0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/* deny callback, 24 bytes, 0x4, S-1-1-0, 4 bytes of data */
+	0x0a, 0x00, 0x18, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/*
+	 * deny callback object, 28 bytes, 0x8, Flags 0 and no GUID,
+	 * S-1-1-0, 4 bytes of data
+	 */
+	0x0c, 0x00, 0x1c, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	0x61, 0x72, 0x74, 0x78,
+	/*
+	 * allow object, 56 bytes, 0x10, Flags 2 and a GUID,
+	 * S-1-5-21-1-2-3-1000
+	 */
+	0x05, 0x00, 0x38, 0x00, 0x10, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
+	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b,
+	0x4c, 0x4d, 0x4e, 0x4f, 0x01, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05,
+	0x15, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
+	0x03, 0x00, 0x00, 0x00, 0xe8, 0x03, 0x00, 0x00,
+	/* allow, 20 bytes, 0x20, S-1-3-4 */
+	0x00, 0x00, 0x14, 0x00, 0x20, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x03, 0x04, 0x00, 0x00, 0x00,
+};
+
+/*
+ * The seven ACE types meant for a SACL (MS-DTYP 2.4.4.10 to 2.4.4.16), in a
+ * DACL
+ */
+static const u8 sacl_types_sd[] = {
+	/* the header: Control SR|DP, no owner, no group, no SACL, DACL at 20 */
+	0x01, 0x00, 0x04, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00,
+	/* the DACL: revision 4, 184 bytes, 7 ACEs */
+	0x04, 0x00, 0xb8, 0x00, 0x07, 0x00, 0x00, 0x00,
+	/* audit, 0xc0, 20 bytes, 0x10000, S-1-1-0 */
+	0x02, 0xc0, 0x14, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	/* audit object, 40 bytes, 0x1, Flags 2 and a GUID, S-1-1-0 */
+	0x07, 0x00, 0x28, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00,
+	0x40, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x4b,
+	0x4c, 0x4d, 0x4e, 0x4f, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,
+	0x00, 0x00, 0x00, 0x00,
+	/* audit callback, 24 bytes, 0x1, S-1-1-0, 4 bytes of data */
+	0x0d, 0x00, 0x18, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/*
+	 * audit callback object, 28 bytes, 0x1, Flags 0 and no GUID,
+	 * S-1-1-0, 4 bytes of data
+	 */
+	0x0f, 0x00, 0x1c, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	0x61, 0x72, 0x74, 0x78,
+	/* resource attribute, 24 bytes, 0x0, S-1-1-0, 4 bytes of data */
+	0x12, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x61, 0x72, 0x74, 0x78,
+	/* scoped policy, 20 bytes, 0x0, S-1-17-9 */
+	0x13, 0x00, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x11, 0x09, 0x00, 0x00, 0x00,
+	/* mandatory label, 20 bytes, 0x7, S-1-16-28672 */
+	0x11, 0x00, 0x14, 0x00, 0x07, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x10, 0x00, 0x70, 0x00, 0x00,
+};
+
+/*
+ * An SD the decoder accepts, with the states and ACE count it decodes to.
+ * The SDs are rows of a table so that one test function runs for each and
+ * KUnit reports each as its own case, by name.
+ */
+struct t_accept {
+	const char *name;
+	const u8 *sd;
+	size_t	len;
+	/* What the encoder writes for it, if not the same bytes */
+	const u8 *encoded;
+	size_t	encoded_len;
+	u8	dacl, sacl;
+	u16	num_aces;
+};
+
+static const struct t_accept accepts[] = {
+	{ .name = "2.4.6 any order and unused bytes, 2.4.5 revision 2",
+	  .sd = base_other_layout, .len = sizeof(base_other_layout),
+	  .encoded = base_sd, .encoded_len = sizeof(base_sd),
+	  .dacl = KSMBD_ACL_PRESENT, .sacl = KSMBD_ACL_PRESENT, .num_aces = 4 },
+	{ .name = "2.4.6 NULL DACL",
+	  .sd = null_dacl_sd, .len = sizeof(null_dacl_sd),
+	  .dacl = KSMBD_ACL_NULL, .sacl = KSMBD_ACL_ABSENT, .num_aces = 0 },
+	{ .name = "2.4.6 no DACL, every other Control bit",
+	  .sd = no_dacl_sd, .len = sizeof(no_dacl_sd),
+	  .dacl = KSMBD_ACL_ABSENT, .sacl = KSMBD_ACL_ABSENT, .num_aces = 0 },
+	{ .name = "2.4.5 empty DACL, NULL SACL",
+	  .sd = empty_dacl_sd, .len = sizeof(empty_dacl_sd),
+	  .dacl = KSMBD_ACL_PRESENT, .sacl = KSMBD_ACL_NULL, .num_aces = 0 },
+	{ .name = "2.4.2.2 0 and 15 sub-authorities, empty SACL",
+	  .sd = sids_sd, .len = sizeof(sids_sd),
+	  .dacl = KSMBD_ACL_PRESENT, .sacl = KSMBD_ACL_PRESENT, .num_aces = 2 },
+	{ .name = "2.4.4.1 ACE data, undefined AceFlags, reserved fields",
+	  .sd = ace_fields_sd, .len = sizeof(ace_fields_sd),
+	  .dacl = KSMBD_ACL_PRESENT, .sacl = KSMBD_ACL_ABSENT, .num_aces = 2 },
+	{ .name = "2.4.4 object and callback layouts",
+	  .sd = layouts_sd, .len = sizeof(layouts_sd),
+	  .dacl = KSMBD_ACL_PRESENT, .sacl = KSMBD_ACL_ABSENT, .num_aces = 6 },
+	{ .name = "2.4.4 SACL types in a DACL",
+	  .sd = sacl_types_sd, .len = sizeof(sacl_types_sd),
+	  .dacl = KSMBD_ACL_PRESENT, .sacl = KSMBD_ACL_ABSENT, .num_aces = 7 },
+};
+
+KUNIT_ARRAY_PARAM_DESC(accept, accepts, name);
+
+/*
+ * Each SD is decoded, and the decoded SD is encoded again. The encoder
+ * must write the same bytes, or the bytes given for an SD that is not laid
+ * out as the encoder lays one out. Nothing the SD holds may be lost on
+ * the way.
+ */
+static void ksmbd_sd_decode_accept_test(struct kunit *test)
+{
+	const struct t_accept *a = test->param_value;
+	struct ksmbd_sd *sd = t_decode(test, a->sd, a->len);
+
+	KUNIT_EXPECT_EQ(test, (int)sd->dacl, a->dacl);
+	KUNIT_EXPECT_EQ(test, (int)sd->sacl, a->sacl);
+	KUNIT_EXPECT_EQ(test, sd->num_aces, a->num_aces);
+	if (a->encoded)
+		t_expect_encoding(test, sd, a->encoded, a->encoded_len);
+	else
+		t_expect_encoding(test, sd, a->sd, a->len);
+}
+
+/* What changing one byte of base_sd is expected to do */
+enum t_effect {
+	REFUSED,	/* the decoder returns -EBADMSG */
+	NO_SACL,	/* the SD decodes without its SACL, and sacl_dropped is set */
+	SACL_UNREAD,	/* the SD decodes without its SACL, which was not read */
+	AS_BASE,	/* the SD decodes to base_sd, unchanged */
+};
+
+struct t_change {
+	const char *name;	/* the change and the MS-DTYP section it breaks */
+	u8	off;
+	u8	new;
+	u8	effect;
+};
+
+static const struct t_change changes[] = {
+	{ "2.4.6 Revision MUST be 1", O_SD_REVISION, 2, REFUSED },
+	{ "2.4.6 OffsetDacl inside the header", O_SD_DACL, 16, REFUSED },
+	{ "2.4.6 OffsetOwner past the end", O_SD_OWNER + 1, 1, REFUSED },
+	{ "2.4.6 OffsetDacl past the end", O_SD_DACL + 1, 1, REFUSED },
+	{ "2.4.6 OffsetDacl MUST be 0 without DP",
+	  O_SD_CONTROL, 0x10, REFUSED },
+	{ "2.4.2.2 owner SID Revision MUST be 1",
+	  B_OWNER + O_SID_REVISION, 2, REFUSED },
+	{ "2.4.2.2 owner SID more than 15 sub-authorities",
+	  B_OWNER + O_SID_COUNT, 16, REFUSED },
+	{ "2.4.5 DACL AclRevision 3", B_DACL + O_ACL_REVISION, 3, REFUSED },
+	{ "2.4.5 DACL AclSize below 8", B_DACL + O_ACL_SIZE, 4, REFUSED },
+	{ "2.4.5 DACL AclSize past the end",
+	  B_DACL + O_ACL_SIZE + 1, 1, REFUSED },
+	{ "2.4.5 DACL AceCount more than fits",
+	  B_DACL + O_ACL_COUNT, 8, REFUSED },
+	{ "2.4.5 DACL AceCount past its ACEs",
+	  B_DACL + O_ACL_COUNT, 5, REFUSED },
+	{ "2.4.4.1 AceSize not a multiple of 4", B_ACE3 + O_ACE_SIZE, 23, REFUSED },
+	{ "2.4.4.1 AceSize past AclSize", B_ACE3 + O_ACE_SIZE, 28, REFUSED },
+	{ "2.4.4.1 AceType above 0x13", B_ACE1 + O_ACE_TYPE, 0x14, REFUSED },
+	{ "2.4.4.1 AceType 0x03 reserved", B_ACE1 + O_ACE_TYPE, 0x03, REFUSED },
+	{ "2.4.4.1 ACE SID count runs past AceSize",
+	  B_ACE1 + 8 + O_SID_COUNT, 2, REFUSED },
+	{ "2.4.4.3 object GUIDs past AceSize",
+	  B_ACE2 + O_ACE_OBJ_FLAGS, 3, REFUSED },
+	{ "2.4.4.3 object ACE too short for its Flags",
+	  B_ACE2 + O_ACE_SIZE, 8, REFUSED },
+	{ "2.4.4.3 object Flags bit that names no GUID",
+	  B_ACE2 + O_ACE_OBJ_FLAGS, 5, REFUSED },
+
+	/* A malformed SACL is left out */
+	{ "2.4.6 OffsetSacl inside the header", O_SD_SACL, 12, NO_SACL },
+	{ "2.4.5 SACL AclRevision 0", B_SACL + O_ACL_REVISION, 0, NO_SACL },
+	{ "2.4.4.1 SACL AceSize not a multiple of 4",
+	  B_SACE0 + O_ACE_SIZE, 21, NO_SACL },
+	/* An OffsetSacl is not read when SACL_PRESENT is clear */
+	{ "2.4.6 OffsetSacl set without SP", O_SD_CONTROL, 0x04, SACL_UNREAD },
+
+	/*
+	 * Requirements that MS-DTYP states with MUST and the decoder does
+	 * not enforce
+	 */
+	{ "2.4.6 SR not set", O_SD_CONTROL + 1, 0x04, AS_BASE },
+};
+
+KUNIT_ARRAY_PARAM_DESC(change, changes, name);
+
+static void ksmbd_sd_decode_byte_change_test(struct kunit *test)
+{
+	const struct t_change *c = test->param_value;
+	struct ksmbd_sd *want = t_base_fields(test);
+	u8 *buf = t_base_copy(test);
+	struct ksmbd_sd *sd = (void *)1;
+	int rc;
+
+	/* A case whose new byte equals the old one would test nothing */
+	KUNIT_ASSERT_TRUE(test, buf[c->off] != c->new);
+	buf[c->off] = c->new;
+
+	rc = ksmbd_sd_decode(buf, sizeof(base_sd), &sd);
+	if (c->effect == REFUSED) {
+		KUNIT_EXPECT_EQ(test, rc, -EBADMSG);
+		KUNIT_EXPECT_NULL(test, sd);
+		if (!rc)
+			kvfree(sd);
+		return;
+	}
+	KUNIT_ASSERT_EQ(test, rc, 0);
+	t_keep_sd(test, sd);
+	if (c->effect != AS_BASE) {
+		want->sacl = KSMBD_ACL_ABSENT;
+		want->sacl_len = 0;
+		want->sacl_data = NULL;
+		want->sacl_dropped = c->effect == NO_SACL;
+	}
+	t_expect_same(test, sd, want);
+}
+
+/*
+ * An owner or a group offset that points into the header of the SD (MS-DTYP
+ * 2.4.6) is refused, even when the bytes there read as a SID. With
+ * SACL_PRESENT clear OffsetSacl is not read, so here it is set to 1. The
+ * header then holds the bytes of a SID with no sub-authority at offset 12.
+ */
+static void ksmbd_sd_decode_offset_in_header_test(struct kunit *test)
+{
+	const size_t len = sizeof(base_sd);
+	struct ksmbd_sd *sd = NULL;
+	u8 *buf = t_base_copy(test);
+
+	buf[O_SD_CONTROL] &= ~SACL_PRESENT;
+	put_unaligned_le32(1, &buf[O_SD_SACL]);
+	KUNIT_ASSERT_EQ(test, ksmbd_sd_decode(buf, len, &sd), 0);
+	kvfree(sd);
+
+	buf[O_SD_OWNER] = O_SD_SACL;
+	KUNIT_EXPECT_EQ(test, ksmbd_sd_decode(buf, len, &sd), -EBADMSG);
+	buf[O_SD_OWNER] = B_OWNER;
+	buf[O_SD_GROUP] = O_SD_SACL;
+	KUNIT_EXPECT_EQ(test, ksmbd_sd_decode(buf, len, &sd), -EBADMSG);
+
+	/* An SD shorter than its header is refused */
+	KUNIT_EXPECT_EQ(test, ksmbd_sd_decode(buf, O_SD_HDR_LEN - 1, &sd), -EBADMSG);
+}
+
+/* Returns an SD with one ACE, which the encoder accepts */
+static struct ksmbd_sd *t_one_ace(struct kunit *test)
+{
+	struct ksmbd_sd *sd = t_alloc(test, 1);
+
+	sd->dacl = KSMBD_ACL_PRESENT;
+	sd->aces[0] = (struct ksmbd_ace){
+		.type = ACCESS_DENIED_ACE_TYPE, .flags = 0x13, .mask = 0x1f01ff,
+		.sid = &everyone,
+	};
+	KUNIT_ASSERT_EQ(test, t_try_encode(test, sd), 0);
+	return sd;
+}
+
+/* Makes one change to an SD the encoder accepts, and expects -EINVAL */
+#define T_REFUSES(what, change)						\
+	do {								\
+		struct ksmbd_sd *sd = t_one_ace(test);			\
+		struct ksmbd_ace *ace = &sd->aces[0];			\
+									\
+		(void)ace;						\
+		change;							\
+		KUNIT_EXPECT_EQ_MSG(test, t_try_encode(test, sd), -EINVAL, what); \
+	} while (0)
+
+/*
+ * The encoder returns -EINVAL for a struct ksmbd_sd that would encode to a
+ * malformed SD. Each T_REFUSES line makes one such change to a valid SD.
+ */
+static void ksmbd_sd_encode_refuse_test(struct kunit *test)
+{
+	static const u8 flags_undefined[4] = { 4 }, flags_one_guid[4] = { 1 };
+	static const u8 acl_rev3[8] = { 3, 0, 8 }, acl_and_more[12] = { 2, 0, 8 };
+	static const u8 data[4];
+	struct smb_sid rev2 = { .revision = 2, .num_subauth = 1 };
+	struct smb_sid sub16 = { .revision = 1, .num_subauth = 16 };
+
+	T_REFUSES("a Control bit the encoder derives", sd->control = DACL_PRESENT);
+	T_REFUSES("an owner SID of revision 2", sd->owner = &rev2);
+	T_REFUSES("a group SID of 16 sub-authorities", sd->group = &sub16);
+	T_REFUSES("a DACL state that is not one of the three", sd->dacl = 3);
+	T_REFUSES("ACEs with a NULL DACL", sd->dacl = KSMBD_ACL_NULL);
+	T_REFUSES("a DACL revision of 3", sd->dacl_revision = 3);
+	T_REFUSES("a SACL state that is not one of the three", sd->sacl = 3);
+	T_REFUSES("SACL bytes with no SACL",
+		  sd->sacl_data = acl_and_more; sd->sacl_len = 8);
+	T_REFUSES("a SACL with no bytes", sd->sacl = KSMBD_ACL_PRESENT);
+	T_REFUSES("a SACL that the decoder would refuse",
+		  sd->sacl = KSMBD_ACL_PRESENT; sd->sacl_data = acl_rev3;
+		  sd->sacl_len = sizeof(acl_rev3));
+	T_REFUSES("bytes after the SACL",
+		  sd->sacl = KSMBD_ACL_PRESENT; sd->sacl_data = acl_and_more;
+		  sd->sacl_len = sizeof(acl_and_more));
+
+	T_REFUSES("an ACE type with no layout", ace->type = 0x03);
+	T_REFUSES("an ACE with no SID", ace->sid = NULL);
+	T_REFUSES("an ACE SID of revision 2", ace->sid = &rev2);
+	T_REFUSES("ACE data that is not a multiple of 4 bytes",
+		  ace->data = data; ace->data_len = 3);
+	T_REFUSES("an ACE data length with no data", ace->data_len = 4);
+	T_REFUSES("an object section in an ACE that is not an object ACE",
+		  ace->obj = flags_one_guid; ace->obj_len = 4);
+	T_REFUSES("an object ACE with no object section",
+		  ace->type = ACCESS_ALLOWED_OBJECT_ACE_TYPE; ace->obj_len = 20);
+	T_REFUSES("an object ACE with an undefined flag",
+		  ace->type = ACCESS_ALLOWED_OBJECT_ACE_TYPE;
+		  ace->obj = flags_undefined; ace->obj_len = 4);
+	T_REFUSES("an object section shorter than its Flags say",
+		  ace->type = ACCESS_ALLOWED_OBJECT_ACE_TYPE;
+		  ace->obj = flags_one_guid; ace->obj_len = 4);
+}
+
+#define T_MAX_ACES	((U16_MAX - 8) / 16)
+
+/*
+ * AclSize is 16 bits wide (MS-DTYP 2.4.5), so a DACL holds at most U16_MAX
+ * bytes, and at most 4095 ACEs since the smallest ACE is 16 bytes. The decoder
+ * accepts a DACL of 4095 ACEs and the encoder writes it again. The encoder
+ * refuses a DACL with one ACE more, which would be too large.
+ */
+static void ksmbd_sd_decode_encode_max_dacl_test(struct kunit *test)
+{
+	const size_t n = T_MAX_ACES, len = O_SD_HDR_LEN + U16_MAX;
+	struct ksmbd_sd *sd = NULL, *more;
+	size_t i;
+	u8 *buf;
+
+	/*
+	 * A DACL of 4095 ACEs whose SIDs have no sub-authority, followed by
+	 * 7 unused bytes
+	 */
+	buf = kunit_kzalloc(test, len, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, buf);
+	buf[O_SD_REVISION] = 1;
+	put_unaligned_le16(SELF_RELATIVE | DACL_PRESENT, &buf[O_SD_CONTROL]);
+	put_unaligned_le32(O_SD_HDR_LEN, &buf[O_SD_DACL]);
+	buf[O_SD_HDR_LEN + O_ACL_REVISION] = 2;
+	put_unaligned_le16(U16_MAX, &buf[O_SD_HDR_LEN + O_ACL_SIZE]);
+	put_unaligned_le16(n, &buf[O_SD_HDR_LEN + O_ACL_COUNT]);
+	for (i = 0; i < n; i++) {
+		u8 *ace = &buf[O_SD_HDR_LEN + O_ACL_HDR_LEN + 16 * i];
+
+		put_unaligned_le16(16, &ace[O_ACE_SIZE]);
+		put_unaligned_le32(i + 1, &ace[O_ACE_MASK]);
+		ace[8 + O_SID_REVISION] = 1;
+		ace[8 + O_SID_AUTHORITY] = 5;
+	}
+	sd = t_decode(test, buf, len);
+	KUNIT_ASSERT_EQ(test, sd->num_aces, n);
+	KUNIT_EXPECT_EQ(test, sd->aces[n - 1].mask, n);
+	KUNIT_EXPECT_EQ(test, t_try_encode(test, sd), 0);
+	/* One ACE more makes the DACL too large for the encoder */
+	more = t_alloc(test, n + 1);
+	more->dacl = KSMBD_ACL_PRESENT;
+	memcpy(more->aces, sd->aces, flex_array_size(sd, aces, n));
+	more->aces[n] = sd->aces[0];
+	KUNIT_EXPECT_EQ(test, t_try_encode(test, more), -E2BIG);
+	more->num_aces = n;
+	KUNIT_EXPECT_EQ(test, t_try_encode(test, more), 0);
+}
+
+static struct kunit_case ksmbd_secdesc_test_cases[] = {
+	KUNIT_CASE(ksmbd_sd_decode_encode_base_test),
+	KUNIT_CASE_PARAM(ksmbd_sd_decode_accept_test, accept_gen_params),
+	KUNIT_CASE_PARAM(ksmbd_sd_decode_byte_change_test, change_gen_params),
+	KUNIT_CASE(ksmbd_sd_decode_offset_in_header_test),
+	KUNIT_CASE(ksmbd_sd_encode_refuse_test),
+	KUNIT_CASE(ksmbd_sd_decode_encode_max_dacl_test),
+	{}
+};
+
+static struct kunit_suite ksmbd_secdesc_test_suite = {
+	.name = "ksmbd_secdesc",
+	.test_cases = ksmbd_secdesc_test_cases,
+};
+
+kunit_test_suite(ksmbd_secdesc_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the ksmbd security descriptor codec");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
-- 
2.47.3

