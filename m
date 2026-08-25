Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ACF44063D
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 21:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787694216; cv=none; b=AOCLaBOGhWv6JxIZ5N5RMb7XcEmJCTJnYsSzUNBB9/HVVyHUyypMcLJfUeFs0LzthbiNiiByDZpEY5lf5bOZtP2E46Y+YrU2Q+/o39LnpHs2obON9bwHh0bnj1g5AwOpKMj4Uqurb2FPwG8uOjVPzIV04pB8uvIpy5i2EK2Anwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787694216; c=relaxed/simple;
	bh=wjNucUp39n3xq8EAzxorvaJGmmTgMK02D5HVAfhjQVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyDwlilFZ2AIQWM620HeqRLVvdMnwgcoo2goe6M7Fyoj0LkSty6DHmmFeMUdWpfuktfcA8N7f77YnKf/PVIGVMzbHuD4VNt84AF5u/8KDAsbeH88CCyzWHjYF8pz8mgR5ITELb6KmYiCEU/YaWCSJAiJTHKuGo3wZvdvJkHXyfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hxi1EWgA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbYcUmz+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hxi1EWgA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LbYcUmz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787694213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PbvycVzqf4hPEetyb1QBcOfC1HYJJLq/kySscNL5C24=;
	b=hxi1EWgAbnc4NQJ9256YPO34oTBASi3ZcW+df2A78HQCFqpdb+yr18tqHQ2vbb9xj13eub
	x2Vt04nnH/7xwpoq8DQjClchvwaPz5BZJCEk+s+A+EwSUP7f5lwgGYOF3MXfLITYxbXhhc
	1F4H9AT/wJaOftQgO5wHvA6LyocVuos=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-MSIu4zyOPhSAUBES8Z8wrg-1; Tue, 25 Aug 2026 17:43:31 -0400
X-MC-Unique: MSIu4zyOPhSAUBES8Z8wrg-1
X-Mimecast-MFC-AGG-ID: MSIu4zyOPhSAUBES8Z8wrg_1787694211
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-937795a3ac5so26241085a.2
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 14:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787694211; x=1788299011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PbvycVzqf4hPEetyb1QBcOfC1HYJJLq/kySscNL5C24=;
        b=LbYcUmz+/GXBuCLdrt6wROabzkYmsoMOttzY+0J3x/diPctYlQS+gKSZSkHjmpagOL
         /8LRTzr+iwY1JxF6hJVRD2knw1yiUlXAket8KiWaXWfQoyOKeAfeffU5GmdoIEGf/HnZ
         flT/R5KJkLD83or+c+2g4Lz0Qd1wcBCN3n7k4p561SVtz2tBYQlhB49VYEAe5Lm/1JSD
         Y7nQyKNAlZf/LeM6wlItXjv4i4qQjMaRfSDBnsWtp3kZcg8NRM5db24i6YSO3E+AhSK7
         kCbJ2rMvaahPv4+jw3zTnkGVnx8zGG9fgcDYJVnRUDJGyQySRxm/EezA8IgukamNAqfE
         rwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787694211; x=1788299011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PbvycVzqf4hPEetyb1QBcOfC1HYJJLq/kySscNL5C24=;
        b=Z4DWyVp3Q+npA16zA/7+NNzQ035kSV4TOKfkfJm3RgFYTaFhdwguOd7lLeAjaGcyl4
         XrrVmWsUM9FFSeUeKHiXqWO62z8uYFIga2Njjm1PvMgLJoONdnJLaJrvLJphiefFMMZy
         E4rGe2R9DueRkAoum9Q8qlWTRGZrCltYPyk0gzxypnSK2Iyu8bEkRMMG266ltCkX5xCT
         Hl99Sb4zi8o5KYtMmrb3MCTcgrRl3AB06uKMPIqRZ+zu8+XWMQvZqrFj7Ke5Rp1I2spb
         cNkQcnMyUp7dVY8DPeyNKVauHhllq0hVJEisVFb1jv7uktdF6nmRUXfXzu7MiK5Gzhb2
         98uQ==
X-Gm-Message-State: AFuF++l0ie6Cy6zx1dReSxUPtEjS9gs1ZFZ7MLGjVXQHp8IaeBNCse5x
	w+5VJWvl3jjAuCUfyZGwqRtHS+TIxbV6UawPDq2mkev37W5cr/kReg8ggdp/7usrdkXwyTlHcy3
	1irW6ZnzFabAQDhjP/DaT0o1mMMj3MKzP5nNAny2OtWKLQYTWhT4Yc+vc64Rm6CK+Z8N448mMvz
	QYkD9yEyZZwZZyTsgvRBUc4431nKUACNvyIyUswXaq/3uF2Gg=
X-Gm-Gg: AR+sD11LGnFQvCQRr+BuE/RUxKh4PRZK7QJBHB570UmbWpVgOI2J24pE7K9VSnJmO69
	leQpAUd5d5TgLzi5ldoTnbiUXjnT/2GaHx9XBHU8dA9WsZnu3bI6h5oy4G4iO5EamgXOiwQTCRS
	tL4ZhgKGf/DmLkkrN/UV3MGPs5H1DOpgTj1nqanfnT3URvtxsiTqJe6k2/VCj8din2U+9wNDP9z
	N2MiFkftHa54nyoOPhPrR+AoB7MWYxBUp1KQ/hy1Q50FYuG8iP/+0b//Gti1vjWD88O+Gz4tch6
	cL3MfCZvJUjY3lMtDgIfcY0wYBK2WaJjuD1b+XoXcGlm+p2vqTNXv1Vx43YfY9yKy3ZRVNcyv/Q
	hcCOlo48/nOZeQdN9b2r3GixJylTyCd8+Ng4/K9bvNbtvvq3hdguCr/9oi2N5
X-Received: by 2002:a05:620a:f12:b0:937:19d3:3fda with SMTP id af79cd13be357-93780490ecemr158852685a.28.1787694211124;
        Tue, 25 Aug 2026 14:43:31 -0700 (PDT)
X-Received: by 2002:a05:620a:f12:b0:937:19d3:3fda with SMTP id af79cd13be357-93780490ecemr158847585a.28.1787694210602;
        Tue, 25 Aug 2026 14:43:30 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377f217c5asm59929785a.15.2026.08.25.14.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 14:43:30 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] smb: client: fix heap overflow in cifs_do_set_acl()
Date: Tue, 25 Aug 2026 16:43:27 -0500
Message-ID: <20260825214328.3852168-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825183229.3799705-1-sorenson@redhat.com>
References: <20260825183229.3799705-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_set_acl() validates ACL size using posix_acl_xattr_size():

        4 + (count * 8)  // 4-byte header + 8 bytes per ACE

cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
wire format into the same buffer:

        6 + (count * 10)  // 6-byte header + 10 bytes per ACE

An ACL that passes the xattr-based check in cifs_set_acl() can
overflow the heap when posix_acl_to_cifs() writes the larger CIFS
format.

Validate the CIFS format size against the remaining buffer space and
USHRT_MAX before converting--data_count is __u16, so sizes above
USHRT_MAX truncate the on-wire packet length, causing the server to
apply a partial ACL.  Replace MaxDataCount = 1000 with
min(CIFSMaxBufSize, USHRT_MAX).

Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
v2 changes:
 - Add USHRT_MAX bound to prevent u16 truncation of data_count for ACLs
   with more than 6553 entries, which would cause a partial ACL to be
   silently applied on the server
 - limit MaxDataCount to min(CIFSMaxBufSize, USHRT_MAX)

 fs/smb/client/cifssmb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..621aca5d3b75 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3555,6 +3555,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3574,8 +3575,7 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
-	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3587,6 +3587,15 @@ int cifs_do_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 	parm_data = ((char *)pSMB) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 
+	/* make sure we can fit the larger cifs_posix_aces in the buffer */
+	cifs_acl_size = sizeof(struct cifs_posix_acl) +
+		       (acl->a_count * sizeof(struct cifs_posix_ace));
+	bytes_available = (CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) - offset;
+	if (cifs_acl_size > bytes_available || cifs_acl_size > USHRT_MAX) {
+		rc = -E2BIG;
+		goto setACLerrorExit;
+	}
+
 	/* convert to on the wire format for POSIX ACL */
 	data_count = posix_acl_to_cifs(parm_data, acl, acl_type);
 
-- 
2.55.0

