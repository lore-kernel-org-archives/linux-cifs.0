Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B051F4174
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 00:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777595254; cv=pass; b=oOS4puVVOJ+BqNhS/OUCmSiYOwYUhg3JvYX3WLpu75ausVVaWQxpcuIms240p4NwZZkXPJiqSqG8L4/lOSbk1aSgzKbBfwb24ZZ7jh2OZ2Eg2zzias20srkRiGx3D7OR/GSVqFMaAi+LDZ3sWGSi5PEl1fSthRtIbqpdKkaqll4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777595254; c=relaxed/simple;
	bh=b4/+eV6bWE2Bwrc2O+/CVJ5INaaI2/6u+mLPhWGNDbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cg3PJ5VjddWjQbbfZrt4yQhM1W4+QXMATRuBF5M7Tw2tKk1duYxAVYARTxngyx0s7xAT9P3nTWStjujYvs4ga75O4E/8jE6yPfBEPRowX3s8MkX4uhEjziarN4QVEcp0CyPkvTSO9kiRvu4O1ztql5ZBDmNaDA32IFOzHQIoS5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wk5OyGMT; arc=pass smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wk5OyGMT"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so244720866b.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 17:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777595251; cv=none;
        d=google.com; s=arc-20240605;
        b=ZpdrwDNlR2TwFlvP5PRwFB8zXL6we5jHcBPtLwTHux3VeCf2PynNtxkesy1Fy8VCb+
         RTm+Jck02u6eT1rY8EaVFnFK+8rSaqU8PSaZlk8kZtKRK7agfHiqmv0Z9a76364Za43k
         YMzSEOMeOcWichMxqTGOZwwsdSL3NVZ3LuOpNtIdCmZgs3UNH/I9gaKZEMWTyGdS16fT
         24gDSlpwhsCQNYncY4JX+SVsJwn1EOUHKmjfucAo6mrnnd4Ovgc5vVGq2Nl7bmn1lz37
         GzqJh1OL8M+xl0MRe7Jps+SyB9rGzDzlEUhSLU3hxbZwOk6ckaRG5liM7K88g7lyw7uh
         IBkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Fg7hYh8JSaCjlzaiWa74d4/q3ZrBr1Vo+JYctYANEaI=;
        fh=n4uRfhPVfoARc4AbFalqQjQA6h2+DWx3bHMPPDvXhxE=;
        b=V82T0v+/riJclp1cYVIehwN55kX7WnYhU0XawMpqQhSx3pIcQcL6ugDRcAv0+AWoEd
         TbxwFCJQKgerw2ihJgCJfCuz1yKNSziaFNCZimU6bEVexV0MdIIWKE8bD96LQYfkWHta
         5ERDtlSltYVk6MSWqfLaXfLhD4acLivlo5CHNaM03XJOHCuefadaDT7DBeU5dAsVAIuG
         XIooCXXjWuMUkpTVneaK8QZVRkBUMvhmAJGVckjhGsZeIsWn3Ao2NpuVHSDvEdeqcsF8
         45UqinUKUXlWE2dM4o3eauM+EWCbmy2wnOH1RHOwJeiB2AQBOQVINz57DPqGEWDy+Ak1
         dTYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777595251; x=1778200051; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fg7hYh8JSaCjlzaiWa74d4/q3ZrBr1Vo+JYctYANEaI=;
        b=Wk5OyGMTXRu2iWdl9Z4ui6uynDKI0AdaIdzk7Z/NaH0O/z1YG3TfwPfBZ9IZ8f29oa
         x0sJT7J3iySmXt5FmQ4Rx35GWHkVnxt5BqpRTVG7wVIF0WKsrc5Cq8JWjvdyU1V0v1jQ
         v3AWd2z7eKHA8+o3t8+ncGrgAxSzskBraRkWLjz9ZGinvUoNSmfiBL/uZk1vj38dkOY9
         mO0BsG5iizQWdQdhDI/JZK3gW16xDkYmMmWZgy4DKFnkLF13stf2EsFvc8XMk+2JLtTP
         nxlp5llzGBPi3I1+wPz36SrQj16KTwODTHVVDoprnOKAav90Sb13vqcloGpcizab40XI
         1CKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777595251; x=1778200051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fg7hYh8JSaCjlzaiWa74d4/q3ZrBr1Vo+JYctYANEaI=;
        b=HoPYjfO/SP2ByTmIgGcto4l5cdpTG0c5ZZCP3WPF3SDNEf+EMP8ktgI7TVXbN6Teqi
         tJwJhvu0y5oJD1SbUv0s0VCEEwGbLVChxY6JLxf7kSPiRVxrl3XTCakEHmVxmt/MuxHb
         2aKfRSQ8u8UORo/9Yi2VCwkRWgpsQ8H+h/UxXpLi1Q7tGNDcjeku+432hKklYCUfpZq7
         ecLsMauanX6g/7hP0QaiTB7R3YGHLNAmDOr0P/Lk/zJuo/malus+XxrITL51UUeA1y1Z
         MhDjIX1hwxBKDYVP7HvHBomcRI7t7wGoRSagAMj7YnTjqgQkDGZEgVYEJz5BWohQN09a
         csjA==
X-Gm-Message-State: AOJu0YzSAEdad8yMgxSnA1PhaEjwgFI+AErvk0YvYB2V7OCeENohqifm
	S4C6d9x/Rq+HD612RtWPpBcF6lax/sVeqsmT+PJiY/5RIM1wliOv+RE4vOWmz6a+niGBCEBQ661
	AVW/OvLccQEihNM10OpmEO8G5jdIx3+0=
X-Gm-Gg: AeBDietfNNT0ChiyWoDP3kt2kjVEyOp3lu/cJYS/CJbCi7ypAbxkQsCp3a0/s56UZg+
	PtucvaV62cRclm6DVkNKy25ZqJshjB/v1JnZTItjC6C2UTshjKsUsngL23HfkZn6th6BQ2uEQiv
	E+kxTkj3uKaPiiyXPrNFlwQo0+DVXA4A4F8t8euddzkbXT9YjBqedwocEwl5R8OcesjSw/nxsqd
	nAESmNMFCqMWvXCWKaJS4faympTw3JaAc/g5HUVtlIe5uETjLiKJy8aEaHVzbukxaJNejUFg7nt
	ZouhGHfA3PHhv6bqyJlwGXnGbqaH+F3vhFUxQeV//JxprwOmIbYpsFYFudfsrwMq15017PX4j+K
	0o2+CtJRNcwmXSj81hQ0FdkXVqAtS9wFCcsYqrUq1+gbLZ1edIyDtLHIXx3v7wr9BH9w/
X-Received: by 2002:a17:907:86a0:b0:b9f:9e7a:bcd2 with SMTP id
 a640c23a62f3a-bbec11f57a4mr40366066b.38.1777595246631; Thu, 30 Apr 2026
 17:27:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430220601.76266-1-rosenp@gmail.com> <CAH2r5mvNHedEymrmCYCbghmdv1OLcbVPstnrSZooLXavKkc4Kw@mail.gmail.com>
In-Reply-To: <CAH2r5mvNHedEymrmCYCbghmdv1OLcbVPstnrSZooLXavKkc4Kw@mail.gmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 30 Apr 2026 17:27:14 -0700
X-Gm-Features: AVHnY4L7GIhIQO1Yw8vcFwwt_qs-KfjeEWcdQKkzrVSAxEOOe1que3s099ZabJo
Message-ID: <CAKxU2N_m8+Rd8Q0Ty7sk0_bANdyagy9KTc8GM=hHu=FbwRbaYg@mail.gmail.com>
Subject: Re: [PATCH] cifssmb: use struct_offset in memcpy calculations
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, 
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 30, 2026 at 5:09=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Seems clearer to leave in the cast so it is a memcpy from char * to char =
*
Will fix in v2. Can't say I agree though.
>
>            memcpy((char *) pFindData,
>
> On Thu, Apr 30, 2026 at 5:06=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wr=
ote:
> >
> > It seems W=3D1/FORTIFY_SOURCE is getting confused about the math here.
> >
> > Use struct_offset to point FORTIFY_SOURCE to the correct place.
> >
> > Remove response_data variables and directly apply to memcpy. Simpler
> > and avoids excess casting.
> >
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  fs/smb/client/cifssmb.c | 40 +++++++++++++---------------------------
> >  1 file changed, 13 insertions(+), 27 deletions(-)
> >
> > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > index 3990a9012264..8598cec5ebbd 100644
> > --- a/fs/smb/client/cifssmb.c
> > +++ b/fs/smb/client/cifssmb.c
> > @@ -4090,9 +4090,9 @@ CIFSSMBQFileInfo(const unsigned int xid, struct c=
ifs_tcon *tcon,
> >                                       get_bcc(&pSMBr->hdr), 40);
> >                 else if (pFindData) {
> >                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.Dat=
aOffset);
> > -                       memcpy((char *) pFindData,
> > -                              (char *) &pSMBr->hdr.Protocol +
> > -                              data_offset, sizeof(FILE_ALL_INFO));
> > +                       memcpy(pFindData,
> > +                              (char *)pSMBr + struct_offset(pSMBr, hdr=
.Protocol) + data_offset,
> > +                              sizeof(FILE_ALL_INFO));
> >                 } else
> >                     rc =3D -ENOMEM;
> >         }
> > @@ -4264,9 +4264,8 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >                                       get_bcc(&pSMBr->hdr), sizeof(FILE=
_UNIX_BASIC_INFO));
> >                 } else {
> >                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.Dat=
aOffset);
> > -                       memcpy((char *) pFindData,
> > -                              (char *) &pSMBr->hdr.Protocol +
> > -                              data_offset,
> > +                       memcpy(pFindData,
> > +                              (char *)pSMBr + struct_offset(pSMBr, hdr=
.Protocol) + data_offset,
> >                                sizeof(FILE_UNIX_BASIC_INFO));
> >                 }
> >         }
> > @@ -4349,9 +4348,8 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, stru=
ct cifs_tcon *tcon,
> >                                       get_bcc(&pSMBr->hdr), sizeof(FILE=
_UNIX_BASIC_INFO));
> >                 } else {
> >                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.Dat=
aOffset);
> > -                       memcpy((char *) pFindData,
> > -                              (char *) &pSMBr->hdr.Protocol +
> > -                              data_offset,
> > +                       memcpy(pFindData,
> > +                              (char *)pSMBr + struct_offset(pSMBr, hdr=
.Protocol) + data_offset,
> >                                sizeof(FILE_UNIX_BASIC_INFO));
> >                 }
> >         }
> > @@ -5079,7 +5077,6 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, s=
truct cifs_tcon *tcon)
> >  /* level 0x105  SMB_QUERY_FILE_SYSTEM_INFO */
> >         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
> >         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> > -       FILE_SYSTEM_ATTRIBUTE_INFO *response_data;
> >         unsigned int in_len;
> >         int rc =3D 0;
> >         int bytes_returned =3D 0;
> > @@ -5130,11 +5127,8 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, =
struct cifs_tcon *tcon)
> >                                       get_bcc(&pSMBr->hdr), 13);
> >                 } else {
> >                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.Dat=
aOffset);
> > -                       response_data =3D
> > -                           (FILE_SYSTEM_ATTRIBUTE_INFO
> > -                            *) (((char *) &pSMBr->hdr.Protocol) +
> > -                                data_offset);
> > -                       memcpy(&tcon->fsAttrInfo, response_data,
> > +                       memcpy(&tcon->fsAttrInfo,
> > +                              (char *)pSMBr + struct_offset(pSMBr, hdr=
.Protocol) + data_offset,
> >                                sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
> >                 }
> >         }
> > @@ -5152,7 +5146,6 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, stru=
ct cifs_tcon *tcon)
> >  /* level 0x104 SMB_QUERY_FILE_SYSTEM_INFO */
> >         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
> >         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> > -       FILE_SYSTEM_DEVICE_INFO *response_data;
> >         unsigned int in_len;
> >         int rc =3D 0;
> >         int bytes_returned =3D 0;
> > @@ -5205,11 +5198,8 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, str=
uct cifs_tcon *tcon)
> >                                       sizeof(FILE_SYSTEM_DEVICE_INFO));
> >                 else {
> >                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.Dat=
aOffset);
> > -                       response_data =3D
> > -                           (FILE_SYSTEM_DEVICE_INFO *)
> > -                               (((char *) &pSMBr->hdr.Protocol) +
> > -                                data_offset);
> > -                       memcpy(&tcon->fsDevInfo, response_data,
> > +                       memcpy(&tcon->fsDevInfo,
> > +                              (char *)pSMBr + struct_offset(pSMBr, hdr=
.Protocol) + data_offset,
> >                                sizeof(FILE_SYSTEM_DEVICE_INFO));
> >                 }
> >         }
> > @@ -5227,7 +5217,6 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct=
 cifs_tcon *tcon)
> >  /* level 0x200  SMB_QUERY_CIFS_UNIX_INFO */
> >         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
> >         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> > -       FILE_SYSTEM_UNIX_INFO *response_data;
> >         unsigned int in_len;
> >         int rc =3D 0;
> >         int bytes_returned =3D 0;
> > @@ -5277,11 +5266,8 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struc=
t cifs_tcon *tcon)
> >                                       get_bcc(&pSMBr->hdr), 13);
> >                 } else {
> >                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.Dat=
aOffset);
> > -                       response_data =3D
> > -                           (FILE_SYSTEM_UNIX_INFO
> > -                            *) (((char *) &pSMBr->hdr.Protocol) +
> > -                                data_offset);
> > -                       memcpy(&tcon->fsUnixInfo, response_data,
> > +                       memcpy(&tcon->fsUnixInfo,
> > +                              (char *)pSMBr + struct_offset(pSMBr, hdr=
.Protocol) + data_offset,
> >                                sizeof(FILE_SYSTEM_UNIX_INFO));
> >                 }
> >         }
> > --
> > 2.54.0
> >
> >
>
>
> --
> Thanks,
>
> Steve
