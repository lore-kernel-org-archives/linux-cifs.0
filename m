Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27846C433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Apr 2021 00:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F033D61006
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Apr 2021 00:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhDXAS2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Apr 2021 20:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244122AbhDXASS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Apr 2021 20:18:18 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAB4C06138B
        for <linux-cifs@vger.kernel.org>; Fri, 23 Apr 2021 17:17:18 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id r128so52956820lff.4
        for <linux-cifs@vger.kernel.org>; Fri, 23 Apr 2021 17:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=f60DKfhnTWzerVWg+d3ePHTdQ1Fzoqv5V04Asm/JP3s=;
        b=jIQGKIDIOBWcV9WjZnz3kWTOFIdyA/iveqFhA8gPxzfxO0cl1qSft3nWlJZ55yYGNo
         Cm/KhtCq3ylsruagKBER+wJUTOlPpOPl4y0ohA50H3gowflJAb5sakprdym7bEFhWF2Z
         CjmVZvcINwSUIBtBPPkGTsj1JjShQJ0/vjFkfmts/IRlrl1Xm4LDhdMiy2x/Z+/ZJhiR
         hn3Aqc44Y6wpr0jOkloIKiA8Ht8SDCGF4P1/J90Vy1SzbibeVDQT06TNQ3y4/WZHLe41
         2iYuHXZLJJgOWFsyQwhpUmXs4nU0eT9kcIoJn8XCN29SPwLVlR5slP05zmYXeCp+sWXU
         ahEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=f60DKfhnTWzerVWg+d3ePHTdQ1Fzoqv5V04Asm/JP3s=;
        b=aG3dTq8bgQBskmZvMCk20YOZEuL0CqYZGdd8q5NNX804b8FRI7dQ+xm8OtQoDakegW
         WXztEABETWqaFZxvI8Af+m3+RdL0exAjM4g1PIrhNfaMfKX7hNB8gHz9zYJTwcGbX4ee
         Ub5xw/dpiHdS9y6+D6AuzVZ6DxAVH+5mbm7AIhQ4g0lI71N20t7gaUQTY54qpqjrkZ1Q
         HJF/Da4kUTHtroZyqHZaBeu4ZDhQSAvfCihhOJ1nCJtwfJ9jqonSQE0hEjHxHbt5pYkY
         b9R1shrxUJjuj/1lvySZmMQdMrh7uPRy7kDPw1DG+Y7dN1DU9ATu0CVchb0+LNpX8uTa
         KIqg==
X-Gm-Message-State: AOAM53127BsOphXFup/ySMRXKwVTAo7m49jewwM+Pc2pzDgtyMRQZLAJ
        GzDFNaEYCgYEVoRdNK5G5ufwPyXoeWnQYS8DzeM=
X-Google-Smtp-Source: ABdhPJyL5GBPfz0+VOz71NNIndJHfOMcwOGs/2f1yjA8sxI5WMimRVXCIBt+Htdttbgai4MilzUJtwsdK/bXTOgoxkw=
X-Received: by 2002:ac2:5f74:: with SMTP id c20mr4588504lfc.282.1619223436786;
 Fri, 23 Apr 2021 17:17:16 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Apr 2021 19:17:05 -0500
Message-ID: <CAH2r5muv6Dds-rwBqr0go+snow_nZxVML7unENyvt3XNndA6Rg@mail.gmail.com>
Subject: mount context "got_ ..." variables
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do you know why we set "got_rsize" and "got_bsize"?  I don't see
checks for these?

case Opt_rsize:
ctx->rsize = result.uint_32;
ctx->got_rsize = true;
break;

-- 
Thanks,

Steve
