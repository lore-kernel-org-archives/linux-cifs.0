Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBD44A00
	for <linux-cifs@vger.kernel.org>; Thu, 13 Feb 2025 00:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739404967; cv=none; b=JQqhPLYof3CtcojOCbXz95vYkrgf5PshLHW2rhn2Svb/pgggjI4V0ndbe8Dge16weAQZlRwXd4co9DHIibSHrl9VU8JXQKbYci0QYIpRHDWNF+IhhliWhg636sfgJsNKRLQQ1ryoGEGKsiGkcl0UN4sXSiHZ3UTMifZw6VLmtXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739404967; c=relaxed/simple;
	bh=zUEPWKkju6VeWdQIR1zpSsKtVC96qgFa3bfvKiV4IX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkOpnVUy5Wwxed2A+wd81ODmFcmHNhg/dezJL6+n/09yZ0N0yp8/BYfA7FHkrPcVAAz6pNFmnW/WmQlBepCRguFVZxqA3uSDMUWCbec8Nhx1D2mrHBBrGoun4f2EgBF7Yz3KmU1SID8M1Nqtws7iBACz8wRjjLVGjurAOrQGoSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIowDGu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIowDGu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28FAC4CEDF;
	Thu, 13 Feb 2025 00:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739404967;
	bh=zUEPWKkju6VeWdQIR1zpSsKtVC96qgFa3bfvKiV4IX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIowDGu3PyHnVzL8CI57wIiDBYrFNAXTdvbXfs7VN8miXq+YKdzzgj+hCFANqOU5w
	 r0xZehVyY0seQnt0SCNfg4u0LNfRYuE46ri8Tmz+rPtCGWOUPthYiJ/8F0UauDWqfj
	 hHnOP+o8FN1aU68vyPUT7aL/bkMd3SbV98DeWO0e+kvkmAnePv5LRWIt2a/sRgWDI2
	 A6ghaPbHWltsgFr69O3kUdrFWb5mE17uOHN7y6FK0dw//++0Uv1EBQTNfEse46DcGm
	 kUzE5HVoQtTJGhT9dmr7vZrehQfBx0jlNXI50XSStMS5gc1rTiieMADMkrzaT5Jt8u
	 /48w+86d8Z3sA==
Received: by pali.im (Postfix)
	id 48B7040E; Thu, 13 Feb 2025 01:02:34 +0100 (CET)
Date: Thu, 13 Feb 2025 01:02:34 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250213000234.s5ugs57chvi7g7pa@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250212224330.g7wmpd225fripkit@pali>
 <ee932bc4f65b5d332c3f663aca64105e@manguebit.com>
 <CAH2r5mtzwOtokQjbX9NzzB6G==t5Wq3Xqz=-K+qqLuBnoKB15g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtzwOtokQjbX9NzzB6G==t5Wq3Xqz=-K+qqLuBnoKB15g@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Wednesday 12 February 2025 17:47:19 Steve French wrote:
> On Wed, Feb 12, 2025 at 4:58 PM Paulo Alcantara <pc@manguebit.com> wrote:
> >
> > Pali Rohár <pali@kernel.org> writes:
> >
> > > On Wednesday 12 February 2025 19:19:00 Paulo Alcantara wrote:
> > >> Pali Rohár <pali@kernel.org> writes:
> > >>
> > >> > On Wednesday 12 February 2025 17:49:31 Paulo Alcantara wrote:
> > >> >> Steve,
> > >> >>
> > >> >> The commit 438e2116d7bd ("cifs: Change translation of
> > >> >> STATUS_PRIVILEGE_NOT_HELD to -EPERM") regressed getcifsacl(1) because it
> > >> >> expects -EIO to be returned from getxattr(2) when the client can't read
> > >> >> system.cifs_ntsd_full attribute and then fall back to system.cifs_acl
> > >> >> attribute.  Either -EIO or -EPERM is wrong for getxattr(2), but that's a
> > >> >> different problem, though.
> > >> >>
> > >> >> Reproduced against samba-4.22 server.
> > >> >
> > >> > That is bad. I can prepare a fix for cifs.ko getxattr syscall to
> > >> > translate -EPERM to -EIO. This will ensure that getcifsacl will work as
> > >> > before as it would still see -EIO error.
> > >>
> > >> Sounds good.
> > >>
> > >> > But as discussed before, we need to distinguish between
> > >> > privilege/permission error and other generic errors (access/io).
> > >> > So I think that we need 438e2116d7bd commit.
> > >>
> > >> OK.
> > >>
> > >> > Based on linux-fsdevel discussion it is a good idea to distinguish
> > >> > between errors by mapping status codes to appropriate posix errno, and
> > >> > then updating linux syscall manpages.
> > >>
> > >> Either way, we shouldn't be leaking -EIO or -EPERM to userland from
> > >> getxattr(2).  By looking at the man pages, -ENODATA seems to be the
> > >> appropriate error to return instead.
> > >
> > > It looks like there are missing error codes for getxattr. Because any
> > > path based syscall can return -EACCES if trying to open path to which
> > > calling process does not have access.
> > >
> > > And EACCES is not mentioned nor documented in getxattr(2). Same applies
> > > for listxattr(2). Now I have tried listxattr() and it really returns
> > > EACCES for /root/file called by nobody.
> >
> > Both man pages have this:
> >
> >         > In addition, the errors documented in stat(2) can also occur.
> >
> > and stat(2) actually documents EACCES.
> >
> > > -EIO is generic I/O error. And I think that this error code could be
> > > returned by any I/O syscall when unknown I/O error occurs.
> >
> > Makes sense.
> >
> > > Returning -ENODATA for generic or unknown I/O error is a bad idea
> > > because ENODATA (= ENOATTR) has already specific meaning when attribute
> > > does not exists at all (or process does not have access to it).
> >
> > You are right.
> >
> > > For me it makes sense to return -EIO and -EPERM by those syscalls. But
> > > for getxattr() we cannot do it due that backward compatibility needed by
> > > getcifsacl application.
> >
> > -EACCES seems the correct one.  But yeah, we can't do it due to
> >  getcifsacl(1) relying on -EIO.
> 
> Since EIO is incorrect, we probably should fix getcifsacl ASAP so we
> can start returning something more correct for this call e.g. -EACCESS
> or -EPERM
> 
> Since updating cifs-utils for newer kernels is relatively easy (and
> the next version of cifs-utils has some security fixes so will be
> easier to rollout), why don't we also change getcifsacl ASAP to handle
> the correct rc to give us more freedom for cifs.ko to return the
> correct error on newer kernels.  Thoughts about this change to
> getcifsacl() function which would work with both old and newer kernels
> with the rc mapping change?  Change to fix the cifs.ko mapping to EIO
> could be delayed as well so cifs-utils with the updated check is
> rolled out?!

That should work too.

Anyway, if I'm looking correctly at that getcifsacl.c code, it contains
fallback from fetching SACL+DACL attribute (ATTRNAME_NTSD_FULL) to
DACL-only attribute.

And if the user does not have permission to access SACL then
STATUS_PRIVILEGE_NOT_HELD is returned by the SMB server.
STATUS_PRIVILEGE_NOT_HELD is being mapped to EPERM.

So EACCES should not be needed there.

If SMB server returns STATUS_ACCESS_DENIED (EACCES) then it means that
user does not have access to path or DACL, and so fallback from
SACL+DACL (ATTRNAME_NTSD_FULL) to DACL-only attribute is useless.

> diff --git a/getcifsacl.c b/getcifsacl.c
> index 123d11e..3c12789 100644
> --- a/getcifsacl.c
> +++ b/getcifsacl.c
> @@ -447,7 +447,8 @@ getxattr:
>                         free(attrval);
>                         bufsize += BUFSIZE;
>                         goto cifsacl;
> -               } else if (errno == EIO && !(strcmp(attrname,
> ATTRNAME_NTSD_FULL))) {
> +               } else if (((errno == EIO) || (errno == EPERM) ||
> (errno == EACCES)) &&
> +                          !(strcmp(attrname, ATTRNAME_NTSD_FULL))) {
>                         /*
>                          * attempt to fetch SACL in addition to owner
> and DACL via
>                          * ATTRNAME_NTSD_FULL, fall back to owner/DACL via
> 
> 
> 
> Thanks,
> 
> Steve
