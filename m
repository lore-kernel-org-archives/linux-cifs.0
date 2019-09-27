Return-Path: <SRS0=ovf2=XW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 835AAC4360C
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Sep 2019 06:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 572DC20872
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Sep 2019 06:50:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MH8ll6vG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbfI0Gue (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Sep 2019 02:50:34 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44148 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfI0Gue (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Sep 2019 02:50:34 -0400
Received: by mail-io1-f68.google.com with SMTP id j4so13446905iog.11
        for <linux-cifs@vger.kernel.org>; Thu, 26 Sep 2019 23:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDOP+d3pjeA2syqYP3No56/PA2kieKwao6mGpSFq65E=;
        b=MH8ll6vGgxWsoCPL/cgE7XYotw4WWKXOp7s1GoH5gfd0d1RWd95FRgOUcweUgVIihg
         PcUU/VHt4aC3nE5NRoOtettoX16rcltq57x+cdT+n7J2enKjg9bcdu7TzfpCWe3mmwg8
         IL1BKKQpgJ0N6zp5aRIyxid9ihH8UEU9ya7Z6/m3hS6bauQgJ0g3t5wz01kHouelIvgW
         nWbmLXWfMNVsSF6MpZnKhG+sNLr4mO8VqYZiwcA2xShp2sW/Mq8nWgXzDuxgNqSF2ImW
         R4qy1vaZ2wG4/yfIGRyz+4WFSGgVH0IYIvioVSzArBBh9iAvBTSms+OEJx8KPds4fkJf
         U+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDOP+d3pjeA2syqYP3No56/PA2kieKwao6mGpSFq65E=;
        b=tCJ07NgyxmHHEQ+RyQL/ikVnhK/QdizzWwBA5oSRnMYfvgcidpbRs3HxEnSGY10UGg
         Z2ieuiZ0QDmR+NKGP3jCZdFVMk5+PN8XTf2zF7/T7+PzHPXCRkGstCnfIiwWbiK/mQMt
         phkZGqi2O1NS6RrOtK8PQx4KhJoZCk4gLQUIUH7XXFVV848sSoi51s66TkCmdLxjbAAw
         xAcWhTwOzK99Ccw4xkcULdZY5JNsr+mY15P3uWUzU5gowIvYmOe+T1U1CQkFHOcw/euD
         XYP7YeJiWR6W/O8N7rP6XbzECEAUT2P9OKZ99FuUTFPhOmPUopmIM9iesfcDpmOlQPQO
         85Bw==
X-Gm-Message-State: APjAAAV2KVeaEY1SoHS5TBEcW6VMZqbvmbBgyjsfHcLKjmJtFnzc6dJI
        DNbBvnIVtdliKWMpA6UGGT4AMxUkmB5DMgD3dks=
X-Google-Smtp-Source: APXvYqw/JXOElsnUZoCxeJ0e5TgLymQaqRDBdK9B/oazCQrJCA28euezh+c7AtW3lYqn9HnN8eC4EzGxlg/w082WyXY=
X-Received: by 2002:a6b:5f11:: with SMTP id t17mr7153281iob.169.1569567033838;
 Thu, 26 Sep 2019 23:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mueOCtAsWjOc3n2OgnygSMmj22uycsvfNKPAiqhx68xsg@mail.gmail.com>
 <461a8f64-1f29-5b30-6b2d-4f4f88812323@samba.org>
In-Reply-To: <461a8f64-1f29-5b30-6b2d-4f4f88812323@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 27 Sep 2019 01:50:23 -0500
Message-ID: <CAH2r5mvC6qMyxmhB_fdXxnXCztefowpWcgqxUgK1m_GSFZOS-g@mail.gmail.com>
Subject: Re: Getting the SID of the user out of the PAC ...
To:     Stefan Metzmacher <metze@samba.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 27, 2019 at 1:44 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 27.09.19 um 08:39 schrieb Steve French via samba-technical:
> > Is there a way to get the SID of the user out of the MS-PAC through
> > Samba utils (or winbind)?
> >
> > This would help cifs if when we upcall as we do today to get the
> > kerberos ticket, we were also given the user's SID not just the ticket
> > to use to send to the server during session setup.
>
> Only if you get a service ticket for the joined client machine.
>
> But I don't understand what a possible use case would be.

When not mounting with "idsfromsid" this would allow us to use the
correct owner SID when creating ACLs (to include the owner and mode)
on mkdir and filecreate (the acl can be sent in the sd_context during
create)

-- 
Thanks,

Steve
