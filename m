Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE094C69;
	Sun, 29 Sep 2024 22:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727648355; cv=none; b=obEptj867vuXFafEeBy9gHtodHAjuSdWSFTd72p0Lza7GJSSVjTuOn1WdXuLs5qpiEcQnKts9w9YpW/vtVz0odKsPp6dnku5li4sbHegSrNRbgm+WQzK9PNXzWvpukV86Hy6Db7BY3ZJlOnFGH0BfgzWrCmaztAiGbQpId1ZSmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727648355; c=relaxed/simple;
	bh=HI/OkCZ1Hgkt+Bgs7QEULJ4W+ZyNZ95EhUvyGeIIDkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdu6jjsv4P0dnk+p2LcaMGUNmnnOIxBG5Hq+7RAyt4cYpzKtCYgMPhm6IoXf/S0CDYbaQ30O5h4R+DADQjQC8QC1Cz5YYl+QEhLr5lgXtE7NkdrpvLsM9XwPcJEejmbniJfJwRB2I3ajMf2OGdomxr57yGqiawYO+a8bU2nqATA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P86dUwxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P86dUwxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E702C4CEC7;
	Sun, 29 Sep 2024 22:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727648354;
	bh=HI/OkCZ1Hgkt+Bgs7QEULJ4W+ZyNZ95EhUvyGeIIDkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P86dUwxiWjXyeWC2nCkPNnp1/mB3U50ls7jR8VxUA0B1H+4SlqLiCq0n/1sgB/ksH
	 BvCwLMU+tMmQMiRRn2w6acSfDbssUs/hsizj7CKImDUo897+jg6chN6D0DLngsVrEl
	 fRRdOxudSaA8VVTonNubTCARnwXUT6nLmRDgmUWRujZqMcQOaAAjBAWeGqk+FBaR05
	 fFWVM6DIOl1yTJ93Dsvr2sDyEpQrt+ftl+Qz31YghMCoTIADmhhi389iTACEfcQgor
	 oNcmC5F3O8Y0GNTFuxuU4PhFxw1c9wwmZYFslUjRBW0gj3kF8YDGuDhJjhRXACMSD6
	 5DY3MCLA8+ksw==
Received: by pali.im (Postfix)
	id D1D04872; Mon, 30 Sep 2024 00:19:08 +0200 (CEST)
Date: Mon, 30 Sep 2024 00:19:08 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] cifs: Validate content of native symlink
Message-ID: <20240929221908.skkup4ds6ow2s77x@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20240929185053.10554-7-pali@kernel.org>
 <CAH2r5mtRN04+X-J7C__qHL6S+VzFbWoRGdb=cBDQfDVLGgWwew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtRN04+X-J7C__qHL6S+VzFbWoRGdb=cBDQfDVLGgWwew@mail.gmail.com>
User-Agent: NeoMutt/20180716

I think that via pike it could be possible or via windows application
running locally (to create reparse point manually with prepared buffer
with such content). I will check it later.

Just a side note: Windows NT kernel allows for object names any
characters except backslash. For object names is not used nul-term
string, but rather string with explicit length. So even a null character
is a valid in a object name. NT NTFS driver has for file names more
restrictions and null is not valid. But it does not mean that somebody
can write own filesystem which allows null bytes in file names...
And this design of explicit lengths is also in SMB, so NT kernel may
export nul characters in symlink path buffers...

On Sunday 29 September 2024 16:48:46 Steve French wrote:
> Is there any easy way to create such a symlink (with null in it)?
> 
> On Sun, Sep 29, 2024 at 1:51 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > Check that buffer does not contain UTF-16 null codepoint
> > because Linux cannot process symlink with null byte.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/reparse.c | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index 5a738f65b190..ca4f96c43508 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -509,6 +509,16 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >         int rc;
> >         int i;
> >
> > +       /*
> > +        * Check that buffer does not contain UTF-16 null codepoint
> > +        * because Linux cannot process symlink with null byte.
> > +        */
> > +       if (unicode && UniStrnlen((wchar_t *)buf, len/2) != len/2) {
> > +               cifs_dbg(VFS, "srv returned null byte in native symlink target location\n");
> > +               rc = -EIO;
> > +               goto out;
> > +       }
> > +
> >         smb_target = cifs_strndup_from_utf16(buf, len, unicode, cifs_sb->local_nls);
> >         if (!smb_target) {
> >                 rc = -ENOMEM;
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
