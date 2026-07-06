Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BF81B4223
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 23:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378952; cv=none; b=uBMjo6bN7heV6FpGxkURz96YOZvH0pAUkqWDZMCI+CY9svRDZGCPI7LH3ofJtaB50mbJi6IaXx1S4rO9337uh7yHVuZW6iVjWFDvndzSCgd9h5pYTSj7BXsI5yWY6BJ3l+h5IhO3+FQoasm7CXxYjkJ2RIPiGNHIrlnTvBBB/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378952; c=relaxed/simple;
	bh=BH1E5/4QfF8OxZALIejI89+1+M3y6Q6yYIvFiTREhtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amJHdnmrPdRudbvW9Q1d6K0LIYjkkH2IqNE8vaYpoDArO+gX0XZQL8xKqnr8X+7eSEi3PAZ7NCTG8xDu7CHCAaOTSmq3If0yDKvkfUmEWQNyUbMYEa7hYMNQvr1Xt7ghPIPyNKGbqA0AS89FT3CrV3MAxDXWuORZeWjyoU9zmoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jyDmUBc7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jyDmUBc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE23E1F00A3A;
	Mon,  6 Jul 2026 23:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783378951;
	bh=ROace6Z7g1naMmzYooQ4frRXZnO5WZetYqkmDmh1cJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jyDmUBc7oYZWWl4/NxUdJxbcTblbFQPa7tkSGcv0kOonshb+EPyMLPd8slDV6UqF4
	 UMnZjdZqjzCjwPmxU2ny28ILpOoL/nwAhZt16hqKzmE8oHKLP/MStdYG/bT9ux01G1
	 81BfxS8Y1xFZud/4nqs+pCqr0GZ0VIBe0hNKAtL0D5UMcNntP3r4CdGMwES5S4swID
	 8tIoS9rGqxv+lYFMhoD4wp9jx+UclXtKXWn/sYnKX/iiQ7QdoTwChYlfyNYHqcqHTW
	 XfMgPQwIcAIG3QW1iOV8ck9WfsbdZzBEAcwOwXa9fX8Oe+sDWslYqdxhE4E/dmupv7
	 6trHomXauH3jg==
Received: by pali.im (Postfix)
	id 1F03C5D7; Tue,  7 Jul 2026 01:02:28 +0200 (CEST)
Date: Tue, 7 Jul 2026 01:02:28 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH RESEND 06/11] cifs: Validate presence of EA $LXMOD for
 WSL reparse points
Message-ID: <20260706230228.a574wmdy2kdigobh@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-7-pali@kernel.org>
 <CAH2r5mue0UYq0--B-6uUVg5zryhxuS82RKFfhMZ0_dJR0gVs4Q@mail.gmail.com>
 <20260706223948.5tmkeq7tu5dk7uuv@pali>
 <CAH2r5mu4LK8cgWHDb_EUpUHkZdD1EtoJcp_c7Zv0KGmibW+=2Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mu4LK8cgWHDb_EUpUHkZdD1EtoJcp_c7Zv0KGmibW+=2Q@mail.gmail.com>
User-Agent: NeoMutt/20180716

Without this change, Linux recognize some nodes as special files which
are not special at all (for WSL). With this change, the recognition is
aligned with the WSL. Those nodes which are special for WSL are
recognized as special also by Linux client. And those nodes which
regular files for WSL are also regular for Linux client.

So this is mostly alignment between MS WSL client and Linux client, to
ensure interoperability.

On Monday 06 July 2026 17:55:50 Steve French wrote:
> Without this change would Linux client recognize it more accurately?
> 
> On Mon, Jul 6, 2026 at 5:39 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > With this change applied, such nodes are recognized as "regular files" same as in WSL.
> >
> > On Monday 06 July 2026 17:30:35 Steve French wrote:
> > > If this EA is missing, does Linux client still recognize it (not
> > > talking about WSL just what Linux client would see)?
> > >
> > > On Mon, Jul 6, 2026 at 1:51 PM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > S_DT part of xattr $LXMOD is mandatory for all WSL reparse points except the
> > > > WSL symlink and Win32 socket. Microsoft WSL subsystem does not recognize
> > > > them without xattr $LXMOD too, and treat such inodes as regular files.
> > > >
> > > > Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
> > > > Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > ---
> > > >  fs/smb/client/reparse.c | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > >
> > > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > > index 49a6a0cc2b61..99e93b56374f 100644
> > > > --- a/fs/smb/client/reparse.c
> > > > +++ b/fs/smb/client/reparse.c
> > > > @@ -1124,6 +1124,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
> > > >  {
> > > >         struct smb2_file_full_ea_info *ea;
> > > >         bool ignore_missing_eas = false;
> > > > +       bool have_xattr_mode = false;
> > > >         bool have_xattr_dev = false;
> > > >         umode_t reparse_mode_type = 0;
> > > >         u32 next = 0;
> > > > @@ -1183,6 +1184,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
> > > >                         if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
> > > >                                 return false;
> > > >                         fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
> > > > +                       have_xattr_mode = true;
> > > >                 } else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
> > > >                         fattr->cf_rdev = reparse_mkdev(v);
> > > >                         have_xattr_dev = true;
> > > > @@ -1194,6 +1196,16 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
> > > >         if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
> > > >                 return ignore_missing_eas;
> > > >
> > > > +       /*
> > > > +        * S_DT part of xattr MODE is mandatory for all WSL reparse points except the WSL symlink.
> > > > +        * Microsoft WSL does not recognize them without xattr MODE too (except the WSL symlink).
> > > > +        * IO_REPARSE_TAG_AF_UNIX is here an exception because this reparse point is used by both
> > > > +        * WSL subsystem and native NT/WinAPI subsystems. And NT/WinAPI creates AF UNIX socket
> > > > +        * without the xattr MODE and recognize it also without the xattr MODE.
> > > > +        */
> > > > +       if (!have_xattr_mode && (tag != IO_REPARSE_TAG_AF_UNIX && tag != IO_REPARSE_TAG_LX_SYMLINK))
> > > > +               return ignore_missing_eas;
> > > > +
> > > >         fattr->cf_mode |= reparse_mode_type;
> > > >         return true;
> > > >  }
> > > > --
> > > > 2.20.1
> > > >
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
