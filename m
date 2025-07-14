Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AEB222594
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 19:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752521048; cv=none; b=LloYC0NUHPBePbtYMngcyhA1RgMbCQW7Lqx9pVGd4fqMzfuVzGk4hX8vcOOHzXrjfrx6Vw1fm2elpKjM21xh4duNU04NuLXdZSG6UhfZspBwEEIHIQo2kmSweUp5Dud0iQUFp/9+E4EDBE2MrkIh/vntwhzKvPc9vy4zaet7Mlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752521048; c=relaxed/simple;
	bh=c7SuZqS+j2w9hKaHpjGptfcgt0V7BJ5GjbFB24gJ93E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJ0KPHVSiEVHo5ia36d1+Jp5bWE16gTQey80fV45/9QT70YW/T9IEhCnYSL6WLmnn2ein9ylg+g4MfUPnHCqIx0KM+Q4cAQ8PEzMxjsiQ8d3tY0EL3BylclzTRgWBt/NbTkwd7xtBGbzgb5FqSP5EeMZb2/iLIVeS7IF5JldKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tHnQvqXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tHnQvqXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C9FC4CEED;
	Mon, 14 Jul 2025 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752521047;
	bh=c7SuZqS+j2w9hKaHpjGptfcgt0V7BJ5GjbFB24gJ93E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tHnQvqXE8PGQXHs5XoXnUVFFk+blnwBIgbQC5NXvpyKiixJzWKpM8J2cAXhNfbDmo
	 zV5k+trFWj7Teo584kh9GGL9t1n5+nSyHwjwosRGjmcybbuZWwVd84mK6QtSQ15FEH
	 UBhW3vZS5I6ETUzkV1rKKqpVQm5UB2JjYkVSsePKihk4Mzl1IM9t5jX6DKII1KCAR6
	 VjgJYwydnwa3bebYT3aOTgmFE5B7fa88eq+V/Vlf/BNql9k59HbtfdaCHtqW5P8KNG
	 EgTZkIhgrG0kZpkzhbvrC2wiOcc4LKASgxlmJlA2S6Fkwyx1NQada0Sn7YnJtUUyo/
	 5FMQvO3IY6VqQ==
Received: by pali.im (Postfix)
	id 12137963; Mon, 14 Jul 2025 21:24:04 +0200 (CEST)
Date: Mon, 14 Jul 2025 21:24:04 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Jeremy Allison <jra@samba.org>,
	vl@samba.org, samba-technical <samba-technical@lists.samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Samba support for creating special files (via reparse points)
Message-ID: <20250714192404.j3dw6l3afgm2voe6@pali>
References: <CAH2r5muQGDkaHL78JOcgsfjL_=A64Xm9CrCBSKgOMABOjcg44w@mail.gmail.com>
 <CAH2r5msdLbvGMARXJ=V9wt0pvXJOrc=zh3eUfeF9AXEeshtByg@mail.gmail.com>
 <aHRo9VfMDIfK5MR6@jeremy-HP-Z840-Workstation>
 <42e549c1-0f92-4b95-b62b-3e0efab9aa10@samba.org>
 <5519b2d9-600c-4a3f-b44f-594877417df7@samba.org>
 <20250714165844.4hctlrwegfspiius@pali>
 <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5ms9Lt3h9q2B6VsbhkoM=_yEdpFXguiHRrrkbsrbkp6j=Q@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Monday 14 July 2025 12:31:03 Steve French wrote:
> > It does not matter if the client or server is POSIX or not. Also on
> > POSIX systems there are filesystems without the support for special
> > files and it is common scenario on more UNIX systems that for particular
> > mount are special files completely disabled for security reasons.
> 
> If it is disabled for security reasons, then probably better to still
> send the request and let the server return the correct return code
> (e.g. access denied rather than "not supported").   But for Linux fs
> the only examples I can think of where all special files are disabled
> are VFAT and some pseudo-filesystems like /proc

In case it is disabled for security reasons and server wants to announce
that it is "available but disabled for security reasons" rather than
"not support at all", then yes it makes sense to send the request and
let it fail with ACCESS error with all those cleanup related issues.
But in this case server should announce the support that it is available
for clients.

In Linux it is not only VFAT. It is also slightly modern exfat. And also
whatever is connected over fuse to userspace.

But generally this is not Linux centric, but rather generic to any other
implementations.

> On Mon, Jul 14, 2025 at 11:58 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > On Monday 14 July 2025 10:23:17 Ralph Boehme wrote:
> > > On 7/14/25 8:01 AM, Ralph Boehme via samba-technical wrote:
> > > > On 7/14/25 4:18 AM, Jeremy Allison wrote:
> > > > > It's an oversight I'm afraid.
> > > >
> > > > hm... it seems reparse points support is mandatory for SMB3 POSIX so I
> > > > wonder what this additional checks buys us.
> >
> > No. It is not mandatory. Getting or setting of reparse points is done
> > via IOCTLs which are optional. Also fs attribute for reparse points is
> > optional.
> >
> > And that make sense as there are still lot of filesystems which do not
> > support reparse points (e.g. FAT) and this fs attribute is exactly what
> > server announce for clients and applications to tell feature support.
> > So application would know what features are provided and which not on
> > particular share. Server can support reparse points on share A but does
> > not have to support it on share B. E.g. when A is NTFS and B is FAT.
> >
> > > > While I agree that generally we should likely set this, for SMB3 POSIX
> > > > the client should probably not check this and we should keep it out of
> > > > the spec.
> > >
> > > one additional thought: it seems like a valid scenario to be able to support
> > > SMB3 POSIX on a server that does not support xattrs on the backing
> > > filesystem and hence may not have a way of storing arbitrary reparse points.
> >
> > xattrs and reparse points are two completely different things, and they
> > should not be mixed or exchanged.
> >
> > For example FAT on older Windows versions supported xattrs (I'm not sure
> > if recent Windows version still support them), but does not and never
> > supported reparse points.
> >
> > For checking if xattrs (in MS terminology called Extended Attributes or
> > abbrev EAs) there is a fs attribute FILE_SUPPORTS_EXTENDED_ATTRIBUTES.
> >
> > Again, application can check if server share supports xattrs by this
> > fs attribute and decide what to do next.
> >
> > > In SMB3 POSIX we're just using them as a wire transport, not necessarily
> > > expecting full support from the server.
> > >
> > > Hence, for Samba I see the following change
> > >
> > >     smbd: announce support for FILE_SUPPORTS_REPARSE_POINTS if the share
> > > supports EAs
> >
> > FILE_SUPPORTS_EXTENDED_ATTRIBUTES (0x00800000) != FILE_SUPPORTS_REPARSE_POINTS (0x80)
> >
> > > ---
> > >  source3/smbd/vfs.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/source3/smbd/vfs.c b/source3/smbd/vfs.c
> > > index 76895f52e039..ea3fa4c8784f 100644
> > > --- a/source3/smbd/vfs.c
> > > +++ b/source3/smbd/vfs.c
> > > @@ -1345,6 +1345,9 @@ uint32_t vfs_get_fs_capabilities(struct
> > > connection_struct *conn,
> > >         if (lp_nt_acl_support(SNUM(conn))) {
> > >                 caps |= FILE_PERSISTENT_ACLS;
> > >         }
> > > +       if (lp_ea_support(SNUM(conn))) {
> > > +               caps |= FILE_SUPPORTS_REPARSE_POINTS;
> > > +       }
> > >
> > >         caps |= lp_parm_int(SNUM(conn), "share", "fake_fscaps", 0);
> > >
> > > https://gitlab.com/samba-team/samba/-/merge_requests/4104
> > >
> > > For the client this would mean, it must allow reparse points for the special
> > > files if SMB3 POSIX is negotiated.
> > >
> > > Makes sense?
> > >
> > > -slow
> >
> > I do not think that this is a good idea at all. It would just complicate
> > things, make more incompatibilities and prevent using FAT or any other
> > filesystem without mknod support, including cases when server itself is
> > configured to not support mknod for e.g. security reasons.
> >
> > FILE_SUPPORTS_REPARSE_POINTS is per-share fs attribute which says if the
> > reparse point of any type are supported. If it was decided that special
> > files, like fifos or character devices are represented as reparse points
> > then for share/filesystem on which are special files supported, server
> > has to announce the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> >
> > And if the server itself supports special files, but particular
> > filesystem like FAT does not support it, then server should not announce
> > the FILE_SUPPORTS_REPARSE_POINTS fs attribute.
> >
> > This is how it was designed and how it is used.
> >
> > It does not matter if the client or server is POSIX or not. Also on
> > POSIX systems there are filesystems without the support for special
> > files and it is common scenario on more UNIX systems that for particular
> > mount are special files completely disabled for security reasons.
> >
> >
> > So the result is that also when POSIX extensions are negotiated, it is
> > important and required to know by POSIX client whether particular
> > exported share supports reparse points / special files or not.
> > And FILE_SUPPORTS_REPARSE_POINTS is already there for it.
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
