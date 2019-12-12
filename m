Return-Path: <SRS0=7r19=2C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB51C43603
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Dec 2019 23:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D8DE21556
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Dec 2019 23:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C9pvPtHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfLLXIu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 18:08:50 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:42322 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730859AbfLLXIu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 18:08:50 -0500
Received: by mail-il1-f196.google.com with SMTP id a6so441305ili.9
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 15:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VdUK52azywFqIMxPcGV5h2RwARC+4tQqSy1B37keJLQ=;
        b=C9pvPtHeiAh3bW7S5aha4XEx5JMIxvqNYyYx35ZAYhN7LbB9J3C7fvDOBC9BF0oh5p
         XFYDqc5ieBtrfFdk4LZGvC020lov2Ie21BQpOxBiHpfzG71hGzV9SiHkfyscZenEaPbk
         8pJ9oo0RAJWvXnP/r4AyQiS4ALcB5PO9UkPVI1cT+v4pm7nVaq9w22LgVFHIffcRRQqN
         KjHwS3bR9JOhPnt7SJgHLcD+RF8qJYIBL+yTGivemKFq2akLl+cRMaLTiq6qT0t2PJhA
         ZPE+jhaopRnunBPOmb+f2jeg1mIuCTb1uREbrKDaw4YqR9tOxQdsv/5WHivHdeAY+8nk
         MgOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VdUK52azywFqIMxPcGV5h2RwARC+4tQqSy1B37keJLQ=;
        b=ViUnuYMXPopBPrh3dxBg6RzNKzzj0YK4W2Fp8vDt107YP8IfyzLLQPlm1EtmzdlhBQ
         7rXcgS/CHKv5LqHplOM9cL+5nIrULAatcGLj5+u/ESXNGDBFfvqEjwMO8eSouLhy1XbH
         No7tfGaMoHNudl/1+MHZ9VHZrYrswKlzqHxm1JfPRRmGT++A2f9TdgMhi7SIMQt16JXj
         +Ep5hAeS/PzVf32iXFJy9PMFObzOY+JeU+tDutc77ybcSx5EtFI9wLRrhbKAtHbgVF7b
         k6XMI7lbVGZWVtgHC2CsBo8m4k9YiM+PDXOuKWkArJ+4HTRaEvg0M4EdMhL0HDywWiva
         10/A==
X-Gm-Message-State: APjAAAUuugJ1A9gOKd3lo/ABYNT5KN1YPtk+BmjzXG3B+wZZkaGbzTQ1
        qkokamRL8keL6Q9N/swjbgLV/W94ODdWn2QHUoCGWw==
X-Google-Smtp-Source: APXvYqx8RYTU9D8jCNqDrbtKWVTbgsSLDiN3BE+oLMUQT1lk9C5nQXDdq99AJmLuUH2OtH7uLVFPUpsZ2MBhLJxmw34=
X-Received: by 2002:a92:d2cd:: with SMTP id w13mr10768427ilg.173.1576192129856;
 Thu, 12 Dec 2019 15:08:49 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJSARbGJ4cOZoGy32mCtUTG9wyEyw8aF06zexshAmqfQ@mail.gmail.com>
 <CAKywueQSgGgPB+tQz28_VCe1LiyxpY7tU9tByypkTJALdHOOWg@mail.gmail.com> <CAN05THSZXrOvZtwYWgejMGKbxrGePNdFSPV5+hUkX8yHySee8Q@mail.gmail.com>
In-Reply-To: <CAN05THSZXrOvZtwYWgejMGKbxrGePNdFSPV5+hUkX8yHySee8Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 Dec 2019 17:08:39 -0600
Message-ID: <CAH2r5mvquYCfY0X5j9jxHxEv98RBAQsr3Cz828yQKcKDs2CKWg@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix refcount underflow warning on unmount when no
 directory leases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Thu, Dec 12, 2019 at 1:36 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> This makes sense. Thanks for this patch.
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Wed, Dec 11, 2019 at 5:53 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=BF=D0=BD, 9 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 20:48, Steve Fr=
ench <smfrench@gmail.com>:
> > >
> > > Fix refcount underflow warning when unmounting to servers which didn'=
t grant
> > > directory leases.
> > >
> > > [  301.680095] refcount_t: underflow; use-after-free.
> > > [  301.680192] WARNING: CPU: 1 PID: 3569 at lib/refcount.c:28
> > > refcount_warn_saturate+0xb4/0xf3
> > > ...
> > > [  301.682139] Call Trace:
> > > [  301.682240]  close_shroot+0x97/0xda [cifs]
> > > [  301.682351]  SMB2_tdis+0x7c/0x176 [cifs]
> > > [  301.682456]  ? _get_xid+0x58/0x91 [cifs]
> > > [  301.682563]  cifs_put_tcon.part.0+0x99/0x202 [cifs]
> > > [  301.682637]  ? ida_free+0x99/0x10a
> > > [  301.682727]  ? cifs_umount+0x3d/0x9d [cifs]
> > > [  301.682829]  cifs_put_tlink+0x3a/0x50 [cifs]
> > > [  301.682929]  cifs_umount+0x44/0x9d [cifs]
> > >
> > > Fixes: 72e73c78c446 ("cifs: close the shared root handle on tree disc=
onnect")
> > >
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> > > Reported-and-tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > Looking at this more, I think that the fact that the handle is valid
> > doesn't mean that it has a directory lease. So, I think we need to
> > track that fact separately. I coded a quick follow-on fix (untested)
> > to describe my idea - see the attached patch.
> >
> > Thoughts?
> >
> > --
> > Best regards,
> > Pavel Shilovsky



--=20
Thanks,

Steve
