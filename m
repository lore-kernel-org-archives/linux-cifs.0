Return-Path: <SRS0=AX+W=4X=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D311C10DCE
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Mar 2020 13:59:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA302084E
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Mar 2020 13:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hc3jVLnB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgCFN7F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Mar 2020 08:59:05 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43430 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgCFN7F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 Mar 2020 08:59:05 -0500
Received: by mail-ot1-f66.google.com with SMTP id j5so2454220otn.10
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2020 05:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h3VlmKzREBTt3fAX25IOelS+3ue0xzaNV1VIc+71Bpk=;
        b=hc3jVLnBp1UgZknKhUDttey2f9K/us0tHLddaaAfXghSVQDfg/1mi4tnnHqu6E+Pe/
         eRPMv1PsQAy6G6n7695/LwoNe4F/UUnK8l/1Aqa5fg5PSCJWz9uW9ygD48M5/ZdV/B2G
         2S5RCcqjc9nd6BPwupRZPlJMaR9p5/y42LF7B+dICxLtm6zq9yZiXOsmqlvlggQ4eq5J
         84YC+KnvMAlpvyWqabM9gVkDrF3tfkgnp22h8m1cyyOqJyUDGCk63MRiFKeDmOtTIsNF
         kP3jrGR00G4I4++5aa65blN7tIyOyEvb54GAMhN2HHyR58aBfizpiSDyOHgFI98ThpJS
         qfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h3VlmKzREBTt3fAX25IOelS+3ue0xzaNV1VIc+71Bpk=;
        b=NzUXuMct/HO/GHTkrZNmsUB0mtDQNg+hRwoItU9p7kwrWLp8pqWL+lQUqeg7hpFttS
         4SopXLxRv4tG03uffGMaHHjpTLamtylFhkHOBx/tRwOkYtLrZEmuil+R8vP5FaIqQLtY
         PJzq9XaQUE7LqO5b9uf8AWej+/ktYSNjm+b+SVVogc6YkXe8GkcvQGE7Cp0AqejCj+9W
         y+l/34SzsECvNl9aMua7lBGLsot2ohlpwOjFtaG41EcMRKpruDjEL4+czjVVaWFDij3O
         xykl/RpOMqepPkSAhqau0JupgTSGi+6DepQQqIxYWc/OsX3zG3qUWw5p/vWtdeuq/oIA
         K1NA==
X-Gm-Message-State: ANhLgQ0EaNC9kNlxdCx4xbWMzZT/sX7XdEA4Fng75v+NsafextDeJD/y
        7MlJT+9rNqplBCQE02N/OU4Y6vS8C2RCjb6yp4o=
X-Google-Smtp-Source: ADFU+vsv3S627Uy88B07yOXdVyRRcdFoL19Vbjno7A5obXxzTKW+5VuLr9UgzH3fE8lAkfUDamQe15/paASgyq448Fo=
X-Received: by 2002:a9d:61d6:: with SMTP id h22mr2477992otk.353.1583503144013;
 Fri, 06 Mar 2020 05:59:04 -0800 (PST)
MIME-Version: 1.0
References: <CA+7wUszkCoy_o2RJ76QESUH3S7NKG6RvFyVY+5sDcQA+dC6utw@mail.gmail.com>
 <CAH2r5mtd-WbXbTG6bgT9EfZyXCC2Qr-TB8QszOy+oFRu5CrerQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtd-WbXbTG6bgT9EfZyXCC2Qr-TB8QszOy+oFRu5CrerQ@mail.gmail.com>
From:   Mathieu Malaterre <mathieu.malaterre@gmail.com>
Date:   Fri, 6 Mar 2020 14:58:50 +0100
Message-ID: <CA+7wUsx7sBMzSFnaynBoU3zoBAaG1n6909EhTsixuzKLTzB79Q@mail.gmail.com>
Subject: Re: Proper mounting Windows DFS Namespace in Linux / Object is remote
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve,

On Mon, Mar 2, 2020 at 10:12 PM Steve French <smfrench@gmail.com> wrote:
>
> Can you try an experiment with Ubuntu's newer kernel:
>
> https://wiki.ubuntu.com/Kernel/MainlineBuilds
> Or
>
> https://github.com/pimlie/ubuntu-mainline-kernel.sh

I picked latest Debian bullseye installer. Here is what I have:

$ uname -rvo
5.4.0-4-amd64 #1 SMP Debian 5.4.19-1 (2020-02-13) GNU/Linux

I am observing the same behavior with regard to 'nodfs' option. I am
required to use this option to get the first mount working.

$ mount
[...]
//mydoma01.acme.corp/network on /tmp/z type cifs
(rw,relatime,vers=default,cache=strict,username=mmalaterre,domain=MY,uid=0,noforceuid,gid=0,noforcegid,addr=1.2.3.4,file_mode=0755,dir_mode=0755,soft,nounix,nodfs,mapposix,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1)

For some reason I am getting vers=1.0 behavior (described previously):

    $ cd /tmp/z
    $ cd folder2
    $ ls
    subfolder2
    $ cd subfolder2/
    bash: cd: subfolder2/: Object is remote

Ref:

$ apt-cache policy cifs-utils
cifs-utils:
  Installed: 2:6.9-1
  Candidate: 2:6.9-1
  Version table:
 *** 2:6.9-1 500
        500 http://deb.debian.org/debian bullseye/main amd64 Packages
        100 /var/lib/dpkg/status
