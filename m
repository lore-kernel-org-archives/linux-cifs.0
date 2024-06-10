Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E667517545
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 20:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718053068; cv=none; b=fIm+Z73PYKvBF2o0emFzWiZ3EZsOoFKaTxF/bGTlHneGAZFV8EbJmFDit+vi3Hqt+0TzC9fafI+Fqu/ECaEjxmxYexe8nDWdrRHqHO2Mpvrsleb/JFyNtBSt9UbzITS1bjU+aEptS3IlI7mZbZjRFj+lwBxIHQdVpfdYYwJCbL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718053068; c=relaxed/simple;
	bh=q64Y+hanoq5Fvcc7HC6JfMpzVMvjhAjew8s5AXHacnQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=er1TyjpHclfC4HR1kM++DpvkDIaXOtLIOdSuTDxm9ZO9PdwJISCgK14Xd5pMA6IW18Rb5OxgC3c++OJqFN8egJQ2eiv46HmwA03VAzoFO/1E2k0Kz+uj3r+N044vS44NmPMkQwfXkv+C2Fgu2fIGswB//f+x1cBU13pqWi8vdw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Vd14aadE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Vd14aadE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Date:Cc:To:From:Message-ID;
	bh=raIWlTcHI+HE51AGr87Hxtt+eNb/T+Q4LXCqmhb1vEY=; b=Vd14aadEua4rXh15/4c/O/O6HT
	M2knOtSTLC3ArJkf/4bxl6zjH1wWFjxZXNEMd+VGYLN1QV3yEI3gRQEL4ym+q0lPpl/Z5CHlE8XKY
	H1WzgxcUNxm45NVQyxbrF/AY9QNl2KUoIHKcDMfx+3/kzqp5pRcmFDmfYUyyHVhwnHM2isJyrWsqX
	vVFKDS6//KFu/otmhPDmcZTVtAmuiXtue69r2YX4/5hn08CHxAeeKcvmFG9tDeh6xEy/wQPHg/Y7p
	hsOTcBGo4JyDK+SOQF1zc7qSyETF21t9yzPjNpaAjGKVvMS+XYl0U57o7tVw05mb9ZDK9MFgwghHp
	yeUR6ATLvTrGkid5I+az/ig7YqtSAOI7x6iJCUxvWIq+TspdH1dqGVqFoyQgt+y3IUO68T0/Yhsb8
	F2z/hO2bBV9vl2DW9r5lS9XfrtY7ZpQhVosjkbYXRZSbWi/9IhOC/4xkCQCuAS8stmnvMT2gST/dK
	bXIG/Xo/BbB1cvjVRYjdSLpq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sGm5G-00G1XA-21;
	Mon, 10 Jun 2024 20:57:43 +0000
Message-ID: <c0ea6cce3b9b96952aad2afa383a1c0b87b37496.camel@samba.org>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
From: Andrew Bartlett <abartlet@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org
Date: Tue, 11 Jun 2024 08:57:39 +1200
In-Reply-To: <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
References: <5659539.ZASKD2KPVS@wintermute>
	 <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
	 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
	 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com>
	 <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
	 <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 2024-06-10 at 15:53 -0500, Steve French wrote:
> On Mon, Jun 10, 2024 at 3:48 PM Andrew Bartlett <
> abartlet@samba.org
> > wrote:
> > On Mon, 2024-06-10 at 15:05 -0500, Steve French wrote:
> > 
> > Yes - the reproducer helps.  The bug is easy to reproduce.
> > 
> > 
> > I wanted to verify that the succeeding cases are the same that I
> > see:
> > 
> > - works with "cache=none"
> > 
> > and
> > 
> > - works with "nobrl"
> > 
> > and
> > 
> > - works with "vers=1.0"
> > 
> > 
> > All other combinations fail ...
> > 
> > 
> > Should be straightforward to fix in cifs.ko.  Will look at a fix
> > for
> > 
> > this later today.
> > 
> > 
> > Awesome, thanks.
> > 
> > 
> > Note that the problem with SMB3.1.1 POSIX extensions is a Samba bug
> > -
> > 
> > a serious regression in the server (but trivial fix).  We are
> > waiting
> > 
> > on someone to merge the oneline fix to the server (which we tested
> > out
> > 
> > ok) from David.
> > 
> > 
> > Is there an MR for this?  I couldn't find it.
> 
> I was puzzled why there wasn't a fix immediately applied since it was
> tested (and could add my Reviewed-by if that helped), and obvious
> server bug (regression), but I think David (who wrote the fix) was
> busy with other tasks.  I would have done one but I am out of date
> with the Samba merge process.

https://wiki.samba.org/index.php/Contribute

> There are two other fairly simple problems (with basic SMB3.1.1
> behavior), e.g. ctime not being updated in a few obvious cases (which
> is not really a POSIX only issue, as it also affects default mounts
> from Windows to Samba)  which we hit in SMB3.1.1 POSIX - that I would
> love to see fixes for so we could restart our regular test automation
> to Samba from Linux (cifs.ko SMB3.1.1 POSIX mounts)

Very happy to help you get set up for small smbd patches, particularly
if it helps move this along.

Let me know your gitlab account once you create it, and I can bless it
for access as a Samba Team member (please also update the team contacts
file).

Andrew Bartlett

-- 
Andrew Bartlett (he/him)       https://samba.org/~abartlet/
Samba Team Member (since 2001) https://samba.org
Samba Team Lead                https://catalyst.net.nz/services/samba
Catalyst.Net Ltd

Proudly developing Samba for Catalyst.Net Ltd - a Catalyst IT group
company

Samba Development and Support: https://catalyst.net.nz/services/samba

Catalyst IT - Expert Open Source Solutions

