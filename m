Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE30CC76195
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Mar 2023 14:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjC0O5N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Mar 2023 10:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjC0O5E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Mar 2023 10:57:04 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645334694
        for <linux-cifs@vger.kernel.org>; Mon, 27 Mar 2023 07:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=EcLo2jehBtE5woQw+HTDbrk4QUNmLhUP85ZRBeQMuFU=; b=T+5WCwONxXnsiWR12bNyoEJhV2
        x68L59djVhTw384fiZn+V9SbTE34uxf6sSn87Ywj3WQAGf0a7MXDbWAnegy3+w7y1bBcesF1XpZzj
        v5gVMmyUoleZrDIKWK8rRqBILYT8FW6rc79JGZ1YI6CY0Av3lA3/5Tw+36Ef4cDEsTYgLUMQs5IcJ
        pZiIhCmvqO5zpa1EtqIrlIJTAsSuI78tLk87NTJ6FibFdMmM5rLxC+lK7Zdysr/0eoOcf7C/wRnGQ
        +nI1vsILdtJfS6fvpYLG+cGwCVuTLJeQelCzzug1vodIBfQ6TaC4DYsO1BlKP7SaLlhj1303auWil
        2afvId2IMINZrOZdUPBPYhed0rifywvmstMXyYoPdyUfJ4OX9EyrQ9DAU3awVwhgjrBchcO4wCrlo
        1YbTYxOuxbMqqTx9sOIYI22o3C5B5fA0ccwMyRdawOOjOmZy4LB9iU/VhEe1P4NG4TDkue0xMTWyq
        P2agZatScu/0TRA0wwtqeq/c;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pgoHG-005fX1-Ia; Mon, 27 Mar 2023 14:56:54 +0000
Message-ID: <3df3fce7-bf62-b0ec-6125-54f118b0e97d@samba.org>
Date:   Mon, 27 Mar 2023 16:56:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/7] Avoid a few casts from void *
Content-Language: en-US
To:     Volker Lendecke <vl@samba.org>, linux-cifs@vger.kernel.org
References: <cover.1679051552.git.vl@samba.org>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <cover.1679051552.git.vl@samba.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------T0486RHyA3KrDBR1uyHYnNr5"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------T0486RHyA3KrDBR1uyHYnNr5
Content-Type: multipart/mixed; boundary="------------4zj7F0W48nYi6LEVb7DfXyL5";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Volker Lendecke <vl@samba.org>, linux-cifs@vger.kernel.org
Message-ID: <3df3fce7-bf62-b0ec-6125-54f118b0e97d@samba.org>
Subject: Re: [PATCH 0/7] Avoid a few casts from void *
References: <cover.1679051552.git.vl@samba.org>
In-Reply-To: <cover.1679051552.git.vl@samba.org>

--------------4zj7F0W48nYi6LEVb7DfXyL5
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMy8xNy8yMyAxMjoxNSwgVm9sa2VyIExlbmRlY2tlIHdyb3RlOg0KPiBXZSBzaG91bGQg
bm90IGdvIHRocm91Z2ggdm9pZCAqIHdpdGhvdXQgdHlwZS1jaGVja2luZyBpZiBpdCdzIG5v
dA0KPiByZWFsbHkgbmVjZXNzYXJ5Lg0KPiANCj4gVm9sa2VyIExlbmRlY2tlICg3KToNCj4g
ICAgY2lmczogQXZvaWQgYSBjYXN0IGluIGFkZF9sZWFzZV9jb250ZXh0KCkNCj4gICAgY2lm
czogQXZvaWQgYSBjYXN0IGluIGFkZF9kdXJhYmxlX2NvbnRleHQoKQ0KPiAgICBjaWZzOiBB
dm9pZCBhIGNhc3QgaW4gYWRkX3Bvc2l4X2NvbnRleHQoKQ0KPiAgICBjaWZzOiBBdm9pZCBh
IGNhc3QgaW4gYWRkX3NkX2NvbnRleHQoKQ0KPiAgICBjaWZzOiBBdm9pZCBhIGNhc3QgaW4g
YWRkX2R1cmFibGVfdjJfY29udGV4dCgpDQo+ICAgIGNpZnM6IEF2b2lkIGEgY2FzdCBpbiBh
ZGRfZHVyYWJsZV9yZWNvbm5lY3RfdjJfY29udGV4dCgpDQo+ICAgIGNpZnM6IEF2b2lkIGEg
Y2FzdCBpbiBhZGRfcXVlcnlfaWRfY29udGV4dCgpDQo+IA0KPiAgIGZzL2NpZnMvc21iMnBk
dS5jIHwgNTUgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMjUgZGVsZXRpb25z
KC0pDQo+IA0KDQpSZXZpZXdlZC1ieSBSYWxwaCBCb2VobWUgPHNsb3dAc2FtYmEub3JnPg0K
DQpUaGFua3MhDQotc2xvdw0KDQo=

--------------4zj7F0W48nYi6LEVb7DfXyL5--

--------------T0486RHyA3KrDBR1uyHYnNr5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmQhrrYFAwAAAAAACgkQqh6bcSY5nkZO
/A//VdPgGC5cjVrDQk4bQ+ORXgSXiKvWvTJKKGBdxarar/iBxHzj20PzYLIgONwxCoGa5QguuKh4
z1MytwLLzLWa+wd4IvRJZi6/JrAkbt5o8pIFaZ61O37r9TV74ASJdCLVHd5PVwHIQgGfkOKobDsg
Dm0H7CVvXqxiMCizniSsBr2cV7IS+1UrTeJdTIynI+bgLCwbq3F1j++z4A9aRHCs/5Vjw20GO04f
DXAxZQ7J9cTIFHsi+AcJnmGadOVjMV76JMmNza9MONrW8Gedk7ebSt8Kvdm+0tq0P3yx8JIsH9K2
dxwmpftFcT8wOUfPS8pc+tzH07TuLSt4FZUHtmSJMoWJkvJ9rFJnUGj1KTabAvrHzDwI97mylWa/
/VwyIcAV3G8JcXA/OhXGxSc8tZm9Edy3qP8VtI+bFcGn0vHbQ0qz+66JFf7OgZS+o2QdVGNAxZsg
W0b0PAnaWBJdLSPfn5pECgjIaMHTgi6RCNoIrfXqbRbUeOUXK1/8tIbWxlgSpBW2kem/fdBu4edW
WqUyNNHbovjMTOzIfFEFphVReTlUulAW1/v/LmSPu2PCdwheB7FvWGXkxGZCjz39F6LC87zNW0sN
EDPe8Eksi+b+vPJti/vSBFd8i4NoaOEwMC9BfBFIwzIWrziAgv6y95udJu9cuF3V7yVpDx1XNwyJ
qGE=
=G6gf
-----END PGP SIGNATURE-----

--------------T0486RHyA3KrDBR1uyHYnNr5--
