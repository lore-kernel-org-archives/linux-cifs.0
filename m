Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7667C78F44
	for <linux-cifs@vger.kernel.org>; Wed, 12 Mar 2025 01:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741742931; cv=none; b=ITdN6ncQkYav8Uq98XsCZQYzQDSiIz8LwFc+khesvU6y8qb4reI937TTm7aAoB4HmZmt+MiEaHlAGA1Rh5lqXDOhkae3iwSKSCJ3ujBnx25OCK/6rsWnwiVgpoB5aAyhsztgb48tKBTkv/SgXq03OhmAKl8zFQe/VVxls/ZH5yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741742931; c=relaxed/simple;
	bh=2sqnU0JFa0x8LVfK/uOR4msCIUJyZa62DEiDswullgA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RBug2maMeoBj5WKA/PhpZqQZviuEN9tcdQhpHmvqAy4jgyuuuhIst5EtclZ3eH+8ktSSbg10xJXzDIgESv19XWSRi12ZBy7GdCv9znYYXFGwUQfrdlJZY0RUbMLTkclBIH316sz37PTYQV3uz7ez9r2+2kbyRM/CSbxq4pYFawk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RXAqw5rM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RXAqw5rM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741742928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M0r84Ri62vMcihc9HdcYuIoC1yO+/C57B7Ff+eEFLaw=;
	b=RXAqw5rMGgkSRq6DTFK3MklDxMGfo9601CFaGIGvC5DJCSMg/on+du05qHNIDLKJRRNZKc
	RA8NpNJRfWwEh7u38hZ0PPpdr3JLJ5QlylObL0HgLBSHwP126Dbfkkn+uHzCseQQzAD9Jn
	wUlKDInYGRQNRSC3+suK82V0svLL+V0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-DY01e9rrPhCNVXjtOjujZg-1; Tue, 11 Mar 2025 21:28:46 -0400
X-MC-Unique: DY01e9rrPhCNVXjtOjujZg-1
X-Mimecast-MFC-AGG-ID: DY01e9rrPhCNVXjtOjujZg_1741742925
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ff798e8c90so8951119a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 18:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741742925; x=1742347725;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M0r84Ri62vMcihc9HdcYuIoC1yO+/C57B7Ff+eEFLaw=;
        b=LIMNdefYuvZrg2BwIUA1tMyiv0oAAVV2oU8xnodlX4OtUI4/HtGmmoKuPAMTF7Ddt1
         fza0jY3GjkZBdU1RTE+aOOH6LkpZZeyCzCSU91lSRP8nXI4ehlgtDMwm488eapJdboxP
         dvq6g4H7rX9bRQKQLSCts1QWPXwA+xHVMd7b6yHe+WbbrpyuUwrJ/wUuLobz2UuZQcyy
         /IQCWGrCmQRAgJTh+oEbd7wvXDWTftbD70oIRPDGIcYY5FX25Wgrn8D1tioEnoWxPIVm
         Nxel2n9rO4D+a+R+Czctlg9bLkOHLWRovHhJjLx0rEaOgpxEkSD2K1PnE6yfdOlgeTZk
         fBWw==
X-Forwarded-Encrypted: i=1; AJvYcCX5EfJdvWipVPKvf3kw4N/VEFsM5uzGku768ZfUKbseb3Yr3NwbUoePRM0fA203j8KGsjSzC9xo3iNg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0S3eukwTIhA9zk1c2qbFU+1Iub1N7LN3jQEK7LQmu5IHaUcRh
	GSB3AqL0LY5xscSZCo/YiCY6X06huNJv5jxaHodliryA6EWwcPnSv69VzDPiVHGQ6bHTDTLo4X8
	Lpu6ADxmqYUg55MSUlCEuxQ2l2trl1qcoYQEtQmL8IRH3UWvlq9Swp2F0wA==
X-Gm-Gg: ASbGncvTEzhrrmcrUXwaoDHYiYJ1TCfDqOXNlWC0jVDbFSeobMBTTefYx1h3r8uYS9F
	IYXixN/uRI6QprNc1QPP/TIXjwtbFlgY88RBwpN6hEbYq4QM/YJ0zmXzTPznul5qWwq9QvelLBU
	+8g9wkzMGATmLBd6ABw1uQQfhmowtPz7ovxgobM59Ar2IGjhMdgsGBgyGAsqNofOKdpKFRFzKuU
	yZfdd0dy35aHboQ2WC8aHtjd1tmlUQ8Ca6cWcUWNPO1eockM+9WPMCs/yi0MRaVwRds/nfGIKyg
	l++4QU6tpN2544uILsL82bS2X69DAeI7PR+t
X-Received: by 2002:a17:90b:4a43:b0:2ee:8e75:4aeb with SMTP id 98e67ed59e1d1-2ff7ce89e00mr32970823a91.17.1741742925394;
        Tue, 11 Mar 2025 18:28:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPuRpP2Gia0vpcvhLRdpfhJhd9G4f/RjwAXEDatzA9hquYo2knRaKs5/3U0TtS3ZZsguO3FQ==
X-Received: by 2002:a17:90b:4a43:b0:2ee:8e75:4aeb with SMTP id 98e67ed59e1d1-2ff7ce89e00mr32970794a91.17.1741742925009;
        Tue, 11 Mar 2025 18:28:45 -0700 (PDT)
Received: from omnibook.happyassassin.net ([2001:569:7cd5:ea00:c6fc:c4e9:3726:7db0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30118230a91sm316231a91.11.2025.03.11.18.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 18:28:44 -0700 (PDT)
Message-ID: <1f422c3745551dc1053e5de4857f9b123ec66889.camel@redhat.com>
Subject: Re: Anonymous mount of CIFS shares fails with cifs-utils 7.2 unless
 'sec=none' is added to mount options
From: Adam Williamson <awilliam@redhat.com>
To: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Date: Tue, 11 Mar 2025 18:28:43 -0700
In-Reply-To: <e64f3f2231064e771423f32865361c10@manguebit.com>
References: <83c00b5fea81c07f6897a5dd3ef50fd3b290f56c.camel@redhat.com>
	 <e64f3f2231064e771423f32865361c10@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41app1) 
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-03-11 at 17:12 -0300, Paulo Alcantara wrote:
> Adam Williamson <awilliam@redhat.com> writes:
>=20
> > I have this line in my /etc/fstab to mount a local network CIFS share
> > that requires no authentication:
> >=20
> > //192.168.1.9/Media		/mnt/data             cifs    noauto,nosuid,soft,g=
uest,uid=3D99,gid=3D99,file_mode=3D0777,dir_mode=3D0777,users,vers=3D3.0	0 =
0
> >=20
> > With cifs-utils 7.2, this suddenly doesn't work. I get an 'invalid
> > argument' error, and in dmesg:
> >=20
> > cifs: Bad value for 'password2'
>=20
> Yes, this is a regression.  The problem is that cifs-utils-7.2 is now
> passing an empty password2=3D for guest authentication and the kernel
> can't handle it.
>=20
> Does the following fix your issue
>=20
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index e9b286d9a7ba..456948d4f328 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -171,6 +171,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] =
=3D {
>  	fsparam_string("username", Opt_user),
>  	fsparam_string("pass", Opt_pass),
>  	fsparam_string("password", Opt_pass),
> +	fsparam_string("pass2", Opt_pass2),
>  	fsparam_string("password2", Opt_pass2),
>  	fsparam_string("ip", Opt_ip),
>  	fsparam_string("addr", Opt_ip),
> @@ -1125,7 +1126,10 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>  	 * we will need special handling of them.
>  	 */
>  	if (param->type =3D=3D fs_value_is_string && param->string[0] =3D=3D 0)=
 {
> -		if (!strcmp("pass", param->key) || !strcmp("password", param->key)) {
> +		if (!strcmp("pass2", param->key) || !strcmp("password2", param->key)) =
{
> +			skip_parsing =3D true;
> +			opt =3D Opt_pass2;
> +		} else if (!strcmp("pass", param->key) || !strcmp("password", param->k=
ey)) {
>  			skip_parsing =3D true;
>  			opt =3D Opt_pass;
>  		} else if (!strcmp("user", param->key) || !strcmp("username", param->k=
ey)) {
>=20

Yes, it does. Thanks.
--=20
Adam Williamson (he/him/his)
Fedora QA
Fedora Chat: @adamwill:fedora.im | Mastodon: @adamw@fosstodon.org
https://www.happyassassin.net




