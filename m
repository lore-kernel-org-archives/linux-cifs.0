Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4C848C8C7
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594485; cv=none; b=qDReCBjZssTzZO9fN/qYYWttjEBiXuVSIXcIOCBT+Wv4yuMlKJeAYG72sQtWi2+JyzyAZ/RAPaBjNeLIwIyPPg6Dx9QlcDhQIdkkjRcIQRYZmYeJYZyNzmw/bqc8JtFsQ3a29NhTNLSwDvs1ASNT0AZMlHjOLCZhF2ZmgWVyQRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594485; c=relaxed/simple;
	bh=Sj36XIv5xMRsbs/wOZ+6qit3KbIBL5gKeu9FcM1KgZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E48WjRjQbPJvM6zeZ2iGurDhIjt/CRD5lC8NZcFv8g6oFnMa9rAcCkzFOArBcQ2WNBl3yng6fjszVVKxj+33+vFso+F+/Uko4SekBySWYPn6fkfo17pluqnFlO/Q6Iw/HGrCBa3WcVYgJ0VPOgA7VVI6v7T796SPqX6ec/AmKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCMj0XYv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOFHv1O9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCMj0XYv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOFHv1O9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZWuq6vDDxC9a57mHhVLz+GoF6OV48cjZqu3A8mCuPWU=;
	b=VCMj0XYv4+o0VRiSyxYQ8oie1P/uWIcdgz1q4Sa0qFIFBZqw4gtJYU5QuOYso5pYpl1KDw
	N4nMz4GeRGMLmK8el4odtkEbI8jdGp0hCoJSnbDHuUpxHvrzjX46KAQ602uW4/Ozjwt/9D
	p87Yt2mCKxCutzF1V06CICpzDaTihGc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-9jcZM46-MCSir39Ez-9VBw-1; Wed, 16 Sep 2026 17:34:27 -0400
X-MC-Unique: 9jcZM46-MCSir39Ez-9VBw-1
X-Mimecast-MFC-AGG-ID: 9jcZM46-MCSir39Ez-9VBw_1789594466
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5328dae1305so2333041cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594466; x=1790199266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZWuq6vDDxC9a57mHhVLz+GoF6OV48cjZqu3A8mCuPWU=;
        b=AOFHv1O99acR78ioweWCdpNcVQf87yKqTPpsULQFgfx5fsCsrzk8/i7Yy8mfcaC02J
         wNyM1JePFTCS2XAVEh1gDJRcFP4vE+3ivny8BIqkAJZ4tkSJmIyKQ7pKPMffPr8nAgpr
         6j9LwRqmFkDOZzXsxItqCBJGkKAisyl+8CAroxhlYURfOkQrMK8ELWdrIR8Y6m3TMpnL
         ZJw/N12V2y4wg/5B9Megpc94FBhOOVniXcrS6F8EPoAiii5J2Ou/YR+6CwEPb6poH5AM
         FXDFVZAX8eAUq3HSxk8c8h3Kji/MA4v5vOFtHRiOU+iXAILAkke1H8SYyi5HIHlKg4+3
         Y6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594466; x=1790199266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZWuq6vDDxC9a57mHhVLz+GoF6OV48cjZqu3A8mCuPWU=;
        b=cgy9y8BMUZIEqRicm69Em2JsdQN+9CgLH3p5WCY6ghWT0ssQONm8SBsbYap+k0PT2b
         BLnhPYAnD6Ll01snz6N4I6CIHFDAeWbpiD2fZpHA9cPugf4h72b7Q9mtRzcf8Sjauy50
         bps7qNIw37Z6SspCQCq3CYol21qlMt3AHqKqoNGbLTR1mzybV1HCB+ot9sSFPdrr9uIe
         NemLwoe4NvPHmyaHij+fd0njrVEWkQF2CfeCYSeqFLDHKDvzX5Td3nNgBRtaIwMae7jQ
         l6Q7FOVAVs5SUzj8tV2HLyb1ahXz7qmvaYcsfDcwUYXH/r1WZYbI04XWZnsd62SHkhg5
         K5rQ==
X-Gm-Message-State: AFuF++kW+94RxgyAdTjnaSaYdn1xBceRjuaGf8q4xAbb2jwVBYRZGOeD
	zBk/TSsQ+ofoz30wx/SeDs2HS0okIST2fKpzUmKntK9GejQNrPpDqkXkOjbQBId7/KNkZ94Ihac
	oMJosvigpOIJ2LFxqkGPVkhoRpVZ26IyGDBi9OWUbyzW52oF+xDv2ZOYTNqD6YTbFjNO22nbfWl
	aI0F5OIPlHILIInuTNdF+PuF2OPhE4RzelBtCOX1UpWotCw54=
X-Gm-Gg: AYBFou25unIt8EiGvSAW1UH5QXqdUMHtJlTIci3TcupX7LO2NVzcOIIv+Nd8UpKrix2
	9tJUQ3JUJiTibXZJJHPHaU/iV1i6REhJeVQ+jbnwenNSDZjS0B4QlAMOdhRvei88+go7TdmiCAy
	bocPb/qfd+eke+y3n8oIQDNCzhvODQVxSHm2Q4nfP32bS7K2AJe9Z/Mu6F/Wbl5BsIoBATS595W
	NMVzEFKD7lzJKG3meyeJVp8A0HKQOAEZdtxXgI35a/jfcps4uTDM577kEOy9TKx7dDZPjAOLqsN
	Mk/OwoVHLushrIqPh4wx3lV5+4hZby0JmHv+jqtn8u+MLg+xs4oA617iRIt8lKsPQI4ceLVJXCt
	rlXyfp6ZZO1fB7EKD/miGBWLrdteKFJaPGTWL0sXyRfhsiSsKivxWOP8pyatL7OAdww==
X-Received: by 2002:ac8:5dce:0:b0:532:7ea5:f35f with SMTP id d75a77b69052e-5327f260c84mr75271271cf.24.1789594466563;
        Wed, 16 Sep 2026 14:34:26 -0700 (PDT)
X-Received: by 2002:ac8:5dce:0:b0:532:7ea5:f35f with SMTP id d75a77b69052e-5327f260c84mr75270711cf.24.1789594466160;
        Wed, 16 Sep 2026 14:34:26 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:22 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 9/9] smb: client: fix reparse buffer bounds in cifs_query_reparse_point()
Date: Wed, 16 Sep 2026 16:34:00 -0500
Message-ID: <20260916213406.1496960-10-sorenson@redhat.com>
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

In cifs_query_reparse_point(), the start >= end check before casting to
struct reparse_data_buffer * only ensures the start pointer is within the
response. It fails to verify that there is enough space remaining for the
fixed 8-byte header of the structure.

If a server provides a DataOffset that leaves less than 8 bytes remaining,
the check passes, but subsequent reads of ReparseTag and ReparseDataLength
will occur out-of-bounds.

Fix this by ensuring the remaining space is at least the size of the
reparse_data_buffer structure before accessing its fields.

Fixes: c13b779d26b3 ("cifs: Fix validation of SMB1 query reparse point response")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f9aff0712794..6dddbd84b93b 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3080,7 +3080,7 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = smb_EIO2(smb_eio_trace_qreparse_data_area,
 			      (unsigned long)start - (unsigned long)io_rsp,
 			      (unsigned long)end - (unsigned long)io_rsp);
-- 
2.55.0

