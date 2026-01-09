Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F44338598
	for <linux-cifs@vger.kernel.org>; Fri,  9 Jan 2026 10:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767955171; cv=none; b=lud5CjyiIGDUkDjz9JLRcV9muvgfnztorwwExCHnpgu10+kdvu/KugwDBq0KHZCFQqzW6itdBNGuMaKAs0ivq8Na4P7a1PrhB2s/8C8/JMPTdZfz5mCawQSfczaPFGBNtyaX3kP5VUgX6Dwrjw/9cVqF0c4j59PXCsoY6btrBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767955171; c=relaxed/simple;
	bh=zAbQnwKQSgBP6p7KWlWw9DcpzSJFpicgY3jt9qQvxcc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PyJoT7sFfkyw7g34YWuub8dGQlHwsFWDdQjnAgfODUHqe4Rx0T+A/ocDYt21mVBnpaeV96wJB2LadABcYH5iKKDcZlzjWo+zM/E3P4DjGuCjOxoj1MBWm79IDDQIDuxsEeWy5mDTlqHu5cfbfKsGpjK+5CqNrxkweOnM0Ks/Jl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lh8RBW7B; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lh8RBW7B"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47d211aee52so4554655e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jan 2026 02:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767955168; x=1768559968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Rnq5gnjYEBiVhXaKRyzgwQ5WDJS4cAZPYtKFe/+ivNc=;
        b=lh8RBW7BYD++KMfj+WNAxkINQ3RgUvUQjlv3Ufo9JX7niyBShY5b4ABflVL1aPZVNa
         /SO101e39p9GLdwKB9bdPphgnRtj7/M3gDRt6T9zFLjULIqFfal5pJy3L7FLA1X8hehg
         wFlhQNxqpiHjbbb4EEmvVzvnL+Yg0fmZwXlqvbJ7eztZUUGEXfQoe3pWfp1+Nkbmpl/9
         C6XnmNerQvPpHBMMEZbc3K1Ex1bYpOi/TgQ0q3rS+QumrMcWOtB2fxHjgiZ7YZHY+K2h
         aax+be4/HSwjSct8OoJ1G0dp6fvlJiNRUHp58EEkSXtvfpYi28VWzKneRGrOgSXA6bTq
         pPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767955168; x=1768559968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rnq5gnjYEBiVhXaKRyzgwQ5WDJS4cAZPYtKFe/+ivNc=;
        b=hK3J+0tZva7hPj0fnFq0P41AggQp/rNtiGQs2smBqlzl7v2oXLhqLcA+GXxbI4yFrk
         RpKGeibI62Si6/azq+ec4fwzPwh166zdsPxHzZAcyNYKtEtmXEGcjqzsSR1ZFsRNNoTt
         FrwQU4zn+AisCHWlv5nFt6t2jhAiQ6LIqPcSnky2the9JDAcCgzjXrBAnKUYJ3bB8pxf
         OYDJGjyYrVHeh1eR+UYZ4kumYKV2oKGbUr+d8G1MZ+zSGBLHnGuZZAiC1FYwBPLRP3/e
         lrG6zbLckwtV1sElsCEjYRAkDUd/mBZ45kZHzRVVN7EU+Dn3Yp/E/Rx65iK+R8rIRAmH
         Cm5A==
X-Forwarded-Encrypted: i=1; AJvYcCV2TMgfgIZDiwpWPkGArLdJhW3BFzk+QzTHLEC0Po+18u55TJaMnL1tmZLN++xpxcvCy6Oj3tErMatM@vger.kernel.org
X-Gm-Message-State: AOJu0YywELN2s/bQ7tbT23yMvykVtkedHfpPG4er0HPwaaG0+ISwKSwq
	WGAcO7wdrHwV2Ro0cdAT3iSUKKgOO5AhbB6pGgpXiDrDmkmUi5s6hxMN
X-Gm-Gg: AY/fxX4VZvMbn2IjkljEd6X+8XHZnP7SjxwfmK5WK2pd5Ejen2jNFYDJJybb+l4aeua
	QjXgoraORbK3nbe1jIUeUfa9YV1JGWdyc5PyRIj2+GXHvuXphdYqB1d81Hs0xN/rnIwySGRXVIH
	NDrQzFZX7xYksY3K8F72TIUuZ14mb49TatXC/o1JJjL1mKqyLc6fBZtjB69Dzs13O9Aw2dQo+v7
	AFEqUbLWyXuxZkzQMzYUEPqw5Q1CZoTc/js+CHMhX9CQtM6XARzrEDcLNkDoQjI6ulIT5M1ngVf
	WlIgyoUyZCbQfxe6zImzWlDL9RLtO1pTrRyGx2DBikgGrwgndktZt0A/QT5paHOgfavojSkGAId
	YfPQiY0IcUPNPi17+CtYFC7NaejqJesHq5GOIToQmfN+K94nfRequCVml6Z/bUPwEUBdjFvM8gm
	u0cJ/HJlxf3yBAC8sAWx0itX6cWLOt/VFkiz7I2TneHRDTyOlH+lpEZR96y+szSONF7sYbsal8f
	e5c0FY=
X-Google-Smtp-Source: AGHT+IHciyXHKUeAGcmyGH9e9/cNeiCCj6AtY6qRKQqbQ6xmqXicuHAMta4fNJAQ21qLP44qM8jCkA==
X-Received: by 2002:a05:600c:3556:b0:477:9fd6:7a53 with SMTP id 5b1f17b1804b1-47d84b04e1amr63078895e9.2.1767955167881;
        Fri, 09 Jan 2026 02:39:27 -0800 (PST)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-215.paris.inria.fr. [128.93.83.215])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-432bd5edd51sm21697194f8f.29.2026.01.09.02.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 02:39:27 -0800 (PST)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: smbd: fix dma_unmap_sg() nents
Date: Fri,  9 Jan 2026 11:38:39 +0100
Message-ID: <20260109103840.55252-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 fs/smb/server/transport_rdma.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index f585359684d4..8620690aa2ec 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1353,14 +1353,12 @@ static int get_sg_list(void *buf, int size, struct scatterlist *sg_list, int nen
 
 static int get_mapped_sg_list(struct ib_device *device, void *buf, int size,
 			      struct scatterlist *sg_list, int nentries,
-			      enum dma_data_direction dir)
+			      enum dma_data_direction dir, int *npages)
 {
-	int npages;
-
-	npages = get_sg_list(buf, size, sg_list, nentries);
-	if (npages < 0)
+	*npages = get_sg_list(buf, size, sg_list, nentries);
+	if (*npages < 0)
 		return -EINVAL;
-	return ib_dma_map_sg(device, sg_list, npages, dir);
+	return ib_dma_map_sg(device, sg_list, *npages, dir);
 }
 
 static int post_sendmsg(struct smbdirect_socket *sc,
@@ -1431,12 +1429,13 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	for (i = 0; i < niov; i++) {
 		struct ib_sge *sge;
 		int sg_cnt;
+		int npages;
 
 		sg_init_table(sg, SMBDIRECT_SEND_IO_MAX_SGE - 1);
 		sg_cnt = get_mapped_sg_list(sc->ib.dev,
 					    iov[i].iov_base, iov[i].iov_len,
 					    sg, SMBDIRECT_SEND_IO_MAX_SGE - 1,
-					    DMA_TO_DEVICE);
+					    DMA_TO_DEVICE, &npages);
 		if (sg_cnt <= 0) {
 			pr_err("failed to map buffer\n");
 			ret = -ENOMEM;
@@ -1444,7 +1443,7 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 		} else if (sg_cnt + msg->num_sge > SMBDIRECT_SEND_IO_MAX_SGE) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
-			ib_dma_unmap_sg(sc->ib.dev, sg, sg_cnt,
+			ib_dma_unmap_sg(sc->ib.dev, sg, npages,
 					DMA_TO_DEVICE);
 			goto err;
 		}
-- 
2.43.0

