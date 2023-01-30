Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7823FC05027
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Jan 2023 00:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjA3APL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Jan 2023 19:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjA3APK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Jan 2023 19:15:10 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A071D199D7
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jan 2023 16:15:09 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id t12so11116812lji.13
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jan 2023 16:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mckd2DI46eMFQEEYqNnffLmF7XoaDgxAo4sggosflkY=;
        b=D7rTsM3a4qfW0TLsK1RTsKT5eUTuauXlCC0azZYagcgjQtTNFSsZJJlcZC+a9/5Fjb
         vQ4ToqTazs1RAUxwdw6BWWT6XOUjYiy0VxN6IlrV9Myj1z1Vtay9A9WwfnD1kVp4YCUb
         7+JndnZwk1N4reNPC5rwNSan+2UKmP6BOD2AwlY2tMdiZnb90+wF/SIA3AIRMYLs1FvX
         mYCZQpWdFqVeKtOFhtou/Mk3ECMoHmMH/nWyEasbmcwKL0PjoP+vAFlolHUWwZVyBSnL
         3LYfck6O+b8oHK8sv5Bx6MEQfXCWXp32POX4bcL8Sg/I0cwwfpxIDqKFo0jjkfz+pUju
         3zaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mckd2DI46eMFQEEYqNnffLmF7XoaDgxAo4sggosflkY=;
        b=NdCoDmpa2BXCf7xKUnvKVcpmjT5ZT6JXgpjHHHx191HcQzoPGFrSSK4H5/55EfvGrn
         /hbt904tFtftaPQoQ2viTaQYHDq53kasNExvrEOkQurOP+VJiE328YBDNdmmOpnuCKDd
         gJ7qzgd3z17BEt/Vjyc1UEXsLqLcr6CumnsTQqFc1/ZEwrPZ7IuGpbbwqma6ScOESYaM
         w3WslsWHKqpZqZld4V/9yVXvCoHws3GW9tZFHa0SlNYiMEcmL9pJhG4yHtI8x6j+4Z2y
         wn6rQsg4HX5cAEuB0ZwDgobalz0vLiYRpl/s1gYLM9oQbziyIa46oik1V5qBqBdNRlWa
         Iabg==
X-Gm-Message-State: AFqh2kp4JG4lWQPK3cAlfegk8yj+6TtybTrKi6pLe0+I37lmwNyRniXL
        1ANEO4OMAO1wE1yEF1GFWQGncMCNV2PXHnxabzjFN2jF8Ac=
X-Google-Smtp-Source: AMrXdXts1QHO3UGPxNzlPb1jD8VQpPqiS73kf18kbE5TMbJPOu/KzzCMcHdhySB0AlcxtTAf3adYoFyKyw6Qr/PM5oM=
X-Received: by 2002:a05:651c:481:b0:28b:a09b:b02e with SMTP id
 s1-20020a05651c048100b0028ba09bb02emr2901596ljc.106.1675037707411; Sun, 29
 Jan 2023 16:15:07 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 29 Jan 2023 18:14:56 -0600
Message-ID: <CAH2r5muJ2DZySJMTNww6uhjGmf3N31s=N896tJ-7HKGhwUn4+w@mail.gmail.com>
Subject: ksmbd-for-next udpated
To:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Six patches for 6.3-rc for ksmbd server included so far:

$ git log --oneline -7
c63a0e4fe477 (HEAD -> ksmbd-for-next, origin/ksmbd-for-next) ksmbd:
update Kconfig to note Kerberos support and fix indentation
35caa2e2d148 ksmbd: Remove duplicated codes
c2809fc63119 ksmbd: fix typo, syncronous->synchronous
1c42cd62499e ksmbd: replace rwlock with rcu for concurrenct access on conn list
b685757c7b08 ksmbd: Implements sess->rpc_handle_list as xarray
1d9c4172110e ksmbd: Implements sess->ksmbd_chann_list as xarray
6d796c50f84c (linus/master) Linux 6.2-rc6


-- 
Thanks,

Steve
