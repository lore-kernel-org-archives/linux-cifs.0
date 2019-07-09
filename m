Return-Path: <SRS0=dv7Q=VG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2874C606CF
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 03:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A303F21537
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 03:05:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IF97BRae"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfGIDFm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Jul 2019 23:05:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37988 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIDFm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Jul 2019 23:05:42 -0400
Received: by mail-pg1-f196.google.com with SMTP id z75so8667207pgz.5
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jul 2019 20:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tiWaU7TfU0pQNcsbZ7N8JOiB7ELuuZjC1ij1j/n4vOE=;
        b=IF97BRaeYc7JmBBoSOwTzDoiDYRpYdzOutBYtVgbNHZr7cfAWF5VjMiYlHZam++5VG
         5FFZ3j5194zg42sMLmuCVb1NU2ZPqKAEBzbRgtRr9mcIIKsWDr80fZU88eGZEbVIruK9
         5JRwxD8g+JcZEutLAp0zhtkZabTeMZ3VdJcDbGf8ZehANW04Jj6mZT4ZBTFHkIzvwS2e
         C5v3UgrIwRhKed0lHszWubtxd/pDN5m0aeTsN8/ZL8A8m5N50p+nBBE0L9lrRKXOz++t
         MzU72G5uSNgX1zVRCu4cU2BgnZMbcp+Spdw+OVFqGLhgZAnGgTrAoHLf2s9ZvXCR0z3g
         1GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tiWaU7TfU0pQNcsbZ7N8JOiB7ELuuZjC1ij1j/n4vOE=;
        b=jwYG9Q4TYkf4GIABTZeoVeGqoetOMpdQoABq9+lxSMNftOz6dfnpJR0wTbiICGlo06
         18TxJWZb73aOI89MwlESbTHx6wQHxy/TML8cEWjz8nTnBCRkuVTFrzdfxlnBmyqHDeXq
         lNf5e6hZ7AInzCFJt6onP7/RCcXezbWmwJ06VX80XV38954EY1zcCqrqHV56bvG41Lge
         3L+xYcHhrT/mTjAaMjKUX4dJ2e+d5uf0SU0qvmiVcZdHs80UKTrKtHNMNBRu5qJX7Nev
         HoI3pKUmjeyTNAacWYBqMAPy0maVk0KmZAr7H7FXQ/4fz9V60SBpuRHx+ViWBMh+OoQw
         TAPw==
X-Gm-Message-State: APjAAAW+R+czv896EVY6YKs2SAZ4q0SP0gDtaauOIqOEYapznUd49M5w
        J60r4KsgxUyGvWFrCx5S+z6/8wxc6jsLrDtn5nI51GKq
X-Google-Smtp-Source: APXvYqxYyviDYn1gDzwyDHikLJ7twH40CZs6jIV8oaZVYHn0bcdtDDEpcvbWhYnIv4RsHDxbQe3ztXcREvGbOuRr9K8=
X-Received: by 2002:a65:6454:: with SMTP id s20mr27714389pgv.15.1562641541388;
 Mon, 08 Jul 2019 20:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAO3V83L1Q9jCLBsjHgFE1jw2PPi_sHtQz4geDKC4jEPWkhNYBg@mail.gmail.com>
 <CAO3V83+iZRAQRZ5YzivPS3di0QM=-dJOg8rnVK1icUuuESd+=g@mail.gmail.com>
In-Reply-To: <CAO3V83+iZRAQRZ5YzivPS3di0QM=-dJOg8rnVK1icUuuESd+=g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Jul 2019 22:05:32 -0500
Message-ID: <CAH2r5muXeKhfTgovqD1uQw_yRbstqj4M9NExqmtp0ZqZ6Dx4VA@mail.gmail.com>
Subject: Re: mount.cifs fails but smbclient succeeds
To:     Wout Mertens <wout.mertens@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

What kernel version? Note that we did make a change late last year in
how we report the server name component of the UNC name during tree
connection so could be useful to try with reasonably recent kernel -
perhaps 5.1 kernel if possible as an experiment

What server type?

On Mon, Jul 8, 2019 at 7:52 PM Wout Mertens <wout.mertens@gmail.com> wrote:
>
> Hi,
>
> I need to mount a file server that I only have credentials for and
> know nothing about.
>
> I have a completely vanilla setup without /etc/smb.conf, nor any Samba
> service running; only the samba client binaries are installed. The
> credentials are domain, username, password; Kerberos is not being used
> as confirmed by the smbclient debug output.
>
> When I connect using
>
>     smbclient -A credentials.txt //corp.local/mnt
>
> it works fine. The name corp.local resolves using DNS and I can browse
> the datastore.
>
> When I mount using
>
>  mount -vvvvv -t cifs //corp.local/mnt --verbose
> -overs=3,credentials=credentials.txt,sec=ntlmssp /mnt
>
> I see that I get a STATUS_BAD_NETWORK_NAME back. If I change the
> credentials, I get a logon error, and if I change the mount name, I
> get a missing file error. So it seems that the path and the
> credentials are correct. If I change the version to 1, it fails in
> some other way. If I change the sec to ntlm, it complains about
> authentication.
>
> Any suggestions? This is driving me crazy :-/
>
> Many thanks!
>
> Wout.



-- 
Thanks,

Steve
