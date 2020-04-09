Return-Path: <SRS0=BWmz=5Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78321C2D0EA
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Apr 2020 06:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FF6206F7
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Apr 2020 06:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K32A9U7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgDIGLV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Apr 2020 02:11:21 -0400
Received: from mail-yb1-f181.google.com ([209.85.219.181]:40688 "EHLO
        mail-yb1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbgDIGLU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Apr 2020 02:11:20 -0400
Received: by mail-yb1-f181.google.com with SMTP id a5so5108807ybo.7
        for <linux-cifs@vger.kernel.org>; Wed, 08 Apr 2020 23:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7eUBE6HZYSyced90hhtsGZtLJfuVXjSRNKfoCcLjNYw=;
        b=K32A9U7mn98dafNO6kC4gfgtfa7evNHtkamEOfallKMphUFeeQaJzzLxgUyJLV6//Q
         gqUuDa8CHLSJ2d6wENOH4Vei4IsVwLeITob8nY1IzbwyrW8DD+4eiUNfr1Qq2+Skof0r
         gxMnoEf1L19mAUUKxFD4yi/Kc0tRfZy1rfvwvCdX14UTiG6oFexwogVB7MJJpSyz3RSE
         IbnQL45jz9T2kkVRIE5zGNeVGpdB8WLarwwela293+lCEJ7fW2jqi6JcepZc0Cqv8+Eq
         /KBFhXm+Wr3FXIckCXHw51wgB7PxAzWrmPKKGXcHByI92uhwPFLae6ZtYbz2dowe28Bg
         BkAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7eUBE6HZYSyced90hhtsGZtLJfuVXjSRNKfoCcLjNYw=;
        b=Sn6hazo4MKH+SOkxwFOdskEH6DJrkZU6W9zFeC8h9yMQWYKv5Rjl+SSTN0q9JK+im0
         0qyCAzcySshharEkRLnvMLryRK2FU1Biid/4by10Nr2OyB9vd2sMjfsvZn+XwtDCW05m
         S+maZSLDO3H519uSlPJJu6NjkmDpIUeh1XTOG4GuLrIDNKtzhGdcnppebBfaj7soOR45
         GJZN3EkCT8DV4NevwoYfttS2QdAggr9awNaqvN216nAr3fJeO07bWzZ+4G8EXDaxT838
         nHyflYFcdylGfxTe3JmbZF/ezVs6e9JxBw2iU8a2U1jtjE7RtwgGsCQdGLzmJs5/gOW1
         Jgmg==
X-Gm-Message-State: AGi0PuY2Eojk+/i9dBnKa/40Dy8mwoFjQOFSS8HCmldmBdX1ItGsU+1F
        YAIUxTqX4DRxCaGoQQcvjBpSDOa8Si+3PW6ZC9eZs6uSjow=
X-Google-Smtp-Source: APiQypI/uvfERA5mk2DoJ/X2xzPF92ge+xCGYFEXZ13kuaV6OvuELlbQ4Ir1xX1Kp3T7p6+CVM9nNvqOyWQDPwMIP+U=
X-Received: by 2002:a25:cd04:: with SMTP id d4mr17398336ybf.375.1586412678773;
 Wed, 08 Apr 2020 23:11:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Apr 2020 01:11:08 -0500
Message-ID: <CAH2r5mvw+5w9HNGb2t9sj3hPTSMbYHChOdCi+XGc4t5YtJ1J9w@mail.gmail.com>
Subject: [PATCH][smb3] smbdirect support can be configured by default  
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Author: Steve French <stfrench@microsoft.com>
Date:   Tue Apr 7 10:23:27 2020 -0500

    smb3: smbdirect support can be configured by default

    smbdirect support (SMB3 over RDMA) should be enabled by
    default in many configurations.

    It is not experimental and is stable enough and has enough
    performance benefits to recommend that it be configured by
    default.  Change the  "If unsure N" to "If unsure Y" in
    the description of the configuration parameter.

    Acked-by: Aurelien Aptel <aaptel@suse.com>
    Reviewed-by: Long Li <longli@microsoft.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 22cf04fb32d3..604f65f4b6c5 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -202,7 +202,7 @@ config CIFS_SMB_DIRECT
        help
          Enables SMB Direct support for SMB 3.0, 3.02 and 3.1.1.
          SMB Direct allows transferring SMB packets over RDMA. If unsure,
-         say N.
+         say Y.

 config CIFS_FSCACHE
        bool "Provide CIFS client caching support"


-- 
Thanks,

Steve
