Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558442D12F6
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 03:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550140; cv=none; b=RYtL1zQNlvIjwwLHCmaeIY9kmdOnVoErHCmozRq9pNpsZGvlQrrTR1zs91Y27VfN9Iq0g0sBls8isqRVqzIFEvTmemULnBWKiDlqafkdpM40i5Pn9B260O03CsgJOhzJwy77ATDt8V6WxEbnxX9HOlBiReJcdySrNm6l2fBYRW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550140; c=relaxed/simple;
	bh=zqDs7NYinFlHW4QHDwPURzM6aFanyhgYzzkvtMQUXHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qXGJgZXR58xU4pp+iKrE6AmgWEEntG+/YEn2aRCWHPig+iOOAJigN28CaxnCw3c1TPHcJsD/JSa77a6iZW+ofVfEQZM0KuH6EEKW8D07cZM4Nq1GVRZu1PRL0SqUVz0vUGBqMKnl6Q2XDsBttyH1UPp7s778inMEob0rI7UI7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c7365Mko; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c7365Mko"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6fad3400ea3so47390596d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 20:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752550137; x=1753154937; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqEzZsmsg62sBSnAiJWNpUEjORuCe45Qu4nfZgH58IM=;
        b=c7365Mko86r8F9Xhbq9ne1QNQBR9HFvyhmoMvJ9pfad2U6hv1+V+GogJRdtoyKUrxA
         sZD5cdVXVz33jf3JLMUQsA7ixOBTgGNmehSOusmw/Jn10HWEoihsiHLSlURP5k42XEac
         lsOobBFnBJooR9z8oxYlKTw+AGGmdChj8C1np70jDIpCEQERKgDyy2A54cq1lBFCyoMu
         yiO6V5pvDoy4LROcv5yAcvvDXVegdeCCh8QRFGBWxN6Q5TG2smD6D3Umx0qBQTlVNEZu
         av1qAgLMD8UPkNc+utYLKSkC/4jNH+omxhwGv3PR0JAifRlSEP00Ng8okkCN/X0L/2mT
         /dGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752550137; x=1753154937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mqEzZsmsg62sBSnAiJWNpUEjORuCe45Qu4nfZgH58IM=;
        b=oqpxgYxrRGrOvyJwbPb1J9D7ikB6QR87NtJL7Am5ToN2h/tleG/Te7qYuutrtgCCyX
         xVrFFltilR3OKB7vuwoSq7977Da6jlc2pTUgic0wkD0MWhXeVy8jK5O/dAhYccBCFA0B
         t7igzJLA2BuKTG8+P1nPeAZkygUS/jzQtVyJQgIYBBGLJI2+P+gzBxO2yiS3FZk3gQ93
         qxVSbr5CPuVGqpkoiikYT2Rr/FavcmUc1I+RSmA61fZLtrNam2RnhZO7E+hT9MUXLMKn
         ezln34CIQCcC0hVvS4t9ccukDXz5Wa1byg89bf4AEDwu/e/NprIFLMqGXRA3pUlH+jBK
         993g==
X-Forwarded-Encrypted: i=1; AJvYcCWyMhXXH75vWyDZF9/6RsqVpbK3/q4su2YMN3lHYQKhmtGKJdWZYzT77x0PTHAUSQn3kyU7t05P+hP/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4ufkalzWXPaPV+y9RG3bP8m2bayCvx3FmFPZiKG3/BLc9K7N5
	9txs9RfVcOD3n53N/bnMX8Y0DnKTCv3oPOrH1Mrwnx7D9oydyX/RTfOtdrL766xro3uFFGFSYIS
	FioFh6XBy2EH5l2a5PZmCgamny/jPE2Y=
X-Gm-Gg: ASbGnct0bn3etTpEYMgBe320vND9qdi+IwVLR+QFKjHhXeM5CirQwKpi3pG9A+am4eZ
	F/6XLNng0pkI9OtpUMqm4SQffHMk2E6NpWYN9X6MccZheUxT4+mJmYqaCcFDuc34bPwoyUP9UCF
	dXEpZmhAASwow/wYRw0m7kLVP+0uJMMR51jHe+sqr7w7HrgqOJZyyG3hprxiVZukrMnomtvkywO
	ZQTAKwvkf/VN/4FwCXHkdExYoilKJ5gLXV0YX9HZg==
X-Google-Smtp-Source: AGHT+IF0Rn3q1simPIvhbc0vnwA4w5RWqXVNYySOA+fEZKvC427+ra0q/RqsKx1LlesxbDASpcGCRQNR+1Vwd2A95IA=
X-Received: by 2002:a05:6214:4886:b0:704:89cd:c43d with SMTP id
 6a1803df08f44-704a3540f3fmr253276826d6.3.1752550136986; Mon, 14 Jul 2025
 20:28:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation> <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org> <20250714165844.4hctlrwegfspiius@pali>
 <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
 <20250714192404.j3dw6l3afgm2voe6@pali> <CAH2r5msRGGHyy0GdNgVYBVN+8NzfevDS-wtzr9TO5jF5NmoxHQ@mail.gmail.com>
 <20250714211016.zqddwjdvybeplgdf@pali>
In-Reply-To: <20250714211016.zqddwjdvybeplgdf@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 14 Jul 2025 22:28:45 -0500
X-Gm-Features: Ac12FXzeMo16oQKxlQC3WIW26V776b5SlQIrn8XsokXtUJ90Q_6Vt8qypRQ8jXk
Message-ID: <CAH2r5mumdvhWTNOCEGV-dT8aQVJrUQEDep0GEBn_CbKF+o3kjQ@mail.gmail.com>
Subject: Re: Samba support for creating special files (via reparse points)
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>, 
	samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2025 at 4:10=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Monday 14 July 2025 15:30:26 Steve French wrote:
> > > But generally this is not Linux centric, but rather generic to any ot=
her
> > implementations.
> >
> >
> > If they are supporting the SMB311 Linux Extensions why wouldn't they wa=
nt
> > to support special files? All of the servers which currently support th=
e
> > extensions do
> > Thanks,
>
> Because of that possible filesystem limitation (like fat or proc or fuse)=
.

That is a moot point because even if the mount has FAT or FUSE mounts
under it, the server can still support reparse points on that share.  A sha=
re
often crosses fs type boundaries, so it is always going to be possible to
setup a share where creating special files will work for only some of the
subdirectories - but at least for those cases with the suggested change
we will return a more accurate return code (e.g. EACCES in some cases)


> > Steve
> >
> > On Mon, Jul 14, 2025, 2:24=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org>=
 wrote:
> >
> > > On Monday 14 July 2025 12:31:03 Steve French wrote:
> > > > > It does not matter if the client or server is POSIX or not. Also =
on
> > > > > POSIX systems there are filesystems without the support for speci=
al
> > > > > files and it is common scenario on more UNIX systems that for
> > > particular
> > > > > mount are special files completely disabled for security reasons.
> > > >
> > > > If it is disabled for security reasons, then probably better to sti=
ll
> > > > send the request and let the server return the correct return code
> > > > (e.g. access denied rather than "not supported").   But for Linux f=
s
> > > > the only examples I can think of where all special files are disabl=
ed
> > > > are VFAT and some pseudo-filesystems like /proc
> > >
> > > In case it is disabled for security reasons and server wants to annou=
nce
> > > that it is "available but disabled for security reasons" rather than
> > > "not support at all", then yes it makes sense to send the request and
> > > let it fail with ACCESS error with all those cleanup related issues.
> > > But in this case server should announce the support that it is availa=
ble
> > > for clients.
> > >
> > > In Linux it is not only VFAT. It is also slightly modern exfat. And a=
lso
> > > whatever is connected over fuse to userspace.
> > >
> > > But generally this is not Linux centric, but rather generic to any ot=
her
> > > implementations.
> > >
> > > > On Mon, Jul 14, 2025 at 11:58=E2=80=AFAM Pali Roh=C3=A1r <pali@kern=
el.org> wrote:
> > > > >
> > > > > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > > > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > > > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > > > > It's an oversight I'm afraid.
> > > > > > >
> > > > > > > hm... it seems reparse points support is mandatory for SMB3 P=
OSIX
> > > so I
> > > > > > > wonder what this additional checks buys us.
> > > > >
> > > > > No. It is not mandatory. Getting or setting of reparse points is =
done
> > > > > via IOCTLs which are optional. Also fs attribute for reparse poin=
ts is
> > > > > optional.
> > > > >
> > > > > And that make sense as there are still lot of filesystems which d=
o not
> > > > > support reparse points (e.g. FAT) and this fs attribute is exactl=
y what
> > > > > server announce for clients and applications to tell feature supp=
ort.
> > > > > So application would know what features are provided and which no=
t on
> > > > > particular share. Server can support reparse points on share A bu=
t does
> > > > > not have to support it on share B. E.g. when A is NTFS and B is F=
AT.
> > > > >
> > > > > > > While I agree that generally we should likely set this, for S=
MB3
> > > POSIX
> > > > > > > the client should probably not check this and we should keep =
it
> > > out of
> > > > > > > the spec.
> > > > > >
> > > > > > one additional thought: it seems like a valid scenario to be ab=
le to
> > > support
> > > > > > SMB3 POSIX on a server that does not support xattrs on the back=
ing
> > > > > > filesystem and hence may not have a way of storing arbitrary re=
parse
> > > points.
> > > > >
> > > > > xattrs and reparse points are two completely different things, an=
d they
> > > > > should not be mixed or exchanged.
> > > > >
> > > > > For example FAT on older Windows versions supported xattrs (I'm n=
ot
> > > sure
> > > > > if recent Windows version still support them), but does not and n=
ever
> > > > > supported reparse points.
> > > > >
> > > > > For checking if xattrs (in MS terminology called Extended Attribu=
tes or
> > > > > abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDED_ATTRIB=
UTES.
> > > > >
> > > > > Again, application can check if server share supports xattrs by t=
his
> > > > > fs attribute and decide what to do next.
> > > > >
> > > > > > In SMB3 POSIX we're just using them as a wire transport, not
> > > necessarily
> > > > > > expecting full support from the server.
> > > > > >
> > > > > > Hence, for Samba I see the following change
> > > > > >
> > > > > >     smbd: announce support for FILE_SUPPORTS_REPARSE_POINTS if =
the
> > > share
> > > > > > supports EAs
> > > > >
> > > > > FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) !=3D
> > > FILE_SUPPORTS_REPARSE_POINTS (0x80)
> > > > >
> > > > > > ---
> > > > > >  source3/smbd/vfs.c | 3 +++
> > > > > >  1 file changed, 3 insertions(+)
> > > > > >
> > > > > > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > > > > > index 76895f52e039..ea3fa4c8784f 100644
> > > > > > --- a/source3/smbd/vfs.c
> > > > > > +++ b/source3/smbd/vfs.c
> > > > > > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(struct
> > > > > > connection_struct *conn,
> > > > > >         if (lp_nt_acl_support(SNUM(conn))) {
> > > > > >                 caps |=3D FILE_PERSISTENT_ACLS;
> > > > > >         }
> > > > > > +       if (lp_ea_support(SNUM(conn))) {
> > > > > > +               caps |=3D FILE_SUPPORTS_REPARSE_POINTS;
> > > > > > +       }
> > > > > >
> > > > > >         caps |=3D lp_parm_int(SNUM(conn), "share", "fake_fscaps=
", 0);
> > > > > >
> > > > > > https://gitlab.com/samba-team/samba/-/merge_requests/4104
> > > > > >
> > > > > > For the client this would mean, it must allow reparse points fo=
r the
> > > special
> > > > > > files if SMB3 POSIX is negotiated.
> > > > > >
> > > > > > Makes sense?
> > > > > >
> > > > > > -slow
> > > > >
> > > > > I do not think that this is a good idea at all. It would just
> > > complicate
> > > > > things, make more incompatibilities and prevent using FAT or any =
other
> > > > > filesystem without mknod support, including cases when server its=
elf is
> > > > > configured to not support mknod for e.g. security reasons.
> > > > >
> > > > > FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute which says=
 if
> > > the
> > > > > reparse point of any type are supported. If it was decided that s=
pecial
> > > > > files, like fifos or character devices are represented as reparse
> > > points
> > > > > then for share/filesystem on which are special files supported, s=
erver
> > > > > has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > >
> > > > > And if the server itself supports special files, but particular
> > > > > filesystem like FAT does not support it, then server should not
> > > announce
> > > > > the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > >
> > > > > This is how it was designed and how it is used.
> > > > >
> > > > > It does not matter if the client or server is POSIX or not. Also =
on
> > > > > POSIX systems there are filesystems without the support for speci=
al
> > > > > files and it is common scenario on more UNIX systems that for
> > > particular
> > > > > mount are special files completely disabled for security reasons.
> > > > >
> > > > >
> > > > > So the result is that also when POSIX extensions are negotiated, =
it is
> > > > > important and required to know by POSIX client whether particular
> > > > > exported share supports reparse points / special files or not.
> > > > > And FILE_SUPPORTS_REPARSE_POINTS is already there for it.
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >



--=20
Thanks,

Steve
