Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E234C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jan 2022 19:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbiATTSe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jan 2022 14:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiATTSe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Jan 2022 14:18:34 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9BAC061574
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 11:18:33 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id x7so25407664lfu.8
        for <linux-cifs@vger.kernel.org>; Thu, 20 Jan 2022 11:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aQwRQjE2Eoz59MxMVZ8JQyIp3GYdDA+jCE0Nw+uhzZU=;
        b=biJT/ZUA2Jt9Uk+s0hgAABhdebjjzM1L2VpTnHNlyqIsVUOxFE2UecVDnBhg0OgX6L
         sKqPedknuYzKksGN7FEu284o+ZUYKsTPDhf30mu2hGa6tVeqG0tuUlBWgfbo+o9ITBzP
         eZTsDBUTTelNJWyFITK7Kh46L3KCtpg5f2o2F4UwSwqoqkcUhVfohGET6FsUd5K4OdXX
         i0w7C1yn7J61uw43iok1ZcJ01oylRVtTDhY7uCc/fAbsQkD2ZwQOFSqmNXaUUZrgfn14
         r8tx84lUAVt217gXLuXJZVH4rs0+xNVJcVOZ9xHexvExUAJF1BbMu3Ia2igACyGRpdLz
         MC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aQwRQjE2Eoz59MxMVZ8JQyIp3GYdDA+jCE0Nw+uhzZU=;
        b=rN6L1tovvT42z5xYHsdG5T6k4OTqAjmcfphkq1xAI2yViGjFaErWlfi4NR6roqGScJ
         zAQeupgv4kV/T5EDPV3gGdEIFCM1/P2HLVyeal/Y/0AMTEBUBEu0f/R+X6yKhBpiPV2o
         bGeY+72dwYAzEaIWLR3S7TjcO9s2hCkscK9zg5RLO312jKZkEar9vCpRd9uU/GzMalhc
         LjxwBxjaiPGI0Nj6w9HGKRWK1dXv5GXLoQ1CBfOifxGSIp6LdQYeMiOYuI05uIKWQNPK
         ASipVt6xNPOSHup7/jCT4NmgjjSmqEESpCLqNXs4GbbQrG9r7nhLW0L2O+jDARWm7hbh
         uoYw==
X-Gm-Message-State: AOAM532qdZZXlOAdV/w7R4A8ZauaJ6FTk1qfqc6o/GfDx9bUTVxEEJv5
        TtbLH2CmoO77EYoY3HTEM4PxZSEK30iuSJG41lA=
X-Google-Smtp-Source: ABdhPJxQvy2AvHQ8yKzrluqhZFka7TLQs3x1g+rF3/3sUZMMNEvuGaNzvFByXan+ugU/6pbScFIdyvNPI3pfvYDYJps=
X-Received: by 2002:a2e:8658:: with SMTP id i24mr356923ljj.209.1642706311826;
 Thu, 20 Jan 2022 11:18:31 -0800 (PST)
MIME-Version: 1.0
References: <YeHUxJ9zTVNrKveF@himera.home> <20220117211305.ambdxok747u6kwlm@cyberdelia>
 <Yeb32NlvfHzi7TxD@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <Yeb32NlvfHzi7TxD@debian-BULLSEYE-live-builder-AMD64>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 20 Jan 2022 13:18:20 -0600
Message-ID: <CAH2r5msL=w_GhGF6suzGrz4LG6vQUfw4F=Ft1ZVjZzKLTq4PGQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] cifs: quirk for STATUS_OBJECT_NAME_INVALID
 returned for non-ASCII dfs refs
To:     Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

we can do a followon to this if you find any problems with it later in the =
week.

On Thu, Jan 20, 2022 at 1:16 PM Eugene Korenevsky
<ekorenevsky@astralinux.ru> wrote:
>
> On Mon, Jan 17, 2022 at 06:14:05PM -0300, Enzo Matsumiya wrote:
>
> > The patch fixes the initial issue (mount and listing files) as per
> > reported in the mentioned bugzilla, but it still fails to create files:
> >
> > % echo "test" | sudo tee myfile
> > tee: myfile: No such file or directory
> > test
>
>
> Sorry, cannot reproduce.
>
> ```
> # mount
> ...
> //192.168.57.14/=D0=B4=D1=84=D1=81 on /tmp/x type cifs (rw,relatime,vers=
=3Ddefault,cache=3Dstrict,username=3Duser,domain=3DWIN-TCIN4O86A6M,uid=3D0,=
noforceuid,gid=3D0,noforcegid,addr=3D192.168.57.14,file_mode=3D0755,dir_mod=
e=3D0755,soft,nounix,mapposix,rsize=3D4194304,wsize=3D4194304,bsize=3D10485=
76,echo_interval=3D60,actimeo=3D1)
> //WIN-TCIN4O86A6M/=D0=B4=D1=84=D1=81/temp on /tmp/x/temp type cifs (rw,re=
latime,vers=3D3.1.1,cache=3Dstrict,username=3Duser,domain=3DWIN-TCIN4O86A6M=
,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D192.168.57.4,file_mode=3D0755=
,dir_mode=3D0755,soft,nounix,mapposix,rsize=3D4194304,wsize=3D4194304,bsize=
=3D1048576,echo_interval=3D60,actimeo=3D1)
> # pwd
> /tmp/x/temp
> # echo test | tee myfile
> test
> # rm myfile
> # echo test | tee myfile
> test
> # cat myfile
> test
> # rm myfile && echo ok
> ok
> ```
>
> Could you provide your 'mount' output as well?
>
>
> --
> Eugene



--=20
Thanks,

Steve
