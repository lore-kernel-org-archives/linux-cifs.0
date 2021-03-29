Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA30C433E2
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 14:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E248261960
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 14:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhC2O5U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbhC2O5I (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Mar 2021 10:57:08 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F2C061574
        for <linux-cifs@vger.kernel.org>; Mon, 29 Mar 2021 07:57:07 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id o66so14027174ybg.10
        for <linux-cifs@vger.kernel.org>; Mon, 29 Mar 2021 07:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=81bMYNL94hoV5LLq9+EVCtSiS4rzFmgZuJLtremGF3A=;
        b=sf9k/IXH8xwTL0Q7UD6HVwh8sr8AUHIT/kqZIRGItAveNJ7nNSa/aU+5iELJkbInOB
         zVdKltMlXhlNFeNJw8t/nfIyMGNm8nqMMUnGXVFme4CbNzZ7SK8wUO4/WyaF7YAQuxKL
         6hW61iw7Vj2ZYt0QOvR5ajv/SDqMPMKoA/mSdeHTchf74qWcnHvcpYtamoVXzNo7Iw33
         xpVdMj3tHeYndPo3HnujIxD+i/rLQSn7a8okZmkDFe9gg6WGlOG2MJ/Spvfwao4THSGu
         T/GMk2dDBXqI16CuCvvcBFeX7ggJYRk6o6b6bj9nDSwNx0n35CPU3lKzRqQbARzzRZaF
         g77Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=81bMYNL94hoV5LLq9+EVCtSiS4rzFmgZuJLtremGF3A=;
        b=FwxL5TZrCVA7Zsty/7xS7gi+zCD1sAEymqU2+tlMhjcfdYImwSX01PDTNoOkI/iR+Q
         s3rF/tOXZFftAT9h4DMgqxpdOFpz93pP7/3jPPKwO5CeOI14W2hlshqed569T+Qx8778
         3UKndCD7GWNmxk3Tdx4nQlc/76ra6C2fiFkZIPpa3HdaMEg+WXAzeEXHdM9aVzrO4ez5
         KgLnWXhi68kgkD4iX6hmtlS45tHXtNQ9gbcx9QEpLbkkv7bL/xhgnNo+Sw3DQpiZ1yqF
         SetK+De8vjh/Xa4zh1tWX86U4jDRI4MgeT598HTqKJr7G9WIauPlkFdkF3fBFjnAgLKn
         I6SA==
X-Gm-Message-State: AOAM532t6m6zWLVdLH9ShfqmJw+CdudKOX05VXJHCdelZ9FNEgl/UdWw
        EtFlZ01gz1+pTV6OoxuMO44f3JiN6iHNhTkOmhtswab4QFM=
X-Google-Smtp-Source: ABdhPJxKjqof0p8BOtcDZCJSjIwUMcjU3bjH6TNsR7k384p4DjKi2tczKYGu6Vi0HA2LpCQzWFp2s3R26kUUNVpbMfo=
X-Received: by 2002:a25:694c:: with SMTP id e73mr22989907ybc.327.1617029826975;
 Mon, 29 Mar 2021 07:57:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210327113252.GC8814@topf.wg>
In-Reply-To: <20210327113252.GC8814@topf.wg>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 29 Mar 2021 20:26:56 +0530
Message-ID: <CANT5p=qShv6gyG+1LEE5edfp7TwJuF8ryCXz+e6tQZcnLHedXg@mail.gmail.com>
Subject: Re: specifying password when using krb5
To:     Frank Loeffler <frank.loeffler@uni-jena.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Frank,

When sec=krb5 is used, the Linux cifs client ignores the password
supplied. You're right. This needs to be documented.
It relies on external utilities (like samba-winbind, sssd or manual
setup of krb5 client) to fetch the krb5 TGT needed for sec=krb5.
I don't know how smbclient does this. Might be worth checking.

If you're connecting to something like a Windows AD, you can setup
winbind to fetch the krb5 TGTs for the AD users.
Once configured, winbind will fetch the kerberos credentials on behalf
of the user during login.
Alternatively, you can setup a kerberos keytab file or credential
cache file yourself manually using kinit.

Regards,
Shyam

On Sat, Mar 27, 2021 at 5:09 PM Frank Loeffler
<frank.loeffler@uni-jena.de> wrote:
>
> Hi,
>
> after hours of debugging, I finally write to this list to see if I
> understood things. Let me first explain what I tried to do and I'll post
> my question towards the end.
>
>
> What I want to do is mount a Windows-share via 'mount.cifs'. I can see
> stuff on that directory using smbclient, so login credentials ect. are
> ok:
>
> # smbclient -A /etc/my-credentials -L \\\\share.name.org
>
>         Sharename       Type      Comment
>         ---------       ----      -------
>    ... some content ...
>
> # smbclient -A /etc/my-credentials //share.name.org/home
> Try "help" to get a list of possible commands.
> smb: \> ls
>   .                                   D        0  Fri Jan 31 12:36:03 2014
>   ..                                  D        0  Fri Jan 29 07:38:10
> 2021
> ...
> smb: \>
>
> So far, so good. Now I want to mount:
>
> # mount -t cifs '\\share.name.org\home' -o credentials=/etc/my-credentials /mnt/win
> domain=MYDOMAIN
> mount.cifs kernel mount options:
> ip=10.10.10.10,unc=\\share.name.org\home,user=me@myorg.org,domain=MYDOMAIN,pass=********
> mount error(13): Permission denied
>
> Looking at wireshark-captures of the smbclient-connect I see it using
> krb5, so let's do that too with cifs:
>
> # mount -t cifs '\\share.name.org\home' -o credentials=/etc/my-credentials,sec=krb5 /mnt/win
> domain=MYDOMAIN
> mount.cifs kernel mount options:
> ip=10.10.10.10,unc=\\share.name.org\home,sec=krb5,user=me@myorg.org,domain=MYDOMAIN,pass=********
> mount error(2): No such file or directory
>
> Note, I do not have active krb5-tickets on this machine, I do not even have kinit installed.
>
> Even more strange, trying without actually specifying a password:
>
> # mount -v -t cifs '\\share.name.org\home' -o username=me@myorg.org,domain=MYDOMAIN,sec=krb5 /mnt/win
> mount.cifs kernel mount options: ip=10.10.10.10,unc=\\share.name.org\home,sec=krb5,user=me@myorg.org,domain=MYDOMAIN,pass=********
> mount error(2): No such file or directory
>
> Shows the same: it does not even ask me for the password (but still
> shows 'pass=********' in the kernel mount options). This is strange,
> because the docs say:
>
>        password=arg|pass=arg
>               specifies the CIFS password. If this option is not given
> then the environment variable PASSWD is used. If the password is not
> specified  directly  or  indirectly via an argument to mount, mount.cifs
> will prompt for a password, unless the guest option is specified.
>
> Trying without password and without sec=krb5 does indeed give me the
> expected prompt.
>
> Digging deeper, into the source of mount.cifs, I find
> (cifs.upcall.c:582)
>
> /*
>  * Prepares AP-REQ data for mechToken and gets session key
>  * Uses credentials from cache. It will not ask for password
>  * you should receive credentials for yuor name manually using
>  * kinit or whatever you wish.
> */
>
> According to that source-code comment, sec=krb5 will ignore any password
> setting - it will not even ask for one. mount.cifs.c:918 shows similar
> intentions:
>
>         if (!strncmp(value, "krb5", 4)) {
>           parsed_info->is_krb5 = 1;
>           parsed_info->got_password = 1;
>         }
>
> So, now my questions:
>
> 1. Is it intended that mount.cifs will not ask for a password when using
> sec=krb5 and will ignore any set password?
> 2. I don't want to setup krb5-tokens for users. All I want is
> authenticate using krb5 to get the smb-session and then forget about
> krb5. smbclient seems to be able to do this. I don't know how they do
> it, I suspect they create a temporary token, open the session, and then
> drop it again. Whatever smbclient does: couldn't mount.cifs do the same
> or something similar? This would make the 'password' setting meaningful
> for sec=krb5. This does not mean that existing tokens couldn't and
> shouldn't be used. It would just mean that users would not *have* to use
> an external mechanism for this.
> 3. For the moment (and only if my observations are correct): could the
> documentation be updated to reflect that "password" is ignored for
> "sec=krb5"? Users shouldn't need to dig inside the source code to find
> out things like that.
> 4. Currently, trying sec=krb5 without token cache files results in the
> rather obscure error "mount error(2): No such file or directory". Could
> this me changed into something that points users to the actual cause of
> the error?
> 5. Am I even remotely correct with any of this? :)
>
> thanks, Frank
>


-- 
Regards,
Shyam
