Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F1230C16F;
	Wed,  2 Sep 2026 18:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373854; cv=none; b=AjhXE7PKdN9k12RwP5DWlA49pkJJb62uOG+QyfS/lMfA484ItHdW8BwmZHc+AJzuGF5f28qoinkf6u+8gA2mqcQPfr0V3ECeH9Dj7ncuR+x/4j5Y+kBsptdUoDpWljnpBC4jx7qA5kqwO2QmNLWH0BFYAEz+tpUsn966VZ16AXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373854; c=relaxed/simple;
	bh=FJ+cFfijYz77qDTUHTCOLZR/qT5V2cDiUBzAkw6y6JE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=irJ2j0HhVG74/EFb1TOcH3PYu/tqOh/YwW23+lxIRL213VyT4/N5XNPR8gZ6hy0FiEx3uUOHT5/Ot5hYj7SPLQIoSZ2aETRPkMI8UslrcDLvvgL6/Oizgbvf8Id/19cJvd0P6+dg6sc7OWSDgflTqACPctvmH5Em+8vrultCBwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=dJxxTgqi; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="dJxxTgqi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EA6VLR/Y58aArH0v0a0iWsfIb/rDehO0veH8II5sfpQ=; b=dJxxTgqisiZhgPS7XrFuQ53bL/
	JZm7fqk1O79FzM6D5OjCxwx9TXhFtEjLgsgswrZGxiEs1Jx2mNRC+hy6iGauG9CZjj2zH9484Ty0Y
	IGh6ittZm9ep/Qms84O9zuu7JT57/NdM8nry/bFqJT94jRPgj6Z0RPnU//e/LgclSn6PQ9kPs2rPY
	l/IJJwr2JJhhkECy3UmBUO2ET/+XnDXJi6jchQ0cFlwk1VdX8aEtcMeufQ62Iu2M6nCM0G3GwHTXN
	k1oYl6aLuJe3w5enqXHfy8Kd5PIoa5t/23jfILb02Bd1WWlQYM3j3piGpV8j/gWoZu0IN1DwRITQ2
	++NisWxg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1pjU-00000000XSA-3Yby;
	Wed, 02 Sep 2026 15:30:48 -0300
Message-ID: <7f452eb86fd82bbe990601df42714cc9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: henrymei <ljp1205831794@gmail.com>, sfrench@samba.org
Cc: ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Aohan Mei <henrymei@tencent.com>,
 TencentOS Corvus AI <corvus@tencent.com>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: reject userspace cifs.idmap descriptions
In-Reply-To: <20260902125217.3951486-1-henrymei@tencent.com>
References: <20260902125217.3951486-1-henrymei@tencent.com>
Date: Wed, 02 Sep 2026 15:30:48 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

henrymei <ljp1205831794@gmail.com> writes:

> From: Aohan Mei <henrymei@tencent.com>
>
> cifs.idmap key descriptions carry authority-bearing fields (owner and
> group SIDs and uid/gid values in "os:"/"gs:"/"oi:"/"gi:" form) that the
> cifs.idmap upcall helper treats as kernel-originating inputs.  Unlike
> its sibling cifs.spnego, the cifs.idmap key type has no vet_description
> hook, so userspace can create keys of this type through
> request_key(2)/add_key(2) and supply those fields without CIFS origin.
> A request_key(2) call with a non-NULL callout then drives a root
> usermodehelper upcall (/sbin/request-key -> cifs.idmap) that consumes
> the unvetted description in root context.
>
> Only accept cifs.idmap descriptions while CIFS is using its private
> root_cred to request the key.  id_to_sid()/sid_to_id() already run
> under override_creds(root_cred), so the kernel-originated path is
> unaffected.
> ...

Applied.
