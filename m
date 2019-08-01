Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C02C19759
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 17:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28E852087E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 17:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sGWP0fEr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbfHARAu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 13:00:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45886 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731376AbfHARAu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Aug 2019 13:00:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id r1so34407518pfq.12;
        Thu, 01 Aug 2019 10:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WGPyF/jz2yKuYFU7gzQ1L/LMsgV9YTZ2vw6QCV6Vnss=;
        b=sGWP0fErmKQgCjE58NXoxmrj6L7FQzRJa9+jCi2n/GxkHB/xpz3L93gva3RvfziNta
         BPAXRRhRYolWQODuGp6caxy9kqfFS2cRDZlBzVt0w66rKNTU88AUyNASwK103/FeLuGy
         IvyXPKwbB1SG2ZNkOfIbWBX7EP7B3DOeOZM4NxF6fnJXYBG1ccKIi+YlF86t18TJ3qrG
         h6huSgunJmOEpK32CV3ruEsJxK+WC9+l9d0HO6Skl5UtdhTHXTya9OWN3RNsJ4yWZK34
         rP+oWK9LVjAGws1nttGsu+bBMdkccSBGABlbwzpOZaEfTMXQw52/eKVtWfbnz72QJMhv
         JS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WGPyF/jz2yKuYFU7gzQ1L/LMsgV9YTZ2vw6QCV6Vnss=;
        b=Mh5o1Lemtw501Ia22oCL2zN/olVuCVbOLHmRE65HOKrdwVaHKZ2Jn8OcecoOIihV2F
         AD7ASHToKKI8uuNQ74KzP+Xg8u0XHLx+HJ8HYt52pNEnFYnDD5kkKZT1F9aS1cmjEnGa
         o1RgL/ukX29fz2+PyNNpez3+KCjMe9pzygXMRK3ahEtblDutewFV3df5EiyOaHfq8jCN
         xd4EzD0n2t3ZfB4QC6AjCqlc0av+jYgvzZOLrHUoaJzEf8qKMqpfaGtml5DaCxxX3LQx
         KZI32Ya2B2Z4I1N0ul9GdpHLYm5SaJem+tM4VQM4oBdb5eC0uRMlwKWH2w1svfJ/lxwJ
         HxVw==
X-Gm-Message-State: APjAAAXPYmHVlztksE8jzFYsbOOyFBqGLB3GIjDp+Y1ScODZfTRRPy0k
        lQ4n1xMWpJ4Fjo0x/6LlGNd2G63VAB0lR+f6qx4=
X-Google-Smtp-Source: APXvYqxlnoZ7H66e1GLk8MqU9jRtl8FsWM4cquNdSP23TFAWWxy+fPwsayD6YLTVS7VXcsI01KJ2dq1MjFDDLk6SktI=
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr9971211pjb.30.1564678849452;
 Thu, 01 Aug 2019 10:00:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190731090526.27245-1-colin.king@canonical.com>
 <87r266seg4.fsf@suse.com> <20190731122841.GA1974@kadam> <87lfwerze8.fsf@suse.com>
 <2f562159-8118-f4a5-9e00-c82cf0841fd5@canonical.com>
In-Reply-To: <2f562159-8118-f4a5-9e00-c82cf0841fd5@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Aug 2019 12:00:37 -0500
Message-ID: <CAH2r5msukKuhEcbpBfXOrwFEA=fyXQKSL+hDwdOFYX7DNLe8TQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove redundant assignment to variable rc
To:     Colin Ian King <colin.king@canonical.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <sfrench@samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Jul 31, 2019 at 10:54 AM Colin Ian King
<colin.king@canonical.com> wrote:
>
> On 31/07/2019 16:34, Aur=C3=A9lien Aptel wrote:
> > "Dan Carpenter" <dan.carpenter@oracle.com> writes:
> >> You're just turning off GCC's static analysis (and introducing false
> >> positives) when you do that.  We have seen bugs caused by this and nev=
er
> >> seen any bugs prevented by this style.
> >
> > You've never seen bugs prevented by initializing uninitialized
> > variables? Code can change overtime and I don't think coverity is
> > checked as often as it could be, meaning the var could end up being use=
d
> > while uninitialized in the future.
>
> gcc/clang should pick up uninitialized vars at compile time. also I run
> coverity daily on linux-next.
>
> Colin
>
> >
> > Anyway I won't die on this hill, merge this if you prefer.
> >
> > Cheers,
> >
>


--=20
Thanks,

Steve
