Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795125091;
	b=pzXJXoIKyneqRSiLOCRzT6dcd2JDFzoi+MbSKPP7kRPKg/602E+KDjCkfmcXMBuwQ8qw
	 x809h+2jYn1StiPmaHOX5N8PbUs7BU0/x/qKOlNb+gBgXeL4R5rr7Yy460Bte5PQDoHLs
	 CkVchA/S4R4U6i/F2r8Ujb/r0oNoxSjVm1SWAU0/vWPteWOVTUYk1HKQxyoJ0W0xfb+Vf
	 zNOcxgBpbkAy8wOEbxXe80qvwMasbWvkytbXcIybxMNqfeWErDXIQrItT9JotCd2NCMXl
	 kFD7c6JCVg1P6Ugvt/DHxObhTRZogk3NrP/745bhuH52/FcU9Dj+soFxGUsg/2TIgTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795125091;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
	b=Gl0tN/vX48JHrbPElPbf+6OoGLOmAJj3BlY7Gcz/04oO3il2NpajVZQk/7e1q7lmHfHn
	 lPUFX3Ywk3G+xKMHh8KZTXNqtPs7VEuwibmegVa+GrfveeTrjV0+glvdgAk2BIZ9oFB3t
	 rjeTGNxW46IuAzv4Oviu/wvVlfvq3zhLtYpf4R8NozNIf9Ob9TeOFMFmtvTMZmz+VvYIT
	 5IUD9eO41/Z0RslPWtTFcmZixSqxinpZXSGJvYCj3ah/mndwusYwYh22ZrRl0SjOnsLE2
	 afJefkbptb3/1lWGpPjva6wnUsSFdI7yHdyiHaDZUsdrKp5WHk0qOj+uH7yJbu2/yyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IlZfXAdV;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01371606A32A
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 21:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01371606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=IlZfXAdV
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so1142605e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 13:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795125089; x=1795729889; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
        b=IlZfXAdVqjbuXw7jCUzgBXdPvunc6N0Mgo0wFLsi18PRIXDg8h5ImWiXqqG9r5Z3nz
         mMCiHUUIjL1nanBAy+gmMMgf3P/DYPfNI/EhxL6VmuCltURwD+QgSpN5wH9Ap5okdiWa
         y1/JXPn/JLNw5xRoGTUzFUnMvRCF7c7CMfNmwx5ikxXdmn96ekaYhxXTtb8MRXhNYeaS
         5grEbe59oWK77G5W0OdmQ9pOUNCM7ixvwCJgXOuUiJiLHN4zyLRjXQj9XiUl5nqIEgCk
         mpXfVFfEyeVkldYSBLUdPMoMK3O4rNrOnb4CWeh8R4q5zrhhEuhtuEtenWRCvjHT14FL
         k9gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795125089; x=1795729889;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ny3Sl9Bn6sHIvah8OWFokkLcjHbV6BwIAehQvpJWiOM=;
        b=AtoTQqF8Lgyq5AtQD5rViwQM2170/5C30JG7F3CeMO2rtd/I1Ggv2eQyOh8eEXJGLJ
         SylrOxrAXI2Ebd5jh074sOvZwP0PZoeIlF/EO+kbHhnaurt/BXCAgQDRh5zdSCsODxBk
         Pccabh/N8Oj818FIIBM9fWIIvZjpUbzirDV37XUWLOiOBJMV7VhMBMonNglFIzkLEjfq
         npPNv363h+gE7rMRogkUU5u8dQanCL4Dp1wnVE36uoYRNqNTqbsCWqGGeaYOS1y5uirQ
         x2ODGDCNcJrk/gIVofwPZPLA6GllKv+AvuHhRrw79eU1pXmyJkMitOvzDmd08mg4p/Gu
         15CA==
X-Forwarded-Encrypted: i=1; AL+hErGkyFDKYxefVO4rAUNC0Tt1s9ogkYgHptIgMkpah408dCY65w1EWzqd4E24+7VMROjwgxpE7FluQAOY@vger.kernel.org
X-Gm-Message-State: APuU4Z+hIVuekKaLT79H+R7F3tCKE+CEiCl4f6bj3gi+soIb8AZxm0fm
	7b21pTO3/06nCYDX25EuMev3kZ9iMoVsKK1KSu+vyJDUkIoUPN9lX4Ko
X-Gm-Gg: AYBFou23d+jF8S7wk2sCwIWIkRS6PC25NYv5KaFEr2YnZU0sCRmy0a2er1s/arzISCp
	61xANHD3siTJeuVsf+w+g8KrB6CbQOdHvDPY52TzPRyd/m8aCHEGSZVb/JOXF6QQ2MiGgQRpfcz
	4/1XJ0eQrck24DLdGx0vjbBm32eVALhrGBLC5qyh8DpDMFd+fYJfuAKdxDafAqgLbcpCuXmu6We
	rjRtJgd0rqFzfz+F31OBa5UwI1d/I4U8SyqEFqAZg3MnxjqBavoJizpoX7TvhAJk8Be8WD2TKz9
	YbxmMMUiNkOTruWB0PKid0kzqrvDvgnwIM3JHDGQtwjOY9WBiSO7FEkflI9e+A/ELE2uE6IDjkS
	wi7IwEsQf6N/EFJucPf/kGZvdX4Keu1i5AVe8No08IRnyTk8xHLlDARHSo3t1Ij9hQxUkN2CWE3
	QQ1SFU4OkDRdV5vGbxBdvS4cmOYPdKyD2/6PSy58NUnMYxkF6diiSvd365NiQoNZ7b0UUT9mdos
	6fEVa8M+WH8yrwAxorHI5Xh2aOnA3BdFKjHTMHqAxlPyjjIsPBMBSEBa/zVOHKeGqkGU/X3UWG3
	6MvNOAgOpu/71LIHFXzJFh51Q89DE/4GGP3U0tdLju2P9MU=
X-Received: by 2002:a05:600c:4f48:b0:4a6:44b:2593 with SMTP id 5b1f17b1804b1-4bb8893ab9cmr20069015e9.29.1795125089289;
        Thu, 19 Nov 2026 13:51:29 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884a3a3dsm24821245e9.10.2026.11.19.13.51.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 13:51:28 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Thu, 19 Nov 2026 22:51:26 +0100
Message-Id: <DMZIQG4U1NTH.2IN0S2YIWEYTG@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-10-koray.fra@gmail.com>
 <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
In-Reply-To: <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>

--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Thu Nov 19, 2026 at 6:34 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Implement provenance time (ptime) in ksmbd, as introduced in a
>> previous commit ("vfs: add provenance time (ptime)").
>>
>> Map it to SMB's CreationTime, making it settable by SMB clients. When
>> reporting CreationTime to clients, prioritize ptime over da.create_time
>> memorized in the user.DOSATTRIB xattr.
>
> That doesn't sound like the right thing to do.
>
> If the server stored a CreationTime that client had set, you cannot
> override this.

Ah, yes, but how would we handle older files which get a custom
CreationTime both before (in the xattr) and after (in ptime) a kernel
upgrade?

> When the client sets CreationTime, the server can decide if it can and wa=
nts
> (may be a policy decision) to store CreationTime in PTIME and not store
> it in user.DOSATTRIB.

To fix the above problem we should probably keep storing it in both
ptime and the xattr though.

> Fun fact: the user.DOSATTRIB format also has a mask so storing the
> creation time inside it is also optional.

With my current patch series applied, when CreationTime gets set by a
client, ksmbd writes it to ptime and fixes/heals the xattr (=3D removing
the CREATE_TIME flag created by older kernels, see the other fun fact
below).

And another fun fact: until [1] ksmbd ignored the flags and just
read/wrote the attribs every time :) so that can only be honored for
files that have been written to/updated with newer kernels.
(That's why there is the ((flags & CREATE_TIME) || da.create_time > 0)
in my patch, and not just the flag check)

Thanks,
koraynilay

[1]: https://lore.kernel.org/linux-cifs/20261115155308.415734-1-koray.fra@g=
mail.com/

> Thanks,
> Amir.



--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCav9vXgAKCRDmj22qf5IG
XM7AAPsG6qghsrCfCEnMzpWg6QyG3mDtqVzO2LuI2Jbx+5MdmwEAqDTU6SUvXvP1
4H1OcrcMro3Ek7i+OVcH9ZQ2xF4lngw=
=LZNw
-----END PGP SIGNATURE-----

--305c4db69b4b7682b4927e5c7245ccd497c3eba9918a22ec95937c8c862e--
