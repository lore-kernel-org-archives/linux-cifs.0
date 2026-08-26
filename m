Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8796C30C177
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758356; cv=none; b=T1hLsdT3QdgAV842esQTVl7q8FLUMx+1VOFQtUrSYyZszG5RmdZbL6prowf+Ky3C6OgFQ+Zgbf9bssW80JKwdZ5BY1Y41l2V4lnfUBbElUbFJFwyIlLd8/V5bJrRbggA3DNu9+1i0rVtqplJ6iIevEudS62uN4agJLPZIgukKc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758356; c=relaxed/simple;
	bh=Nhk1B4KT6xQJgxBOVM+nH1Tz88/S2L+BL2EbB5HvWXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6uggRXvBbrons3ejIgb+UgTip14ze1ZcsacRSNx6/S0hfMF/XynhhxUODjpalnu2IUDp7IAkiudVkZx6JXsvH1sA16s9cXgsOLY25Iie84/4HspHjwNxDqHAL8dHVc3czmQuU6odyn1H0oVY88GAAPchAVCaz8acRoqXHRECD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TargcJYG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rquDrTFe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TargcJYG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rquDrTFe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4QAga8y8B/crqtjyLgFtXgIcP2IcPU8Wa1eVgvxjKTw=;
	b=TargcJYG+mzM2fzLLSSE8aJ6Ylmbg3wW8+3U9PxAYxClahUvuTK9FXyqwTGLoDoOMmtDcf
	hL1xCYFiD/T+nHYLQupXkNYFDTBPh4hFEprq4BCAbW3XJSyffC+YNip3Q/5n2TcAp+SSjd
	LXEi46rJPm9RFCr5nithwxvcDSJTe2Y=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-WNRBRhG5OvCHioHMqv2msw-1; Wed, 26 Aug 2026 11:32:26 -0400
X-MC-Unique: WNRBRhG5OvCHioHMqv2msw-1
X-Mimecast-MFC-AGG-ID: WNRBRhG5OvCHioHMqv2msw_1787758345
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66cc7e43096so836759d50.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758345; x=1788363145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4QAga8y8B/crqtjyLgFtXgIcP2IcPU8Wa1eVgvxjKTw=;
        b=rquDrTFeuWsAJXjh3WF4aTtZKlIU36GNQtDV2Vg75l8jgaX3/4onGmglvsKrd9lbAk
         F/HN7gd7xYOhxx9BsEH2Zz8mjwjc9hmZTkn1CTvRtRD6c8bPJIomBTJ2m9OtX9jHjmUM
         BZWT8zPHGaPxg9udsgs0lr25+whAH8iWM3b1yVCiU7864rCU3mN7WRInEf8uqnWWV9mE
         f8V06eHz2kXBytTfV+CfUiwPo5ThDdVq9hhDlMW6hTsS9A69zS7APlZam6kmzBfMZPsa
         yzY1JlWJZu5xU/lMRchhtRRpwbnrw7z/AIJov5FKJBeN2OKI11jjIzq0XKveVe+IwzAG
         25ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758345; x=1788363145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4QAga8y8B/crqtjyLgFtXgIcP2IcPU8Wa1eVgvxjKTw=;
        b=lyRf5rdE4asJ5SLp10J5QNzMnldecyjdFKtgvcK4GIZMYyyDG3+oLptCD1DeKcw7T0
         0iadwhzio3Ot2rU+9ZR2kAZ9CliU6pTIOVXASEscOeDlx+aVmNPp7S+hnBuOUpUuFwe0
         Bk5iCx6TMwMC0tbzC32K8Bw1VFyHPVuSLqVrqG/acrIH3FNSiONSszebFRBNbI9YDuQ5
         qsqaXzQVunES//Stk94uHJ+xVSyv7MN1VgRokU5VzUGn90N3zdiYNp5e4GHyTJqWTlIR
         9gc7/tKlBo2sZAepzMesjOVfA8Asvf03CqcWw2V2GCmsm0KQTBYU3n+J7hjAf3bQ4MHP
         p3bg==
X-Gm-Message-State: AFuF++nuCUmHkIeor4+sGogax4CvzcVZzCrL3lDuuCLfkjkkfYVqrqyb
	wuNOmhV9c21XKBVnBPDFhX3l5dZ1zV8cqcVhprKeVPvDLhc9TKC/+yuWSC9KmcNceZfkdkri0iO
	5dxvBjp0PRIuaq/MHPjCGpuUA2bnf0JO4xXf7OvlswHBy6cKfRZwu5CtIlDZU19w2ya6/m7UZ51
	Aki2NQP0q5+zaFGCr+3+HyRCwu5Qsu+sdHco5j3HKalxQ7Bww=
X-Gm-Gg: AR+sD10bXvnmcCIs/Dab8sei3th4z4b387BH9tyWqbdWNl3nwfXvLo/5C/RRIlo0btn
	BWyGKFB7oxr5mcAnbvY1Wj0dcvyyKmmoR/4Cv5vVM8Bpcek7Z/3JwA2X+l08ggMXGL40LVVWhbO
	ybehwHjEDJwo481W7DfibrJExQAK4quGhvz5pbg0uLlA6zJKq8I7bYKkCtemZ3bSIMOkmmlwzA5
	sFqbXtEI2FAjBVia/F0E8F6FOVZkt05smI8IF4KojJG7ei7Gtma2W1f0SuB4J0DE/vkGTHSHf9J
	DOoMF6kPlhDYgakgDD7UoXLsbuHMda/o+Ji0VI1NLo5+CVyDt3YZkTF5dyLBF9b8H6qt0CPV441
	NC0blnXDY5RX2OXtXqAvh/Gg+MOLTd/Lu+j6hZByDSgz9MUfEPJd9HxtTEtguFx24nQ==
X-Received: by 2002:a53:a812:0:b0:66d:2276:bea with SMTP id 956f58d0204a3-66d25785d0dmr2053969d50.35.1787758345309;
        Wed, 26 Aug 2026 08:32:25 -0700 (PDT)
X-Received: by 2002:a53:a812:0:b0:66d:2276:bea with SMTP id 956f58d0204a3-66d25785d0dmr2053932d50.35.1787758344739;
        Wed, 26 Aug 2026 08:32:24 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:24 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 09/11] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Wed, 26 Aug 2026 10:31:45 -0500
Message-ID: <20260826153147.4112943-10-sorenson@redhat.com>
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

When snapshot_array_size < GMT_TOKEN_SIZE, smb3_enum_snapshots()
unconditionally sets ret_data_len = sizeof(struct smb_snapshot_array),
silently inflating it beyond the actual server response size if the
server returned fewer bytes.  The subsequent copy_to_user() then reads
past the end of retbuf.

Reject responses shorter than sizeof(struct smb_snapshot_array) with -EIO.

Fixes: dcbf1c8af18a ("smb3: add ioctl to get a list of snapshots for volume or share")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index efc68c7aef8a..c866d7c8c7dd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2382,8 +2382,14 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by
-- 
2.55.0

