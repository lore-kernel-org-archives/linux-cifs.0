Return-Path: <SRS0=w1sk=7L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1D8C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 20:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E59412075A
	for <linux-cifs@archiver.kernel.org>; Fri, 29 May 2020 20:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJEw28Ld"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgE2Ulc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 May 2020 16:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgE2Ulc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 May 2020 16:41:32 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85BAC03E969
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2020 13:41:31 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id j8so1760744ybj.12
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2020 13:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zaNIRcKoHF/ewb38bzfAIG4Oft+WdTJOuRkmpdiOwVg=;
        b=nJEw28LdziUhWnzvLqt0BKP53IysKBrbO1EJcFe9I27vwjrmjuIOCga4BS8RoEfRD3
         27SCCwU69ss9flVggtwhQV8wAKYE6X6u7qj/nrWJVQv4MOc5uvFNkZxDbmXPGh+aVoTi
         NePv6VVEp+fHihrQvBuiffxDMibmHbKWnH1kZsRULKWTbT3jG3Da77Qdm7kbYX1ZGr5g
         4zZE4iFei/9CwO9YsDp7IwqoBzbCwzeGTuXbwW+K8vrM0sBXSwKqIQlP0LpkxrRMlpPF
         hijoQLTAvLpjO+VGpuxiazRaEhNe/7iJCysEwlZRMeMg9xBhEsp2H2RwMNZrMlFcAGkH
         cA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zaNIRcKoHF/ewb38bzfAIG4Oft+WdTJOuRkmpdiOwVg=;
        b=ZNPBYGdXEHzeX4ws1q9PAG2rjyw8xAYxZnkvP+ZGT6b8YibrVtxFBVtGOMZ+NgbRa3
         jSJvITmtM0TafKYR/lcjx403hEv6bag8BTZzrTUFI1s2D0TtH3YNfiiWTVI1lb4Fiah4
         y4AoUmVrfAVQzRraEi/3Im1ysJrdJfDkRv4bnEpkdhAuz53L8IzTTDtYtJDKHvcReWCq
         yCKlWAx0fSKZZ10I9+Lqf3eUyZwrKZqxJ4zgKVFqtM3FM4614IxN//7oAcjiV5DQdvdL
         CaE8AgCBgdURxtEB96+lvJuy9UIwK6PBEJZJNBHDiFTqNNa3Xdvh/FJ4APy3bBxcD9/+
         +6vQ==
X-Gm-Message-State: AOAM531z1Xpl1YIfYZXY3VVc+zI6119+96LYJlNp50Y+nLyYE63kYJpV
        urt99bRcHk2HLAm4L55PkIgmdiwAK33UU3IP/QA=
X-Google-Smtp-Source: ABdhPJwkbMe4WxT4AmZKqAJ2qBs1OnMwHuFQ+niOA1eBtTmgHO0MAUeH8SIfyhNDo8geaFlo7tbD7XIDMYkOi3DrQDA=
X-Received: by 2002:a25:4487:: with SMTP id r129mr2782394yba.14.1590784891007;
 Fri, 29 May 2020 13:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200519183829.5512-1-pc@cjr.nz> <20200519183829.5512-2-pc@cjr.nz>
 <87r1v4jcwb.fsf@suse.com>
In-Reply-To: <87r1v4jcwb.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 29 May 2020 15:41:19 -0500
Message-ID: <CAH2r5mutMnvBSvuwuMM1MW2jB1waZ8vmOSSHnn3wg3oYshdnfA@mail.gmail.com>
Subject: Re: [PATCH 2/3] cifs: handle hostnames that resolve to same ip in failover
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged all 3 into cifs-2.6.git for-next

thx

On Thu, May 28, 2020 at 10:29 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
