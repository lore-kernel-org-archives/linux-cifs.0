Return-Path: <SRS0=LGzZ=YH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CB2ECE587
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 09:08:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C31D207FF
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 09:08:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="du4IUe77"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbfJNJIx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Oct 2019 05:08:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44125 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730691AbfJNJIw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Oct 2019 05:08:52 -0400
Received: by mail-io1-f65.google.com with SMTP id w12so36263497iol.11
        for <linux-cifs@vger.kernel.org>; Mon, 14 Oct 2019 02:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Ur1eTKoVO3wN+x03kXh8I2XsPr+iXVsLGNEziY9nGs=;
        b=du4IUe77YWpxVazpPUJ2kXDDjHDwWMN3AC8cd6KsXQMboK71TPwtXps6Og1P/Ac6EM
         4zo56tNmcbMFIcAQdP3ztqwP2wypoGjHsUQ1YAK4IRLe1rkKVUixgGw47b+pHqI5Siqz
         A0icudIGBbg1wB2F2UmI0FAnbKoUXQG2FK2ZQWKlKaFWhyMPKrefXGHShb1Jvg3HoygQ
         DVa7SWWiKD6FteO815c1Ue2iB+2Has6FSba8AvV1C5pxGKkxyH5GEREdlYN9eKL/F4Yb
         g8MMUn8JMX+sLUCxlCbVNd4c372gkwha1TD4mf/sakI2xhe//SpVjVDnrenVpSYrF4w2
         /hxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Ur1eTKoVO3wN+x03kXh8I2XsPr+iXVsLGNEziY9nGs=;
        b=Ncw8rfH7T48P65hHGztOoWPT+3v9bp89tOnS7LNK5RE3K54zW2OVKoxBXZ+wSokBTf
         6G2nl8TSmCrnp7NBLn6NbmZHmva8TXSnQIlaa2A4Okzd5vLAMyZmsLEqqU+m/obUwCC3
         o4bZnz/8avKXFnOawf4/E88mtPd+CNy2gztz+sKWIKQLFGSeL1k+wfEEo95GI6xKzyOU
         O4qhNb1teFDDQPAvDFsvUd3JodrLjexR2ZrJhfQ+RRKR2LUgdLxF+bp1+PEILVM6QaNp
         1Nvl6y6hRCMpXpMZ+gVFUVEU5efpJdOGeoY4kwjJzhX8kjd1K/hCMMCttoQUG+733Mio
         XwAQ==
X-Gm-Message-State: APjAAAXN0TsDVYMzUb/0/RKUs27hg6NYtF0Kkt/1CYv+ZoBQsbXhhzxt
        lj8XKiXnBoy12mtCchmcbp3CvmsutHOMk0QGFBQ=
X-Google-Smtp-Source: APXvYqzXREaLwpMF7/RnkNEs9C+aIl41nWeXpL63hROXqh+5vvu3fN0r80aSjI8rnVfv4MfxKTDtw0u0l84ACZVVQqA=
X-Received: by 2002:a5d:8f8e:: with SMTP id l14mr17532875iol.3.1571044132091;
 Mon, 14 Oct 2019 02:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191014085923.14967-1-rbergant@redhat.com>
In-Reply-To: <20191014085923.14967-1-rbergant@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Mon, 14 Oct 2019 19:08:43 +1000
Message-ID: <CAN05THQTb=aechQB5rqUxZLpfwocqfLPMVW5mAz4F5dn3ryj0w@mail.gmail.com>
Subject: Re: [PATCH] CIFS: avoid using MID 0xFFFF
To:     Roberto Bergantinos Corpas <rbergant@redhat.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 14, 2019 at 7:01 PM Roberto Bergantinos Corpas
<rbergant@redhat.com> wrote:
>
> According to MS-CIFS specification MID 0xFFFF should not be used by the
> CIFS client, but we actually do. Besides, this has proven to cause races
> leading to oops between SendReceive2/cifs_demultiplex_thread. On SMB1,
> MID is a 2 byte value easy to reach in CurrentMid which may conflict with
> an oplock break notification request coming from server
>
> Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> ---
>  fs/cifs/smb1ops.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index c4e75afa3258..c8d96230cbd2 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -183,6 +183,9 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
>         /* we do not want to loop forever */
>         last_mid = cur_mid;
>         cur_mid++;
> +       /* avoid 0xFFFF MID */
> +       if (cur_mid == 0xffff)
> +               cur_mid++;
>
>         /*
>          * This nested loop looks more expensive than it is.
> --

Reviewed-by: lsahlber@redhat.com>


Steve, can we get this pushed to linus soonish?  It is a bad issue.
