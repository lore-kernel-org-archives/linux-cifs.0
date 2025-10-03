Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6EF218AAD;
	Fri,  3 Oct 2025 22:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759530661; cv=none; b=WLhxldNlj48is80aU5b/upAv3kbnAJD4zs74fTol4j7SpL0v+bYSh5XBapn/WMYkb4uVlrT+XaLkHQ+UpBvEoVNW76p49lBrGxE52A/3zcwuorTKqquptJyg64l3FFmLpl7uAti8bvpGidB1aG1f6iv9Uvx9CBCQkEWspIkHWZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759530661; c=relaxed/simple;
	bh=Ga65cQuMN6v2JBd0z0s5Gfk4vp6QmhfHtou9in1ENNk=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=Mvq+e35oXUKOCJVyRBwMomE0z8IzOFh12Nsu6NMsVcpejYksFY7KQxICrN9hH/uzWpB9TqnHbXKIV5xx+bxYa8bpagksOkMf11mvn3TfIj/uqzMpKFiiZbyGR9/nKkjzzllKcCI1/h/nWZWrcd6H9F+6mNsytIIgjGF5C1erll0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=aIT3lOSs; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ki0oJkGb; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="aIT3lOSs";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ki0oJkGb"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 4AEB6EC0696;
	Fri,  3 Oct 2025 18:30:57 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 03 Oct 2025 18:30:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm2; t=
	1759530657; x=1759617057; bh=di2ncAb64xtFyI0H9TnTutKfL8cfkb1esKp
	tKpUfeWk=; b=aIT3lOSsHGzGY5+egmvjNs1jfbQNbu9Kb++35Up5/00pyiL8vu6
	npB5ln9vfki76Bf5fXlOfHhc8miS9nTloyMETHq8//MsXPwpagLVn96onlDe2OPX
	SBGYvFZfamcdBWW2U1VYxZH4lFb7EMlIBhwwnu45Eh+ftJh9ulqbmpZ6rAuDCEHp
	MIa0YGSX8sw+Q5rB8r4n/ZcKKQlV1M2PQx/LAOzGI332Xm+zf3hWTB+xrropZvfS
	PGsTFHiW/DqlOLUL4qa7aMROdz7kjVm7Dy8a9cIEBuOChzuma2b47mkjFa5XY9Gr
	9p9eMOOYvRojJQ0zAjQXn37bxncLIaKmxYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1759530657; x=
	1759617057; bh=di2ncAb64xtFyI0H9TnTutKfL8cfkb1esKptKpUfeWk=; b=k
	i0oJkGbbtluYelUqV2PzPon1mBGNHLjhJEHAqmFZeawmsssWDeos4i3E/T0UOQ86
	hC8m1wDwwGKfSFEJbmm8VbBZPD9phOXo9dLGdFkyb39fjrDpQGx5lgs2aCGtC4wc
	3XXe46znhqF3UJuCjGBKYN6xVt7OdIPwd4sCUredQNx1gQog3ojactAwA6XQDyAr
	EXzIGtfS86ZJwF+ZcnNlz/gNKGfcPuh6D8Rt8m44speFo3WK/Qn7KVzZrBu/+JWp
	zVgyz976Euyj1fTZkMp0cssLoWhGsu+ohWHmJ8DHfs89TAb+yTBdw4Q8I4eGb2uD
	V1CNrSDliHBnMyALK/aMg==
X-ME-Sender: <xms:oE7gaDxWQTYLZCkpyPi6S7IGswbP2bSdp4XNQkhBEN4rzXwpdsqStQ>
    <xme:oE7gaLtVPWZGhwbIQybxLOgRSdGsUCDWCMCs3TAclmQHJzdQu4ea4RFxT3gJmJI8j
    oVHcppQm7ll6XlQpduXTH2hdxlFQhQxZMPoP73qHAcnlzCN4w>
X-ME-Received: <xmr:oE7gaOB-jp7nzj1sFefYoDo7i-BJltig9UYNi1EMKiRHANmFYadd-hsUicz8yNL0Y7HKkUY-tm8fDEmFg1y6xhbTzqOTnyJAxIvxEaqDhOBd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeltddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpegtgfgghffvvefujghffffkrhesthhqredttddtjeenucfhrhhomheppfgvihhluehr
    ohifnhcuoehnvghilhgssehofihnmhgrihhlrdhnvghtqeenucggtffrrghtthgvrhhnpe
    eljedtfeegueekieetudevheduveefffevudetgfetudfhgedvgfdtieeguedujeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghilhgsse
    hofihnmhgrihhlrdhnvghtpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehmrghrkhhushdrvghlfhhrihhnghesfigvsgdruggvpdhrtghpth
    htoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghp
    thhtoheplhhinhhugidqtghifhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepkhgvrhhnvghlqdhjrghnihhtohhrshesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehtohhmsehtrghlphgvhidrtghomhdprhgtphhtthhopehmvghtiigvse
    hsrghmsggrrdhorhhgpdhrtghpthhtoheplhhinhhkihhnjhgvohhnsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehsmhhfrhgvnhgthhesghhmrghilhdrtghomhdprhgtphhtth
    hopehsvghnohiihhgrthhskhihsegthhhrohhmihhumhdrohhrgh
X-ME-Proxy: <xmx:oE7gaFEs9TZiKXg4VevMAoBe03qVROSfsBVW7Y_CgTsD3cUODSKMHw>
    <xmx:oU7gaGDdhjjSxbWj0zKdplZm2VOuZxsV1XYiFlZtSeGQbJZnvt1FjA>
    <xmx:oU7gaDmDRcGgVIegfuTeluIld7MNiBpzlgCjLhl8ko2Cw9IKBSFgVQ>
    <xmx:oU7gaEPtJ4GIO5rjiZeye1RDbgzlf2RCwYD0dWcz9Z7iMj5CWc1sZg>
    <xmx:oU7gaC8juepaD63j511jZkPLE9jXly_rXeAQslz0NbP0uQfna35MHeCG>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 18:30:54 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Markus Elfring" <Markus.Elfring@web.de>
Cc: linux-cifs@vger.kernel.org, "Namjae Jeon" <linkinjeon@kernel.org>,
 "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "Steve French" <smfrench@gmail.com>, "Tom Talpey" <tom@talpey.com>,
 "LKML" <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 "Stefan Metzmacher" <metze@samba.org>
Subject:
 Re: [PATCH] ksmbd: Use common error handling code in ksmbd_vfs_path_lookup()
In-reply-to: <6d759211-79e7-4d86-b22e-2ae46d209622@web.de>
References: <6d759211-79e7-4d86-b22e-2ae46d209622@web.de>
Date: Sat, 04 Oct 2025 08:30:46 +1000
Message-id: <175953064635.1793333.2429881029964457140@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sat, 04 Oct 2025, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 3 Oct 2025 20:26:56 +0200
>=20
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function implementation.

I think this is a good cleanup - thanks.  But I think it could be even
better.

- rename the "path" parameter to "return_path" or similar.
- declare  struct path path __free(path_-put) =3D {};
- change all "path->" instances to "path."
- remove all those path_put() calls, but leave the "return xxx"
- at the point of successful return, use

   return_path->dentry =3D no_free_ptr(path.dentry);
   return_path->mnt =3D no_free_ptr(path.mnt);
   return 0;

This is based on the pattern in kern_path_parent() and
__start_removing_path().

Thanks,
NeilBrown


>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/server/vfs.c | 32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 891ed2dc2b73..3535655b4d86 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -94,17 +94,13 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_con=
fig *share_conf,
>  	if (err)
>  		return err;
> =20
> -	if (unlikely(type !=3D LAST_NORM)) {
> -		path_put(path);
> -		return -ENOENT;
> -	}
> +	if (unlikely(type !=3D LAST_NORM))
> +		goto put_path;
> =20
>  	if (do_lock) {
>  		err =3D mnt_want_write(path->mnt);
> -		if (err) {
> -			path_put(path);
> -			return -ENOENT;
> -		}
> +		if (err)
> +			goto put_path;
> =20
>  		inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
>  		d =3D lookup_one_qstr_excl(&last, path->dentry, 0);
> @@ -116,8 +112,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_con=
fig *share_conf,
>  		}
>  		inode_unlock(path->dentry->d_inode);
>  		mnt_drop_write(path->mnt);
> -		path_put(path);
> -		return -ENOENT;
> +		goto put_path;
>  	}
> =20
>  	d =3D lookup_noperm_unlocked(&last, path->dentry);
> @@ -125,21 +120,22 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_c=
onfig *share_conf,
>  		dput(d);
>  		d =3D ERR_PTR(-ENOENT);
>  	}
> -	if (IS_ERR(d)) {
> -		path_put(path);
> -		return -ENOENT;
> -	}
> +	if (IS_ERR(d))
> +		goto put_path;
> +
>  	dput(path->dentry);
>  	path->dentry =3D d;
> =20
>  	if (test_share_config_flag(share_conf, KSMBD_SHARE_FLAG_CROSSMNT)) {
>  		err =3D follow_down(path, 0);
> -		if (err < 0) {
> -			path_put(path);
> -			return -ENOENT;
> -		}
> +		if (err < 0)
> +			goto put_path;
>  	}
>  	return 0;
> +
> +put_path:
> +	path_put(path);
> +	return -ENOENT;
>  }
> =20
>  void ksmbd_vfs_query_maximal_access(struct mnt_idmap *idmap,
> --=20
> 2.51.0
>=20
>=20
>=20

