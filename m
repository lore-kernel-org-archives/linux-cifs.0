Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFA7C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA2361177
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhDIEz4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhDIEz4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 00:55:56 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF7AC061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 21:55:43 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id x8so70076ybx.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 21:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7qyVwjO+2aW8+q2wKA7u0X87h3DMFKB2eaL8s0yZKWU=;
        b=R4GQ9IEEnwxLkSsXiS92g6QdGlyFlSFHOoiIqTtc4Em2k9ft2vTFDtDHWBx9+yn2rD
         TBboV4BTPhgJmFNWtapguz3fs9UguBTYhRrFgrEDdVUk8GcDgIjSjTqtAkMorxSpf0vW
         kAAogQj5w5oeDqXLC1UKSsGb/yV/GeNkIVI+WXW1aEMiyjjR9jnKpiKoUrPFOglV9FlE
         +Wr7ta51bEX01fKy/H0xXbKVu4G+Bfo/zXCtVw/GVR5vOB4Ufd8KkQnTDFFnRP/EZsf3
         RjFyYNBlUgBWl0l7r0kKjQmSNeeSm034rV3jjRPCr7d3gzVG8MUd41KQdMjqSbtT+4Xz
         sJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7qyVwjO+2aW8+q2wKA7u0X87h3DMFKB2eaL8s0yZKWU=;
        b=pR6iHgZAQ5r9qSp6kxK2W6vRgpawmgDCxaZOQHRVuGz+/7dgEfua4QT7wElC49HpUH
         6qppYs3V74d+LrZgRLEATYpNvrgnAl9OxZZjOXFQ+xyS9tTGx3ZE9keo0D9nBoZr7h9h
         JHK+uCFpx8eJp/ttOXN0DMyVL5qxPY+KXl4HajFW+LrTIrekWE65SkmU4dC62YzJNlSS
         CU55cut951K4sUppxxhwrzOzzpQLx+Ld6CRVM4qvNBv4rlriFskXQAW8YoyKqI4H1p0G
         SHQO3EF7QoSZLC4gMfwsSsLY7GNA2+yniY6/cbJTu9yZ4XmaPwoh8OAzVWkZuN3X0mr9
         RDng==
X-Gm-Message-State: AOAM533e7bAmyJMwR95AO5kkmu7uIkNLzPte6EpmDuyWKZNg169+cwRR
        p5ZXUGQ8XZwVRcd06nRDYgdD//8mOJjWq+PrP9cm3hVc
X-Google-Smtp-Source: ABdhPJyZDTe01oGrPwg7N+OcMAGNjiBAxjDrYZGvuwH9ijvRo/X9tnbDTJmQ3mFlLPHpQw9ZSLQOjuO+LS46bmIZBc4=
X-Received: by 2002:a25:ef42:: with SMTP id w2mr15949875ybm.34.1617944142140;
 Thu, 08 Apr 2021 21:55:42 -0700 (PDT)
MIME-Version: 1.0
References: <CA+V7QS9gJ+WX6iVsRBaCoHZXwr-zPQSNWbsUqk=N06xAYv1N6g@mail.gmail.com>
In-Reply-To: <CA+V7QS9gJ+WX6iVsRBaCoHZXwr-zPQSNWbsUqk=N06xAYv1N6g@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 9 Apr 2021 10:25:31 +0530
Message-ID: <CANT5p=q=RmfmPNahsx=E0Ec_W7o6+=JeSPB2m5Vm7pVzuANzRg@mail.gmail.com>
Subject: Re: Query - cifscreds usage
To:     Richard Beare <richard.beare@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Richard,

Why not use cifscreds to store your user credentials against the
server? And then use an additional mount option "multiuser".
I haven't tried this yet, but I feel that should work for your use case.

Let me know if I'm missing anything here.

Regards,
Shyam

On Thu, Mar 18, 2021 at 3:41 AM Richard Beare <richard.beare@gmail.com> wrote:
>
> Hi,
> Apologies in advance if this is the wrong forum. Getting help
> documentation directed me here. I'm setting up a small set of
> workstations with what I hope to be three types of users, and would
> like to clarify whether certain parts of the cifs configuation are
> possible - something I haven't been able to determine from manuals or
> google to date.
>
> The base system is ubuntu 20.04lts:
>
> uname -r
> 5.4.0-67-generic
>
> mount.cifs -V
> mount.cifs version: 6.9
>
> The current setup of the machine successfully handles the cifs mount
> via pam_mount. The mount uses ntlmssp credentials, with a command
> like:
>
> MOUNT_OPTIONS="-o
> username=${USER},uid=${_UID},gid=${_GID},domain=DOMAIN,sec=ntlmssp,vers=2.1"
> AD_SHARE="//ad.host/home/user${USER_FOLDER}/${USER}"
>
> mount -t cifs ${AD_SHARE} ${_MNTPT} ${MOUNT_OPTIONS}
>
> There is no kerberos for the cifs share available to linux.
> What I'd like to know is whether it is possible to use kernel key
> credentials, like those stored with cifscreds, to authenticate a mount
> request at other times.
>
> For example, might it be possible to capture those credentials in the
> pam process and then later issue a mount command that does not prompt
> for a password? My interpretation of the docs suggests that it isn't
> possible - the credentials are used to control access to an already
> mounted share, rather than perform the initial mount.
>
> I'd like to be able to have both cifs and nfs mounts happening in the
> same place under autofs control, but without placing credentials in
> files. The cifscreds option seems very close, but not quite right - is
> my interpretation right?
>
>
> More information on why I'm asking this - I'd like a user to be able
> to authenticate against AD,
> get checked against some list, have an nfs mounted home directory
> provided if available and the cifs share mounted elsewhere for
> convenience. A cifs share gets used for home folders if the user isn't
> on the special list. Any user should be able to trigger automounts of
> nfs home folders by accessing them, as in a typical pure linux setup.
>
> The other option I think may be viable is modification of the home
> folder location during the login process, but I can't see how to
> achieve that either.
> Thanks



-- 
Regards,
Shyam
