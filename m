Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EB432695F
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987002; cv=none; b=CU0ez6rPJ4zrhwI7qYccMkzNBBOERO7kf/akkr4bO0hAQ/Uq9FvOiqgFbHf9k3U/fw1fJGu0tG5MwvzZkVOGgoIH4azy7WZBht2cCTgEhFhMP5udhIjkqg9vwGwXoCgjxKi5fGHRfUHBCVZl1h9LNhfff7GSUbFPwXWahBGDoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987002; c=relaxed/simple;
	bh=qVlybgAJT4Hn9XjOl8Z0AZBHvta2r8gMFXJx1iRWkvI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IaNPFjWmlx8nzeT1gBEEPcr+nH3eaeteOKzYWCeJkK/c5e/c0E/a91aJ06d9JnImBMYE3UqN9tPq55eFicAP8SSlbklZ4QRymhEcQKzDOV1PloGDMeFoyit/Ewj4iaEEH5WnsYd4RF1Wl5OyYnTgUMEzUfqDfcEuNOTVOVb6N2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAoscl4F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HpUi/8aF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAoscl4F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpUi/8aF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786987000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qFU5GC8BDvD5z5ZiDFY+3zRbt/y+DuObGPoFvJH9zR4=;
	b=GAoscl4F6K6ldTBrrbSzHA/65ZRSkAhhRN/sfpNKQaA0LQ0gBPP33K1pdWo8Z0srp/Z+BS
	W7rCTn3LdOCzZ5WB0VGphwLvKa2i1yR9AIK+/CFM7PcdyQ+TyMAFfnfZqof24xunTRQzjh
	ccG7KWdwvex7XZQ+mP8k+8Q7Tk1LTR4=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-IRY5AGkxPoSltvK7BEoH1Q-1; Mon, 17 Aug 2026 13:16:38 -0400
X-MC-Unique: IRY5AGkxPoSltvK7BEoH1Q-1
X-Mimecast-MFC-AGG-ID: IRY5AGkxPoSltvK7BEoH1Q_1786986998
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-45eb9967696so111329fac.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 10:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786986998; x=1787591798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qFU5GC8BDvD5z5ZiDFY+3zRbt/y+DuObGPoFvJH9zR4=;
        b=HpUi/8aFSFBJr4CTit0ZwT4g7usx2ZXBFwORYpbZFA5q4rVFrviJMxgXZXj0Co9pAR
         UMqRgBD5IkfUl1P3mjquY1PG+EBOgXsBrE24gCbAJUAO58Z1p14+l/9L7n014EzFbI4h
         KrISkN1I/+maVJyV8C00n3V2o5UkDOvXPcM3PXAUz6vJmh3dxxRU271BLZGqsp36huq7
         yQOtg+3s/dw0xOFjgcVL5RfkXzzC36S/4gIvdE/2k7z4iLfKh56QzEdsZk7o7EygZ21X
         iRORUp1y5pwsFWIy/vv2T4hdfmG2zhNzuqHA3IW84pXuQhW5YC4vvIgxOuRlUvb+19Ez
         ncTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786986998; x=1787591798;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qFU5GC8BDvD5z5ZiDFY+3zRbt/y+DuObGPoFvJH9zR4=;
        b=m5vImS+O8SwDCaejNDkD/M4OdZuc5SCt9lyL9qv7Av39bHqk+fSr05wy2RaEMzXfqL
         N0LzUlzIJlDyqZ1LfIvnSIVgtzyQyvJV9ioDPgHIq4azSbbKHbwSHrwU5fH/iBSlbDcY
         XVds39/T5URScXuYQ4XCl1KSbbJAdICEfBhT74rJTpSvfIhLHf8AuHQWyIO5oB+GAM4G
         u/0e8NtbD4tWnMRxbFd3pf2vnyUlVqVWV2tPgt4FgvikeXOX8ZLi6FTw2f4t8M4WFTn9
         MPoWpcsA1t9bH/0GUVd86M9lTtCX0vVWA/UXN5rFZ9NOzVK4xd3MY4ky1ONq3MIsVqg1
         CEXA==
X-Gm-Message-State: AOJu0YzQzI2/WOXbsR8roTn+pMbpufe0P1fzVEGpNo3+VJZugYDg1nam
	aGv1Kjx8eiCqPrtl3XJVLrfr7F17iCVslZWIUxvWm6gFNYy1nhrPOm7PfFGLIHyefaoqM8NDVmH
	ifwz85MRQH/JX3IHHE8HONMpmWP8cHKdtC4Yta5Fn8KCrieRXoHyZj8OeuHcqG+NzyS1tsoc3Sm
	pOsU8aKcDVtAMAbzCvu7q65dqFMLC3Pi9+YZxjFNdeGJkkKKY=
X-Gm-Gg: AR+sD12T45kdJJHzI4gKgrTucBKrcQiVO+LLvgp5n+ljOFGvk1Sg4stoxrLS46Mta8L
	Op1qhuIH14nfb/hH8wOxX7/c5D+fwxboc5Jduqo5Q1ivOhMPpElsI/EnBkyAPx8JN8v+a6DkIJi
	5F/+NnsjUU2LUhbB1qL6WLQo+ZtVF2JnlMMs+q0HLnwSFdABUWmWDYCeJudTEA87ZhUIptIcaG+
	JFcCT8Xr55bVOVOmsjml3uAj00Mr6Vr1iyMLQjLH4NKC6DRDTPRXhDNLhPmad2JTlBNyJwVaNHN
	PsikLantdMWFEO4DnEeSmRolYgK9ED15SEAVaHMpiNwvMk0uXQnzdkdeIA68cYG1U27+W1Vx49/
	OLOOypHq9HHaAH2oD/2LvTakrBqQiuMHf/dVYnKXG/l35k0XIboDHFHba5BVRgxOM4w==
X-Received: by 2002:a05:6871:e48a:b0:448:aa9e:b051 with SMTP id 586e51a60fabf-460c025d1f5mr505036fac.14.1786986998081;
        Mon, 17 Aug 2026 10:16:38 -0700 (PDT)
X-Received: by 2002:a05:6871:e48a:b0:448:aa9e:b051 with SMTP id 586e51a60fabf-460c025d1f5mr504997fac.14.1786986997595;
        Mon, 17 Aug 2026 10:16:37 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45f22e07004sm1485800fac.13.2026.08.17.10.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 10:16:36 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com
Subject: [PATCH] smb: client: reject lease breaks with reserved NewLeaseState bits set
Date: Mon, 17 Aug 2026 12:16:34 -0500
Message-ID: <20260817171634.212571-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_tcon_has_lease() and smb2_tcon_find_pending_open_lease() assign the
server-supplied __le32 NewLeaseState field directly to a __u8 local
variable, silently dropping bits 8-31.  Valid SMB2 lease-state values use
only the lower three bits (READ_CACHING=0x01, HANDLE_CACHING=0x02,
WRITE_CACHING=0x04); a server that sets reserved upper bits would have
those bits silently discarded, causing the client to record an incorrect
lease state and potentially miss cache invalidations.

Decode NewLeaseState to a u32 first and reject the response if any
reserved bits are set before narrowing to __u8.

Fixes: ab14cb0cae99 ("CIFS: Fix missing lease break")
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2misc.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 9068175e57cd..1e1d915c4377 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -570,12 +570,20 @@ static bool
 smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 {
 	__u8 lease_state;
+	u32 ls;
 	struct cifsFileInfo *cfile;
 	struct cifsInodeInfo *cinode;
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
 
-	lease_state = le32_to_cpu(rsp->NewLeaseState);
+	ls = le32_to_cpu(rsp->NewLeaseState);
+	if (ls & ~(SMB2_LEASE_READ_CACHING_HE | SMB2_LEASE_HANDLE_CACHING_HE |
+		   SMB2_LEASE_WRITE_CACHING_HE)) {
+		cifs_dbg(VFS | ONCE, "%s: invalid NewLeaseState 0x%x\n",
+			 __func__, ls);
+		return false;
+	}
+	lease_state = (__u8)ls;
 
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		cinode = CIFS_I(d_inode(cfile->dentry));
@@ -609,11 +617,20 @@ static struct cifs_pending_open *
 smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
 				  struct smb2_lease_break *rsp)
 {
-	__u8 lease_state = le32_to_cpu(rsp->NewLeaseState);
+	u32 ls = le32_to_cpu(rsp->NewLeaseState);
 	int ack_req = le32_to_cpu(rsp->Flags &
 				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
 	struct cifs_pending_open *open;
 	struct cifs_pending_open *found = NULL;
+	__u8 lease_state;
+
+	if (ls & ~(SMB2_LEASE_READ_CACHING_HE | SMB2_LEASE_HANDLE_CACHING_HE |
+		   SMB2_LEASE_WRITE_CACHING_HE)) {
+		cifs_dbg(VFS | ONCE, "%s: invalid NewLeaseState 0x%x\n",
+			 __func__, ls);
+		return NULL;
+	}
+	lease_state = (__u8)ls;
 
 	list_for_each_entry(open, &tcon->pending_opens, olist) {
 		if (memcmp(open->lease_key, rsp->LeaseKey,
-- 
2.55.0

