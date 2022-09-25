Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E464C6FA82
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 22:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiIYWbv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 18:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiIYWbm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 18:31:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C22C2CDF8
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 15:31:42 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id 13so10597055ejn.3
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 15:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3Ll/pVLkdT1bVWh7yn3N43sl9bxjylKfX4mgO44t6S4=;
        b=R80JjQBn07Hu990f11X74a3KO0tfTwxCPCQgbVcbcEMmZWRBqG+aDE3/ATIDk8hFQb
         e2QllSackr8tbAha7Dk5MThVWg2JoPFPe5ULfpCnZAGUjUmm+f479GKGZJkykv6Ul3Ou
         9vd1Yeha4AFoaFEc8OhvNAni8Hyip9DpL/pv1vRkyxUoGA8zR/4Gsr6BrCRbXJKE4A8d
         yF2DNuReeDW0OtacVoHkh3xALP8Y1yDE/rBZkkOt+Eg6Fvp54mZ+0fgl5wrm4hbsZrgj
         6yDjd6iNXMt7L/dVPUzlELMZank4+E0Cd3uASoZowdBfIKTxOOUueWYfdcXHXvSsUqvI
         5X1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3Ll/pVLkdT1bVWh7yn3N43sl9bxjylKfX4mgO44t6S4=;
        b=AHsw7v/wdxOtnnSnZ10Kw1xUTEqVjBNsESlaIcJe7b2nUCViPJa0gDcuUDPRhyXm+W
         V23KM7x5sCfL6cEm9TLM+X5NT2+0gPvrGlN4h1ZMn3WNo3fW57qHcp6+AG7F9a/Gcfxt
         PMSPdmVIm4p/Gaq1/t4zyhC+Qz4bUOVje3LmzZJyJZ5U3FTWRP5JKWura1GNuG4kVr8S
         vuDxHVRLrByGFXiMDfzq2rbA0Jd2ovnNCoj4WYoga5iKbdR/vrsfq9dm3LRqwuPUw8OI
         dKJiCk6v1GxJTOBkPjKAuMl6qe624VUEISq3EhoCsdZjyc/MA2Wx6uVK7qK/OdgtE0Uy
         vFVQ==
X-Gm-Message-State: ACrzQf0dBS1HTX8C3lWAka4HOT4Cx8bm1OXQ/3wKS/hf5b6k0nrVg6ur
        d+rMqKKgoiC3bEzgOzj8D+Rsu64ovUnoRR6rHkMdCB4K
X-Google-Smtp-Source: AMsMyM4qpz4x9MERG20aVVJxHzuDzX61F8mm+i9XjKkRDnYlQPijTTJzf/gnv8tYDEE389Hnnx4Aip+Vjj9pFUDzKDE=
X-Received: by 2002:a17:907:320a:b0:741:72ee:8f3 with SMTP id
 xg10-20020a170907320a00b0074172ee08f3mr16107308ejb.168.1664145100556; Sun, 25
 Sep 2022 15:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msb_fCs_cZC8unPmwH94APeOWhGFjBy7mn-jY0Jh3nTgw@mail.gmail.com>
In-Reply-To: <CAH2r5msb_fCs_cZC8unPmwH94APeOWhGFjBy7mn-jY0Jh3nTgw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 26 Sep 2022 08:31:28 +1000
Message-ID: <CAN05THRF4s88Cfm=63p0QdqW4KzqaD0mRq1=ptWRTGC6_9iyNg@mail.gmail.com>
Subject: Re: dir lease service hangs xfstest
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, 24 Sept 2022 at 11:03, Steve French <smfrench@gmail.com> wrote:
>
> Probably is due to patch 6 in the series but the dir lease series
> seems to hang (starting from 2nd xfs subtest run).  See:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1035
> vs. current for-next

Hmm. Remove patch 6 for now and I will try to reproduce locally.

>
> --
> Thanks,
>
> Steve
