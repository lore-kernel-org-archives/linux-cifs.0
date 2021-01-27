Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8E8C433E6
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 06:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A61D720715
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 06:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhA0GHm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhA0FlT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 00:41:19 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA0C061573
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 21:37:39 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id a1so673097ilr.5
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 21:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xGArUN0r4AnIMNv0f1t7IZbJIJZ927oUl6WKm0Y2Vk4=;
        b=u8qOrj0ujhExxMmaqsd/DSWGogcuR/FNUisDEp315MTfrMNPO3iN95pORHIT/Wtxru
         rFPmB4lYzrgADZ0WjE5iKq9Y9/VyBHqQP9ULW+7bT/8ig/u2qH6ynelWqkf63liUP1FN
         HtewQn9IV2Uj9lfhSIL+S6REFTn6nZKB0KlTAHnOybKGcF77zZu2rpelr3/aVSJJW5Oy
         /l7DF6u8R6KncCdvN+frccj4Njp7qeyFlktO2tStKJbCUgX8b2mWeChgMuhFXBMRNWcu
         8lUdZq24GwwiZSxITyUtjqGTuQkDI0ogamypb0NKRj6S+IYCxZBX/kY2WYbyMrLtBHuu
         Ercw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xGArUN0r4AnIMNv0f1t7IZbJIJZ927oUl6WKm0Y2Vk4=;
        b=a8+hQyNLo3cRX8P9o5sG9LVx+hTqrEHTlCPYEr7FyY2qZwlDXyj6fzQcwKMz3qbW1J
         PSBW7kY5gfj/uG9jPzKURuQkzHqGP0Z6jDoJD9KwEWMHDu3utyHTq0g8LBM2IeBZ0mz8
         wutBlzWV7bVDO+4VGq80+EEz39IBCXKBjP8XsbWMFgd+nRhQEk3PT1oq2aqlXPF/HzvJ
         frICdRKMqOHeWhbuy54dvgZHRO9rn1oX+kmBhBv7tcuAm0Yk6PTnOcWUbhHiN+rh7V4Q
         rtGM9iJFTnE8N1INEXCkbCEQ+kmVU17AsU3ASPXysfs4tU+QRkGLUwXBqA2Y34I1+He0
         1/tw==
X-Gm-Message-State: AOAM5306Y2P+TaAv2q7Xl8xSgvT5+nVpBg7BEHs8ZOvqxWiFEQeWTIMl
        eQc0B+5pzAr2oLLQf59JHaKnbA+m87CMzoHGxJQPF0g5afY=
X-Google-Smtp-Source: ABdhPJw0FwohIX8EkUN2IyV6anpLYaXprTa4RNfKik42OYQ553Ead/5EG+3OwwkVsmkhopp90/d+mG5gQW3Ti19GdhM=
X-Received: by 2002:a05:6e02:ca9:: with SMTP id 9mr7512878ilg.159.1611725859048;
 Tue, 26 Jan 2021 21:37:39 -0800 (PST)
MIME-Version: 1.0
References: <1415900995.66272053.1611639038067.JavaMail.zimbra@redhat.com> <1593727848.66273087.1611640555370.JavaMail.zimbra@redhat.com>
In-Reply-To: <1593727848.66273087.1611640555370.JavaMail.zimbra@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 27 Jan 2021 15:37:27 +1000
Message-ID: <CAN05THSrMzaMd+_yf1BYWw4oW2RJNhDR1Ao+9JmOLf9e=N3ksg@mail.gmail.com>
Subject: Re: mount dfs share failed becaus e of missing username
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yeah, there are a few bugs with dfs in the new mount api.
One bug is in connect.c:expand_dfs_referrals() where we should remove
the call to
smb3_cleanup_fs_context_content().  But it is not sufficient.
as we will just loop and never resolve the actual DFS referral.

I am trying to find where we lost that.

On Wed, Jan 27, 2021 at 10:45 AM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Hello guys,
>
> I met a bug. Mount dfs root share failed on v5.11.0-rc5. But It's success=
 on v5.10.
>
> [root@ibm-x3650m4-01-vm-14 ~]# mount -vvv  //localhost/dfsroot cifs -o us=
er=3Droot,password=3Dredhat
> mount.cifs kernel mount options: ip=3D::1,unc=3D\\localhost\dfsroot,user=
=3Droot,pass=3D********
> mount error(22): Invalid argument
>
> dmesg log:
> [ 1648.025424] CIFS: fs/cifs/connect.c: build_unc_path_to_root: full_path=
=3D\\localhost\dfsroot
> [ 1648.025427] CIFS: fs/cifs/connect.c: build_unc_path_to_root: full_path=
=3D\\localhost\dfsroot
> [ 1648.025429] CIFS: fs/cifs/connect.c: build_unc_path_to_root: full_path=
=3D\\localhost\dfsroot
> [ 1648.025434] CIFS: fs/cifs/dfs_cache.c: __dfs_cache_find: search path: =
\localhost\dfsroot
> [ 1648.025437] CIFS: fs/cifs/dfs_cache.c: setup_referral: set up new ref
> [ 1648.026760] CIFS: fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip=
: resolved: localhost to 127.0.0.1
> [ 1648.026773] CIFS: VFS: No username specified
> [ 1648.028008] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses_count=3D3
> [ 1648.028012] CIFS: fs/cifs/connect.c: cifs_put_tcon: tc_count=3D1
> [ 1648.028014] CIFS: fs/cifs/connect.c: VFS: in cifs_put_tcon as Xid: 32 =
with uid: 0
> [ 1648.028017] CIFS: fs/cifs/smb2pdu.c: Tree Disconnect
> [ 1648.028385] CIFS: fs/cifs/connect.c: cifs_put_smb_ses: ses_count=3D2
> [ 1648.028390] CIFS: fs/cifs/connect.c: VFS: leaving mount_put_conns (xid=
 =3D 29) rc =3D 0
> [ 1648.028393] CIFS: VFS: cifs_mount failed w/return code =3D -22
>
>
> More info please look https://bugzilla.kernel.org/show_bug.cgi?id=3D21134=
5.
>
> Thanks.
>
> --
> Best regards!
> XiaoLi Feng =E5=86=AF=E5=B0=8F=E4=B8=BD
>
> Red Hat Software (Beijing) Co.,Ltd
> filesystem-qe Team
> IRC:xifeng=EF=BC=8C#channel: fs-qe
> Tel:+86-10-8388112
> 9/F, Raycom
>
