Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A463DC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 29 May 2022 04:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiE2EEp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 May 2022 00:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiE2EEn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 May 2022 00:04:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C868BD11
        for <linux-cifs@vger.kernel.org>; Sat, 28 May 2022 21:04:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAE32B80919
        for <linux-cifs@vger.kernel.org>; Sun, 29 May 2022 04:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AA5C385B8
        for <linux-cifs@vger.kernel.org>; Sun, 29 May 2022 04:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653797078;
        bh=zpQs0ENfYbn/W5NOj2uq+Xd7KdwzgnuIiMljYaRvyU8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Hu/tAaWsQIvil6kLfeuZxi2s2G1UWcrEQwHujG81cvnaJvqPTvYx6P3galgn+Ov+u
         2eBYOYe3+rVulkuSDYX6JM+7AFRrQ/P8htp5eoaBkOn0tVMmCl51gq/hptm3yZ7HhI
         yOikWD94584czUdxEFlK5LeG8YhieB9DVNXGqglbh8aME1Fq8pcdarmo4rJaupJnBH
         8Tai8o4d5R618sWSGNomTkKUaN219C8UMZhlMhJXWtb3KGYxOZXVHAqEsUiaHEU2sh
         LOGg4HznaKk3skrNjEKcGyT4gY5xdmSrNtafRIYV0aJI2DDPsN+63JZTxxar3kgfWV
         a7BiRwxLoQOFw==
Received: by mail-wr1-f49.google.com with SMTP id i6so2901706wrw.5
        for <linux-cifs@vger.kernel.org>; Sat, 28 May 2022 21:04:38 -0700 (PDT)
X-Gm-Message-State: AOAM533XeAo8yMy+/mObLvVtjPV6AsmxZEmNugD4P4sr75lnBCZCYt8r
        xQ56N1kYuE1U7Pd3nI3cN617mF/bRUa/MopSW/g=
X-Google-Smtp-Source: ABdhPJw/qsczTBYEMMDbZA56pOuJL5GcNhldu/9lLHJVtM/kr69wPWrvzuXHM9YLoFoET/CxXUoR/Joj1UcMDKMEg90=
X-Received: by 2002:adf:d1c4:0:b0:210:1935:3dd8 with SMTP id
 b4-20020adfd1c4000000b0021019353dd8mr8312048wrd.229.1653797076692; Sat, 28
 May 2022 21:04:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:ee4e:0:0:0:0:0 with HTTP; Sat, 28 May 2022 21:04:36
 -0700 (PDT)
In-Reply-To: <CAH2r5muLr-UKAhcoP-s2Hn=U=Hbe2PtTLKODD+biSzQS8FkfZg@mail.gmail.com>
References: <CAH2r5muLr-UKAhcoP-s2Hn=U=Hbe2PtTLKODD+biSzQS8FkfZg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 29 May 2022 13:04:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-k6t+CL3DiZCPNyW6F10JbGnBrXmddAEMsVxaBrzbsBw@mail.gmail.com>
Message-ID: <CAKYAXd-k6t+CL3DiZCPNyW6F10JbGnBrXmddAEMsVxaBrzbsBw@mail.gmail.com>
Subject: Re: xfstests passed for current mainline against current ksmbd-for-next
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-29 12:53 GMT+09:00, Steve French <smfrench@gmail.com>:
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/108
Thanks for your test!

>
> --
> Thanks,
>
> Steve
>
