Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B647A30E0DC
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758353; cv=none; b=ojBSFj34OX7BeEd/9gjBTAQlm8XICKyWOfTDA6vFsgu2HvIETYPjKzk4Fo1Dt/JH2Ue9KS1idNm2lseXOgEcju+ggAitZLkEemnCfIeDroxNAa/1LUYJUFBan023C+EiX4f2fpVxvVy4FuwlAQHdi88uo09iSCkVcKkRdOXaa9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758353; c=relaxed/simple;
	bh=34K/FoU7abAOYLlPQo+u98BXpk6bD/cNXKkoSIw24xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv4A/9kIYgADwVoFhfrg66pRKm7XDE0KFmnrN3ih49dR8YyyC0Z4yr9nrJRserfxORSHL6SM9CIuGva+xkCm4tWr0vRh4pZe8iO8dcnRCkriUfH1bSAGC5Tn4wAnwQuKprLztYr3+epGK5AkUTDXLDAlB57V0H6T4IulP7RBryk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NMNmpd2m; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nDx8dUjt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NMNmpd2m";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nDx8dUjt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MsXHiYkvLJ5Dfkmh4RbCEqIEWI8MfAZu25u27dTcaQk=;
	b=NMNmpd2mZU+msd5UNrPU2OOjil0B1LRWtIA6VI2BE2R6uF52mdSiXNKNrM7GWX3Q2eS9bJ
	DBtTzoqRHMJojPuVl86BO1QKxovA/DTQYqu3O0tiQRGV6ySmjI/quopGmTRme4RynSrf2p
	F1hUctvIvnXJe/k8sQt1Wkx+edlh2bM=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-DI3zG6h8PS-66tZ9QbdWAw-1; Wed, 26 Aug 2026 11:32:26 -0400
X-MC-Unique: DI3zG6h8PS-66tZ9QbdWAw-1
X-Mimecast-MFC-AGG-ID: DI3zG6h8PS-66tZ9QbdWAw_1787758346
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66cc65a15dfso1607473d50.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758346; x=1788363146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MsXHiYkvLJ5Dfkmh4RbCEqIEWI8MfAZu25u27dTcaQk=;
        b=nDx8dUjtb0XAf+WCfJ7bRqSKAghqKwtg3xRPAZ/CEBxWlJtYEdCEhTf2H8lY3rrKrk
         eUTrfRHfV4sqg7cmx4NfQxiADo4jjuVqGzqO7cUw4QgQ9LecDxi83UqKJONW0cIRlXJY
         ll0cRyTyzFeofkaTLGGN/ruosMTN/KIA4TtxDb9T9D2TSXduCgBPuYTTOyxEJUL3NsN/
         8JXrrTeQB1wBjjwRVJgEirHnTcEpmpTjhxYZXYgtkdW5cRNQEGclWXF2VGTDCFE2XCcA
         TBI+9FZ7Pg//G48T0bwvbupyg7Ds5QALEFWFnAd4mhL2ZGV8i9Umvo2b2EUc/301b6vX
         0KPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758346; x=1788363146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MsXHiYkvLJ5Dfkmh4RbCEqIEWI8MfAZu25u27dTcaQk=;
        b=tLWCIWs0/u34H4QVsAtwLyGb//eGOxJxZsDgQlHC6owvqcN59jTNm9a2AuRYTE8vpj
         VNxLazvhNrMzs3dnSnLatIA7r+1tHoqNzPIwRhyaHJsf9A5gcWUUE4fXslObZCTcombp
         nwJ9QEnWCIBJwbnMHQzaMmCb/MPt7ZbcCp1rSaScNkhl/fHvB8SxoMTAe9e4Evbi66mx
         G4bS4i2MbjELUVp2ss8/4Kwf6nXCDmm5V/NkLXRZ0E5u1gFUtMJ4etg5XKKGo8oNpFOL
         kRGDJGyHuBHz2hPrniORXj0XtcIN1nnLnocHvdvT6LopwdjgcdmriInEK+b3HcMrDB+M
         9ybQ==
X-Gm-Message-State: AFuF++ld3LsbX/3CqJ/JqS9k1NFkJKhragRzWqnCHimzVjZdq3cG4UEZ
	B2mUORSfgX5VKrgX3YFhVJ5IxnziaX7yJdqxWREvW+isvLzdYJVH6ej8Cqh3ZFOfq5TYM3Sorvl
	prEikecvoyQLAMfmxF4BYP0anM5RV+SzIT1kkWLIP+JJ3zbvYUZRkMJnOoka+E0wvFwXvwcitwG
	wKeU+/7zeeueGflX02/njBwAwgxmpNJxDT6hnrg4krleugffo=
X-Gm-Gg: AR+sD11A3l3LdeqaIS8bBcCsSPMH2UFiqEsVVHINYltSY9lO6AN2M3v8oxZeMj1S/+5
	7tTj7lJh9XX/HJA+ueVAPnyMcngKax9SWuMi2vpvdcn4kfJKC9G+mPImxMMAyiuD7mups7C6XEP
	imxDBf/wXeLcNxKyjGczlSN2bpaVZEeXxdwLk8aYsiY0mUQgrTbBMkhP7/LSQJyCxbMTZEJ1bUd
	qCrfmu84aD6eHNkOG4a5+CjHngd31kmRg9XjtdwHdOc5iDSZb0tVp0B0JNhiAEpM0T4rlVdQZAh
	iN9nE8CtOHeDJlelyM90Nzv1x/mamCKr0dIUF5pkX/wOpRgaf63sHKz3K3NRkIP99eMfdklDwq1
	s3KpfWlJ608K8MBMpXWmMC4Yqf0Tb4HG9QtgyhR3jpVSAruLOyabDbNnu8GTB4y9wwA==
X-Received: by 2002:a53:e10a:0:b0:66c:9046:5aa1 with SMTP id 956f58d0204a3-66d256df641mr2248542d50.22.1787758346153;
        Wed, 26 Aug 2026 08:32:26 -0700 (PDT)
X-Received: by 2002:a53:e10a:0:b0:66c:9046:5aa1 with SMTP id 956f58d0204a3-66d256df641mr2248520d50.22.1787758345573;
        Wed, 26 Aug 2026 08:32:25 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:25 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 10/11] smb: client: fix incomplete bounds check on reparse buffer in cifs_query_reparse_point()
Date: Wed, 26 Aug 2026 10:31:46 -0500
Message-ID: <20260826153147.4112943-11-sorenson@redhat.com>
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

The start >= end check before casting to struct reparse_data_buffer *
ensures the pointer is in range but not that end - start >= sizeof(*buf).
A server-supplied DataOffset leaving fewer than 8 bytes passes the check
but allows OOB reads of ReparseTag and ReparseDataLength.

Fold the minimum-size check into the existing condition using `end`.

Fixes: c13b779d26b3 ("cifs: Fix validation of SMB1 query reparse point response")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..acb533383a3e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3064,7 +3064,7 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = smb_EIO2(smb_eio_trace_qreparse_data_area,
 			      (unsigned long)start - (unsigned long)io_rsp,
 			      (unsigned long)end - (unsigned long)io_rsp);
-- 
2.55.0

