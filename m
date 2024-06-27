Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608561BF58;
	Thu, 27 Jun 2024 20:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719519728; cv=none; b=ARil3Hwdq1AD/RAPRyZhvG7psgPaXEmC2g2v6AY/gfw/NPXKVM16qNsAsqlwbFrgtwsMbunQPlVL2ZdyZyHVH17aShHC7kdDDCigqCr4veT8rxmSuEF2lbKnSlY7jXLmbbBkoDcLMBk9uJDv0whY8x37CXmIRSMlTP2A3sOxGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719519728; c=relaxed/simple;
	bh=p4B2mvCmXom56o80wmZXmDeDj3JxYTCL1AMb/2233RI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH6Lgn7Jm5aboEMXuCJueMlG7/2owQWUqL6QmOF8pRC6XO9IzE91Xc6pT8YE7teVbSH9WtK9o3OwnNDbXKm12wthcboyX0/j2zIWhppicUVsnfeRF6rxNby7GY2Z3QprpEQk6iX7wW6rUhdVixaM/+MLVAQu0GlpvzauWCZiaD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=vutFzSs0; arc=none smtp.client-ip=212.227.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="vutFzSs0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1719519718; x=1720124518; i=christian@heusel.eu;
	bh=p4B2mvCmXom56o80wmZXmDeDj3JxYTCL1AMb/2233RI=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=vutFzSs0uuckA2ptTgHpD6pdKIG/nix+4EkgkLavOGPDrG9IcpLO0HWbJbZ+U/Pk
	 6jvAq7LdrFPrKl6nkZE5/vmEzUTP4z8uLViUyOOqzdIFCITJwY1t6WsGfuSs5bupM
	 gmhULxLmgN6/N3FIfP2Qo8KMt2JDsGJfbTT05KI8Jg5/E955JWMQwO5nMxHGYunnm
	 kWWWZR5K/VLnIzZLlFpM62MFe/AfSzXPlfuuYQ/CCubi9MX8m/R7pV5QsVGaUawAx
	 u7VICuxWmXZZ+ubLkzSTQJOrHVRLX88pKnnpgbGrSQZmBcYZF60P0jcJLVFtDlwV2
	 Sn8GUxMNZlK9EpXOoQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([80.140.196.45]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MDN3O-1sDcPh1Ve2-002D5U; Thu, 27 Jun 2024 22:16:15 +0200
Date: Thu, 27 Jun 2024 22:16:14 +0200
From: Christian Heusel <christian@heusel.eu>
To: Andrew Paniakin <apanyaki@amazon.com>
Cc: pc@cjr.nz, stfrench@microsoft.com, sashal@kernel.org, pc@manguebit.com, 
	regressions@lists.linux.dev, stable@vger.kernel.org, linux-cifs@vger.kernel.org, 
	abuehaze@amazon.com, simbarb@amazon.com, benh@amazon.com, gregkh@linuxfoundation.org
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
Message-ID: <a58625e7-8245-4963-b589-ad69621cb48a@heusel.eu>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
 <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
 <ZnyRlEUqgZ_m_pu-@3c06303d853a>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="de5zva3l6z7p62ol"
Content-Disposition: inline
In-Reply-To: <ZnyRlEUqgZ_m_pu-@3c06303d853a>
X-Provags-ID: V03:K1:9r+PViboj2vPSE0B9c+ZMxqrx/3az471oruk93qBuqqK8h9dSbX
 KaqIjeBXa6avgQ52aN5m4n/Vwe1Bhm/5XTydnNYFkbjHz/zzjUTUoFlM/t9vOpI2Y9Gp8jP
 bFh1AZYnZwpIC94WthAKHbkt1knsJcAQT0uJFEc+PbL+Or8/CW58RPm81q+VbAK7hCkzFBG
 ByLZcRAOj/CVcGPNLptJg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:pfvix2MrJ4k=;s9Pjk1JVm1YDNW19GA2JXW6LjaE
 SkHG6QygYn7BE9frZjTSlK3k/iwmdYllXwrrdhgsAaPdsRBBo6qyfsf5QuIhXg3inaWZPVbN2
 B1q9u/I/M0g5T5LXJhGLsL1H9vVbxODbNcsYnYiwLNXUM89zfgyW+46lUHjpVzRWoEDQ+ketN
 txKsfVd3nSSw3owo3dtSEWT89TC/0aMrDjfwS0LEtDlsx1vq5EUKS68twFs6NqgqGbZn+aShV
 jbX/keg5lhUCYf7hoiMTVSvi5SyQ570z/1dAJTTXTiZIBjAjcJqLKO/9ZvQxssDuwGQKCn5C/
 ewNNuAF2tslZwpJWWefcFaxfNClzyB/8zP1JT5fnuHhl4zbxY+7yxzPEB5+ltwwIaNPWUkv1W
 aXiNT4lTci1nVwrMUedEylDT4/mF3D31pFparA3S7fivGCk2pBs+cD5WDL6rOUont15paXwrT
 YrjE7jfZwmJdFM6b/g77xHXld//IvODclhCfNc/ndcsIhgaFo+hY89KEtLjIn/LDE/NMQvNR7
 wpol48HFZt7oS0rfixTqDtl4+vyaI5B5rpJ5XDCQ1+J11XMFWoKc46+arbYIhBnehakIjQrzl
 vbilixss4sm5Izv4bDwNJS7vl7TPMK6QCPZxWPyMs21Ma/JSfOwAfF1YI85ZUYLpAoClGN9Po
 8XTChGtwgccNAUqPulzDa4YfA2w6sGE9joqWWFJ0SAUelj99YXH++7ZUJA2RTsnJkf3RcJsiR
 2R8VGwN3ymcSPuYhX6DOj2qFZEoJTY4rs1lp+pk23t4egOZ+ObCkeA=


--de5zva3l6z7p62ol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/06/26 03:09PM, Andrew Paniakin wrote:
> On 25/06/2024, Christian Heusel wrote:
> > On 24/06/24 10:59AM, Andrew Paniakin wrote:
> > > On 19/06/2024, Andrew Paniakin wrote:
> > > > Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> > > > released in v6.1.54 and broke the failover when one of the servers
> > > > inside DFS becomes unavailable.
> > >
> > > Friendly reminder, did anyone had a chance to look into this report?
> > >=20
> >=20
> > If I understand the report correctly the regression is specific for the
> > current 6.1.y stable series, so also not much the CIFS devs themselves
> > can do. Maybe the stable team missed the report with the plethora of
> > mail that they get.. I'll change the subject to make this more prominent
> > for them.
> >=20
> > I think a good next step would be to bisect to the commit that fixed the
> > relevant issue somewhere between v6.1.54..v6.2-rc1 so the stable team
> > knows what needs backporting .. You can do that somewhat like so[0]:
> >=20
>=20
> Bisection showed that 7ad54b98fc1f ("cifs: use origin fullpath for
> automounts") is a first good commit. Applying it on top of 6.1.94 fixed
> the reported problem. It also passed Amazon Linux kernel regression
> tests when applied on top of our latest kernel 6.1. Since the code in
> 6.1.92 is a bit different I updated the original patch:
>=20

Hey Andrew,

good job on the bisection!

I think it might make sense to send the backported version of the patch
for inclusion to the stable tree directly (see "Option 3" [here][0]).

Cheers,
Chris

[0]: https://www.kernel.org/doc/html/next/process/stable-kernel-rules.html#=
option-3

--de5zva3l6z7p62ol
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmZ9yI4ACgkQwEfU8yi1
JYVOqg//X8BaMDQBGCFjvGiTh5/ydTOB2mV8UpIHdv/2AeT0wfZN2Bde+z6xRePz
1yMgaxPN9prXmdoES0aykiuRZqFInYPkgJI5NTkLx6q73m5Egf/S88MWv64LYFlP
to6ByDMfiai/Fy5YeXpy4KufTyLDGGaFbBaGujNfuaeZwzRTcpFeIVWyo3rd7pgS
pjLlopGblHL8hbwifdYsNv5g6iFlSZcsWC7lpzfILywcXZW5CYx8pm0oAus2lKAi
aLMsRiUDXq+uPHvAgedjGBh78zU4bH6fmT0Z955nLlEpuICH9BbjQG57LaYSyH93
jrJCkahO9OFfI3vVs0tOCioan7J1F21UTSoD8Ll3Cn4UZ3c5lUbDmBU6qm/rEwR2
Dg3d1DkXEi0ywlQZ7he48+GqRsgBnWoyF6czhtxRkIgl6iQUwZWaQdBhches3vEr
w3z/TVh2PIkXgl9U7+yprAwbaiBKz2Wz/6mi1YuvFd54QvfVKSKu1U3+kgK3ZyYI
3v73y8iAV2uZrTPRTqB7ZVRj1fiSWslsEQ6MPO7cyv1K2XkX85SS4e2pzKWlDC1h
zwnlJVE+HtMU/xPPopRLxsnGFvA7Ymawyn5cac6HytMZSE0XyQ/jw8SUhMKB4Fhs
mjqlgWunP9pvhRKgOuKkeDD7rysWtCjbSkF5C+j2fmpysNd3pd8=
=pFOg
-----END PGP SIGNATURE-----

--de5zva3l6z7p62ol--
