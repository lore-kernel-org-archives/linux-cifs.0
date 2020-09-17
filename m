Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0611BC433E2
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 02:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3D12072E
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 02:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PhQ+u5UL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgIQCSB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Sep 2020 22:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQCSA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Sep 2020 22:18:00 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 22:18:00 EDT
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3194C06178B
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2020 19:08:01 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id x20so503599ybs.8
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2020 19:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JHnHkJ2uopug0Es0IzDJr1dgkC5qx7eXuHCd1M02iX8=;
        b=PhQ+u5UL+55fhl7fAWZVNUFqxJKA+H1P2GnxGonofPnFtyPiRLfdGkZ8Y2JQ28eatP
         /gKSCxS486U/CylmX1HGjr5nI8Sdy5f0gD1H2/HjJpT00XhfY8Q5RzLc076uKGttPY8h
         WDCWZKRXyQ6vwLzucfk1T1vIE+DMuDiq/0jL5Si6OAztB6082uFk74xRsUkuZGfkoDVd
         ks009IOhGkgWcyszupCznJxY+X4TwTjxxq7DOaRvf0GWD0Zff3w5W2JJUESKhhcDvXmr
         otOj0YZMQlHe4jUXXwlB/YputdeC0TWowv+d2eQ21+dbLYlmtgicHi5lL1VnIOOv13sq
         EpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JHnHkJ2uopug0Es0IzDJr1dgkC5qx7eXuHCd1M02iX8=;
        b=V0UR5Bf3yCallHp3G4IGW6EBT0IF/yudGShPHojyfK7nYYJnU10nBb7K0q76JcStpo
         mIS2wZvQP4/eJ3bUSpgMl/9kmmi7AVnT1Dz6c47jHS89Ey/chzxCwzOGTakB6Eb5qH5e
         iUWBdkaN+Us9EcNYZSyKbEiITa1W96BWjr1Wbo5lRSUBXi4q6wWGyeTAUkrQOkFTMZPg
         q/JYx34Th3dC8/p2JG6ribdYiS6YEIXZWwmyjPSI3xx36RptNqYhFXrLrZw1XMeQ6CAD
         hIsnVOPAEUdOIHWPLb3cd2mbK1b2AHtLxAzmbdRWsO1fQXKWuOwhVqfbDibWn31wrhcx
         TkLA==
X-Gm-Message-State: AOAM5322xA8FW0KMSPYFE6KSVdlO3vK0S/FeunPLvyZcaWhP2wQSsVA6
        dIIR3KxrwG5IDLes1m/teDF2zIUQREutJacDBfU=
X-Google-Smtp-Source: ABdhPJzvlc4q9trvVKdS9DzFUu1uhcU5oiWkUk/LJvr+XKVd7YaLxAqPqnDZb4FtUBNdn40NFJouDJhiqS/9RaNmNQ4=
X-Received: by 2002:a25:5f4c:: with SMTP id h12mr37314503ybm.97.1600308480669;
 Wed, 16 Sep 2020 19:08:00 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 17 Sep 2020 07:37:50 +0530
Message-ID: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
Subject: mutiuser request_key in both ntlmssp and krb5
To:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I was going through the code path in cifs.ko where we get the
credentials of an user using request_key mechanism. And I think there
may be an issue in both ntlmssp and krb5 case.

1. For ntlmssp, I see that the credentials are stored in the keyring
with IPv4 or IPv6 address as the key. Suppose the mount was initially
done using hostname, and IP address changes (more likely in Azure
scenario), we may end up looking for credentials with the wrong key.

2. For ntlmssp, if I add another user credentials to the keyring using
cifscreds, doesn=E2=80=99t that overwrite the prev user=E2=80=99s credentia=
ls? Or is
there a way to store multiple credentials for the same server?

3. For krb5, and multiuser mount, how should cifs.ko get the username
for a user? Currently, I don=E2=80=99t think we read the username from
anywhere.

--=20
-Shyam
