Return-Path: <SRS0=9Mpj=CS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4785BC10DAA
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Sep 2020 11:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA66421D7B
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Sep 2020 11:04:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qagrnJLS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIILEh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Sep 2020 07:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgIILEf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Sep 2020 07:04:35 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC97C061573
        for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2020 04:04:35 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id p6so1484880ybk.10
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2020 04:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cQTw9g13ZYnhlzkxBfbUx37jWAKBnjJMrA6Ks1b8Ks8=;
        b=qagrnJLSfTf/8PpVAANah4qIYkX1CQBks0+j3zR9MhDrFuLb+E+yaOS6GIN76Dho4t
         YTfTfHH2y+WNUH0sBQD3Vfpyo/cjCfyjiaGDbpsvYwts4A2CcCvVwWjI+arxFahRUFp2
         2V3NdSXNwWEk4tVLFXFh4LH3129uhD+rPuruxhHRB2EpWSAymb7qFoZTGnIIXsoQDAHx
         NuERFAknZ7Pr1aLq12r0wx1pjfL7MvbpB4k2FA9Hc1jjszdU1N6vD4woYR4GGDNgVZzp
         aW2S1Xu6ihYwTMBwt+ZP75zegmYJHramDG7iIc6ugz/CWO00/qz8yofFlzcLQFB09Mtu
         6RcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cQTw9g13ZYnhlzkxBfbUx37jWAKBnjJMrA6Ks1b8Ks8=;
        b=F/YpUvx1hOodtKwArkNbSl5VrqASdOo0MlMw4ZWwH3Emg18Iz8GiaC12y3Y6DiFYwY
         pm87F1iFZL4rydKvEytCNv5YMcEhC1PVqEgzSmE9pP8mo8ihDHEXPZ0gD2Vq15Y9hKXC
         9tQMHngRpjpabzWlsNgWBdYf8OWdDEJUj2r2lhz8yvoyXN48sCnMm7uvtoQQ/b5mtwMx
         ZfCBGAxxiHin94jFkF3vOeAXrn905KovjRyIq0MPSJpbniyFHZe7uPcRssfYAwH0bzx4
         MjXj2lEQW8mAnmGVWkcwjmW23+6keV9+tLNgseWPv26eZYjVyBxwAh6IeMbn0eqylSdy
         lz3A==
X-Gm-Message-State: AOAM530hTwSk6hy2MhPnVw70M403Wn8w51nel+3MghO2lZ3DYatjoK/i
        cP3/DaIIsGHW03ISq0DmD4c5u/T4JZVb3HPSXhM=
X-Google-Smtp-Source: ABdhPJyOBQsKtSkg3R7s3XBSzqEXwpu91xjJ7V9f7CfN3rMHxoiHN0ZqB6QflXiVlsizLHjvoEezgRbAz3XEY6RAWaw=
X-Received: by 2002:a25:750a:: with SMTP id q10mr4714594ybc.185.1599649474723;
 Wed, 09 Sep 2020 04:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com> <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com> <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
In-Reply-To: <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 9 Sep 2020 16:34:24 +0530
Message-ID: <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I did some code reading on samba-winbind (and sssd to some extent),
and here are a few things I noticed.
1. Both today have almost "no-op" handlers for open and close of PAM sessio=
ns.
2. However, the login and logoff do have some functionalities. PAM
setcred is done both on log-on and log-off, so that the cred cache is
deleted on the last logoff.
3. Login and logoff have ref counts associated with a user. But I do
notice that a kinit is done on every login (even if the user is
already logged on).

So it looks like (at least as of today) we don't break much by
authenticating with PAM. One additional change needed would be to
introduce umount.cifs, which deletes PAM credentials for the user.

Alternatively, another option is to not rely on winbind/sssd for
authentication (or maintaining krb5 tgt up-to-date), but instead let
cifs-utils deal with it separately. Today, cifs.upcall has a way to
kinit if the cred cache file is missing. But that needs the keytab
file to be populated with the key for the user in question. We could
also try a kinit based on password in mount.cifs (if the cred cache is
missing), and if that works, populate the keytab file with the key for
this user (for cifs.upcall to use later, when necessary).

Thoughts?

Regards,
Shyam

On Mon, Aug 17, 2020 at 2:42 PM Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
>
> Thanks Aur=C3=A9lien. Good points.
> Let me take a closer look at this and see how to proceed.
>
> Regards,
> Shyam
>
> On Mon, Aug 17, 2020, 14:18 Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>>
>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>> > Agreed. But since we're not dealing with krb5cc file directly in
>> > mount.cifs, I don't see it influencing this change. However, I will te=
st it
>> > out too.
>>
>> When reconnecting or accessing DFS links (cross-server symlinks) the
>> client opens a new connection to the target server and has to auth
>> again. Since there are no ways to ask for a password at that moment
>> (we're in the middle of some syscall) cifs.ko does an upcall to
>> cifs.upcall and passes the pid of the process who initiated the
>> syscall. cifs.upcall then reads that proc env (via /proc/<pid>/environ)
>> and looks for KRB5CCNAME, uses it and returns the required data for
>> cifs.ko to proceed with the SMB Session Setup.
>>
>> So it is important to have this env var set if the location of the
>> credential cache is not the default one. If you do PAM login from
>> mount.cifs, the env var might be set for that process but it will only
>> persist in children processes of mount.cifs i.e. most likely none.
>>
>> I still think this patch is a good idea but we should definitely print
>> something to the user that things might fail later on, or give
>> instructions to set the env var in the user shell or something like that=
.
>>
>> > That does make sense. I was thinking of including a mount option to en=
able
>> > this path. But let me explore the retry-on-failure path as well.
>>
>> Mount option sounds good regardless.
>>
>> > Yeah. I didn't get the complete picture on session maintenance after
>> > reading the pam application developer's guide.
>> > Was hoping that somebody on samba-technical would have some idea about=
 this.
>>
>> The keyring docs have some info on it too but it's still not clear to
>> me.
>>
>> https://man7.org/linux/man-pages/man7/session-keyring.7.html
>>
>> Cheers,
>> --
>> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg=
, DE
>> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
-Shyam
