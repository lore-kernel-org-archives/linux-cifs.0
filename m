Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DF828751B;
	Sun,  5 Apr 2026 23:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775433203; cv=none; b=dGIinwVHe83xarK3ehR8eIPlX4so/htgjBcF9TphGLYX+grrVG8CPiFGjbC5KcJCtPI6jRKeZicQAGkZ6uYdiPMHVJb0lPWq4boRMNkUPj3t5uSrTFlmwlInONntls3UmIW4P6HOAtII0rvbKOTwA9F9wtSbh+El555f1qtd79A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775433203; c=relaxed/simple;
	bh=AQMHzBnALza5eY2MjjjaJfLYkZMud4a+1WKHhQBPrRg=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=btOYPY3qJeja0vk3eplWEvk+c72Ws3MVxAFH6806pu8oubs7I+RQAYVnvfJ+ehAm8vxTH1EvPNy9mkbwBL130ofhqnTXuUum77HpwCUEGH3pBIWTnZ3HMnqMjToJYzMMIoTvL6UGJY8QZEHZk2G2UhAYyRawaxguS+/Hf0P8BHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=Nc5j3f7w; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Uo3d0MnJ; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="Nc5j3f7w";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Uo3d0MnJ"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 635FC1D00060;
	Sun,  5 Apr 2026 19:53:20 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Sun, 05 Apr 2026 19:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1775433200; x=1775519600; bh=sLDyAQJ4Qij5PU7AO3RaMblOxAB3WklwTIN
	zz9rGZbI=; b=Nc5j3f7w3KobSvPd2wXH9/Zft5j3Y5WohM4yxtSA45ujSlqzaBj
	9G2LK82c15RP2Yn/QPTjOd8oV/1F+xYd8omFJt0gCKs+wCh14gUf8CqtPY0GJpeq
	8us/C5jCsXCgUlvxJcJ3bO7wI/QX1NRQgMrpV3iKWLkaiAD0MRkwsiRmXby9Oznf
	n84wH2z51arkhhteCb6eKMWVJ6nr9152a9dmqdZMfVXpQJ7P7VFn+D9F8CPAydsy
	B+gHUYMHVOdAaje9vmnRjUWJj9JMs1+xGBaBBQRb2cvlDw4tPzNMM298ajFgfiV9
	qVZ2n/piH3Mno0fO6YVerKdJ1+slO3AvECw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1775433200; x=
	1775519600; bh=sLDyAQJ4Qij5PU7AO3RaMblOxAB3WklwTINzz9rGZbI=; b=U
	o3d0MnJJhdI6CyjtsJZ0VRnxwP7BTBUqZZh9owfkwjsk9p0+sDvFBNseZ/ob1+EH
	nRroagTFZzyUMvj2b++IFmK+NZwSnqqxVTpfPyuodiDSIflBXCZrAxwq6lhR1MB+
	6rlPsrztlp5y0kwN0F6++0IYDxrrrjnbLBLGsih4H7u8bNioc7v0eTiJmI4dm7gf
	2Jj1Cxeu/UqdBeNogKebaGARRTXKSrj2AcafvR1lD9btD+8GCsvJi6TU4stDoYAu
	HcmzZeugKFchrXMrEfWzv4+4HtS/7xLwsD/zmCveS0XEqx5ceLWsJSHsF3egIssp
	OsITu5sgHtAv/NM4Us57A==
X-ME-Sender: <xms:7_XSaerFqxHsb9XY644u7b99oOdIUk2BKxckgU8XvghtpeIqY1ZrPA>
    <xme:7_XSae6EeTgOes9fXTjHCOz50abVteEoKGhKXH_Ioqidt256ylmuUih3YQRhK3S0T
    2ouYuzP9vTJ0SB9JY6cFT_-TTyjpgRsLpBEIwAws0bgtawn8A>
X-ME-Received: <xmr:7_XSaVdJ1xODTqSfaCM7p4zllDi8eZ-cwAIf5GQOZvV9w_PU8cy4_gWHTUtGP0jYJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduieduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpegtgfgghffvvefujghffffkrhesthhqredttddtjeenucfhrhhomheppfgvihhluehr
    ohifnhcuoehnvghilhgssehofihnmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpe
    eljedtfeegueekieetudevheduveefffevudetgfetudfhgedvgfdtieeguedujeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghilhgsse
    hofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtg
    hpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdgtihhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprh
    gtphhtthhopeguhhhofigvlhhlshesrhgvughhrghtrdgtohhmpdhrtghpthhtohepphgt
    sehmrghnghhuvggsihhtrdhorhhgpdhrtghpthhtohepshhmfhhrvghntghhsehgmhgrih
    hlrdgtohhm
X-ME-Proxy: <xmx:7_XSaT7ScXutRmBTtCc730uFNHAh_vVV1Z6jRZjaok1a6euQbxI4tA>
    <xmx:7_XSacsMN6_c36fIgIrMW1d16P6QyUjYafS0DTG3JDk1tI_vwm2epA>
    <xmx:7_XSaTg0YDfsS2ll9uWksKJhiDPxGYnW9eiU2PI_P76SsW1Tn3RPfQ>
    <xmx:7_XSaXrnWipGySpdpI8ZW9KiTxS7kVVHZEnADFUVkTXJpCGAO3kBFQ>
    <xmx:8PXSabX0Jr2vKLp6NJpd7jfcDnmZIOTHC8YLjSfj1Knb2jA3DI_LJhDc>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Apr 2026 19:53:17 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Cc: "Paulo Alcantara" <pc@manguebit.org>, smfrench@gmail.com,
 "David Howells" <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] smb: client: add support for O_TMPFILE
In-reply-to: <20260405233222.GW3836593@ZenIV>
References: <20260405211819.1251369-1-pc@manguebit.org>
  <20260405211819.1251369-2-pc@manguebit.org>
  <20260405233222.GW3836593@ZenIV>
Date: Mon, 06 Apr 2026 09:53:15 +1000
Message-id: <177543319568.1474915.17445767081272255066@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Mon, 06 Apr 2026, Al Viro wrote:
> On Sun, Apr 05, 2026 at 06:18:19PM -0300, Paulo Alcantara wrote:
>=20
> > @@ -436,17 +457,13 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
> >  		goto out_err;
> >  	}
> > =20
> > -	if (newinode)
> > -		if (S_ISDIR(newinode->i_mode)) {
> > -			rc =3D -EISDIR;
> > -			goto out_err;
> > -		}
> > +	if (newinode && S_ISDIR(newinode->i_mode)) {
> > +		rc =3D -EISDIR;
> > +		goto out_err;
> > +	}
> > =20
> >  	d_drop(direntry);
> > -	d_add(direntry, newinode);
>=20
> > +		rc =3D __cifs_do_create(dir, direntry, full_path, xid,
> > +				      tlink, oflags, mode, oplock,
> > +				      fid, buf, &inode);
> > +		if (!rc)
> > +			d_add(direntry, inode);
>=20
>=20
> > +		rc =3D __cifs_do_create(dir, dentry, path, xid, tlink,
> > +				      file->f_flags, mode, &oplock,
> > +				      &fid, NULL, &inode);
> > +		if (!rc) {
> > +			set_nlink(inode, 0);
> > +			mark_inode_dirty(inode);
> > +			d_mark_tmpfile_name(file, &QSTR_LEN(name, size - 1));
> > +			d_instantiate(dentry, inode);
>=20
> I really don't like this "not sure what the state is, d_drop() to
> get it unhashed" pattern, _especially_ when d_drop() and d_add() or
> d_instantiate() get separated.
>=20
> Note, BTW, this d_add() call site is one of the two in the entire kernel
> that are neither d_splice_alias() in disguise nor pass NULL as inode.
> The other one is nfs_link(), where we also have this kind of "d_drop()
> first, then use d_add()" pattern.
>=20
> Folks, what state can dentry be in cifs_do_create()?  I'd rather see
> that sorted out, not obfuscated even more.

cifs_do_create() gets call from cifs_atomic_open() which is
->atomic_open(), so dentry can be in-lookup or negative-hashed.

If is also called from cifs_create() (->create()) and as cifs_lookup()
never skips the lookup due to intent (like NFS does) the dentry will
always be hashed negative.

So dentry can be in-lookup or hashed-negative.  With current APIs we can
avoid d_drop() with

 if (d_in_lookup(dentry))
    d_add(dentry, inode);
 else
    d_instantiate(dentry, inode);

though I would prefer to provide an interface which handled both.

NeilBrown


>=20
> FWIW, that's a major headache for Neil's stuff around directory locking
> changes - any place where we play with unhash-and-rehash needs separate
> analysis.  d_drop() is not something to be used lightly; it obfuscates the
> dentry state and we'll need to translate those to the new locking scheme.
>=20

