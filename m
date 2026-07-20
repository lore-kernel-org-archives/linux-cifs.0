Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6F3AC0D3
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 06:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784528082; cv=none; b=Y3W2YFe/uqgkj3Tyc9jwrKypjWaomseSJX88Sagn2uF8DGvZO+5/ktJ+zi+4V/x14LsVCdHqdjX/gBQa+q9UfhYs8/A/zC8yxxxSaRdHolxzfO0wKhufNvAdAWp5cfhzJZlJN4ojLAnxDTOKTG8CuuUM8i2xCcgQ3q0vOXOlNfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784528082; c=relaxed/simple;
	bh=2Jm1RYthZiAv6Lk4U12ZSCn+8iZoS19hICtmtXyv6o4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dq15+leiSzBdjM7oejM9znVzhAtX4WZzbpmn4KI/vSPapAGgGLMGGxtWvrtymQlE4hT74juWAySOwgxp6Q0h8UpZUGpSiL4AxVvfjWqROsY/7WAp5+LGtqMD5/WXbuv08gCZqAaJC2NUcwaxrv2qx4ZlKlCGxd8uEcALfijqLhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AapSBBCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AapSBBCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739091F000E9;
	Mon, 20 Jul 2026 06:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784528074;
	bh=4GsZSh+4WBxjsM73/BuCfimN/0LdshFGqaxvXJ1pn0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AapSBBCE1AElTsHgCBdUx1XQncIgx3n6EphJWNZi4Q1eQC/QMc4uygf+hvnhvCnEC
	 DUU6qJzEnSy9/RRuTStYmrC3PaB9qF3bw7CheFk8S+W5/8jGT+jSt9FIQDTxHsP4sn
	 2pu9P6d6/zyd9MnTd5AsTazg46Cgy3GMSWjT8G4o=
Date: Mon, 20 Jul 2026 08:13:11 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"security@kernel.org" <security@kernel.org>
Subject: Re: [BUG 1/3] smb: client: SMB2/3 signature failures are logged but
 the response is accepted
Message-ID: <2026072010-affront-blog-f082@gregkh>
References: <SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>

On Sun, Jul 19, 2026 at 06:05:01PM +0000, Birtwhistle, Daniel wrote:
> Hello Steve, Paulo, and linux-cifs maintainers,
> 
> My name is Daniel Birtwhistle. In my role, I assess security properties of
> software inherited by GE HealthCare products. I am writing personally as the
> researcher and technical contact.
> 
> This is the first of three coordinated CIFS client reports. This message covers
> response-signature enforcement. The companions cover server-provided symlinks
> escaping mount confinement and client-required sealing being dropped after
> reconnect; all three defects have different fixes and can be classified
> independently.

As you sent these to a public list, no need to get security@kernel.org
involved.

Also:

> I have the minimal candidate patch, source harness, raw transcript, trace
> results and matched controls. I have not posted or attached the reproducer,
> but can provide it directly for review and can test a maintainer-proposed fix.

Always send patches, as the documentation asks, so you can get full
credit for resolving the issue if the fix is correct.

Same for the other 2 emails you sent.

thanks,

greg k-h
