Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D674AC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Mar 2022 13:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241341AbiC1NEw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Mar 2022 09:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiC1NEu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Mar 2022 09:04:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4189C59
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 06:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648472587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/u9IbKTaxd7JfWbYIumOYCvcuDGJC1EVRBB8DOZNjec=;
        b=N65ClNAkp53KzOMaGet7OLYH+iZoJF0PCCzJvoOpqxl/9dSWCUVdt1o9feijv3CD2A5clC
        kQtM2n2/W+Dkt6zYk+dv7ZJQKD/QuXsJgbduZbGxTak7WxRz+GUukr1mHf/MIwpJSyQpiM
        V6fnsKhzyQ0VY1+we0EmapQeUM/HAN8=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-461-edjXzIFBMu6C_x8qpl9KJg-1; Mon, 28 Mar 2022 09:03:06 -0400
X-MC-Unique: edjXzIFBMu6C_x8qpl9KJg-1
Received: by mail-qt1-f199.google.com with SMTP id u29-20020a05622a199d00b002e06ae2f56cso10342299qtc.12
        for <linux-cifs@vger.kernel.org>; Mon, 28 Mar 2022 06:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/u9IbKTaxd7JfWbYIumOYCvcuDGJC1EVRBB8DOZNjec=;
        b=xTpnBZFxPxeHnpOqtO1vuHiVQX/6Teqtm5B7v2dcMLSTO9MBqi3YrR0OvRwYCw66g8
         T6YC1cUX8RgDOveegDoRpQG5wCuPcdFTZtxvedzjwjWajAhp5BK8RfGdAuCVLafsU/xO
         czL8l7qnNr9CYavEpbdvNUUwg6eNbhw5Am08yCYLyxd6AABFE0FcARyzAJvdD9kI7hy6
         8+/Tr4VoxQ/sQMpcsQNUgaBXJ0Y2YooexdV9A/xsga1y6+fV6hGChqEwuVpJEq51VANP
         o7QWiC7zIBRqKfgcIkBV9lkifkYsrrQJ+ZLjp2jFN0Sx/07+4sEnorykKUSfz4sKlJjw
         aMxA==
X-Gm-Message-State: AOAM531ayBlMiB/POIsU9BavHk2UgX5sK0iUCumRTr/dwmQV9hSVR2zJ
        EbEhMTEk+zCVvNldxsLR5jkJazFZP65UFXrYLnMSzeHai4Nh3XQZRNUzWdSroRHMGxvTeuqn4ex
        LpmSwR9CxtKYUUhi3uW9xHA==
X-Received: by 2002:a05:6214:c4a:b0:441:2c0e:1cb4 with SMTP id r10-20020a0562140c4a00b004412c0e1cb4mr20296001qvj.98.1648472585599;
        Mon, 28 Mar 2022 06:03:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwc0BWvMkauz8RL1WHra/Cyzf5posV9J1/75Ci8EjT4n+fT/8/G2vr6453bVFQNKYlS5HK8A==
X-Received: by 2002:a05:6214:c4a:b0:441:2c0e:1cb4 with SMTP id r10-20020a0562140c4a00b004412c0e1cb4mr20295947qvj.98.1648472585197;
        Mon, 28 Mar 2022 06:03:05 -0700 (PDT)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id m16-20020a05620a24d000b0067ecf605ef5sm8576234qkn.105.2022.03.28.06.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 06:03:04 -0700 (PDT)
From:   trix@redhat.com
To:     sfrench@samba.org, nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] cifs: fix enum usage
Date:   Mon, 28 Mar 2022 06:03:00 -0700
Message-Id: <20220328130300.3090213-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Clang build fails with
cifsfs.c:709:18: error: implicit conversion from enumeration
  type 'enum statusEnum' to different enumeration
  type 'enum tid_status_enum'
  tcon->status = CifsExiting;
               ~ ^~~~~~~~~~~

The type of the element status changed, so enum needed to change.
Replace CifsExiting with TID_EXITING.

Fixes: 7e5c8c02911b ("smb3: cleanup and clarify status of tree connections")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0789bf1496c74..a47fa44b6d52b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -706,7 +706,7 @@ static void cifs_umount_begin(struct super_block *sb)
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	} else if (tcon->tc_count == 1)
-		tcon->status = CifsExiting;
+		tcon->status = TID_EXITING;
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
-- 
2.26.3

