Return-Path: <SRS0=+oFK=7W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4741CC433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 05:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1843420774
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 05:02:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDjH6Llb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgFIFCw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Jun 2020 01:02:52 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53890 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726286AbgFIFCv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Jun 2020 01:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591678969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qCU5U4xdxahl70cM9jwtQAtVhmoVp2eehZ71OSHosOM=;
        b=ZDjH6LlbAyUUrlpG4ZgdnYel/yNjQizit0PXqEogQ0KKf4NaNv4yCIROrHxCbvf/0Jmq2s
        cmiQTQRLd+pJDRQFsm6gvuRmxs0ETpS7IdkcU/kPEmcYwMpIwolq3dooqxVvo1rh/b8ICS
        BR3PJEhQ8jO8BMbjEwkAStcX95N9tBY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-YN53EDtBNKq-q1RyHzSUBA-1; Tue, 09 Jun 2020 01:02:47 -0400
X-MC-Unique: YN53EDtBNKq-q1RyHzSUBA-1
Received: by mail-qt1-f197.google.com with SMTP id u26so17371398qtj.21
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2020 22:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qCU5U4xdxahl70cM9jwtQAtVhmoVp2eehZ71OSHosOM=;
        b=LdL/0+V1qWYT2s1dwtfB8bM3M0dBJtoEFhD+q6o6PsLlzauodz199BdW68iE/BOxcf
         aXaZLTxEtEbeJLCNY99qVrAhsyACxFcJveCDMXFi+yTfbyd/caf70K9oNuJIdC4DEwix
         fkVyS2q2prWkeI3tqQb42tVzIO7Hv26pmExZmG8R7mr6uSEPOay89kbxmVfVoXymKbIb
         FeO5zoUITT8hElx9QRuhDfUT3XF4LhAlaHNguSgQeYuVOAETNb8GrhtCLN0WL2EUVdqo
         xbovtM2NKL8ZJJGND2sirzyxZKexFfg0ixp0AIX6dAC6cYHavo9j8iFCfHGIjwOg+aZO
         G9RA==
X-Gm-Message-State: AOAM531M8Pr5oqFhCMsXk0o0lIb0KZ9fXOpdIDZ6hmlIFEjhHNHwT8q7
        kvnk4ann3/+5Um8PsrNAfRE3nWEFZFB0H6qaURtoROWcnxCopHfJy2H/e8RnkNiDZ2W+7PHonXa
        FDF+YrZWw6Re7b3a1LMCWTGCbheTEHuEjwuKCdg==
X-Received: by 2002:ac8:6f2f:: with SMTP id i15mr14606939qtv.73.1591678966592;
        Mon, 08 Jun 2020 22:02:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLwGAiQ9ohd/p6/VVc8J9DZAK0sHIXeMt119WaF8i70Vnch+76qDvh44eZvfNggvckBMJ8SK7jH01P4YR4Cnw=
X-Received: by 2002:ac8:6f2f:: with SMTP id i15mr14606923qtv.73.1591678966322;
 Mon, 08 Jun 2020 22:02:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200605151746.18743-1-kdsouza@redhat.com> <CAH2r5mt_AtRHoyZ3_0j+d0gxA0_ntvYEUsN3VWY4mkG=ammwiw@mail.gmail.com>
In-Reply-To: <CAH2r5mt_AtRHoyZ3_0j+d0gxA0_ntvYEUsN3VWY4mkG=ammwiw@mail.gmail.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Tue, 9 Jun 2020 10:32:34 +0530
Message-ID: <CAA_-hQ+FLZsJi96dRLpQFZc-iS1xTAaNvrwtfao2uBL=3650+w@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: dump Security Type info in DebugData
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Steve :)

On Tue, Jun 9, 2020 at 10:31 AM Steve French <smfrench@gmail.com> wrote:
>
> the updated version of this one has been merged into cifs-2.6.git for-next
>
> On Fri, Jun 5, 2020 at 10:17 AM Kenneth D'souza <kdsouza@redhat.com> wrote:
> >
> > Currently the end user is unaware with what sec type the
> > cifs share is mounted if no sec=<type> option is parsed.
> > With this patch one can easily check from DebugData.
> >
> > Example:
> > 1) Name: x.x.x.x Uses: 1 Capability: 0x8001f3fc Session Status: 1 Security type: RawNTLMSSP
> >
> > Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> > Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> > ---
> >  fs/cifs/cifs_debug.c |  4 ++++
> >  fs/cifs/cifsglob.h   | 18 ++++++++++++++++++
> >  2 files changed, 22 insertions(+)
> >
> > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> > index 916567d770f5..9caca784376b 100644
> > --- a/fs/cifs/cifs_debug.c
> > +++ b/fs/cifs/cifs_debug.c
> > @@ -375,6 +375,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
> >                                 ses->ses_count, ses->serverOS, ses->serverNOS,
> >                                 ses->capabilities, ses->status);
> >                         }
> > +
> > +                       seq_printf(m,"Security type: %s\n",
> > +                                       get_security_type_str(server->ops->select_sectype(server, ses->sectype)));
> > +
> >                         if (server->rdma)
> >                                 seq_printf(m, "RDMA\n\t");
> >                         seq_printf(m, "TCP status: %d Instance: %d\n\tLocal Users To "
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 39b708d9d86d..d8ef01039e71 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1994,6 +1994,24 @@ extern struct smb_version_values smb302_values;
> >  extern struct smb_version_operations smb311_operations;
> >  extern struct smb_version_values smb311_values;
> >
> > +static inline char *get_security_type_str(enum securityEnum sectype)
> > +{
> > +       switch (sectype) {
> > +       case RawNTLMSSP:
> > +               return "RawNTLMSSP";
> > +       case Kerberos:
> > +               return "Kerberos";
> > +       case NTLMv2:
> > +               return "NTLMv2";
> > +       case NTLM:
> > +               return "NTLM";
> > +       case LANMAN:
> > +               return "LANMAN";
> > +       default:
> > +               return "Unknown";
> > +       }
> > +}
> > +
> >  static inline bool is_smb1_server(struct TCP_Server_Info *server)
> >  {
> >         return strcmp(server->vals->version_string, SMB1_VERSION_STRING) == 0;
> > --
> > 2.21.1
> >
>
>
> --
> Thanks,
>
> Steve
>

