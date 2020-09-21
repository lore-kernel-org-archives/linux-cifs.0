Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE43C43464
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 09:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C4B20719
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 09:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="f5CKEEbm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIUJbw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 05:31:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:39784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgIUJbw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 21 Sep 2020 05:31:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600680710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYEhbTDfiW8GwmeQ36W8CMIIX7xKf0SFukD25EgOlZg=;
        b=f5CKEEbmxyiQTH97ocRT3d5jGE6hlsleVeYjXH03HnVUytuqqGnlY7n+TwYCkZvbSp8Fbi
        DrXYr8WWOz48S77oguhaX4wm8wDpy2hP0B+5LMRR2RMkUea6CnCZI08Klscyq+eiipGq3t
        QXPbTCu5wG0b+qA4XzlApsyx3Dfb1ME=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 887E3B2C9;
        Mon, 21 Sep 2020 09:32:26 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: mutiuser request_key in both ntlmssp and krb5
In-Reply-To: <CANT5p=ob6gSFkdy+k0Hera9mLQVhZ743RUiGk7gHbTGwuu7KEw@mail.gmail.com>
References: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
 <87tuvwlpto.fsf@suse.com> <87r1r0lp9s.fsf@suse.com>
 <CAH2r5muiYZGr=1rZHobpKXAtG+OCDORZok_acOkL6TQssVrm3Q@mail.gmail.com>
 <CANT5p=ob6gSFkdy+k0Hera9mLQVhZ743RUiGk7gHbTGwuu7KEw@mail.gmail.com>
Date:   Mon, 21 Sep 2020 11:31:49 +0200
Message-ID: <87imc7lblm.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hey,

Shyam Prasad N <nspmangalore@gmail.com> writes:
>> IIRC the keyring used is the session one, so each user gets a different =
keyring.
>
> Ah, I see. So I'm wondering how the multiuser mounts for ntlmssp work?
> On each login, does the user have to populate the keyring with his/her
> credentials?

I think that was the idea yes, or maybe integrate with PAM somehow? But
you'll have to do some archeological work with Jeff Layton to get to the
bottom of this :)

> Agreed for majority cases. But Steve makes a good point that this only
> gets us the local uid/username.
> However, the actual domain user name could be very different. For
> example, local user user1 could be logged in as domain1\user1 or
> domain2\user1. How do we handle this scenario?

This is a sadistic puzzle game with many pieces...

If the Linux client is properly integrated with AD ({winbind or ssd} +
PAM module + nsswitch conf), you login with your AD user and get an AD
uid. There is no local user.

    $ ssh 'NUC\administrator@192.168.122.50'
    Password:=20
    Last login: Mon Sep 21 10:41:34 2020 from 192.168.122.1
    Have a lot of fun...
    NUC\administrator@twmember:~> id
    uid=3D20501(NUC\administrator) gid=3D20514(NUC\domain users) groups=3D2=
0514(NUC\domain users),10000(BUILTIN\administrators),10001(BUILTIN\users),2=
0501(NUC\administrator),20513(NUC\domain admins),20519(NUC\schema admins),2=
0520(NUC\enterprise admins),20521(NUC\group policy creator owners),20573(NU=
C\denied rodc password replication group),21108(NUC\netmon users)
    $ mount.cifs //adnuc.nuc.test/data /x -o sec=3Dkrb5i,multiuser,cifsacl,=
username=3Dadministrator,domain=3DNUC
    $ ls -l /x
    -rwx------ 1 NUC\user1 NUC\domain users             0 Aug  5 22:14 from=
_u1
    -rwx------ 1 NUC\user2 NUC\domain users             0 Aug  5 22:16 from=
_u2

I don't know what is the situation at Redhat but at SUSE the only
supported way to use multiuser mounts (if even documented) is via a
properly AD-joined system and kerberos. Even then, I think I've only
seen 1 ticket from a multiuser setup in 5 years. Most setups are 1 mount
per user for user dirs, where it makes sense to have everything owned by
the user.

> I'm guessing (please correct me if I'm wrong here) that an user
> session corresponds to only one of those two remote users
> (domain1\user1 or domain2\user1). In that case, how do we get the
> fully qualified name in the context of this session?

At the SMB level you only see Windows SIDs and cifs.ko will report all
files as being owned by the mounter's uid (or uid=3D mount opt).

When you mount with cifsacl mount option, cifs.ko will try to map those
SIDs to uids by upcalling cifs.idmap. This program will ultimately query
winbind or sssd to get the mapping.

So userspace tools will see AD uids. Now to get the text username from
it they use regular POSIX libc calls like getpwuid(). If your system is
properly integrated with AD, this call gets rerouted via nsswitch to
again use winbind/sssd.

There is a book that covers some of this called "Mechanics of User
Identification and Authentication: Fundamentals of Identify
Management". It's from 2007 but still relevant. Here's a diagram from
page 96: https://i.imgur.com/PBwXIuJ.png

Glibc:
https://www.gnu.org/software/libc/manual/html_node/Lookup-User.html

Nsswitch: allows to replace the various traditional text-based databases
of the system (/etc/passwd, /etc/hosts, ....) by calling into different
backends.

https://man7.org/linux/man-pages/man5/nsswitch.conf.5.html

nsswitch winbind backend:
https://gitlab.com/samba-team/samba/-/blob/master/nsswitch/winbind_nss_linu=
x.c

cifs.idmap plugin API:
https://github.com/piastry/cifs-utils/blob/master/idmap_plugin.h

cifs.idmap winbind backend (ships with cifs-utils):
https://github.com/piastry/cifs-utils/blob/master/idmapwb.c

cifs.idmap sssd backend (ships with sssd):
https://github.com/SSSD/sssd/blob/12f74f8c98fac6a7eeb3937f623949bcb3adb547/=
src/lib/cifs_idmap_sss/cifs_idmap_sss.c

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
