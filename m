Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A02CC77B7A
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 20:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjEQU4n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 16:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjEQU4n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 16:56:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF07B106
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 13:56:41 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f27977aed6so1468248e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 13:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684357000; x=1686949000;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k0U2Fq3ShImFNDxch8l92IXHWkElV47Y21SUnGd4+CU=;
        b=Yzk1Lu3LkVgfYNXI6N1Kt6r2Gp3Ap/8v8KL59L3j/UMNKqPM5KN1oobHnSmB0DiOjl
         C/WI7gdqGBUj4ll73F1DHyDE4JedBISWo4VXyOtoeazGXaiggEpJWKdPMkHKZB088dCM
         MdaoQ5qYYJJzveNl9HOUT+hGh/1B+GGNqVHJiepm04ZCcgIpbY+6f4JPC1+DgyP9/DMw
         AnoEUQoWzfeyZzcxon/Z4t2RbE/4rolIeRvrtJ+sUT4xDQYTD4kAJMUjdqLJhEEpsyvs
         9LzYQa7iyflk/hdAcJrOpCgCFRXap7Ctz96ynJhGAvQbDY2ngSxF9JgpMiHEA3is3ohX
         41pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684357000; x=1686949000;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k0U2Fq3ShImFNDxch8l92IXHWkElV47Y21SUnGd4+CU=;
        b=Rexl+It8r86aiQs5vR8J4mRyNuTq/CHT0z4NB/RncQMJSOTpSAfiHek4U9qn7fCipX
         xXLLH+sq1erR5U5Leqi/Badh9y8qJJrbbTmYwx06lVY0Hzavr1vUcUAzKwTSTgErnR31
         IM61cU5Lo7gkfYtuLoLnSxwgLIegjvM73T78YrWPnZ9H5C/HEgV6SwGYodINAFQot+KC
         vC9/wB8ujXluDeLbo1vbwQ+Gw5ZVtrnRDyVxq9gReBf/hl8643+v+SLkWplJO04pz5Fd
         WUJSpxTLBie9kzI5oF1sRxQNqHs/NP4krSbIIw7WTBfuLEnFqr/emPvc57xtGL/3cg48
         R57A==
X-Gm-Message-State: AC+VfDzGk5tJ1+sJXH/sdlAzwbvfKKM1KT3VOZXWzNhQ5f78KphzPpZh
        3T2GtpVu6397MckoROV/StwqMnEu6TZyzckO55CiGHUeH266Nw==
X-Google-Smtp-Source: ACHHUZ46RsRsQBP9bbTviIeir3zuRRLP3ziRt+oLhsGTqyQjZTFJ/11NrdFAZBhc4HCZoDS8pVU199FqQYlts+D2YMk=
X-Received: by 2002:ac2:4464:0:b0:4ee:dafa:cb00 with SMTP id
 y4-20020ac24464000000b004eedafacb00mr498061lfl.60.1684356999476; Wed, 17 May
 2023 13:56:39 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 May 2023 15:56:28 -0500
Message-ID: <CAH2r5mt=+=Xh+aNdfcFgB-yQuU_6NkUExpkYh5M4a9Axk4V9eQ@mail.gmail.com>
Subject: Linux client test automation improvements
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Migration of our Linux SMB3.1.1 client test automation (cifs.ko) to
the new host is showing progress, I have added additional tests, and
the tests run slightly faster overall.  Here is an example of a recent
run:

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/7/builds/11

With another test group (Azure multichannel) I did see a few
intermittent test failures although those may be related to the test
system or network not cifs.ko (see
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/1/builds/28
e.g.), still investigating those.

I will be rerunning the ksmbd and samba and samba POSIX test groups
today with the new setup (adding the additional tests which now work
with cifs.ko) and then finish by adding the main test group (which
crosses many server types)

-- 
Thanks,

Steve
