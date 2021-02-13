Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D466C433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 00:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCAE64E9A
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 00:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhBMA1O (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 19:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhBMA1O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 19:27:14 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4AC061574
        for <linux-cifs@vger.kernel.org>; Fri, 12 Feb 2021 16:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=JGQd2Cous/HruplA1vEiD9rmCfWsV8SoYGgBeyWEeos=; b=Zsu2Nl1AFYgE21lvba39bhKT0j
        rziHx2/+3jANq3LfJs8qfv0UaVk7suqOC7xSx8ljew5KLOQ2VMU9TORt0rPTtk19i76QIhrSz6Oi6
        Z2Huvr9w6ttWhP6Oc1knWkQ3+EVE8MKqr3PaVrtZpHVkoZMEYMn67Zecr2kD79MAKBgwkPvpoTRHi
        fBOMs13LrT8w2JAva7RMlODVMZBL52tFdGE4a3oPTw4OGaQQCoWS3eAits29oQAqgPUnZ1cDTSsIB
        rOx1+QNH15TMRF6d1ePisB6chG/iQYbrQM+MhNu1OODcDg7amL5rDNTMhEDu5GSJhAN7RFr54dUNz
        HAz5lgtC9yCnRo+5HM/b8PTUhzpQ39b3kYDg/e82MmzlpANliit59KW0kiAAabI1B6NyNe6LLh1DC
        iP3LNhDQKsJbm14mQTkfeUAF5qoiFrP6smHmsR3q1MVoyey9Yd6Hbdd5c1AWr6IuMQEeggJJqnzp+
        xRodnKENfd7RD7njVasFgCEJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lAilZ-0005O0-QK; Sat, 13 Feb 2021 00:26:29 +0000
Subject: Re: [GIT PULL] cifs fixes
To:     Steve French <smfrench@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Bj=c3=b6rn_JACKE?= <bjacke@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
 <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
 <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Autocrypt: addr=metze@samba.org; prefer-encrypt=mutual; keydata=
 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
 uAMlsTqBMFOwuvAcYAj2bwl7QQU6yhU=
Message-ID: <592ad76a-866e-f932-5a82-1af4a2ba4880@samba.org>
Date:   Sat, 13 Feb 2021 01:26:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="OqxO8FuE7l0hV399CnX1DuQiix1IawcgL"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OqxO8FuE7l0hV399CnX1DuQiix1IawcgL
Content-Type: multipart/mixed; boundary="1sQhfqo0jP88m6tOXmci5TvNQFwOzjDdj";
 protected-headers="v1"
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 =?UTF-8?Q?Bj=c3=b6rn_JACKE?= <bjacke@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <592ad76a-866e-f932-5a82-1af4a2ba4880@samba.org>
Subject: Re: [GIT PULL] cifs fixes
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
 <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
 <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com>
In-Reply-To: <CAH2r5mtj+-xGDy-YN0JwSJAsgvB+HpQFCBi-zdTNXTRBY_Mteg@mail.gmail.com>

--1sQhfqo0jP88m6tOXmci5TvNQFwOzjDdj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 12.02.21 um 21:39 schrieb Steve French:
> Metze/Bjorn,
> Linus is right - samba.org is down for me (I also verified with JRA).
> Any ETA on when it gets back up?
>=20
> On Fri, Feb 12, 2021 at 2:05 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Fri, Feb 12, 2021 at 10:16 AM Steve French <smfrench@gmail.com> wro=
te:
>>>
>>>   git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3
>>
>> It looks like git.samba.org is feeling very sick and is not answering.=

>> Not git, not ping (but maybe icmp ping is blocked).
>>
>> Please give it a kick, or provide some other hosting mirror?


It's online again.

The machine is running a 'AMD Ryzen Threadripper 2950X 16-Core Processor'=

and is freezing without any trace every view days.

We played with various boot parameters (currently we're using
'mem_encrypt=3Doff rcu_nocbs=3D0-31 processor.max_cstate=3D1 idle=3Dnomwa=
it nomodeset consoleblank=3D0',
with the ubuntu 20.04 5.8 kernel, we also tried 5.4 before), but nothing =
seems to help.

metze



--1sQhfqo0jP88m6tOXmci5TvNQFwOzjDdj--

--OqxO8FuE7l0hV399CnX1DuQiix1IawcgL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEfFbGo3YXpfgryIw9DbX1YShpvVYFAmAnHLAACgkQDbX1YShp
vVaoARAAoVDfDAxb6sG2Ad2Kt1KQJHUXCwdNa83txDdhtCDouDoHplcG1GYonhrl
IaqO8bdQOrbkEldJ3ABodDuOIxL2R24ID4D6NaU7x1pWCBbHuAjBe0EqHqplR7/0
N/Abq9ZykDkiGxhXGZWbxwRI+zdm8CgFRYDhc8kQW+QHRgBJOObBF/pXfj4NfH5h
fDz/l3zUr4aTnoAxWdLMqMFelZgKPP7KW7HOODWAUj0IjVXmjQwyHjzhAztgjAJt
6uN9mk5zT/LoesuLvlDiVL0SpXGV03eaDf1cueHC/klhX7W4/rzMEnvbB/yc5YDY
vZih4lGDd50z+jy3mLUTwvi8V+o0m+4eJZq3SovjZU61FhDI+MsOWhKujTG5So0t
GRncJ5kVNFXRJ+KedXbNvixO4EIyCBDbi4zem64tzPf+DnzUGBVQ+pQlQG+aiK/6
IKXi0xFTXxe2LyjpPz8eh8p5ePalTM5B3aeTNgmlNu8hG8+vGGWO/xsL0CTG/UVY
/DZ/vQApONs1ZIM5Pk+sUltZqWZpSoRyQ3uqaYVvivFDJU56Q32pvFNQY0yonqCa
jB5+xSfsRvmpxsqTYE/n/jEbs3QdlU37VwfsQodF/Y+dEMUEM1J8G1pTgACPAMbp
DtRv+UzEgfHjA+jJpV35YoDnQ9qcTv/cd0AzxsXwrEYCO7wIfaw=
=D3y3
-----END PGP SIGNATURE-----

--OqxO8FuE7l0hV399CnX1DuQiix1IawcgL--
