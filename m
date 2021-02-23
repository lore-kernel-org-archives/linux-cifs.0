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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39570C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Feb 2021 10:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F1264E32
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Feb 2021 10:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhBWKVv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Feb 2021 05:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhBWKVt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Feb 2021 05:21:49 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5DAC061574
        for <linux-cifs@vger.kernel.org>; Tue, 23 Feb 2021 02:21:08 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id h26so10443177lfm.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Feb 2021 02:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ELoC5uUicNMAgjQeBLzg2s2w4JeIblrgn4QMY8Rq+YQ=;
        b=F0zNcf6bxsJmLJ1DNEawjV/uQPrNa55bj7vdx9mnqZZ82ZNEo0G2qhS7UsJSdFKqmN
         DV74VCeOkHOVsGE1nQFPGIMPzcaBMbPUESinmYH52sZI+zNX20g3+CODFoWkxxoX02Az
         s0ks+OyhI/LtwU9XK5y4gL9CGrZok7oboDbsXN5JeR6bhmaaWUwuqGtbBd/w9wcQ3Q0W
         Ik9EH4/ZIbKdaiZRZ7pS+YU7W/YQ3g4qtuYzcem+YXehnOLvTWTLcLxjUO5bDOzSFR1e
         E8FtXK8aXRVccDExTKuXetdSfzqNRbJaUfsc1yG6RLePTfg8HFuoSPnSAwBznIQj8gU4
         U+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ELoC5uUicNMAgjQeBLzg2s2w4JeIblrgn4QMY8Rq+YQ=;
        b=DYzXlj9R/DaOK/GOs2VU3kKtEUX2aOuSP1h905KlQCgi/+x3m1iSRsuVavyl/vxxYC
         cqWgJc9IbjRDInaugjGMsX9j/2TOjpNY/c7YYbFIKGdnZzPfrbglCMKWX5/IBqV+SVrg
         tEvoiIS9poI+Z5qOQ/Si7/kBJXkIiaoFiPtQoZP2LIDsnuS+HUoWnRmrKJ78qMLSK9F5
         H9jQcQ/4UwLZkMSlsk3R3xxXcbWpIjkdAzQ9rWMKfb/XlmlgymIgY0xHML7bprjDHq/H
         LxSZ5nbJFB9UjAGgjpD78damlsWS9DdK7acS+7gVDouDqFFnIGiM1NWR6eMqw2tmewiI
         Js1g==
X-Gm-Message-State: AOAM533mrURbz919RbcAtCeodd5ID0doWymZZ1M0LniOIHrvD+4vVB0c
        QGbFS2aFzYLEY3bROYVJQ6HVXHjrvZlOD8PdNMA=
X-Google-Smtp-Source: ABdhPJwleUCusbaOlzzHP9iI4mpTCjcB5cwhoKFL9CjGjA11JKH73342cfdLvHbOH6NWbDvdSZBhSPTNA2lQXPQZ6Zs=
X-Received: by 2002:a05:6512:2118:: with SMTP id q24mr15933951lfr.133.1614075667269;
 Tue, 23 Feb 2021 02:21:07 -0800 (PST)
MIME-Version: 1.0
References: <1A318EB9-A257-4A11-B319-EA3F2628C8B7@hxcore.ol>
 <CAKywueROT6yAn6Eer4sncxsaZZyih3kApKmLacb3xsxDJfWfMQ@mail.gmail.com>
 <80BC289A-88D1-45CB-A751-0382211ED4B8@hxcore.ol> <CAKywueRuwHXG65i6XQknXgqtQ+=AdrLCCqft+vwE5XFLWwo=Gw@mail.gmail.com>
 <CAH2r5mv-QHyhdCTyB=uXsyQkMm1fi5vOn6dF=H3quwPg9ek=VA@mail.gmail.com>
 <CAH2r5muFUkL3Bexv-VxK_WKSKXvGq9Bs5CZU0CA0t_SufpkguA@mail.gmail.com>
 <F0563410-2F65-4259-8298-B0669CDD1C8B@hxcore.ol> <CAKywueQgF1LaYW17NS_e71TdSyVffTPUy5JgsQOF+Frkj1TDKA@mail.gmail.com>
 <CANT5p=rv7qTqmBL03tdmKmn5zUfNABf0=pQ3=3i63S7c_4X11w@mail.gmail.com> <AEF3AF95-9738-4A43-8618-D78C01BC8714@hxcore.ol>
In-Reply-To: <AEF3AF95-9738-4A43-8618-D78C01BC8714@hxcore.ol>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Feb 2021 04:20:56 -0600
Message-ID: <CAH2r5msJ8HwNn3B3EBif3Fm83PQ9thX3vB9dQccVFc8_jAiEew@mail.gmail.com>
Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
To:     Rohith <rohiths.msft@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "sribhat.msa@outlook.com" <sribhat.msa@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged this patch in with the one it fixes and pushed to cifs-2.6.git for-n=
ext

Running buildbot on them now:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/bui=
lds/509

On Tue, Feb 23, 2021 at 3:49 AM Rohith <rohiths.msft@gmail.com> wrote:
>
> Hi Steve,
>
>
>
> Please find the attached patch which will fix the regression caused by pr=
evious patch.
>
> During read path when pdu length is greater than CIFSMaxBufSize, =E2=80=
=9Cbufs=E2=80=9D pointer is not updated during =E2=80=9Creceive_transform=
=E2=80=9D. So, oops occurred while accessing =E2=80=9Cbufs=E2=80=9D pointer=
.
>
>
>
> I ran cifs/100 test on my local machine:
>
> dd if=3D/dev/zero of=3D$TEST_DIR/$$/big-file bs=3D4M count=3D1
> dd if=3D$TEST_DIR/$$/big-file of=3D/dev/null bs=3D4M count=3D1
>
>
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
> From: Shyam Prasad N
> Sent: Monday, February 22, 2021 10:53 PM
> To: Pavel Shilovsky
> Cc: Rohith; Steve French; linux-cifs@vger.kernel.org; sribhat.msa@outlook=
.com
> Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
>
>
>
> Looks good to me.
>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
>
>
>
> On Mon, Feb 22, 2021 at 9:21 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
>
> >
>
> > Both patches look good. Thanks!
>
> >
>
> > Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> > --
>
> > Best regards,
>
> > Pavel Shilovsky
>
> >
>
> > =D0=B2=D1=81, 21 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 22:44, R=
ohith <rohiths.msft@gmail.com>:
>
> > >
>
> > > Thanks Steve. Will make sure to run checkpatch for further patches.
>
> > >
>
> > >
>
> > >
>
> > > Regards,
>
> > >
>
> > > Rohith
>
> > >
>
> > >
>
> > >
>
> > > Sent from Mail for Windows 10
>
> > >
>
> > >
>
> > >
>
> > > From: Steve French
>
> > > Sent: Sunday, February 21, 2021 6:26 AM
>
> > > To: Pavel Shilovsky
>
> > > Cc: Rohith; linux-cifs@vger.kernel.org; Shyam Prasad N; sribhat.msa@o=
utlook.com
>
> > > Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
>
> > >
>
> > >
>
> > >
>
> > > The remaining suggestion of Pavel's is included in this trivial clean=
up.
>
> > >
>
> > >
>
> > >
>
> > > Trivial change to clarify code in smb2_is_network_name_deleted
>
> > >
>
> > > Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
>
> > > ---
>
> > >  fs/cifs/smb2ops.c | 29 +++++++++++++++--------------
>
> > >  1 file changed, 15 insertions(+), 14 deletions(-)
>
> > >
>
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>
> > > index aee9da88a333..b2191babce26 100644
>
> > > --- a/fs/cifs/smb2ops.c
>
> > > +++ b/fs/cifs/smb2ops.c
>
> > > @@ -2459,23 +2459,24 @@ smb2_is_network_name_deleted(char *buf, struc=
t TCP_Server_Info *server)
>
> > >   struct cifs_ses *ses;
>
> > >   struct cifs_tcon *tcon;
>
> > >
>
> > > - if (shdr->Status =3D=3D STATUS_NETWORK_NAME_DELETED) {
>
> > > - spin_lock(&cifs_tcp_ses_lock);
>
> > > - list_for_each(tmp, &server->smb_ses_list) {
>
> > > - ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
>
> > > - list_for_each(tmp1, &ses->tcon_list) {
>
> > > - tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_list);
>
> > > - if (tcon->tid =3D=3D shdr->TreeId) {
>
> > > - tcon->need_reconnect =3D true;
>
> > > - spin_unlock(&cifs_tcp_ses_lock);
>
> > > - pr_warn_once("Server share %s deleted.\n",
>
> > > -     tcon->treeName);
>
> > > - return;
>
> > > - }
>
> > > + if (shdr->Status !=3D STATUS_NETWORK_NAME_DELETED)
>
> > > + return;
>
> > > +
>
> > > + spin_lock(&cifs_tcp_ses_lock);
>
> > > + list_for_each(tmp, &server->smb_ses_list) {
>
> > > + ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
>
> > > + list_for_each(tmp1, &ses->tcon_list) {
>
> > > + tcon =3D list_entry(tmp1, struct cifs_tcon, tcon_list);
>
> > > + if (tcon->tid =3D=3D shdr->TreeId) {
>
> > > + tcon->need_reconnect =3D true;
>
> > > + spin_unlock(&cifs_tcp_ses_lock);
>
> > > + pr_warn_once("Server share %s deleted.\n",
>
> > > +     tcon->treeName);
>
> > > + return;
>
> > >   }
>
> > >   }
>
> > > - spin_unlock(&cifs_tcp_ses_lock);
>
> > >   }
>
> > > + spin_unlock(&cifs_tcp_ses_lock);
>
> > >  }
>
> > >
>
> > >  static int
>
> > >
>
> > >
>
> > >
>
> > > On Sat, Feb 20, 2021 at 5:38 PM Steve French <smfrench@gmail.com> wro=
te:
>
> > >
>
> > > I corrected various checkpatch errors - including two of those Pavel =
noted, and tentatively merged into cifs-2.6.git for-next.  See attached upd=
ated patch.
>
> > >
>
> > >
>
> > >
>
> > > Will fix the indentation next.
>
> > >
>
> > >
>
> > >
>
> > > On Sat, Feb 20, 2021 at 12:18 PM Pavel Shilovsky <piastryyy@gmail.com=
> wrote:
>
> > >
>
> > > =D1=87=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 08:10,=
 Rohith <rohiths.msft@gmail.com>:
>
> > > >
>
> > > > Hi Pavel,
>
> > > >
>
> > > >
>
> > > >
>
> > > > Addressed review comments. Can you please take a look.
>
> > > >
>
> > > >
>
> > > >
>
> > > > >> Btw, I think is_status_io timeout should be called in this loop =
for
>
> > > >
>
> > > > >> every mid not outside the loop (sorry, missed that in the origin=
al
>
> > > >
>
> > > > >> review). Could you please fix that separately?
>
> > > >
>
> > > >
>
> > > >
>
> > > > Yes, will send out different patch for status_io_timeout.
>
> > >
>
> > > Thanks!
>
> > >
>
> > > The patch looks good. Please find my minor comments below:
>
> > >
>
> > > 1.
>
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>
> > > index 10fe6d6d2dee..b2f51546c2ef 100644
>
> > > --- a/fs/cifs/connect.c
>
> > > +++ b/fs/cifs/connect.c
>
> > > @@ -993,6 +993,10 @@ cifs_demultiplex_thread(void *p)
>
> > >   if (mids[i] !=3D NULL) {
>
> > >   mids[i]->resp_buf_size =3D server->pdu_size;
>
> > >
>
> > > + if (server->ops->is_network_name_deleted) {
>
> > > +         server->ops->is_network_name_deleted(bufs[i],
>
> > > +                              server);
>
> > > + }
>
> > >
>
> > > ^^^
>
> > > remove extra {}
>
> > >
>
> > > 2.
>
> > > +static void
>
> > > +smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *serv=
er)
>
> > > +{
>
> > > + struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)buf;
>
> > >
>
> > > + struct list_head *tmp, *tmp1;
>
> > > + struct cifs_ses *ses;
>
> > > + struct cifs_tcon *tcon;
>
> > > +
>
> > > + if (shdr->Status =3D=3D STATUS_NETWORK_NAME_DELETED) {
>
> > >
>
> > > ^^^
>
> > > let's do the opposite check: if status is not
>
> > > STATUS_NETWORK_NAME_DELETED then return immediately from the function=
.
>
> > > This will remove overall indentation for the nested for loops.
>
> > >
>
> > > 3.
>
> > > @@ -4605,6 +4632,10 @@ static void smb2_decrypt_offload(struct
>
> > > work_struct *work)
>
> > >  #ifdef CONFIG_CIFS_STATS2
>
> > >   mid->when_received =3D jiffies;
>
> > >  #endif
>
> > > + if (dw->server->ops->is_network_name_deleted) {
>
> > > +         dw->server->ops->is_network_name_deleted(dw->buf,
>
> > > +                                  dw->server);
>
> > > + }
>
> > >
>
> > > ^^^
>
> > > remove extra {}
>
> > >
>
> > > --
>
> > > Best regards,
>
> > > Pavel Shilovsky
>
> > >
>
> > >
>
> > >
>
> > >
>
> > > --
>
> > >
>
> > > Thanks,
>
> > >
>
> > > Steve
>
> > >
>
> > >
>
> > >
>
> > >
>
> > > --
>
> > >
>
> > > Thanks,
>
> > >
>
> > > Steve
>
> > >
>
> > >
>
>
>
>
>
>
>
> --
>
> Regards,
>
> Shyam
>
>



--=20
Thanks,

Steve
