Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79E33B970
	for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 19:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786475934; cv=none; b=uFexr+dkhxoHGFKo21v1s9PODJs2pf44IvUsZa+9ATW0jogfW/s1FTVFlYsE9CG3H5nCwZ1k1HWZw68cSMN5wgfdmGIWj1aEl3FKR5Kc5XyrGO+6YOy5rNVab9qlpgjGcVLwxkFA6Iqe0N89LgHAzjmoNqKDUpHG76mka6bOEIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786475934; c=relaxed/simple;
	bh=5sHuuMzvKgVLMP9DBWNk/8a4WbWTH5iaI8fDiwlOlzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cFrt4Hhm9xvzofcpLXJejzflYf4Sm2voVB//G3YzUsapBdc3hLv04vrvgrf2hvDXKXVKsbKIy46PzC2BA6EM1QygyhxEDJ1zMXstnXDlJ7K1KyxfpAvcFmnACXXiD69VljJP0cUBkwrYMviprwNl6uGniQDVmCmRdVTqPvh66c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dARH7Zgs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jsUStkDC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dARH7Zgs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jsUStkDC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786475931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=epTOxMb768PT17zRbOrlL+2E6AusCyAWynHyvNWQ0xM=;
	b=dARH7Zgs+K8Ymg6qPbO02WB4hTrthizLfCc3VR+4/7thRg5RWecgF9xzgm2qJw9T0N91iq
	NAOq5T6KDzMAHQW1d4PTaNGf4s/kTOLHEHBaiT9gQhvywyHHG8Y4JmuHNxpVlvLrfIhFCu
	+ALTEbS04s9aW/nqD4R6w0wupGYD8yA=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-Uis8Q5GaOvOvguMAHJVCZw-1; Tue, 11 Aug 2026 15:18:50 -0400
X-MC-Unique: Uis8Q5GaOvOvguMAHJVCZw-1
X-Mimecast-MFC-AGG-ID: Uis8Q5GaOvOvguMAHJVCZw_1786475930
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9e2db9914so1611112a34.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Aug 2026 12:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786475930; x=1787080730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=epTOxMb768PT17zRbOrlL+2E6AusCyAWynHyvNWQ0xM=;
        b=jsUStkDCfxYBHCG3qbp2FnUun6oINJbuHNCb2QJ4k+OEAa/Ipu0Rl9LTD3bY42+EoH
         TAgaJUjqxtIsDlW7/4sal5I/aKBeg85TddIcfBn+3MwElRCOmKjrykPokdcxl7KksVMY
         mWSYa03k5KVjJZ38Lj3e/RV4m3OeBEXDPwVnXz6ei0NxxYMdNXLM9JAMimhM6Le+4LhV
         papx9wtBWmk25bHkg5rE3f8Q+zbOMoJtGhx/A3zClWOhNx12tvNNiedKNrvEJj7EsjB5
         LqJ2BxfQsxfJ+M0G5y41U7bbzYNNtye+JFw/2ZSMo1HJgRwnigD1uKE8wXSxz5OVagXD
         wBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786475930; x=1787080730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=epTOxMb768PT17zRbOrlL+2E6AusCyAWynHyvNWQ0xM=;
        b=K+cbnnXYJXkce6aobZuJl/EmWwWkcTMGUdjsZQH8x3+abgeUtkGRHGM8bcjAzIeNtD
         liaa7CM9gRq/dyVFyGv9HMzQh0c6GlEjNXs5tBubMoKVjaDr0HTJTD+oKD6aghvNPRsK
         OKF4e9yzhNw9Z7o5/kb1EoaPrLO3GuZS+Nj5m+bapW9U8APoe9e5oSPfdssJVvbetsb+
         2yVrlcfdWuNSpf5lC8ytoqrSpaIPSoqazJrc3kdUDEBUKO9BiK71HM62NWdZzBFsBIfl
         oZC/1ZoGqSi1CWSrbBYSBGkIKm0nmShwwdokO/3B7PjF045HN/9lJGRPfrbMJ5COR+eL
         R4YQ==
X-Gm-Message-State: AOJu0YwaDiv0pWd/FbQnyswAu//GcTjmNRULbBvs1DoVB9LwsWexoKWd
	+w4zaOXoax/Vw3Diax0rwGKroMjv/oGz/tWJULCRLyG2NShpd5DbrbPb+HNODTgQc9VMIvbk8rV
	9/sPB9uxC38cvCdRo9/6NzfGJh1gqspWnhmaOvY2EvpugyQRwJh+YhrdbAZtzAnD4fruEjUteE1
	11Upn3KUUJRP8D0Jxg/C2EB/FQ7SuX+6hN+v3Oj/bO2TWCeV4=
X-Gm-Gg: AR+sD10g0Ct2Xv1mOH+pzmVRJLEWYk7a99AE53QpgHlNWYPH0dYHOlDGcO42dq43ogo
	CLtwQtsqqi88q7PxsxryK9eGfeEasuH0cmFTJQNQv3EDBhko6bVMCiBCscaonW+DGlGBg8kEaej
	SIJx8kD7SUzg37l82UhN9ShfMCW7Gs8/yI8JJkp9g+2Do4CG+wSn6Agbr1g3J677FewCCFNpZQJ
	4H9b9QvrDPTLmUVF49k+uT5fg4REFgi6dv/TWytJ4pEIWYNb7V9gpHsdE56+nTbBmY43eqldThc
	ll6Z4yuGtqitx+UaJq/RcNPK3bBPxQoWGrRSO5yS6qphmcIOcTPVIp+qI+U/elFUDmH0SX1W3kr
	nl6ZTVz00qotomj7IyXdZysvASxb2VhOwBc0v36fu53bdFOO1U+rA74u6c0wkBMOdMA==
X-Received: by 2002:a4a:ee06:0:b0:6ac:a658:b952 with SMTP id 006d021491bc7-6b0ac354439mr1582645eaf.2.1786475929630;
        Tue, 11 Aug 2026 12:18:49 -0700 (PDT)
X-Received: by 2002:a4a:ee06:0:b0:6ac:a658:b952 with SMTP id 006d021491bc7-6b0ac354439mr1582606eaf.2.1786475929117;
        Tue, 11 Aug 2026 12:18:49 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b320d6e5sm609225a34.12.2026.08.11.12.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 12:18:48 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org,
	smfrench@gmail.com,
	grayhat@foxmail.com,
	pc@manguebit.org
Subject: [PATCH] smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()
Date: Tue, 11 Aug 2026 14:18:46 -0500
Message-ID: <20260811191846.1263281-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

coalesce_t2() computes data pointers directly from server-supplied
DataOffset fields with no validation against buffer bounds:

  data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
                     get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
  data_area_of_src = (char *)&pSMBs->hdr.Protocol +
                     get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
  data_area_of_tgt += total_in_tgt;
  ...
  memcpy(data_area_of_tgt, data_area_of_src, total_in_src);

A small DataOffset can push a pointer below the actual byte area,
overwriting header fields; a large one can push it past the buffer
end, causing out-of-bounds heap reads (source) or writes (target).
The BCC overflow guard does not prevent this: BCC reflects how much
data is present, while DataOffset controls where in the buffer it
starts.

The "validate target area" comment present since the function was
first written in 2005 was a placeholder that was never implemented.

Add lower- and upper-bound checks for both data pointers before the
memcpy, and before any target header fields are modified.

Fixes: e4eb295d38b5 ("[PATCH] cifs: Handle multiple response transact2 part 1 of 2")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
An independent report with KASAN reproducer (Shen Yongchao,
grayhat@foxmail.com) confirms this vulnerability against v7.2-rc6.
Their proposed fix bounded only the target upper limit; this patch
additionally adds lower-bound checks on both data pointers and
validates the source buffer range.

 fs/smb/client/smb1transport.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 966f2cf83a51..66daa5a37e4a 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -375,12 +375,31 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr, unsigned int *pdu_len)
 	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
 				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
 
-	/* validate target area */
 	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
 				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
 
 	data_area_of_tgt += total_in_tgt;
 
+	/*
+	 * DataOffset fields are server-supplied and not validated against
+	 * buffer bounds; check both data pointers before mutating the
+	 * target header.
+	 */
+	if (data_area_of_tgt < (char *)target_hdr +
+				sizeof(struct smb_t2_rsp) + sizeof(__le16) ||
+	    data_area_of_tgt + total_in_src >
+	    (char *)target_hdr + CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
+		cifs_dbg(VFS, "%s: target data area out of bounds\n", __func__);
+		return -EPROTO;
+	}
+	if (data_area_of_src < second_buf +
+				sizeof(struct smb_t2_rsp) + sizeof(__le16) ||
+	    data_area_of_src + total_in_src >
+	    second_buf + smbCalcSize((struct smb_hdr *)second_buf)) {
+		cifs_dbg(VFS, "%s: secondary data area out of bounds\n", __func__);
+		return -EPROTO;
+	}
+
 	total_in_tgt += total_in_src;
 	/* is the result too big for the field? */
 	if (total_in_tgt > USHRT_MAX) {
-- 
2.55.0

