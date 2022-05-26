Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D744C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 14:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242285AbiEZOCh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 10:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbiEZOCg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 10:02:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA1A82CDEA
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 07:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653573754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=t/NjQKnGqjNPpF942YZJrFLnAbWe3CnyInwbwktGydg=;
        b=JBImV1Nl94tFyYz61GaFnNzXr70jEqOYsZGijtCA0jspXKK1X2LPw/rb+5WWRYdHrjrbK2
        N9pC687i7eFcEZF7+4YCPP1SiW9Kn0Ahp/iTwXsoElHesM5miu1ZwfORXS7syY+quQWMrq
        gBFGkmnGqQD28d2/P3fRaVNXCnwn3Fw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-145-7CCwy2j5NZeYmKZwxOE_xg-1; Thu, 26 May 2022 10:02:33 -0400
X-MC-Unique: 7CCwy2j5NZeYmKZwxOE_xg-1
Received: by mail-qv1-f72.google.com with SMTP id w6-20020a05621404a600b00461c740f357so1660714qvz.6
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 07:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/NjQKnGqjNPpF942YZJrFLnAbWe3CnyInwbwktGydg=;
        b=o9k4GXQfFCHVgduvqeuh54ehdBl/EPRCrTLbgXgxBhy3pUrBAn1YC9/CtnDgXMAoeL
         dEeSXzE78jOX9mL8BeVK/k+Lbd5eeWNT0vP8cVrzEzrvh6OZbMAbcP8lg14C6QwXgYgo
         asStLcKrSLNe0RXC3DENKdtCXq5fOJdZcUJ9c+C69ioMgoYo5rbYAEMtIwBjQDlaT7Vc
         H8Njj7gc4iCUH1FVNAkV6Xcfp4s3OEhlNS0Q/57pdmGWjFQ4T5XK1oAH0iX0kPhiwQOp
         YKKuADj0sHG3kDiIt5deWeRwSVT6avWOlk3q/wIToDrZxcRZAcCpvVe/iNbV/Z/wSHXO
         jSTw==
X-Gm-Message-State: AOAM530PdpMj+joQLsrzvVcamPphSGiJvvam3Sz7qZJLv7SbS2ieKRSG
        0tkz3QPlf65J3TvDgyy10Er0oeNxQyQpWbCFD7qGX0tfuwO+dud2tWJRrnjBcPfjUTa0I+8QcUb
        3TaAXO41GV3IBIVyVUQPTMw==
X-Received: by 2002:a05:620a:199d:b0:6a3:a2d2:abee with SMTP id bm29-20020a05620a199d00b006a3a2d2abeemr12128638qkb.549.1653573751836;
        Thu, 26 May 2022 07:02:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx32tHOhTv7CHF4lQP4Z7dwEs3OmKH8agO67I1d5hvC5IwQ4wIyFmYszbKurImtJrG3LOJmcw==
X-Received: by 2002:a05:620a:199d:b0:6a3:a2d2:abee with SMTP id bm29-20020a05620a199d00b006a3a2d2abeemr12128604qkb.549.1653573751507;
        Thu, 26 May 2022 07:02:31 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id u6-20020a05622a17c600b002f3dc9ebb4bsm950014qtk.65.2022.05.26.07.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:02:31 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     sfrench@samba.org, nathan@kernel.org, ndesaulniers@google.com,
        dhowells@redhat.com
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] cifs: set length when cifs_copy_pages_to_iter is successful
Date:   Thu, 26 May 2022 10:02:26 -0400
Message-Id: <20220526140226.2648689-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

clang build fails with
fs/cifs/smb2ops.c:4984:7: error: variable 'length' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
  if (rdata->result != 0) {
      ^~~~~~~~~~~~~~~~~~

handle_read_data() returns the number of bytes handled by setting the length variable.
This only happens in the copy_to_iter() branch, it needs to also happen in the
cifs_copy_pages_to_iter() branch.  When cifs_copy_pages_to_iter() is successful,
its parameter data_len is how many bytes were handled, so set length to data_len.

Fixes: 67fd8cff2b0f ("cifs: Change the I/O paths to use an iterator rather than a page list")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3630e132781f..bfad482ec186 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4988,7 +4988,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
-		rdata->got_bytes = pages_len;
+		length = rdata->got_bytes = pages_len;
 
 	} else if (buf_len >= data_offset + data_len) {
 		/* read response payload is in buf */
-- 
2.27.0

