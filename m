Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148BF31280C
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758341; cv=none; b=eT2qxbJmnCbjIIe7ubPVsPTDhU+kNJMOBV0F+GApGzNIt8FcYKsb5xzaEpK456X4iV7rvV7rLgkmENnemP0I2TCsunQ8GPLDb0l6V7wvqzr5Y4kT4hEJanWukdqPg+5d6t2faVaM1SraL8KJDloJy1HsTL/w98fhAE+OidlEBrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758341; c=relaxed/simple;
	bh=cz//MR6BCZ92O7ntoCM5s9znOTvSVl5Y2EGxYEP/01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjzjLuKSNNptqXTeTWjauvMoJ3IhhVJsLz0QJQaCAkiA8HoZvwyuP6sqkaDwVM1cWPVs6El2R11bb0h7aOO2ZHWtpthhlu+l1GcYZiwV/524fkNBDEyCFu02W05YaGgpU2HRCa/v88WoAu9otksSIViUCk/1m5VCmyGJoSB3Lzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JkK5Ncy4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j/4qA5OE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JkK5Ncy4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j/4qA5OE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+4uO3I8DglwSkcrqXQh9lvjjvP5CVMo2VnfzN++ifA=;
	b=JkK5Ncy4+gS/qHPGPssJ5/hI03drPEykQKUewx9wIcHA1c3VgdNKjBunHmRtKzKqpEeh3x
	w9/V7LGjdjWlRn8O26eY6bQgxqIdDhx3y/G+SZHuBzmrv54oanwQnwc+SasRJ15ZhHAs7v
	V6HtoESEemgrD8eQwjjyxzsCrvtuatg=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634--X4xE1ZCMY2vmfTzmtT9gQ-1; Wed, 26 Aug 2026 11:32:15 -0400
X-MC-Unique: -X4xE1ZCMY2vmfTzmtT9gQ-1
X-Mimecast-MFC-AGG-ID: -X4xE1ZCMY2vmfTzmtT9gQ_1787758334
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-66cbb3dcea7so2680300d50.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758334; x=1788363134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i+4uO3I8DglwSkcrqXQh9lvjjvP5CVMo2VnfzN++ifA=;
        b=j/4qA5OE8j2b7/Oz2lQ6tHXP2ZsG/334MTIkx6w34G1jxLQBJI13VJ8zpYpQVxnO59
         mvAKijizmHZV+cGlSBMBuj0wNacnEXHJkwTji/X2S53IBChzmDnnPXONb99WcqnqakWv
         EySlCKrxVdc3O0ovmxkdRoHSIBAGguRAvyFl/uxY8yS1HAgMuu6fI9h87168aZAFyf9e
         cQbI05j9u6s+sNpsTJilOswyBYd/Ccux0bmmHRsHQSWTsN6YENGJRsPvHKPx7P1BLu53
         C8C+BgCcIFuLLRUXDMsETE9R4AuGMpApIHRnCNx5ynKrGFPzOlO7o+cct4Y66KSs/AD+
         ZVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758334; x=1788363134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i+4uO3I8DglwSkcrqXQh9lvjjvP5CVMo2VnfzN++ifA=;
        b=nQapZKnPU/MPcKaUEy3kHc5ZBZt14/GU5vrTx+lkcaRzytDCNZcipAElDVfppSfwwc
         2skME7Z96jvKsvIDHVXcTpBKpbdMiP4cOVSVa2qtOvzzBuRaD9Ds5FrqsE+Duq9SjoMx
         KlTOYPxAhaA07SJ9Mya+sluiLbNb3bvM59ZPwp/IAnnJEnTVD08aB7jILINdKObsRn1g
         jlshvXJmUClCK+I4KGsw8rDpBcZsfhUk2CY6bU8khPtGVKb3KAwy4hZo2SLDRxHdsze1
         XRgRuN8yTTdffoHM38ZbgXTAxdEY8DNnAvlw5liwiXGOMunyAAWpRq4LUjH1W1qeDm1+
         yq/w==
X-Gm-Message-State: AFuF++lnhHKQZ4tX41cU8IWm+DmbgBN/toQVjJhgsCepXixEZu4QFEPc
	j6DWNNrvyFBMABd/8Ltz4UluTzo+2nWScaNfH+B7eeebFQQ29ukgcdD4xybKWwrjSay7Mlf98wT
	MKsGhjw0op6+v1vS0v/GY8nNCUfft2LqAaMSVgas+UbAEpzuMrBtzntbDyaOyxgMwPnY8j1bVwo
	pJjX62JhJk1QnCAPePgi9y66+SJIDlOmzLMzBOIMvy3BmxGkw=
X-Gm-Gg: AR+sD11bfaoyYjsRJwDxIZLJzQ1J3JmunNJvUCAvjfrRTJk75/ORvJPtHA9E+wo6N/5
	p/lFW4p0NGYvjKFYIlZUepj9Z8ZawMTWP6AYYfj6fu8VMMf1ttZesBHqIf8C+mwrDd56mSpUjRS
	qshtX455//ZIO0RPcy5Nkd6rpWGHD1w2WG4IdL255vC0QhpsD5tCKVRPBPcukhEpAvDOkgvKhJT
	CoskDCBvHcF6DFRQuCmuLN7xeD99y1pCRdQqd/ezKhKUalpvqsZX449KnRih6GsgnQRWX7rRm4I
	Ruzj2p0534Efv52/0qXzpAGEfIIkcrU11rea2w/wO6a77eRI2QAZMv1trRWyBOvwu8Zp82Nphf8
	E1Tu/LAwIi8ad7nuUBUeXRU9SiWHVMzJ7y66Obw9Nz8ejBwwRsfMa2LOB9mZJfwwktw==
X-Received: by 2002:a05:690e:c45:b0:66d:236b:dc75 with SMTP id 956f58d0204a3-66d2584942emr3038325d50.48.1787758334156;
        Wed, 26 Aug 2026 08:32:14 -0700 (PDT)
X-Received: by 2002:a05:690e:c45:b0:66d:236b:dc75 with SMTP id 956f58d0204a3-66d2584942emr3038294d50.48.1787758333663;
        Wed, 26 Aug 2026 08:32:13 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:13 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 03/11] smb: client: fix server->total_read not tracking sub-PDU size in receive_encrypted_standard()
Date: Wed, 26 Aug 2026 10:31:39 -0500
Message-ID: <20260826153147.4112943-4-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
References: <20260826153147.4112943-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

receive_encrypted_standard() processes compound encrypted frames by
iterating sub-PDUs, decrementing pdu_length by NextCommand on each
hop but leaving server->total_read at the original full-frame size.
cifs_handle_standard() passes server->total_read as len to
smb2_check_message(), so every length guard in smb2_check_message()
(smb2_rsp_struct_sizes[], smb2_min_pdu_len[]) operates on the
full-frame size rather than the current sub-PDU.

A malicious server can craft a compound encrypted frame where any
non-last sub-PDU is shorter than the fixed response struct it
declares.  The oversized len bypasses both guards, smb2_get_data_area_len()
reads struct fields at offsets past the received data, and the
data-area length arithmetic produces a spurious pointer into
uninitialized slab content or the next sub-PDU, which a rogue server
controls.

At the top of each iteration, pdu_length is the full remaining
compound tail (current sub-PDU + all subsequent ones), not the current
sub-PDU alone.  For a non-last sub-PDU, server->total_read must be
derived from next_cmd, not pdu_length.  Read next_cmd before assigning
server->total_read, then use `next_cmd ? next_cmd : pdu_length` so
that smb2_check_message() sees the actual per-sub-PDU extent on every
pass through the loop.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e75420dbe950..1bc3f8266eda 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5248,6 +5248,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 one_more:
 	shdr = (struct smb2_hdr *)buf;
 	next_cmd = le32_to_cpu(shdr->NextCommand);
+	server->total_read = next_cmd ? next_cmd : pdu_length;
 
 	if (*num_mids >= MAX_COMPOUND) {
 		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-- 
2.55.0

