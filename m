Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67105C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 07:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A6760F23
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 07:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhIUHfD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 03:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhIUHfB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 03:35:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE596C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 00:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=YWfzNKhNvLJLOrWn0HICX+6w/0waAYdZAbVq62yscsI=; b=tqvyrLZ7fBgyeGP3Uk2ovL6ag6
        IrwE1JtikWBKGM+MTNvOmybbdAgZAjUBDCG8ciabaTZoI/Ehq+2gxB7WInBLdnnJqiZmwIKNO3lY7
        hKImY7ymaGOxryG7+5azd/uALpeodxcpjIWCYBfLJ0oAfpxpszQVCiFosD1YBNTCPJ91ytrfj7kot
        sD6yfEm/bAExI7dV0zrZtU+mx1vzj+XRNxJle/y5ZVuw7YxRmsVA+ALZKuAQZ2zIfPHyHWjI0mj/Y
        X52v4wA/Qtl5RkiG+XvHzgwv4XBxBNj+Iv5DFJvoarjsxWwzJOPQWiwuH156OXaIMjQ6sfeI831kQ
        yUPMUfhFaRXNb/gPizmCAaok7Df+QthiUSFbnMLl/u8KIcbxoeWEDzh/XA147VAlIsgPHowzQkAB1
        reM/mcGVBCnPONCrPeHYNUTbFft6CMVZFBkbmtdinbqBoD9TzljdDzCjVyNyMKQs7nZeGtyFy68n1
        KFm3YqFnacZO6+0PSa6zL6Is;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSaHS-0077bE-Dx; Tue, 21 Sep 2021 07:33:30 +0000
Subject: Re: [PATCH v3] ksmbd: remove follow symlinks support
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <20210921051933.626532-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <dd7f6ca6-bef8-1f5e-53cc-83646c988e80@samba.org>
Date:   Tue, 21 Sep 2021 09:33:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921051933.626532-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iS0UvLSWpfjAYrls8qi3NjFyBybgulZaQ"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iS0UvLSWpfjAYrls8qi3NjFyBybgulZaQ
Content-Type: multipart/mixed; boundary="XZCiYSlJxrBoEpv8gYUxCKXJVFs3xnezI";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>
Message-ID: <dd7f6ca6-bef8-1f5e-53cc-83646c988e80@samba.org>
Subject: Re: [PATCH v3] ksmbd: remove follow symlinks support
References: <20210921051933.626532-1-linkinjeon@kernel.org>
In-Reply-To: <20210921051933.626532-1-linkinjeon@kernel.org>

--XZCiYSlJxrBoEpv8gYUxCKXJVFs3xnezI
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

excellent! One issue below.

Am 21.09.21 um 07:19 schrieb Namjae Jeon:
> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the middle=
 of
> symlink component lookup and remove follow symlinks parameter support.
> We re-implement it as reparse point later.
>=20
> Test result:
> smbclient -Ulinkinjeon%1234 //172.30.1.42/share -c
> "get hacked/passwd passwd"
> NT_STATUS_OBJECT_NAME_NOT_FOUND opening remote file \hacked\passwd
>=20
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   v2:
>    - reorganize path lookup in smb2_open to call only one
>      ksmbd_vfs_kern_path().
>   v3:
>    - combine "ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup"
>      patch into this patch.
>=20
>   fs/ksmbd/smb2pdu.c | 43 ++++++++++---------------------------------
>   fs/ksmbd/vfs.c     | 32 +++++++++-----------------------
>   2 files changed, 19 insertions(+), 56 deletions(-)
>=20
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 4399c399284b..baf7ce31d557 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2660,13 +2660,9 @@ int smb2_open(struct ksmbd_work *work)
>   		goto err_out1;
>   	}
>  =20
> -	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
> -		/*
> -		 * On delete request, instead of following up, need to
> -		 * look the current entity
> -		 */
> -		rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
> -		if (!rc) {
> +	rc =3D ksmbd_vfs_kern_path(name, LOOKUP_NO_SYMLINKS, &path, 1);
> +	if (!rc) {
> +		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
>   			/*
>   			 * If file exists with under flags, return access
>   			 * denied error.
> @@ -2685,25 +2681,10 @@ int smb2_open(struct ksmbd_work *work)
>   				path_put(&path);
>   				goto err_out;
>   			}
> -		}
> -	} else {
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
> -			rc =3D ksmbd_vfs_kern_path(name, 0, &path, 1);
> -			if (!rc && d_is_symlink(path.dentry)) {
> -				rc =3D -EACCES;
> -				path_put(&path);
> -				goto err_out;
> -			}
> +		} else if (d_is_symlink(path.dentry)) {
> +			rc =3D -EACCES;
> +			path_put(&path);
> +			goto err_out;

I wonder whether the d_is_symlink() check should be done *inside*=20
ksmbd_vfs_kern_path()? The idea being having one function where the=20
required semantics are implemented without bleeding logic stuff in the=20
callers. ksmbd_vfs_kern_path() could simply return -ELOOP if *any* path=20
component is a symlink.

Then of course the question is how to handle this in some callers to=20
make the decision what how to present the directory entry to the caller.

For example in ksmbd_vfs_readdir_name() I'm not sure if we return file=20
metadata from the link target.

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--XZCiYSlJxrBoEpv8gYUxCKXJVFs3xnezI--

--iS0UvLSWpfjAYrls8qi3NjFyBybgulZaQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFJisgFAwAAAAAACgkQqh6bcSY5nkZh
wQ//bOSAzBvCrxdr/wDYbSmoikHvyrAcVmyU1w5XFdx3b5CYcpBKpd2ZX++sTjjcbuLcZ1YOUvJe
i5sg5/3CXTSTioBXlzuR3ruGOtSKO9tbWy7oxZYNgLiASuCvuvW69T/0pLJPd9mIGPXfhMK/IKAE
7q0j06Szn/ZkE1dHBbL7POireotRcZXDK37C2rRycVX46JKXSDiM0gZ+oss0ro0svlJKOYhsPhwU
VIVHepV2ftMAl16SkvmR6uVS3ThZxi5u/kWBg7IqC+lbMwrW28zDcN5OAZt+IH7q7TiK5ucc/4T3
PMkA7kTCNTLYunimS+SxNijE0lLCU19KEOsxCr917JYLqrbFKSc/kaVtYRbodYqmvsLvsWlpLkpM
82ikWfvjiEkxfkDWhpg5BSDPlS7PqY1UM6ExiHPGj1jsqAr9slkhzDQ4FG83moMADVXzLkYMHYwQ
Rv/vWQkFKFIPeryJE2IjwCEK5+LpAWiyN0deMjy6XKhdZPO3IDzX/sdbtT7CFgZ0DKILURZFPj9V
IIUFit6Sw0ZC8o2xAVxr0rHdOg2fi+v3qaBMdosyzOGNmTNdzFfz2Z7K2att/bJD48A4pBS7dCzW
/ea3yunoHXVV8k4A79Vc1TyDSp50ltOhFBNs11BXQUzOCDC+IY+hRhcUY/7HOd2Zdtx2FWLhvT9H
sBY=
=XSE7
-----END PGP SIGNATURE-----

--iS0UvLSWpfjAYrls8qi3NjFyBybgulZaQ--
