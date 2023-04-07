Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E19EC76196
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Apr 2023 04:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjDGEnh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Apr 2023 00:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDGEnh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Apr 2023 00:43:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAD5901C
        for <linux-cifs@vger.kernel.org>; Thu,  6 Apr 2023 21:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680842568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HU1C8wNfOyLlseqg9Ercx0RKfENBpbx1shty+u3RDnA=;
        b=PMN5LMeuDI8IxPEfLQ0rguZ5AboCXTPQH21at+5tYQq34qE3GI+ZKbp4zLCD5P8kk9Q14Q
        +5/SGSRoY/R3FGy3aPSOqVgkdDciPqiP+Hlqlt0ACLDe4OMiL11RxHhIIZB3NSA702TDHU
        9jzS/usGS6kXqe95HjxK6h24wKEcEY4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-wF22yuJaP6mYkU7sX2MEsQ-1; Fri, 07 Apr 2023 00:42:47 -0400
X-MC-Unique: wF22yuJaP6mYkU7sX2MEsQ-1
Received: by mail-qt1-f200.google.com with SMTP id b11-20020ac87fcb000000b003e37d72d532so28086105qtk.18
        for <linux-cifs@vger.kernel.org>; Thu, 06 Apr 2023 21:42:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680842567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HU1C8wNfOyLlseqg9Ercx0RKfENBpbx1shty+u3RDnA=;
        b=G/8LQQGF8z6SRoOqoyRGReIYpkYNrdjXxM1pbIu7sqC0s0kgnuc1ZjzVGrEePsyBqM
         IE62waB3tit1WfUWtHy9/K0CGXCN7XJIoD8saXbxPXLNUqPEAQfzwMzM/B6QHTkp2cvd
         1js0rGnPnO2lqWoBEAMlJJqPWa5U/0YeMhakE74ljv9tJGgHP9+XXcFvNwGiHAvnqXLo
         r4+lkPs4qMpEcN+QsRmMTt2ewPs1xJ3Fav5K1VqAJ9wwvZ0YNcFa1JevTxiq5aGAFMnS
         K9eu/ECf8/39Bt/6LUhs+yJgGiYk4X3DsqZ+asVef6qHx0Q2uacv9tcFG/rApXk/if2R
         Cj8A==
X-Gm-Message-State: AAQBX9fB2ikmZ+d9d/9JsrwT3VJAN3qKPqfDAKo/AiM5SeLtnTQrh7Lg
        0oTV4qINfzaEH4q0BbT3nUWfSuZewTRCzHtxEFZ8xXgj7dGa4ipJxkqwJBPq8l1bn4VgzcArr3y
        xuL52Mm/rXVlnubcr1hNJzMaUEYRxEmjt3C4NuA==
X-Received: by 2002:a05:622a:1998:b0:3e4:db08:ae9c with SMTP id u24-20020a05622a199800b003e4db08ae9cmr426146qtc.8.1680842567198;
        Thu, 06 Apr 2023 21:42:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350ankIXccwHSS7R2poWhJs+f8s8hKlMf1u7ZdDGyoLEhYJAtyurYPuVfIrF0oWPrSkMzrRIOj2JNJsOUre3hv6I=
X-Received: by 2002:a05:622a:1998:b0:3e4:db08:ae9c with SMTP id
 u24-20020a05622a199800b003e4db08ae9cmr426142qtc.8.1680842566969; Thu, 06 Apr
 2023 21:42:46 -0700 (PDT)
MIME-Version: 1.0
References: <6cf163fe-a974-68ab-0edc-11ebc54314ef@redhat.com> <CAH2r5msJtiGDuQcQdUkpamChTYNobUEVCax5GmHwpV0NbZOR0Q@mail.gmail.com>
In-Reply-To: <CAH2r5msJtiGDuQcQdUkpamChTYNobUEVCax5GmHwpV0NbZOR0Q@mail.gmail.com>
From:   Takayuki Nagata <tnagata@redhat.com>
Date:   Fri, 7 Apr 2023 13:42:35 +0900
Message-ID: <CANFaLqEG6=vyb+DB2KX9DPfgqGJd2wTfEBCS4+gs++67A5LB4Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: reinstate original behavior again for forceuid/forcegid
To:     Steve French <smfrench@gmail.com>
Cc:     sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thank you for reviewing my patch.
I have no thoughts on the priority. So If it does not bother you to
send the v2 patch, I will resend the v2 patch soon with a revised
commit message to clarify "what breaks".

Takayuki Nagata

2023=E5=B9=B44=E6=9C=887=E6=97=A5(=E9=87=91) 13:13 Steve French <smfrench@g=
mail.com>:
>
> Tentatively merged into cifs-2.6.git for-next
>
> Any thoughts on priority sending it upstream soon?
>
> On Thu, Apr 6, 2023 at 7:06=E2=80=AFAM Takayuki Nagata <tnagata@redhat.co=
m> wrote:
> >
> > forceuid/forcegid should be enabled by default when uid=3D/gid=3D optio=
ns are
> > specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
> > changed the behavior. This patch reinstates original behavior to overri=
ding
> > uid/gid with specified uid/gid.
> >
> > Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> > Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
> > ---
> >  fs/cifs/fs_context.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index ace11a1a7c8a..6f7c5ca3764f 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -972,6 +972,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
> >                         goto cifs_parse_mount_err;
> >                 ctx->linux_uid =3D uid;
> >                 ctx->uid_specified =3D true;
> > +               ctx->override_uid =3D 1;
> >                 break;
> >         case Opt_cruid:
> >                 uid =3D make_kuid(current_user_ns(), result.uint_32);
> > @@ -1000,6 +1001,7 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
> >                         goto cifs_parse_mount_err;
> >                 ctx->linux_gid =3D gid;
> >                 ctx->gid_specified =3D true;
> > +               ctx->override_gid =3D 1;
> >                 break;
> >         case Opt_port:
> >                 ctx->port =3D result.uint_32;
> > --
> > 2.40.0
> >
>
>
> --
> Thanks,
>
> Steve
>

