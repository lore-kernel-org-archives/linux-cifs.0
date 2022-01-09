Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9E9C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jan 2022 02:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiAICnN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Jan 2022 21:43:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54420 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiAICnN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Jan 2022 21:43:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7E2760E75
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 02:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19404C36AE5
        for <linux-cifs@vger.kernel.org>; Sun,  9 Jan 2022 02:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641696192;
        bh=R3vxqOw7Ea3JbUZ8LP/+NTlKYhfcQcQ/jRLfwNZh1t8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DlhIAW2CU2YpnGPnwlzfpMjDqcgmrh0MTvHVZRxQ4EH87eshSMv3vUBQfi3vCPZFF
         qkCIHEHIKNQW0GX1sbq/Cou7qihgAGGOOA8PfVt3lLkrylew4SzuBiXKM/7aljG85o
         SQYcl1G3QL1qhfX1fGcYZmH654nC5/QbUDsvpDzQZcN/iP0mv1oLYP/dhP7KxTZZnN
         EU+SOwXk4sI2lMX40h67Q6B1/nJ09fu9dgfTFBozEvVe+gcsOnNXRt5OZX5xJvYxlU
         f74lFjMajMGNtzt+p/zneGC02tISuRJ0cXOUf6qHdE60hq4FiKEzXVRtNK5hBLIcoc
         umjFrnF24hzaw==
Received: by mail-yb1-f172.google.com with SMTP id p5so21221775ybd.13
        for <linux-cifs@vger.kernel.org>; Sat, 08 Jan 2022 18:43:12 -0800 (PST)
X-Gm-Message-State: AOAM531FfTeRhtfwBxLO9OyRyYINiQ577V6nfpdyfABOP6S2aMVOsX71
        ZWMndGaK/rvtLPdR65b8lPM9qlyFFvBMgB7LbSY=
X-Google-Smtp-Source: ABdhPJwtwva+wCsQmZONxxCeB4vlvoDSgSfqxV9xXaNOBE5O1RQRX5Rf9Q/gOW1n6+A31nxYppvy4ikF+PdaByQmWPY=
X-Received: by 2002:a25:a321:: with SMTP id d30mr48898463ybi.373.1641696191220;
 Sat, 08 Jan 2022 18:43:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:5011:b0:123:6c39:8652 with HTTP; Sat, 8 Jan 2022
 18:43:10 -0800 (PST)
In-Reply-To: <20220107054531.619487-2-hyc.lee@gmail.com>
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 9 Jan 2022 11:43:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
Message-ID: <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> Due to restriction that cannot handle multiple
> buffer descriptor structures, decrease the maximum
> read/write size for Windows clients.
>
> And set the maximum fragmented receive size
> in consideration of the receive queue size.
>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
