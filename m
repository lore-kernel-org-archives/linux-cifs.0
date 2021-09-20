Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9142AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FF560F23
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 16:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhITQNQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhITQNQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 12:13:16 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CCCC061574
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 09:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=M/qnrH55jTA+0EyZY6veqaXRD72WZ6TMwseZxuNd5mI=; b=yfqJ6CH3XX5jzJCnxqeECS3ZZn
        jB484pidstyt9TVoa3aDEzvAs12SYPZy7W/PZVRB0hUN7zmLtM17EwLlDFMf5mjWnk6z1ggEh/Xlz
        vg93b4NmJ4Z0MZYUF9aSZ9GOo8lNfzl8SIB5lIoelGFHpMb4Lixhh0qd+t3xxPrFxBxbpIennMu5J
        MA+2UCSSOB0QemIofkg2mPXYCvbBcS0/MRfHO+qleqZDj/MzgSsdFUK7hvbrn2MtKQwbKpF3XAYYt
        Atzr7xdZip20OOwvU9Xcaxbp0ENyoOg4pcVeIzhA+bUUYK+rhdmoZVuOhX4JJYUR2FXJrwjSkV6n6
        g6xdyZqY9/Mr3BTdLHzVnX3NG0nqgNe84wdQVI6sYlogn4AttKOBk/FMDZdgeCMKGfmL64dpik6Df
        cRt5EBKPnM7lNhprWdwBtKuuXRFOByFokWT3EYMqmFx+N5qZj2I2VOiduGHe7pBXdVVCOi24PHdbs
        moOIgQAK5V7GNenCdWRTAJky;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSLtS-0070sj-Nt; Mon, 20 Sep 2021 16:11:46 +0000
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
 <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
 <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <97166b9e-b0e2-2cc2-5d53-c0f8687faf80@samba.org>
Date:   Mon, 20 Sep 2021 18:11:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uTAu7UgNRCJ9s9phvyMISsxWVZBnON1Xp"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uTAu7UgNRCJ9s9phvyMISsxWVZBnON1Xp
Content-Type: multipart/mixed; boundary="bSqI5fFJ3UvSFjlRWD8xOBgSPlZc30jrr";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>
Message-ID: <97166b9e-b0e2-2cc2-5d53-c0f8687faf80@samba.org>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <85871805-c9fb-6df9-be6d-ff57074426a3@samba.org>
 <27cdc659-cf4d-cc9e-e5c5-6a3d23987e72@samba.org>
 <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>
In-Reply-To: <CAH2r5mt8gxSS56kDvmtRTOi7Dm0fXwD6zL45WAP2hw2_TxDPow@mail.gmail.com>

--bSqI5fFJ3UvSFjlRWD8xOBgSPlZc30jrr
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 20.09.21 um 17:10 schrieb Steve French:
> On Mon, Sep 20, 2021 at 10:03 AM Ralph Boehme <slow@samba.org> wrote:
>>
>> Am 20.09.21 um 16:45 schrieb Ralph Boehme:
>>> Am 19.09.21 um 04:13 schrieb Namjae Jeon:
>>>> Use  LOOKUP_NO_SYMLINKS flags for default lookup to prohibit the
>>>> middle of symlink component lookup.
>>>
>>> maybe this patch should be squashed with the "ksmbd: remove follow
>>> symlinks support" patch?
>>
>> also, I noticed that the patches are already included in ksmbd-for-nex=
t.
>> Did I miss Steve's ack on the ML?
>>
>> I wonder why the patches are already included in ksmbd-for-next withou=
t
>> a proper review, I just started to look at the patches and wanted to
>> raise several issues.
>=20
> I included them at Namjae's request in for-next to allow the automated
> tests to run on them (e.g. the Intel test robot etc.) - those
> automated bots can be useful ... but I had done some review of all of
> them, and detailed review of most, and had run the automated tests
> (buildbot) on them (which passed, even after adding more subtests),
> and the smbtorture tests were also automatically run (it is triggered
> in Namjae's github setup).
>=20
> Of the 8 patches in for-next, these 3 are the remaining ones that I am
> looking at in more detail now:
>=20
> 24f0f4fc5f76 ksmbd: use LOOKUP_NO_SYMLINKS flags for default lookup
> 1ec1e6928354 ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
> e2cd5c814442 ksmbd: add validation in smb2_ioctl

ok, thanks for explaining.

To be honest, I'm still trying to make sense of the patch workflow.=20
Hopefully I get there eventually.

How can I detect if a patch is already reviewed and queued for upstrea=20
merge, so it's "too late" for me to do a review?

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--bSqI5fFJ3UvSFjlRWD8xOBgSPlZc30jrr--

--uTAu7UgNRCJ9s9phvyMISsxWVZBnON1Xp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFIssEFAwAAAAAACgkQqh6bcSY5nkaU
0A//fv+ylnm4+5FHzrEypydLJs+nUBjAOB8ZIt57hmE9uXzymed0aTwjJJJXc1b3/+jfzUvyHKDk
u0SOT7boYwWhLuGL8X4DjzybhN7/xaDkwjTcqAboagCuwa4ce3jsWbjmbvlRTwGKP44ArvvPZeNR
u6GjytPFUdldonl9hoJwQWkozH+8Co/yi/J9b2WP3V5OlpCaTY4Uhdf0MhOBpkrHKjRt8H77lp2Y
HEFpiouPBIuqKGe4OOoaHOzvLEihe0e3dqxkH9t6gNEO6iSMOUBYWX+VYJURYOV3UBjhNOye9eAU
ilFVJkXBP/ZdS3uORWTIpcyxEPL7BQfpndTN4uR3kzjLLMhy2SaqArAngFCehqgCat2lPxHQA/Tu
5dJV+PqlXDcJ8tazKbgYEXH2u+xnefUXO3eaxIqtFzfpWp8OOye1+sIr/y0NgTv7Nq/cc5HDTnJG
bz3YLgjit71dkS29ZAQoQo3HGnK3p7JO59ro9lwmcuxywyO+gp+dR8uXrmJYVNXLOEJ0tOrmnt5W
tmgrBZ2Zeto+rvLc7n9zGuAnj8F5sR31MhwwXyrKLhV4WXwgQ8xTq/dfr8QktwnddvxyjCH2B1km
ihm0JnN7J9G9rDxy6D5etLG+pDBfNkB90qCMSIGYpK2+rzP0sesRW0CEpa+tpZy3rfh+7kHOiusz
DfM=
=cAZN
-----END PGP SIGNATURE-----

--uTAu7UgNRCJ9s9phvyMISsxWVZBnON1Xp--
