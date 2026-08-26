Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A939430FC26
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758351; cv=none; b=RMNRV9/xN5LvF6Mcu7RDQxGzgskjvYyy27QA+vbpJEc2vU/WfpvqVneSrAfxKnKlCS8MbumXl2EtTEeAwrWcOa4TgW5UYIM+fNr6VOzpjSiWGz+gxnAOGlwGjhc5Svo622fcTzkp+oanNYDqHU7GfGbvosByjIFXLiLkfRK/P0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758351; c=relaxed/simple;
	bh=9c9AsfWadPeBpODKRouw11+EtIsyWqscZ8UgTDEVl3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1EcqmHZS659utpkSuGsH8jgfyPxfZ177WWTUsYkWKiv5UxVUmtjvxivRvhZ0rt+XG+8i5qkJymly74eBMeYa5zXPgxbMaOxCjCPbnCvvqQc+HCykWVw0eR8AdKHXatSIRwp3kJq+rMqJvApg+tiAZniMhyQS9T6eRWqszbTr+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XGkIewlb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f6wlsLki; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XGkIewlb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f6wlsLki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvrMF4Yjtz78iJTbYFy+PaftufYsw+A3Sx0I/KyH0+s=;
	b=XGkIewlbU3d5mQ4ir4krDN+2fZXh37OKrfz8Mbzk9vUEXOnPCGcss9QgH2br/t7w+eiQmA
	8bWcTpD1ApJc5s3TAeCcopAt7NSK3WgzEHpLNE5Ff+eQE9YKFadIOgsQk0bPPhYUL6sRAs
	lW15s0kLEoClEtYA4kCKTmwCckAV7xQ=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-5tRNr2eQMx-usWtStiLNHA-1; Wed, 26 Aug 2026 11:32:25 -0400
X-MC-Unique: 5tRNr2eQMx-usWtStiLNHA-1
X-Mimecast-MFC-AGG-ID: 5tRNr2eQMx-usWtStiLNHA_1787758345
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66cbb3dcea7so2680813d50.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758345; x=1788363145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zvrMF4Yjtz78iJTbYFy+PaftufYsw+A3Sx0I/KyH0+s=;
        b=f6wlsLkiWwGFM5XIgafS0L99c8E2Xh3nhp2pvX2ZvI183JFlhUbDoin1gQYZB8KbGa
         3dP274+4+R8cplaiymHLAuWE8bjUa2dquh4QHHhg0nmcTb6hxyVxJP8ofZg1xFyyWKG/
         Bi1S8qtXSOPAQX9iVdp/Qx5GF3GeYqUHvjIGrcr1nyHMkjRg94OYxX0XSoNh6AnA8wlZ
         TnaAvNenSK2q/UCqQjqr/1hT+vDdUigoMeZsXyesygjB0FBKEUQdUBMKLSx42vC1D4gL
         rpZ2x49ExF0QMoIS1y+UgRz2ZIjQQB1q4lUJsTKuAqUDyU8uMq5B776KvSOf+e6pKccz
         8wnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758345; x=1788363145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zvrMF4Yjtz78iJTbYFy+PaftufYsw+A3Sx0I/KyH0+s=;
        b=j/Nwt1u/rpbo4CzWyZcbI0aok4mMq5o/6tT0iNMzI0f+fG0+in551/Xk2ALkkQTFTY
         mOdW8jEgKvkuaj5Sw+52yAWLF8ufh7XPujQIo1iczLQwqr6gZtxSe8770mSrVax+lqYF
         WkF2tlHK3AdYP0g05QRU8fHC5OZ0nwZRjJ7lXguYCyzrosdYOhUdjOeydTrFbaxSfw+w
         wgRRJC4vYxyycBQzJ5QRk7G5pHh/sZYoUY2H7eAaATxclxgH+A/PisIu7V+UNtPNmMKZ
         EGtk5rcmaNFzr59eqxmGMtqwQ1gx/nuRMKeMQJOf37PUlwkvZL61Gdg0jTLHW60/1znW
         7xvQ==
X-Gm-Message-State: AFuF++l/ExqKIzoAmwpMyNASghpZIRA30dbCsBXMEaNO44ZZhob1EDhi
	1r2Xqcbdh/YtZy6KwxOrtsH2r75+jxerkUqrMSclwvkJOw2F40o7teyy30xS8C3UVRGLeZETgU4
	8cqiI5LQEWP0D21ZQM30EzjLoUMigjoy6WC75jPmrKVT486nl9R1kYlgD3JPcquEB13gQYtZLBD
	lTvCdnITutpRcSHzGTC8JCjdruk27dMLPL8NnuYVKN8FQqREk=
X-Gm-Gg: AR+sD10bUhEh8gfgdR89JMXJl1D0XneVpnMJQl8IhiCUo6p74qtO/SFDhfOcpESoCJX
	kaurHX6f372m/uusZ66eTE8Pt0yZrDPw4SDoQ8lDMRR7aP9997B6JDcVFsQnfOjWazCtpH6Uv6m
	kWia5rCZG+Qej40de19h+DhZdWEg56ivwXBO3olntVuWMthZ0yl0INMZvuwlo4cIRkp5S5EiNKW
	IeTa2r0Nql1+K1+1IhrJVf2YhdEYiDrxK/AihEoRtm6JpobJR0D3tOaMylFwUOXe7Vk09ka5pL0
	Aju0g6Ktq4nyS4l36buOVy19Igr5Ewu4ZpUn9ebzH80MhN2JEBW1E5y20H1VrZIGzxR6Pe4BMv1
	bM4Q0iaP2YivfBwPXZPWTLrKGRrLyAEanHw+rdsoAOVSbxv0R2ETKcGZeAT4D/SZ6Jg==
X-Received: by 2002:a05:690e:2056:b0:664:c81c:d1 with SMTP id 956f58d0204a3-66d2582f9a9mr2155125d50.45.1787758344628;
        Wed, 26 Aug 2026 08:32:24 -0700 (PDT)
X-Received: by 2002:a05:690e:2056:b0:664:c81c:d1 with SMTP id 956f58d0204a3-66d2582f9a9mr2155088d50.45.1787758343865;
        Wed, 26 Aug 2026 08:32:23 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:20 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 08/11] smb: client: fix underflow in is_valid_oplock_break() notify offset check
Date: Wed, 26 Aug 2026 10:31:44 -0500
Message-ID: <20260826153147.4112943-9-sorenson@redhat.com>
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

The check intended to bound data_offset against the received frame:

    if (data_offset > len - sizeof(struct file_notify_information))

underflows when len < sizeof(struct file_notify_information): the
subtraction wraps to a large value, the condition is false, and pnotify
is constructed from an unchecked data_offset.

Check len < sizeof(struct file_notify_information) first.

Fixes: 097f5863b1a0 ("cifs: read overflow in is_valid_oplock_break()")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb1misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1misc.c b/fs/smb/client/smb1misc.c
index cdfbbff24b72..a39c9140ceca 100644
--- a/fs/smb/client/smb1misc.c
+++ b/fs/smb/client/smb1misc.c
@@ -86,7 +86,8 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 		if (get_bcc(buf) > sizeof(struct file_notify_information)) {
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
 
-			if (data_offset >
+			if (len < sizeof(struct file_notify_information) ||
+			    data_offset >
 			    len - sizeof(struct file_notify_information)) {
 				cifs_dbg(FYI, "Invalid data_offset %u\n",
 					 data_offset);
-- 
2.55.0

