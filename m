Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9709C432BE
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 18:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4A3160F45
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 18:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhHZSft (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Aug 2021 14:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhHZSfp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Aug 2021 14:35:45 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E2AC061757
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 11:34:57 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id n27so8367333eja.5
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 11:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZe4ci2KGawwktu2Rt9NTDgb2P5UFORo8JetiL6o3P0=;
        b=q5MrMg1ecx5oKVfOEzJkM31kLjSqKn0Gzr6AJdXGxzx/yt/BpI5ksyZheuPpahHFVw
         2ouiZENI4B+GgNVU7dyuzCSaoCONhk64do0+Va9DggeBlin9/lxrgHOqVoYSjm+GjT6h
         +7sc+iD9RbjT8FA9t7Z+whyj4T7zFa+H8bgNRx79+M5l2ioNOu068Lwib9OSL1HV1ch5
         vXqWBtpy5eZ6Jkug6ny1U1OHvzeIP1imHUXNyDlY4eEGvA/04zTW0Vh0pGXwok9BNXlV
         ZaZae50keri1goncdpjTTuvhyCmUYMPs2g1rB9g7ffIspeeyMnbXrSmC13/ph6gxLCeq
         jR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZe4ci2KGawwktu2Rt9NTDgb2P5UFORo8JetiL6o3P0=;
        b=k0D4jk6TrIPOX7MT7WN/NWJTQc1U7ReCTXeYRwfxD7qxTMp8CrvZp9ADD2+SpquvyS
         4SpNVJcO9a3eI1S/YvNWhczygQ49rKuMBaOwXP6t2ofvRLEQDyaL5A1n4dARo0hnx0zG
         x7MwX3v1/zf6ZtzNQ0t4KB9I5z8shTBzdUqFLB8W13PSgoXKFaZTkuNq8d8SIv8G9O8+
         UmZyIW+mb+P3ypIAsVafDi66g88Wqd4dlJJ7F4KIuN/ww9k4JBgazpih3AnxmyMFkblA
         1fi6YLPUxmuo4P4NGCONxx+EiANVCdIAEzyL3awaBkIDZ9B4GPh/pmCFwTREpGGnYFfj
         aEfA==
X-Gm-Message-State: AOAM533VXQyTBdXMgV6d8Exs48mR4Z4fJc6rAzHvb0jv9XbaH1AZqWFg
        JTmf3ujaWLVxZOxnQyXeoV1lU7GY2vxYHbihF5PnSjq0
X-Google-Smtp-Source: ABdhPJyu+hZzTBmP4/BRIFOlRT2GFT20Xl/dkZvPkY2GVMGN+hLSc6vg2G5k8yaE2fKVhRhj99m+M1hXFeCgTAOvnT4=
X-Received: by 2002:a17:906:d52:: with SMTP id r18mr5726895ejh.47.1630002896070;
 Thu, 26 Aug 2021 11:34:56 -0700 (PDT)
MIME-Version: 1.0
References: <bec6e1554ba990330cf812050f4b43feda92aeb9.camel@tjernlund.se>
In-Reply-To: <bec6e1554ba990330cf812050f4b43feda92aeb9.camel@tjernlund.se>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 27 Aug 2021 04:34:44 +1000
Message-ID: <CAN05THRp0AcQvgn2ro-0M12i90FMnQfBCo7AFbf1qQCF2dtUjQ@mail.gmail.com>
Subject: Re: CIFS version 1/2 negotiate ?
To:     Tjernlund <tjernlund@tjernlund.se>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 25, 2021 at 9:49 PM Tjernlund <tjernlund@tjernlund.se> wrote:
>
> We got an old netapp server which exposes CIFS vers=1 and when trying to mount shares
> from this netapp we get:
> CIFS: VFS: \\netapp2 Dialect not supported by server. Consider  specifying vers=1.0 or vers=2.0 on mount for accessing older servers
> CIFS: VFS: cifs_mount failed w/return code = -95
>
> If I specify vers=1 manually on the mount cmd it works.
> However, GUI file managers cannot handle this and less Linux savy users don't know how to
> use the mount cmd manually.
>
> I wonder if kernel could grow a SMB1 version negotiate so a standard CIFS mount can work?
> We are at kernel 5.13 and I can test/use a kernel patch.

I don't think we can do that in the client.  We are all trying to move
away from SMB1, and a lot of servers already today
have it either disabled by default or even removed from the compile.
So enabling automatic multi-protocol support for SMB1 is the wrong
direction for us.

For that reason I think there will also be pushback from GUI
filemanagers to add a "smb1 tickbox", but you can try.

Other solutions could be to locally hack and replace mount.cifs with a
patch to "detect if servername matches the old netapp and
automatically add a vers=1 to the mount argument string passed to the
kernel".
It would require you to build a patched version of cifs-utils and
distribute to all the client machines though, so ...


>
>  Jocke
>
>
