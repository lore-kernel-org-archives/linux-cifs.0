Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BD4C04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 15:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiI1PuV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiI1PuT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 11:50:19 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CA18275A
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 08:50:11 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id bu4so4816219uab.6
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 08:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date;
        bh=C0CP9ujk/hPFRxYPTKvsHo6nmETiwTxEAK2IM2xv4Xw=;
        b=JyjUCkWMYZPbUcM1e0LnjnGruIQqsOhgP46bTiWrFKELumSSSU13V3OcmQQS+ljrUz
         I023M2nMhUqHpU9TnqJjOrUV377J75OerJBpJqg0OqYEl2H01UDND5sqqcyN3krRugbg
         9zGKMFcvORziAlLSIMNcg1hZ4B10BKCorGEYmPj69DY6esPm5Vl52jttqUBX5kmxQ0Nm
         e60uXXN/oPtSw5tzfKWkUQcLXxH8n1tU2Eozybvp4Sn6jR83zZXjbD/Bht2rF9Pe8G61
         TBKYWFVyTGjRozMMzmqBWnqN5A5pMQsTr8FDi70fV25lISzxTwz3+5BpmBt4ZelvNN38
         OB0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=C0CP9ujk/hPFRxYPTKvsHo6nmETiwTxEAK2IM2xv4Xw=;
        b=Ro/0IkSVIg58/W38Lamzfg86yoCuH1iMy7vlG3VfTVz5k3aew8BldkGNB+p7+c1PVP
         LcWWZeRskG8mLAZy8V45ks8PPx+Ue91CJSWV6jIsd9dTcW1J64EWrPBKiIUVMVCmywnE
         Kmuva55FwCDmthMI4dWXuw0gS6V03dU4hyRQEUMy7bjL/Wnvm2rtXxT6kmeywly3suMW
         5hP0mBu5ErTnpJgECdTzjuEAOlmfVk8yAvf1ZTRhcHGJYN61dSUUl4TxvD6Xxe1s2mH+
         kuatR6b2JMsy9kwMysZHrCShfHslnpZA+Ks7RXICr0zAeOjefHVywH0HNk4oLr472uQW
         /rEA==
X-Gm-Message-State: ACrzQf1r4jLQgrE4gqzOUx7cRZxkefKbSZifvfaHw9r72BlxqNkiyB1i
        Bt+V6eDRA65Xw+Va7OPeBE5AxqbMvpwrCZrHE/jZ1mit
X-Google-Smtp-Source: AMsMyM5ne/wPRD/pRXQ7uVfqQa3LEZ5xoILDwWaHSgJMyJCkFX7203T5hGFkQxk57v4wzuhijNqaB3sBhroDRrcpSUk=
X-Received: by 2002:ab0:474e:0:b0:3b0:5e66:bf47 with SMTP id
 i14-20020ab0474e000000b003b05e66bf47mr15337099uac.4.1664380210285; Wed, 28
 Sep 2022 08:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtg603usx5f=-+U6S-Lv5oWKjoxFpmKUC6xMq-XB2gTxg@mail.gmail.com>
In-Reply-To: <CAH2r5mtg603usx5f=-+U6S-Lv5oWKjoxFpmKUC6xMq-XB2gTxg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Sep 2022 10:49:59 -0500
Message-ID: <CAH2r5mu2aGmf0uM6GBAV8zhA2rUiJ_nJ1CEP631J+KrWadOeLg@mail.gmail.com>
Subject: Fwd: Buildbot: builder cifs-testing build 1038
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Wed, Sep 28, 2022 at 10:16 AM
Subject: Buildbot: builder cifs-testing build 1038
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>


http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/1038

Theories on the xfstest failures with the first five of your six dir
lease patches?


-- 
Thanks,

Steve
