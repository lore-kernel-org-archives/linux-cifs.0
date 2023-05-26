Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E36C77B7A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 12:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjEZMBs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 08:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjEZMBq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 08:01:46 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638EE125
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 05:01:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30add74cc30so115230f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685102498; x=1687694498;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yND35ais/ukG+uTh3KH7a9De2YZqNP7mXDsC69SJnlM=;
        b=zndeBKmy7vQdUTShwT7eFAF2WU52kDQMUlI0H12GCJW6/ahrt9Il9Hh+H+SrXRFzHj
         XrLC0QNjJcyxx8a72Ot+6CHWW7I1Dgeyl1zIi5z9zeIGyChZBJouAnD4Fi2R6nJEwAGI
         HrZ8UVsuxNUjSwLLB66hGTKSYOnum68DamLumhQbIxpWuWi67/be+NBFqfslwKkYFlWQ
         F1P2EGpD4GumkJVXl9TPChj97/Ymunj9GEqDPKaP7x4fuSZLytOrUTMMk89XsxeHG5wN
         WsEeBwX9dEFV3m9jO64u3e1FaJjm867hwl+D3FNMFVWyNMwvzhN1PXuVxu+r2JrS5CXU
         /qBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685102498; x=1687694498;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yND35ais/ukG+uTh3KH7a9De2YZqNP7mXDsC69SJnlM=;
        b=SC33ov/8U8ht1CjxTAZdmvKhMRiqjgK+JPkjEtrcn9JN55N551SdY34gJEOpFgoxEC
         7JY33p2TrHfg7wGJ4zVDWj+83exz23qwEY3VBCPvG4HfGmvSu9DVIO9+SX41tbSuSziv
         ra8R7JIuKBeBe+/RXffjMQ4YtXVVQ6KaPG/OblXekWDWTNeBFNiwJc9Tmyq60j4KkzJs
         TAT8F3GGNs06WXZqAHwjtGFhPjKBqinX4sDKA82/AFa5cKkTebjnZvbIF00tAF/AkWV8
         viHuJTz9UX4DHlH5wn2d0kiNJgVKeaqXVjXgyzoSp57AL8U9qIAqo1puCs/gh4PduPfp
         wstQ==
X-Gm-Message-State: AC+VfDxNO+H286M5ZKoqMpwmm4xjAg9CtsTNWr1IpFLXAe9NDOlwkKrU
        cqX3j6NAveZ9BaOeELSv0B8cDQ==
X-Google-Smtp-Source: ACHHUZ47+6xfUhFicStwKDOze5EQJV3MIf1AL/SQeZmtUnb4T3OshVkP4bhO87fqG4B9/SaKC8feCQ==
X-Received: by 2002:a5d:404b:0:b0:306:2c16:8359 with SMTP id w11-20020a5d404b000000b003062c168359mr1339056wrp.39.1685102497818;
        Fri, 26 May 2023 05:01:37 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e21-20020a05600c219500b003f604ca479esm8609669wme.3.2023.05.26.05.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 05:01:36 -0700 (PDT)
Date:   Fri, 26 May 2023 15:01:33 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Steve French <sfrench@samba.org>
Cc:     Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] smb: delete an unnecessary statement
Message-ID: <077d93ae-adbf-4425-9cc4-eea5163b050c@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We don't need to set the list iterators to NULL before a
list_for_each_entry() loop because they are assigned inside the
macro.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/smb/client/smb2ops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5065398665f1..6e3be58cfe49 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -618,7 +618,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		 * Add a new one instead
 		 */
 		spin_lock(&ses->iface_lock);
-		iface = niface = NULL;
 		list_for_each_entry_safe(iface, niface, &ses->iface_list,
 					 iface_head) {
 			ret = iface_cmp(iface, &tmp_iface);
-- 
2.39.2

