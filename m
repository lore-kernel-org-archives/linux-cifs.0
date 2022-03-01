Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B61C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 11:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbiCALCO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbiCALCO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 06:02:14 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245A98C7D4
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 03:01:32 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r133so31369wma.2
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 03:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RYWf6kPlH7xhtVqscp0wSjPH2MdDV31DzEO/ahVa5Tk=;
        b=oEsJr0QvAZrPcOMXmOSrPZzkX7zn2bfv9a+JU0gMDONZkX5TYIRkCkvqiXnei1o0pD
         XIQn6/ru2vJ+ssSb9/MgHCGKdE0sKkL9cYTFeZyBHEEqYD36KEwIo0pZhuBJV0ximd8T
         Aq6FOoQ3RhzCmUv90/N7PngwiNchyIg0eT1IuSxdurix04lGQTV6RIUqqfX+oIt65H41
         HPrv6I4jPq5Yb8XH2EkUE7X2zcpbd64MkGCMbqPp0eH2UGL4V1IadVCSCBs0eugET0I7
         joi/fBhwH92E46zFLX+xMakc0dWE4sYKM2W3imJSR4M82CIbgKE/1V22gBp6Egaup4XY
         Ps9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYWf6kPlH7xhtVqscp0wSjPH2MdDV31DzEO/ahVa5Tk=;
        b=5mGbSoAsV/WYlubP05qI1p9KZhxBBW8q+dcWQuiJaQT5PP59f75Pz/NUiNxjyBrI85
         kbcqlly9oOPdCx3UyrcMowjqEE+xApvmZ7kfKjVbpl0DEk2o/d/p7Yu9djhH+pq1uBYi
         0XPeYJrubCUHlWgAYnBU7/ppMml1R27aK63nXPYUBmtcdw901Zc6O5cLwHG+/4XaNtYi
         7bfPtahxUEA1uhsEDbGzWpNYo1ajDCJU0ZDCvXerdHHSQl2uSdRg+ha01+hEkkeyy75y
         3rZOUToS/2LLuOiXIPDbSz7mHcP9yw6/0ExWJXHr+gfBR1EfbGQu3F7S3cQ3E/23rA9D
         rxoA==
X-Gm-Message-State: AOAM533csmIlU+SqZXgx4prMdmKQF1f5esxLI134/3c2mtowlBFNGLVA
        LQLEEb7X1r/uoIajH3zTY+f2Mm6GIsGe2w==
X-Google-Smtp-Source: ABdhPJyD3adDk65XWjxij3o9pTZfwS9uKmwBiLAmIeHu0XE/o6uUfxJkmw2kqKXPSSe0PK/MS6xJzQ==
X-Received: by 2002:a05:600c:4a02:b0:380:deae:2c2d with SMTP id c2-20020a05600c4a0200b00380deae2c2dmr16523759wmp.133.1646132489932;
        Tue, 01 Mar 2022 03:01:29 -0800 (PST)
Received: from marios-t5500.iliad.local ([2a01:e0a:0:22a0:fa5e:e68e:157b:df1d])
        by smtp.gmail.com with ESMTPSA id m6-20020a5d56c6000000b001edb64e69cdsm13306904wrw.15.2022.03.01.03.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:01:29 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 3/4] ksmbd-tools: Add validation for ndr_read_* functions
Date:   Tue,  1 Mar 2022 12:00:08 +0100
Message-Id: <20220301110006.4033351-3-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301110006.4033351-1-mmakassikis@freebox.fr>
References: <20220301110006.4033351-1-mmakassikis@freebox.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Modify the ndr_read_* functions to check the payload is large enough to
read the requested bytes. Rather than returning the decoded value,
return 0 on success and -EINVAL if the buffer is too short.
This is the same pattern used in the kernel ksmbd code when dealing with
NDR encoded data.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 include/rpc.h       |  18 ++---
 include/smbacl.h    |   2 +-
 mountd/rpc.c        | 166 +++++++++++++++++++++++++++++++-------------
 mountd/rpc_lsarpc.c |  77 +++++++++++++++-----
 mountd/rpc_samr.c   |  94 ++++++++++++++++++-------
 mountd/rpc_srvsvc.c |  35 +++++++---
 mountd/rpc_wkssvc.c |   9 ++-
 mountd/smbacl.c     |  14 ++--
 8 files changed, 291 insertions(+), 124 deletions(-)

diff --git a/include/rpc.h b/include/rpc.h
index 63d79bc724c8..0fa99d41df35 100644
--- a/include/rpc.h
+++ b/include/rpc.h
@@ -298,10 +298,10 @@ struct ksmbd_rpc_pipe {
 						   int i);
 };
 
-__u8 ndr_read_int8(struct ksmbd_dcerpc *dce);
-__u16 ndr_read_int16(struct ksmbd_dcerpc *dce);
-__u32 ndr_read_int32(struct ksmbd_dcerpc *dce);
-__u64 ndr_read_int64(struct ksmbd_dcerpc *dce);
+int ndr_read_int8(struct ksmbd_dcerpc *dce, __u8 *value);
+int ndr_read_int16(struct ksmbd_dcerpc *dce, __u16 *value);
+int ndr_read_int32(struct ksmbd_dcerpc *dce, __u32 *value);
+int ndr_read_int64(struct ksmbd_dcerpc *dce, __u64 *value);
 
 int ndr_write_int8(struct ksmbd_dcerpc *dce, __u8 value);
 int ndr_write_int16(struct ksmbd_dcerpc *dce, __u16 value);
@@ -310,7 +310,7 @@ int ndr_write_int64(struct ksmbd_dcerpc *dce, __u64 value);
 
 int ndr_write_union_int16(struct ksmbd_dcerpc *dce, __u16 value);
 int ndr_write_union_int32(struct ksmbd_dcerpc *dce, __u32 value);
-__u32 ndr_read_union_int32(struct ksmbd_dcerpc *dce);
+int ndr_read_union_int32(struct ksmbd_dcerpc *dce, __u32 *value);
 
 int ndr_write_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz);
 int ndr_read_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz);
@@ -318,13 +318,13 @@ int ndr_write_vstring(struct ksmbd_dcerpc *dce, void *value);
 int ndr_write_string(struct ksmbd_dcerpc *dce, char *str);
 int ndr_write_lsa_string(struct ksmbd_dcerpc *dce, char *str);
 char *ndr_read_vstring(struct ksmbd_dcerpc *dce);
-void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *ctr);
-void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
+int ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *ctr);
+int ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
 			      struct ndr_uniq_char_ptr *ctr);
 void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr);
 void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr);
-void ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr);
-void ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr);
+int ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr);
+int ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr);
 int __ndr_write_array_of_structs(struct ksmbd_rpc_pipe *pipe, int max_entry_nr);
 int ndr_write_array_of_structs(struct ksmbd_rpc_pipe *pipe);
 
diff --git a/include/smbacl.h b/include/smbacl.h
index 5be815447906..b0fe131c9fac 100644
--- a/include/smbacl.h
+++ b/include/smbacl.h
@@ -72,7 +72,7 @@ struct smb_ace {
 };
 
 void smb_init_domain_sid(struct smb_sid *sid);
-void smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid);
+int smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid);
 void smb_write_sid(struct ksmbd_dcerpc *dce, const struct smb_sid *src);
 void smb_copy_sid(struct smb_sid *dst, const struct smb_sid *src);
 int smb_compare_sids(const struct smb_sid *ctsid, const struct smb_sid *cwsid);
diff --git a/mountd/rpc.c b/mountd/rpc.c
index 4db422abe9b0..9d6402ba5281 100644
--- a/mountd/rpc.c
+++ b/mountd/rpc.c
@@ -311,17 +311,22 @@ NDR_WRITE_INT(int32, __u32, htobe32, htole32);
 NDR_WRITE_INT(int64, __u64, htobe64, htole64);
 
 #define NDR_READ_INT(name, type, be, le)				\
-type ndr_read_##name(struct ksmbd_dcerpc *dce)				\
+int ndr_read_##name(struct ksmbd_dcerpc *dce, type *value)		\
 {									\
 	type ret;							\
 									\
 	align_offset(dce, sizeof(type));				\
+	if (dce->offset + sizeof(type) > dce->payload_sz)		\
+		return -EINVAL;						\
+									\
 	if (dce->flags & KSMBD_DCERPC_LITTLE_ENDIAN)			\
 		ret = le(*(type *)PAYLOAD_HEAD(dce));			\
 	else								\
 		ret = be(*(type *)PAYLOAD_HEAD(dce));			\
 	dce->offset += sizeof(type);					\
-	return ret;							\
+	if (value)							\
+		*value = ret;						\
+	return 0;							\
 }
 
 NDR_READ_INT(int8,  __u8, betoh_n, letoh_n);
@@ -350,15 +355,22 @@ NDR_WRITE_UNION(int16, __u16);
 NDR_WRITE_UNION(int32, __u32);
 
 #define NDR_READ_UNION(name, type)					\
-type ndr_read_union_##name(struct ksmbd_dcerpc *dce)			\
+int ndr_read_union_##name(struct ksmbd_dcerpc *dce, type *value)	\
 {									\
-	type ret = ndr_read_##name(dce);				\
-	if (ndr_read_##name(dce) != ret) {				\
+	type val1, val2;						\
+									\
+	if (ndr_read_##name(dce, &val1))				\
+		return -EINVAL;						\
+	if (ndr_read_##name(dce, &val2))				\
+		return -EINVAL;						\
+	if (val1 != val2) {						\
 		pr_err("NDR: union representation mismatch %lu\n",	\
-				(unsigned long)ret);			\
-		ret = -EINVAL;						\
+				(unsigned long)val1);			\
+		return -EINVAL;						\
 	}								\
-	return ret;							\
+	if (value)							\
+		*value = val1;						\
+	return 0;							\
 }
 
 NDR_READ_UNION(int32, __u32);
@@ -377,6 +389,8 @@ int ndr_write_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz)
 int ndr_read_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz)
 {
 	align_offset(dce, 2);
+	if (dce->offset + sz > dce->payload_sz)
+		return -EINVAL;
 	memcpy(value, PAYLOAD_HEAD(dce), sz);
 	dce->offset += sz;
 	return 0;
@@ -503,12 +517,16 @@ char *ndr_read_vstring(struct ksmbd_dcerpc *dce)
 	gsize bytes_read = 0;
 	gsize bytes_written = 0;
 
-	size_t raw_len;
+	int raw_len;
 	int charset = KSMBD_CHARSET_UTF16LE;
 
-	raw_len = ndr_read_int32(dce);
-	ndr_read_int32(dce); /* read in offset */
-	ndr_read_int32(dce);
+	if (ndr_read_int32(dce, &raw_len))
+		return NULL;
+	/* read in offset */
+	if (ndr_read_int32(dce, NULL))
+		return NULL;
+	if (ndr_read_int32(dce, NULL))
+		return NULL;
 
 	if (!(dce->flags & KSMBD_DCERPC_LITTLE_ENDIAN))
 		charset = KSMBD_CHARSET_UTF16BE;
@@ -521,6 +539,9 @@ char *ndr_read_vstring(struct ksmbd_dcerpc *dce)
 		return out;
 	}
 
+	if (dce->offset + 2 * raw_len > dce->payload_sz)
+		return NULL;
+
 	out = ksmbd_gconvert(PAYLOAD_HEAD(dce),
 			     raw_len * 2,
 			     KSMBD_CHARSET_DEFAULT,
@@ -535,20 +556,28 @@ char *ndr_read_vstring(struct ksmbd_dcerpc *dce)
 	return out;
 }
 
-void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *ctr)
+int ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *ctr)
 {
 	ctr->ptr = ndr_read_vstring(dce);
+	if (!ctr->ptr)
+		return -EINVAL;
+	return 0;
 }
 
-void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
+int ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
 			      struct ndr_uniq_char_ptr *ctr)
 {
-	ctr->ref_id = ndr_read_int32(dce);
+	if (ndr_read_int32(dce, &ctr->ref_id))
+		return -EINVAL;
+
 	if (ctr->ref_id == 0) {
-		ctr->ptr = 0;
-		return;
+		ctr->ptr = NULL;
+		return 0;
 	}
 	ctr->ptr = ndr_read_vstring(dce);
+	if (!ctr->ptr)
+		return -EINVAL;
+	return 0;
 }
 
 void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr)
@@ -564,19 +593,24 @@ void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr)
 	ctr->ptr = NULL;
 }
 
-void ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr)
+int ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr)
 {
-	ctr->ptr = ndr_read_int32(dce);
+	if (ndr_read_int32(dce, &ctr->ptr))
+		return -EINVAL;
+	return 0;
 }
 
-void ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr)
+int ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr)
 {
-	ctr->ref_id = ndr_read_int32(dce);
+	if (ndr_read_int32(dce, &ctr->ref_id))
+		return -EINVAL;
 	if (ctr->ref_id == 0) {
 		ctr->ptr = 0;
-		return;
+		return 0;
 	}
-	ctr->ptr = ndr_read_int32(dce);
+	if (ndr_read_int32(dce, &ctr->ptr))
+		return -EINVAL;
+	return 0;
 }
 
 static int __max_entries(struct ksmbd_dcerpc *dce, struct ksmbd_rpc_pipe *pipe)
@@ -731,10 +765,14 @@ static int dcerpc_hdr_read(struct ksmbd_dcerpc *dce,
 {
 	/* Common Type Header for the Serialization Stream */
 
-	hdr->rpc_vers = ndr_read_int8(dce);
-	hdr->rpc_vers_minor = ndr_read_int8(dce);
-	hdr->ptype = ndr_read_int8(dce);
-	hdr->pfc_flags = ndr_read_int8(dce);
+	if (ndr_read_int8(dce, &hdr->rpc_vers))
+		return -EINVAL;
+	if (ndr_read_int8(dce, &hdr->rpc_vers_minor))
+		return -EINVAL;
+	if (ndr_read_int8(dce, &hdr->ptype))
+		return -EINVAL;
+	if (ndr_read_int8(dce, &hdr->pfc_flags))
+		return -EINVAL;
 	/*
 	 * This common type header MUST be presented by using
 	 * little-endian format in the octet stream. The first
@@ -746,16 +784,20 @@ static int dcerpc_hdr_read(struct ksmbd_dcerpc *dce,
 	 * MUST use the IEEE floating-point format representation and
 	 * ASCII character format.
 	 */
-	ndr_read_bytes(dce, &hdr->packed_drep, sizeof(hdr->packed_drep));
+	if (ndr_read_bytes(dce, &hdr->packed_drep, sizeof(hdr->packed_drep)))
+		return -EINVAL;
 
 	dce->flags |= KSMBD_DCERPC_ALIGN4;
 	dce->flags |= KSMBD_DCERPC_LITTLE_ENDIAN;
 	if (hdr->packed_drep[0] != DCERPC_SERIALIZATION_LITTLE_ENDIAN)
 		dce->flags &= ~KSMBD_DCERPC_LITTLE_ENDIAN;
 
-	hdr->frag_length = ndr_read_int16(dce);
-	hdr->auth_length = ndr_read_int16(dce);
-	hdr->call_id = ndr_read_int32(dce);
+	if (ndr_read_int16(dce, &hdr->frag_length))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &hdr->auth_length))
+		return -EINVAL;
+	if (ndr_read_int32(dce, &hdr->call_id))
+		return -EINVAL;
 	return 0;
 }
 
@@ -772,9 +814,12 @@ static int dcerpc_response_hdr_write(struct ksmbd_dcerpc *dce,
 static int dcerpc_request_hdr_read(struct ksmbd_dcerpc *dce,
 				   struct dcerpc_request_header *hdr)
 {
-	hdr->alloc_hint = ndr_read_int32(dce);
-	hdr->context_id = ndr_read_int16(dce);
-	hdr->opnum = ndr_read_int16(dce);
+	if (ndr_read_int32(dce, &hdr->alloc_hint))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &hdr->context_id))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &hdr->opnum))
+		return -EINVAL;
 	return 0;
 }
 
@@ -805,13 +850,21 @@ int dcerpc_write_headers(struct ksmbd_dcerpc *dce, int method_status)
 static int __dcerpc_read_syntax(struct ksmbd_dcerpc *dce,
 				struct dcerpc_syntax *syn)
 {
-	syn->uuid.time_low = ndr_read_int32(dce);
-	syn->uuid.time_mid = ndr_read_int16(dce);
-	syn->uuid.time_hi_and_version = ndr_read_int16(dce);
-	ndr_read_bytes(dce, syn->uuid.clock_seq, sizeof(syn->uuid.clock_seq));
-	ndr_read_bytes(dce, syn->uuid.node, sizeof(syn->uuid.node));
-	syn->ver_major = ndr_read_int16(dce);
-	syn->ver_minor = ndr_read_int16(dce);
+	if (ndr_read_int32(dce, &syn->uuid.time_low))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &syn->uuid.time_mid))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &syn->uuid.time_hi_and_version))
+		return -EINVAL;
+	if (ndr_read_bytes(dce, syn->uuid.clock_seq,
+			   sizeof(syn->uuid.clock_seq)))
+		return -EINVAL;
+	if (ndr_read_bytes(dce, syn->uuid.node, sizeof(syn->uuid.node)))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &syn->ver_major))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &syn->ver_minor))
+		return -EINVAL;
 	return 0;
 }
 
@@ -843,13 +896,18 @@ static int dcerpc_parse_bind_req(struct ksmbd_dcerpc *dce,
 				 struct dcerpc_bind_request *hdr)
 {
 	int i, j;
+	int ret = -EINVAL;
 
 	hdr->flags = dce->rpc_req->flags;
-	hdr->max_xmit_frag_sz = ndr_read_int16(dce);
-	hdr->max_recv_frag_sz = ndr_read_int16(dce);
-	hdr->assoc_group_id = ndr_read_int32(dce);
+	if (ndr_read_int16(dce, &hdr->max_xmit_frag_sz))
+		return -EINVAL;
+	if (ndr_read_int16(dce, &hdr->max_recv_frag_sz))
+		return -EINVAL;
+	if (ndr_read_int32(dce, &hdr->assoc_group_id))
+		return -EINVAL;
+	if (ndr_read_int8(dce, &hdr->num_contexts))
+		return -EINVAL;
 	hdr->list = NULL;
-	hdr->num_contexts = ndr_read_int8(dce);
 	auto_align_offset(dce);
 
 	if (!hdr->num_contexts)
@@ -862,24 +920,32 @@ static int dcerpc_parse_bind_req(struct ksmbd_dcerpc *dce,
 	for (i = 0; i < hdr->num_contexts; i++) {
 		struct dcerpc_context *ctx = &hdr->list[i];
 
-		ctx->id = ndr_read_int16(dce);
-		ctx->num_syntaxes = ndr_read_int8(dce);
+		if (ndr_read_int16(dce, &ctx->id))
+			goto fail;
+		if (ndr_read_int8(dce, &ctx->num_syntaxes))
+			goto fail;
 		if (!ctx->num_syntaxes) {
 			pr_err("BIND: zero syntaxes provided\n");
-			return -EINVAL;
+			goto fail;
 		}
 
 		__dcerpc_read_syntax(dce, &ctx->abstract_syntax);
 
 		ctx->transfer_syntaxes = calloc(ctx->num_syntaxes,
 						sizeof(struct dcerpc_syntax));
-		if (!ctx->transfer_syntaxes)
-			return -ENOMEM;
+		if (!ctx->transfer_syntaxes) {
+			ret = -ENOMEM;
+			goto fail;
+		}
 
 		for (j = 0; j < ctx->num_syntaxes; j++)
 			__dcerpc_read_syntax(dce, &ctx->transfer_syntaxes[j]);
 	}
 	return KSMBD_RPC_OK;
+
+fail:
+	free(hdr->list);
+	return ret;
 }
 
 static int dcerpc_bind_invoke(struct ksmbd_rpc_pipe *pipe)
diff --git a/mountd/rpc_lsarpc.c b/mountd/rpc_lsarpc.c
index b9088950c46e..6aab08dd7223 100644
--- a/mountd/rpc_lsarpc.c
+++ b/mountd/rpc_lsarpc.c
@@ -105,8 +105,12 @@ static int lsa_domain_account_data(struct ksmbd_dcerpc *dce, char *domain_name,
 static int lsarpc_get_primary_domain_info_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
+	__u16 val;
 
-	dce->lr_req.level = ndr_read_int16(dce);
+	if (ndr_read_int16(dce, &val))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+
+	dce->lr_req.level = val;
 
 	return KSMBD_RPC_OK;
 }
@@ -158,9 +162,15 @@ static int lsarpc_open_policy2_return(struct ksmbd_rpc_pipe *pipe)
 static int lsarpc_query_info_policy_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
+	__u16 val;
 
-	ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
-	dce->lr_req.level = ndr_read_int16(dce); // level
+	if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// level
+	if (ndr_read_int16(dce, &val))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+
+	dce->lr_req.level = val;
 
 	return KSMBD_RPC_OK;
 }
@@ -206,19 +216,26 @@ static int __lsarpc_entry_processed(struct ksmbd_rpc_pipe *pipe, int i)
 static int lsarpc_lookup_sid2_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
+	struct lsarpc_names_info *ni = NULL;
 	unsigned int num_sid, i;
 
-	ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
+		goto fail;
 
-	num_sid = ndr_read_int32(dce);
-	ndr_read_int32(dce); // ref pointer
-	ndr_read_int32(dce); // max count
+	if (ndr_read_int32(dce, &num_sid))
+		goto fail;
+	// ref pointer
+	if (ndr_read_int32(dce, NULL))
+		goto fail;
+	// max count
+	if (ndr_read_int32(dce, NULL))
+		goto fail;
 
 	for (i = 0; i < num_sid; i++)
-		ndr_read_int32(dce); // ref pointer
+		if (ndr_read_int32(dce, NULL)) // ref pointer
+			goto fail;
 
 	for (i = 0; i < num_sid; i++) {
-		struct lsarpc_names_info *ni;
 		struct passwd *passwd;
 		int rid;
 
@@ -226,8 +243,12 @@ static int lsarpc_lookup_sid2_invoke(struct ksmbd_rpc_pipe *pipe)
 		if (!ni)
 			break;
 
-		ndr_read_int32(dce); // max count
-		smb_read_sid(dce, &ni->sid); // sid
+		// max count
+		if (ndr_read_int32(dce, NULL))
+			goto fail;
+		// sid
+		if (smb_read_sid(dce, &ni->sid))
+			goto fail;
 		ni->sid.num_subauth--;
 		rid = ni->sid.sub_auth[ni->sid.num_subauth];
 		passwd = getpwuid(rid);
@@ -244,6 +265,9 @@ static int lsarpc_lookup_sid2_invoke(struct ksmbd_rpc_pipe *pipe)
 
 	pipe->entry_processed = __lsarpc_entry_processed;
 	return KSMBD_RPC_OK;
+fail:
+	free(ni);
+	return KSMBD_RPC_EINVALID_PARAMETER;
 }
 
 static int lsarpc_lookup_sid2_return(struct ksmbd_rpc_pipe *pipe)
@@ -333,24 +357,34 @@ static int lsarpc_lookup_sid2_return(struct ksmbd_rpc_pipe *pipe)
 static int lsarpc_lookup_names3_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
+	struct lsarpc_names_info *ni = NULL;
 	struct ndr_uniq_char_ptr username;
 	int num_names, i;
 
-	ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
+		goto fail;
 
-	num_names = ndr_read_int32(dce); // num names
-	ndr_read_int32(dce); // max count
+	// num names
+	if (ndr_read_int32(dce, &num_names))
+		goto fail;
+	// max count
+	if (ndr_read_int32(dce, NULL))
+		goto fail;
 
 	for (i = 0; i < num_names; i++) {
-		struct lsarpc_names_info *ni;
 		char *name = NULL;
 
 		ni = malloc(sizeof(struct lsarpc_names_info));
 		if (!ni)
 			break;
-		ndr_read_int16(dce); // length
-		ndr_read_int16(dce); // size
-		ndr_read_uniq_vstring_ptr(dce, &username);
+		// length
+		if (ndr_read_int16(dce, NULL))
+			goto fail;
+		// size
+		if (ndr_read_int16(dce, NULL))
+			goto fail;
+		if (ndr_read_uniq_vstring_ptr(dce, &username))
+			goto fail;
 		if (strstr(STR_VAL(username), "\\")) {
 			strtok(STR_VAL(username), "\\");
 			name = strtok(NULL, "\\");
@@ -368,6 +402,10 @@ static int lsarpc_lookup_names3_invoke(struct ksmbd_rpc_pipe *pipe)
 	pipe->entry_processed = __lsarpc_entry_processed;
 
 	return KSMBD_RPC_OK;
+
+fail:
+	free(ni);
+	return KSMBD_RPC_EINVALID_PARAMETER;
 }
 
 static int lsarpc_lookup_names3_return(struct ksmbd_rpc_pipe *pipe)
@@ -433,7 +471,8 @@ static int lsarpc_close_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
diff --git a/mountd/rpc_samr.c b/mountd/rpc_samr.c
index 6425215f6d34..5a9afd3000a2 100644
--- a/mountd/rpc_samr.c
+++ b/mountd/rpc_samr.c
@@ -84,11 +84,19 @@ static int samr_connect5_invoke(struct ksmbd_rpc_pipe *pipe)
 	struct ksmbd_dcerpc *dce = pipe->dce;
 	struct ndr_uniq_char_ptr server_name;
 
-	ndr_read_uniq_vstring_ptr(dce, &server_name);
-	ndr_read_int32(dce); // Access mask
-	dce->sm_req.level = ndr_read_int32(dce); // level in
-	ndr_read_int32(dce); // Info in
-	dce->sm_req.client_version = ndr_read_int32(dce);
+	if (ndr_read_uniq_vstring_ptr(dce, &server_name))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// Access mask
+	if (ndr_read_int32(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// level in
+	if (ndr_read_int32(dce, &dce->sm_req.level))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// Info in
+	if (ndr_read_int32(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	if (ndr_read_int32(dce, &dce->sm_req.client_version))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 	return 0;
 }
 
@@ -115,7 +123,8 @@ static int samr_enum_domain_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -181,10 +190,17 @@ static int samr_lookup_domain_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
-	ndr_read_int16(dce); // name len
-	ndr_read_int16(dce); // name size
-	ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // domain name
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// name len
+	if (ndr_read_int16(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// name size
+	if (ndr_read_int16(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// domain name
+	if (ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -221,7 +237,8 @@ static int samr_open_domain_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -245,16 +262,30 @@ static int samr_lookup_names_invoke(struct ksmbd_rpc_pipe *pipe)
 	struct ksmbd_dcerpc *dce = pipe->dce;
 	int user_num;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
-	user_num = ndr_read_int32(dce);
-	ndr_read_int32(dce); // max count
-	ndr_read_int32(dce); // offset
-	ndr_read_int32(dce); // actual count
-	ndr_read_int16(dce); // name len
-	ndr_read_int16(dce); // name size
+	if (ndr_read_int32(dce, &user_num))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// max count
+	if (ndr_read_int32(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// offset
+	if (ndr_read_int32(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// actual count
+	if (ndr_read_int32(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// name len
+	if (ndr_read_int16(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// name size
+	if (ndr_read_int16(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
-	ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // names
+	// names
+	if (ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -291,10 +322,14 @@ static int samr_open_user_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
-	ndr_read_int32(dce);
-	dce->sm_req.rid = ndr_read_int32(dce); // RID
+	if (ndr_read_int32(dce, NULL))
+		return KSMBD_RPC_EINVALID_PARAMETER;
+	// RID
+	if (ndr_read_int32(dce, &dce->sm_req.rid))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -321,7 +356,8 @@ static int samr_query_user_info_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -481,7 +517,8 @@ static int samr_query_security_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -519,7 +556,8 @@ static int samr_get_group_for_user_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EINVALID_PARAMETER;
 
 	return KSMBD_RPC_OK;
 }
@@ -549,7 +587,8 @@ static int samr_get_alias_membership_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EACCESS_DENIED;
 
 	return KSMBD_RPC_OK;
 }
@@ -575,7 +614,8 @@ static int samr_close_invoke(struct ksmbd_rpc_pipe *pipe)
 {
 	struct ksmbd_dcerpc *dce = pipe->dce;
 
-	ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
+	if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
+		return KSMBD_RPC_EACCESS_DENIED;
 
 	return KSMBD_RPC_OK;
 }
diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
index 7e9fa675d34a..38b984b3a269 100644
--- a/mountd/rpc_srvsvc.c
+++ b/mountd/rpc_srvsvc.c
@@ -272,32 +272,45 @@ static int srvsvc_share_get_info_return(struct ksmbd_rpc_pipe *pipe)
 static int srvsvc_parse_share_info_req(struct ksmbd_dcerpc *dce,
 				       struct srvsvc_share_info_request *hdr)
 {
-	ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
+	if (ndr_read_uniq_vstring_ptr(dce, &hdr->server_name))
+		return -EINVAL;
 
 	if (dce->req_hdr.opnum == SRVSVC_OPNUM_SHARE_ENUM_ALL) {
 		int ptr;
+		__u32 val;
 
 		/* Read union switch selector */
-		hdr->level = ndr_read_union_int32(dce);
-		if (hdr->level == -EINVAL)
+		if (ndr_read_union_int32(dce, &val))
 			return -EINVAL;
-		ndr_read_int32(dce); // read container pointer ref id
-		ndr_read_int32(dce); // read container array size
-		ptr = ndr_read_int32(dce); // read container array pointer
-					   // it should be null
+		hdr->level = val;
+		// read container pointer ref id
+		if (ndr_read_int32(dce, NULL))
+			return -EINVAL;
+		// read container array size
+		if (ndr_read_int32(dce, NULL))
+			return -EINVAL;
+		// read container array pointer
+		if (ndr_read_int32(dce, &ptr))
+			return -EINVAL;
+		// it should be null
 		if (ptr != 0x00) {
 			pr_err("SRVSVC: container array pointer is %x\n",
 				ptr);
 			return -EINVAL;
 		}
-		hdr->max_size = ndr_read_int32(dce);
-		ndr_read_uniq_ptr(dce, &hdr->payload_handle);
+		if (ndr_read_int32(dce, &val))
+			return -EINVAL;
+		hdr->max_size = val;
+		if (ndr_read_uniq_ptr(dce, &hdr->payload_handle))
+			return -EINVAL;
 		return 0;
 	}
 
 	if (dce->req_hdr.opnum == SRVSVC_OPNUM_GET_SHARE_INFO) {
-		ndr_read_vstring_ptr(dce, &hdr->share_name);
-		hdr->level = ndr_read_int32(dce);
+		if (ndr_read_vstring_ptr(dce, &hdr->share_name))
+			return -EINVAL;
+		if (ndr_read_int32(dce, &hdr->level))
+			return -EINVAL;
 		return 0;
 	}
 
diff --git a/mountd/rpc_wkssvc.c b/mountd/rpc_wkssvc.c
index ba7f9a841e3d..124078fd38b4 100644
--- a/mountd/rpc_wkssvc.c
+++ b/mountd/rpc_wkssvc.c
@@ -141,8 +141,13 @@ static int
 wkssvc_parse_netwksta_info_req(struct ksmbd_dcerpc *dce,
 			       struct wkssvc_netwksta_info_request *hdr)
 {
-	ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
-	hdr->level = ndr_read_int32(dce);
+	int val;
+
+	if (ndr_read_uniq_vstring_ptr(dce, &hdr->server_name))
+		return -EINVAL;
+	if (ndr_read_int32(dce, &val))
+		return -EINVAL;
+	hdr->level = val;
 	return 0;
 }
 
diff --git a/mountd/smbacl.c b/mountd/smbacl.c
index 66531c3bebea..cc043ea59c2c 100644
--- a/mountd/smbacl.c
+++ b/mountd/smbacl.c
@@ -30,16 +30,20 @@ static const struct smb_sid sid_unix_groups = { 1, 1, {0, 0, 0, 0, 0, 22},
 static const struct smb_sid sid_local_group = {
 	1, 1, {0, 0, 0, 0, 0, 5}, {32} };
 
-void smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid)
+int smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid)
 {
 	int i;
 
-	sid->revision = ndr_read_int8(dce);
-	sid->num_subauth = ndr_read_int8(dce);
+	if (ndr_read_int8(dce, &sid->revision))
+		return -EINVAL;
+	if (ndr_read_int8(dce, &sid->num_subauth))
+		return -EINVAL;
 	for (i = 0; i < NUM_AUTHS; ++i)
-		sid->authority[i] = ndr_read_int8(dce);
+		if (ndr_read_int8(dce, &sid->authority[i]))
+			return -EINVAL;
 	for (i = 0; i < sid->num_subauth; ++i)
-		sid->sub_auth[i] = ndr_read_int32(dce);
+		if (ndr_read_int32(dce, &sid->sub_auth[i]))
+			return -EINVAL;
 }
 
 void smb_write_sid(struct ksmbd_dcerpc *dce, const struct smb_sid *src)
-- 
2.25.1

