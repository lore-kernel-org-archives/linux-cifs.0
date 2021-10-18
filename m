Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51526C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Oct 2021 14:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365DF61027
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Oct 2021 14:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJROwM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhJROwM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Oct 2021 10:52:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5DCC06161C
        for <linux-cifs@vger.kernel.org>; Mon, 18 Oct 2021 07:50:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w19so141179edd.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Oct 2021 07:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k29vt56k2ci+3s/qqii1b1xIRVFdLYd+DrZZxGInwls=;
        b=KEA3szNBJJI5SCY5yT9/XFrufd7/IM1sYkZL1+jFWCuRhqgBtp91DDr5nCczSBXsgv
         SF8mpBM9NFHv4v8n07k5VMnt6BRrJHtGqRWpvetbWeR7K/AKVKOs9MXTypEWqZGZCpAg
         WhAy1rBMpDduY5AF4QOPMc0TmYfCS2i05PW4eUqYX6KL8MHpw2nHlUZrV+4uLG7QQIAj
         x7GwkT+bI0IpLXh6EObgv1/P3d9pfZTq6bft9AVEKuIDPnZigBe3ub0ujxJ5tQBEReet
         1RP79EBJgX7HuyuxI6U+XY2Mba8HEBRZbfgR5CDFMUNNkJGiefGhP4VgdP1QwpW6peoH
         4NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k29vt56k2ci+3s/qqii1b1xIRVFdLYd+DrZZxGInwls=;
        b=BLWw6BKdU48RIKKhiHjqCkgjn++zLbvvjeZ+wjKAraUq6E5Zu58QZRMemzaTRv0kOk
         fAAoOH6U1WwVqyDPuDYM9uPqKdkX5R1H2saixF8OlukdNSbhfJigo6fi8BqMKc1KUc/5
         KqebjUA33L3yIy8OPwcB97VzdualnZlNrJUaQ3cb9btAxouGSPu0vQWBOHAp9HMxx9ar
         GD18PvDJLKQu98skk5y7Z0kRo46tpZfnHsgk9xVUVXTVnMuMdC1Mz8y3KEOyCZHFh1BF
         mFuFgWJzJCjbFy3Y83jnJwoerLz6RPbrLQEMJT4o1Ywr/jOXxjgKHdfKDuTQ6jBoGtYJ
         YSWA==
X-Gm-Message-State: AOAM530EZyxBdTU7IgUzqQbwDWEHQAsUGbt3F30O7F/lPsGKDhMjHFIa
        sfh2xj8BCPqbyNVDRtad1FJPu0Wbdxefn4m0jCufURlhqAqrDA==
X-Google-Smtp-Source: ABdhPJxayyRPhMjdtfPpy8UMtQC9MBmSrvWuIqMSOHBdprZ/A4ug2EC+NRvpS76QbRwbl1p8qNdwlPciYHFGZJjrVkI=
X-Received: by 2002:a17:906:1707:: with SMTP id c7mr29371313eje.377.1634568593429;
 Mon, 18 Oct 2021 07:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211016235715.3469969-1-mmakassikis@freebox.fr> <CAKYAXd9iC6+S+rrp=DGyR6f7qxOQm7i-nqmHK=m2qM8t3UbJdQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9iC6+S+rrp=DGyR6f7qxOQm7i-nqmHK=m2qM8t3UbJdQ@mail.gmail.com>
From:   Marios Makassikis <mmakassikis@freebox.fr>
Date:   Mon, 18 Oct 2021 16:49:42 +0200
Message-ID: <CAF6XXKWCn2bSV4o=r0q7gO3H029y-jLZ4CReHABEEOwk6S4T_g@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: add buffer validation in session setup
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 18, 2021 at 4:04 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> Hi Marios,
> > +     negblob_off = le16_to_cpu(req->SecurityBufferOffset);
> > +     negblob_len = le16_to_cpu(req->SecurityBufferLength);
> > +     if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4))
> > +             return -EINVAL;
> Like the following code, negblob is still used without buffer check.
> We need to add buffer check for it here ?
>
> if (negblob->MessageType == NtLmNegotiate) {
>
> } else if (negblob->MessageType == NtLmAuthenticate) {
>
> Thanks!
>
Hello Namjae,

I'm not sure I understand what you mean. Should I change the check to
something like this ?

+       negblob_off = le16_to_cpu(req->SecurityBufferOffset);
+       negblob_len = le16_to_cpu(req->SecurityBufferLength);
+       if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4) ||
+           negblob_len < sizeof(struct negotiate_message))

Marios

> > +
> >       negblob = (struct negotiate_message *)((char *)&req->hdr.ProtocolId +
> > -                     le16_to_cpu(req->SecurityBufferOffset));
> > +                     negblob_off);
> >
> > -     if (decode_negotiation_token(work, negblob) == 0) {
> > +     if (decode_negotiation_token(conn, negblob, negblob_len) == 0) {
> >               if (conn->mechToken)
> >                       negblob = (struct negotiate_message *)conn->mechToken;
> >       }
> > @@ -1736,7 +1746,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
> >                       sess->Preauth_HashValue = NULL;
> >               } else if (conn->preferred_auth_mech == KSMBD_AUTH_NTLMSSP) {
> >                       if (negblob->MessageType == NtLmNegotiate) {
> > -                             rc = ntlm_negotiate(work, negblob);
> > +                             rc = ntlm_negotiate(work, negblob, negblob_len);
> >                               if (rc)
> >                                       goto out_err;
> >                               rsp->hdr.Status =
> > --
> > 2.25.1
> >
> >
