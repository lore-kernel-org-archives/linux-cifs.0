Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662404C9A;
	Sat,  9 Nov 2024 04:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731125413; cv=none; b=XBCETWKPXfLYoq16a4rmDJ97vszXSZODuUAZ16T37CtjQF96iJR1HN3/gJ2KACgCMKGXZ27eYqc2Lih0VH/g3PrRjImylbv2ECyMpS1T6ubk5ueVZ2JtUZ45sTMzvoJceHdjphrqeFfi8IiaEMhOd8PyFQfrmp1YBHW1fr0flS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731125413; c=relaxed/simple;
	bh=JZ69qcM9P5rwr+/FsC7FXOQh1NARMh+JwV0K4vI0Nk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UEeRNiRibnDC+qU9kCWCEH71tt3oDOeoI/9v5kf5ZJ9A1ogSoLSs/ApiCmttvnOQQBzZJKsxbaeCqRBQBMvtB8AEqBZUCwyG7Zy1djXr3IBrnRLXJXjJznhPFIEGhdKWmrIdvcnJYazZPAtCJ9phib3SIMhddzT+jIQhpulCRAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZBCmR3vj; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBCmR3vj"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fb599aac99so24711951fa.1;
        Fri, 08 Nov 2024 20:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731125409; x=1731730209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GM4UJKrOsFES8DQLIyVBGBuw6/u1pHS52JzCVUCY7Xc=;
        b=ZBCmR3vjG0skRSQBFIQBR805UsZ11udkrq8OiMjbFgcVc1ZtdluS/rLrmwQc1YGvau
         /D7piiWIeFm7Y8Cf0OUacoWZE6QXgF5d64tkZKxczGEIkB7GCLgqX6Z48V4Ntw/8YiIb
         aDvKYRZzI8BtAruXfgR+ya+YoSvnmVO4y++ChrmRxwaoBlJdp5vQmp0cG7YsdMDZLa0k
         PxBh+hEmjcAckQtYAXeE/mf3XZ8KS1OdkTL+uqJkh3n+hYVjanOvEBK8p6nTX0G+tCBS
         RH95lmP/ARZNCnMHcIQCaWv6XxoseEIfe5cRbsGk7sQdKol9M1Sj+H/mUgF5ACjfJmjC
         1vqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731125409; x=1731730209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GM4UJKrOsFES8DQLIyVBGBuw6/u1pHS52JzCVUCY7Xc=;
        b=maJqJxfI35jWdkfLt9DRQM1OLtxE4tRX2iIrAQaYIxJlKF1QgHWlUhQ+c/U9osDHo1
         W27ey3mrTreC3EYDJsBhWUSeuW+ILUSc3gETemVsnmNCw5lclut+C8uJ1+KUA4qZFzcB
         9YretsiQ6tqgSPOhWBV5n5/KYGMkz8nfAO0fgOKkxr73KTFRhtEYsIA6AuVloVbeO7LL
         k1zVw5sR2EbQVLa7kG/UhrdHgoApeqOGibaeWev2nSEdep2YXmd/eTZX0tu7epaxEbkL
         4qp82RVggBxxQwHWtgI9m1aC2jaF9lWEBfY3njmfgPA5rPc+y75Tkkk/8Plu5PVXwgPf
         YYMg==
X-Forwarded-Encrypted: i=1; AJvYcCUgrGB4/+qAIlTRcK8XM/DlE0fGw6/VwriQQVSA7SQhsELvGuQ0Ez7pMeTywKLiAa983iubUeGFQTYi@vger.kernel.org, AJvYcCUmIJkokwSodIgeTcm4Ld2H9o9UOcGzoUZf/mR/+LjPmgQ4znA2VqGheyNo3yxn//qOoS5J+5X8DLLg1oNh@vger.kernel.org
X-Gm-Message-State: AOJu0YwBb33lH6AbbR1nc96blZTh9zSkjRpnyOsLMlCqoQaALBlnAn2t
	h46H6KXL/Z6MbM7+J9Huw9CG7KaIQJLxNMoCwFBf/gIYNUZTFimV6loz/3zrZLyYreoH9jA441f
	L674a4nW6QqZ1sPG+i6tThFOB+AdWCQ==
X-Google-Smtp-Source: AGHT+IE9GKNNZ0Mijfe3qxFEp1tC6/+XsIB9vbcTZaHbzQmj5vq6ibLMZdeW6gbCeXAQMnyqT55aN5g4NcKHeCKPU9o=
X-Received: by 2002:a2e:9a16:0:b0:2fa:d67a:ada7 with SMTP id
 38308e7fff4ca-2ff201b1d51mr27340911fa.23.1731125409243; Fri, 08 Nov 2024
 20:10:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007210214.102568-1-linux@treblig.org> <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
In-Reply-To: <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Nov 2024 22:09:58 -0600
Message-ID: <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath S M <bharathsm@microsoft.com>, 
	CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As an alternative, might be useful to see if this command still works
to Samba and/or older Windows (and e.g. enable an ioctl for it - might
have been useful in the past to old servers)

On Fri, Nov 8, 2024 at 10:06=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> No objections to this from me. Will add it to for next next in the next f=
ew days so can queue it for 6.13-rc
>
> On Thu, Nov 7, 2024, 3:11=E2=80=AFPM Dr. David Alan Gilbert <linux@trebli=
g.org> wrote:
>>
>> * linux@treblig.org (linux@treblig.org) wrote:
>> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
>> >
>> > CIFSSMBCopy() is unused, remove it.
>> >
>> > It seems to have been that way pre-git; looking in a historic
>> > archive, I think it landed around May 2004 in Linus'
>> > BKrev: 40ab7591J_OgkpHW-qhzZukvAUAw9g
>> > and was unused back then.
>> >
>> > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
>>
>> Ping?
>>
>> Dave
>>
>> > ---
>> >  fs/smb/client/cifsproto.h |  7 -----
>> >  fs/smb/client/cifssmb.c   | 63 --------------------------------------=
-
>> >  2 files changed, 70 deletions(-)
>> >
>> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>> > index 1d3470bca45e..8235b5a0aa2b 100644
>> > --- a/fs/smb/client/cifsproto.h
>> > +++ b/fs/smb/client/cifsproto.h
>> > @@ -549,13 +549,6 @@ extern int generate_smb311signingkey(struct cifs_=
ses *ses,
>> >                                    struct TCP_Server_Info *server);
>> >
>> >  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>> > -extern int CIFSSMBCopy(unsigned int xid,
>> > -                     struct cifs_tcon *source_tcon,
>> > -                     const char *fromName,
>> > -                     const __u16 target_tid,
>> > -                     const char *toName, const int flags,
>> > -                     const struct nls_table *nls_codepage,
>> > -                     int remap_special_chars);
>> >  extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tco=
n *tcon,
>> >                       const unsigned char *searchName,
>> >                       const unsigned char *ea_name, char *EAData,
>> > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
>> > index c6f15dbe860a..ca50ac652e02 100644
>> > --- a/fs/smb/client/cifssmb.c
>> > +++ b/fs/smb/client/cifssmb.c
>> > @@ -2339,69 +2339,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xi=
d, struct cifs_tcon *pTcon,
>> >       return rc;
>> >  }
>> >
>> > -int
>> > -CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
>> > -         const char *fromName, const __u16 target_tid, const char *to=
Name,
>> > -         const int flags, const struct nls_table *nls_codepage, int r=
emap)
>> > -{
>> > -     int rc =3D 0;
>> > -     COPY_REQ *pSMB =3D NULL;
>> > -     COPY_RSP *pSMBr =3D NULL;
>> > -     int bytes_returned;
>> > -     int name_len, name_len2;
>> > -     __u16 count;
>> > -
>> > -     cifs_dbg(FYI, "In CIFSSMBCopy\n");
>> > -copyRetry:
>> > -     rc =3D smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
>> > -                     (void **) &pSMBr);
>> > -     if (rc)
>> > -             return rc;
>> > -
>> > -     pSMB->BufferFormat =3D 0x04;
>> > -     pSMB->Tid2 =3D target_tid;
>> > -
>> > -     pSMB->Flags =3D cpu_to_le16(flags & COPY_TREE);
>> > -
>> > -     if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>> > -             name_len =3D cifsConvertToUTF16((__le16 *) pSMB->OldFile=
Name,
>> > -                                           fromName, PATH_MAX, nls_co=
depage,
>> > -                                           remap);
>> > -             name_len++;     /* trailing null */
>> > -             name_len *=3D 2;
>> > -             pSMB->OldFileName[name_len] =3D 0x04;     /* pad */
>> > -             /* protocol requires ASCII signature byte on Unicode str=
ing */
>> > -             pSMB->OldFileName[name_len + 1] =3D 0x00;
>> > -             name_len2 =3D
>> > -                 cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name=
_len+2],
>> > -                                    toName, PATH_MAX, nls_codepage, r=
emap);
>> > -             name_len2 +=3D 1 /* trailing null */  + 1 /* Signature w=
ord */ ;
>> > -             name_len2 *=3D 2; /* convert to bytes */
>> > -     } else {
>> > -             name_len =3D copy_path_name(pSMB->OldFileName, fromName)=
;
>> > -             pSMB->OldFileName[name_len] =3D 0x04;  /* 2nd buffer for=
mat */
>> > -             name_len2 =3D copy_path_name(pSMB->OldFileName+name_len+=
1, toName);
>> > -             name_len2++;    /* signature byte */
>> > -     }
>> > -
>> > -     count =3D 1 /* 1st signature byte */  + name_len + name_len2;
>> > -     inc_rfc1001_len(pSMB, count);
>> > -     pSMB->ByteCount =3D cpu_to_le16(count);
>> > -
>> > -     rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>> > -             (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>> > -     if (rc) {
>> > -             cifs_dbg(FYI, "Send error in copy =3D %d with %d files c=
opied\n",
>> > -                      rc, le16_to_cpu(pSMBr->CopyCount));
>> > -     }
>> > -     cifs_buf_release(pSMB);
>> > -
>> > -     if (rc =3D=3D -EAGAIN)
>> > -             goto copyRetry;
>> > -
>> > -     return rc;
>> > -}
>> > -
>> >  int
>> >  CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>> >                     const char *fromName, const char *toName,
>> > --
>> > 2.46.2
>> >
>> --
>>  -----Open up your eyes, open up your mind, open up your code -------
>> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \
>> \        dave @ treblig.org |                               | In Hex /
>>  \ _________________________|_____ http://www.treblig.org   |_______/
>>


--=20
Thanks,

Steve
