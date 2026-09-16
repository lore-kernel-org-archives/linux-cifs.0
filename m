Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8CE46D562
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594479; cv=none; b=BI46TY5o7UKOpgInLaddiiy98699wmf/wEr+ejtNE6In/9xr9bxovvoKHp9WM943PYmYmxVWp8ZJxp4NduRz60kTxknOZGuwEQaiET+kuRdXstfe6MF9UGuhbqbhq9Y0+6blS3Rmng/jpTnKrw1ZooaaCfrUrnS4vlZ0nlPbvlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594479; c=relaxed/simple;
	bh=OFmUR5n12qboMmyBDS8aJ5gQxbHGee425Wkk4EjiRoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDyXU8xPaFd7QiC5cWNCaVbJ1JgIPPfLdfOW2fkLa4HM6ut7Di1P1AWFjuPmiiIW02eelhvYd7XAbZ41ObcKjXbnc+YtPR3Z1x41FMDQZrZJU5SVrpoyNK68eBE2/xiisxfxVlSAjTSDGSFDy/CfCTdN5e2XA3WnJRhAVdsy84c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+PqSMAE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YH/dMVKv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+PqSMAE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YH/dMVKv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6OnhzbABUYbzzJKN8af0lhPKwu8S8OBp+evSnROGSRk=;
	b=e+PqSMAETnzNcvKnqJ9wTS9DgWjSZ567OE+DfGGIm4xiJeVV3S+HK2f2uuAG21me439LYC
	izoqrUZHYeEbk8gBj5EV6cN5LmZiKBFMq9g6NZagFf78ZKiu03yGmbvEr83xfL6JjbX4D/
	rKOcAkAT8uIFVbRSLw2PLOA2o4CyYlM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-kkxqQWY6PXezB5jx39rfWQ-1; Wed, 16 Sep 2026 17:34:17 -0400
X-MC-Unique: kkxqQWY6PXezB5jx39rfWQ-1
X-Mimecast-MFC-AGG-ID: kkxqQWY6PXezB5jx39rfWQ_1789594457
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5328cdb38bcso1610181cf.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594457; x=1790199257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6OnhzbABUYbzzJKN8af0lhPKwu8S8OBp+evSnROGSRk=;
        b=YH/dMVKv4J4ArpzehpohS6zF5rxON7BzvxZ3nfa5+yqsQ4OxSqFuXLD6fhM011ub0N
         SfS/2oYWYPUuKsQfQBAmC00mrzY3Kh3ZSBdr3b9uLlO/DI8a+qkQuv1mSa4lmxGf3Xql
         sIclYXSflO2UcD14dFmqfV3WNWjxXfWzxgw+1Q0QxE4zSFwznxVqYbP53hwEa/FAU7EO
         CL/aa5GmL2hQTYS9vYNjzfTmpr3SWd9h5aIAyycRYwU9CC6xTyUM6oYgtbz+hdWH7Yuw
         pi/raviolet1zSvxEgkam6AT4CRSDTYcyweTVyPV019qSnTwiOsrH/ANg7oJ703wE40j
         t/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594457; x=1790199257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6OnhzbABUYbzzJKN8af0lhPKwu8S8OBp+evSnROGSRk=;
        b=pfvKPcHlO4ztu/+zkGlOESRfHsURhfKDYNdCyhtYd2fogOaGIiRt2ZoBotACtIvinh
         MnTAaeMuk3CI96w/jHQ+Qsdhk/9i0hcBYCHuw7+YXRiSoau0I5cnLOGE+MQPXjiITBA8
         M7RhqacSa4mJmYjcWB2oe53vtPqL9s7Ma/4GraFEKvn7MTreXmUy7HlQagA4S1Qj/sKG
         g0Y9J/4Ov8k6qfq+7x2rZjDr5p8kLhl7+/Yjoe1hRWPIO0lsj7eoTPLcWs8u9hvbDXbU
         By8ArB3xAapCKTk+OoEErucPbNz+KXYeCEUJKeOiKQFRDvhuSG7e1Y+3u1Zsas6yRQMh
         38Yw==
X-Gm-Message-State: AFuF++lMnwQi91gtjY/1vE7AgzGQaG03Yh4bbpe4yizdTFpFdW+qDWxt
	uxGBbao5CIlKM5lY+nFfHL2EsXE+zBGolosLrV8BxH0ftd41PL8AVDLkD0r7/I13SPfE8w2xngH
	tHRUCUhSgxE8zdmVNYcn7qguMaOpGsoKERtdlG+8QXe2+WzzlLAmaeRin0JytDCYhb/IjP4JMDZ
	bjNQ4UULPO8IN6wE4DQlbn1s448UxNSDrpraGi/ihchzm5ySSOCw==
X-Gm-Gg: AYBFou2pysI/Gtg4wwgynCgYP/He8v4e5xxjGDzMYNrorsl7ua1r+1mOOHLvxT76Trb
	t7OYUvchM0C72cxmud7qxTQcqZ50+ZPBzAji0LOV+65fsyEmx26wJTqga6h8SDz0iX5l5c/A08Z
	miSmLE5eOBNe6lKgzTVjA4iMiPFOpo9I/1H3uXFV8za2VgrFHtRGsaEJ2vXLeUV1cFJyLxeFO7R
	frJq0wYlvYamyR82jgCvIHZP7gtyFWJdSPxiQnU1Lp9Hsoe3zzXxT2HREzFrgsJrU+xkSNt03Mu
	GESItluxbr8Btvz4q02r/Yc8P18aiKBEhKbpBK4PhMmXtncYAH7greGRt6EKglsetAKjvAnR5Kw
	KBj7DStCJE/XpaPsCfuOxDy0myONOiPrbpv/d106HzDMkxyahpiB/yNmKrX+KqlV7lQ==
X-Received: by 2002:ac8:5916:0:b0:52e:467e:ea75 with SMTP id d75a77b69052e-5327eeaf0f2mr75155831cf.31.1789594457328;
        Wed, 16 Sep 2026 14:34:17 -0700 (PDT)
X-Received: by 2002:ac8:5916:0:b0:52e:467e:ea75 with SMTP id d75a77b69052e-5327eeaf0f2mr75155081cf.31.1789594456723;
        Wed, 16 Sep 2026 14:34:16 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:16 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 5/9] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 16 Sep 2026 16:33:56 -0500
Message-ID: <20260916213406.1496960-6-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In parse_server_interfaces(), the server-supplied Next offset is
validated against bytes_left, but not against the size of the interface
structure itself.

A small, non-zero Next value can pass the bounds check but advance the
pointer by less than sizeof(*p). This causes the next iteration of the
loop to read misaligned, overlapping structure fields.

Fix this by ensuring the Next offset is at least sizeof(*p).

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2177f6fc01..bda940cb3784 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -785,9 +785,9 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}
-- 
2.55.0

