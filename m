Return-Path: <SRS0=3XS+=6H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E011AC55185
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Apr 2020 01:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC3E2074F
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Apr 2020 01:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rr+E4ojc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbgDWBbe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBbd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Apr 2020 21:31:33 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737CAC03C1AA;
        Wed, 22 Apr 2020 18:31:33 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id a9so2266179ybc.8;
        Wed, 22 Apr 2020 18:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qTERN+i0HIChPpFfmgcmeaOzlSbySSWPcFYAbeYUgFo=;
        b=rr+E4ojcCqOtxYzaHP++U+89MxK5MiZjXlb5Qb9nqsg9otkLEszW9zKDREFSW6adY4
         ihYDJRt2EpNRNRrZxo1hzL9zLecZqgElRxoLRO2UQLyv0t/EJh4fKPNyk+Mc9NwRZZF2
         oKYvcS3Tb4V3ElMicauImL9A4P7MqJe0mu36ZXTEjhL7HLxrESS6M9pUQ/HO8TU23+Df
         NHVni4I8FA9QqHq4jZzOyUsgghQlxerauUtojYGDYnJUISHQCgIdLo5LfcbUfBcTMMMV
         cFJ4B/tO2d+r+idJyo3OVLe9I1A8d4MWzi9JgVgp8Odp8VKr8Odyj2OoCQnk7D1W6/W9
         Os0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qTERN+i0HIChPpFfmgcmeaOzlSbySSWPcFYAbeYUgFo=;
        b=gqxwpjduUFDffkMYeCO//+iTXN4zj11K1bHD1CaXmnPpQom5+dnuxma3Uudv56Pn0b
         jHH39E/HlnWyWB29w9A8phqfYiZ/AwzB17AvYZWbzBRrtZGgyomEa9BKKFpj2HopBqoH
         wR9wgve3ZOnyrAGtO3R46sMLLAwQFoENSMSp+oHajGZ+IJdT3zfHytDkWHc241IMEuro
         Pg2ZKGCiCV7Xa7R9Gpk8wk3NI2rYD1xE2bHSSCrh1c+DI4qFPCKXTU55OCShJuo//ouA
         jTV0kbLZU/DJ+FMB33pVPhSZVIpPGqD2F2TNH2Hemv7vgGXYApgqXxnlgUsQVCgQOQl5
         QzUA==
X-Gm-Message-State: AGi0PuYyVioKZORU8QWl0vftBFx5J0TeWvSy5ij+3+SAHGmCfyujzcQ7
        jrUyDdy9rOotDQDkTS25UUEso8E1vwew7cYBJis=
X-Google-Smtp-Source: APiQypKJMu3AyBtHt03zMEEtlNqfRN+lKkkWcS4V5OtidAVtmrzo7IAb6GE/EErIjP0YvJxe7VTaI7uyfOjCnDHmn+w=
X-Received: by 2002:a25:e907:: with SMTP id n7mr2857011ybd.85.1587605492519;
 Wed, 22 Apr 2020 18:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200423103101.0d416eb8@canb.auug.org.au>
In-Reply-To: <20200423103101.0d416eb8@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 22 Apr 2020 20:31:21 -0500
Message-ID: <CAH2r5mvUwDAfW0Eh1cLvSxukBkySYrW7Bf-f35bMdzHu81EG9A@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed.  updated cifs-2.6.git for-next with Paulo's respun version of
two patches to address the missing #ifdef

Should be ok now.

On Wed, Apr 22, 2020 at 7:31 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/connect.c: In function 'cifs_find_tcon':
> fs/cifs/connect.c:3378:45: error: 'struct cifs_tcon' has no member named 'dfs_path'
>  3378 |   if (!match_tcon(tcon, volume_info) || tcon->dfs_path)
>       |                                             ^~
>
> Caused by commit
>
>   f73409e5babd ("cifs: do not share tcons with DFS")
>
> # CONFIG_CIFS_DFS_UPCALL is not set
>
> I have reverted that commit for today.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
