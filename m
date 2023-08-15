Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D8DC001B0
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Aug 2023 14:26:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjHOOZ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Aug 2023 10:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237614AbjHOOZj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Aug 2023 10:25:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314F619A7
        for <linux-cifs@vger.kernel.org>; Tue, 15 Aug 2023 07:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5106637B8
        for <linux-cifs@vger.kernel.org>; Tue, 15 Aug 2023 14:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C82C433C7;
        Tue, 15 Aug 2023 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692109536;
        bh=RmuuELVrePDY5vmsyZg0YbaBCFNRJNObTeiiNhd6fXc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JLJG861hgJ4RvxoV6n0s4RLG+ZeJ/sJK1A3MeyyaUXUfiMJdTKck5/lK2oeSA/726
         7O2nlIdDonu5ZLkRAUJxFqblF373qFUH9TK59VV9wi4yoKHroRQo5902R+GIBb46qD
         1NnKc30KiZk7wmP/FELaWCRnKrvMeIlleUn7cma/0MQdwt+87NF2jyfBF0yHT7CCSO
         fM3wFhaoD5i2dcSk2ehPOeZ9L/d1jniQ1o7pQYsJY9H4g/Ngfq6pZvvq+75LZQIKO2
         60f1AQF3dyKb2Og5AgSqJmSncJpbpnFJ69fLBPYaa886xm+10I1T9Fgos4o0SgogRy
         9vQxcwz7N1sIg==
Message-ID: <0d52da2fbc5cc6704d23aca657d85ae32b18cfaa.camel@kernel.org>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
From:   Jeff Layton <jlayton@kernel.org>
To:     Paulo Alcantara <pc@manguebit.com>,
        Steve French <smfrench@gmail.com>
Cc:     =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jay Shin <jaeshin@redhat.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Date:   Tue, 15 Aug 2023 10:25:34 -0400
In-Reply-To: <a3a8f7a3e90541f20ef93e7f02f0a877661d8999.camel@kernel.org>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
         <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
         <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
         <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
         <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
         <7f1c7940764425cbcf6f6585d138ef38e6618581.camel@kernel.org>
         <cca8280bb933aa149de1bb9115d2fb3a.pc@manguebit.com>
         <a3a8f7a3e90541f20ef93e7f02f0a877661d8999.camel@kernel.org>
Content-Type: multipart/mixed; boundary="=-N9aSZlEPmmNurxkQQ40V"
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-N9aSZlEPmmNurxkQQ40V
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-08-11 at 12:58 -0400, Jeff Layton wrote:
> On Fri, 2023-08-11 at 13:49 -0300, Paulo Alcantara wrote:
> > Jeff Layton <jlayton@kernel.org> writes:
> >=20
> > > Thanks for the confirmation. There were some oopses on some RHEL8 (5.=
14
> > > based kernels). The stack looked something like this:
> > >=20
> > > PID: 2415716  TASK: ffff937139090000  CPU: 3    COMMAND: "ls"
> > >  #0 [ffff9ef946b23728] machine_kexec at ffffffffac867cfe
> > >  #1 [ffff9ef946b23780] __crash_kexec at ffffffffac9ad94d
> > >  #2 [ffff9ef946b23848] crash_kexec at ffffffffac9ae881
> > >  #3 [ffff9ef946b23860] oops_end at ffffffffac8274f1
> > >  #4 [ffff9ef946b23880] no_context at ffffffffac879a03
> > >  #5 [ffff9ef946b238d8] __bad_area_nosemaphore at ffffffffac879d64
> > >  #6 [ffff9ef946b23920] do_page_fault at ffffffffac87a617
> > >  #7 [ffff9ef946b23950] page_fault at ffffffffad20111e
> > >     [exception RIP: cifs_mount+1126]
> > >     RIP: ffffffffc08e8826  RSP: ffff9ef946b23a00  RFLAGS: 00010246
> > >     RAX: 0000000000000000  RBX: ffff936c8221ea00  RCX: ffff936f8018b3=
20
> > >     RDX: 0000000000000001  RSI: ffff936f8018b420  RDI: ffff936c8221ea=
00
> > >     RBP: ffff9ef946b23a90   R8: 5346445756535c5c   R9: 6765642e503130=
31
> > >     R10: 65622e666f6f7267  R11: 0063696c6275505c  R12: ffff9370b192fc=
00
> > >     R13: ffff936f8018b420  R14: 00000000003097ad  R15: 00000000000000=
00
> > >     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> > >  #8 [ffff9ef946b23a98] cifs_smb3_do_mount at ffffffffc08d11f2 [cifs]
> > >  #9 [ffff9ef946b23aa0] cifs_smb3_do_mount at ffffffffc08d11f2 [cifs]
> > > #10 [ffff9ef946b23b08] smb3_get_tree at ffffffffc0930ae0 [cifs]
> > > #11 [ffff9ef946b23b30] vfs_get_tree at ffffffffacb52365
> > > #12 [ffff9ef946b23b50] fc_mount at ffffffffacb7485e
> > > #13 [ffff9ef946b23b60] vfs_kern_mount at ffffffffacb748ec
> > > #14 [ffff9ef946b23b80] cifs_dfs_do_automount at ffffffffc093552e [cif=
s]
> > > #15 [ffff9ef946b23bc0] cifs_dfs_d_automount at ffffffffc0935880 [cifs=
]
> > > #16 [ffff9ef946b23bd0] follow_managed at ffffffffacb5bdaf
> > > #17 [ffff9ef946b23c10] lookup_fast at ffffffffacb5c7e5
> > > #18 [ffff9ef946b23c68] walk_component at ffffffffacb5d258
> > > #19 [ffff9ef946b23cc8] path_lookupat at ffffffffacb5e215
> > > #20 [ffff9ef946b23d28] filename_lookup at ffffffffacb62710
> > > #21 [ffff9ef946b23e40] vfs_statx at ffffffffacb55874
> > > #22 [ffff9ef946b23e98] __do_sys_statx at ffffffffacb5692b
> > > #23 [ffff9ef946b23f38] do_syscall_64 at ffffffffac8043ab
> > > #24 [ffff9ef946b23f50] entry_SYSCALL_64_after_hwframe at
> > > ffffffffad2000a9
> > >     RIP: 00007ff6a2637edf  RSP: 00007ffe040017d0  RFLAGS: 00000246
> > >     RAX: ffffffffffffffda  RBX: 00007ffe04001910  RCX: 00007ff6a2637e=
df
> > >     RDX: 0000000000000100  RSI: 00007ffe04001910  RDI: 00000000ffffff=
9c
> > >     RBP: 0000000000000100   R8: 00007ffe040017f0   R9: 00000000ffffff=
9c
> > >     R10: 0000000000000002  R11: 0000000000000246  R12: 00007ffe040017=
f0
> > >     R13: 0000000000000000  R14: 0000000000000003  R15: 000055ce1a3ae1=
b8
> > >     ORIG_RAX: 000000000000014c  CS: 0033  SS: 002b
> > >=20
> > > Analysis of the vmcore by Roberto showed that we had ended up past th=
at
> > > point with tcon=3D=3DNULL and rc=3D=3D0.
> >=20
> > Interesting.  Thanks for sharing the backtrace!
> >=20
> > So it actually ended up with NULL @tcon and rc =3D=3D 0 while mounting =
a DFS
> > link.  Nice catch!
> >=20
> > > Steve's patch would have fixed the panic there, but I think the host
> > > would have ended up with a successful mount, but with a broken
> > > superblock. The current code seems a bit less fragile, and I didn't s=
ee
> > > any similar brokenness there, but I didn't look too hard either.
> >=20
> > Yeah, makes sense.
> >=20
> > > In any case, we'll plan to fix this up with a one-off in RHEL/Centos.
> > > Thanks again for the sanity check!
> >=20
> > Would you mind to propose a patch that fixes the above and mark it for
> > v5.14..v5.15?
>=20
> Sounds good. One of us will make sure that happens too.
>=20

FWIW, I took a look at v5.15.125 and I don't see the same bug there. It
probably got fixed inadvertently with some other backporting. Looks like
this is only a problem for older, non-stable-series kernels.

The patch I created for RHEL8 is attached though, if you're interested.
--=20
Jeff Layton <jlayton@kernel.org>

--=-N9aSZlEPmmNurxkQQ40V
Content-Disposition: attachment;
	filename="0001-cifs-fix-bogus-cifs_mount-error-handling-in-RHEL8.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch;
	name="0001-cifs-fix-bogus-cifs_mount-error-handling-in-RHEL8.patch";
	charset="ISO-8859-15"

RnJvbSA5ZDk3ZTJjMzdlOThlODkzZTM4YjNlNjQ5MjNjYTY4ZGM5YzIxZTYxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKZWZmcmV5IExheXRvbiA8amxheXRvbkByZWRoYXQuY29tPgpE
YXRlOiBUdWUsIDE1IEF1ZyAyMDIzIDA5OjQyOjIxIC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gY2lm
czogZml4IGJvZ3VzIGNpZnNfbW91bnQgZXJyb3IgaGFuZGxpbmcgaW4gUkhFTDgKClRoZSBwYXRj
aCB0aGF0IG9yaWdpbmFsbHkgd2VudCBpbiBmb3IgdGhpcyBidWcgd2FzIGJvZ3VzIGFuZCBjb3Vs
ZCBjYXVzZQpjaWZzX21vdW50IHRvIHJldHVybiAwLCBldmVuIHRob3VnaCBpdCBoYWRuJ3QgcHJv
cGVybHkgZmlsbGVkIG91dCB0aGUKc3VwZXJibG9jay4KCkVuc3VyZSB0aGF0IHdlIGFsc28gcmV0
dXJuIGFuIGVycm9yIGluIHRoaXMgY2FzZS4gUGF1bG8gQWxjYW50YXJhCnN1Z2dlc3RlZCAtRU5P
RU5UIGluIHRoZSB1cHN0cmVhbSBkaXNjdXNzaW9uLgoKU2lnbmVkLW9mZi1ieTogSmVmZnJleSBM
YXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyB8IDQgKysr
LQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5jIGIvZnMvY2lmcy9jb25uZWN0LmMKaW5kZXggZjg4MmIz
OGQ0ZWQzLi4wYWYwYzA3MTgxNTMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY29ubmVjdC5jCisrKyBi
L2ZzL2NpZnMvY29ubmVjdC5jCkBAIC0zNTA3LDggKzM1MDcsMTAgQEAgaW50IGNpZnNfbW91bnQo
c3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwgc3RydWN0IHNtYjNfZnNfY29udGV4dCAqY3R4
KQogCQkJcmMgPSAtRUxPT1A7CiAJfSB3aGlsZSAocmMgPT0gLUVSRU1PVEUpOwogCi0JaWYgKHJj
IHx8ICF0Y29uKQorCWlmIChyYyB8fCAhdGNvbikgeworCQlyYyA9IHJjID8gcmMgOiAtRU5PRU5U
OwogCQlnb3RvIGVycm9yOworCX0KIAogCWtmcmVlKHJlZl9wYXRoKTsKIAkvKgotLSAKMi40MS4w
Cgo=


--=-N9aSZlEPmmNurxkQQ40V--
