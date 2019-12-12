Return-Path: <SRS0=7r19=2C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CE5C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Dec 2019 19:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81A612173E
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Dec 2019 19:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EaTcmkrL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbfLLTg7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 14:36:59 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44724 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbfLLTg7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 14:36:59 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so3265697iof.11
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 11:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=I4qNOtpTnliWRWpYcshqwqZptTmZfORm7Q5xQxkjBIU=;
        b=EaTcmkrLQJdVGvm75Zj5zptXNp26PfhGv3aQbdYVDnvrUIbcI6JQqjkjrkZtglIHY8
         amLLXoxKpDQvNsdi616BpXhLUqTQj9JkAouPYiMvkhoWhrSpvQDPaGGwn6hQCZJxbPhs
         4dzPAeIYhHK38BApbiJqd1wCTCPQBRHVyz7irwVym0YSUxLoos6aH6VqJecDrtECcan4
         TP7qfaCyZUKCOgtzphDJvHoOAw9Q2+X9KhG1vtjDM5Qr6gasm0y+LziIBUt7xBsm48Ot
         QJWalFvyPilh6ZcTD6PzcZWHQn3YJv9A8R/ROv2ERGhK1MQQdTE+aPSomqWmUIBUiq9P
         Nexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=I4qNOtpTnliWRWpYcshqwqZptTmZfORm7Q5xQxkjBIU=;
        b=C/Zhwt8muSIsPCH6jTRGGzYNzYEJGdjxgjsl+O2dkXvEMtmre7MGWM2bFxiZvfyen4
         w2hKjRqyw+J5xldsYeAazI8bqtSBZbQOfCrnVYzlclZ5kvEwItnC+3SvcgVBKd69iSKJ
         G5bkpKEa2hzjmGgg7nmHmpfR8G9rcqL+JIp9u+P55Vg0QJVBHx+aN1Mw+u/UeibO+9qe
         CQvgq50OLY0w8ZvmfNbci2xhTGq4Y0HuS2/Bqp+xtUer5GiAdqsvijs6guHtyNXfgC0a
         uhnupcnLGx5vd5utbYWzQevDcqwkPcncFmT8UYBzZo+dA3oi85AfCnJnBCitldF185Xz
         ChVg==
X-Gm-Message-State: APjAAAVNgPqr+vUqkHQtCxcuwBgzQHZsoynySHXf8T230lgn19JMHuuN
        IXROjS8TP+XoFJ6B4rULXsMTukw/xpAttgQGxfU=
X-Google-Smtp-Source: APXvYqzU/0hq7yz9UYXcf/Aff/z2tTFW41l13A9PR1Uw/MExsayQyJs13HwflJ1ADMv+7fSt7kvnjH/hLlNXKYBaoPc=
X-Received: by 2002:a05:6638:30e:: with SMTP id w14mr9779527jap.58.1576179418384;
 Thu, 12 Dec 2019 11:36:58 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJSARbGJ4cOZoGy32mCtUTG9wyEyw8aF06zexshAmqfQ@mail.gmail.com>
 <CAKywueQSgGgPB+tQz28_VCe1LiyxpY7tU9tByypkTJALdHOOWg@mail.gmail.com>
In-Reply-To: <CAKywueQSgGgPB+tQz28_VCe1LiyxpY7tU9tByypkTJALdHOOWg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 13 Dec 2019 05:36:47 +1000
Message-ID: <CAN05THSZXrOvZtwYWgejMGKbxrGePNdFSPV5+hUkX8yHySee8Q@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix refcount underflow warning on unmount when no
 directory leases
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This makes sense. Thanks for this patch.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Wed, Dec 11, 2019 at 5:53 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D0=BD, 9 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 20:48, Steve Fren=
ch <smfrench@gmail.com>:
> >
> > Fix refcount underflow warning when unmounting to servers which didn't =
grant
> > directory leases.
> >
> > [  301.680095] refcount_t: underflow; use-after-free.
> > [  301.680192] WARNING: CPU: 1 PID: 3569 at lib/refcount.c:28
> > refcount_warn_saturate+0xb4/0xf3
> > ...
> > [  301.682139] Call Trace:
> > [  301.682240]  close_shroot+0x97/0xda [cifs]
> > [  301.682351]  SMB2_tdis+0x7c/0x176 [cifs]
> > [  301.682456]  ? _get_xid+0x58/0x91 [cifs]
> > [  301.682563]  cifs_put_tcon.part.0+0x99/0x202 [cifs]
> > [  301.682637]  ? ida_free+0x99/0x10a
> > [  301.682727]  ? cifs_umount+0x3d/0x9d [cifs]
> > [  301.682829]  cifs_put_tlink+0x3a/0x50 [cifs]
> > [  301.682929]  cifs_umount+0x44/0x9d [cifs]
> >
> > Fixes: 72e73c78c446 ("cifs: close the shared root handle on tree discon=
nect")
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
> >
> > --
> > Thanks,
> >
> > Steve
>
> Looking at this more, I think that the fact that the handle is valid
> doesn't mean that it has a directory lease. So, I think we need to
> track that fact separately. I coded a quick follow-on fix (untested)
> to describe my idea - see the attached patch.
>
> Thoughts?
>
> --
> Best regards,
> Pavel Shilovsky
