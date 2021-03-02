Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FEEC433E0
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Mar 2021 06:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 625B664EBA
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Mar 2021 06:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbhCCGau (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Mar 2021 01:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2359520AbhCBWAb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Mar 2021 17:00:31 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA2C061756
        for <linux-cifs@vger.kernel.org>; Tue,  2 Mar 2021 13:59:48 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id v8so15821343ilh.12
        for <linux-cifs@vger.kernel.org>; Tue, 02 Mar 2021 13:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eynTMk7zjP7VskligkfKRGOnz4Usp3Wp0gYmErypgog=;
        b=VQQBk1LcJs5XemKPMBVzeWjoWnDz0gBuMd/lGAohhuasaLBIoPq68kptNBCJ2mVEUg
         Cab/Na13tTI/cOEGyNFYPN87xVtRV49k/ECzbryZfFykk0ZNZGjzq34YWs3lVRdfpwgZ
         Vv3GuldKWXVFTaInDxfsSR2tycD9hTiV0WxLJ0izrNhFtZWem1bvmsJGT242P0SFyUge
         F/6uCeectEu89NRZxSh/1olbT8LaXsixMZnRquwgdXGeBRmCUUO9RUGbOyk9fESTAFDB
         whoeDAVk4gZ4gmpsPRdyiljhePhOBoi48f4QCvIgW3ts0Pz+V6u++daaUTKgQ7CmRVA3
         bHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eynTMk7zjP7VskligkfKRGOnz4Usp3Wp0gYmErypgog=;
        b=L5LwhfXHieJzlcti4u5ixjKKsFfdnlRbzrrK1i/srQgqRNEQ+/QFkdkkuJLGc3MEg/
         XXqmGTT3hppCCgHKhxcm8w44UKXp8oousLil6Nrnf6EDKVr80cnVBZvap1TrTfxpQ0aw
         RgE0/aOAlXEynvJEbjHqsPi/P0CyUByfbc6ikpdR4AuBXRPbNmtH27ukMjoRGnn6yaHz
         oLWRDsW7QfvtCE1LvQJsl/xCWGsWiQQszeWmoQDONKkZsUhdnr2QPVxVrCYehOV+6I/r
         RVGt86NEEnP+lKxIvm7X11ckj9pnIc3ck+MUim5beLY8ctJRosJTSZduN0toHo4BxMdi
         462w==
X-Gm-Message-State: AOAM530BTY+MtHz1xUpH18KnAerEVm6G+UWfxE9vu6JO8+EWpAGaeqp4
        a2SSxNSIBQynVFHLl8zKFrJYKABMOoFDgHV5cIw=
X-Google-Smtp-Source: ABdhPJybfevM+MuNL0ftDgpBHgOSbD3uHX/rsWomrUXx8mtcr5Da368GvxkbWE9NDY14xWAGVY7Qj8+IZZIvqA8Ai+o=
X-Received: by 2002:a92:cd0c:: with SMTP id z12mr545323iln.109.1614722388240;
 Tue, 02 Mar 2021 13:59:48 -0800 (PST)
MIME-Version: 1.0
References: <87tupuya6t.fsf@suse.com>
In-Reply-To: <87tupuya6t.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 3 Mar 2021 07:59:37 +1000
Message-ID: <CAN05THRV_Tns4MTO-GFNg0reR+HJKa1BCSQ0m23PTSryGNPCeg@mail.gmail.com>
Subject: Re: [EXPERIMENT] new mount API verbose errors from userspace
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 2, 2021 at 5:03 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi,
>
> I have some code to use the new mount API from user space.
>
> The kernel changes are just making the code use the fs_context logging
> feature.
>
> The sample userspace prog (fsopen.c) is just a PoC showing how mounting
> is done and how the mount errors are read.
>
> If you change the prog to use a wrong version for example (vers=3D4.0) yo=
u
> get this:
>
>     $ gcc -o fsopen fsopen.c
>     $ ./fsopen
>     fsconfig(sfd, FSCONFIG_SET_STRING, "vers", "4.0", 0): Invalid argumen=
t
>     kernel mount errors:
>     e Unknown vers=3D option specified: 4.0
>
> There are some cons to using this API, mainly that mount.cifs will have
> to encode more knowledge and processing of the user-provided option
> before passing it to the kernel.
>
> Where previously we would pass most options as-is to the kernel, making
> it easier to add new ones without patching mount.cifs; we know have to
> know if the option is a key=3Dstring, or key=3Dint, or boolean (key/nokey=
)
> and call the appropriate FSCONFIG_SET_{STRING,FLAG,PATH,...}.
>
> The pros are that we process one option at a time and we can fail early
> with verbose, helpful messages to the user.

I like this, this is very nice.
But, as you touch upon, it requires we know in mount.c what type each
argument is.
Which is problematic because the list of mount arguments in cifs.ko
has a fair amount of crunch
and I think it would be unworkable to keep cifs-utils and cifs.ko in
lockstep for every release where
we modify a mount argument.

What I think we should have is a ioctl(),  system-call,
/proc/fs/cifs/options,  where we can query the kernel/file-system
module
for "give me a list of all recognized mount options and their type"
i.e. basically a way to fetch the "struct fs_parameter_spec" to userspace.

This is probably something that would not be specific to cifs, but
would apply to all filesystem modules.


regards
ronnie sahlberg


>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
