Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A203B22071;
	Sat, 14 Sep 2024 06:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726294893; cv=none; b=TIQao4fQQ0uD2qBT3ZV6dv7aYIFMNaZWTkMdq7WVXya+o4unoM4EQmvQ0zEawvFWw0fHfdYynQmj20ZxvRKMhYsUwzux40V9RDi2SGntkgSwGC/tq12LpHfGvrzoI6oqjKtNwEuOBK0GWcUxqNZavV5gvbSAP3g49peLQT43OQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726294893; c=relaxed/simple;
	bh=WkMDuGdZXtQdX4Axd7GKeCsBR07A6JstNka7dRcJrq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DBDVD1Whwfbj51JGzMN9KLNigzEdwCjG40GuXevT58y2kBCcMvc3qBttbg/2creaaizrkFO6yhQ27A3mgt+9QyjMniLxQ/xvvWBGP+lPxaVZEKBeYe48lGgTJIXwiB2Tw0Tn58/Q0ZKKGbk6dM32UccxzOgkAacYK0RKRAHy700=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T74dUBYQ; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T74dUBYQ"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5c26815e174so1903103a12.0;
        Fri, 13 Sep 2024 23:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726294890; x=1726899690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joLOAVe4hRH3NR5iKNMj2U1MIz4Q2rmmeqog2vo7XzY=;
        b=T74dUBYQDTbO3pPY2u+IQmNxMPrufxnOyABIrbSFuatmgKFSmFWIwc6SBeFW6wFqT7
         OO13+XN5Eej2ACdA6iABLwzzAlP4SYb5ONUyrMukguCanN/JtSo0AArwfjQQdrtNxI7L
         fej4LVrS4S+jkcttfLkGmXFKNZRjksRiZxijIh6IYTjqvdQwAYLIPdUL+dQ8BX4Gj8e9
         KPyu+bp+YxeCrQ2D/J0wdwz+kwnbT3QdyMmX+/nO856nFSvI17lDiAcysb5LfHm4BeuL
         vVw1WUp5VzXbMyXWLtPmaPikMGKW+igwtfaKQdZylGFV5lCUssTeeSZrApV/m1eYCYTz
         nSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726294890; x=1726899690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joLOAVe4hRH3NR5iKNMj2U1MIz4Q2rmmeqog2vo7XzY=;
        b=GMyx0OBYAPN/Eby0VaxaDJbAYagcy/v5avtDNYOunFnDSZElXFAOUZNjn3Yv/lDVf5
         DFFCnyIZpA8E51UxLe8gcRu+eWsBWJutTk6TeE4H05g5E3STrHzQ9eYBPUuxyJ2ayYyr
         OOybJ67ucBqPipu0xejWtz33qabPqdXxezA/cBiAPfA3qaN3Z/jApFjaMC/om/UfSFLv
         139fJxfnKGk73WF75Mepz8l59cryDCGweesfxkBoO0V+Of2nn/r97XsPoZ37uROCWz3Q
         wNBEeDmFamzjJwT7K8PG3/Cuz6JexT+8r8Ry4AFM4x6O1POpeIeAzjb5IIsGDK0P3uTg
         VuYg==
X-Forwarded-Encrypted: i=1; AJvYcCUtZOvC+8zCe3qWY4KurE9AY4HpeN+XyHI3/3wbuxjsmUEwWXvZ30W6ZjFJWFWrdR9QKV+PtNKZ9i1Wmhs6@vger.kernel.org, AJvYcCW8JtgsWUkFu3WowRCks3W3jth5qVLMHChgWzpmd9YGpvrCw4mpzSE7GG+cXwuqlEymiycFyJE56lcd@vger.kernel.org
X-Gm-Message-State: AOJu0Yx606ZPOIo7ds585HtIo9DfyaGQMWRapkpZCO+p9N6K8ByWe/55
	lWRZWVWOkk6q++BKgba5eeIfSpBgS3CUDlsDrEGTi9nCdN5QeDy+5MmyK7Vaj988hEXHkWzLZqs
	lz6+iT9whDxhWdrvPDsCsrjJAFyk=
X-Google-Smtp-Source: AGHT+IHPRmAFZolwJZ5oqY2INKoSDpA+AYfALJsAgLM11B0l++07GMwzktEj6z/mMbRwWVRau9Bc6hiy0DbfFj027Hw=
X-Received: by 2002:a05:6402:909:b0:5c0:ac1d:b970 with SMTP id
 4fb4d7f45d1cf-5c41e1b52f7mr5049419a12.32.1726294889857; Fri, 13 Sep 2024
 23:21:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912120548.15877-1-pali@kernel.org> <20240912120548.15877-7-pali@kernel.org>
 <20240913200721.7egunkwp76qo5yy7@pali> <CAH2r5mvEa8mUrK7mEKFiimkb1asTWA0p7ADz4937yoxM916RAw@mail.gmail.com>
 <20240913224248.k5tn2le3gau2prmo@pali>
In-Reply-To: <20240913224248.k5tn2le3gau2prmo@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Sep 2024 01:21:17 -0500
Message-ID: <CAH2r5mtgV=NkZVChDY-apdqkvM9KFkraRGy_jDCpLmFU6PFMAA@mail.gmail.com>
Subject: Re: [PATCH 6/7] cifs: Fix creating of SFU fifo and socket special files
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 13, 2024 at 5:42=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Friday 13 September 2024 17:14:22 Steve French wrote:
> > How did you find the format of the FIFO and SOCK file types?  I
>
> For fifo there are multiple sources on internet, but none of them is
> normative. Everything is just what people have tried. For example this
> old email on samba list:
> https://lists.samba.org/archive/linux-cifs-client/2005-May/000856.html
>
> Format of the socket I have figured out by creating it in Interix
> subsystem and then dumped content of the file from Win32 subsystem.
> Then I checked that it has also same format over older MS NFS server.
> It was easier than trying to search for some documentation (which I have
> not found).
>
> > couldn't find any references to those so added two new types to allow
> > current Linux to be able to create these (especially since they are
> > opaque to the server and thus low risk).
>
> I was searching over internet again and now I have found patent
> https://patents.google.com/patent/US20090049459 which describe symlink
> content:
>
> #define NFS_SPECFILE_LNK_V1=E2=80=83=E2=80=830x014b4e4c78746e49 /* =E2=80=
=9CIntxLNK=E2=80=9D */
>
> But does not describe other types.
>
> > > +     case S_IFSOCK:
> > > -             strscpy(pdev.type, "LnxSOCK");
> > > +             /* SFU socket is system file with one zero byte */
> > > +             pdev_len =3D 1;
> > > +             pdev.type[0] =3D '\0';
> > >               break;
> > >       case S_IFIFO:
> > > -             strscpy(pdev.type, "LnxFIFO");
> > > +             /* SFU fifo is system file which is empty */
> > > +             pdev_len =3D 0;
> >
> > My worry about the suggested change above is that it is possible that
> > we could accidentally match to an empty file.
>
> I fully understand your concerns, but code in this patch is for creating
> new fifos. Not recognizing existing fifos.
>
> Code for recognizing existing fifos (=3Dempty file with system attribute)
> was not changed and is in Linux cifs client for a very long time.
<>
> > We intentionally added
> > the two new dev.type fields for these to avoid collisions with other
> > things (and since they are Linux specific).  It seems risky to have an
> > empty file with the system attribute marked as a FIFO, and similarly a
> > file with one byte null as Socket.   Since this is for only the Linux
> > client to recognize, I wanted to do something safe for those file
> > types less likely to be confusing (ie strings for Socket and FIFO that
> > were similar in length and format to the other special files seemed
> > intuitive) and "LnxFIFO" and LnxSOCK" were used as the tags in the
> > file to reduce confusion ie the tags for those two start with "Lnx" -
> > ie "something used for Linux client" not related to the original
> > Interix (those begin with "Intx").
>
> I see. Now I understand what are those types (as I have not seen them
> before). It is somehow misleading if such "LnxFIFO" and LnxSOCK"
> functionality is provided by SFU option, but is incompatible with MS SFU
> and also with MS NFS server. And is also incompatible with older Linux
> cifs clients (as they do not understand those Lnx types).

I am not as worried about FIFO and SOCK type being recognized by
older servers (since almost every use case for them would be for them
to be seen (only) by the client - e.g. for mounts to servers that
don't implement reparse points yet), and since they are less
common file types I am willing to let them be unrecognized by
old clients (we can tag them for stable if older distros don't have
them),  but I am concerned about allowing "current clients" to
create empty files for an unusual purpose which could be
confusing/non-intuitive.

And since this change (at least the one to allow FIFOs to be created with "=
sfu"
has been in mainline for a year and also since it uses a more intuitive tag
("LnxFIFO") than the empty one used by very old Windows) the only
clients who would have created these would be already using this newer tag
(older Linux clients couldn't have created such files - there seems more
risk of regression with reverting the change than with continuing with
the Linux client specific tag (at least to the one for FIFOs
since that has been in much longer than the socket one which is recent)

Will discuss with others - opinions welcome.

There is an upcoming SMB3.1.1 test event coming up next week (and the annua=
l
Storage Developer Conference too) so I can see if others have opinions one
way or another on whether to move to empty (or 1 byte) files for
creating fifos/sockets

> > Note that in the long run we hope to use reparse points by default in
> > more servers to store special files like this but there are a few
> > cases for unusual workloads that need special file support that would
> > have to use sfu still.  The newer reparse tags that Windows uses "WSL"
> > have the advantage that they require fewer roundtrips to query (since
> > the file type is in the reparse tag).
>
> Yes, new WSL tags seems to be better. Also SFU mount option is not
> activated by default.
>
> > Also noticed an interesting problem when mounted with "sfu" -
> > "smbgetinfo filebasicinfo /mnt/fifo1" will hang (in sys_open).  Is
> > that expected for a FIFO?
>
> Reading from fifo sleep reading process until some other process write
> data to fifo. This is how fifos are working. You can try it on local
> filesystem (e.g. ext4 or tmpfs).

makes sense - thx
