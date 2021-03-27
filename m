Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2809EC433C1
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Mar 2021 11:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEA361941
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Mar 2021 11:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhC0Lim (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Mar 2021 07:38:42 -0400
Received: from smtp-out-02.rz.uni-jena.de ([141.35.105.44]:46310 "EHLO
        smtp-out-02.rz.uni-jena.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhC0Lim (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 27 Mar 2021 07:38:42 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Mar 2021 07:38:41 EDT
Received: from smtp-intra-03.rz.uni-jena.de (smtp-intra-03.rz.uni-jena.de [10.138.192.41])
        by smtp-out-02.rz.uni-jena.de (Postfix) with ESMTPS id 4F6xXX4JhDzGpqv
        for <linux-cifs@vger.kernel.org>; Sat, 27 Mar 2021 12:32:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-jena.de;
        s=opendkim-2020; t=1616844764;
        bh=R1ZSiPj5SG1C5t//XS2r8bwybzPG9SDQ3TPHaOjLOPw=;
        h=Date:From:To:Subject:From;
        b=sGu4/TpKd0gE/vLHHcNvDCKAK9GrlBCDfDVlugSRVKf3GoVcuVFNobf2Z9QRQcl/x
         SIf3Pzl81t5EFy2WvkXyZQVNZOztW8L1CnMIT68B5BbD8FPktTTdWKPjA/xtDWJcfR
         REZz/JpLeRt99cUaNnOFLFTgJgVyknbCkE9fc779nrwyFoIiEujBwjrUNyEv1rWsOZ
         Gc1hmsFXDOP5O1T3O7pH/CT/qKQfUucQ5AFd0L7FUGcxVzb15GzAfTJx1EESKjPJJn
         lx0QnF8gCvMO2AMVWDv+9OM6GjSmTG5/G7zOvVTJTV08KTsWmqyvaGDoY34vYr06Ta
         Ap0XUM5m1GsZg==
Received: from localhost (heteroptera.inf-bb.uni-jena.de [10.149.60.23])
        by smtp-intra-03.rz.uni-jena.de (Postfix) with ESMTPSA id 4F6xXX2DLnzyrS
        for <linux-cifs@vger.kernel.org>; Sat, 27 Mar 2021 12:32:44 +0100 (CET)
Date:   Sat, 27 Mar 2021 12:32:53 +0100
From:   Frank Loeffler <frank.loeffler@uni-jena.de>
To:     linux-cifs@vger.kernel.org
Subject: specifying password when using krb5
Message-ID: <20210327113252.GC8814@topf.wg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after hours of debugging, I finally write to this list to see if I=20
understood things. Let me first explain what I tried to do and I'll post=20
my question towards the end.


What I want to do is mount a Windows-share via 'mount.cifs'. I can see=20
stuff on that directory using smbclient, so login credentials ect. are=20
ok:

# smbclient -A /etc/my-credentials -L \\\\share.name.org

        Sharename       Type      Comment
        ---------       ----      -------
   ... some content ...

# smbclient -A /etc/my-credentials //share.name.org/home
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Fri Jan 31 12:36:03 2014
  ..                                  D        0  Fri Jan 29 07:38:10=20
2021
=2E..
smb: \>

So far, so good. Now I want to mount:

# mount -t cifs '\\share.name.org\home' -o credentials=3D/etc/my-credential=
s /mnt/win
domain=3DMYDOMAIN
mount.cifs kernel mount options:=20
ip=3D10.10.10.10,unc=3D\\share.name.org\home,user=3Dme@myorg.org,domain=3DM=
YDOMAIN,pass=3D********
mount error(13): Permission denied

Looking at wireshark-captures of the smbclient-connect I see it using=20
krb5, so let's do that too with cifs:

# mount -t cifs '\\share.name.org\home' -o credentials=3D/etc/my-credential=
s,sec=3Dkrb5 /mnt/win
domain=3DMYDOMAIN
mount.cifs kernel mount options:=20
ip=3D10.10.10.10,unc=3D\\share.name.org\home,sec=3Dkrb5,user=3Dme@myorg.org=
,domain=3DMYDOMAIN,pass=3D********
mount error(2): No such file or directory

Note, I do not have active krb5-tickets on this machine, I do not even have=
 kinit installed.

Even more strange, trying without actually specifying a password:

# mount -v -t cifs '\\share.name.org\home' -o username=3Dme@myorg.org,domai=
n=3DMYDOMAIN,sec=3Dkrb5 /mnt/win
mount.cifs kernel mount options: ip=3D10.10.10.10,unc=3D\\share.name.org\ho=
me,sec=3Dkrb5,user=3Dme@myorg.org,domain=3DMYDOMAIN,pass=3D********
mount error(2): No such file or directory

Shows the same: it does not even ask me for the password (but still=20
shows 'pass=3D********' in the kernel mount options). This is strange,=20
because the docs say:

       password=3Darg|pass=3Darg
              specifies the CIFS password. If this option is not given=20
then the environment variable PASSWD is used. If the password is not=20
specified  directly  or  indirectly via an argument to mount, mount.cifs=20
will prompt for a password, unless the guest option is specified.

Trying without password and without sec=3Dkrb5 does indeed give me the=20
expected prompt.

Digging deeper, into the source of mount.cifs, I find=20
(cifs.upcall.c:582)

/*
 * Prepares AP-REQ data for mechToken and gets session key
 * Uses credentials from cache. It will not ask for password
 * you should receive credentials for yuor name manually using
 * kinit or whatever you wish.
*/

According to that source-code comment, sec=3Dkrb5 will ignore any password=
=20
setting - it will not even ask for one. mount.cifs.c:918 shows similar=20
intentions:

        if (!strncmp(value, "krb5", 4)) {
          parsed_info->is_krb5 =3D 1;
          parsed_info->got_password =3D 1;
        }

So, now my questions:

1. Is it intended that mount.cifs will not ask for a password when using=20
sec=3Dkrb5 and will ignore any set password?
2. I don't want to setup krb5-tokens for users. All I want is=20
authenticate using krb5 to get the smb-session and then forget about=20
krb5. smbclient seems to be able to do this. I don't know how they do=20
it, I suspect they create a temporary token, open the session, and then=20
drop it again. Whatever smbclient does: couldn't mount.cifs do the same=20
or something similar? This would make the 'password' setting meaningful=20
for sec=3Dkrb5. This does not mean that existing tokens couldn't and=20
shouldn't be used. It would just mean that users would not *have* to use=20
an external mechanism for this.
3. For the moment (and only if my observations are correct): could the=20
documentation be updated to reflect that "password" is ignored for=20
"sec=3Dkrb5"? Users shouldn't need to dig inside the source code to find=20
out things like that.
4. Currently, trying sec=3Dkrb5 without token cache files results in the=20
rather obscure error "mount error(2): No such file or directory". Could=20
this me changed into something that points users to the actual cause of=20
the error?
5. Am I even remotely correct with any of this? :)

thanks, Frank


--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEDs94vEHD2WZGdOX+6TOmKn4jn2QFAmBfF+IACgkQ6TOmKn4j
n2RUfRAAqDbvoZhh+oJrOsy01zPFjvh6Lw/DIQDUpu4cBBv0S74wa6/JlJ7SQKRm
GZusqSb4QV3tT2nrINSDxyteEuoit61MSPXeRqXf3vROQS0YwopnYO0DoLT6rL31
DOV16HElFkmtp6RmTDJc7cF1+taElzlk3uYon1JR6Q+ShaeWMWK5/lCadL5SIp95
noEfrXFE8xNtPpzxqd90soAE5iRR++ZoSOqLmAq32OO6w94n/6abqhabxpEmvR2x
ZQ2QvuOFgWL9oYmjIsVtJ7kgGKlhK7AEzXFBEzI6D6ksvs4zThQPwa7DcBFtIBcL
sJ77mFNK5TbFQX9u9Zr7w4I9RorYQjUPq0Q/mfUXB4+H6c4k1u5cxBJieed9D9oT
s+DFa0wlUpFLGly6Pzj2wE06AmtnYRUE8lFgZFySQuIUGRZJqhg3SnscszttHwkp
EOIYZ6DCkzjAzuvTjna6GzhX4oT+t/eY0sDYvWQVRW5JZNtAIM4UEbh+wPjO6sBx
vzvDQwdN69A9SAAL0xNmUBHdsDePba6sEyP/iP98wkBOgAjeb/V78lDcNlyn8wxK
XA4sSTQZTfaMoBz/aebzYJ9/6lJovN/f5MBe596OAq7dXt5k/mrIx4iGMaoYMRje
lAotTCqiCWkUyqyC738i9mi+zH5ZT1c1GpMcGAN8lkZoWJF3Zi0=
=aE1V
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
