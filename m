Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025CCC282CE
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 17:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5E9D206C0
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 17:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HolLUotR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbfDERGP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 13:06:15 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:35022 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730492AbfDERGP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Apr 2019 13:06:15 -0400
Received: by mail-pl1-f170.google.com with SMTP id w24so3364868plp.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 Apr 2019 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XdSFLNfVCx2ESuMBQMKs/kaDYB5JB3XDvXjIG/8iy40=;
        b=HolLUotRrEaquIJdL9jtGohFTTLYaE5PnkdgAirB5GC39nhMcilw6jyM7PXtqwxeRa
         SbJYIaIUmC8/zb3oSssKrnk9IFu0F/89+KeCzTXNFA0kYenRd6ygFIdnLsFdpAL5ft4v
         ilUr0VQStCKCvfY7jPm0rDHBGD2evCFTzadDNdcP++7fTiRufTTMVUs8r17eoec+qjCL
         gbfAAcMt4ea1OEqlL7LkWJ7u3EAE776Iv/r6RuUQ2b2OT7ezIX9tqJk8dxWpuOxKgJWp
         bRF6bcVsvOP5Pv7YCHuxUBT6nGlVE7gXvq8JyCWbmAvMZNPesiZkGrNy+c0+d9o3EutU
         QeiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XdSFLNfVCx2ESuMBQMKs/kaDYB5JB3XDvXjIG/8iy40=;
        b=JrlZdoFjWD32mlTt6NwvgJU+7EBALYVXz8IIQa3RSZR1GBq3JRmrT7aSgcJ/YXo8Ke
         6ADBUP1eksj58fug0VjdkrlnHauJnHp/1RQQEnLgoALEtAo6debIYBmCN1HvrxIgn3AU
         4hU+7KYD/69cvmn1tzyoUQVS6taEvMFuL4bQamrUXAVEDSR181l3fJIdcMPtb71JgC9t
         vioW72eUukfDMPjVEzlhQX/lXT+ojsrUI4HqWZ3/Ch4W5TdVOuVp5629cZq1/XeYiTCv
         ZWI/3IkHymBYuF6xQr3Vftx/sWuwleIHyHQ8WTeBvD/aK8mTATcDNhxR2KeG5xsfA0hU
         4+5g==
X-Gm-Message-State: APjAAAUpqZt+EqN9THz7qtbszqCOzVNb3lGDJq/91jaglmtndFXWsHdL
        4dhT+AIktN8LmmzwEy+5Ru0NxplHZGEPVyuLrXrsnA==
X-Google-Smtp-Source: APXvYqxFMvfar7piAOOzkmW1Q6Cc7aS908TEhocfhyzzsIuL4c3bNSTbYSQm75U/ltMF5VmOVzxJxK1MJVKUnmytJC0=
X-Received: by 2002:a17:902:9006:: with SMTP id a6mr13690423plp.259.1554483974009;
 Fri, 05 Apr 2019 10:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mstkeagNZzxMZQdritnU53jsVOWW2kMN8bcfN2fL7CCOA@mail.gmail.com>
 <87sguwsse1.fsf@suse.com>
In-Reply-To: <87sguwsse1.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Apr 2019 12:06:02 -0500
Message-ID: <CAH2r5mv31SDxx-2shASYouH1XJdxBY_mVJp5t9_UpHX=uY3AYg@mail.gmail.com>
Subject: Re: Add smb3 mount helper
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - we could move common code to a common C file - would be fairly
easy to reduce most of the duplicated code (and can do the diff
between the two mount.cifs.c vs mount.smb3.c)  - goal is also to
behave differently for the two (we don't want to show/display/use
obsolete options in the mount.smb3.c flavor of the mount helper)

On Fri, Apr 5, 2019 at 4:39 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Steve French <smfrench@gmail.com> writes:
> >     We want to encourage use of more secure SMB3, and don't want
> >     people using cifs and this new helper makes it less confusing:
> >          "mount -t smb3"
> >     rather than
> >          "mount -t cifs"
> >     Users can still mount the old way, but if they use smb3 mount
> >     helper (mount.smb3 or "mount -t smb3") it will be less confusing
> >     and less likely to use older insecure dialects.
>
> I don't think duplicating the source is a good idea. Could we just make
> a symlink or hardlink at installation? Alternatively move the common
> code to a separate file.
>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 21284 (AG N=C3=
=BCrnberg)



--=20
Thanks,

Steve
