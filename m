Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD922EBDDE;
	Mon,  6 Jul 2026 22:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378701; cv=none; b=K5CtsNOFF1WSSRqVDYeP4XMCyeqxY2Jme+P838kLbOWS1NhwsEPQS6oDHhY3aJ7kLPsFZegdL2p9Hvd7pacM+KxDG3pF7fdhjND/VkFfqqw/wL2g90TKMZbmVWrW2LsC7Q2dYnmv9h6axp8SMaKF8T7YfLtJ7iopD8/whMqi+60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378701; c=relaxed/simple;
	bh=419TmRsSOeoesDr1aIF/fvIGTd64Jpop2TshXNML6tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hT1NKzCija1J4WmEtbdZsMCQLLbjdHQAo0wrSnZSaj64HOff1uQ9d9OQ+/QWbKNLCYEnBRMQN+BOP2jOrc98rh2/8aLdMuHF7eRaQ7KX1XPHp0Cegne3g/Itq0yWM6w5Euz2wq710tr/JVKQqadzLavsWGmx4+gX6LvxTw7HqKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3Jxtea1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3Jxtea1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1488A1F000E9;
	Mon,  6 Jul 2026 22:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783378700;
	bh=a1lvud7FZviX9knGtFQuVvSpeAHUeQeqgWfRN+CjGV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L3Jxtea1GG6ryBEJM6Ms45J2iXeiDMZZ59l58YTTJGssYu/MYBvUXYeoK/E9oke/q
	 jk4z3tHuUO7S5W11EMf2dl13oAP0kwPonhA89bRj/L39fk8YMrLWlvOpAPLsu+6T25
	 e7wIz3EpAX/wQXX/IPntJbNURDrvHA19mgVQ7HXgVjO7OrUOUup6f+kh1qyzsDRmOd
	 j9gT/bzts+LljT2UcppCYHP91TqJhdetXns/lOcTQ0wVgJSwjFz1JCaFm6Q7qukoVY
	 urwr2ZXfKoavKbemS/cqcXRKgJkBu2SJ/CZzEtlAXWuGBLoNwizYA4IhNoNML2nuFS
	 lz2Ihel2OAG/Q==
Received: by pali.im (Postfix)
	id 3BE985D7; Tue,  7 Jul 2026 00:58:17 +0200 (CEST)
Date: Tue, 7 Jul 2026 00:58:17 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 07/11] cifs: Check if server supports EAs before
 trying to set it for WSL
Message-ID: <20260706225817.hideosulpvoelww5@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260706184819.22124-8-pali@kernel.org>
 <CAH2r5mvHgpVP=CxcBd6iygLzDr5cvvvh9_W7DbxzRJTN6H4FKA@mail.gmail.com>
 <20260706224236.4fm5ypvbq3z3fsqi@pali>
 <CAH2r5mvDGM7i8EsdPkW681a_AnXOAsHkg38eJqegO7g2gV8qAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvDGM7i8EsdPkW681a_AnXOAsHkg38eJqegO7g2gV8qAw@mail.gmail.com>
User-Agent: NeoMutt/20180716

It is not working even without this my patch.

mknod_wsl() is already setting the EAs and at the later stage,
mknod_wsl() will report an error if the EAs cannot be set. In EA is
present also the type of special file, and it is done for all types.

So this patch is not breaking it.

On Monday 06 July 2026 17:49:27 Steve French wrote:
> It should work for sockets (and symlink) without EAs right? So would the
> patch break that?
> 
> Thanks,
> 
> Steve
> 
> On Mon, Jul 6, 2026, 5:42 PM Pali Rohár <pali@kernel.org> wrote:
> 
> > If the server does not support EAs then setting the EAs (which is part
> > of the creating WSL special file) would fail and so WSL special file
> > would not be created. Major and minor numbers of char and block devices
> > is stored in the EAs and therefore without EAs support, it is not
> > possible to create and store char and block device nodes.
> >
> > On Monday 06 July 2026 17:33:42 Steve French wrote:
> > > If this were purely Linux, without this patch what would happen with
> > > creating special files if the server didn't support EAs.  Would some
> > > special files still work?
> > >
> > > On Mon, Jul 6, 2026 at 1:52 PM Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > WSL special files store information into EAs. When EAs are not
> > supported
> > > > on the server filesystem then fast fail in mknod_wsl() function.
> > > >
> > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > ---
> > > >  fs/smb/client/reparse.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > >
> > > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > > index 99e93b56374f..e2ea59a17c9c 100644
> > > > --- a/fs/smb/client/reparse.c
> > > > +++ b/fs/smb/client/reparse.c
> > > > @@ -668,6 +668,13 @@ static int mknod_wsl(unsigned int xid, struct
> > inode *inode,
> > > >         struct kvec reparse_iov, xattr_iov;
> > > >         int rc;
> > > >
> > > > +       /*
> > > > +        * WSL special files store information into EAs. When EAs are
> > not
> > > > +        * supported on the server filesystem then fast fail.
> > > > +        */
> > > > +       if (!(le32_to_cpu(tcon->fsAttrInfo.Attributes) &
> > FILE_SUPPORTS_EXTENDED_ATTRIBUTES))
> > > > +               return -EOPNOTSUPP;
> > > > +
> > > >         rc = wsl_set_reparse_buf(&buf, mode, symname, cifs_sb,
> > &reparse_iov);
> > > >         if (rc)
> > > >                 return rc;
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
> >
