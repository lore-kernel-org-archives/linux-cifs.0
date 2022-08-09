Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29F5CC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 00:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244628AbiHIAiY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHIAiX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 20:38:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57BD12AB3
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 17:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8387361156
        for <linux-cifs@vger.kernel.org>; Tue,  9 Aug 2022 00:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA168C433D7
        for <linux-cifs@vger.kernel.org>; Tue,  9 Aug 2022 00:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660005501;
        bh=UgCWKi3Gn9PIdsPgmiUACOtwyuGqJ5PCZQ1o3z7AwFo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ONiWAMo5AGkJlum3Axo5lfipd59HVP/LdRHQfONPd9seBQWm83/DhDqo7XrNoL0Q/
         vsRbSOqda9aiBPExeefaONbcHttdVW/ADq+AFZzOzyfXpYc5pvIwNMiVAbmAV+VySv
         AdsdIv79nqgXITbx/r+Ixr7jDNJUnFIW1sfs38pZrEQIINH9wK/C+nd2QVOgW53K3p
         6/JxFsnskZByJcdI0EOEsEMzFKEQAcQRyHRdj7Iu4YKlDZx/MggTPpH8mBdYIYSDkR
         w1gbhSPTqsi8XLn7RftBCRDtwdtkHCiV8zel8zGqEZv4FMv1xnvMdY+k0QIqjlUkYq
         RLYGCut3k9Pfw==
Received: by mail-ot1-f43.google.com with SMTP id q6-20020a05683033c600b0061d2f64df5dso7549574ott.13
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 17:38:21 -0700 (PDT)
X-Gm-Message-State: ACgBeo1yKoj5tPjhcoCyb+zgCMzPyzWHaWxKeqRgKKQjVKdylaWLmXac
        PqHBVTgxBcbozXIwL+43+s68BxEHIVmlrtowqAE=
X-Google-Smtp-Source: AA6agR4OyX17F5e0p0c64jSq6NN0llF4EaaCyQHdIedVc6iss7FG2bgPVT6nuBi3wFlm8spu4NYxEE4m3LXECY52K+E=
X-Received: by 2002:a9d:5619:0:b0:617:3dd:f32b with SMTP id
 e25-20020a9d5619000000b0061703ddf32bmr7748969oti.187.1660005500968; Mon, 08
 Aug 2022 17:38:20 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 8 Aug 2022 17:38:20
 -0700 (PDT)
In-Reply-To: <20220808220216.17235-1-atteh.mailbox@gmail.com>
References: <20220808220216.17235-1-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 9 Aug 2022 09:38:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9CBR92ydiBj+1u7hEnmahOK9V4qorJVzO0D1+iXJ4qzQ@mail.gmail.com>
Message-ID: <CAKYAXd9CBR92ydiBj+1u7hEnmahOK9V4qorJVzO0D1+iXJ4qzQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ksmbd: request update to stale share config
To:     atheik <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-09 7:02 GMT+09:00, atheik <atteh.mailbox@gmail.com>:
> ksmbd_share_config_get() retrieves the cached share config as long
> as there is at least one connection to the share. This is an issue when
> the user space utilities are used to update share configs. In that case
> there is a need to inform ksmbd that it should not use the cached share
> config for a new connection to the share. With these changes the tree
> connection flag KSMBD_TREE_CONN_FLAG_UPDATE indicates this. When this
> flag is set, ksmbd removes the share config from the shares hash table
> meaning that ksmbd_share_config_get() ends up requesting a share config
> from user space.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
