Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792D7B672
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752609286; cv=none; b=RgWgAzozZy97tXt+M8le3S0ufivCHuD+zE6cuDmEPgekMmaBbAoeVB0Go59PD434m76j0e4Qak8DPrC3OhRoItIPzlu04Gost9iJkLqdUgZqHodd69HLFxpNYQ//U5jYlNZpfvxJGjMPaLUMlDudx7K7oqrcgARShidRYW5pg28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752609286; c=relaxed/simple;
	bh=FIpfiEwl/oHgCQyYGuMbwRkZjoSHDsUjxRKk8aNpjaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJJA59I81wGEmyjeoAV5vfZVrhk+VNfiotz9lns7CXC177bOFD22KoyINPdpaC5cr4MJTRWpFvdRIa5UzVDTvwPD783gVNo46UwK+91DxwIFDoRAhVnwUNNcbh60tWOATkrhKdD65dyAaMpwGoaY1n9jvJkyN5yueVlRJ7Gv26U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j4ypEnEV; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j4ypEnEV"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-702cbfe860cso55593946d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 12:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752609283; x=1753214083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qzRlcwXYg6AwwPiXWehxsYQ3+UfrM1J6NX9J6Fau04=;
        b=j4ypEnEVsRaWQyE8OfWcQYhLT7/t3Jlogr8Bo/+/9ehhWthn32xa8e2t2DINHL6tvG
         C3UgD4xj++Y1ek5cQEwDRNNDzvCvHgFClTTSM1sYSKoKx6IHpMjcLk6MU8DBmohHIbdB
         UUQJx9NahVe11e2MNIy+QskjIm71HmY1HUvcz7oHvSNC/RUBZf97KrhofWZtJgyRafnv
         R4YXbOy/xSupA/fQYEI6x2EbeuPtR/Gv6VuWbME1fARx2hBXWB32qBCP8hjz97utwsJn
         fXTPxhI1kF+rV6bKhS8Vl2dGUaMukcACucTZ7uqazrKvBHAThf7FJOhJX+U2tpiNbarY
         GiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752609283; x=1753214083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qzRlcwXYg6AwwPiXWehxsYQ3+UfrM1J6NX9J6Fau04=;
        b=Bw7BuylMrg0Dowp8hpuol5ukLT4w0dl0RuwSkBMkJSLDCq3J59QeoCa7Sajrsn01lR
         8pyn2v1ZcaE0DRIZu0muYBf1eDpf0IsvjIMenP/Z7HG0QjJauKuSj7DW15MyZbRbdf3I
         XF1/umEzIGilgJROG6yVQ9coANGdNuS3+MfPrLjMV1CKh7K+9044a/7Umpw9vkYYgWeX
         hCAZTVTz/3N6HQBN/XIml6XnUd4bSeSNrJhieiIyw0jfYgmIhCV05+iYgniSAXcsPh70
         13OdonIPL0LipfKYm9A+zplS91GIx5zrG9tVUU6w4rkUKBzOqpBKcnQGZpjFOL5xgKj/
         PBWA==
X-Forwarded-Encrypted: i=1; AJvYcCVB/yDmYp6R8APCxEfgKlXQpsihCy4o2bPDRScY+CUdB2Ea3PYOnOYAR2P+988YQgMlyjITJ24WwVUP@vger.kernel.org
X-Gm-Message-State: AOJu0YyrHhd62q70JDIFy429x4WSvLCMgolz6kFV8lbSK4N70yGcaZOI
	6IgkYqheeWaazqYwpbYvOIE/BdJOln3jRiEySDsV2H12uU5A/55jgcIyu+szYHPQ3kIYeg6OSX+
	sxj7E/nukL1/Vn70BIEwOwXOYmvcfblY=
X-Gm-Gg: ASbGncuo/I4o4f8UGNMBDMOOCbPWwn3vpRswgXxheauXFCvcfw9CZsDqdGo7zigtpeR
	1ahbKgXG/0Hg46M+pZClsl91ZPIHX7QJm0quGDGvlbNcJaTnILpxr2Vs/lVGx+z9JQVBm2HUmku
	x9cF6ELIj5pH6m2sUmwy8rRBhJ2x9Rk/9K0LT3Jyr+G4L0JmhFojjSDhwvI3SiVXYu3DeoMJ7vg
	nqIjQ==
X-Google-Smtp-Source: AGHT+IHe7gptNDXi9S0Ng4lUVo454Eurvj64qo/EpwernIpoMPhGGO8IhMleD+PDaRInXr9gA/AKjGpM5e3pXS7L5iA=
X-Received: by 2002:a05:6214:19cc:b0:701:9d0:1408 with SMTP id
 6a1803df08f44-704f4aac139mr9554436d6.20.1752609282320; Tue, 15 Jul 2025
 12:54:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org> <20250714165844.4hctlrwegfspiius@pali>
 <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
 <20250714192404.j3dw6l3afgm2voe6@pali> <CAH2r5msRGGHyy0GdNgVYBVN+8NzfevDS-wtzr9TO5jF5NmoxHQ@mail.gmail.com>
 <20250714211016.zqddwjdvybeplgdf@pali> <CAH2r5mumdvhWTNOCEGV-dT8aQVJrUQEDep0GEBn_CbKF+o3kjQ@mail.gmail.com>
 <20250715080911.julhkkcf7an56q4w@pali> <CAH2r5mvAuffmNwgJZ=n3m4aj4Xn45unK1ENPEdL_=pG-S3XHCw@mail.gmail.com>
 <20250715174321.7xko6gtmmlfsrjze@pali>
In-Reply-To: <20250715174321.7xko6gtmmlfsrjze@pali>
From: Steve French <smfrench@gmail.com>
Date: Tue, 15 Jul 2025 14:54:31 -0500
X-Gm-Features: Ac12FXxBPQm4VZa0owHddwyJD8Q9oSmIJzSDTS5AcY5a_H7OLOSFh7NOBQcGY4k
Message-ID: <CAH2r5muQPRjpzWFLNJirhNjJ=DyJNusg-oNYOtQdxc2d-A7Hog@mail.gmail.com>
Subject: Re: Samba support for creating special files (via reparse points)
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>, "vl@samba.org" <vl@samba.org>, 
	samba-technical <samba-technical@lists.samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2025 at 12:43=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> On Tuesday 15 July 2025 12:07:50 Steve French wrote:
> > On Tue, Jul 15, 2025 at 3:09=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> > >
> > > On Monday 14 July 2025 22:28:45 Steve French wrote:
> > > > On Mon, Jul 14, 2025 at 4:10=E2=80=AFPM Pali Roh=C3=A1r <pali@kerne=
l.org> wrote:
> > > > >
> > > > > On Monday 14 July 2025 15:30:26 Steve French wrote:
> > > > > > > But generally this is not Linux centric, but rather generic t=
o any other
> > > > > > implementations.
> > > > > >
> > > > > >
> > > > > > If they are supporting the SMB311 Linux Extensions why wouldn't=
 they want
> > > > > > to support special files? All of the servers which currently su=
pport the
> > > > > > extensions do
> > > > > > Thanks,
> > > > >
> > > > > Because of that possible filesystem limitation (like fat or proc =
or fuse).
> > > >
> > > > That is a moot point because even if the mount has FAT or FUSE moun=
ts
> > > > under it, the server can still support reparse points on that share=
.  A share
> > > > often crosses fs type boundaries, so it is always going to be possi=
ble to
> > > > setup a share where creating special files will work for only some =
of the
> > > > subdirectories - but at least for those cases with the suggested ch=
ange
> > > > we will return a more accurate return code (e.g. EACCES in some cas=
es)
> > >
> > > That is not fully truth. Crossing a mount point in mounted SMB share =
is
> > > signaled by the new mount point over SMB and so the SMB client is
> > > interpreting it like a new share and reading fs attributes for that
> >
> > That does not look correct.
> > I just tried this to Samba (mounting to the root of my laptop, and cd i=
nto
> > various subdirectories on various mounts with fs) and none of them trig=
gered
> > query fs information.
>
> I have tried it more times against Windows SMB server and it worked
> fine. I created mount point on SMB share, which is pointing to different
> filesystem on external disk with FAT and it is working fine on recent
> Windows Server 2022 and is working fine also on old Windows 2000. So
> seems that this is working fine for at least 25 years.
>
> I tried creating mount point via both GUI "diskmgmt.msc" tool (which
> allows to choose disk and then select mount point where to mount it on
> other disk e.g. C drive) and also via CLI "mountvol" command in cmd.exe,
> similar to UNIX mount command.
>
> If it does not work against Samba then it looks like Samba issue.

Not necessarily, but in any case until Windows supports SMB3.1.1 POSIX
extensions
it is moot point for the change to correctly check if SMB3.1.1 POSIX Extens=
ions
(not just check if the fsattr for supporting reparse points) is set.
Obviously a server
can (and will) support special files with SMB3.1.1 POSIX (emulating
them as reparse points over
the wire, but storing them however the server thinks is best) but some
will not support reparse points
generally (just in the narrow case for SMB3.1.1 POSIX Extensions)

> > > crossed path. Linux SMB client is already doing it and correctly hand=
les
> > > crossed mount points. It also shows crosses in the "mount" output.
> >
> > Looking at mount output I see no difference after crossing multiple
> > mount points under the same share, no automounts were created eg
> > and nothing new shows up in /proc/fs/cifs/DebugData or /proc/mounts
>
> When I accessed the mount point then I see a new line appeared in /proc/m=
ounts.
>
> And shell "stat" correctly shows different Device major/minor numbers
> for files inside the mount point and on the main share.

That is not the case to Samba (and presumably to some other servers as
well) although
it may be for Windows.   Windows handles junctions/links pointing to
different drives much
differently than Linux so am not surprised that the behavior differs.
> > > > > > Steve
> > > > > >
> > > > > > On Mon, Jul 14, 2025, 2:24=E2=80=AFPM Pali Roh=C3=A1r <pali@ker=
nel.org> wrote:
> > > > > >
> > > > > > > On Monday 14 July 2025 12:31:03 Steve French wrote:
> > > > > > > > > It does not matter if the client or server is POSIX or no=
t. Also on
> > > > > > > > > POSIX systems there are filesystems without the support f=
or special
> > > > > > > > > files and it is common scenario on more UNIX systems that=
 for
> > > > > > > particular
> > > > > > > > > mount are special files completely disabled for security =
reasons.
> > > > > > > >
> > > > > > > > If it is disabled for security reasons, then probably bette=
r to still
> > > > > > > > send the request and let the server return the correct retu=
rn code
> > > > > > > > (e.g. access denied rather than "not supported").   But for=
 Linux fs
> > > > > > > > the only examples I can think of where all special files ar=
e disabled
> > > > > > > > are VFAT and some pseudo-filesystems like /proc
> > > > > > >
> > > > > > > In case it is disabled for security reasons and server wants =
to announce
> > > > > > > that it is "available but disabled for security reasons" rath=
er than
> > > > > > > "not support at all", then yes it makes sense to send the req=
uest and
> > > > > > > let it fail with ACCESS error with all those cleanup related =
issues.
> > > > > > > But in this case server should announce the support that it i=
s available
> > > > > > > for clients.
> > > > > > >
> > > > > > > In Linux it is not only VFAT. It is also slightly modern exfa=
t. And also
> > > > > > > whatever is connected over fuse to userspace.
> > > > > > >
> > > > > > > But generally this is not Linux centric, but rather generic t=
o any other
> > > > > > > implementations.
> > > > > > >
> > > > > > > > On Mon, Jul 14, 2025 at 11:58=E2=80=AFAM Pali Roh=C3=A1r <p=
ali@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > > > > > > > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wr=
ote:
> > > > > > > > > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > > > > > > > > It's an oversight I'm afraid.
> > > > > > > > > > >
> > > > > > > > > > > hm... it seems reparse points support is mandatory fo=
r SMB3 POSIX
> > > > > > > so I
> > > > > > > > > > > wonder what this additional checks buys us.
> > > > > > > > >
> > > > > > > > > No. It is not mandatory. Getting or setting of reparse po=
ints is done
> > > > > > > > > via IOCTLs which are optional. Also fs attribute for repa=
rse points is
> > > > > > > > > optional.
> > > > > > > > >
> > > > > > > > > And that make sense as there are still lot of filesystems=
 which do not
> > > > > > > > > support reparse points (e.g. FAT) and this fs attribute i=
s exactly what
> > > > > > > > > server announce for clients and applications to tell feat=
ure support.
> > > > > > > > > So application would know what features are provided and =
which not on
> > > > > > > > > particular share. Server can support reparse points on sh=
are A but does
> > > > > > > > > not have to support it on share B. E.g. when A is NTFS an=
d B is FAT.
> > > > > > > > >
> > > > > > > > > > > While I agree that generally we should likely set thi=
s, for SMB3
> > > > > > > POSIX
> > > > > > > > > > > the client should probably not check this and we shou=
ld keep it
> > > > > > > out of
> > > > > > > > > > > the spec.
> > > > > > > > > >
> > > > > > > > > > one additional thought: it seems like a valid scenario =
to be able to
> > > > > > > support
> > > > > > > > > > SMB3 POSIX on a server that does not support xattrs on =
the backing
> > > > > > > > > > filesystem and hence may not have a way of storing arbi=
trary reparse
> > > > > > > points.
> > > > > > > > >
> > > > > > > > > xattrs and reparse points are two completely different th=
ings, and they
> > > > > > > > > should not be mixed or exchanged.
> > > > > > > > >
> > > > > > > > > For example FAT on older Windows versions supported xattr=
s (I'm not
> > > > > > > sure
> > > > > > > > > if recent Windows version still support them), but does n=
ot and never
> > > > > > > > > supported reparse points.
> > > > > > > > >
> > > > > > > > > For checking if xattrs (in MS terminology called Extended=
 Attributes or
> > > > > > > > > abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDE=
D_ATTRIBUTES.
> > > > > > > > >
> > > > > > > > > Again, application can check if server share supports xat=
trs by this
> > > > > > > > > fs attribute and decide what to do next.
> > > > > > > > >
> > > > > > > > > > In SMB3 POSIX we're just using them as a wire transport=
, not
> > > > > > > necessarily
> > > > > > > > > > expecting full support from the server.
> > > > > > > > > >
> > > > > > > > > > Hence, for Samba I see the following change
> > > > > > > > > >
> > > > > > > > > >     smbd: announce support for FILE_SUPPORTS_REPARSE_PO=
INTS if the
> > > > > > > share
> > > > > > > > > > supports EAs
> > > > > > > > >
> > > > > > > > > FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) !=3D
> > > > > > > FILE_SUPPORTS_REPARSE_POINTS (0x80)
> > > > > > > > >
> > > > > > > > > > ---
> > > > > > > > > >  source3/smbd/vfs.c | 3 +++
> > > > > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > > > >
> > > > > > > > > > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > > > > > > > > > index 76895f52e039..ea3fa4c8784f 100644
> > > > > > > > > > --- a/source3/smbd/vfs.c
> > > > > > > > > > +++ b/source3/smbd/vfs.c
> > > > > > > > > > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(=
struct
> > > > > > > > > > connection_struct *conn,
> > > > > > > > > >         if (lp_nt_acl_support(SNUM(conn))) {
> > > > > > > > > >                 caps |=3D FILE_PERSISTENT_ACLS;
> > > > > > > > > >         }
> > > > > > > > > > +       if (lp_ea_support(SNUM(conn))) {
> > > > > > > > > > +               caps |=3D FILE_SUPPORTS_REPARSE_POINTS;
> > > > > > > > > > +       }
> > > > > > > > > >
> > > > > > > > > >         caps |=3D lp_parm_int(SNUM(conn), "share", "fak=
e_fscaps", 0);
> > > > > > > > > >
> > > > > > > > > > https://gitlab.com/samba-team/samba/-/merge_requests/41=
04
> > > > > > > > > >
> > > > > > > > > > For the client this would mean, it must allow reparse p=
oints for the
> > > > > > > special
> > > > > > > > > > files if SMB3 POSIX is negotiated.
> > > > > > > > > >
> > > > > > > > > > Makes sense?
> > > > > > > > > >
> > > > > > > > > > -slow
> > > > > > > > >
> > > > > > > > > I do not think that this is a good idea at all. It would =
just
> > > > > > > complicate
> > > > > > > > > things, make more incompatibilities and prevent using FAT=
 or any other
> > > > > > > > > filesystem without mknod support, including cases when se=
rver itself is
> > > > > > > > > configured to not support mknod for e.g. security reasons=
.
> > > > > > > > >
> > > > > > > > > FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute wh=
ich says if
> > > > > > > the
> > > > > > > > > reparse point of any type are supported. If it was decide=
d that special
> > > > > > > > > files, like fifos or character devices are represented as=
 reparse
> > > > > > > points
> > > > > > > > > then for share/filesystem on which are special files supp=
orted, server
> > > > > > > > > has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attri=
bute.
> > > > > > > > >
> > > > > > > > > And if the server itself supports special files, but part=
icular
> > > > > > > > > filesystem like FAT does not support it, then server shou=
ld not
> > > > > > > announce
> > > > > > > > > the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> > > > > > > > >
> > > > > > > > > This is how it was designed and how it is used.
> > > > > > > > >
> > > > > > > > > It does not matter if the client or server is POSIX or no=
t. Also on
> > > > > > > > > POSIX systems there are filesystems without the support f=
or special
> > > > > > > > > files and it is common scenario on more UNIX systems that=
 for
> > > > > > > particular
> > > > > > > > > mount are special files completely disabled for security =
reasons.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > So the result is that also when POSIX extensions are nego=
tiated, it is
> > > > > > > > > important and required to know by POSIX client whether pa=
rticular
> > > > > > > > > exported share supports reparse points / special files or=
 not.
> > > > > > > > > And FILE_SUPPORTS_REPARSE_POINTS is already there for it.



--=20
Thanks,

Steve
