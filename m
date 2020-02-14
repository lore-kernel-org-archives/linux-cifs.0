Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C648C2BA83
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 19:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF8A2168B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 19:05:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sK4hodaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgBNTFB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Feb 2020 14:05:01 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43138 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgBNTFB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Feb 2020 14:05:01 -0500
Received: by mail-lf1-f65.google.com with SMTP id 9so7437324lfq.10
        for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2020 11:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IotVpaKfA9twFHJPETEL8FWwnxXrEhcz0PeD9ICjwQk=;
        b=sK4hodaFDRoAeb2a4t6E1O1sYHWw+0htpWaZXEBelowsIYzR1j5PHW7iJjQw/Knzxy
         xCXvSnd/xN6kpEt4sx3//5+QPDU6BD+8Hbw5mNFJKvtfKuBsYXxNn9CgKrakNUTdMyUj
         P1nrNX9NtmzhP/zaoU45kJWX1qXgJcMXqsu/UOiKqZaXJA0QfpvzsNsQxt+VjXLT8l9R
         5XRYqMbOwQmVU9DkNVXe4uM9ZkuCd9cBsaMxCvzZDPK/53H2m3v3S7F2L1Au451hh0pj
         T3k93HqwCmzjnpqVlNs9xX1BXMlmiQTWxpRaFWKxwaKr50LuwxFeZ3/lSvmMkgRnBGSG
         qFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IotVpaKfA9twFHJPETEL8FWwnxXrEhcz0PeD9ICjwQk=;
        b=RACmi9/U9xIJL+zVvqbNaBfPWpJnSDMrYFnfDvEr1E3rE6qEZtDShshxO82OQjru6E
         9MU1SHQn6KQg8gNIBCH8UVtvF+zLycR+WQ/uhc1ZrWWXtevivtQVKhH+Z8WK65qnJ5KF
         H1KpVVwgcBPM4IdSNqF0lGqd2P8Mv4tbfSPnvtoMnDwr0XPDnuHlTPmlmmuCW9aDzIr5
         fZsJZGW5yWELIWueJdmxY3X5VZlUP3xEU5HPCGjNesUCm/p+9MTHQ2/NHNK1SpQ0n1Y7
         hNL71zAeYVy39G9zmyX3GUynQP8RRunY1MkLgobGQsl6w8TcJ54eP3usX4zN+Vf7WT4y
         ivPw==
X-Gm-Message-State: APjAAAX+noVWiaT9fvrBblt5WTqwSGK2L0SuMJW7EGXFXrtw1SMs9RnD
        dvtYhFFcTENubVLJ3tB4I/qzXc9uur/8LWz+pw1VHJE=
X-Google-Smtp-Source: APXvYqwE216s2FEWwVXSBCr/rpjftDyifq/rlIZqzqCqhg/PBrQkcqJJAS8THqGfDADTgjA55miVkdtdJTbweQ4I6Wk=
X-Received: by 2002:a19:750e:: with SMTP id y14mr2451106lfe.86.1581707098954;
 Fri, 14 Feb 2020 11:04:58 -0800 (PST)
MIME-Version: 1.0
References: <20200213021447.24819-1-lsahlber@redhat.com> <CAH2r5ms0Bz6gVS1guJS6_=3fwQSbdd2yOh7PKJCkrvqFeyUgnQ@mail.gmail.com>
In-Reply-To: <CAH2r5ms0Bz6gVS1guJS6_=3fwQSbdd2yOh7PKJCkrvqFeyUgnQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 14 Feb 2020 11:04:47 -0800
Message-ID: <CAKywueQ_=r7m_XDxjyH1DON3Smz-q3LSJDuYKG-AG8npH7hyDg@mail.gmail.com>
Subject: Re: [PATCH] cifs: make sure we do not overflow the max EA buffer size
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We can't receive packets bigger that 16k in the memory pool buffers.
In order to support bigger response buffer we would need to allocate
individual pages and receive the packet directly into them (like we do
for writes).

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 13 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 22:14, Steve=
 French <smfrench@gmail.com>:
>
> We should be allowing these to be larger than ~16000 bytes
>
> Should be XATTR_SIZE_MAX 65536
>
> but that can be done with different patch
>
> On Wed, Feb 12, 2020 at 8:15 PM Ronnie Sahlberg <lsahlber@redhat.com> wro=
te:
> >
> > RHBZ: 1752437
> >
> > Before we add a new EA we should check that this will not overflow
> > the maximum buffer we have available to read the EAs back.
> > Otherwise we can get into a situation where the EAs are so big that
> > we can not read them back to the client and thus we can not list EAs
> > anymore or delete them.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/smb2ops.c | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index baa825f4cec0..3c76f69f4ca7 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -1116,7 +1116,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_t=
con *tcon,
> >         void *data[1];
> >         struct smb2_file_full_ea_info *ea =3D NULL;
> >         struct kvec close_iov[1];
> > -       int rc;
> > +       struct smb2_query_info_rsp *rsp;
> > +       int rc, used_len =3D 0;
> >
> >         if (smb3_encryption_required(tcon))
> >                 flags |=3D CIFS_TRANSFORM_REQ;
> > @@ -1139,6 +1140,38 @@ smb2_set_ea(const unsigned int xid, struct cifs_=
tcon *tcon,
> >                                                              cifs_sb);
> >                         if (rc =3D=3D -ENODATA)
> >                                 goto sea_exit;
> > +               } else {
> > +                       /* If we are adding a attribute we should first=
 check
> > +                        * if there will be enough space available to s=
tore
> > +                        * the new EA. If not we should not add it sinc=
e we
> > +                        * would not be able to even read the EAs back.
> > +                        */
> > +                       rc =3D smb2_query_info_compound(xid, tcon, utf1=
6_path,
> > +                                     FILE_READ_EA,
> > +                                     FILE_FULL_EA_INFORMATION,
> > +                                     SMB2_O_INFO_FILE,
> > +                                     CIFSMaxBufSize -
> > +                                     MAX_SMB2_CREATE_RESPONSE_SIZE -
> > +                                     MAX_SMB2_CLOSE_RESPONSE_SIZE,
> > +                                     &rsp_iov[1], &resp_buftype[1], ci=
fs_sb);
> > +                       if (rc =3D=3D 0) {
> > +                               rsp =3D (struct smb2_query_info_rsp *)r=
sp_iov[1].iov_base;
> > +                               used_len =3D rsp->OutputBufferLength;
> > +                       }
> > +                       free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_ba=
se);
> > +                       resp_buftype[1] =3D CIFS_NO_BUFFER;
> > +                       memset(&rsp_iov[1], 0, sizeof(rsp_iov[1]));
> > +                       rc =3D 0;
> > +
> > +                       /* Use a fudge factor of 256 bytes in case we c=
ollide
> > +                        * with a different set_EAs command.
> > +                        */
> > +                       if(CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SI=
ZE -
> > +                          MAX_SMB2_CLOSE_RESPONSE_SIZE - 256 <
> > +                          used_len + ea_name_len + ea_value_len + 1) {
> > +                               rc =3D -ENOSPC;
> > +                               goto sea_exit;
> > +                       }
> >                 }
> >         }
> >
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
