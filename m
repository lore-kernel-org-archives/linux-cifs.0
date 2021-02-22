Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FEFC433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8AC264E21
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhBVRXE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Feb 2021 12:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhBVRW7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Feb 2021 12:22:59 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330FFC06178C
        for <linux-cifs@vger.kernel.org>; Mon, 22 Feb 2021 09:21:45 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id jt13so30741021ejb.0
        for <linux-cifs@vger.kernel.org>; Mon, 22 Feb 2021 09:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PigckDjQwgmQbZmix+5/T70AhA8Boqhp2e7BzFOANQI=;
        b=a1lUrxZ2iuMyTkWd6lo7QBMsKaV+geZefLYqHk7o/Y79gMmceI+eMuC2CHirsA1ZM6
         iNG1j/QmKRwPErxnHFMs+keWpyj1divRuf20YP7fiehgZl3Y5D77AlqMlGyPcHLxsJm7
         GgCKsn2Nzw0Qr8rDvvPYHLoAPHeImldMO+mHad6gQdEZizG1InQuFOYl3lcO/JbUerdB
         ywzLgqKIEPDRlrqv6rjxEO50MoEvSeoADtYfkhfJHEKqpSM5tElnBnG6MGIIWkGPfqlV
         UMRuLZaFrsO0owC+mOu1HG1K+Pvc5ChhksGwfn4lXLM7k2LxiX3qIWoPoLFDPE2zh7Uh
         03BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PigckDjQwgmQbZmix+5/T70AhA8Boqhp2e7BzFOANQI=;
        b=SMQOTrU8Sk6zVVGVUn90CdNEe/zN/qB11NKh1fGc4C02mQaHRrsP3AHA3D00Q4EOEx
         8nugVmLk1NPjyDksNnNnRvMoATyWm7Ur4qDjtQTVWLgaTcnTQ6WNxLYJ0TR6Pr9DRHOl
         Ty863PZ2ZGHn7s2hZBiaQJDyKHrluoG4fe+ssttxc+PIhaXwCDY0jvg2j1evy4vacB6B
         5yfoJhCRKjGUCli3V+O/MJpz6Fa3QpXFr7yhcFUogSZ4v2qtnZps3Xp10bGcwwuQ0GfF
         QwqgvgV5lvQHmILALsHzocVjwF0UKTXZicgTBr0mkV4XWaeSPAnOJm9oCPNT+6EvzTKU
         jJ6A==
X-Gm-Message-State: AOAM530QKoRmv/TUFm4maeb3QRsFU3sjInDcd+6HYaH/89GNOP52bQem
        2ZLDWdb7mjQfc1Y2NEMCGCHQRqjmkH7AnXEoSlbCxNrG1w==
X-Google-Smtp-Source: ABdhPJzhK10dq/vxlduXgK6TgRCLsElCuNtvI2DJB7nGulkY+EFD0pNGiAc7tS6yf8v59SyOWhldK2zGqjIQn3tFt7c=
X-Received: by 2002:a17:907:373:: with SMTP id rs19mr9216212ejb.341.1614014503969;
 Mon, 22 Feb 2021 09:21:43 -0800 (PST)
MIME-Version: 1.0
References: <1A318EB9-A257-4A11-B319-EA3F2628C8B7@hxcore.ol>
 <CAKywueROT6yAn6Eer4sncxsaZZyih3kApKmLacb3xsxDJfWfMQ@mail.gmail.com>
 <80BC289A-88D1-45CB-A751-0382211ED4B8@hxcore.ol> <CAKywueRuwHXG65i6XQknXgqtQ+=AdrLCCqft+vwE5XFLWwo=Gw@mail.gmail.com>
 <CAH2r5mv-QHyhdCTyB=uXsyQkMm1fi5vOn6dF=H3quwPg9ek=VA@mail.gmail.com>
 <CAH2r5muFUkL3Bexv-VxK_WKSKXvGq9Bs5CZU0CA0t_SufpkguA@mail.gmail.com> <F0563410-2F65-4259-8298-B0669CDD1C8B@hxcore.ol>
In-Reply-To: <F0563410-2F65-4259-8298-B0669CDD1C8B@hxcore.ol>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 22 Feb 2021 09:21:32 -0800
Message-ID: <CAKywueQgF1LaYW17NS_e71TdSyVffTPUy5JgsQOF+Frkj1TDKA@mail.gmail.com>
Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
To:     Rohith <rohiths.msft@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "sribhat.msa@outlook.com" <sribhat.msa@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Both patches look good. Thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 21 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 22:44, Rohit=
h <rohiths.msft@gmail.com>:
>
> Thanks Steve. Will make sure to run checkpatch for further patches.
>
>
>
> Regards,
>
> Rohith
>
>
>
> Sent from Mail for Windows 10
>
>
>
> From: Steve French
> Sent: Sunday, February 21, 2021 6:26 AM
> To: Pavel Shilovsky
> Cc: Rohith; linux-cifs@vger.kernel.org; Shyam Prasad N; sribhat.msa@outlo=
ok.com
> Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
>
>
>
> The remaining suggestion of Pavel's is included in this trivial cleanup.
>
>
>
> Trivial change to clarify code in smb2_is_network_name_deleted
>
> Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/smb2ops.c | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index aee9da88a333..b2191babce26 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2459,23 +2459,24 @@ smb2_is_network_name_deleted(char *buf, struct TC=
P_Server_Info *server)
>   struct cifs_ses *ses;
>   struct cifs_tcon *tcon;
>
> - if (shdr->Status =3D=3D STATUS_NETWORK_NAME_DELETED) {
> - spin_lock(&cifs_tcp_ses_lock);
> - list_for_each(tmp, &server->smb_ses_list) {
> - ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
> - list_for_each(tmp1, &ses->tcon_list) {
> - tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_list);
> - if (tcon->tid =3D=3D shdr->TreeId) {
> - tcon->need_reconnect =3D true;
> - spin_unlock(&cifs_tcp_ses_lock);
> - pr_warn_once("Server share %s deleted.\n",
> -     tcon->treeName);
> - return;
> - }
> + if (shdr->Status !=3D STATUS_NETWORK_NAME_DELETED)
> + return;
> +
> + spin_lock(&cifs_tcp_ses_lock);
> + list_for_each(tmp, &server->smb_ses_list) {
> + ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
> + list_for_each(tmp1, &ses->tcon_list) {
> + tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_list);
> + if (tcon->tid =3D=3D shdr->TreeId) {
> + tcon->need_reconnect =3D true;
> + spin_unlock(&cifs_tcp_ses_lock);
> + pr_warn_once("Server share %s deleted.\n",
> +     tcon->treeName);
> + return;
>   }
>   }
> - spin_unlock(&cifs_tcp_ses_lock);
>   }
> + spin_unlock(&cifs_tcp_ses_lock);
>  }
>
>  static int
>
>
>
> On Sat, Feb 20, 2021 at 5:38 PM Steve French <smfrench@gmail.com> wrote:
>
> I corrected various checkpatch errors - including two of those Pavel note=
d, and tentatively merged into cifs-2.6.git for-next.  See attached updated=
 patch.
>
>
>
> Will fix the indentation next.
>
>
>
> On Sat, Feb 20, 2021 at 12:18 PM Pavel Shilovsky <piastryyy@gmail.com> wr=
ote:
>
> =D1=87=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 08:10, Roh=
ith <rohiths.msft@gmail.com>:
> >
> > Hi Pavel,
> >
> >
> >
> > Addressed review comments. Can you please take a look.
> >
> >
> >
> > >> Btw, I think is_status_io timeout should be called in this loop for
> >
> > >> every mid not outside the loop (sorry, missed that in the original
> >
> > >> review). Could you please fix that separately?
> >
> >
> >
> > Yes, will send out different patch for status_io_timeout.
>
> Thanks!
>
> The patch looks good. Please find my minor comments below:
>
> 1.
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 10fe6d6d2dee..b2f51546c2ef 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -993,6 +993,10 @@ cifs_demultiplex_thread(void *p)
>   if (mids[i] !=3D NULL) {
>   mids[i]->resp_buf_size =3D server->pdu_size;
>
> + if (server->ops->is_network_name_deleted) {
> +         server->ops->is_network_name_deleted(bufs[i],
> +                              server);
> + }
>
> ^^^
> remove extra {}
>
> 2.
> +static void
> +smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
> +{
> + struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)buf;
>
> + struct list_head *tmp, *tmp1;
> + struct cifs_ses *ses;
> + struct cifs_tcon *tcon;
> +
> + if (shdr->Status =3D=3D STATUS_NETWORK_NAME_DELETED) {
>
> ^^^
> let's do the opposite check: if status is not
> STATUS_NETWORK_NAME_DELETED then return immediately from the function.
> This will remove overall indentation for the nested for loops.
>
> 3.
> @@ -4605,6 +4632,10 @@ static void smb2_decrypt_offload(struct
> work_struct *work)
>  #ifdef CONFIG_CIFS_STATS2
>   mid->when_received =3D jiffies;
>  #endif
> + if (dw->server->ops->is_network_name_deleted) {
> +         dw->server->ops->is_network_name_deleted(dw->buf,
> +                                  dw->server);
> + }
>
> ^^^
> remove extra {}
>
> --
> Best regards,
> Pavel Shilovsky
>
>
>
>
> --
>
> Thanks,
>
> Steve
>
>
>
>
> --
>
> Thanks,
>
> Steve
>
>
