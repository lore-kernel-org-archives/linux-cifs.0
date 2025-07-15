Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2782D238B
	for <linux-cifs@vger.kernel.org>; Tue, 15 Jul 2025 05:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752559184; cv=none; b=KeQLm4eDAHNP8qaPWPmwMHwJ3v6qO0GZA6XUNf7m6sthgWSywR0J+1sVWHFZ/ZtlFKl72x9tUJXuUL6VBtWHlRmeymACeGy1+d9vnil2XEwTViKVURVCExCfoOsQOb/EfIgAaw0Gp/TWLcGsO+woibrH7xgWJCuI7UQ50KyfgF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752559184; c=relaxed/simple;
	bh=IWeKAJNyHD2ImhwyuiNz3zCNwRk60o1/qy/6MxCRQl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvOeq5EqzUGLPLuLVjd0FpxqGXFDSLYTSWdVzdRB+vc7WsT1CLTmINnKRWESqBGkeIkLz2d/yfckTrt7q8T+z0H6ZK13yVCEmYrJ5Rk3hFTjGddNp0ULbKhp3gzwXbf3oS75G1bXWRLVCl9bgy8Qa5tKtv9eITfSeYN+xbkj/RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=0j7J67Sz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="0j7J67Sz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=wbtJQLUmjDvGH6xHsbQvld5DzXzF7ewDLkWTSGus4cI=; b=0j7J67SzkR2h0CXdTA1CCU8MQn
	MYdzMbVn4TxxTM1VqkVX+57dw/K6mu5UV7+RzM8VmihSXhuGeQdNrHqigxBp98TKGQBiEgB1+Zb4W
	cIusNWqq9p90vzfVXSPL+Stha1NMRSfFFWa9hi3ZgWYKA+yG7MyeMZ5H5J/I2QCyv2VTfdA4JU49V
	Uc8js2luf90/ojS7byIfkB1/stoKT5d/Bk0/WoNHKs7FY/+tZH2XsPn2KMxh2LLJDv7fpGq8KsG9I
	XDJ4QwmH0nAupm709kkSGDhYvz0r/yR26DisiKNBk3ypQ6vmjdouxlhgsnvKXEFPoiXRQzILR94bu
	nMfa7Ari3Rd1JDCchLAV8ZcwTUAJl0mCkHdsV8OJRoXM8UINs6X6lBgmglX7SpgLUN+NshAiPQ2yB
	dxzh2fTPyH2iftxBt0lduJPyZf7IAyD4AtGGseauxcJ1JhgNT6el58NXuedJ5Hl/olNvH0tdT6LM9
	PTWU4SaRpJO0tBXR+OafFRMM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ubYhX-00FPF2-1T;
	Tue, 15 Jul 2025 05:59:39 +0000
Date: Tue, 15 Jul 2025 08:59:36 +0300
From: Alexander Bokovoy <ab@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Till =?iso-8859-1?Q?D=F6rges?= <doerges@pre-sense.de>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Using UPN with mount.cifs?
Message-ID: <aHXuSKMsQsPWd5NC@toolbx>
References: <a97b22e8-144e-45ed-8850-c3fd18769a6c@pre-sense.de>
 <CAH2r5mtgWfxQtoy2gwnMiWM3HXno2icuWmiuhMJ64yTAi_jsyQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtgWfxQtoy2gwnMiWM3HXno2icuWmiuhMJ64yTAi_jsyQ@mail.gmail.com>

On Пан, 14 ліп 2025, Steve French via samba-technical wrote:
> This is an interesting question.
> 
> mount.cifs will pass it (the UPN) down to cifs.ko so it will get sent
> on the wire, so behavior will vary by server.

Is this with GSSAPI krb5 or NTLMSSP?

For GSSAPI we either expect already existing credential or initialize it
from a keytab. In the first case cifs.upcall is not doing anything to
enable enteprise principal because it is not handling the initial ticket
acquisition. In the second case it doesn't do anything to mark the
client principal as an enteprise one.

The difference is by how that client principal is marked down in GSSAPI
negotiation. It needs two parts:

 - a client name should be an enterprise principal,
 - client code should make sure it sets a flag to accept rewrites of
   its own client principal name by the KDC in the returned ticket
   (principal canonicalization).

Neither is done by the cifs.upcall. More to that, for GSSAPI krb5 the
username passed to the cifs.upcall is pretty much ignored except for the
keytab initialization.

With NTLMSSP you don't really have 'enterprise principals', as it is up
to the SMB server to interpret the name you passed.

The client has nothing to indicate that. A server may consider
interpreting it as a local machine-provided one (username=testuser), or
consider to map it into the local one even if it has domain name
explicitly set (such as with IAKERB case on a standalone Windows).

> 
> I tried it to current Samba (passing "username=testuser" and also
> "username=testuser@somedomain" and also for
> "username=testuser,domain=somedomain") and it worked fine for all
> three cases (with and without UPN, with and without "domain=").
> 
> Trying it to Windows though:
> 1) "username=testuser" worked
> 2) "username=testuser,domain=somedomain"  worked
> 3) "username=testuser@somedomain"  did not work to Windows server
> 
> So looks like the behavior varies by server, but safest way is to
> specify the UPN as "username=" and "domain=" rather than
> username=someuser@somedomain
> 
> On Mon, Jul 14, 2025 at 7:44 AM Till Dörges <doerges@pre-sense.de> wrote:
> >
> > Hello everyone,
> >
> >
> > I'm wondering whether it is possible to use User Principal Names (UPN) instead of
> > accountnames + workgroup/domain, when mounting a share with mount.cifs?
> >
> >
> > The man page for mount.cifs does not mention UPN. A quick grep through the latest
> > sources (cifs-utils-7.4) doesn't mention UPN either.
> >
> > Searching the ML in particular and the web in general came up emtpy, too.
> >
> >
> > So, is there a way to do it?
> >
> >
> > Thanks and regards -- Till
> >
> > --
> > Dipl.-Inform. Till Dörges                  doerges@pre-sense.de
> >
> >                                          www.pre-sense.de/fcknzs
> >
> > PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
> > Geschäftsführer/Managing Director        AG Hamburg, HRB 107844
> > Till Dörges                              USt-IdNr.: DE263765024
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
> 

-- 
/ Alexander Bokovoy
