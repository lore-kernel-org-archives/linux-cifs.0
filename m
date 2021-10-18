Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32923C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Oct 2021 23:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 150AC60F02
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Oct 2021 23:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhJRXT0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Oct 2021 19:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233389AbhJRXTZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 18 Oct 2021 19:19:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75CB960FDA
        for <linux-cifs@vger.kernel.org>; Mon, 18 Oct 2021 23:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634599033;
        bh=sWy5//HNUU5vcNIBFwqRm/VmjF7cq5qpRuIuVTuSIgE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Bn6mj5SV9GhuEVDzBklG1XXoMTZLFdk9/e99VtnQLt1ulGTngkYajro6YmXAaZaME
         Znrn0b4SdsWS9XWzturHa3Z2fcPJrBqWbBxK/+wMZPATb6FRP8ROH2URMnjYXsSO4i
         nezaP4fodlQddjUfFP9kfue2n4vO5dek6YAinnOF91XryT9af5OPwp1DZSeXNvEiQG
         Ik0b7cp6Lw1d0r/fCKjhqgSrTsFux9A2xlx6hSJGWHoothEAl7/EBDRcbwSXumDME9
         Px0pV2hxhGLCkymvozQVSALzWqkFYRK0J++bw7OQpG/pDpo/tpnPnPKpUL3uQBa+Z+
         yqojFlVAEbILA==
Received: by mail-oi1-f172.google.com with SMTP id m67so2048862oif.6
        for <linux-cifs@vger.kernel.org>; Mon, 18 Oct 2021 16:17:13 -0700 (PDT)
X-Gm-Message-State: AOAM530Og1ru2spZeKVNVoRm95ZEL0KtthR7AAsBiameet89GZ1qzN+V
        X0EfzFQ4KAVamSciw+xos38hA5Z7eJM6W9iADkw=
X-Google-Smtp-Source: ABdhPJwQ/g373GtCcjmIC4KhK2lW4grZreSELdB3QU+3t6BaNr36SQLe24wszZXdrNe/Uqw1YUdX0Y4YU+aXOIn0G90=
X-Received: by 2002:a05:6808:6c2:: with SMTP id m2mr1513034oih.8.1634599032791;
 Mon, 18 Oct 2021 16:17:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Mon, 18 Oct 2021 16:17:12
 -0700 (PDT)
In-Reply-To: <CAF6XXKWCn2bSV4o=r0q7gO3H029y-jLZ4CReHABEEOwk6S4T_g@mail.gmail.com>
References: <20211016235715.3469969-1-mmakassikis@freebox.fr>
 <CAKYAXd9iC6+S+rrp=DGyR6f7qxOQm7i-nqmHK=m2qM8t3UbJdQ@mail.gmail.com> <CAF6XXKWCn2bSV4o=r0q7gO3H029y-jLZ4CReHABEEOwk6S4T_g@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 19 Oct 2021 08:17:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9tAmRBMLEwpb6RCOEchL58JNgUWABEv5KAsZ+uAoFWDg@mail.gmail.com>
Message-ID: <CAKYAXd9tAmRBMLEwpb6RCOEchL58JNgUWABEv5KAsZ+uAoFWDg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: add buffer validation in session setup
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-18 23:49 GMT+09:00, Marios Makassikis <mmakassikis@freebox.fr>:
> On Mon, Oct 18, 2021 at 4:04 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> Hi Marios,
>> > +     negblob_off = le16_to_cpu(req->SecurityBufferOffset);
>> > +     negblob_len = le16_to_cpu(req->SecurityBufferLength);
>> > +     if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) -
>> > 4))
>> > +             return -EINVAL;
>> Like the following code, negblob is still used without buffer check.
>> We need to add buffer check for it here ?
>>
>> if (negblob->MessageType == NtLmNegotiate) {
>>
>> } else if (negblob->MessageType == NtLmAuthenticate) {
>>
>> Thanks!
>>
> Hello Namjae,
>
> I'm not sure I understand what you mean. Should I change the check to
> something like this ?
>
> +       negblob_off = le16_to_cpu(req->SecurityBufferOffset);
> +       negblob_len = le16_to_cpu(req->SecurityBufferLength);
> +       if (negblob_off < (offsetof(struct smb2_sess_setup_req, Buffer) - 4)
> ||
> +           negblob_len < sizeof(struct negotiate_message))
negblob_len < offsetof(struct negotiate_message, NegotiateFlags))

Thanks!

>
> Marios
>
>> > +
>> >       negblob = (struct negotiate_message *)((char
>> > *)&req->hdr.ProtocolId +
>> > -                     le16_to_cpu(req->SecurityBufferOffset));
>> > +                     negblob_off);
>> >
>> > -     if (decode_negotiation_token(work, negblob) == 0) {
>> > +     if (decode_negotiation_token(conn, negblob, negblob_len) == 0) {
>> >               if (conn->mechToken)
>> >                       negblob = (struct negotiate_message
>> > *)conn->mechToken;
>> >       }
>> > @@ -1736,7 +1746,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
>> >                       sess->Preauth_HashValue = NULL;
>> >               } else if (conn->preferred_auth_mech ==
>> > KSMBD_AUTH_NTLMSSP) {
>> >                       if (negblob->MessageType == NtLmNegotiate) {
>> > -                             rc = ntlm_negotiate(work, negblob);
>> > +                             rc = ntlm_negotiate(work, negblob,
>> > negblob_len);
>> >                               if (rc)
>> >                                       goto out_err;
>> >                               rsp->hdr.Status =
>> > --
>> > 2.25.1
>> >
>> >
>
