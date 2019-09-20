Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8E0C3A5A6
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 00:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF7C7217D6
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 00:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oYh9FfAV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393268AbfITAMK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Sep 2019 20:12:10 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40793 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390329AbfITAMJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Sep 2019 20:12:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id d17so3672776lfa.7;
        Thu, 19 Sep 2019 17:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m6ayjb5Y1w+paqBDeMRBFKWOnuXQJVkXbMguPcmxhXw=;
        b=oYh9FfAVWj1Q8HXOkLBpoLgbYmc6y9vM35bODz9VsXxVkIqyCAl85OpIuDt09tBcqE
         AWudGE24UZBcjqPVCrBy2tKKmb3RryVREfzMdZxIRDdIQan2GkrIJTODF7kHAjdEIZ1x
         SKkdkfW/qRQhyhH2ENa8uH3G9psyoAqgnI6xS9S90quhsAIpD0QlDe4BZ6eTopdmEQt1
         7E6JqzHPY3ZATPrbH3UdS+S/Ygpu3KU1v472TwQCC9NT4ii/n3QHTV+GOhzS4OHA5/3j
         n01CjNRSmbAQT+dO8Ylzz8P2erKOT5mHGXjXXrekFDnEPL2PqXykqql5I/y1mpD6yicA
         KkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m6ayjb5Y1w+paqBDeMRBFKWOnuXQJVkXbMguPcmxhXw=;
        b=VXQt1wqZKcMl44uWSDhi8JXTs7Md9S2e16DztYuI/0Hh7Q6XkF3g7YdEqn5X6PpxDM
         HM9EFBJshuhK/auf1k4+zdzSbmYkgm9Vi+iDa4gQM4P0CX7ZZAYpgaqxXQGhRwhqDPQn
         LBcVNjwDwrRkGJXwv4rEfaviVbnGNSZuq+ufGZ1C7POjxN0WOl1RtFeZ3wwWK4itqfPJ
         1Q+jfjcJ75fmeafyFCvnxVFpWIhtk+v1+KDqzeMcMyXv5BNpHyQ42hmPVTo/gBuxe0P+
         K15GcpeMuKP2vEiMdKsD7b2o5dppHWLDSaC2sFgTcOD9bXkMm9oh6UZfqryJCjz/bqyP
         mqdQ==
X-Gm-Message-State: APjAAAU4ZWsRAb3Qe5fbh3rAENAWS44dIco0Jcyls17Zzw2hOM1ci6K1
        c9yzkY4j56IMfjlqVrpD82KSIqhcfTTgyWqA1Q==
X-Google-Smtp-Source: APXvYqyrHjG3SdTLkwjGnaFwRPuUfUXn13WX0rf+FkThMEIpHRSEVMubA2VRABuBECiNZqc9ZoTZJAl4zzmnZpUtUqs=
X-Received: by 2002:a19:8a0b:: with SMTP id m11mr6409704lfd.4.1568938326291;
 Thu, 19 Sep 2019 17:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190829050237.GA5161@jagdpanzerIV>
In-Reply-To: <20190829050237.GA5161@jagdpanzerIV>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 19 Sep 2019 17:11:54 -0700
Message-ID: <CAKywueRd4d_fojGL+n4BisoibhgkYfN9Wyc_+0=-1sarz4-HZw@mail.gmail.com>
Subject: Re: build_path_from_dentry_optional_prefix() may schedule from
 invalid context
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 28 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 22:02, Sergey Seno=
zhatsky
<sergey.senozhatsky.work@gmail.com>:
>
> Hello,
>
> Looking at commit "cifs: create a helper to find a writeable handle
> by path name":
>
> ->open_file_lock scope is atomic context, while build_path_from_dentry()
> can schedule - kmalloc(GFP_KERNEL)
>
>        spin_lock(&tcon->open_file_lock);
>        list_for_each(tmp, &tcon->openFileList) {
>                cfile =3D list_entry(tmp, struct cifsFileInfo,
>                             tlist);
>                full_path =3D build_path_from_dentry(cfile->dentry);
>                if (full_path =3D=3D NULL) {
>                        spin_unlock(&tcon->open_file_lock);
>                        return -ENOMEM;
>                }
>                if (strcmp(full_path, name)) {
>                        kfree(full_path);
>                        continue;
>                }
>                kfree(full_path);
>
>                cinode =3D CIFS_I(d_inode(cfile->dentry));
>                spin_unlock(&tcon->open_file_lock);
>                return cifs_get_writable_file(cinode, 0, ret_file);
>        }
>
>        spin_unlock(&tcon->open_file_lock);
>
> Additionally, kfree() can (and should) be done outside of
> ->open_file_lock scope.
>
>         -ss

Good catch. I think we should have another version of
build_path_from_dentry() which takes pre-allocated (probably on stack)
full_path as an argument. This would allow us to avoid allocations
under the spin lock.
--
Best regards,
Pavel Shilovsky
