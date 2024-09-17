Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D160A2AEEE;
	Tue, 17 Sep 2024 20:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726605090; cv=none; b=MeVQYJlLXaE5EF6WLq4PHucOBqIgbDMcdaBRRe33Tm70XoyCKrl+Qt71pbHM2ZLqTtxwigfPsdKLgFoP25XmlrjHKPhhux/ok+1NBLFiGO+2NEJhXhO+7LX5zx5hJuUQRMNDBFlN2rPrlDqISOVXzUjk1ZfE/iQIzwDKglNNJFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726605090; c=relaxed/simple;
	bh=wCRHKWsQQVGDDRn1uU4C9FYDnNKWfqS/Ul/N88f0JiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmIH/pnGvJ9ufdmkiIQxZXc4fLwGwyGToTslmPPU/iVGcdkGb3b+YssVw4kHWFxsm86m4L1OZnT4xX7PlKT+3/xEit5BbWzbZQJW4N1xzAc0J9DInVhcPrDpzYpQfaOmkhwe+h8J6NFC1eSwaQLaXffntEKuiiSJR0bfQq4DRW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=h8G/a6Zm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="h8G/a6Zm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=wCRHKWsQQVGDDRn1uU4C9FYDnNKWfqS/Ul/N88f0JiE=; b=h8G/a6ZmcKCLyey0e6iKa2+GBD
	cEfLHIr/4ZRYs247juq8gb+f7oUrUnA7tZ7ojbKwKwhPnmWVcExny+1nIYCv+tMsMwqQBe7aKQU70
	HpexkuR0YYGoNbF41wDce8xtvvnLgrb+lPSoYz0l2+7tLklnzrY4Stg3JiFGcU/Wfvhu0DpPdX9I0
	fE1idIklwO7lGWjUdMfVlY5Pt8fTZkHpjdSDUVJN3l0xC+qNJTaUaoJIteXi0Q6Fir3PtWH9wmQdE
	/uJ4OuJD38ymGvBpwoXohvis8K3dOWBSYx3S+L7x1hK6/E8nubFgNlxzhRVVq5GO87W4H9rrTBFuk
	0mS9lyX5lKjcI4wjlA2guQVh8WzbFyjXM4olWQOi8Lq72ojf0E1/hGkL8RJhXXjBj2glx3SZvNi2q
	/dh98XFUOHgva5gDj8wby+520fZK5QorxLsAPskdZg5oLp5B+tVLED0LijCsniGmZtUtYgSlcFHIh
	YLddBiBq4pGm9bEQE0dNNpXk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sqer7-000beI-0t;
	Tue, 17 Sep 2024 20:31:25 +0000
Date: Tue, 17 Sep 2024 13:31:22 -0700
From: Jeremy Allison <jra@samba.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <ZunnGhOogEQU2Hje@jeremy-rocky-laptop.localdomain>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
 <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
 <20240917202921.ty32zzmhrg33knpy@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240917202921.ty32zzmhrg33knpy@pali>

On Tue, Sep 17, 2024 at 10:29:21PM +0200, Pali Rohár wrote:
>On Tuesday 17 September 2024 13:23:40 Jeremy Allison wrote:
>> On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Rohár wrote:
>> > And seems that SMB2_OP_QUERY_WSL_EA is useful not only for reparse
>> > points, but also for any regular file or directory as it can contain
>> > UNIX mode and UID/GID ownership.
>>
>> uid/gid should *never* be exposed over the wire for SMB.
>>
>> That way lies madness.
>
>Hello Jeremy, if I understood wsl_to_fattr() function correctly then it
>is already doing it, it fills uid/gid for stat() from data which were
>exposed over the wire for SMB. Could you check that function if it is
>truth?

I'm sure the Windows implementation is doing it - however, any Linux
server implementations should not do this (IMHO).

It will break all SID -> uid / gid mapping that servers must
carefully set up.

On the wire - SIDs must be the only source of identity.
