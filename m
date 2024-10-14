Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25123154C0F;
	Mon, 14 Oct 2024 09:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898796; cv=none; b=PCXDjf7xNjwtPi60augIU5TO6gZa4TBYYPJmsi3feGQZZIIgI4EYZcbBEvHGMoIflbdZ+1fjMr5cqd4mSxOL8tmR5aRElIKTVNnGJ2W+ohT/PHd0GLTUBBOBnq50PjAZY1zoNh8lK2qLoDDg2fjU2vcVoaRJrsOUT8ZR/kM+G1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898796; c=relaxed/simple;
	bh=8vErmPJTnH/EWnq6JL6XfOpvhjpZ7bm6d6zMxJTq/+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/15RzakXtMqi1c7946bW7Jm5quG0g/tfvP2+yJDWRt898WeMYGMToFGaMQiQq0zQCPUpuIKh4xolXvf4xdCiMbt7P2qY9HTkuKXvYFnhc78kDA2AW36ABkx2YBT3fOo9M2qdsLMCm3xLXfDdNSefUMHhl70OAcCFUYMT9wTRfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O+Gye1bP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O+Gye1bP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D88BC4CEC3;
	Mon, 14 Oct 2024 09:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728898795;
	bh=8vErmPJTnH/EWnq6JL6XfOpvhjpZ7bm6d6zMxJTq/+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O+Gye1bPY4TZyiMuIfDPNQ5J9WioNOR7OdNSRj/ZXinEPDvyxorJpPsacvSumyft9
	 uTELYfNhX5c2jSXMJjEoWtcsTWc4Xe8RIwmgNGDeM1jZIVfTxuja/CAFbsyiXqS4Iv
	 EGc6s8vMJEg/FO+audOda2A/nDJvsNfzkG4AVnNNVlZhk3HmEIKZiHWfDKdA57UyGQ
	 bv+dmGWPoYDfx29Sk5yqoayQIjdIbrLXZ5Y40aeU26hqkLVdQZiHZkchJnBsaoIpbA
	 MDVXjdH9g+O1y1vNLqhC9ISrGB7zxNrJB9qO0H+W39Mon1RIBwlRcK5r9ebk5KeiVJ
	 q5fNTwbAspk6g==
Received: by pali.im (Postfix)
	id 65BA89DA; Mon, 14 Oct 2024 11:39:49 +0200 (CEST)
Date: Mon, 14 Oct 2024 11:39:49 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] cifs: Validate content of native symlink
Message-ID: <20241014093949.ea6egfoysw3gk5rs@pali>
References: <20240929185053.10554-1-pali@kernel.org>
 <20241005140300.19416-1-pali@kernel.org>
 <20241005140300.19416-6-pali@kernel.org>
 <CAH2r5mswCDw+rk-f5Tcd1niTz2prPNxbOfwyG_XSL5xRwRsbeg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mswCDw+rk-f5Tcd1niTz2prPNxbOfwyG_XSL5xRwRsbeg@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Saturday 12 October 2024 23:21:43 Steve French wrote:
> This looks like one of the more important of the fixes of this series
> - let me know if any thoughts or Reviewed-by/Acked-by on it.  I may
> try to send this earlier than the others
> 
> Pali,
> Let me know if I missed dependencies that this patch depends on

This one should be fine. I do not see any dependency for this change.

> On Sat, Oct 5, 2024 at 9:03 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > Check that path buffer has correct length (it is non-zero and in UNICODE
> > mode it has even number of bytes) and check that buffer does not contain
> > null character (UTF-16 null codepoint in UNICODE mode or null byte in
> > non-unicode mode) because Linux cannot process symlink with null byte.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/reparse.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> >
> > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > index 0d1cea64ab6e..fb1d16b17f38 100644
> > --- a/fs/smb/client/reparse.c
> > +++ b/fs/smb/client/reparse.c
> > @@ -544,6 +544,25 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
> >         int rc;
> >         int i;
> >
> > +       /* Check that length it valid for unicode/non-unicode mode */
> > +       if (!len || (unicode && (len % 2))) {
> > +               cifs_dbg(VFS, "srv returned malformed symlink buffer\n");
> > +               rc = -EIO;
> > +               goto out;
> > +       }
> > +
> > +       /*
> > +        * Check that buffer does not contain UTF-16 null codepoint in unicode
> > +        * mode or null byte in non-unicode mode because Linux cannot process
> > +        * symlink with null byte.
> > +        */
> > +       if ((unicode && UniStrnlen((wchar_t *)buf, len/2) != len/2) ||
> > +           (!unicode && strnlen(buf, len) != len)) {
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
