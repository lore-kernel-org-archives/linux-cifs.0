Return-Path: <SRS0=hrCW=42=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86485C10F29
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Mar 2020 10:10:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D68220828
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Mar 2020 10:10:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VCpdR/7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCIKK6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Mar 2020 06:10:58 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41524 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIKK6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Mar 2020 06:10:58 -0400
Received: by mail-oi1-f196.google.com with SMTP id i1so9535233oie.8
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2020 03:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CN4iAlbjItoDXwwZc9+toj2fr45v+x1gzBMqHr20QKc=;
        b=VCpdR/7lAPdGJ42zzuqETlylmQgu0elf39ILetcSn8HNWj8tq2Wq7WJP1y5gq5K5CA
         8rdx0F+nFMGoRSsPjwiNmylYtpxUw953MhKCOldYZYbI0f5/rEPu1ryg/RtUYV1xSg98
         XjX1iJr8uFS2YSTRJ04kyEBiV4uuUMMhN0udiMO8nvMoqJ7rc6yy20oSkysaG1imaoBe
         qzbTaovWRrWH4CU5ne8uzONVVo+Uglg9l8zt7c9e8mHMw+XRCe88TQD0+6hYMCnEIJjc
         UnH1G2zawxNY4drJEvn9B1oGn6227unLa3nAkb4l6PnghFSQQI7mDC3Y7jlYZ5OK05a9
         Tziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CN4iAlbjItoDXwwZc9+toj2fr45v+x1gzBMqHr20QKc=;
        b=Drpb30Tw4NVvyauf3pyriiGQbXZ93ctHd2DfGPiOWQZEXvgDPace7LrPy+V3I6ickc
         BEzM2QQBXiEoMsey+BK2npB6VmmLuHRR89VFYq7NHn/fESdJszrG3o/GPa1lYCunLwa6
         QPxjtwCeZPYny6dGi+IMzlaQyyO8inXdrqs6Jey0jefiAZMfAXRdirboKzZICVOBC5le
         tDqYn+DLCwn9uIohyk9w9f8EXE/ulY181zVlAOEQ0gzC1wtgAdgKstP4ibWx/rcuglg2
         0hxjBkvQHQo+9CulPlRvUftM/RSYSJeo661+SzIapne5twrqe46+BSJfZ9OMs7CeOV69
         37WQ==
X-Gm-Message-State: ANhLgQ2G3fWJXp9m1+ZwtbLv91KIeo6X0Y29ZArp1wpjkD2PBsMWLbOL
        P0E7MUvWFXDPGqXLBMkyCgx0mmPSGX4waPFzO30=
X-Google-Smtp-Source: ADFU+vsRIZN6qA/qyG9ouMw8jPh93h1yUnZmz7EFY6BUpWmMivR8GJfdagetL4zkTxYq1T2zw0SuNZ9NJQSOEtxA0pA=
X-Received: by 2002:aca:56c2:: with SMTP id k185mr5409192oib.141.1583748657878;
 Mon, 09 Mar 2020 03:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <CA+7wUszkCoy_o2RJ76QESUH3S7NKG6RvFyVY+5sDcQA+dC6utw@mail.gmail.com>
 <CAH2r5mtd-WbXbTG6bgT9EfZyXCC2Qr-TB8QszOy+oFRu5CrerQ@mail.gmail.com> <CA+7wUsx7sBMzSFnaynBoU3zoBAaG1n6909EhTsixuzKLTzB79Q@mail.gmail.com>
In-Reply-To: <CA+7wUsx7sBMzSFnaynBoU3zoBAaG1n6909EhTsixuzKLTzB79Q@mail.gmail.com>
From:   Mathieu Malaterre <mathieu.malaterre@gmail.com>
Date:   Mon, 9 Mar 2020 11:10:40 +0100
Message-ID: <CA+7wUsxNJ2KQgQ8v+hob31NP45HDAEKEHPKNJ6+F+6AFBCeaJw@mail.gmail.com>
Subject: Re: Proper mounting Windows DFS Namespace in Linux / Object is remote
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Mar 6, 2020 at 2:58 PM Mathieu Malaterre
<mathieu.malaterre@gmail.com> wrote:
>
> Steve,
>
> On Mon, Mar 2, 2020 at 10:12 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Can you try an experiment with Ubuntu's newer kernel:
> >
> > https://wiki.ubuntu.com/Kernel/MainlineBuilds
> > Or
> >
> > https://github.com/pimlie/ubuntu-mainline-kernel.sh
>
> I picked latest Debian bullseye installer. Here is what I have:
>
> $ uname -rvo
> 5.4.0-4-amd64 #1 SMP Debian 5.4.19-1 (2020-02-13) GNU/Linux
>
> I am observing the same behavior with regard to 'nodfs' option. I am
> required to use this option to get the first mount working.
>
> $ mount
> [...]
> //mydoma01.acme.corp/network on /tmp/z type cifs
> (rw,relatime,vers=default,cache=strict,username=mmalaterre,domain=MY,uid=0,noforceuid,gid=0,noforcegid,addr=1.2.3.4,file_mode=0755,dir_mode=0755,soft,nounix,nodfs,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)
>
> For some reason I am getting vers=1.0 behavior (described previously):
>
>     $ cd /tmp/z
>     $ cd folder2
>     $ ls
>     subfolder2
>     $ cd subfolder2/
>     bash: cd: subfolder2/: Object is remote
>
> Ref:
>
> $ apt-cache policy cifs-utils
> cifs-utils:
>   Installed: 2:6.9-1
>   Candidate: 2:6.9-1
>   Version table:
>  *** 2:6.9-1 500
>         500 http://deb.debian.org/debian bullseye/main amd64 Packages
>         100 /var/lib/dpkg/status

I eventually stumble upon:

* https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

Which gave me a more verbose error log I found out that:

[...]
[  687.037593] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip:
unable to resolve: MYSERV13
[  687.037606] fs/cifs/cifs_dfs_ref.c: cifs_compose_mount_options:
Failed to resolve server part of //MYSERV13/network to IP: -2
[...]

Updating my resolve.conf from:

search acme.corp

to:

search acme.corp mydoma01.acme.corp

I was finally able to call mount -t cifs without the 'nodfs' option.
The symptoms are no longer an error and simply informative:

$ cd subfolder2
CIFS VFS: BAD_NETWORK_NAME: \\MYSERV13\network
[...]

I can finally access the content of subfolder2 without issue.

-- 
Mathieu
