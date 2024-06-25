Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1A0148FF5;
	Tue, 25 Jun 2024 11:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719314499; cv=none; b=CXfESifI6waLJJn4rZ0KyZDB90+Ug60CC6/P9R21Q12PCP2IwfF/7+TArkDiL7SlmwdNeq9QpIM3TKPg/1m3LaYpEsfNv47YnPuPkzd7WRmrFm8O8FrQ/QXNH6nnhYexwtMwPE0ivytysdSGy1jCexHgVDDOzBCv+XnOPx0ERVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719314499; c=relaxed/simple;
	bh=oSbhm/dT5MKMXBhgwWCjBGIAGVS63RQDUCW+HqsxQOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cb7lklIsGHFWCyq956Q16/ULetXMnd1n1UeIx+24EccpGvXyKhrSPDxEPJjPoAyRpg27oyOvNGTsIVXmualUTlK46jP1vvu84GsymZdjUvnfxhYNVXzvtNdXpoLZzvzQP/Mp+toeMvG2oyvBFZVnm1Kdr93THHehghdoHU+Gz2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=sh+gnQk6; arc=none smtp.client-ip=212.227.126.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="sh+gnQk6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1719314488; x=1719919288; i=christian@heusel.eu;
	bh=uMMLgPkSCGHiELtwqegdPywPsAzyqY9AmA8zacbiW8I=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=sh+gnQk6ej4PfuiU+hTwTyMitd6USWq7qBxa7dT8tZU5Rb4x/iPST5KVyNMxIVNm
	 i3OVPsNJeeHjvbJRI3dI75cYAxYFIGCCx6IzF609CSwErPSis3HI0mJBiph6Nw7yh
	 hCcgahUUeOw8Lforuu4EP9dmD5+/6SRPE360duse7HFqMa+aO5YvzmDJJJ1TA8D0R
	 kPy3HukxSMKrN+ktXm35pwZqaMc40sQKBNcOcP6+rONVsXJxBUcIpiqy6+uQMSfJr
	 DCYOyRgtapZjfupgMMnV4DhrQRaVE+Wkn0aDbN1KQdOtg/yKeU/NcRzBlesLc6Nty
	 41WPU/5x80cFDcc6WA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([78.42.228.106]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MNKyQ-1rxPdl2yMc-00WPVN; Tue, 25 Jun 2024 13:07:51 +0200
Date: Tue, 25 Jun 2024 13:07:49 +0200
From: Christian Heusel <christian@heusel.eu>
To: Andrew Paniakin <apanyaki@amazon.com>
Cc: pc@cjr.nz, stfrench@microsoft.com, sashal@kernel.org, pc@manguebit.com, 
	regressions@lists.linux.dev, stable@vger.kernel.org, linux-cifs@vger.kernel.org, 
	abuehaze@amazon.com, simbarb@amazon.com, benh@amazon.com
Subject: Re: [REGRESSION][BISECTED][STABLE] Commit 60e3318e3e900 in
 stable/linux-6.1.y breaks cifs client failover to another server in DFS
 namespace
Message-ID: <210b1da5-6b22-4dd9-a25f-8b24ba4723d4@heusel.eu>
References: <ZnMkNzmitQdP9OIC@3c06303d853a.ant.amazon.com>
 <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jmsggbhoayj3vp5r"
Content-Disposition: inline
In-Reply-To: <Znmz-Pzi4UrZxlR0@3c06303d853a.ant.amazon.com>
X-Provags-ID: V03:K1:K2gnCX6y5v0pEX0/67AmSIgOOCUSrjSVvkqkMNLNIcj01PSH4Oj
 T8aefGcsyDnq5Cg1O+6axHk9E/pe3KkKePQCeBRB/co0elYikkASNMndef5YYfRBT/HkNTM
 lF1j6+l+Z5WkD7iUx/IZRyuvPvRosANuuUJlKhrIclk8mMuLHEHGcR2+SoKYsMVYU+ouoCk
 +XMw6vJjld7kNuDGwiWXQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:FpkI5MEtraI=;dN19VhZMalOaYI7c4WLnfolaHVM
 f4au55iSExDBqAI00wcBkZqZVtFELDzhgHtWTCBnDXMHaS2sB6orsl611Ny57CRAOu8GjSS2M
 oSxb6IKPBLjGPfo38XHmNqeBtwRC1h+hzpovxrl4LEQF6hAyLdULoHgnGLmIJST88ucDDxNNd
 Ybl1+ZPxdG7UPGT2oBlf6I2pDsWuwmDtBDZJMLeqVBoUJ8ZVhKOt8c0FTr5M8qS4asqNFqo8D
 XkkQ5R2gO9eXZvK/52fZboJJqU99Gvdti4YuC2ZfnFIpnDsj73Lf0NDioiYjSxCE9l1vXqaRx
 czJQMdSlacVN0lUJTLnxqZ5g5p55V67FhY3Fb7bFjw4XqvUVIjNcRMxrmZYxJa0mder6v7uGM
 vOJIRX6qV3+RACX3WikRhu77sBx9UpIAy376ZhB+ReOF6Ca1BCmOnjET8N/XNzIjOdwO/2eQq
 aBbNP9XEX+mns4aysRwvEHCY2BG97VkxPxl8XiIkt7Jp1yuafGYZ4Q+JqMgXew/BGhZyexg65
 IUZMUgrMN8EGk57Hj1981QN6Do6Cyl4gH6ry950CZy1LqUUZ2RwaNV/jwdX2ACOPmOscNBjBV
 hDgz3aPrLYUapcWkpayfVFwqp1rl3k9DSL5UHPe7NvH8QG39lBXTPWVUZQF5yc4vSuvAULt3q
 HaoqS/Rrjg1IxS9Qpg2uhdnt4llsKjzIHlc6R+ss2BO+fs8aWnQ+65YQOjL4FTYQY9n6ASEhx
 Xm1ZlOteUxDv/nE2jR1aXnAPCUetzksz3vZAnwRMSU6R6kW+erLmMg=


--jmsggbhoayj3vp5r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/06/24 10:59AM, Andrew Paniakin wrote:
> On 19/06/2024, Andrew Paniakin wrote:
> > Commit 60e3318e3e900 ("cifs: use fs_context for automounts") was
> > released in v6.1.54 and broke the failover when one of the servers
> > inside DFS becomes unavailable. We reproduced the problem on the EC2
> > instances of different types. Reverting aforementioned commint on top of
> > the latest stable verison v6.1.94 helps to resolve the problem.
> >=20
> > Earliest working version is v6.2-rc1. There were two big merges of CIFS=
 fixes:
> > [1] and [2]. We would like to ask for the help to investigate this prob=
lem and
> > if some of those patches need to be backported. Also, is it safe to jus=
t revert
> > problematic commit until proper fixes/backports will be available?
> >=20
> > We will help to do testing and confirm if fix works, but let me also li=
st the
> > steps we used to reproduce the problem if it will help to identify the =
problem:
> > 1. Create Active Directory domain eg. 'corp.fsxtest.local' in AWS Direc=
tory
> > Service with:
> > - three AWS FSX file systems filesystem1..filesystem3
> > - three Windows servers; They have DFS installed as per
> >   https://learn.microsoft.com/en-us/windows-server/storage/dfs-namespac=
es/dfs-overview:
> >     - dfs-srv1: EC2AMAZ-2EGTM59
> >     - dfs-srv2: EC2AMAZ-1N36PRD
> >     - dfs-srv3: EC2AMAZ-0PAUH2U=20
> >=20
> >  2. Create DFS namespace eg. 'dfs-namespace' in Windows server 2008 mode
> >  and three folders targets in it:
> > - referral-a mapped to filesystem1.corp.local
> > - referral-b mapped to filesystem2.corp.local
> > - referral-c mapped to filesystem3.corp.local
> > - local folders dfs-srv1..dfs-srv3 in C:\DFSRoots\dfs-namespace of every
> >   Windows server. This helps to quickly define underlying server when
> >   DFS is mounted.
> >=20
> > 3. Enabled cifs debug logs:
> > ```
> > echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> > echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> > echo 7 > /proc/fs/cifs/cifsFYI
> > ```
> >=20
> > 4. Mount DFS namespace on Amazon Linux 2023 instance running any vanilla
> > kernel v6.1.54+:
> > ```
> > dmesg -c &>/dev/null
> > cd /mnt
> > mount -t cifs -o cred=3D/mnt/creds,echo_interval=3D5 \
> >     //corp.fsxtest.local/dfs-namespace \
> >     ./dfs-namespace
> > ```
> >=20
> > 5. List DFS root, it's also required to avoid recursive mounts that hap=
pen
> > during regular 'ls' run:
> > ```
> > sh -c 'ls dfs-namespace'
> > dfs-srv2  referral-a  referral-b
> > ```
> >=20
> > The DFS server is EC2AMAZ-1N36PRD, it's also listed in mount:
> > ```
> > [root@ip-172-31-2-82 mnt]# mount | grep dfs
> > //corp.fsxtest.local/dfs-namespace on /mnt/dfs-namespace type cifs (rw,=
relatime,vers=3D3.1.1,cache=3Dstrict,username=3DAdmin,domain=3Dcorp.fsxtest=
=2Elocal,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D172.31.11.26,file_mod=
e=3D0755,dir_mode=3D0755,soft,nounix,mapposix,rsize=3D4194304,wsize=3D41943=
04,bsize=3D1048576,echo_interval=3D5,actimeo=3D1,closetimeo=3D1)
> > //EC2AMAZ-1N36PRD.corp.fsxtest.local/dfs-namespace/referral-a on /mnt/d=
fs-namespace/referral-a type cifs (rw,relatime,vers=3D3.1.1,cache=3Dstrict,=
username=3DAdmin,domain=3Dcorp.fsxtest.local,uid=3D0,noforceuid,gid=3D0,nof=
orcegid,addr=3D172.31.12.80,file_mode=3D0755,dir_mode=3D0755,soft,nounix,ma=
pposix,rsize=3D4194304,wsize=3D4194304,bsize=3D1048576,echo_interval=3D5,ac=
timeo=3D1,closetimeo=3D1)
> > ```
> >=20
> > List files in first folder:
> > ```
> > sh -c 'ls dfs-namespace/referral-a'
> > filea.txt.txt
> > ```
> >=20
> > 6. Shutdown DFS server-2.
> > List DFS root again, server changed from dfs-srv2 to dfs-srv1 EC2AMAZ-2=
EGTM59:
> > ```
> > sh -c 'ls dfs-namespace'
> > dfs-srv1  referral-a  referral-b
> > ```
> >=20
> > 7. Try to list files in another folder, this causes ls to fail with err=
or:
> > ```
> > sh -c 'ls dfs-namespace/referral-b'
> > ls: cannot access 'dfs-namespace/referral-b': No route to host```
> >=20
> > Sometimes it's also 'Operation now in progress' error.
> >=20
> > mount shows the same output:
> > ```
> > //corp.fsxtest.local/dfs-namespace on /mnt/dfs-namespace type cifs (rw,=
relatime,vers=3D3.1.1,cache=3Dstrict,username=3DAdmin,domain=3Dcorp.fsxtest=
=2Elocal,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=3D172.31.11.26,file_mod=
e=3D0755,dir_mode=3D0755,soft,nounix,mapposix,rsize=3D4194304,wsize=3D41943=
04,bsize=3D1048576,echo_interval=3D5,actimeo=3D1,closetimeo=3D1)
> > //EC2AMAZ-1N36PRD.corp.fsxtest.local/dfs-namespace/referral-a on /mnt/d=
fs-namespace/referral-a type cifs (rw,relatime,vers=3D3.1.1,cache=3Dstrict,=
username=3DAdmin,domain=3Dcorp.fsxtest.local,uid=3D0,noforceuid,gid=3D0,nof=
orcegid,addr=3D172.31.12.80,file_mode=3D0755,dir_mode=3D0755,soft,nounix,ma=
pposix,rsize=3D4194304,wsize=3D4194304,bsize=3D1048576,echo_interval=3D5,ac=
timeo=3D1,closetimeo=3D1)
> > ```
> >=20
> > I also attached kernel debug logs from this test.
> >=20
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D851f657a86421
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D0a924817d2ed9
> >=20
> > Reported-by: Andrei Paniakin <apanyaki@amazon.com>
> > Bisected-by: Simba Bonga <simbarb@amazon.com>
> > ---
> >=20
> > #regzbot introduced: v6.1.54..v6.2-rc1
>=20
>=20
> Friendly reminder, did anyone had a chance to look into this report?
>=20

It seems like so far nobody had a chance to look into this report =F0=9F=A4=
=94

If I understand the report correctly the regression is specific for the
current 6.1.y stable series, so also not much the CIFS devs themselves
can do. Maybe the stable team missed the report with the plethora of
mail that they get.. I'll change the subject to make this more prominent
for them.

I think a good next step would be to bisect to the commit that fixed the
relevant issue somewhere between v6.1.54..v6.2-rc1 so the stable team
knows what needs backporting .. You can do that somewhat like so[0]:

  $ git bisect start --term-new=3Dfixed --term-old=3Dunfixed
  $ git bisect fixed v6.2-rc1
  $ git bisect unfixed v6.1

Then you just need to carry around the commit that broke the behaviour
for you (which could be quite some work). Maybe others also have better
ideas on how to approach that.

A revert may be a bit more complicated as the breaking commit in seems
to be a dependency for a commit that fixes something:

    efc0b0bcffcba ("smb: propagate error code of extract_sharename()")
    Fixes: 70431bfd825d ("cifs: Support fscache indexing rewrite")

Cheers,
chris

[0]: https://stackoverflow.com/a/17153598

#regzbot introduced: 062eacf57ad91b5c272f89dc964fd6dd9715ea7d
#regzbot summary: cifs: broken failover for server inside DFS

--jmsggbhoayj3vp5r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmZ6pQUACgkQwEfU8yi1
JYWSwA/+OPb/TZJmsjikMtPq9++IQcrHwdzJx3MYVtjHfKnPdVSUc7LROrXMdngS
OEv8Du6IpiYtP91JSu/Dd28tLiwRgqfmUJuv+9bNJRHE9A2yyEyHg0CtgzoX8kQP
eLthIxpPuqJqClWDy2UPSoCfcrUgUdPCPbSTG3RTe3CIeQhRZ4KwZ+bpb2AS0mOD
BadNW1ew+qYILEIF/YRdU2BxWdNF+eNCrumMwBPdDgqgAXvRQ7a8V7RZPQFLlUJ8
oXSnhrH4Y2ESXAXrmVitbX1w0jV+bznHTnA9t6hJnM2SB41CY5j24uM3b10VCDXn
TGudRwccs29xZaKzlRED6DZ3c9YMz43zOkQ2AmQOtaAHXTn2CVqc0WWtHoUfqWGg
HdncnOKwHroDxvh0FvWB9bzIYBHmm79pMpLhdCdtm2kcmDPEkyb/QW5QbTDzrmQo
vb3MRP6s5ko0yFfHouZIG0rwwqAHl9NEw/i8SCzE7JJkRbR4jecV+env1nEAsDw+
QSR4xD6YUwYbG3/1j5B8GS0etU/UAoGHLw6NBY+zAl6/RRORGxPzGhM8QS68Qaxp
C0+F53YmCriHjR9fwil6HBD21MSLMhUBHy1W1JOTkvvLJGZLzM9F/75zhENm8ECu
7qfmbwByPZhPoYgXAdzkic3WUEx9iQbtkwULlMLIqu4VXGXVB1Y=
=HFX0
-----END PGP SIGNATURE-----

--jmsggbhoayj3vp5r--
