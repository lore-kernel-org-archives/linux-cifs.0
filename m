Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667F8C001DF
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jul 2023 07:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjGXH4Z (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jul 2023 03:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbjGXH4E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jul 2023 03:56:04 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC011981
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 00:55:37 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-31758eb5db8so998174f8f.2
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jul 2023 00:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690185336; x=1690790136;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ral5MrVVkWIMNXIYZez+l/nT0KAiAmRhvEB6dW3iwXE=;
        b=bzMHMDZ1DBn8oyVosDEc0VNKNkjETca9CVOpwCSXdycEa0lXhMGhaHdiR6E1C8LRDj
         ljs2awh2IQZdiuvY+GmnIu8kvqfxZDocloImkWDZ4GXEBMjrAubORtqiGPlS6l67OJRo
         0Bjq8w2BThA5zgbeh5LCvutr1ZDNqfB4tcmv7ubyaquxbq+z2pEagof8RxY86SJ/Nu3b
         7Sq1Uudml8K4u/XMSaL/kNBV0pV+l02kwIKyQHZPyk2SlEUagGoSyD3qUZt/3FQ1EwDd
         Bf97+x2GlzyuDkFizPYOvguICwLOLx3rS9LKdgNQBA81jpat6Buv8zrMqmrWQXqkVRD1
         ravw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690185336; x=1690790136;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ral5MrVVkWIMNXIYZez+l/nT0KAiAmRhvEB6dW3iwXE=;
        b=BFyOzf/DXr6jezvosk0hy32fJ4Elbq/EgKm4ZVjAdctYm+vyIn88eDPPBY2z71IcMA
         eYtlNZoUQsULjDakPvyWAI6Ng300gQvTA9Tczh/9TR4exWR7fNdaUSaAodeizhpcfNgb
         Mz9W3BYGR080t0m5ay97TtVvuAjqitiTF1g4MpsepFjtVA3+fAI0lTjP8i9uoAX/BwNu
         O68IxG4DF+tVP40X3AK2SwCfW+Ow75woXiBoUT9X0DIB0eUDhqS+ITsUMYCCLstmJUk7
         N6OQiE3aL4xxtg0hTXnpUh1MCHfAO8Bwv87NXzEaodHAbfF5wJJWdocC/zhC2AImTiW3
         9uiA==
X-Gm-Message-State: ABy/qLZkl+++leKQZpj0UqEecBpk3SwfjHXK1yTJMZ6mXVtCkeBG3rwX
        DQLsOI/Z+WeJUWCqYk96acST1NBftRKRMB9XfSM=
X-Google-Smtp-Source: APBJJlFyzNcYA+FPfkKkAIx7VkVBGQ8GTIfkXk7qAvxf8mzqYQve5Tl7s5HyJWys1BDpe7lEgEv85A==
X-Received: by 2002:a5d:484d:0:b0:315:8fc0:915e with SMTP id n13-20020a5d484d000000b003158fc0915emr7466333wrs.56.1690185336347;
        Mon, 24 Jul 2023 00:55:36 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id n5-20020a5d67c5000000b0031416362e23sm12078784wrw.3.2023.07.24.00.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 00:55:36 -0700 (PDT)
Date:   Mon, 24 Jul 2023 10:55:32 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     nspmangalore@gmail.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: allow dumping keys for directories too
Message-ID: <e36ce0a0-7bed-4184-8068-82151f175bec@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Shyam Prasad N,

The patch 27bfeaa7b929: "cifs: allow dumping keys for directories
too" from Jun 16, 2023 (linux-next), leads to the following Smatch
static checker warning:

	fs/smb/client/ioctl.c:481 cifs_ioctl()
	error: 'tlink' dereferencing possible ERR_PTR()

fs/smb/client/ioctl.c
    469                 case CIFS_DUMP_FULL_KEY:
    470                         /*
    471                          * Dump encryption keys (handles any key sizes)
    472                          */
    473                         if (pSMBFile == NULL)
    474                                 break;
    475                         if (!capable(CAP_SYS_ADMIN)) {
    476                                 rc = -EACCES;
    477                                 break;
    478                         }
    479                         cifs_sb = CIFS_SB(inode->i_sb);
    480                         tlink = cifs_sb_tlink(cifs_sb);

cifs_sb_tlink() requires error checking.

--> 481                         tcon = tlink_tcon(tlink);
    482                         rc = cifs_dump_full_key(tcon, (void __user *)arg);
    483                         cifs_put_tlink(tlink);
    484                         break;
    485                 case CIFS_IOC_NOTIFY:
    486                         if (!S_ISDIR(inode->i_mode)) {
    487                                 /* Notify can only be done on directories */
    488                                 rc = -EOPNOTSUPP;
    489                                 break;
    490                         }
    491                         cifs_sb = CIFS_SB(inode->i_sb);
    492                         tlink = cifs_sb_tlink(cifs_sb);
    493                         if (IS_ERR(tlink)) {
    494                                 rc = PTR_ERR(tlink);
    495                                 break;
    496                         }
    497                         tcon = tlink_tcon(tlink);
    498                         if (tcon && tcon->ses->server->ops->notify) {
    499                                 rc = tcon->ses->server->ops->notify(xid,
    500                                                 filep, (void __user *)arg,
    501                                                 false /* no ret data */);
    502                                 cifs_dbg(FYI, "ioctl notify rc %d\n", rc);
    503                         } else
    504                                 rc = -EOPNOTSUPP;
    505                         cifs_put_tlink(tlink);
    506                         break;

regards,
dan carpenter
