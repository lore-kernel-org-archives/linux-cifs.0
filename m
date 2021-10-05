Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514EAC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 20:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F983611C0
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 20:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhJEUWS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 16:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhJEUWP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 16:22:15 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D3BC061749
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 13:20:24 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i24so778919lfj.13
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 13:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jaTur/0YsNRhkLVzdY4flgs2hS4lNdqogfiomozirV4=;
        b=W+oytqMD60WjTHcbfUUCmbrA+GwM6S39HNrSZv8M+q5pse8ZCeipJLXkj5KGcZX4TY
         hieG+YcRfGg+7ExmcbqKs9SzBeLIk0Krne0Z7K6XcF4GW8fAP7fZwy5JV0BBwWHUrzG8
         wLX5bpkL/+kNX1nEfFhbYU1mMHJUOrjnxiMmkoEyeGg51yD+tF08I24HlqEBpJ0aqQIZ
         rQezE7AxnTrnhuF0EJxqmW4MdSL/nVcik+8D8zo2LpJ3bCS1hrGqzpP2FLGPVQ+r39dR
         nvUXifchZOWz9hZWR1dKO/hxB0BHxDBnPGOQF2NSnUtFBAlEXq1XC+IsDos61FCfXXYI
         nQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jaTur/0YsNRhkLVzdY4flgs2hS4lNdqogfiomozirV4=;
        b=tTN/jKuUxtTODDwj1vKx/FGEP41NdC9FQo12FWRKHebr9nmgAcpU7Y4CGBqJVGJml8
         YmvHKdYw9JG+W5RSd72oQruQcCJLuHT4/GlXcSM52j+kuAwjynHMAo5/Q1HSTLOIIpTm
         w8brH6GL2L0tzt6c5zGcM+u17GlMXDA/ONPGeW1iHd7ciq2ZBikTUlqDMs55lZXQPxge
         wPwXFR/tWXZmxiKVKt7wLds0wrF72bLR4aSgsmEUS5DgoIW6xmShZAuiZm5JFv36ajZT
         485JHfFHW2OE79orVlpoZLJb537vJHtxFTZWuc/C8N1ht+H2T+al0IkFnP0JxX20KKgS
         Y8Cw==
X-Gm-Message-State: AOAM533U62pFGESxehi+cLuGiutF/otaBzIPClPVQAZJzyLtUI0h7FHt
        VEJ7V6dardpz/QYapNliUOkurM5pnwvnUSJaSfU=
X-Google-Smtp-Source: ABdhPJz5kZUms2tJWgsXf2+SBvQscqYAJ/UnTcZpOMFoUaUQNyEm6c32wwTCq9EkkJaAsjjRUO+v0aZMozi0ppzPoZg=
X-Received: by 2002:a2e:bc16:: with SMTP id b22mr25470418ljf.500.1633465222320;
 Tue, 05 Oct 2021 13:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20211002131212.130629-1-slow@samba.org> <20211002131212.130629-8-slow@samba.org>
 <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
 <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org> <CAH2r5mukpkfuf951rVC97EBA8KLVPc3chF2+33Ms31uR_ty5dg@mail.gmail.com>
 <cc20019e-7c51-1b8f-bc29-dcdaadeaed7b@samba.org>
In-Reply-To: <cc20019e-7c51-1b8f-bc29-dcdaadeaed7b@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Oct 2021 15:20:11 -0500
Message-ID: <CAH2r5mtSdYbb6G_k6MJDac845_VC2S89oEd-LCHBuB6o1YCx5Q@mail.gmail.com>
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 5, 2021 at 2:28 PM Ralph Boehme <slow@samba.org> wrote:
>
> Am 05.10.21 um 20:43 schrieb Steve French:
> > Typically kernel style encourages even a brief description in all
> > changesets (even trivial ones) e.g.
> >
> > "Simplifies message parsing slightly.  No change in behavior"
>
> Sure, I could add this. Otoh
>
> bcf130f9dfbaccf91376a44b18f51ed8007840d6
>
> :)
>
> To me it doesn't make sense.

The patch submission guidelines for the kernel (see
Documentation/process/submitting-patches.rst) are not too bad to
understand (you can see why slightly more description is needed from
some examples mentioned there), and seem reasonably logical.  Also
checkpatch already auto-verifies a few of the things mentioned in the
submitting-patches guidelines.

Note that your example is an old patch (from 10 years ago); rules have
gotten a bit stricter.  Here is a more recent patch from the same
committer, note that he no longer uses the minimalist description ("No
change in behavior") see below (and another example from same
committer commit 4b03d99794eeed27650597a886247c6427ce1055)

commit ebd9d2c2f5a7ebaaed2d7bb4dee148755f46033d
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Fri Apr 16 14:00:17 2021 -0400

    nfsd: reshuffle some code

    No change in behavior, I'm just moving some code around to avoid forward
    references in a following patch.

    (To do someday: figure out how to split up nfs4state.c.  It's big and
    disorganized.)

    Signed-off-by: J. Bruce Fields <bfields@redhat.com>
    Signed-off-by: Chuck Lever <chuck.lever@oracle.com>


-- 
Thanks,

Steve
