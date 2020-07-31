Return-Path: <SRS0=14TU=BK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2E9C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Jul 2020 03:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BEBD20663
	for <linux-cifs@archiver.kernel.org>; Fri, 31 Jul 2020 03:55:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xi25tnvL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgGaDze (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jul 2020 23:55:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730820AbgGaDze (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Jul 2020 23:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596167730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hvXy8MWgG797rqAWiy0rLqER8ho6yQL4/ZHLnX9Z8vg=;
        b=Xi25tnvLq+eO2yG8DD47zeVJjWFTefi8qYIaHBF4FVtcC6vnzCp3D8k+jOKT9yG7nSG0fU
        bmvPpxolSxy9fuWDgGxMuyrBowdFBQtnaB23bxOj0pc4u4PJUIcJZwkMz6S9Uo1Gq53WJ+
        sVqEtkDlF7u0XjwbBk4C4EZsoYNa5pY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-Qvknn3mLOLSd4TMUjOmHMw-1; Thu, 30 Jul 2020 23:54:34 -0400
X-MC-Unique: Qvknn3mLOLSd4TMUjOmHMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A511C1005510;
        Fri, 31 Jul 2020 03:54:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C0A425262;
        Fri, 31 Jul 2020 03:54:33 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92C779A0E0;
        Fri, 31 Jul 2020 03:54:33 +0000 (UTC)
Date:   Thu, 30 Jul 2020 23:54:32 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     "Michael Keane, K1MK" <mkeane@arrl.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <smfrench@gmail.com>
Message-ID: <2012730924.44428949.1596167672893.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5muepeJcNHHBUnV=ToHUYnud9KbfkKq1P17L=J4Ev2L+vw@mail.gmail.com>
References: <b14432a4-bb8c-7a0f-4339-b7e6ddec9b4a@arrl.org> <CAH2r5msj3KMMonyhjDeyAweHEBezOHFkJwCUXpJ4Gv59Q=S9bQ@mail.gmail.com> <752d5d05-7b91-b119-b5a6-7fcdeb1f0ced@arrl.org> <CAH2r5muNtwm3V-0GpaRBXmrptGDO9w1vDSWN9Wrf_eebuevg6A@mail.gmail.com> <61450b64-ed70-6b8f-2beb-57267ddcb8c5@arrl.org> <CAH2r5mu-g-RrR9Q4ghmqjkd-mbXbfeJE=HgVSaEEosCyBNoO8Q@mail.gmail.com> <119a0298-4099-c65e-30db-746814e36cce@arrl.org> <CAH2r5muepeJcNHHBUnV=ToHUYnud9KbfkKq1P17L=J4Ev2L+vw@mail.gmail.com>
Subject: Re: issue -- cifs automounts stopped working
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.22]
Thread-Topic: issue -- cifs automounts stopped working
Thread-Index: oje4MaGsnFCb9ucedDhd98eJtw+mZQ==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I'm not sure if your problem is like this. But I know there is
a bug for selinux. It will prevent to mount cifs with krb5 when=20
krb5 upgrade from 1.17 to 1.18 in RHEL8. Disabled selinux or=20
executing "setsebool samba_export_all_rw=3D1" will fix this issue.=20
  https://bugzilla.redhat.com/show_bug.cgi?id=3D1847221

Thanks.

----- Original Message -----
> From: "Steve French via samba-technical" <samba-technical@lists.samba.org=
>
> To: "Michael Keane, K1MK" <mkeane@arrl.org>
> Cc: "Shyam Prasad N" <nspmangalore@gmail.com>, "CIFS" <linux-cifs@vger.ke=
rnel.org>, "samba-technical"
> <samba-technical@lists.samba.org>
> Sent: Wednesday, July 22, 2020 12:03:10 PM
> Subject: Re: issue -- cifs automounts stopped working
>=20
> There are two common Kerberos libraries, MIT and Heimdal (Heimdal is
> also packaged as an optional part of Samba as an alternative to MIT
> Kerberos) ... would be interesting if there is a way to work around
> this by switching to Heimdal krb5 libraries.
>=20
> Adding samba-technical as some of the developers on samba-technical
> know the Kerberos maintainers and may have suggestions on how to track
> down this possible regression in MIT kerberos.
>=20
> On Tue, Jul 21, 2020 at 10:48 PM Michael Keane, K1MK <mkeane@arrl.org> wr=
ote:
> >
> > Tried setting KRB5_CCNAME to KEYRING:persistent:1000 with no change
> > (Also tried KRB5CCNAME  as well, as that's the environment variable
> > which seems to work with kinit & klist)
> >
> > Also tried setting default_ccahe_name in /etc/krb5.conf to a legacy
> > value of
> >
> >      default_ccache_name =3D /tmp/krb5_%{uid}
> >
> > in order to force it to use the filesystem rather than the kernel space
> > for the credentials cache. And it still fails in the same way. I think
> > that tends to makes this more likely a regression in krb5 than the kern=
el.
> >
> > I believe that I may have verified this by reverting from
> > krb5-*/-/1.18.2-10 to krb5-*-1.17.1-5 which resolves the issue
> >
> >
> >
> > On 07/21/2020 3:59 PM, Steve French wrote:
> > > Would setting KRB5_CCNAME (as would be expected in the past) for that
> > > process fix the issue?
> > >
> > > On Tue, Jul 21, 2020 at 2:52 PM Michael Keane, K1MK <mkeane@arrl.org>
> > > wrote:
> > >> KRB5_CCNAME is not set in the environment of the user for whom the
> > >> automount is failing.
> > >>
> > >> In /etc/krb5.conf the default is set to:
> > >>
> > >>      default_ccache_name =3D KEYRING:persistent:%{uid}
> > >>
> > >> The calls to keyctl()  in the strace for cifs.upcall  indicate that =
it's
> > >> successfully locating the user's keyring in the kernel and that it i=
s
> > >> able to read key data from that keying
> > >>
> > >> I haven't gone through and tried unpacking and decoding the contents=
 of
> > >> those reads, but the reads aren't failing outright like it couldn't =
find
> > >> the credentials cache or the contents that it's looking for
> > >>
> > >>
> > >> On 07/21/2020 1:36 PM, Steve French wrote:
> > >>> That is plausible but I also wonder about other whether other parts=
 of
> > >>> krb5 configuration are changed/broken eg KRB5_CCNAME environment
> > >>> variable
> > >>>
> > >>> See https://web.mit.edu/kerberos/krb5-1.12/doc/basic/ccache_def.htm=
l
> > >>>
> > >>> On Tue, Jul 21, 2020, 12:24 Michael Keane, K1MK <mkeane@arrl.org
> > >>> <mailto:mkeane@arrl.org>> wrote:
> > >>>
> > >>>      Thanks
> > >>>
> > >>>      In trying to further debug this problem, I've stood up a separ=
ate
> > >>>      Fedora 31 instance for testing with the result that the same
> > >>>      configuration that is failing on Fedora 32 is working under Fe=
dora
> > >>>      31
> > >>>
> > >>>      Using strace it would appear the deviation occurs at the point=
 of
> > >>>      "handle_krb5_mech" where the Fedora 31 instance proceeds thoug=
h
> > >>>      several keyctl() calls to a successful return while the Fedora=
 32
> > >>>      instance goes through a similar sequence of keyctl() calls but
> > >>>      rather than finishing up with a final call to keyctl() to
> > >>>      instantiate the key it appears that the krb5 library and/or ss=
sd
> > >>>      is going through a series of steps to locate the KDC (and fail=
ing)
> > >>>      even though the KDCs have always been explicitly configured in
> > >>>      /etc/krb5.conf
> > >>>
> > >>>      So the root cause of this issue may not be anything in cifs.up=
call
> > >>>      but rather something in the sssd or kerberos that got changed =
as a
> > >>>      result of moving from Fedora 31 to Fedora 32
> > >>>
> > >>>      On 07/18/2020 8:40 PM, Steve French wrote:
> > >>>>      Looks like error obtaining the key (either keyutils package n=
ot
> > >>>>      installed or no Kerberos ticket found).
> > >>>>
> > >>>>      This page has debug instructions for cifs.upcall. see of that
> > >>>>      information is helpful.
> > >>>>
> > >>>>      http://sprabhu.blogspot.com/2014/12/debugging-calls-to-cifsup=
call.html?m=3D1
> > >>>>
> > >>>>      Also try kinit as a local user and then mount with cruid moun=
t
> > >>>>      option pointing to their uid to see if that helps.
> > >>>>
> > >>>>      On Fri, Jul 17, 2020, 09:04 Michael Keane, K1MK <mkeane@arrl.=
org
> > >>>>      <mailto:mkeane@arrl.org>> wrote:
> > >>>>
> > >>>>          CIFS automounts to local NAS devices have stopped working
> > >>>>          recently
> > >>>>
> > >>>>          Fedora 32
> > >>>>
> > >>>>          kernel 5.7.8-200.fc32.x86_64
> > >>>>
> > >>>>          mount.cifs version: 6.9
> > >>>>
> > >>>>          auto.misc: it-share
> > >>>>          -fstype=3Dcifs,multiuser,cruid=3D${UID},rw,vers=3Ddefault=
,sec=3Dkrb5
> > >>>>          ://filer5/IT_Share
> > >>>>
> > >>>>          dmesg:
> > >>>>
> > >>>>              [ 3428.883661] fs/cifs/cifsfs.c: Devname:
> > >>>>              //filer5.arrlhq.org/IT_Share
> > >>>>          <http://filer5.arrlhq.org/IT_Share> flags: 0
> > >>>>              [ 3428.883702] fs/cifs/connect.c: Username: root
> > >>>>              [ 3428.883706] fs/cifs/connect.c: file mode: 0755 dir
> > >>>>          mode: 0755
> > >>>>              [ 3428.883709] fs/cifs/connect.c: CIFS VFS: in
> > >>>>          mount_get_conns as
> > >>>>              Xid: 12 with uid: 0
> > >>>>              [ 3428.883710] fs/cifs/connect.c: UNC:
> > >>>>          \\filer5.arrlhq.org <http://filer5.arrlhq.org>\IT_Share
> > >>>>              [ 3428.883721] fs/cifs/connect.c: Socket created
> > >>>>              [ 3428.883723] fs/cifs/connect.c: sndbuf 16384 rcvbuf
> > >>>>              131072
> > >>>>              rcvtimeo 0x1b58
> > >>>>              [ 3428.884126] fs/cifs/fscache.c:
> > >>>>          cifs_fscache_get_client_cookie:
> > >>>>              (0x000000006d2b3226/0x0000000090edec3a)
> > >>>>              [ 3428.884130] fs/cifs/connect.c: CIFS VFS: in
> > >>>>          cifs_get_smb_ses as
> > >>>>              Xid: 13 with uid: 0
> > >>>>              [ 3428.884131] fs/cifs/connect.c: Existing smb sess n=
ot
> > >>>>              found
> > >>>>              [ 3428.884135] fs/cifs/smb2pdu.c: Negotiate protocol
> > >>>>              [ 3428.884141] fs/cifs/connect.c: Demultiplex PID: 57=
78
> > >>>>              [ 3428.884156] fs/cifs/transport.c: Sending smb:
> > >>>>              smb_len=3D252
> > >>>>              [ 3429.010818] fs/cifs/connect.c: RFC1002 header 0x11=
c
> > >>>>              [ 3429.010830] fs/cifs/smb2misc.c: SMB2 data length 9=
6
> > >>>>          offset 128
> > >>>>              [ 3429.010832] fs/cifs/smb2misc.c: SMB2 len 224
> > >>>>              [ 3429.010835] fs/cifs/smb2misc.c: length of negconte=
xts
> > >>>>          60 pad 0
> > >>>>              [ 3429.010871] fs/cifs/transport.c: cifs_sync_mid_res=
ult:
> > >>>>          cmd=3D0
> > >>>>              mid=3D0 state=3D4
> > >>>>              [ 3429.010885] fs/cifs/misc.c: Null buffer passed to
> > >>>>              cifs_small_buf_release
> > >>>>              [ 3429.010891] fs/cifs/smb2pdu.c: mode 0x1
> > >>>>              [ 3429.010893] fs/cifs/smb2pdu.c: negotiated smb3.1.1
> > >>>>              dialect
> > >>>>              [ 3429.010903] fs/cifs/asn1.c: OID len =3D 7 oid =3D =
0x1 0x2
> > >>>>          0x348 0xbb92
> > >>>>              [ 3429.010907] fs/cifs/asn1.c: OID len =3D 7 oid =3D =
0x1 0x2
> > >>>>          0x348 0x1bb92
> > >>>>              [ 3429.010910] fs/cifs/asn1.c: OID len =3D 10 oid =3D=
 0x1 0x3
> > >>>>          0x6 0x1
> > >>>>              [ 3429.010912] fs/cifs/smb2pdu.c: decoding 2 negotiat=
e
> > >>>>          contexts
> > >>>>              [ 3429.010914] fs/cifs/smb2pdu.c: decode SMB3.11
> > >>>>          encryption neg
> > >>>>              context of len 4
> > >>>>              [ 3429.010916] fs/cifs/smb2pdu.c: SMB311 cipher type:=
1
> > >>>>              [ 3429.010921] fs/cifs/connect.c: Security Mode: 0x1
> > >>>>          Capabilities:
> > >>>>              0x300046 TimeAdjust: 0
> > >>>>              [ 3429.010923] fs/cifs/smb2pdu.c: Session Setup
> > >>>>              [ 3429.010926] fs/cifs/smb2pdu.c: sess setup type 5
> > >>>>              [ 3429.010949] fs/cifs/cifs_spnego.c: key description=
 =3D
> > >>>>              ver=3D0x2;host=3Dfiler5.arrlhq.org
> > >>>>          <http://filer5.arrlhq.org>;ip4=3D10.1.123.38;sec=3Dkrb5;u=
id=3D0x0;creduid=3D0x3e8;user=3Droot;pid=3D0x1690
> > >>>>              [ 3429.025053] CIFS VFS: \\filer5.arrlhq.org
> > >>>>          <http://filer5.arrlhq.org> Send error in SessSetup
> > >>>>              =3D -126
> > >>>>              [ 3429.025056] fs/cifs/connect.c: CIFS VFS: leaving
> > >>>>          cifs_get_smb_ses
> > >>>>              (xid =3D 13) rc =3D -126
> > >>>>              [ 3429.025059] fs/cifs/connect.c: build_unc_path_to_r=
oot:
> > >>>>              full_path=3D\\filer5.arrlhq.org
> > >>>>          <http://filer5.arrlhq.org>\IT_Share
> > >>>>              [ 3429.025059] fs/cifs/connect.c: build_unc_path_to_r=
oot:
> > >>>>              full_path=3D\\filer5.arrlhq.org
> > >>>>          <http://filer5.arrlhq.org>\IT_Share
> > >>>>              [ 3429.025060] fs/cifs/connect.c: build_unc_path_to_r=
oot:
> > >>>>              full_path=3D\\filer5.arrlhq.org
> > >>>>          <http://filer5.arrlhq.org>\IT_Share
> > >>>>              [ 3429.025062] fs/cifs/dfs_cache.c: __dfs_cache_find:
> > >>>>          search path:
> > >>>>              \filer5.arrlhq.org <http://filer5.arrlhq.org>\IT_Shar=
e
> > >>>>              [ 3429.025063] fs/cifs/dfs_cache.c: get_dfs_referral:=
 get
> > >>>>          an DFS
> > >>>>              referral for \filer5.arrlhq.org
> > >>>>          <http://filer5.arrlhq.org>\IT_Share
> > >>>>              [ 3429.025065] fs/cifs/dfs_cache.c: dfs_cache_noreq_f=
ind:
> > >>>>          path:
> > >>>>              \filer5.arrlhq.org <http://filer5.arrlhq.org>\IT_Shar=
e
> > >>>>              [ 3429.025071] fs/cifs/fscache.c:
> > >>>>              cifs_fscache_release_client_cookie:
> > >>>>              (0x000000006d2b3226/0x0000000090edec3a)
> > >>>>              [ 3429.025076] fs/cifs/connect.c: CIFS VFS: leaving
> > >>>>          mount_put_conns
> > >>>>              (xid =3D 12) rc =3D 0
> > >>>>              [ 3429.025077] CIFS VFS: cifs_mount failed w/return c=
ode
> > >>>>              =3D -2
> > >>>>
> > >>>>          journalctl:
> > >>>>
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: key
> > >>>>              description:
> > >>>>              cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dfiler5.arrl=
hq.org
> > >>>>          <http://filer5.arrlhq.org>;ip4=3D10.1.123.38;sec=3Dkrb5;u=
id=3D0x0;creduid=3D0x3e8;user=3Droot;pid=3D0x1690
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: ver=3D2
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
> > >>>>              host=3Dfiler5.arrlhq.org <http://filer5.arrlhq.org>
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: ip=3D10.1.1=
23.38
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: sec=3D1
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: uid=3D0
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: creduid=3D1=
000
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: user=3Droot
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: pid=3D5776
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
> > >>>>              get_cachename_from_process_env:
> > >>>>              pathname=3D/proc/5776/environ
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
> > >>>>              get_existing_cc: default ccache is
> > >>>>          KEYRING:persistent:1000:1000
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
> > >>>>              handle_krb5_mech: getting service ticket for
> > >>>>          filer5.arrlhq.org <http://filer5.arrlhq.org>
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
> > >>>>              cifs_krb5_get_req: unable to get credentials for
> > >>>>          filer5.arrlhq.org <http://filer5.arrlhq.org>
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]:
> > >>>>              handle_krb5_mech: failed to obtain service ticket
> > >>>>          (-1765328370)
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: Unable to
> > >>>>              obtain service ticket
> > >>>>              Jul 17 09:43:13 mkZ230.ARRLHQ.ORG
> > >>>>          <http://mkZ230.ARRLHQ.ORG> cifs.upcall[5779]: Exit status
> > >>>>              -1765328370
> > >>>>
> > >>>>          $ klist
> > >>>>          Ticket cache: KEYRING:persistent:1000:1000
> > >>>>          Default principal: mkeane@ARRLHQ.ORG
> > >>>>          <mailto:mkeane@ARRLHQ.ORG>
> > >>>>
> > >>>>          Valid starting       Expires              Service princip=
al
> > >>>>          07/17/2020 09:43:06  07/17/2020 19:43:06
> > >>>>          krbtgt/ARRLHQ.ORG@ARRLHQ.ORG <mailto:ARRLHQ.ORG@ARRLHQ.OR=
G>
> > >>>>                   renew until 07/24/2020 09:42:57
> > >>>>
> > >>>>          Filer5 is a QNAP TS-870U-RP Version 4.3.6.1070 (2019/09/1=
0)
> > >>>>          NAS device
> > >>>>          but having this issue with other NAS device on LAN
> > >>>>
> > >>>>          --
> > >>>>          Michael Keane, K1MK
> > >>>>          IT Manager
> > >>>>          ARRL, The National Association for Amateur Radio=E2=84=A2
> > >>>>          225 Main Street, Newington, CT 06111-1494 USA
> > >>>>          Telephone: (860) 594-0285
> > >>>>          email: mkeane@arrl.org <mailto:mkeane@arrl.org>
> > >>>>
> > >>>      --
> > >>>      Michael Keane, K1MK
> > >>>      IT Manager
> > >>>      ARRL, The National Association for Amateur Radio=E2=84=A2
> > >>>      225 Main Street, Newington, CT 06111-1494 USA
> > >>>      Telephone: (860) 594-0285
> > >>>      email:mkeane@arrl.org  <mailto:mkeane@arrl.org>
> > >>>
> > >> --
> > >> Michael Keane, K1MK
> > >> IT Manager
> > >> ARRL, The National Association for Amateur Radio=E2=84=A2
> > >> 225 Main Street, Newington, CT 06111-1494 USA
> > >> Telephone: (860) 594-0285
> > >> email: mkeane@arrl.org
> > >>
> > >
> >
> > --
> > Michael Keane, K1MK
> > IT Manager
> > ARRL, The National Association for Amateur Radio=E2=84=A2
> > 225 Main Street, Newington, CT 06111-1494 USA
> > Telephone: (860) 594-0285
> > email: mkeane@arrl.org
> >
>=20
>=20
> --
> Thanks,
>=20
> Steve
>=20
>=20

