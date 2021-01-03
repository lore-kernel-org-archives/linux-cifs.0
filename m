Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F8EC433DB
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 00:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D508C207A5
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 00:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbhACAUd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbhACAUd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Jan 2021 19:20:33 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917E1C061573
        for <linux-cifs@vger.kernel.org>; Sat,  2 Jan 2021 16:19:52 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id x20so56272826lfe.12
        for <linux-cifs@vger.kernel.org>; Sat, 02 Jan 2021 16:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YCRYRrSFJ8U5gMuf3xqA6363ZBdzYrM6npGRKphRBoY=;
        b=hOhZTDKxz1aX2WvhVi3HQlRw0glv57E7L0yW5vCvhAxQ0URsfE9cM9plld/9hMtOgf
         wwuV8ptdgf84FdmS2Ag5NVC7Efl8m09b7j9FFy3tqroVV7oprlB2b44C1QFahFTVv9H7
         i+w9zmatKwMPZBjTfTBeP8HQV7VENQjOHU5HVms0bLJCGFHwzlabX38BVM1j3sZnqDqZ
         M9tE2tsP6tygBMVmJAE/I1j5DVUmyVMpAQ3erkq6E87TnkceYlWM9Ib6LDrk+ERj+uI8
         CQYUnT2VT+jaUoNL2EkjLNs2LR2TMyfi2H1ExG8mCfgiKO+pYB1NRGRp/iGkuJTi9Azk
         kkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YCRYRrSFJ8U5gMuf3xqA6363ZBdzYrM6npGRKphRBoY=;
        b=afYCTipP9Pb52lg+bDUwsEn7Z/KfBH+77rLbPBw5vu7XdahCkYrXIJdh9oaMo2wbB6
         4N4hilynj8UtmlD1LuU4MXCuOh9/prXaWU7Bm/SKd7fxoAT2w0xacsxwOO9KeRwla2CR
         aM9w3xmeO61H1yHQlzIK9G5HjiSl5JWfa5LScN2woBAeNbrGYINMczontThksYe0asgz
         srKV/9Oyfy0XIOh+eGhoxV2b5dBiwmpSPOD1JcYqoXUBhKMid0WoRqXc9nPOQtJszqpQ
         IRUW+AuUbHSUTMhtAf1FVVf3mcgMeBlX5i5U/Pcf7zoIXYkn4T32hU1rqZDarcZ9yLMU
         op+w==
X-Gm-Message-State: AOAM533CaLW+yyts5XDENxOhSArgsSu8AGnqr/LUw1SdATtoPiqj1FEY
        YU9h5b2yeSfjrXnIP3XLAzMM8IlARRMPEmGtxITfKI/h246BfA==
X-Google-Smtp-Source: ABdhPJzf9A8cqKe1GghbWqMlXWUmc98U3WM9a7OFA2xxDGYT3cUMoWmdYZRpxpngyHaJ+khfVV6BTseuYZNh8t+af1U=
X-Received: by 2002:ac2:5689:: with SMTP id 9mr30681415lfr.175.1609633190966;
 Sat, 02 Jan 2021 16:19:50 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer> <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
 <20210101195821.GA41555@jeremy-acer> <CAH2r5mvt_cHDbT0xaeLNQn=5cQ0T2-wPgpMkYEGQNdtDZ3kP=A@mail.gmail.com>
 <20210102025837.GA61433@jeremy-acer> <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
 <20210102052524.GA67422@jeremy-acer>
In-Reply-To: <20210102052524.GA67422@jeremy-acer>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 Jan 2021 18:19:39 -0600
Message-ID: <CAH2r5msZt0UZG5r5Z7=_jQf=-xgNz8zW7fZOnqncqeJHB=mOmA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file name
To:     Jeremy Allison <jra@samba.org>
Cc:     Xiaoli Feng <xifeng@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I agree with the idea of being safe (in the smbclient in this case),
and not returning potentially dangerous file names (even if a very
remote danger to the tool, smbclient in this case), but I am not
convinced that the "user friendly" behavior is to reject the names
with the rather confusing message - especially as it would mean that
inserting a single file with an odd name into a server could make the
whole share unusable for smbclient (e.g. in a backup scenario).  I
agree with rejecting (or perhaps better skipping) it, but ... not sure
any user would understand what SMBecho has to do with a server file
name.

"NT_STATUS_INVALID_NETWORK_RESPONSE listing \*
smb: \> SMBecho failed (NT_STATUS_CONNECTION_DISCONNECTED). The
connection is disconnected now"

On Fri, Jan 1, 2021 at 11:25 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Fri, Jan 01, 2021 at 09:49:06PM -0600, Steve French wrote:
> >I exported the /scratch directory with smb.conf configured as
> >
> >[scratch]
> >   comment = scratch share for testing
> >   browseable = yes
> >   path = /scratch
> >   guest ok = yes
> >   read only = no
> >   ea support = yes
> >   create mask = 0777
> >   directory mask = 0777
> >   vfs objects = acl_xattr
> >   map acl inherit = yes
> >   strict allocate = yes
> >   map acl inherit = yes
> >   mangled names = no
> >
> >Connecting with smbclient and doing a simple ls causes the disconnect:
> >$ smbclient --version
> >Version 4.12.5-Ubuntu
> >$ smbclient //localhost/scratch -U testuser
> >Enter SAMBA\testuser's password:
> >Try "help" to get a list of possible commands.
> >smb: \> ls
> >  .                                   D        0  Fri Jan  1 21:19:52 2021
> >  ..                                  D        0  Thu Dec 31 21:42:28 2020
> >  rsvd-chars                          D        0  Fri Jan  1 09:14:04 2021
> >  file-?-question                     N        0  Fri Jan  1 21:19:42 2021
> >is_bad_finfo_name: bad finfo->name
> >NT_STATUS_INVALID_NETWORK_RESPONSE listing \*
> >smb: \> SMBecho failed (NT_STATUS_CONNECTION_DISCONNECTED). The
> >connection is disconnected now
>
> Well of course it disconnects. You set
>
> "mangled names = no"
>
> So the server returns the bad name. The smbclient
> library notices the server is trying to screw with
> it by sending invalid Windows names and disconnects
> to protect itself.
>
> This is by design. There is a *REASON* mangled names = yes
> is the default. Otherwise you can't see valid server
> filenames that contain : \ etc. etc. from a Windows client.
>
> Even a file names AUX: has to be mangled. "mangled names = no"
> is only useful for a pre-cleaned exported file system which
> you can guarantee contains only Windows-compatible names.
>
> This is not a bug, it's working as designed to protect
> the client code.
>
> There was a CVE where libsmbclient might pass up
> names containing a '/' to the calling code (not
> that they can exist on disk, but a malicious server
> could send them) which might then treat it as a
> path separator.



-- 
Thanks,

Steve
