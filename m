Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDC6C001B0
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Aug 2023 16:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjHKQ1A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Aug 2023 12:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHKQ07 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Aug 2023 12:26:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CF218F
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 09:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96BD363CE4
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 16:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B529C433C8;
        Fri, 11 Aug 2023 16:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691771218;
        bh=LIlnTwHkVOy9JLaJ8mUnD6nmmp2uhG+8eu6XMkh1OBU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KTsyOie7rCSsAPW6IgvnEDYQTix6hpkkCva+JdYkNAil5DHvoYQ7U0bkqAv3LxEuJ
         3xW2pCQnYgw7xHmxZyt/r0wrUWz/HcRgoRkEFA8sh9KlybtEAcG/c2rqtQGFge9RWv
         miLl78dRviUMqqP98rh+9CPOFJbW0uTCgDXjcQzuT2Li3dT0ieiqX86pKJz/BgHl4W
         1gaw6PmPf3/+evVdXjiR35oH1MyTH7f58G5WRNOS6BlN6TYb1ciqzguitCR3POqbyp
         B7irW2oFyQCMymBJwIIKOzdICaoM9+MiOWZ83EATrzQwjhaLeI46cvx2j3DKeSqADN
         e+NKSzZGUHgGQ==
Message-ID: <7f1c7940764425cbcf6f6585d138ef38e6618581.camel@kernel.org>
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
Date:   Fri, 11 Aug 2023 12:26:55 -0400
In-Reply-To: <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
         <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
         <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
         <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
         <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 2023-08-11 at 12:15 -0300, Paulo Alcantara wrote:
> Jeff Layton <jlayton@kernel.org> writes:
>=20
> > On Wed, 2021-06-23 at 19:34 -0500, Steve French wrote:
> > > updated patch attached with Aurelien's suggestion.
> > >=20
> > > On Wed, Jun 23, 2021 at 7:17 AM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >=20
> > > > Agreed.
> > > >=20
> > > > On June 23, 2021 8:48:24 AM GMT-03:00, "Aur=E9lien Aptel" <aaptel@s=
use.com> wrote:
> > > > > Steve French <smfrench@gmail.com> writes:
> > > > > > We weren't checking if tcon is null before setting dfs path,
> > > > > > although we check for null tcon in an earlier assignment statem=
ent.
> > > > >=20
> > > > > If tcon is NULL there is no point in continuing in that function,=
 we
> > > > > should have exited earlier.
> > > > >=20
> > > > > If tcon is NULL it means mount_get_conns() failed so presumably r=
c will
> > > > > be !=3D 0 and we would goto error.
> > > > >=20
> > > > > I don't think this is needed. We could change the existing check =
after
> > > > > the loop to this you really want to be safe:
> > > > >=20
> > > > >       if (rc || !tcon)
> > > > >               goto error;
> > > > >=20
> > > > >=20
> > > > > Cheers,
> > >=20
> > >=20
> > >=20
> >=20
> > I know this patch is ancient and the mainline code has marched on, but
> > it seems really suspicious to me.
>=20
> Yes, it is.
>=20
> > With this, we have cifs_mount returning 0, even though the superblock
> > hasn't been properly initialized. Is that expected? Shouldn't it return
> > an error in that case?
>=20
> No, that isn't expected.  And yes, if @tcon would ever be NULL at that
> point, we should be returning an error instead.  Otherwise we'd end up
> dereferencing a NULL @tcon while trying to get an inode for the root
> dentry later.
>=20
> However, by quickly looking at the old code -- on top of 162004a2f7ef --
> I don't see how we'd end up having a NULL @tcon with rc =3D=3D 0 as
> mount_get_conns() would return -errno if it couldn't get a tcon.  Please
> correct me if I'm missing something.  Whether it is possibile or not,
> the NULL @tcon check is certainly missing a 'rc =3D -ENOENT' or some othe=
r
> error before bailing out as you've pointed out.

Thanks for the confirmation. There were some oopses on some RHEL8 (5.14
based kernels). The stack looked something like this:

PID: 2415716  TASK: ffff937139090000  CPU: 3    COMMAND: "ls"
 #0 [ffff9ef946b23728] machine_kexec at ffffffffac867cfe
 #1 [ffff9ef946b23780] __crash_kexec at ffffffffac9ad94d
 #2 [ffff9ef946b23848] crash_kexec at ffffffffac9ae881
 #3 [ffff9ef946b23860] oops_end at ffffffffac8274f1
 #4 [ffff9ef946b23880] no_context at ffffffffac879a03
 #5 [ffff9ef946b238d8] __bad_area_nosemaphore at ffffffffac879d64
 #6 [ffff9ef946b23920] do_page_fault at ffffffffac87a617
 #7 [ffff9ef946b23950] page_fault at ffffffffad20111e
    [exception RIP: cifs_mount+1126]
    RIP: ffffffffc08e8826  RSP: ffff9ef946b23a00  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffff936c8221ea00  RCX: ffff936f8018b320
    RDX: 0000000000000001  RSI: ffff936f8018b420  RDI: ffff936c8221ea00
    RBP: ffff9ef946b23a90   R8: 5346445756535c5c   R9: 6765642e50313031
    R10: 65622e666f6f7267  R11: 0063696c6275505c  R12: ffff9370b192fc00
    R13: ffff936f8018b420  R14: 00000000003097ad  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #8 [ffff9ef946b23a98] cifs_smb3_do_mount at ffffffffc08d11f2 [cifs]
 #9 [ffff9ef946b23aa0] cifs_smb3_do_mount at ffffffffc08d11f2 [cifs]
#10 [ffff9ef946b23b08] smb3_get_tree at ffffffffc0930ae0 [cifs]
#11 [ffff9ef946b23b30] vfs_get_tree at ffffffffacb52365
#12 [ffff9ef946b23b50] fc_mount at ffffffffacb7485e
#13 [ffff9ef946b23b60] vfs_kern_mount at ffffffffacb748ec
#14 [ffff9ef946b23b80] cifs_dfs_do_automount at ffffffffc093552e [cifs]
#15 [ffff9ef946b23bc0] cifs_dfs_d_automount at ffffffffc0935880 [cifs]
#16 [ffff9ef946b23bd0] follow_managed at ffffffffacb5bdaf
#17 [ffff9ef946b23c10] lookup_fast at ffffffffacb5c7e5
#18 [ffff9ef946b23c68] walk_component at ffffffffacb5d258
#19 [ffff9ef946b23cc8] path_lookupat at ffffffffacb5e215
#20 [ffff9ef946b23d28] filename_lookup at ffffffffacb62710
#21 [ffff9ef946b23e40] vfs_statx at ffffffffacb55874
#22 [ffff9ef946b23e98] __do_sys_statx at ffffffffacb5692b
#23 [ffff9ef946b23f38] do_syscall_64 at ffffffffac8043ab
#24 [ffff9ef946b23f50] entry_SYSCALL_64_after_hwframe at
ffffffffad2000a9
    RIP: 00007ff6a2637edf  RSP: 00007ffe040017d0  RFLAGS: 00000246
    RAX: ffffffffffffffda  RBX: 00007ffe04001910  RCX: 00007ff6a2637edf
    RDX: 0000000000000100  RSI: 00007ffe04001910  RDI: 00000000ffffff9c
    RBP: 0000000000000100   R8: 00007ffe040017f0   R9: 00000000ffffff9c
    R10: 0000000000000002  R11: 0000000000000246  R12: 00007ffe040017f0
    R13: 0000000000000000  R14: 0000000000000003  R15: 000055ce1a3ae1b8
    ORIG_RAX: 000000000000014c  CS: 0033  SS: 002b

Analysis of the vmcore by Roberto showed that we had ended up past that
point with tcon=3D=3DNULL and rc=3D=3D0.

Steve's patch would have fixed the panic there, but I think the host
would have ended up with a successful mount, but with a broken
superblock. The current code seems a bit less fragile, and I didn't see
any similar brokenness there, but I didn't look too hard either.

In any case, we'll plan to fix this up with a one-off in RHEL/Centos.
Thanks again for the sanity check!

--=20
Jeff Layton <jlayton@kernel.org>
