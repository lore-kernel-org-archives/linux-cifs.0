Return-Path: <SRS0=JIor=ZZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF0AC432C0
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Dec 2019 19:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6D920803
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Dec 2019 19:19:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KewRXwdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLCTTI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:19:08 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43538 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfLCTTH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Dec 2019 14:19:07 -0500
Received: by mail-lf1-f65.google.com with SMTP id 9so2473103lfq.10
        for <linux-cifs@vger.kernel.org>; Tue, 03 Dec 2019 11:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2GBS04O5cMailrKaNu54Z7CLaw1Q60TT9DHPp+PcaJM=;
        b=KewRXwdCnn8YKxdTiewvgQZFXLSZ1FrZn810SXducNGjFB7TZ5oclBqz1AvNK/SNrS
         w4xVzwuNtVO9z0tKZtsA0wUub9+FeZFKJr41MUPOL+HjqtHNFXl9lOPpCwQT9M4ssg1F
         JkZ7IFgqztejogvZaICBMuTVxIccyDwgMWQwvfP9ISxy1do7uxnSPcJLkctcey6Uqw6t
         P2F+mFvvxWj/uZwbYOM/8d6MNn8FuRWXQYHlVlPFyPJ4T65y02VfyXEhwFmAj//JGceJ
         HpD2QirGwmWFD47p7bbBibksXZEfvqNQ9qZqew1FSqy1BZmJN/5rxi94z+5l+nmKyh+H
         C5Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2GBS04O5cMailrKaNu54Z7CLaw1Q60TT9DHPp+PcaJM=;
        b=fKsMvTSS6nLWHegIcVUHdsND/sCpp6mSIxrOlwmTJ+t57mP0Ssh0mmuK7K/vxMbPiI
         3NS0JbIcLy+acddScxqsrAyQVUcCe8mSsJpx9nMW65duhPfGB1PBEAmJrXNSwS56NohU
         nTzW8V3g+PO7JxHF3TReYonJ0m7PwOQj2Hvss6pAkmc2jC7X6mnep+TafXQQsqPFVryS
         8HOY+zIm8Cqe6xKtdQxVYQUDiYxFbtnLr68nW8TmiucHOGeERt7Hd8HnZhYNhPWc8KuX
         uUVFwimr1L118z3dFO/dmQazt4T47T6pgk/BwJKEblqKhkuyMeTuoQuwDThpePfwrbhc
         IHJA==
X-Gm-Message-State: APjAAAX/4JTuBh2I+TbxNVlSv7L7ZvLrjnOJbuUGOD9mpVbsA8ZWse1C
        KYcfLZpWYFAgiq+n79fGjCM5WDT/aP59TKWuig==
X-Google-Smtp-Source: APXvYqyEyLHsl8ZCQXtirYTORDQSr3EzQYrbE85MXBKNQ8Wx8GbJS3C80HUtsRO+lMqth97rsPlIQPpZSKMK8BA/hnU=
X-Received: by 2002:ac2:4553:: with SMTP id j19mr3890955lfm.142.1575400745756;
 Tue, 03 Dec 2019 11:19:05 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muXMXS6S-+XykdZmZGMQGNsTunxDXM-fqX7owEG+E=RRQ@mail.gmail.com>
 <8736e1tl1j.fsf@suse.com> <CAH2r5mu9gs+wV+s1=HC9bS0Rb1KY1uJ5ZQFZsCNycGGJH50kCA@mail.gmail.com>
In-Reply-To: <CAH2r5mu9gs+wV+s1=HC9bS0Rb1KY1uJ5ZQFZsCNycGGJH50kCA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 3 Dec 2019 11:18:54 -0800
Message-ID: <CAKywueS7sVnbBCgc0Cc8NoqDsbEWVh2iMU7fBuoTS_2v-Hjw-A@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Query timestamps on file close
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The inode locking is missed in the patch. See cifs_fattr_to_inode()
that takes inode->i_lock to atomically update all the attributes. The
similar thing is needed in +smb2_close_getattr().

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 3 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 10:05, Steve French=
 <smfrench@gmail.com>:
>
> Fixed typo, and added the update of AllocationSize (and added reviewed
> by). See attached.
>
