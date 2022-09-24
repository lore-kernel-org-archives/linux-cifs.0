Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BA4C04A95
	for <linux-cifs@archiver.kernel.org>; Sat, 24 Sep 2022 01:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbiIXBDq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Sep 2022 21:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIXBDp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Sep 2022 21:03:45 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2903C125195
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 18:03:44 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id s192so959684vkb.9
        for <linux-cifs@vger.kernel.org>; Fri, 23 Sep 2022 18:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=yOoUvLVJbDkLSavIFt0YnYSzOuY7RttBWzKgWK/okjg=;
        b=c9W4E6pWWtSs0XKTspRMmDN+P7SMb/YbNEs/MUyiTfeOsJeVOkDLCOj/yW91Jq3k98
         3e6IQduDTwlJhEMHaUM/BM+IQzmVD2X9PBF5pcjyu/5kFNNRbHnRugm3pcSLrwyQ6Ou3
         zxvYYiBTAOj2BV5zB5qxLuwGnJTZAxKfckRipx7YsqRH71l1hHIzePlAFaGsfkKcuJOV
         qFWXem0gY3iLcGzP9U9DdTwOfC7y+by5ndf081Z/0mZyIzl4d87Y7HmFy4+oux9iVwe5
         1TNj3mpa4wtrbHaDnnUDvXTVH4/AGbKkkodkJjyWfBt8oJKaJ0G5Kfsp6/IYAMYCYmP3
         tWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=yOoUvLVJbDkLSavIFt0YnYSzOuY7RttBWzKgWK/okjg=;
        b=5FRRaXBYSe01KOOU9o4wlILAOcvaReoSEOSIrKUKAaBxLnH1dFPk5cXr9c0SjEdlih
         uwPW+1+nN3Z3ytfbIw4n4w88ZfIeLrlxPqwWRGRwq/xI1njJfBwS2yMYXWH+g1DAzHk/
         y8AzWbsXuiaaZjcLkn95VDECt/oi7bqRDA18YjjRhEyGiiXVEqXSZJzbaqLvG8y1L7d9
         e6IQBPrdQYkl4MsDXJ4HYUPplmUl8MAWvd9PGgJO5Qg3pRTEMREWSt9K3cqgQL7sEbKo
         M4KLTPvjlZiYM5siR/+WMH0PlLJK5cmge/nq2W1P6SmWrixW79EcPYPfizaAjcMU9mVP
         2gVw==
X-Gm-Message-State: ACrzQf1iWiTUOVbL6y17lHpaRmjTrWQ1gXrtPjFoIKzJ8nP3GZE1il+K
        NOfRFn4YtVziC0BrJuZLzgbYiYA69RVEJIOuGzNuPHD/BS8=
X-Google-Smtp-Source: AMsMyM5tPrB4kI5+R3+ZqJWYm0JKyQhDv71ecGN47y8LwAY5UylGURCLuHDpWTNJDEzGfMARNCy3qu9qKGKuCEks4bQ=
X-Received: by 2002:a05:6122:10dc:b0:3a3:4904:2941 with SMTP id
 l28-20020a05612210dc00b003a349042941mr4835086vko.24.1663981422995; Fri, 23
 Sep 2022 18:03:42 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 23 Sep 2022 20:03:32 -0500
Message-ID: <CAH2r5msb_fCs_cZC8unPmwH94APeOWhGFjBy7mn-jY0Jh3nTgw@mail.gmail.com>
Subject: dir lease service hangs xfstest
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Probably is due to patch 6 in the series but the dir lease series
seems to hang (starting from 2nd xfs subtest run).  See:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1035
vs. current for-next

-- 
Thanks,

Steve
