Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5298FEB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 22:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjF0Wza (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 18:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjF0Wz3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 18:55:29 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686AC26B6
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 15:55:28 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2b69ea3b29fso46772781fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 15:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687906526; x=1690498526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TfIsTcV+pJUlz+Pm5+WAm0YlGZMnKht8+l4ma29DnU=;
        b=HCNlNIpgYD3k909fJRl1ikJEQxUVqI3fEtqw2aFLHO2htLJl+zWw0MCM3jBh+uL6LJ
         w4teHe3Pg5eASKLp2ZTYR3AvWgsKW6AXnxxToW0sj1ihZRlmIP/fpYjWyQcIrdShd0jj
         tzYG1+10bp6x1J5xecERruk7fXJsVOSYtd4hbHSMFIzLGNplwZ9jDxeCNxoAJ6MlFAbh
         mm+ha/F+OwfStcQA/hdPPGrPvxhn/GIHwPWgZrPWicYLEMh0Al1E4TA2r4x4wem5+xJr
         o7JFPkUWkQe5SJEAhmzLQRmq/+mhf+wZu/uoZFTrmZDD+W+r0zKkM+ISsxaCpB2MWwOU
         o97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687906526; x=1690498526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1TfIsTcV+pJUlz+Pm5+WAm0YlGZMnKht8+l4ma29DnU=;
        b=AQzJN+gDdYWrRFyzigqh6zJZ7XM5LJsC6OGPKzlkgn8DZa0OMujeCdLiRmOX2NvHc0
         R2z4nhb7EkpFLO54A0GU1peVhaxcG8PTzRvfM/bXRuJWFtbcpA9+T3L7zyscgAimWF8U
         6AwhVXaujdeymyMt/CS/b4990YUgeF8wLS0TO7Z1jI0bN3O1Hol1pNw/fbyNJCYJTvm8
         MJ1BMdca0LbBkLrr4Rbv0cfWy+b7pcvLkwnPd0Lfmp05+u18iXdAGTY22g5HHnPFFNJ6
         QSfRwdyopNQSQgG96toNKUkNqk2XnppCzTNFmIVwz6Zz77U4pzFzatvUd0zB07NTZRwJ
         zNwA==
X-Gm-Message-State: AC+VfDzrQkJ1i5qsKMJYvnuUlzaOxRUeGKJzhTbPWFTEc4NeTw9cO+x9
        pZ1YhkCgyTryu1FYksS50p/07ZmP3HdSZx9xPLk=
X-Google-Smtp-Source: ACHHUZ7mi9Pw89Uh4b66HGkhvMxnAoMhobQbxW3cWsFELCpct0erkBTIBhUtIisN785GjB3m5+wkD2153OTCUAkucdg=
X-Received: by 2002:a05:6512:3045:b0:4fb:89cd:9616 with SMTP id
 b5-20020a056512304500b004fb89cd9616mr1730573lfb.0.1687906526063; Tue, 27 Jun
 2023 15:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230627120943.16688-1-sprasad@microsoft.com> <a1006fe1-5be2-4e49-cf9e-cd1a23c213af@talpey.com>
In-Reply-To: <a1006fe1-5be2-4e49-cf9e-cd1a23c213af@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 27 Jun 2023 17:55:14 -0500
Message-ID: <CAH2r5mtTk434vnq3fRPAQPfTa5tdpOsdU=GXSi-N8OFxg4oNvw@mail.gmail.com>
Subject: Re: [PATCH] cifs: print client_guid in DebugData
To:     Tom Talpey <tom@talpey.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, pc@cjr.nz, ematsumiya@suse.de,
        bharathsm.hsk@gmail.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added acked-by and merged into cifs-2.6.git for-next

On Tue, Jun 27, 2023 at 2:28=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/27/2023 8:09 AM, Shyam Prasad N wrote:
> > Having the ClientGUID info makes it easier to debug
> > issues related to a client on a server that serves a
> > number of clients.
> >
> > This change prints the ClientGUID in DebugData.
>
> Good idea.
>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >   fs/smb/client/cifs_debug.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> > index 079c1df09172..f5af080ac100 100644
> > --- a/fs/smb/client/cifs_debug.c
> > +++ b/fs/smb/client/cifs_debug.c
> > @@ -347,6 +347,7 @@ static int cifs_debug_data_proc_show(struct seq_fil=
e *m, void *v)
> >               spin_lock(&server->srv_lock);
> >               if (server->hostname)
> >                       seq_printf(m, "Hostname: %s ", server->hostname);
> > +             seq_printf(m, "\nClientGUID: %pUL", server->client_guid);
> >               spin_unlock(&server->srv_lock);
>
> It's a totally minor thing, but does this code really need to
> take the server lock? These elements never change anyway.
>
> In any case:
>
> Acked-by: Tom Talpey <tom@talpey.com>
>
> >   #ifdef CONFIG_CIFS_SMB_DIRECT
> >               if (!server->rdma)



--=20
Thanks,

Steve
