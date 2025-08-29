Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701414F9FB;
	Fri, 29 Aug 2025 13:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756472468; cv=none; b=hGuP456lIsqghQismgUXDrLivNvUqAymODQFEvT/L0Z2CAdrXeJyssdmV+fXZU6j63MkBtR89JSR1BZkV8oNuPpznVG8ZM17U92qovVlihh0iEvfsZpjUnngCUklXXvD38decDvclXjvIoDglNUywxo7Jjpt6RU9323LgmAM6p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756472468; c=relaxed/simple;
	bh=huEmYKtpngB9RmDN6wRbSbdKSJH3TWBnhI3yoCvi/xU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLnvVW6bSsGb8tl5KAPgF8z6s8c+wL+upzshnS1qzjBE806ZED176dnV68v+lTRe/DaxOrpJhRGh79St2hxAPSSB1nh9i9kzByb88zNwYf9xyMSRt6i0r5Go0GVxp96Wkv3d9vrzfqI1+kYS1bYuA2r6igz6EVRjGnHc8xmVKTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKCR9zTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKCR9zTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA3BC4CEF0;
	Fri, 29 Aug 2025 13:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756472467;
	bh=huEmYKtpngB9RmDN6wRbSbdKSJH3TWBnhI3yoCvi/xU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKCR9zTS39TL+CT4FGE3zmcte3Lcdogid/aX/TT42gdmxRnMM8Vh03urXpDNmisTH
	 nPAPmS6HghA0IL5LbeF/npNmFuR08fLNdXbfjfDTf5A9EjP31elTOvviQnIYx+ZiyK
	 1doh17YzPoR0JmUL8yg7T0Kly3iMpkMS55qBMpeYiWj98NGFGpvqy5yXerJDWDkVgR
	 v5B4mjPFKeTEg8svXIv1v/iKjwyD9u5IbUWFEDn8Syn8PzRyJHJFnRxBrtp8pXmGmC
	 aBboCCuNs6ai+OGuoHXK5++fwJpPJtsRR7wvTaYPDuaZCwouCFiIrG/apgP7EKoPuM
	 nzZabLanOV7RA==
Received: by pali.im (Postfix)
	id 6B11085D; Fri, 29 Aug 2025 15:01:04 +0200 (CEST)
Date: Fri, 29 Aug 2025 15:01:04 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
	Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Do not use UID and GID from EAs
Message-ID: <20250829130104.jtjp2jlmd6infvtc@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali>
 <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
 <20240917203431.w5dejuwfkmabrewz@pali>
 <CAN05THTVav8HOCk6V+5eg-BTESZDBx2BuQOF1c=Vn2dFv_UNxw@mail.gmail.com>
 <CAH2r5muUioziUN7mRFUAOV3tGPMLnb949j70GKYnRM2LygAWVQ@mail.gmail.com>
 <20250811105258.t3r65wsytkmyguem@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250811105258.t3r65wsytkmyguem@pali>
User-Agent: NeoMutt/20180716

On Monday 11 August 2025 12:52:58 Pali Rohár wrote:
> On Tuesday 17 September 2024 16:19:08 Steve French wrote:
> > On Tue, Sep 17, 2024 at 3:45 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > On Wed, 18 Sept 2024 at 06:37, Pali Rohár <pali@kernel.org> wrote:
> > > >
> > > > On Tuesday 17 September 2024 13:31:22 Jeremy Allison wrote:
> > > > > On Tue, Sep 17, 2024 at 10:29:21PM +0200, Pali Rohár wrote:
> > > > > > On Tuesday 17 September 2024 13:23:40 Jeremy Allison wrote:
> > > > > > > On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Rohár wrote:
> > > > > > > > And seems that SMB2_OP_QUERY_WSL_EA is useful not only for reparse
> > > > > > > > points, but also for any regular file or directory as it can contain
> > > > > > > > UNIX mode and UID/GID ownership.
> > > > > > >
> > > > > > > uid/gid should *never* be exposed over the wire for SMB.
> > > > > > >
> > > > > > > That way lies madness.
> > > > > >
> > > > > > Hello Jeremy, if I understood wsl_to_fattr() function correctly then it
> > > > > > is already doing it, it fills uid/gid for stat() from data which were
> > > > > > exposed over the wire for SMB. Could you check that function if it is
> > > > > > truth?
> > > > >
> > > > > I'm sure the Windows implementation is doing it - however, any Linux
> > > > > server implementations should not do this (IMHO).
> > > > >
> > > > > It will break all SID -> uid / gid mapping that servers must
> > > > > carefully set up.
> > > > >
> > > > > On the wire - SIDs must be the only source of identity.
> > > >
> > > > Ok. But then I do not understand why Linux client parses and uses uid
> > > > and gids which are sent over the wire. If you are saying that the SIDs
> > > > must be the only source of truth then Linux client should rather ignore
> > > > uid and gid values?
> > >
> > > What I think Jeremy is refering to is that mixing uids and sids in the
> > > protocol itself is
> > > a protocol design mistake.
> > > Because this means that some PDUs in the protocol operate on SIDs but
> > > others operate on
> > > UID/GIDs and this means there is great risk of mistakes and have the
> > > sid<->uid mapping return
> > > different results depending on the actual PDU.
> > >
> > > Sometimes the sid<->uid mapping happens in the server, at other times
> > > the mapping happens in the client
> > > and it is very difficult to guarantee that the mapping is consistent
> > > across PDUs in the protocol as well as across different clients.
> > 
> > Yes - agreed.
> > 
> > SIDs are globally unique and should always be used/sent over the wire
> > (never send or use the local uid/gid which is not guaranteed to be
> > unique).  Whether retrieving ownership information via
> > the SMB ACL or via an SMB3.1.1 POSIX response, the SID is the correct
> > thing to send/use in the protocol.  For cases where the client is not
> > domain joined, the UID/GID can be encoded in the SID, for cases that
> > are domain joined the Linux UIDs/GIDs can be mapped consistently via
> > the SID.
> > 
> > -- 
> > Thanks,
> > 
> > Steve
> 
> Hello Steve, based on the above discussion I'm proposing a change which
> stops parsing UID and GID values stored in EAs on the SMB server for
> SMB2 and SMB3 dialects. Change is in the attachment.
> 
> Steve, Ronnie, Jeremy and Paulo, could you review this change?

Hello, have you looked at the proposed change in the previous email?
