Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AB0C3F2D1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 04:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EEB21556
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 04:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwarbDN9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgCDEmb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 23:42:31 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:36987 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgCDEmb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 23:42:31 -0500
Received: by mail-lj1-f195.google.com with SMTP id q23so464006ljm.4
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2020 20:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LlNfhtR7+dh4ztkPdXaosHVg0EWcyUieuWtxvbng71M=;
        b=fwarbDN9y4ob/ITBLXfUpur572KcX4Fgy+VkFVfaM0D+gj61HG5CoDDOphREhOo7zO
         UoPDuVprgEqky0D/DDI0jCF4eIi+5JP4TTyZEDF0FcMdKbQZUM5BAjXHnW9mf8uRXce6
         w7C8wjsbeWarbA0V3vKEAlYIoV82lkxeUobncAZly+i0Pif/e0JT/rhw4YgK0ct8v3x4
         vUUeQhxYRWaKjv0MY1ZOjf3FYzAMeGonqpy9uVZwUkGtuCqaF6sulR823LbVjkPD/f2+
         IBobBi1p7I3vfh28NF5fJEU5FCAtatSMrpD69PqtmMViwGZRcH+6vf7sCriAW02Aez9Q
         5fxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LlNfhtR7+dh4ztkPdXaosHVg0EWcyUieuWtxvbng71M=;
        b=EIMyZDTOp62aVEzJ5w56OLnLV1jKdVdiKYHt7RNRWtn4wiQisxO7ZdKJ8t9K+hQmer
         OjoAwpzpSaZbc7hhnWKwdUom+3cn1/3qfVqF/1cc0m97FV0D3U/7NUUOlTsbAQhpPT7B
         0kJSM+MXM7RDn1k2abd10sxv6GyABv5jjFyEMhS/Gav8V4KUeIKS2vIQRzEQHFF6Trfl
         f9N9zNFF+d9llVxoVhS7fPyKfW2kdHPznO1KAeBJFAsgtMcSvJfunz58z1C6JMwfp3kc
         s9khnNE5JYXwtl2MJRTgbqTjrRxfo0+4C84qtaP15qe2iveM42M0dY1UDhixU3KH0QAv
         +rJg==
X-Gm-Message-State: ANhLgQ2ZdXAXY7D5GbjagliaCah6JYLdzvSY/e9CpBlc1sdxNItZ/i2i
        VMzGVudRPoHAF0BVgqiEhxHnlqkYqNhhQWi7hQ==
X-Google-Smtp-Source: ADFU+vvu13XR7txsdWgjEveHtfOMuayr3HCYzSSrvzUPiBiJzCQFWsgRvaLw90okHMCpxvyAtqxLGWc4Ht7snULd96s=
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr745088ljk.245.1583296949839;
 Tue, 03 Mar 2020 20:42:29 -0800 (PST)
MIME-Version: 1.0
References: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
In-Reply-To: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 3 Mar 2020 20:42:18 -0800
Message-ID: <CAKywueTKmwyF0fO_ErFUXa2Jgq+F9xAUKgLdCWWWXXCfp2ih2g@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: allow unlock flock and OFD lock across fork
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It looks that I forgot to ack the patch:

Acked-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 20 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 18:30, Murph=
y Zhou <jencce.kernel@gmail.com>:
>
> Since commit d0677992d2af ("cifs: add support for flock") added
> support for flock, LTP/flock03[1] testcase started to fail.
>
> This testcase is testing flock lock and unlock across fork.
> The parent locks file and starts the child process, in which
> it unlock the same fd and lock the same file with another fd
> again. All the lock and unlock operation should succeed.
>
> Now the child process does not actually unlock the file, so
> the following lock fails. Fix this by allowing flock and OFD
> lock go through the unlock routine, not skipping if the unlock
> request comes from another process.
>
> Patch has been tested by LTP/xfstests on samba and Windows
> server, v3.11, with or without cache=3Dnone mount option.
>
> [1] https://github.com/linux-test-project/ltp/blob/master/testcases/kerne=
l/syscalls/flock/flock03.c
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2file.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index afe1f03aabe3..eebfbf3a8c80 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -152,7 +152,12 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct=
 file_lock *flock,
>                     (li->offset + li->length))
>                         continue;
>                 if (current->tgid !=3D li->pid)
> -                       continue;
> +                       /*
> +                        * flock and OFD lock are associated with an open
> +                        * file description, not the process.
> +                        */
> +                       if (!(flock->fl_flags & (FL_FLOCK | FL_OFDLCK)))
> +                               continue;
>                 if (cinode->can_cache_brlcks) {
>                         /*
>                          * We can cache brlock requests - simply remove a=
 lock
> --
> 2.20.1
>
>
