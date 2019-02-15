Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 007B7C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4EE821934
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 01:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f+WEUfKn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfBOBCs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 20:02:48 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:41394 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfBOBCs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Feb 2019 20:02:48 -0500
Received: by mail-lj1-f181.google.com with SMTP id e17-v6so6910675lja.8
        for <linux-cifs@vger.kernel.org>; Thu, 14 Feb 2019 17:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=S3JQIut61Khu9QwPwoZE0fZCc2GhvbkINBe3Ii+ctXs=;
        b=f+WEUfKnoW7w7uKUPOmFPmyAdRMVrF97Wu4JWO7uDbR/nZpdbuwUhpG/QSE2NgJ57M
         XkvF77acKoitDtrZTPwgzMrDc58ZgKBfvP2PwTaokfcWoOnbjKTMVl1D1cRe+9eWhCil
         wIOMJVWPi4vFeFHk6l7+uZUDqTtOlqsS7e9FxQ0aeUDDbIXdLRlnoxTbW1tfU4f3abtB
         QY6Hxbehi0sErMD+OF1N7hPkpqhVQeWPjviyABbp/KoX9NCG4KlEa3luWpLu6ZQ84Znf
         +2aXLIRzjgjWDJUR91pN7S4EjAIlWKQ9uH2FXtOpyyOhE1VLiKFxXjonzgXS/IFQGflS
         0GWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=S3JQIut61Khu9QwPwoZE0fZCc2GhvbkINBe3Ii+ctXs=;
        b=bjoHcJ5jbxmuwVTtwCAw1ro3EcNTFqMJrUJe6Y/6NNVKCMGBDKCbWdHvHfG+ihEzQq
         gzkD9PjTo+7DetH7jpP+fsuJlAhI8vG5l2iRfxCMP8b+GHyVYQXMQcQFpBCfIcE5gCjX
         LlffRyBER4B16pHvJO4+cwOzPBWbmFcpJpPAU+RDi/dRsn8DnN4QJJGN/woqg5eGweBs
         tG3qYl2+K+wjN2L52RnGRwJ1JcSpnAwCMsR73I9QlR4XJ5i9jZiJ/r/8U/f3SkV6LmfD
         Hd51YftPBvwt4ot4ge9SZxV6LHQukvO6Ub6U52pFyr6TczcQjxIh7QO3jW3UWWqrbYi3
         tksg==
X-Gm-Message-State: AHQUAuY/kFg9zp2SbaaGNsm6rCT7ahqf7rmuHUiLD5OVEfN0uWVba8Rf
        dCTaclIrhmU9ZKpYQGLaANGUW6pmhRCenUZR4RDTAlc=
X-Google-Smtp-Source: AHgI3IbPMR84JhthHmNA+Kf/+i7WOZI9sGXXzEhy+S5ZP07WCW0rE0Zb7JcMvK+sOq/Pg14sSFz+dBKlvIaiy8r/49A=
X-Received: by 2002:a2e:9a09:: with SMTP id o9-v6mr4013874lji.132.1550192565375;
 Thu, 14 Feb 2019 17:02:45 -0800 (PST)
MIME-Version: 1.0
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 14 Feb 2019 17:02:34 -0800
Message-ID: <CAKywueRwez4Djs50dMityuA=hnE6SMeWUJ8xdTYs+jEhNvdCog@mail.gmail.com>
Subject: [cifs-utils] next branch is updated
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <palcantara@suse.de>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

I updated the next branch with all the pending patches that I could find:

https://github.com/piastry/cifs-utils/commits/next

Please take a look in case anything is missed.

--
Best regards,
Pavel Shilovsky
