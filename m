Return-Path: <SRS0=RSIS=73=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6697AC433DF
	for <linux-cifs@archiver.kernel.org>; Sun, 14 Jun 2020 09:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DCEC20747
	for <linux-cifs@archiver.kernel.org>; Sun, 14 Jun 2020 09:09:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfgJjze+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgFNJJX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 14 Jun 2020 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725265AbgFNJJX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 14 Jun 2020 05:09:23 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09484C03E969
        for <linux-cifs@vger.kernel.org>; Sun, 14 Jun 2020 02:09:23 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id o4so7378529ybp.0
        for <linux-cifs@vger.kernel.org>; Sun, 14 Jun 2020 02:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ft4vK77oea9XtB00hFNRt+jixbZn3gNvcTLAGVzHeQ8=;
        b=JfgJjze+y+RwtPGSO8gU8+xACH3z2iF4MUCTVpDL1O2xLE8ophpQ4acrWKRB11+Qyu
         dmw8fvFlGjpKuPA2ef0zoZQRebxjBajeFax0F4w9bJ6iREUzBIwWem1JvPHUDitibye3
         BODWe2Ft9rOz0dILC0dJvEOAbYz5UOt9JliQgt2l8sXMMBBZ6p95mh/IYkOIg2zoqxis
         1uF+vOSvSWb0nVvHrVkYxGqDjqvQUJeotKAMWrKbjBbD/ZQCXT9Uw3pTADrqAru5aS0B
         z0XKTAL+LRjWaf4rg9SBJcrK6eQOrnE9Yrcl/qM4wTua/7+g5czudGCyVIcXoUathTFf
         2Bbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ft4vK77oea9XtB00hFNRt+jixbZn3gNvcTLAGVzHeQ8=;
        b=mRZ/I52+4ovTSalyoEhKCFIgN5dDAAPPDcXPgJ/JislF8EUKXnLmHK2SdA+LYCQGw8
         izelLOlewujNZNaV9bhHz523RizvZY0XlMRfbsZotIvsss3kSqYUOGISAhFEhVcqFK/p
         v/Eo5Yj4U0iw3uweDsYatND0WPI9qOfhYD7bTag3ZDwFr9f8L7W81SwWyhmRjYjnT1EO
         NWcIxPb0diXUw0GAHG33+8iVKgtFzTVIh2x9Tp1ipmY558n9VhF6rI+bvbPHIfrd5RAQ
         /6CYgtE6qcPlDvh+uW0QHuVazAjtiG8dxi1P9tOBBLnHapGonq922UZSq0JnUM6cAUHA
         cB7A==
X-Gm-Message-State: AOAM532PsH9v8Wsp/BC0ctH9dvMo/sjxdljpJYFGav0yPuClEsffEBeA
        eZdqhzEcg1E/4bx74s6GY3dLSh8miR5kH9J/H+1VjdmNWe8=
X-Google-Smtp-Source: ABdhPJxoAA2NWDGY6W5uFYCOUe1ed7kTpTkEIByiB87uA5uuNqW/CFAJ1GDOo0x9Oq+gCoqtgieiuwz+rmL47N+LhCQ=
X-Received: by 2002:a5b:785:: with SMTP id b5mr35071422ybq.96.1592125761845;
 Sun, 14 Jun 2020 02:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <ab981c0afaa83091923e94df23e91037@pantel.eu>
In-Reply-To: <ab981c0afaa83091923e94df23e91037@pantel.eu>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 14 Jun 2020 14:39:10 +0530
Message-ID: <CANT5p=pJ+T0RnJ8_3=M8KFa17Q0LTKmwj3bTXE0EkjudpJ==zQ@mail.gmail.com>
Subject: Re: get_existing_cc returns the wrong krb-cache under ubuntu 20.04
To:     Marco Pantel <marco@pantel.eu>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Marco,

I don't think that the env variable set by you is able to reach the
cifs.upcall code, purely based on the way the upcall gets triggered.
The request-key calls cifs.upcall as UID 0 and then changes to the
appropriate uid. And the env variable is read before switching to the
user (maybe a fix is needed here?).

You could try setting the default_ccache_name parameter in krb5.conf
to /tmp/krb5cc_%{uid}_abcdef
https://web.mit.edu/kerberos/krb5-1.12/doc/admin/conf_files/krb5_conf.html#=
libdefaults

Regards,
Shyam


On Sat, Jun 13, 2020 at 8:54 PM Marco Pantel <marco@pantel.eu> wrote:
>
> Hello!
>
> I try to automount a cifs folder on an ubuntu 20.04 client from my nas (Q=
NAP running Samba 4.7.12) using the respective user's kerberos ticket. I hu=
nted the problem down to the method "get_existing_cc" in cifs.upcall which =
returns the path "/tmp/krb5cc_{uid}" although that filed is named "/tmp/krb=
5cc_{uid}_abcdef". Env variables $KRB5CCNAME and /proc/{pid}/environ hold t=
hat latter name, by the way, so I don't know why "get_existing_cc" comes up=
 with the wrong
> cache filename.
>
> > Jun 13 17:04:11 desktop-linux kernel: CIFS: Attempting to mount //nas/h=
omes/DOMAIN=3DHOME/Administrator
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: key description:
> > cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dnas;
> > ip4=3D172.16.20.20;sec=3Dkrb5;uid=3D0x2715;creduid=3D0x2715;user=3Dadmi=
nistrator;pid=3D0x16ce
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: ver=3D2
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: host=3Dnas
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: ip=3D172.16.20.20
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: sec=3D1
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: uid=3D10005
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: creduid=3D10005
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: user=3Dadministrator
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: pid=3D5838
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: get_cachename_from_pro=
cess_env: pathname=3D/proc/5838/environ
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: get_existing_cc: defau=
lt ccache is FILE:/tmp/krb5cc_10005
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: get_tgt_time: unable t=
o get principal
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: krb5_get_init_creds_ke=
ytab: -1765328174
> > Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: Exit status 1
> > Jun 13 17:04:11 desktop-linux mount[5838]: mount error(2): No such file=
 or directory
> > Jun 13 17:04:11 desktop-linux mount[5838]: Refer to the mount.cifs(8) m=
anual page (e.g. man mount.cifs) and kernel log messages (dmesg)
> > Jun 13 17:04:11 desktop-linux kernel: CIFS VFS: \\nas Send error in Ses=
sSetup =3D -126
> > Jun 13 17:04:11 desktop-linux kernel: CIFS VFS: cifs_mount failed w/ret=
urn code =3D -2
> > Jun 13 17:04:11 desktop-linux systemd[1]: home-administrator-Ablage.mou=
nt: Mount process exited, code=3Dexited, status=3D32/n/a
>
> With a symlink named "/tmp/krb5cc_{uid}" to the correct cache file the au=
tomount works flawlessly, but that extra six characters being a security fe=
ature (from what I read about it) I would not necessarily want to work arou=
nd it.
> Besides that, I have seen the method returning the correct name during so=
me of my tests, but I'm not able to reconstruct the fstab entry that I used=
. But every time I put the "noauto" in /etc/fstab, it only returns the shor=
tened cache file name, which of course does not exist.
>
> Is there any advice on how I can fix this problem or is this a bug in cif=
s.upcall?
>
>
> Best regards
> Marco



--=20
-Shyam
