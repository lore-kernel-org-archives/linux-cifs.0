Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4CFC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 05:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4931C6112F
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 05:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhIUFx6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 01:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229745AbhIUFx6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Sep 2021 01:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 242D161166
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 05:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632203550;
        bh=Rrd2R2p6w684SsWgqESzrYwqsVkKT0sVv5DgbNIkFME=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=M37tl51M0Cqu8bPaB+j54IM7H1CXgH5rhr5BFlA9CVoQgdI9+I1zB8rRVvZ572qxY
         w1DMgNbw2lrngQ27isbOa+b0rN/41HmSkRMv94yeFBrKgMq1Iohsj8qG60Z60FewcM
         ogucNv3KsySaMXBB7fDlnoIcbnxrIofwKot/9loRV+IorjqgqMYhjgUmD7uwBY5il6
         QaL7LTvy3rXzdqXTg+Csqa7fM78+HWgg7/PfqALAE/0xTxD6WvBOAAC/sXqP5D21gD
         Iy5gJUz+785SDbSk8qmP94AfO/CUQ6GOb0QtfNBpoZ6scwMPZSxLDDIYbEcglLFm7t
         K1k6m+R57u0ew==
Received: by mail-oi1-f172.google.com with SMTP id u22so19951859oie.5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 22:52:30 -0700 (PDT)
X-Gm-Message-State: AOAM531x+TonlX700ECZpfXwA1p2eQ6SuUJvtN2alQjCPAYQTpKkXPT4
        YCmJcX6mEhQu4lAwk6SWtq/DzA1/+lVnuGd7lzQ=
X-Google-Smtp-Source: ABdhPJxqZ2VO9YLxC62Xo96/kD2BBwTRYzFHwPvEraXQxWczqOw/jMyfnkb2KWhBTiX3gYucgqVH/m98LFrMiu+x1q4=
X-Received: by 2002:a54:4f03:: with SMTP id e3mr2291977oiy.32.1632203549535;
 Mon, 20 Sep 2021 22:52:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Mon, 20 Sep 2021 22:52:28
 -0700 (PDT)
In-Reply-To: <CAGvGhF6Vf7vmd2vRC6Vv22ZNoxbhX4ym3_NjjiOncvx=ay9X8w@mail.gmail.com>
References: <CAGvGhF6Vf7vmd2vRC6Vv22ZNoxbhX4ym3_NjjiOncvx=ay9X8w@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 21 Sep 2021 14:52:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8h86Fa2JCKdqjKktk5oonarOemm1=Z9+VeA7_PDpoyLA@mail.gmail.com>
Message-ID: <CAKYAXd8h86Fa2JCKdqjKktk5oonarOemm1=Z9+VeA7_PDpoyLA@mail.gmail.com>
Subject: Re: ksmbd: missing validation of hdr->next_offset
To:     Leif Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-21 14:02 GMT+09:00, Leif Sahlberg <lsahlber@redhat.com>:
> List, Namjae,
Hi Ronnie,
>
> I have been looking at next_offset and we need some additional
> validation of when we
> walk to the next pdu without validating we have enough buffer.
>
> I think the problem is down in is_chained_smb2_message()/
> init_chained_smb2_rsp()
> where it advances work->next_smb2_rcv_hdr_off without checking that
> the new offset is valid and contains a smb2 header and payload.
>
>
> A simple reproducer is libsmb2.
> Apply this patch to break "next_offset"  for compounds in libsmb2 :
> diff --git a/lib/pdu.c b/lib/pdu.c
> index 1329388..4eab8d7 100644
> --- a/lib/pdu.c
> +++ b/lib/pdu.c
> @@ -174,6 +174,7 @@ smb2_add_compound_pdu(struct smb2_context *smb2,
>          }
>
>          pdu->header.next_command = offset;
> +        pdu->header.next_command = 0x0f0ff0f0;
>          smb2_set_uint32(&pdu->out.iov[0], 20, pdu->header.next_command);
>
>          /* Fixup flags */
>
> And then just run this command which uses compounds:
> ./examples/smb2-stat-sync smb://192.168.124.221/Share/
> it should oops right away.
>
>
> I don't know where the best place to check for this is,  either in
> init_chained_smb2_rsp()
> but it was a little hard to track it down.
> A different place to check this might be from
> ksmbd_conn_handler_loop()
> and just walk the headers and check next_offset header by header
> before even trying to process any of the pdus.
Really thanks for your review! I will fix it now.

Thanks again!
>
>
> regards
> ronnie shalberg
>
>
