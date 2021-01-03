Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2B0C433DB
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 03:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74EDB20796
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Jan 2021 03:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbhACDqs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Jan 2021 22:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbhACDqr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Jan 2021 22:46:47 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BC8C061573
        for <linux-cifs@vger.kernel.org>; Sat,  2 Jan 2021 19:46:06 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id h205so56825149lfd.5
        for <linux-cifs@vger.kernel.org>; Sat, 02 Jan 2021 19:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7XkGEH+8RkBNYCEf7NdeeHpDAFBsEQHpOi3CzI4PHQ=;
        b=vG033Qu29kv1kBkK+tUfNkL4czdv2Os3fKc7Mjw9NheCBKakXKwB6GPC4RYKLg31/P
         AYbMAfO0Ww+mDkHEXOCq60LRx4oLelpoOKhroVOudV9ERGu2Yhue0iZ6L03c6a4paxDd
         5DFf/RhIcSzs9TyOiKZO6i3eJSYdNVcC3KRPKn+ZAMa8j/pqyaYSc6UNYEVRHoWr5Z1N
         s9n28BEHjesUbsz75z3qssaQhTE6OC0Yzf7PAep8ruq34DZkdGi2mD+VocCKbOuSCuou
         IIOy7f6rfzIldvZoZhIYt58IWC+vVYWuxuHFbi9lt9NHUtxiw9bSg6+d4K4TfKmShI5A
         k7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7XkGEH+8RkBNYCEf7NdeeHpDAFBsEQHpOi3CzI4PHQ=;
        b=e5FmTY/Fj9DzFBmVN/FdH+VlINBLeimWz+JijTns/XWlKPhnT4fAgS6dlx6gguIDW6
         o/u0n0qyMLTVnBFfw7PiMO0B/evFMt/Rr4xywP7bOOH16XL7E/aat+NAcMGChChQpsfQ
         o1LyTuBcM6/2sshcRcPtJgEMv/W+1QDQPjQET81GNxXqeYzhn1h3TKwaogr6incsq7dq
         Q5DkvtU4NOF6+RWM9VcXlV6y4BhbWGFC3H6+8pyhLrwYyq8JAV7jqDEwRFfHFrJ3h+0C
         MVd/nsBGotr0tdk0NkXnI/LE3pQkQ8rUjgbYA5AbQ6Lst6LsPLpDFCb2E9vqgvwpLd0p
         xUHQ==
X-Gm-Message-State: AOAM53397B7j3V+55crZLLI5OLH6dQW0JNyu5vKsZYfcOuyAuVC2wMb5
        vySBiw7CPeah64h8wlPl5QGMBUAP2P4OS88es4E=
X-Google-Smtp-Source: ABdhPJzP+cVbpVwoq+krBeYGKJ8dU+aUU9UqMV8ZDJFEs5O7IngJEnQVxPkfVZpADbJz3YMGEc7Mwk5R/9RiTphukbI=
X-Received: by 2002:ac2:5689:: with SMTP id 9mr30942152lfr.175.1609645564785;
 Sat, 02 Jan 2021 19:46:04 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msH3LZuF69UFcfgtG7XXurMDc=-Ab7Ct4XwfARR8d+wRA@mail.gmail.com>
 <20210101060050.GA1892237@jeremy-acer> <CAH2r5mt+5LQB59w0SPEp2Q-9ZZ2PV=XDMtGpy2pedhF8eKif0A@mail.gmail.com>
 <20210101195821.GA41555@jeremy-acer> <CAH2r5mvt_cHDbT0xaeLNQn=5cQ0T2-wPgpMkYEGQNdtDZ3kP=A@mail.gmail.com>
 <20210102025837.GA61433@jeremy-acer> <CAH2r5ms1V2KKb6T3ELQ-JsQ3fniOScTE2654_xLwnPruiekzEw@mail.gmail.com>
 <20210102052524.GA67422@jeremy-acer> <CAH2r5msZt0UZG5r5Z7=_jQf=-xgNz8zW7fZOnqncqeJHB=mOmA@mail.gmail.com>
 <20210103012116.GA117067@jeremy-acer> <20210103012511.GC117067@jeremy-acer>
In-Reply-To: <20210103012511.GC117067@jeremy-acer>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 Jan 2021 21:45:53 -0600
Message-ID: <CAH2r5muZ9tFZtHakrSf6Px2HGQTDUzg8+V52+NQaytKX_ZpHCA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow files to be created with backslash in file name
To:     Jeremy Allison <jra@samba.org>
Cc:     Xiaoli Feng <xifeng@redhat.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jan 2, 2021 at 7:25 PM Jeremy Allison <jra@samba.org> wrote:
>
> On Sat, Jan 02, 2021 at 05:21:16PM -0800, Jeremy Allison via samba-technical wrote:
> >On Sat, Jan 02, 2021 at 06:19:39PM -0600, Steve French wrote:
> >>I agree with the idea of being safe (in the smbclient in this case),
> >>and not returning potentially dangerous file names (even if a very
> >>remote danger to the tool, smbclient in this case), but I am not
> >>convinced that the "user friendly" behavior is to reject the names
> >>with the rather confusing message - especially as it would mean that
> >>inserting a single file with an odd name into a server could make the
> >>whole share unusable for smbclient (e.g. in a backup scenario).  I
>
> FYI, as I pointed out this only happens if you *explicitly*
> set a server parameter that is only expected to be set on
> a share with "clean" (no non-Windows) names.
>
> So just creating a file containing : \ etc. doesn't do
> this - you have to misconfigure the server FIRST.

I agree that with Samba server this is less common (not sure how many
vendors set that smb.conf
parm) but note that "man smb.conf" does not warn that disabling name
mangling will break
smbclient (assuming that local files have been created on the server with one of
the various reserved characters, perhaps over NFS for example).  But
... there are many
other servers, and I wouldn't be surprised if other servers have
sometimes returned files
created by NFS or Ceph or some cluster fs that contain reserved
characters, even if
it is illegal.

> The SMBecho is due to the keepalive failing
We (SMB/CIFS developers) would know that, but I doubt that all users
would realize that
(for example) creating a file over NFS with a reserved character and
then reexporting the
file over SMB with Samba configured with managled names off, or with a
server that
is less strict than Samba.   Seems like it would be better to print a
warning like:
                    "exiting due to invalid character found in file name"
rather than killing the session and ending up with the (to most users)
unehelpful error message.
-- 
Thanks,

Steve
