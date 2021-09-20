Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0239C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 13:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EAC61019
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 13:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239711AbhITN7W (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 09:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbhITN7V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 09:59:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED314C061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 06:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=rMRScaIFwL1zkqyGTbcr0FI90ry9E6L5qAE+pz/m8zk=; b=BIbo8LSDq63VKzYSqd+cwLVa3L
        AhSok5Sm0Uf6ic0+YtvhTeYUnXLkrfeUv9ukZcjCfC9eH9xa3iE3LsHMdUmspqaTI2rVMswBym/ix
        CAr/iFch5++msnGmu/amziX0l4Lmeo/TmWdLqvGwEtXkwZVIemLkuROdFNDll9w+jO0jHwUKkPOj9
        7lAJK+a5r8opidAex0GeevPR3Urn4TBWhW6h6qtaJUEJRIO2gNndu7eL33M1QsqiWJlXYzrUOSUhx
        i3wP8cUlSn/2kePL5Jz3oJNbGlH6l6T8jtOVR1ym4EgeHmEUkfAUi7pkry8JWrD2uTHkgZE0Gqzne
        Lb8KGrUpTdjxaCwisCjMsR+WPc8bMA0lM+C5bIaNuoenRaHQdfxVb7Ab8xfp2cRBN5VO85BCkNtFA
        I2W2ex+A2INiAf7nWYjEJ1WQ67ORiBmbYXGHQ9iLojtL4yTCM+Q1+tb9XhUqJgQmk819NohIXC4pj
        bYlE6ObhNVbrGN7Rai+Hewos;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSJnr-006zdO-14; Mon, 20 Sep 2021 13:57:51 +0000
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210920065613.5506-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
Date:   Mon, 20 Sep 2021 15:57:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920065613.5506-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5G5KNPAAcK0ZDoz7cz1A34eQQodtcXbSl"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5G5KNPAAcK0ZDoz7cz1A34eQQodtcXbSl
Content-Type: multipart/mixed; boundary="XDTEMP2P8mHeCiPcXNciMHaFTP2h53AI4";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <6e8b6c79-3394-f39c-8e1b-06b3c2950a28@samba.org>
Subject: Re: [PATCH] ksmbd: remove follow symlinks support
References: <20210920065613.5506-1-linkinjeon@kernel.org>
In-Reply-To: <20210920065613.5506-1-linkinjeon@kernel.org>

--XDTEMP2P8mHeCiPcXNciMHaFTP2h53AI4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

Am 20.09.21 um 08:56 schrieb Namjae Jeon:
> This patch remove symlink support that can be vulnerable, and we
> re-implement it as reparse point later.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 55 ++++++++++-----------------------------------=
-
>   fs/ksmbd/vfs.c     | 50 +++++++++--------------------------------
>   2 files changed, 21 insertions(+), 84 deletions(-)
>=20
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index afc508c2656d..911c5e97678d 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2661,17 +2661,7 @@ int smb2_open(struct ksmbd_work *work)
>   	}
>  =20
>   	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
> -		if (test_share_config_flag(work->tcon->share_conf,
> -					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
> -			/*
> -			 * On delete request, instead of following up, need to
> -			 * look the current entity
> -			 */
> -			rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
> -		} else {
> -			rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
> -		}
> -
> +		rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
>   		if (!rc) {
>   			/*
>   			 * If file exists with under flags, return access
> @@ -2693,24 +2683,11 @@ int smb2_open(struct ksmbd_work *work)
>   			}
>   		}
>   	} else {
> -		if (test_share_config_flag(work->tcon->share_conf,
> -					   KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS)) {
> -			/*
> -			 * Use LOOKUP_FOLLOW to follow the path of
> -			 * symlink in path buildup
> -			 */
> -			rc =3D ksmbd_vfs_kern_path(name, LOOKUP_FOLLOW, &path, 1);
> -			if (rc) { /* Case for broken link ?*/
> -				rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
> -			}
> -		} else {
> -			rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS,
> -						 &path, 1);
> -			if (!rc && d_is_symlink(path.dentry)) {
> -				rc =3D -EACCES;
> -				path_put(&path);
> -				goto err_out;
> -			}
> +		rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
> +		if (!rc && d_is_symlink(path.dentry)) {
> +			rc =3D -EACCES;
> +			path_put(&path);
> +			goto err_out;

why the the check for d_is_symlink()? Wouldn't ksmbd_vfs_kern_path()=20
just return -ELOOP if a path component is a symlink? Hence I guess the=20
below if (rc) where we handle EACCESS should be expanded to handle ELOOP.=


I guess I would also refactor the

if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)

logic in a previous commit to change the codeflow so there's only one=20
call to ksmbd_vfs_kern_path().

>   		}
>   	}
>  =20
> @@ -4795,12 +4772,8 @@ static int smb2_get_info_filesystem(struct ksmbd=
_work *work,
>   	struct path path;
>   	int rc =3D 0, len;
>   	int fs_infoclass_size =3D 0;
> -	int lookup_flags =3D LOOKUP_NO_SYMLINKS;
>  =20
> -	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -		lookup_flags =3D LOOKUP_FOLLOW;
> -
> -	rc =3D ksmbd_vfs_kern_path(share->path, lookup_flags, &path, 0);
> +	rc =3D ksmbd_vfs_kern_path(share->path, LOOKUP_NO_SYMLINKS, &path, 0)=
;
>   	if (rc) {
>   		pr_err("cannot create vfs path\n");
>   		return -EIO;

why doesn't this return rc?

> @@ -5307,7 +5280,7 @@ static int smb2_rename(struct ksmbd_work *work,
>   	char *pathname =3D NULL;
>   	struct path path;
>   	bool file_present =3D true;
> -	int rc, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> +	int rc;
>  =20
>   	ksmbd_debug(SMB, "setting FILE_RENAME_INFO\n");
>   	pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
> @@ -5376,11 +5349,8 @@ static int smb2_rename(struct ksmbd_work *work,
>   		goto out;
>   	}
>  =20
> -	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -		lookup_flags =3D LOOKUP_FOLLOW;
> -
>   	ksmbd_debug(SMB, "new name %s\n", new_name);
> -	rc =3D ksmbd_vfs_kern_path(new_name, lookup_flags, &path, 1);
> +	rc =3D ksmbd_vfs_kern_path(new_name, LOOKUP_NO_SYMLINKS, &path, 1);
>   	if (rc)
>   		file_present =3D false;

I guess this should handle ELOOP?

>   	else
> @@ -5430,7 +5400,7 @@ static int smb2_create_link(struct ksmbd_work *wo=
rk,
>   	char *link_name =3D NULL, *target_name =3D NULL, *pathname =3D NULL;=

>   	struct path path;
>   	bool file_present =3D true;
> -	int rc, lookup_flags =3D LOOKUP_NO_SYMLINKS;
> +	int rc;
>  =20
>   	if (buf_len < sizeof(struct smb2_file_link_info) +
>   			le32_to_cpu(file_info->FileNameLength))
> @@ -5457,11 +5427,8 @@ static int smb2_create_link(struct ksmbd_work *w=
ork,
>   		goto out;
>   	}
>  =20
> -	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS))
> -		lookup_flags =3D LOOKUP_FOLLOW;
> -
>   	ksmbd_debug(SMB, "target name is %s\n", target_name);
> -	rc =3D ksmbd_vfs_kern_path(link_name, lookup_flags, &path, 0);
> +	rc =3D ksmbd_vfs_kern_path(link_name, LOOKUP_NO_SYMLINKS, &path, 0);
>   	if (rc)
>   		file_present =3D false;

same here?

Other then that: lgtm. Oh, besides, guess this needs an accomanying=20
change to ksmbd-tools?

Cheers!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--XDTEMP2P8mHeCiPcXNciMHaFTP2h53AI4--

--5G5KNPAAcK0ZDoz7cz1A34eQQodtcXbSl
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFIk14FAwAAAAAACgkQqh6bcSY5nka5
WhAAwulS9IWK8WjdcWG6fFht77ISgO+WT8WuHO7bzupxZDaVmdDyKXlsP6JV4xAEgkrVz5jFecjE
nIVzGrGWT1M8Wl4Ym7aUyRBkHchTzb1jY5QPRHEL1+1WR2w+ZYZf77PCPySIpvLtse0c3kF9H2QR
k5WwWhOIaAHJxkuDeILkHoLXmWbroXTzhzciIrY5eYJWnvqsTQ7rC+OAscdgYCMK3nx51tQd/pU/
Q7cw1iJT9Ot/Vnae4QUAc8WbMQf+F9eZhNnml8HLhFwp6IgatiUm+gf0ziHxePTNz2b+aflKDVkr
y4AZaATcVYDvVqR2JA3VM3AUTtfZGksCwJvj///TC++QUdaTFk39Xc2jkGoB/kvsXRJuBZb1bsyJ
7mVs/UtPLbgrij0yjY7+UX4OBgHu/45Wqm3AE3YnIStlVYpUwfQOs5NPaz9ordaJ4GDzK9r4x/3e
7Ps78k/OXUVE/RihB1jbtLbIlxh+q2bM/k44zWKTftVqBUaPkmGRcKNKPDKzL7KR103OQYLaIMiA
Mc/vJvtLaqKfF+VHXS9P2knazaBDkY5NftAyECF+5oO5BG6a7u+N6cI9MZyKPno7k1+07stAtI5c
dIN67h/qAZ9U+f6G0ubKukFeQtsn5m1X0IdsRkNjmRl13WmU0m5vhnALKMv64WNf1OC3rgLlDxDY
ufw=
=2p5B
-----END PGP SIGNATURE-----

--5G5KNPAAcK0ZDoz7cz1A34eQQodtcXbSl--
