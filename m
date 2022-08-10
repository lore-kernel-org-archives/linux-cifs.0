Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344A0C00140
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Aug 2022 08:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbiHJIGk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Aug 2022 04:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiHJIG0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Aug 2022 04:06:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D506160509
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 01:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93247B81AFB
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 08:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A27C433D6
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 08:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660118783;
        bh=WNftXve3XEoisZk1tqJM0S79/VzRLwazDxT8PzOrh5E=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hFIaD6L4/diFarnJ6uIg0Z1Mq99sYI8BV+EDICC8uFP6+W+5aUMIKTph6teEtHO67
         lWLqBE0ABh9/zHia2oAMn1zak2xZgTsD6TCdd718yoQaniqT4KqPr6RrB3k+BYfsWK
         Seyg1WFR+UoCSLF+upiQpyh8rXeMLLTZ95OwV/JQTwyq9MbIbVaPKgv9xwOBBItLyd
         ZUWqncID8+C07tFAxqV1rMubyS5XlOQ0qqJXjfsjSoGH0AcI6urfo/jv0RIH5pPoYp
         opiPaWdkh98KZ/rr0rjLmvse37liSvrAPWfLQZ/83vN7O8FAr8/MFqoWk5UvITvWRy
         +YH8vI7vhA4mg==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-10e615a36b0so16975483fac.1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Aug 2022 01:06:23 -0700 (PDT)
X-Gm-Message-State: ACgBeo2PvCgCaa2E6RI+UQiZjP+l9cs8vDsNv2fxrbD/sBqBFvUozlTZ
        YmEV1Wh3mYBR4ySBYfXZ35GN9Hj3KN1cC4NJxFg=
X-Google-Smtp-Source: AA6agR6BbDJgf9SlbPew/q6Jk7olaaJMboCOkNYJlNFtqfFzh2KVnlKWyH2FGaDWnCXv/AUfPEYvRXECAGnzmGbKLiY=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr994803oab.257.1660118782417; Wed, 10
 Aug 2022 01:06:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Wed, 10 Aug 2022 01:06:22
 -0700 (PDT)
In-Reply-To: <20220808220216.17235-3-atteh.mailbox@gmail.com>
References: <20220808220216.17235-1-atteh.mailbox@gmail.com> <20220808220216.17235-3-atteh.mailbox@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 10 Aug 2022 17:06:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_TiZX31eerm4kYHU62X4tDmZN_TwSsR7=7H+JQ9Mk3ZA@mail.gmail.com>
Message-ID: <CAKYAXd_TiZX31eerm4kYHU62X4tDmZN_TwSsR7=7H+JQ9Mk3ZA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ksmbd-tools: inform ksmbd of stale share config
To:     atheik <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-09 7:02 GMT+09:00, atheik <atteh.mailbox@gmail.com>:
> When initializing a share from a group, flag the share with
> KSMBD_SHARE_FLAG_UPDATE if the group callback mode denotes that the
> config file was reloaded. If the share was flagged, then later when
> handling a tree connect request, flag the connection with
> KSMBD_TREE_CONN_FLAG_UPDATE to inform ksmbd that its cached share
> config is stale. If there are no failures when handling the request,
> remove the share flag.
>
> Signed-off-by: Atte Heikkil=C3=A4 <atteh.mailbox@gmail.com>
Applied 2/3, 3/3 patches.

Thanks!
