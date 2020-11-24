Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7703CC2D0E4
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 13:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E40F20708
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 13:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388439AbgKXNh5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Nov 2020 08:37:57 -0500
Received: from mail.archlinux.org ([95.216.189.61]:33366 "EHLO
        mail.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388437AbgKXNh4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Nov 2020 08:37:56 -0500
Received: from mail.archlinux.org (localhost [127.0.0.1])
        by mail.archlinux.org (Postfix) with ESMTP id EB7B02578EC;
        Tue, 24 Nov 2020 13:37:51 +0000 (UTC)
Date:   Tue, 24 Nov 2020 14:37:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=archlinux.org;
        s=mail; t=1606225071;
        bh=XtgjzqZMN6eDN0vI5EuIcSFlMqucgQkyOiUwxF+pKZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=ggoK5h7w6umHfMhYlA2qhQ8EdcOBkl7U5Ndk9P41+iNvE0VyQZN29Z9K6FW0IdW/p
         YtfSNa3xanYo4al2rm7J6m2/DpPO8HinPwSB4jV1roVChm14mI+fcXw6sUgn59O9Qf
         5vOwF42Pr+Hwiqt0A72StGdrSbtrelZMGS+cyil72q2+UtMFdq/vVSeoC8Sa47VxoG
         qzB/1OOxo4F8eTerHP0EkBXiOEGdBqBQudMzPlv9djfvhiTx7NKPmyoJvG9dbfWR+M
         klRaqK8t063w4qytl6SIj522UsP7pJQ8mdVk9+G4RsXHz3YJSYg7tH9ikJWmjRh8I4
         KXrib/nig2x5nfidkVWWhKXOv9XZH3iwb0pKoX5jqQRCum399Emagk51dp3Pds0nyz
         cZH4odqMKe/TDC0GYrLW1X2Q1ksS1VYPkhvJc6JggGJ4YxL8d+bVmN/AQj35XFUw2W
         HVlhtHK7KoWsGYRmAPKEDMRVH2U2ordhLdznldJTlnQeQSC1+/0XJWx0sJe/lo7KJz
         mvKFYnmcV8d4cmwWtG3FXLqOqZd/LZFiLxkNjLdRcExhtc36nrQcvgExE2acTAxL3F
         yFEKnmYtgnjnVSoDZmOdUADPAgPt8+f2FyawGNhgypNDfmWinOoo6sxQ2cF4EqcxKR
         xO8wVk5RKxN1uEGRfPuFtX88=
From:   Jonas Witschel <diabonas@archlinux.org>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH 0/2] cifs-utils: update the cap bounding set only when
 CAP_SETPCAP is given
Message-ID: <20201124133740.cixyh57b3rlto54n@archlinux.org>
References: <20201121111145.24975-1-diabonas@archlinux.org>
 <87tutflztq.fsf@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k4bsvc3kda3vmism"
Content-Disposition: inline
In-Reply-To: <87tutflztq.fsf@suse.com>
Autocrypt: addr=diabonas@archlinux.org; prefer-encrypt=mutual; keydata=
        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
        glSD2arJIJyQaOjHnsjM6HgR7jQ==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--k4bsvc3kda3vmism
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/2] cifs-utils: update the cap bounding set only when
 CAP_SETPCAP is given
MIME-Version: 1.0

Hi Aur=C3=A9lien,

On 2020-11-24 13:11, Aur=C3=A9lien Aptel wrote:
> This sounds good but I'm not very familiar with libcap, any ideas how we
> can test those code paths?

a simple integration test would be trying to run mount.cifs as a setuid bin=
ary
with normal user rights. With libcap-ng 0.8.1 and an unpatched version of
cifs-utils 6.11, this will result in the error message "Unable to apply new
capability set."

$ git clone --branch=3Dcifs-utils-6.11 https://git.samba.org/cifs-utils.git
$ cd cifs-utils
$ autoreconf -i
$ ./configure
$ make
$ sudo chown root:root ./mount.cifs
$ sudo chmod u+s ./mount.cifs
$ ./mount.cifs test /mnt
Unable to apply new capability set.

After applying the patch series, mount.cifs will work normally:

$ ./mount.cifs test /mnt
mount.cifs: permission denied: no match for /mnt found in /etc/fstab

For cifs.upcall, I guess this is usually run with elevated privileges, so it
will normally have CAP_SETPCAP, but for testing purposes, we can grant the
necessary capabilities manually and run as a normal user:

$ sudo setcap cap_setuid,cap_setgid,cap_sys_ptrace,cap_dac_read_search=3Dep=
 ./cifs.upcall
$ ./cifs.upcall

Without the patch, this will fail with an empty stderr and an error of
"trim_capabilities: Unable to apply capability set: Success" in the syslog.
With the patch, applying the capabilities succeeds and the usage information

Usage: cifs.upcall [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-E] [-t] =
[-v] [-l] [-e nsecs] key_serial

is displayed on stderr.

Best,
Jonas

--k4bsvc3kda3vmism
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE0ZGnjxiB84R1PJZ+aGsGOsS8DskFAl+9DJ4ACgkQaGsGOsS8
Dsmf2xAAls+6NJ+ayQiHlCgFdTFemAUA+VE+NHNpOsnfXeyAPlkbbwINRidg32iF
efG7Cl6CxcseV9ZOGVUB2bNBxd2hAvEF5XxLNbjZUx8FsD4exVahZKy3tMj9kYmV
65piiFyUybwzpDWqv3rdB13EGIAV3FkC56wjE96aw4JhDEnXTU6enGTTnbxkMcFo
d9+gY4z/3yDdCTQ5Wr6/w4RYryD3yoCXnHEdkYzWBOqZLBmyOysRj0SVzcZi58DU
LMXPtByg+XsseNV3TaiiyGVZ4Rvac0d4Zcz4MG94mWeOuaQ/ur3norJUy0nGiGHn
g0f9WvKoXNqAQnoNQVXLxzyp6M4hFuZuZHPD3+90eR3g0hVY/Znpn6KxVhpy43fK
ZDHPqJ46Wyw9fZZiqEzdeMPtY+QT7Z35vtAq75AR3KSOhmzsduhxYx7rwg2us3p9
DHvh93lKf20WQ2UoXRWYst642gyI4hQx4de+nLY4i0GuTZqiyH8Ws5VMN1+tPTig
3bqUNVOXgsgrV0dngMGNgxDpFAYK0UbXuxkPKiGsbwOS3f96B0rtGEk5SwzWEErX
jZ/HALK+9qLTTSuDNBmVWWjoxvdLytZsfEejxV2UpduYp6yt2J9DNlMG/Ac1d1TC
QtuyHn2uul7E+px6Dv9ofbBAQaaRC/My7/r+w9g18GRWCV7r5Jk=
=ihq8
-----END PGP SIGNATURE-----

--k4bsvc3kda3vmism--
