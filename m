Return-Path: <SRS0=jY8V=BX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7E9C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 23:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8866220774
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Aug 2020 23:10:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y3r/ESTq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMXKS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Aug 2020 19:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgHMXKS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Aug 2020 19:10:18 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB655C061757
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 16:10:17 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so8004680eje.7
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2020 16:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5sAzcnpsWkVdMF718dYK82AuN1Oi+sG8wE5AGh59yfI=;
        b=Y3r/ESTq0faQhG5aeHa9zWsseof8CaspfWzGZkJqw/2M3Kmww92AwPX96GBP2KUXN3
         25cbKJRcgtZX1IJhArr65clloFo1LhAw1XscRCdeVePkhj8y1nu217H8ZLbyH//OlQao
         mXPrCNjP5n+hCX+q0HXGrPGTHJBHedH+qUvCB/C1J02O75dTJrhhBstgwifGkZgHYJC/
         0f4XbUGEVAFxmul3R2XhHmBdzNohgoJx8qpm79IOfwzcrlvGnml/6h5uOkYXu4vFDpSv
         IVMtlLKr0gbaIccw6oPvHRXHXY1/96/xMPrln2CgubK0bQ9KnnK4YduLebk/4eOFHkoW
         ol0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5sAzcnpsWkVdMF718dYK82AuN1Oi+sG8wE5AGh59yfI=;
        b=r235okUPsAi3RF2BdY3jH/LIiZqqr41IhLjdRo58sNWWgi7EHkUqNDn5lHW1jUBz2T
         PqyOUe++p95iNXNVqU0bCclskWbvES8mTmyj0G3nDREKrXts9KPMqe+EZEx64YZk5pL1
         Uv3cc+6yaNKaBRu3RmdhH2ANgtOd1znabP/GvUXJ8kSLa+gT1Aoyc1eRHUfGfxgO/ze0
         YrAw6WwGw+wnDtwqv6XEaxyxOnps9ZN4uVLuS4CxLFiVOOcNym6C2WEeMWulTlI7CqCp
         k1sgTGEnLszAi6MMHE67DloJCuoMQ/rE6Xob+yLVVGNVNfdboU9FRzDe1MJ34ROPQD0e
         dbaQ==
X-Gm-Message-State: AOAM531fD7PBW12xe9m1D/Uf3UO4xsL6j2DPegHijZNUHnA85C40/EcV
        Ac23VK8ZbxnyA20nmhcvTND7KgogLH0R+YsaBCOw
X-Google-Smtp-Source: ABdhPJx5JuFmpzTG+WkkbJLJhii8mHkWyqr98Ufb5TQOea3uizO+x4FE3VtVDi5BJD8yL2SruqYVDlqco38TVJElVuA=
X-Received: by 2002:a17:906:248b:: with SMTP id e11mr6868479ejb.280.1597360216276;
 Thu, 13 Aug 2020 16:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms-cXJzTqbTuE8_095aUssB8RvaqBTkfY2gHROjg7GsAQ@mail.gmail.com>
 <87blje5t1y.fsf@cjr.nz>
In-Reply-To: <87blje5t1y.fsf@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 13 Aug 2020 16:10:05 -0700
Message-ID: <CAKywueTOxmPxLG-ghVkokpDNuRyYK29Ogx39QtGzBYGBvGXDGg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Fix mkdir when idsfromsid configured on mount
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 13 =D0=B0=D0=B2=D0=B3. 2020 =D0=B3. =D0=B2 10:56, Paulo Alcan=
tara <pc@cjr.nz>:
>
> Steve French <smfrench@gmail.com> writes:
>
> > From c8e2d959ddac89ee44f170b2f2549e749581ec55 Mon Sep 17 00:00:00 2001
> > From: Steve French <stfrench@microsoft.com>
> > Date: Thu, 13 Aug 2020 12:38:08 -0500
> > Subject: [PATCH] SMB3: Fix mkdir when idsfromsid configured on mount
> >
> > mkdir uses a compounded create operation which was not setting
> > the security descriptor on create of a directory. Fix so
> > mkdir now sets the mode and owner info properly when idsfromsid
> > and modefromsid are configured on the mount.
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > CC: Stable <stable@vger.kernel.org> # v5.8
> > ---
> >  fs/cifs/smb2inode.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> > index b9db73687eaa..eba01d0908dd 100644
> > --- a/fs/cifs/smb2inode.c
> > +++ b/fs/cifs/smb2inode.c
> > @@ -115,6 +115,7 @@ smb2_compound_op(const unsigned int xid, struct cif=
s_tcon *tcon,
> >       vars->oparms.fid =3D &fid;
> >       vars->oparms.reconnect =3D false;
> >       vars->oparms.mode =3D mode;
> > +     vars->oparms.cifs_sb =3D cifs_sb;
> >
> >       rqst[num_rqst].rq_iov =3D &vars->open_iov[0];
> >       rqst[num_rqst].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
