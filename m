Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842CFC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 01:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiEQBL1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 May 2022 21:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240813AbiEQBLV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 May 2022 21:11:21 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36615369FE
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 18:11:20 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id v4so20073024ljd.10
        for <linux-cifs@vger.kernel.org>; Mon, 16 May 2022 18:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=npUul0ZkF4DiqZyxM/QDxgoc2Q+eTH7b6S+ofS3UumM=;
        b=jfF7WK59c8R9oPZWRapIw6nxt6A7wfjuuAkeSNM3ieT1q3tGrxokLjtHGF9Rveu3lW
         wi94PFDukIxVTX5/V07fifZoI0Z5vlSq54CHA3AN9WCeo8eCXn0mxurYHmgqiqtCnRW/
         ZYurgL2usZupl10Myr/BTgG07lCC6FxG2yY4ZqnTyl384mRgJ1ab5jP/v6Val5PQOtIQ
         I0OEJrazJhruGHaRu7FulUV4iDu+uCeI7dojbXcXSE6f5r/pFnWl8p40gzYD67FaPHfq
         0aUOZ2bbe3nC4vZMk3HzQdQyLg1GQ7Hf7JfIEVGv6ZgHlmPgM6XDXSNI4/rbo5O3oEcC
         N4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=npUul0ZkF4DiqZyxM/QDxgoc2Q+eTH7b6S+ofS3UumM=;
        b=z3bYvzqFmH20looDcIEWisXwerkC4q8uNKfK0YNCYQx7znDHrPsDZ4je2O8LiClMRa
         3jma8KIIYDaNA/wtVt0XYzjGkz9U6OWl6EbT39yGtDV0j3IPrnGj4SPR2ByVam/zZ4tp
         hGMqTv5iwDiI5PwwiONm1PSbgp7dUQP+lexU5Q/641clzQJb3p2qHp98eKv082O0ctBE
         xgxvtBEXqUxigu1sOVjO3UwpSnSNha/1E+sPS/6IIXBOH/Vu6xqrrT+dF+u9c2eOKkMG
         xlmJxn86WJnLmyIo7hRlqObF665fZtkLjLxTM4seNhQElhDG3hBTrMKRdUIUdBvWevs4
         ULXg==
X-Gm-Message-State: AOAM533w1oL4khUKerrmWhYBfFA07oPDPlZSR4XBeEtbGKclkrG6jdf7
        9r8ktnGjCZjRrMSKhKzoqP+UntViOpVHz31e1xLkf+8uMVg=
X-Google-Smtp-Source: ABdhPJxqxrF3tgF9bk3XQR5papcb9tYQ5MS9E8OyGEu4sDavqwB2vvFlYiggg36Ubrj3vMCv7z+WfLxEyc1mpv4XNOA=
X-Received: by 2002:a2e:a17c:0:b0:250:c47e:3d5a with SMTP id
 u28-20020a2ea17c000000b00250c47e3d5amr12846699ljl.314.1652749878108; Mon, 16
 May 2022 18:11:18 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 16 May 2022 20:11:07 -0500
Message-ID: <CAH2r5mu1cWEuHAJiY4T6zNKgWNwaoVevpnT7hrHwbbPa=AQiDw@mail.gmail.com>
Subject: non-cifs change post 5.18-rc4 causing buildbot regressions
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Noticed various xfstests failing (see e.g.
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/220)
in 5.18-rc7 but not in 5.18-rc4.   Anyone else noticing this?  No
cifs.ko changes during this time period so could be unrelated to
cifs.ko (e.g. mm or VFS change)

-- 
Thanks,

Steve
