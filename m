Return-Path: <SRS0=e1Ds=BJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C60B9C433E1
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jul 2020 16:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A02C20829
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jul 2020 16:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVq7uWl4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgG3QOQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jul 2020 12:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3QOP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jul 2020 12:14:15 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9890AC061574
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2020 09:14:15 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id v6so13538028iow.11
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2020 09:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RCWzddazJlIHQptRlypC2GSdXc3zmJWBhcgTeh7vkBw=;
        b=QVq7uWl4jZyB78iS4Yr4DZM15O6/voZHMbMRAPxYViY5riLifyA/bPFPGajaFIvEgX
         TtnPMioGkbZ0AZF7oi8KLf30F2rh1lc8i1LghTsI/FN0Vv60h4Eq7K82DuKOFqOf/gqk
         yN1OkdPJh2KZMwPNCRUia32RoqtNy5/H+lE82oPjDxdCPzn63BogivhynpmM74wjuhGK
         bpu+XWP0AzJona5LwCfXCzjCJX3TMLID5nA167n4x73r6vWuzQ0/BVQxIqXh/XdvVtK2
         AwRpvc3YH8rtxl6RoQQnFpU77yGS/uQxmOH5h3xSJcPIst4njH+7CiQQPvxuoItcRNji
         3f4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RCWzddazJlIHQptRlypC2GSdXc3zmJWBhcgTeh7vkBw=;
        b=qeuD1VzvFXcFu9OmIeCiP8TkIX/Ak1rBxEAL0C/kZNQNyaThk/55Sb6V+UjAnLG/+u
         n0XWvqm6aVRBOQzUq/81rIYxc5D14QyN7KHrshWps+ksBHVmwmhAMSJWSfnOSHJbHY7C
         CYG3pUMnCoRsnErxNZcTi8cc/0g0ZEcS35xyhPfUHL/NykWXnCNE+KYvAfoD7Df+Bgal
         a/cFyEGP5I8XCOKjw6xb0wvrCA32Th5UXe7xNNOAKQe6eAuMeOYPRT1Z1Y4qkX+Tsb8O
         GxPdXHUAVvN3Yf/tn+uj66SqwLFdBAs/q8A2xA8EBISvZ9ttMurSQ6npN7rqU8huCndY
         HH0Q==
X-Gm-Message-State: AOAM5309LzvEXsvL3R3Xsca0X9z4gsfYmKDGS/qogFkrizaz/fgCBV93
        ROyOmu1YVvYhYGDagZuLBmpl6TReyNZz3liQAxxfzcYJrLU=
X-Google-Smtp-Source: ABdhPJzU8l3AixNB09/arbpkd6F0og/Y80ZVddZ/kIxn4qiQIWbzDTjpXXQBRF87tUGLxPoGC6V1OHAA844ZW/PI9NQ=
X-Received: by 2002:a05:6638:1414:: with SMTP id k20mr976838jad.76.1596125654460;
 Thu, 30 Jul 2020 09:14:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 30 Jul 2020 11:14:03 -0500
Message-ID: <CAH2r5mtWw8_f0TNLC2TdsAV4sgUBM8rNKdvXgUSGFY0s=2v0uQ@mail.gmail.com>
Subject: More xfstest tests added to cifs.ko regression testing
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added tests: 565, 567, 568, 591

See
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/378

-- 
Thanks,

Steve
