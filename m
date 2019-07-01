Return-Path: <SRS0=A2J+=U6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09531C0650E
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Jul 2019 17:44:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCCEA206A3
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Jul 2019 17:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paulo.ac header.i=@paulo.ac header.b="DRZWdgho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfGARoB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Jul 2019 13:44:01 -0400
Received: from mx.paulo.ac ([212.47.230.6]:53182 "EHLO mx.paulo.ac"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbfGARoB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 1 Jul 2019 13:44:01 -0400
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2019 13:43:59 EDT
From:   Paulo Alcantara <paulo@paulo.ac>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paulo.ac; s=dkim;
        t=1562002455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LNEJnCkdtdvcie7bCJV/gCuExcx0qKL98nUFotNhX30=;
        b=DRZWdghoR5tWtzItznR7KWxRBHHsaHSTcIUSbGUzj/uMgxYIQ2tKwCWPFNReH+kLt5K/OL
        x6BYOfSZI9rdmxMFf6DkdVUNueBGJsZU32X+fWiMihVjINWci73IQAClhk+6L0jnkTIQLv
        ujEHFHYqThDUJBTfSEFQtZo51z92EpkCA0qUt1xq5DEcolZmaYGPMxEuZGRAUvIteXPQXg
        rtyx537O8zYOLs4iwt7rS0uB4Cy0c/XoiI0FsCjzzxXaUEi4LJ/Vv6UFOkeErSELZnjiOz
        WZLHO4P//SSOyvcmBXO+8iOXZKTYoiDyTjdIGe1OuVSdiRW7pKJlVMklH2oxpw==
To:     Steve French <smfrench@gmail.com>, Jean Delvare <jdelvare@suse.de>
Cc:     Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Harald Hoyer <harald@redhat.com>,
        linux-modules@vger.kernel.org,
        Pavel Shilovsky <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: multiple softdeps
In-Reply-To: <CAH2r5ms=ZkpedmsBGLUwzE7tVvEw7wAr_kLm3PpVntX8_U9UCQ@mail.gmail.com>
References: <0bfb6f60-0042-f6be-24ed-7803b6ac759c@redhat.com> <20190628162517.GA24484@ldmartin-desk1> <20190629113018.22c9c95c@endymion> <CAH2r5ms=ZkpedmsBGLUwzE7tVvEw7wAr_kLm3PpVntX8_U9UCQ@mail.gmail.com>
Date:   Mon, 01 Jul 2019 14:33:36 -0300
Message-ID: <87v9wl8xsf.fsf@paulo.ac>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=paulo.ac;
        s=dkim; t=1562002455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LNEJnCkdtdvcie7bCJV/gCuExcx0qKL98nUFotNhX30=;
        b=Vz/y2SmID+SbZj1fgLJ906xihpinlLeMb3YENUvBMXoDZsl+JBqyiyeZb/fhUxRJgT8p+t
        DjTxi6h43MR7ROgzO8DNBE8qKJClgYya3mBSU7iQmvpcmY6wSogA6DNH1snb3iBRHuMcsx
        TBiCvg3KryELAQ8P3wSOtr2em85CPRhNUNWgfY5SKVv83TrwZYLMibOWKNn2Ly6gWVDovC
        hAQN1wKowrKOsJ/CiWpzbAvcgrP1ziUv5gPTOfBSNwUwCZmt24cMNq/YYBfBsbVC49l94r
        JjOezaez0KNSnazkzUFnkJzyt2BtajbNTxfduMincjewqfKUDS+Xwf3w/wB+sQ==
ARC-Seal: i=1; s=dkim; d=paulo.ac; t=1562002455; a=rsa-sha256; cv=none;
        b=DBT9ZKj+F9s3vZzil7tCOOx1V+wyg5a+IqJdGHgpFYFPG9bh5xQLkXOmVqZ2oltH402VCs
        b6RdWg824/2euzUMLELN1vAzQRYzGMOCq99hGhUSjOuTaKrVcZ1KcK/daYmsuKBGaD3CN9
        zRhn1B/9A2izPntW3jGINauPFxc2/xV9HVvmvclFaobfB+gaSr/AMCGko2cu6o/vQje8lu
        agRkPdPQeOxuLuoCLXdwUa/yMy3m5bTBO4G7lSDkhhWV6CHD07CN2AwkRnhkk7k8N3zhLv
        rQ9k9mXGOWD4sz0nxokeLPS4BZyPuqpafLj1DL4tnn2f6NcvYUCEZ+QspWWQdQ==
ARC-Authentication-Results: i=1;
        mx.paulo.ac;
        auth=pass smtp.auth=paulo smtp.mailfrom=paulo@paulo.ac
Authentication-Results: mx.paulo.ac;
        auth=pass smtp.auth=paulo smtp.mailfrom=paulo@paulo.ac
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

>> Or we could decide that cifs in initrd is not supported?
>
> Paulo had been experimenting with booting from cifs.ko (over SMB3.11
> mounts to Samba).
>
> Presumably since SMB3/SMB3.11 family of protocols is the most common
> network file system across a pretty broad variety of operating systems
> it is easier to imagine it being extended for special cases like
> booting the OS (it is already very feature rich compared to most
> network/cluster file system protocols and has exhaustive detailed
> documentation).
>
> My gut reaction is that if cifs.ko (SMB3.11 mounts) don't work with
> initrd ... we need to fix that even if it means minor protocol
> extensions, but Paulo might have more data.

I was able to boot a Leap 15 system from cifs.ko with changes in [1], so
IMHO, it would probably make sense to support cifs in initrd as well --
though I haven't tested it myself.

Thanks,
Paulo

[1] https://git.paulo.ac/linux.git/commit/?h=smb-boot

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEERoXdH1qkUp3jTzChVeljQjyMrg0FAl0aQ/AACgkQVeljQjyM
rg13sg//QJfH9J6LGeWWJJft2D5zUZI0wfy6KAedi58tSNxUBbQHnASdL7R7WGGx
E2ulj7i0TOHylOl7MIDdKPaN7tqfckQvlIVEp6HFcuI9S7+cPC1Z/PxxGJrMZ4uS
YLgiC0s+dO2il99C4uZQuPU2wD6LR4C7kr17HIqJNtAMYnguZtFoovviGeX+k40U
pytGy2haQcsAy546KU43nGx1/Xv1mIaZ1vhSs8EZ2qfx/Fm5fBfj4SeuhC5sjUqt
FuZomJ5jisyrhHb8ovGO8rPUMkHaW8k5LuTF8lAzD3ihg2jo33EXpaGvs+Jfl+qT
DoR0c/J4QL7NzMXft652dWP0V7w9UcIUUjGH5VUAbs0TRNoEowKCCO22rtWkiKxi
J5Pv8ML55s82NNX7RrWCH6vmwZdK7bYNjHbqG6NrS6ADwTf3IdxpYi2Ns6wK8dmT
ER3Myy27KUjQPi864gbV4E8xy8iQzn0aSp+P2eI0MzayFW+T+Iki87ze0+tUbehG
pOMXbh2cTWbx0CBi0Mvf5QpZc+Vxe6+S9IJgR3Eas0gCA2Ndt5K2hbAwul49jAF8
NSNliUKtPDB23x0lRwUlSe7Js/vgCmdGF19SNPIDzrnGCTmSKXON7CkYj71UjZH7
OOETNgBBbDWKsGNtp4JPpge/V/6gmex5eH+Mk20JLD6U55ASzic=
=bw5E
-----END PGP SIGNATURE-----
--=-=-=--
