Return-Path: <SRS0=sSqu=ZL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11DFC432C0
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Nov 2019 16:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE495223AB
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Nov 2019 16:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfKSQ4A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Nov 2019 11:56:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39207 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728320AbfKSQz7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Nov 2019 11:55:59 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <matthew.ruffell@canonical.com>)
        id 1iX6nF-0006sC-U9
        for linux-cifs@vger.kernel.org; Tue, 19 Nov 2019 16:55:58 +0000
Received: by mail-il1-f200.google.com with SMTP id t23so19918003ila.19
        for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2019 08:55:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qMVxz7DEvrAqdEQJ+q0LV0JU+LXgEg2dOoNA2KuMQqQ=;
        b=ZroQtiiEpLoEf2t3aQJupvMD9nzqT+32tUbXpTBQvpG83Mh511sVQIP8YpdqvfaOEa
         zsRpP+V2qCZa4IXvhE8X4ZDpl5JSTj0eEGzN4Nmddf73BohaUUZUG7dF1MX9x6ame2jz
         2qDo+mcNXQ82K5xqJqvIUQrval9rKshjINzH/wCVh4z0IsrbnUzXtEn2I3ibt06NXZ+A
         J6Om5MlM+O6Pz69lFfGugRy55F2zB69s1xxnUO1BOo7+Q4KZ/wkUlEMXSrGxBWSvTDqK
         wlXLiobDN438LbPfQpGLvaCc77nOHL3hvyOiJRkZ45WeCdTXci/3Z63PqKw7G0IboZKK
         8qZw==
X-Gm-Message-State: APjAAAU9AeZBaRsL6o7IMV/zdEv4iprOB5nQ0vcfLmGpuI1Yhw76KSk/
        pdZSFkkSznRC7VmK9ypHgpzEjUesx1Brjii5InrwF/u/0qj9P0m7kaoqKB/2y01h9Qm3CmrBfkw
        ymtobOnrqLrNrGScuRSm5OiwpYGID63VVuuUXbv8g9qHAq0MavV7/rNQ=
X-Received: by 2002:a05:6602:2592:: with SMTP id p18mr2856098ioo.70.1574182556896;
        Tue, 19 Nov 2019 08:55:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwU2kIEes3MA+w8AJRjpzGjbx+TVcNYUZrveoT+LXddYs4wLpcezSWo3d0zGnpJQz5XvqpKwIfgrjly8Xkkgj0=
X-Received: by 2002:a05:6602:2592:: with SMTP id p18mr2856074ioo.70.1574182556633;
 Tue, 19 Nov 2019 08:55:56 -0800 (PST)
MIME-Version: 1.0
References: <05aa2995-e85e-0ff4-d003-5bb08bd17a22@canonical.com> <87imnooa13.fsf@cjr.nz>
In-Reply-To: <87imnooa13.fsf@cjr.nz>
From:   Matthew Ruffell <matthew.ruffell@canonical.com>
Date:   Tue, 19 Nov 2019 08:55:45 -0800
Message-ID: <CAKAwkKuwsCQGPJJD7HwFhqfqO+_u=z8nt=L2TC-k-9da2iQCPw@mail.gmail.com>
Subject: Re: PROBLEM: DFS Caching feature causing problems traversing
 multi-tier DFS setups
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

Apologies for the delay.

I built the patch you placed at the end of your message into a test kernel for
our customer, based on 5.4-rc7. I also sent the customer a vanilla 5.4-rc7 to
test against, to see if the patch is what fixes the problem.

The customer just got back to me, and confirmed that vanilla 5.4-rc7 fails to
mount their multi tier DFS share, and the patched 5.4-rc7 with the patch you
provided successfully mounts their multi tier DFS share.

Not working - Vanilla 5.4-rc7
$ uname -rv
5.4.0-rc7 #4 SMP Wed Nov 13 17:23:52 NZDT 2019
$ sudo mount -v -t cifs //company.com/folders/country/<share> -o
defaults,user=<user> /mnt/share
Password for <user>@//company.com/folders/country/<share>: ************
mount.cifs kernel mount options: ip=<IPv4
Address>,unc=\\company.com\folders,user=<user>,prefixpath=country/<share>,pass=**********
mount error(2): No such file or directory
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Working - Patched 5.4-rc7 with https://paste.ubuntu.com/p/DnCTNMjQJC/
$ uname -rv
5.4.0-rc7+upstreampatch1+ #3 SMP Wed Nov 13 16:42:34 NZDT 2019
$ sudo mount -v -t cifs //company.com/folders/country/<share> -o
defaults,user=<user> /mnt/share
Password for <user>@//company.com/folders/country/<share>: ************
mount.cifs kernel mount options: ip=<IPv4
Address>,unc=\\company.com\folders,user=<user>,prefixpath=country/<share>,pass=**********
$ cd /mnt/share/
:/mnt/share$ ll
total 4
drwxr-xr-x 2 root root 0 Oct 18 2017 ./
drwxr-xr-x 3 root root 4096 Nov 19 15:51 ../
drwxr-xr-x 2 root root 0 Oct 23 15:27 <Directory>/
drwxr-xr-x 2 root root 0 Aug 13 2018 <Directory 2>/

Please, go ahead and prepare the patch for mainline inclusion, and as Steve
mentioned before, consider cc stable.

Thank you for developing the fix quickly.

Matthew Ruffell
Sustaining Engineer @ Canonical
