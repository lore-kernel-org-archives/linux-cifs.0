Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB22DA75C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 01:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761700931; cv=none; b=AKQP2Daq43mzLYbeNnZNL7Db94EEJVLS+iBAvLxpOKd6VB+ytAb99M11S1IMtxMBAd/FqwHRE8h+VuyRso9MJQLBrjIiNK8kb0u3cehSpFdZa94peqc8qx5nMG4UZ4y93X4zMB8Q/CUJ7EG8IuF+yPspsvGpq/u7DNLoicKgOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761700931; c=relaxed/simple;
	bh=S2b5v7BphY6UNVJ2EiK1amDcEL41Kn4BzKmEzDS1bPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dxwa//AajqBDqgspPiYaQYB+e6x6HFgmSOx236CRaRBnrFG/DV9yPye8dRbLoP6l7mUqKisee3qSGaql61MOpLjUt629WR2cs1+rPt9Gf8BJuiKJOWq0+/e6e8TncJMUsr/3G3WGrVie22l8aoeKK7Nv4LbmzmVql6WzO1mOKWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cmmNXX+J; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cmmNXX+J"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-78e4056623fso65777676d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 18:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761700926; x=1762305726; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDMKbwo4e1XYplcRaRCOO8BfBQzx6rO9UPIekWnQStQ=;
        b=cmmNXX+JNr/Gnq3dWWcwPSDn2SOe8wbmoksGD7tC0ksDmzqUCTDlug6wo0cFyKVk9g
         /YDZXezv5YjOg7hMnaQ9kuldjUjT5vQ2UUqDBd2+fBYUtcpJujyDLuZTulPK8IXTs9bu
         1lRtOVb6HPfJKfCKTJI3TLaQF6ds7Ssry8HZ3spvsxWl5TiDmtzGfWRnG5+912WLZ0b5
         45vjf+xDxR0npM4fHhZbJjJcN9Oy8R3uMB51Cwhx68q0O17QVrm5knuz3cyCjm19wUNG
         lIAOxca1HFliLmBJU7ZvWwSvJuTFSFM0o/7VZls8wBGaWqujJo6y9HI4cR7unaBwjnP4
         psEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761700926; x=1762305726;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KDMKbwo4e1XYplcRaRCOO8BfBQzx6rO9UPIekWnQStQ=;
        b=HY0lInEuUaySySh4GEs9l6UISaaqvKqJYN5gFbbdvGdJdrThOycNBD8EGpNj8NlJbF
         eWLIdBRfxWz57TwK7jhAef2IE/JBbzj32gS5SAmtDKlDCUNAoD3K1nvC2dkuWEIT8/Up
         HAFWKZ1ljaX/XMz2krcnrOloTETkvp+jCkhiaitjo2GED6rEwfaJNlLLiPi2Gvay93lw
         EBw/fMPhROZixnZF+dLJRHaHRcBzOXbVZANLjIIZ7mwEA+zNrVtK2QxovPaL3LSkQqxn
         8eeSyq5F+/buS0YhkC45DHBNKFYFCKVhLzabY121RYCeLdIYfpkxCJi3dHzEcmxGBETB
         jAVg==
X-Forwarded-Encrypted: i=1; AJvYcCUA6RKT9lA31bcmhnxTbbUbi1AHxZbWTgcosPg2DLmPOzNOUbEqiCyI6b1f3k+hV1YHpWhtNpjFkHYd@vger.kernel.org
X-Gm-Message-State: AOJu0Yzly9GLWo05xf11nz2kTLC/WersDUvPzxs+uACJS5DOY99dpEm6
	SUy0sSbH7Wy/ynx6+0N093d/c1FelWHfQBPnhmjDWjppBIf5M+5oaGCPWMPZqmlm3b5sVAffEh5
	erGibnMBGVZ+phjivaIhZZnriFsx/3xY=
X-Gm-Gg: ASbGncsJGn/EF7XDJ68XzEonWVnG4mCK7VEaUr6VV5LY/7RB6aiyWBfafMf/Ur6CHxe
	XFmP8N6CYESVLLwPCA9yHHt6R1MzmEk+gi7vQqhi8NxsADZkk4WkelKqZA/UfgV64h/+PQQQ76d
	lZEMf2twKEvTWZz08Ys6nbJqSfLclw5lhg7KTOb3T/evfQpx6VCB5uBuwDzUuHjI/2uE0nmjA6V
	AbpnNJ9ihdB3ZVVEB4DSxRWzXGrMNW5bNGrsOIULtWJBfiFAu/R9QhqGSHQERT6YW09cVIdweHk
	RB/hjDL0JLSiLd4JHkHlZ1SHUiS3og9gieGrOHCHq60UTGkpn0b0cwK2mxdjX6BKfSiay0RnjXO
	ndlNJiCUd6oBn8LhNdOTFwZ7wJpHm+6uIzmIgffixZA==
X-Google-Smtp-Source: AGHT+IEc4NH9t2lM8316gctKCNxkQBf44uEcgI7cN9zFY9sBvvVo/gPjLbVJjKj6gKmN8hD4y8bpxXEcJdTqrf1y0n4=
X-Received: by 2002:a05:6214:c6c:b0:87f:fea5:876e with SMTP id
 6a1803df08f44-88009ad5138mr15752506d6.10.1761700925829; Tue, 28 Oct 2025
 18:22:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027071316.3468472-7-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd_LqhpKCJAPKm0yBC-G+tTJpVQJSoTCbEN7Gdz1kMnQDg@mail.gmail.com>
 <CAH2r5mudENVd0MxrYCidsovUJsk0FheTgkUTXm34UT_+hGNz=g@mail.gmail.com>
 <713404c4-9bc0-4410-9004-5337b6b2ddee@linux.dev> <CAH2r5mv-NxRHr70Tt7kd4Wc89NCtUqqxj7HOtK7st1esNS5GAw@mail.gmail.com>
 <cd3c1e93-4830-4295-8d6b-56e4513617ec@linux.dev>
In-Reply-To: <cd3c1e93-4830-4295-8d6b-56e4513617ec@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Tue, 28 Oct 2025 20:21:52 -0500
X-Gm-Features: AWmQ_blCpEuJyiTo-ZKjyeYbP2wRXu-nut418-YDaDejGTqCsgc69LtAlp2IZ4o
Message-ID: <CAH2r5msK8h3Nr0Hme7b2LE+4VqvucNNKrcbEswT9XpS-3xX4uA@mail.gmail.com>
Subject: Re: [PATCH v4 06/24] smb: move file access permission bits
 definitions to common/smb1pdu.h
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>, 
	Namjae Jeon <linkinjeon@samba.org>, Christophe JAILLET <christophe.jaillet@wanadoo.fr>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One of the problems of course is balancing code readability and
minimizing difficult (to rebase on) changes where possible (so we
don't mess up backports to stable too much) with "we don't want smb1
confusing  highly secure smb3.1.1 code, and want smb1 code to be easy
to ignore and compile out"

On Tue, Oct 28, 2025 at 8:18=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Got it, thanks for your suggestion.
>
> On 10/28/25 10:56 PM, Steve French wrote:
> > The goal would be to have things (#defines flags, structs, code) only
> > used by smb1, thus not used by ksmbd (which doesn't support smb1, it is
> > only supported by cifs.ko and even then only when smb1 is enabled in
> > kernel config) in distinct headers (that wouldn't have to be in fs/smb/
> > common) so we don't ever confuse current secure smb311 code with smb1
> >
> > Thanks,
> >
> > Steve
> >
> > On Tue, Oct 28, 2025, 12:11=E2=80=AFAM ChenXiaoSong
> > <chenxiaosong.chenxiaosong@linux.dev
> > <mailto:chenxiaosong.chenxiaosong@linux.dev>> wrote:
> >
> >     Do you mean merging smb1pdu.h and smb2pdu.h into smbpdu.h?
> >
> >     On 10/28/25 11:54 AM, Steve French wrote:
> >      > We don't want to encourage smb1 so where possible things used fo=
r
> >     smb2
> >      > and later especially smb3 and later should never be in something
> >     that
> >      > sounds like smb1. ideally most of smb1 code could be ifdef out
> >     but also
> >      > we don't want to look like we require smb1
> >      >
> >      > Thanks,
> >      >
> >      > Steve
> >      >
> >      > On Mon, Oct 27, 2025, 11:37=E2=80=AFPM Namjae Jeon <linkinjeon@k=
ernel.org
> >     <mailto:linkinjeon@kernel.org>
> >      > <mailto:linkinjeon@kernel.org <mailto:linkinjeon@kernel.org>>> w=
rote:
> >      >
> >      >     On Mon, Oct 27, 2025 at 4:15=E2=80=AFPM
> >     <chenxiaosong.chenxiaosong@linux.dev
> >     <mailto:chenxiaosong.chenxiaosong@linux.dev>
> >      >     <mailto:chenxiaosong.chenxiaosong@linux.dev
> >     <mailto:chenxiaosong.chenxiaosong@linux.dev>>> wrote:
> >      >      >
> >      >      > From: ChenXiaoSong <chenxiaosong@kylinos.cn
> >     <mailto:chenxiaosong@kylinos.cn>
> >      >     <mailto:chenxiaosong@kylinos.cn
> >     <mailto:chenxiaosong@kylinos.cn>>>
> >      >      >
> >      >      > There are only 2 different definitions between the client
> >     and server:
> >      >      >
> >      >      >   - SET_FILE_READ_RIGHTS:
> >      >      >     - client: rename to CLIENT_SET_FILE_READ_RIGHTS
> >      >      >     - server: rename to SERVER_SET_FILE_READ_RIGHTS
> >      >      >   - SET_FILE_WRITE_RIGHTS
> >      >      >     - client: rename to CLIENT_SET_FILE_WRITE_RIGHTS
> >      >      >     - server: rename to SERVER_SET_FILE_WRITE_RIGHTS
> >      >      >
> >      >      > Perhaps in the future we can change them to be the same,
> >     move them to
> >      >      > common header file.
> >      >      >
> >      >      > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn
> >     <mailto:chenxiaosong@kylinos.cn>
> >      >     <mailto:chenxiaosong@kylinos.cn
> >     <mailto:chenxiaosong@kylinos.cn>>>
> >      >      > ---
> >      >      >  fs/smb/client/cifsacl.c    |   4 +-
> >      >      >  fs/smb/client/cifspdu.h    | 112
> >     ---------------------------------
> >      >      >  fs/smb/common/smb1pdu.h    | 123 +++++++++++++++++++++++=
+
> >     +++++++
> >      >     +++++-
> >      >      >  fs/smb/common/smb2pdu.h    |   6 --
> >      >      >  fs/smb/server/smb_common.h |  55 -----------------
> >      >      >  fs/smb/server/smbacl.c     |   2 +-
> >      >      >  6 files changed, 125 insertions(+), 177 deletions(-)
> >      >      >
> >      >      > diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifs=
acl.c
> >      >      > index ce2ebc213a1d..5c3d8eb68868 100644
> >      >      > --- a/fs/smb/client/cifsacl.c
> >      >      > +++ b/fs/smb/client/cifsacl.c
> >      >      > @@ -654,9 +654,9 @@ static void mode_to_access_flags(umod=
e_t
> >      >     mode, umode_t bits_to_use,
> >      >      >            is this but we have cleared all the bits sans
> >     RWX for
> >      >      >            either user or group or other as per bits_to_u=
se */
> >      >      >         if (mode & S_IRUGO)
> >      >      > -               *pace_flags |=3D SET_FILE_READ_RIGHTS;
> >      >      > +               *pace_flags |=3D CLIENT_SET_FILE_READ_RIG=
HTS;
> >      >      >         if (mode & S_IWUGO)
> >      >      > -               *pace_flags |=3D SET_FILE_WRITE_RIGHTS;
> >      >      > +               *pace_flags |=3D CLIENT_SET_FILE_WRITE_RI=
GHTS;
> >      >      >         if (mode & S_IXUGO)
> >      >      >                 *pace_flags |=3D SET_FILE_EXEC_RIGHTS;
> >      >      >
> >      >      > diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifs=
pdu.h
> >      >      > index 86167875574c..a063c98683bc 100644
> >      >      > --- a/fs/smb/client/cifspdu.h
> >      >      > +++ b/fs/smb/client/cifspdu.h
> >      >      > @@ -117,118 +117,6 @@
> >      >      >  #define SMBOPEN_OTRUNC        0x0002
> >      >      >  #define SMBOPEN_OAPPEND       0x0001
> >      >      >
> >      >      > -/*
> >      >      > - * These are the file access permission bits defined in
> >     CIFS for the
> >      >      > - * NTCreateAndX as well as the level 0x107
> >      >      > - * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107,
> >      >     SMB_QUERY_FILE_ALL_INFO
> >      >      > - * responds with the AccessFlags.
> >      >      > - * The AccessFlags specifies the access permissions a
> >     caller has
> >      >     to the
> >      >      > - * file and can have any suitable combination of the
> >     following
> >      >     values:
> >      >      > - */
> >      >      > -
> >      >      > -#define FILE_READ_DATA        0x00000001  /* Data can be=
 read
> >      >     from the file   */
> >      >      > -                                         /* or directory
> >     child
> >      >     entries can   */
> >      >      > -                                         /* be listed
> >     together
> >      >     with the      */
> >      >      > -                                         /* associated c=
hild
> >      >     attributes      */
> >      >      > -                                         /* (so the
> >      >     FILE_READ_ATTRIBUTES on  */
> >      >      > -                                         /* the child
> >     entry is
> >      >     not needed)   */
> >      >      > -#define FILE_WRITE_DATA       0x00000002  /* Data can be
> >     written
> >      >     to the file  */
> >      >      > -                                         /* or new file
> >     can be
> >      >     created in    */
> >      >      > -                                         /* the director=
y
> >      >                  */
> >      >      > -#define FILE_APPEND_DATA      0x00000004  /* Data can be
> >      >     appended to the file */
> >      >      > -                                         /* (for non-
> >     local files
> >      >     over SMB it */
> >      >      > -                                         /* is same as
> >      >     FILE_WRITE_DATA)      */
> >      >      > -                                         /* or new
> >     subdirectory
> >      >     can be       */
> >      >      > -                                         /* created in t=
he
> >      >     directory         */
> >      >      > -#define FILE_READ_EA          0x00000008  /* Extended
> >     attributes
> >      >     associated   */
> >      >      > -                                         /* with the fil=
e
> >     can be
> >      >     read        */
> >      >      > -#define FILE_WRITE_EA         0x00000010  /* Extended
> >     attributes
> >      >     associated   */
> >      >      > -                                         /* with the fil=
e
> >     can be
> >      >     written     */
> >      >      > -#define FILE_EXECUTE          0x00000020  /*Data can be =
read
> >      >     into memory from */
> >      >      > -                                         /* the file usi=
ng
> >      >     system paging I/O */
> >      >      > -                                         /* for executin=
g the
> >      >     file / script  */
> >      >      > -                                         /* or right to
> >     traverse
> >      >     directory   */
> >      >      > -                                         /* (but by
> >     default all
> >      >     users have   */
> >      >      > -                                         /* directory by=
pass
> >      >     traverse        */
> >      >      > -                                         /* privilege an=
d
> >     do not
> >      >     need this   */
> >      >      > -                                         /* permission o=
n
> >      >     directories at all)*/
> >      >      > -#define FILE_DELETE_CHILD     0x00000040  /* Child entry
> >     can be
> >      >     deleted from  */
> >      >      > -                                         /* the director=
y (so
> >      >     the DELETE on  */
> >      >      > -                                         /* the child
> >     entry is
> >      >     not needed)   */
> >      >      > -#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes
> >      >     associated with the   */
> >      >      > -                                         /* file or dire=
ctory
> >      >     can be read    */
> >      >      > -#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes
> >      >     associated with the   */
> >      >      > -                                         /* file or dire=
ctory
> >      >     can be written */
> >      >      > -#define DELETE                0x00010000  /* The file or
> >     dir can
> >      >     be deleted   */
> >      >      > -#define READ_CONTROL          0x00020000  /* The
> >     discretionary
> >      >     access control */
> >      >      > -                                         /* list and
> >     ownership
> >      >     associated    */
> >      >      > -                                         /* with the fil=
e
> >     or dir
> >      >     can be read */
> >      >      > -#define WRITE_DAC             0x00040000  /* The
> >     discretionary
> >      >     access control */
> >      >      > -                                         /* list
> >     associated with
> >      >     the file or */
> >      >      > -                                         /* directory ca=
n be
> >      >     written         */
> >      >      > -#define WRITE_OWNER           0x00080000  /* Ownership
> >      >     information associated */
> >      >      > -                                         /* with the fil=
e/dir
> >      >     can be written */
> >      >      > -#define SYNCHRONIZE           0x00100000  /* The file
> >     handle can
> >      >     waited on to */
> >      >      > -                                         /* synchronize
> >     with the
> >      >     completion  */
> >      >      > -                                         /* of an input/
> >     output
> >      >     request       */
> >      >      > -#define SYSTEM_SECURITY       0x01000000  /* The system
> >     access
> >      >     control list   */
> >      >      > -                                         /* associated
> >     with the
> >      >     file or      */
> >      >      > -                                         /* directory ca=
n be
> >      >     read or written */
> >      >      > -                                         /* (cannot be i=
n
> >     DACL,
> >      >     can in SACL) */
> >      >      > -#define MAXIMUM_ALLOWED       0x02000000  /* Maximal
> >     subset of
> >      >     GENERIC_ALL    */
> >      >      > -                                         /* permissions =
which
> >      >     can be granted */
> >      >      > -                                         /* (cannot be i=
n
> >     DACL
> >      >     nor SACL)     */
> >      >      > -#define GENERIC_ALL           0x10000000  /* Same as:
> >      >     GENERIC_EXECUTE |       */
> >      >      > -                                         /*
> >      >     GENERIC_WRITE |         */
> >      >      > -                                         /*
> >      >     GENERIC_READ |          */
> >      >      > -                                         /*
> >      >     FILE_DELETE_CHILD |     */
> >      >      > -                                         /*
> >     DELETE |
> >      >                  */
> >      >      > -                                         /*
> >     WRITE_DAC |
> >      >                   */
> >      >      > -                                         /*
> >      >     WRITE_OWNER             */
> >      >      > -                                         /* So GENERIC_A=
LL
> >      >     contains all bits */
> >      >      > -                                         /* mentioned ab=
ove
> >      >     except these two */
> >      >      > -                                         /* SYSTEM_SECUR=
ITY
> >      >     MAXIMUM_ALLOWED */
> >      >      > -#define GENERIC_EXECUTE       0x20000000  /* Same as:
> >      >     FILE_EXECUTE |          */
> >      >      > -                                         /*
> >      >     FILE_READ_ATTRIBUTES |  */
> >      >      > -                                         /*
> >      >     READ_CONTROL |          */
> >      >      > -                                         /*
> >      >     SYNCHRONIZE             */
> >      >      > -#define GENERIC_WRITE         0x40000000  /* Same as:
> >      >     FILE_WRITE_DATA |       */
> >      >      > -                                         /*
> >      >     FILE_APPEND_DATA |      */
> >      >      > -                                         /*
> >      >     FILE_WRITE_EA |         */
> >      >      > -                                         /*
> >      >     FILE_WRITE_ATTRIBUTES | */
> >      >      > -                                         /*
> >      >     READ_CONTROL |          */
> >      >      > -                                         /*
> >      >     SYNCHRONIZE             */
> >      >      > -#define GENERIC_READ          0x80000000  /* Same as:
> >      >     FILE_READ_DATA |        */
> >      >      > -                                         /*
> >      >     FILE_READ_EA |          */
> >      >      > -                                         /*
> >      >     FILE_READ_ATTRIBUTES |  */
> >      >      > -                                         /*
> >      >     READ_CONTROL |          */
> >      >      > -                                         /*
> >      >     SYNCHRONIZE             */
> >      >      > -
> >      >      > -#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA =
|
> >      >     FILE_READ_ATTRIBUTES)
> >      >      > -#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >     FILE_APPEND_DATA \
> >      >      > -                               | FILE_WRITE_EA |
> >      >     FILE_WRITE_ATTRIBUTES)
> >      >      > -#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> >      >      > -
> >      >      > -#define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ=
_EA |
> >      >     FILE_WRITE_EA \
> >      >      > -                               | FILE_READ_ATTRIBUTES \
> >      >      > -                               | FILE_WRITE_ATTRIBUTES \
> >      >      > -                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > -                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > -#define SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >     FILE_APPEND_DATA \
> >      >      > -                               | FILE_READ_EA |
> >     FILE_WRITE_EA \
> >      >      > -                               | FILE_READ_ATTRIBUTES \
> >      >      > -                               | FILE_WRITE_ATTRIBUTES \
> >      >      > -                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > -                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > -#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_=
EA |
> >      >     FILE_EXECUTE \
> >      >      > -                               | FILE_READ_ATTRIBUTES \
> >      >      > -                               | FILE_WRITE_ATTRIBUTES \
> >      >      > -                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > -                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > -
> >      >      > -#define SET_MINIMUM_RIGHTS (FILE_READ_EA |
> >     FILE_READ_ATTRIBUTES \
> >      >      > -                               | READ_CONTROL | SYNCHRON=
IZE)
> >      >      > -
> >      >      >  /*
> >      >      >   * Invalid readdir handle
> >      >      >   */
> >      >      > diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1=
pdu.h
> >      >      > index f14d3d9aac22..9fe6fc4b05a7 100644
> >      >      > --- a/fs/smb/common/smb1pdu.h
> >      >      > +++ b/fs/smb/common/smb1pdu.h
> >      >      > @@ -75,7 +75,128 @@
> >      >      >  #define SMBFLG2_UNICODE cpu_to_le16(0x8000)
> >      >      >
> >      >      >  /*
> >      >      > - * File Attribute flags
> >      >      > + * These are the file access permission bits defined in
> >     CIFS for the
> >      >      > + * NTCreateAndX as well as the level 0x107
> >      >      > + * TRANS2_QUERY_PATH_INFORMATION API.  The level 0x107,
> >      >     SMB_QUERY_FILE_ALL_INFO
> >      >      > + * responds with the AccessFlags.
> >      >      > + * The AccessFlags specifies the access permissions a
> >     caller has
> >      >     to the
> >      >      > + * file and can have any suitable combination of the
> >     following
> >      >     values:
> >      >      > + */
> >      >      > +
> >      >      > +#define FILE_READ_DATA        0x00000001  /* Data can be=
 read
> >      >     from the file   */
> >      >     Please don't move them to smb1pdu.h.
> >      >     These are common definitions that are also defined in the sm=
b2
> >      >     specification.
> >      >      > +                                         /* or directory
> >     child
> >      >     entries can   */
> >      >      > +                                         /* be listed
> >     together
> >      >     with the      */
> >      >      > +                                         /* associated c=
hild
> >      >     attributes      */
> >      >      > +                                         /* (so the
> >      >     FILE_READ_ATTRIBUTES on  */
> >      >      > +                                         /* the child
> >     entry is
> >      >     not needed)   */
> >      >      > +#define FILE_WRITE_DATA       0x00000002  /* Data can be
> >     written
> >      >     to the file  */
> >      >      > +                                         /* or new file
> >     can be
> >      >     created in    */
> >      >      > +                                         /* the director=
y
> >      >                  */
> >      >      > +#define FILE_APPEND_DATA      0x00000004  /* Data can be
> >      >     appended to the file */
> >      >      > +                                         /* (for non-
> >     local files
> >      >     over SMB it */
> >      >      > +                                         /* is same as
> >      >     FILE_WRITE_DATA)      */
> >      >      > +                                         /* or new
> >     subdirectory
> >      >     can be       */
> >      >      > +                                         /* created in t=
he
> >      >     directory         */
> >      >      > +#define FILE_READ_EA          0x00000008  /* Extended
> >     attributes
> >      >     associated   */
> >      >      > +                                         /* with the fil=
e
> >     can be
> >      >     read        */
> >      >      > +#define FILE_WRITE_EA         0x00000010  /* Extended
> >     attributes
> >      >     associated   */
> >      >      > +                                         /* with the fil=
e
> >     can be
> >      >     written     */
> >      >      > +#define FILE_EXECUTE          0x00000020  /*Data can be =
read
> >      >     into memory from */
> >      >      > +                                         /* the file usi=
ng
> >      >     system paging I/O */
> >      >      > +                                         /* for executin=
g the
> >      >     file / script  */
> >      >      > +                                         /* or right to
> >     traverse
> >      >     directory   */
> >      >      > +                                         /* (but by
> >     default all
> >      >     users have   */
> >      >      > +                                         /* directory by=
pass
> >      >     traverse        */
> >      >      > +                                         /* privilege an=
d
> >     do not
> >      >     need this   */
> >      >      > +                                         /* permission o=
n
> >      >     directories at all)*/
> >      >      > +#define FILE_DELETE_CHILD     0x00000040  /* Child entry
> >     can be
> >      >     deleted from  */
> >      >      > +                                         /* the director=
y (so
> >      >     the DELETE on  */
> >      >      > +                                         /* the child
> >     entry is
> >      >     not needed)   */
> >      >      > +#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes
> >      >     associated with the   */
> >      >      > +                                         /* file or dire=
ctory
> >      >     can be read    */
> >      >      > +#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes
> >      >     associated with the   */
> >      >      > +                                         /* file or dire=
ctory
> >      >     can be written */
> >      >      > +#define DELETE                0x00010000  /* The file or
> >     dir can
> >      >     be deleted   */
> >      >      > +#define READ_CONTROL          0x00020000  /* The
> >     discretionary
> >      >     access control */
> >      >      > +                                         /* list and
> >     ownership
> >      >     associated    */
> >      >      > +                                         /* with the fil=
e
> >     or dir
> >      >     can be read */
> >      >      > +#define WRITE_DAC             0x00040000  /* The
> >     discretionary
> >      >     access control */
> >      >      > +                                         /* list
> >     associated with
> >      >     the file or */
> >      >      > +                                         /* directory ca=
n be
> >      >     written         */
> >      >      > +#define WRITE_OWNER           0x00080000  /* Ownership
> >      >     information associated */
> >      >      > +                                         /* with the fil=
e/dir
> >      >     can be written */
> >      >      > +#define SYNCHRONIZE           0x00100000  /* The file
> >     handle can
> >      >     waited on to */
> >      >      > +                                         /* synchronize
> >     with the
> >      >     completion  */
> >      >      > +                                         /* of an input/
> >     output
> >      >     request       */
> >      >      > +#define SYSTEM_SECURITY       0x01000000  /* The system
> >     access
> >      >     control list   */
> >      >      > +                                         /* associated
> >     with the
> >      >     file or      */
> >      >      > +                                         /* directory ca=
n be
> >      >     read or written */
> >      >      > +                                         /* (cannot be i=
n
> >     DACL,
> >      >     can in SACL) */
> >      >      > +#define MAXIMUM_ALLOWED       0x02000000  /* Maximal
> >     subset of
> >      >     GENERIC_ALL    */
> >      >      > +                                         /* permissions =
which
> >      >     can be granted */
> >      >      > +                                         /* (cannot be i=
n
> >     DACL
> >      >     nor SACL)     */
> >      >      > +#define GENERIC_ALL           0x10000000  /* Same as:
> >      >     GENERIC_EXECUTE |       */
> >      >      > +                                         /*
> >      >     GENERIC_WRITE |         */
> >      >      > +                                         /*
> >      >     GENERIC_READ |          */
> >      >      > +                                         /*
> >      >     FILE_DELETE_CHILD |     */
> >      >      > +                                         /*
> >     DELETE |
> >      >                  */
> >      >      > +                                         /*
> >     WRITE_DAC |
> >      >                   */
> >      >      > +                                         /*
> >      >     WRITE_OWNER             */
> >      >      > +                                         /* So GENERIC_A=
LL
> >      >     contains all bits */
> >      >      > +                                         /* mentioned ab=
ove
> >      >     except these two */
> >      >      > +                                         /* SYSTEM_SECUR=
ITY
> >      >     MAXIMUM_ALLOWED */
> >      >      > +#define GENERIC_EXECUTE       0x20000000  /* Same as:
> >      >     FILE_EXECUTE |          */
> >      >      > +                                         /*
> >      >     FILE_READ_ATTRIBUTES |  */
> >      >      > +                                         /*
> >      >     READ_CONTROL |          */
> >      >      > +                                         /*
> >      >     SYNCHRONIZE             */
> >      >      > +#define GENERIC_WRITE         0x40000000  /* Same as:
> >      >     FILE_WRITE_DATA |       */
> >      >      > +                                         /*
> >      >     FILE_APPEND_DATA |      */
> >      >      > +                                         /*
> >      >     FILE_WRITE_EA |         */
> >      >      > +                                         /*
> >      >     FILE_WRITE_ATTRIBUTES | */
> >      >      > +                                         /*
> >      >     READ_CONTROL |          */
> >      >      > +                                         /*
> >      >     SYNCHRONIZE             */
> >      >      > +#define GENERIC_READ          0x80000000  /* Same as:
> >      >     FILE_READ_DATA |        */
> >      >      > +                                         /*
> >      >     FILE_READ_EA |          */
> >      >      > +                                         /*
> >      >     FILE_READ_ATTRIBUTES |  */
> >      >      > +                                         /*
> >      >     READ_CONTROL |          */
> >      >      > +                                         /*
> >      >     SYNCHRONIZE             */
> >      >      > +
> >      >      > +#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA =
|
> >      >     FILE_READ_ATTRIBUTES)
> >      >      > +#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >     FILE_APPEND_DATA \
> >      >      > +                               | FILE_WRITE_EA |
> >      >     FILE_WRITE_ATTRIBUTES)
> >      >      > +#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> >      >      > +
> >      >      > +#define CLIENT_SET_FILE_READ_RIGHTS (FILE_READ_DATA |
> >      >     FILE_READ_EA | FILE_WRITE_EA \
> >      >      > +                               | FILE_READ_ATTRIBUTES \
> >      >      > +                               | FILE_WRITE_ATTRIBUTES \
> >      >      > +                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > +                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > +#define SERVER_SET_FILE_READ_RIGHTS (FILE_READ_DATA |
> >     FILE_READ_EA \
> >      >      > +                               | FILE_READ_ATTRIBUTES \
> >      >      > +                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > +                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > +#define CLIENT_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >      >     FILE_APPEND_DATA \
> >      >      > +                               | FILE_READ_EA |
> >     FILE_WRITE_EA \
> >      >      > +                               | FILE_READ_ATTRIBUTES \
> >      >      > +                               | FILE_WRITE_ATTRIBUTES \
> >      >      > +                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > +                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > +#define SERVER_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >      >     FILE_APPEND_DATA \
> >      >      > +                               | FILE_WRITE_EA \
> >      >      > +                               | FILE_DELETE_CHILD \
> >      >      > +                               | FILE_WRITE_ATTRIBUTES \
> >      >      > +                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > +                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > +#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_=
EA |
> >      >     FILE_EXECUTE \
> >      >      > +                               | FILE_READ_ATTRIBUTES \
> >      >      > +                               | FILE_WRITE_ATTRIBUTES \
> >      >      > +                               | DELETE | READ_CONTROL |
> >     WRITE_DAC \
> >      >      > +                               | WRITE_OWNER | SYNCHRONI=
ZE)
> >      >      > +#define SET_MINIMUM_RIGHTS (FILE_READ_EA |
> >     FILE_READ_ATTRIBUTES \
> >      >      > +                               | READ_CONTROL | SYNCHRON=
IZE)
> >      >      > +
> >      >      > +/*
> >      >      > + * File Attribute flags - see MS-SMB 2.2.1.4.1
> >      >      >   */
> >      >      >  #define ATTR_READONLY  0x0001
> >      >      >  #define ATTR_HIDDEN    0x0002
> >      >      > diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2=
pdu.h
> >      >      > index f79a5165a7cc..f2fbd651ab8f 100644
> >      >      > --- a/fs/smb/common/smb2pdu.h
> >      >      > +++ b/fs/smb/common/smb2pdu.h
> >      >      > @@ -1149,12 +1149,6 @@ struct
> >     smb2_server_client_notification {
> >      >      >  #define FILE_OVERWRITE_IF_LE
> >       cpu_to_le32(0x00000005)
> >      >      >  #define FILE_CREATE_MASK_LE
> >       cpu_to_le32(0x00000007)
> >      >      >
> >      >      > -#define FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA =
\
> >      >      > -                       | FILE_READ_ATTRIBUTES)
> >      >      > -#define FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >     FILE_APPEND_DATA \
> >      >      > -                       | FILE_WRITE_EA |
> >     FILE_WRITE_ATTRIBUTES)
> >      >      > -#define FILE_EXEC_RIGHTS (FILE_EXECUTE)
> >      >      > -
> >      >      >  /* CreateOptions Flags */
> >      >      >  #define FILE_DIRECTORY_FILE_LE
> >       cpu_to_le32(0x00000001)
> >      >      >  /* same as #define CREATE_NOT_FILE_LE
> >     cpu_to_le32(0x00000001) */
> >      >      > diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/
> >     smb_common.h
> >      >      > index 810fad0303d7..df67b370025d 100644
> >      >      > --- a/fs/smb/server/smb_common.h
> >      >      > +++ b/fs/smb/server/smb_common.h
> >      >      > @@ -38,61 +38,6 @@
> >      >      >  #define F_CREATED      2
> >      >      >  #define F_OVERWRITTEN  3
> >      >      >
> >      >      > -#define FILE_READ_DATA        0x00000001  /* Data can be=
 read
> >      >     from the file   */
> >      >      > -#define FILE_WRITE_DATA       0x00000002  /* Data can be
> >     written
> >      >     to the file  */
> >      >      > -#define FILE_APPEND_DATA      0x00000004  /* Data can be
> >      >     appended to the file */
> >      >      > -#define FILE_READ_EA          0x00000008  /* Extended
> >     attributes
> >      >     associated   */
> >      >      > -/* with the file can be read        */
> >      >      > -#define FILE_WRITE_EA         0x00000010  /* Extended
> >     attributes
> >      >     associated   */
> >      >      > -/* with the file can be written     */
> >      >      > -#define FILE_EXECUTE          0x00000020  /*Data can be =
read
> >      >     into memory from */
> >      >      > -/* the file using system paging I/O */
> >      >      > -#define FILE_DELETE_CHILD     0x00000040
> >      >      > -#define FILE_READ_ATTRIBUTES  0x00000080  /* Attributes
> >      >     associated with the   */
> >      >      > -/* file can be read                 */
> >      >      > -#define FILE_WRITE_ATTRIBUTES 0x00000100  /* Attributes
> >      >     associated with the   */
> >      >      > -/* file can be written              */
> >      >      > -#define DELETE                0x00010000  /* The file ca=
n be
> >      >     deleted          */
> >      >      > -#define READ_CONTROL          0x00020000  /* The access
> >     control
> >      >     list and      */
> >      >      > -/* ownership associated with the    */
> >      >      > -/* file can be read                 */
> >      >      > -#define WRITE_DAC             0x00040000  /* The access
> >     control
> >      >     list and      */
> >      >      > -/* ownership associated with the    */
> >      >      > -/* file can be written.             */
> >      >      > -#define WRITE_OWNER           0x00080000  /* Ownership
> >      >     information associated */
> >      >      > -/* with the file can be written     */
> >      >      > -#define SYNCHRONIZE           0x00100000  /* The file
> >     handle can
> >      >     waited on to */
> >      >      > -/* synchronize with the completion  */
> >      >      > -/* of an input/output request       */
> >      >      > -#define GENERIC_ALL           0x10000000
> >      >      > -#define GENERIC_EXECUTE       0x20000000
> >      >      > -#define GENERIC_WRITE         0x40000000
> >      >      > -#define GENERIC_READ          0x80000000
> >      >      > -/* In summary - Relevant file       */
> >      >      > -/* access flags from CIFS are       */
> >      >      > -/* file_read_data, file_write_data  */
> >      >      > -/* file_execute, file_read_attributes*/
> >      >      > -/* write_dac, and delete.           */
> >      >      > -
> >      >      > -#define SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ=
_EA \
> >      >      > -               | FILE_READ_ATTRIBUTES \
> >      >      > -               | DELETE | READ_CONTROL | WRITE_DAC \
> >      >      > -               | WRITE_OWNER | SYNCHRONIZE)
> >      >      > -#define SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA |
> >     FILE_APPEND_DATA \
> >      >      > -               | FILE_WRITE_EA \
> >      >      > -               | FILE_DELETE_CHILD \
> >      >      > -               | FILE_WRITE_ATTRIBUTES \
> >      >      > -               | DELETE | READ_CONTROL | WRITE_DAC \
> >      >      > -               | WRITE_OWNER | SYNCHRONIZE)
> >      >      > -#define SET_FILE_EXEC_RIGHTS (FILE_READ_EA | FILE_WRITE_=
EA |
> >      >     FILE_EXECUTE \
> >      >      > -               | FILE_READ_ATTRIBUTES \
> >      >      > -               | FILE_WRITE_ATTRIBUTES \
> >      >      > -               | DELETE | READ_CONTROL | WRITE_DAC \
> >      >      > -               | WRITE_OWNER | SYNCHRONIZE)
> >      >      > -
> >      >      > -#define SET_MINIMUM_RIGHTS (FILE_READ_EA |
> >     FILE_READ_ATTRIBUTES \
> >      >      > -               | READ_CONTROL | SYNCHRONIZE)
> >      >      > -
> >      >      >  /* generic flags for file open */
> >      >      >  #define GENERIC_READ_FLAGS     (READ_CONTROL |
> >     FILE_READ_DATA | \
> >      >      >                 FILE_READ_ATTRIBUTES | \
> >      >      > diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbac=
l.c
> >      >      > index 5aa7a66334d9..b70ba50f1f10 100644
> >      >      > --- a/fs/smb/server/smbacl.c
> >      >      > +++ b/fs/smb/server/smbacl.c
> >      >      > @@ -180,7 +180,7 @@ static void mode_to_access_flags(umod=
e_t
> >      >     mode, umode_t bits_to_use,
> >      >      >          * either user or group or other as per bits_to_u=
se
> >      >      >          */
> >      >      >         if (mode & 0444)
> >      >      > -               *pace_flags |=3D SET_FILE_READ_RIGHTS;
> >      >      > +               *pace_flags |=3D SERVER_SET_FILE_READ_RIG=
HTS;
> >      >      >         if (mode & 0222)
> >      >      >                 *pace_flags |=3D FILE_WRITE_RIGHTS;
> >      >      >         if (mode & 0111)
> >      >      > --
> >      >      > 2.43.0
> >      >      >
> >      >
> >
> >     --
> >     Thanks,
> >     ChenXiaoSong.
> >
>
> --
> Thanks,
> ChenXiaoSong.
>


--=20
Thanks,

Steve
