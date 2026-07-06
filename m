Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907EB43785F
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 22:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377592; cv=none; b=vGclfOnpHRejzCUt1raj7tMfCjHthmHs/63Y3kl2XHRJzSnfZToywgY+p37FrcTgylixnb99jHGJr4eoA0aHqHFbkESrNejmtUK9SaynGBe/f9I1eUNN9zHuZoZOvdI3LdpWQH8jS4tKw5snzGuDGXJ0VcYvUy9Hh9J8i0Lp/48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377592; c=relaxed/simple;
	bh=90eI05JZ45D5ov6QvIVjoUawmgZExMWEq5RId/7zlw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=il8C+GdvrWsK57jSlx97CKFI2nUhgWDgh3L2Yay9e5p9PQfME1zYwe+MxV3Ju4iH1XP4ChfqZ+ecPpYulPxiCP00XlwHpSJCWILLvHBbk9nieSvbfs71Bi0ceq6VShFadv19G7iY2OLX2mWV/XdiZR+7UXS/1ikYLvkz6kL0Hdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BO2+eL90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BO2+eL90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F591F00A3F;
	Mon,  6 Jul 2026 22:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783377591;
	bh=D35fZfjdPvMutz3m9JTyaKMKBkamMtR7udM6fJrddY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BO2+eL90mxqkGXSMPrI86zytcdp5Y94GMXXmCm4B+mSIHZEh7vjEm4FzO5K4lqPzv
	 3PSK/uDcoEbrfH9M6cHGt04ygB3nv+r94wPja1cWbV0EUJh/OVD3HMx5s6R8jtgbx7
	 gRdIOF19TJkcYYKdmWyQ5zshUrW+NFAip5pOMnK/OSSnQyAwY+zSlcIsmT9DIrwKTQ
	 ykgKRaWbqGexfPRUfN1sW94TXazjCzbl96V1F4Gn15lv3DzZz+GbKz91Aq8/i1/Gyp
	 kQq2+tKZyRlg8dTt5fhmjR9QTfWo99jPm9YXgi1eq+g30rf97cvFhG/d8gV/C8/QWA
	 SVECmdqA0o8vg==
Received: by pali.im (Postfix)
	id 4857C5D7; Tue,  7 Jul 2026 00:39:48 +0200 (CEST)
Date: Tue, 7 Jul 2026 00:39:48 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH RESEND 06/11] cifs: Validate presence of EA $LXMOD for
 WSL reparse points
Message-ID: <20260706223948.5tmkeq7tu5dk7uuv@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-7-pali@kernel.org>
 <CAH2r5mue0UYq0--B-6uUVg5zryhxuS82RKFfhMZ0_dJR0gVs4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mue0UYq0--B-6uUVg5zryhxuS82RKFfhMZ0_dJR0gVs4Q@mail.gmail.com>
User-Agent: NeoMutt/20180716

With this change applied, such nodes are recognized as "regular files" same as in WSL.

On Monday 06 July 2026 17:30:35 Steve French wrote:
> If this EA is missing, does Linux client still recognize it (not
> talking about WSL just what Linux client would see)?
> 
> On Mon, Jul 6, 2026 at 1:51 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > S_DT part of xattr $LXMOD is mandatory for all WSL reparse points except the
> > WSL symlink and Win32 socket. Microsoft WSL subsystem does not recognize
> > them without xattr $LXMOD too, and treat such inodes as regular files.
> >
> > Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
> > Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/reparse.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index 49a6a0cc2b61..99e93b56374f 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -1124,6 +1124,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
> >  {
> >         struct smb2_file_full_ea_info *ea;
> >         bool ignore_missing_eas = false;
> > +       bool have_xattr_mode = false;
> >         bool have_xattr_dev = false;
> >         umode_t reparse_mode_type = 0;
> >         u32 next = 0;
> > @@ -1183,6 +1184,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
> >                         if (S_DT(reparse_mode_type) != S_DT(le32_to_cpu(*(__le32 *)v)))
> >                                 return false;
> >                         fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
> > +                       have_xattr_mode = true;
> >                 } else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
> >                         fattr->cf_rdev = reparse_mkdev(v);
> >                         have_xattr_dev = true;
> > @@ -1194,6 +1196,16 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
> >         if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
> >                 return ignore_missing_eas;
> >
> > +       /*
> > +        * S_DT part of xattr MODE is mandatory for all WSL reparse points except the WSL symlink.
> > +        * Microsoft WSL does not recognize them without xattr MODE too (except the WSL symlink).
> > +        * IO_REPARSE_TAG_AF_UNIX is here an exception because this reparse point is used by both
> > +        * WSL subsystem and native NT/WinAPI subsystems. And NT/WinAPI creates AF UNIX socket
> > +        * without the xattr MODE and recognize it also without the xattr MODE.
> > +        */
> > +       if (!have_xattr_mode && (tag != IO_REPARSE_TAG_AF_UNIX && tag != IO_REPARSE_TAG_LX_SYMLINK))
> > +               return ignore_missing_eas;
> > +
> >         fattr->cf_mode |= reparse_mode_type;
> >         return true;
> >  }
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
