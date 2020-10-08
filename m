Return-Path: <SRS0=9bed=DP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60BBC433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Oct 2020 20:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3908621D43
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Oct 2020 20:36:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1Qtjqhp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgJHUgp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJHUgp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Oct 2020 16:36:45 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64258C0613D2
        for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2020 13:36:45 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id d24so4228113ljg.10
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2020 13:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ECsXNM/sNVbauS2/45aLO/xXagdFy92hVzxoISnmMHI=;
        b=N1Qtjqhp7EtRNbK2Kjrmuc87pXUXu9nRUMFPC2Ct4o19ZI6gFQhuC1eqEU2/PlVdNt
         0vfsTc5LKhQqwl4WLI6bZiNYzvF3eJqqEPW1X3T4it4/CikctIA82UTyhsKAj9RyVO1Y
         2Z7EmS0GRwT9EBUsFVCf1VXdelddK5pFDsp4RRbx5g4kMLMfkcEfC9IHhAjfBKJWoORI
         aGpL70N9n//WKZh/tByb9nzdMzKzXXUd3YiTiHgzgJwE3B/PYrJw7PD0poaSmDuOjYJB
         xPubk48tptvUHarzOE3OOEvZ/ExMyYEKqja2XbqEA9Por2BlnkuM+HyspD87bdd9Ov6m
         pKLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ECsXNM/sNVbauS2/45aLO/xXagdFy92hVzxoISnmMHI=;
        b=DTvt2hx1B1pYfxhZgPkWH8v3N0hveK1hcHWV4lvdwpOonqI9VXt2hGy8RGNHYFLDLp
         JAxDtuUGRYBYk5zgP1/k4g0nzGM7rSpORMt5kaln9FTBnUQSRTv9jSSDa3nismJ9hwj9
         51zIwIxlwOIvUXDgIGPEI+spQgnbiSB72D+ousqhbUNsHLv0Kd472utqeelguNoH0WEA
         bEYOC+I1Xx4zbStZ5Yk+ZaJyIN1eha8XNxm56IJeWLkM0hAGYtpFNpV2JKroEKqtcmeM
         nEirr8o4IC9MiQIro5GlXsE+8FV6sAMiG+vhL4yE9AFMk77MtIcDvchy1jujaoM3L2uU
         fMyQ==
X-Gm-Message-State: AOAM531llA/j8xGc+gXOZjdJxTL0i4v1wqPjEaLlWJjDmLYIYuWNvBiy
        w7ODrCrA3VT1OTCLOGCs1PMGG4mS1wn2uEAhJkc=
X-Google-Smtp-Source: ABdhPJwy0qFcOjWTxlyYgTsDAUv7+tkIZvwwLv42nLG+bIVoZBVW8t8CmD6SG1i/z3bECpDJ59/ax5Tz8Wxb9p8teN8=
X-Received: by 2002:a2e:82cf:: with SMTP id n15mr3674874ljh.394.1602189403779;
 Thu, 08 Oct 2020 13:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
In-Reply-To: <CACdtm0YWG1Ni5JnOpnH4OVnF7RpiE_E_WXYrTBEP=K+SL=Yuog@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Oct 2020 15:36:33 -0500
Message-ID: <CAH2r5msodNEQPFO7fwY1wpy=qUNPTH+8iPDxZSvMrjg+SkJHEg@mail.gmail.com>
Subject: Re: [PATCH] Resolve data corruption of TCP server info fields
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, sribhat.msa@outlook.com,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed up 2 small checkpatch warnings and merged into cifs-2.6.git for-next

On Thu, Oct 8, 2020 at 9:40 AM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi All,
>
> With the "esize" mount option, I observed data corruption and cifs
> reconnects during performance tests.
>
> TCP server info field server->total_read is modified parallely by
> demultiplex thread and decrypt offload worker thread. server->total_read
> is used in calculation to discard the remaining data of PDU which is
> not read into memory.
>
> Because of parallel modification, =E2=80=9Cserver->total_read=E2=80=9D va=
lue got
> corrupted and instead of discarding the remaining data, it discarded
> some valid data from the next PDU.
>
> server->total_read field is already updated properly during read from
> socket. So, no need to update the same field again after decryption.
>
> Regards,
> Rohith



--=20
Thanks,

Steve
