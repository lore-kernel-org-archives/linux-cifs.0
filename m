Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51BD44683D
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787586000; cv=pass; b=J+/EQi9SRjCyjMirez5Lh0J7UiJdLR2GAm8qNTvbm2XOsbE57h56Ys1g8cNJrwedBNBI1tmUYgwKGHcKQYW4JL/KbshIuuQVfbOfxcH46w1KCDkUnj/E20hJcAVxkU9+1PtT1bM4Z2nVh6ZEPyV8eOuCcqaC5vxpME3G8vAy3w8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787586000; c=relaxed/simple;
	bh=TKa+7Rt0HMct/L3Y9OQKcWqR+kqwOl5wJxjs0oMkUU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OWxr0g7aPnJa7eStHAvJVJmXoX1jwIdWYC8zVH+O/xjPLVTybRaeymtiL8RpwbKGmUv2+taB8xeeW2qvqvwBymnDGy+wPh1bUPmbax9Qb+H78/rxbFkiKLeFV5S9n6NgBkLNSrITlGtTLKw4irMzpI5zSxd7ekaJwU+v7RXtPow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W3PgV/+u; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W3PgV/+u"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a422090b2fso5366179a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 08:39:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787585997; cv=none;
        d=google.com; s=arc-20260327;
        b=ODRkya/nkS+G4TFhVpEFklbnciv0UuSb2Wxkygl0QROojTsFbjyN/whPRbLXllZtyo
         aeMGvl6ly4rFIdQsB4RiPfe3CtSF1NWf2dLguKkBUeEJ1GgtR93OMghXIGgLCbUB5qtc
         EgwQVicKa+IYWwORwyv6OuRwqMsF+VYxSZQmGPi4rgE/yKZvOQo5M+MP6uoudqE4UrfK
         mE6wrpVYuWLC1Gt/1i+tOC85hwMrlOHvX85GDo/fYT+A31DkNRBT0M9FZ/oIqecLNgPq
         6W7+8zJ/RXVzkDT3QUq8bmTePKgwzOAlFbv5Zal4drq/lolqI/6k+mmFz1vMvTstdI9v
         8cKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
        fh=QjvIug82DAcMJ90CENlYAjVS2LfROPLHVsBC0M9znMw=;
        b=GbVKuJmfu56i3suWmPjLT/hS6oReLpBu09rVhVnaTSkZlods3Sl0PiNMNJfwbj8jeP
         AtOnKeFm25dQFmFuM922je7WVrAnB11p1gGRy6co/BpFn+E9UoI/8Z/1yxsoAdjakTNQ
         6tA+MAjuAnPKCO/TPHs1rv13hgAs6lN6uK832xti4IEulHkY99R+EkK3uUyDVuFN4HDD
         Qp8NZx7ztynPzXkSS/opltSSEAz2BgL/Lajugu8OOgmF/cQB8deRx/ext9d1o8j6kwtN
         xgjXN3edcLZGscHxU+GyqpAdNJo4uSZbRjtHs0Dd7yRDtDecVo4T2dZOOgK+bNFyyzJV
         UzEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787585997; x=1788190797; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
        b=W3PgV/+uOfQUz8pF76YCRrs84UlPEQPXY6HtwG0yI1HdTUh2ba/YB+1YJpUAS8XdXn
         Nx3XJL9Oc00PyQABJxkNHFOgjCSoI/xWe345bzxJ/b+/kz+4kSbygw7HCiQgxjGaaY4w
         sghmbsvrUQl3pnPyXdGdA9OZQnrQ3Opb24oUwzcYrUtP9FEkKTZuwypkY5AjwFbFS7XO
         yXa9rXb/qmJZWLA0UVIlNsn2+ODVi/ShtKx/zqYe1EQzakHcxF5auvyTFihZJF/CcTTj
         7uN/TKfLsHjfnw2WMoiN/6eXZExCjtCWKoYymHKhPSIbWZYRwFyYcpRQTDjzw//We5Rb
         2vuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585997; x=1788190797;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wJCHcWH/H7HoSqeQAsfWyCv2ylIhs9AEwOmpHAgZ6Mo=;
        b=fPrc42qA3R+h0nbS8Py7TxWFu/LEfC0wDTqSYq3gkctj5wE1GrZPfqsI6yZZvuqiog
         eKeUPZm0QBshpJgTXd9bl16gwKdN01lKWIwdLr/EnXyV7An0JY1fr3A3f2WM1JcbEuDw
         4nK6/sd+OvW9AFN2G4qZbB95DsGsu3wIqiuMU/UYv+/scVQIo87eClX7G7utLaNuGVCL
         oSjZ2VqjQbjDPk8q6kDOa+lY2yAcMGPAkl6ARoRL0WIvsJ5SX5cQJADCfmjTrhKfIz8g
         f6Kpcv5m5p6wBfQ3mBAlBJmpzAdoIMFzaUZ8nirqhbAIpJ1byagWZpp6LxCf3gQcW1Ri
         hYMQ==
X-Forwarded-Encrypted: i=1; AHgh+RpaPxSyD4ds6fjWJ9XqpUYK+BRpB6A6V3TKOH8v0Ld5iS9sxGANov0/nWPIViReZosKv/E8x8e/gPc2@vger.kernel.org
X-Gm-Message-State: AFuF++k9FZ5zmv4JZybzZhgqIM+sd8stLHkvE5Pm7MYMxJb/JKrOTMv9
	kp/qD1KNu2fPL1nzE4Hq/WGs5wjGlyI8xcXK4j5U8QighezAOD7mSPyBT9pRCIiCiuXZXFbqUg5
	Nk1jxbF8uRmrIJzTi3r5nhbXLSSHYtoY=
X-Gm-Gg: AR+sD13J6/z7utGIQhJ9Ok2Nq7Yi6R1l6dSj5chjgMWCsTv56UgN2cvJPcbHL0lj2r5
	lxhPbf3LXUWV8PgfE82ZKE8LmpbrcG4Gfm5XSFdHWwz+fuSjLYU5ERr5FC3VGmyKYo8BsJsby89
	5uvvI5yYZRU5e4SGjXGEkxGn5IPJjQHtLgY1e0XvmKKtzvJlpMsT8qY2Inlj0pE9iH7xtOXLSA7
	JR2SL6b0if+AwgOZLCStGhzHe8b6BDTR4hQbsG531Cl1wvlq3jrepWl9xyoSVIdhYOUDPkrcAJL
	hwMqp8mfVzY24bZLI1yz+SPfv7fcqrYCscIh8nhu30zC6UdeypnY1bfiV0jOjioLQuDZsoF5wEo
	U
X-Received: by 2002:a05:6402:1ecb:b0:6a0:dda3:83db with SMTP id
 4fb4d7f45d1cf-6a42eec0421mr29612154a12.0.1787585996720; Mon, 24 Aug 2026
 08:39:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824144130.759997-1-dhowells@redhat.com> <20260824144130.759997-31-dhowells@redhat.com>
In-Reply-To: <20260824144130.759997-31-dhowells@redhat.com>
From: =?UTF-8?Q?Aur=C3=A9lien_Couderc?= <aurelien.couderc2002@gmail.com>
Date: Mon, 24 Aug 2026 17:39:20 +0200
X-Gm-Features: AcwNN1UVhOm3jvQyZ6QNY0YG-DuDugP0zSGCGTU-9BV_0e1-yGju4sTdJrlUq5g
Message-ID: <CA+1jF5qPZUhCevwbu7zQDEVWss6gMdoDMhqKqH3k7v=WStRtEA@mail.gmail.com>
Subject: READ_PLUS in NetFS? Re: [PATCH v10 30/35] netfs: Simplify read abandonment
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Christian Brauner <christian@brauner.io>, 
	Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Leon Romanovsky <leon@kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Stefan Metzmacher <metze@samba.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Dominique Martinet <asmadeus@codewreck.org>, Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev, 
	linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org, 
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>, ceph-devel@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 5:04=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Currently, if one or more of the subrequests in a read request fails, the
> read collection algorithm will attempt to salvage folios that are fully
> downloaded but that span multiple subreqs, provided all of the contributo=
ry
> subreqs succeeded, but this makes the algorithm quite complicated as a
> subreq can contribute to multiple folios and a folio can be contributed t=
o
> by multiple subreqs.
>
> Simplify this by just abandoning the rest of a read request once a
> permanently failed subreq is hit.  This is what read_folio, DIO/unbuffere=
d
> read, gap filling, RMW and write preload all need to do; readahead is the
> odd one out as it doesn't have any return other than unlocking folios.
>
> With this change, even for readahead, the rest of the read is simply
> abandoned; read() and suchlike will call ->read_folio() on each
> non-uptodate folio to retry and retrieve the error.
>
> Note that retryable failures still get retried by netfslib as part of the
> request as before.

What about READ_PLUS, i.e. sparse file reads? If you do this kind of
work of handling partial abandonment, can such a work also benefit
READ_PLUS?

Aur=C3=A9lien
--=20
Aur=C3=A9lien Couderc <aurelien.couderc2002@gmail.com>
Big Data/Data mining expert, chess enthusiast
