Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D23C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 07:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D949E60F46
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Sep 2021 07:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhI0H1s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Sep 2021 03:27:48 -0400
Received: from smtppost.atos.net ([193.56.114.176]:9715 "EHLO
        smarthost3.atos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233185AbhI0H1r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Sep 2021 03:27:47 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Sep 2021 03:27:47 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=atos.net; i=@atos.net; q=dns/txt; s=mail;
  t=1632727570; x=1664263570;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YKvVrYkX+oEgoXf0TNrks+ueYikQeIMCa2dHmmvSjNU=;
  b=47WyTlTS+o8ioY5b/eOnVNmZyJmeoceHMERCIez3z+coSCuMmores0H0
   f5SkEQVCFUWA8/OJBcZk6tNWSOTol2Zpebk45DBYWrKiQamH5alSIuH6g
   C3ZOGcbCklqgbhFdws3EM1Ao7ehdb2OQYv2TxbT0iPg+KqfJkdgplVf1M
   I=;
X-IronPort-AV: E=Sophos;i="5.85,325,1624312800"; 
   d="scan'208";a="259681431"
X-MGA-submission: =?us-ascii?q?MDH/xH7wdIWX0C70H+hYfC/csykSnafZ3nmBEF?=
 =?us-ascii?q?GbKRhc7jFb8ktmIbipqzl/kOh71voRWRYIViuf7PGnz29yQ6/GlYHYwG?=
 =?us-ascii?q?0alTfkUARKXW9fG0mBAAqvhJGtdKiOFb6xnRTnLWddDm5u65KKMFPhK4?=
 =?us-ascii?q?Y7?=
Received: from mail.sis.atos.net (HELO GITEXCPRDMB11.ww931.my-it-solutions.net) ([10.89.28.141])
  by smarthost3.atos.net with ESMTP/TLS/AES256-GCM-SHA384; 27 Sep 2021 09:18:50 +0200
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net (10.89.28.144) by
 GITEXCPRDMB11.ww931.my-it-solutions.net (10.89.28.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 27 Sep 2021 09:18:50 +0200
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net
 ([fe80::4817:dcd:3f05:31dd]) by GITEXCPRDMB14.ww931.my-it-solutions.net
 ([fe80::4817:dcd:3f05:31dd%8]) with mapi id 15.01.2242.010; Mon, 27 Sep 2021
 09:18:50 +0200
From:   "Weiser, Michael" <michael.weiser@atos.net>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Jacob Shivers <jshivers@redhat.com>
CC:     Simo Sorce <simo@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        "The GSS-Proxy developers and users mailing list" 
        <gss-proxy@lists.fedorahosted.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
Thread-Topic: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
Thread-Index: AQHXCgvMbLbyZ+7iUU2CMDV0Fo+sRau0mFWAgAQpC54=
Date:   Mon, 27 Sep 2021 07:18:50 +0000
Message-ID: <10598d01fe09433ea57a38142b7fb854@atos.net>
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net>
 <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
 <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com>
 <c49c0a18c228e6aa43dbb2cbab7e0a266d1c0371.camel@redhat.com>
 <CANT5p=p_G+jMMVMkYDL=fXZi_OO7eY2Foz8VkyQuT+1h5Xgifw@mail.gmail.com>
 <facbd0542074a5b8ef2f6f3d5649010503d8d84d.camel@redhat.com>
 <CALe0_75RLR=gcwitnxvACh1mt3jnOGHFx7baO0YRhwEfKwFoGg@mail.gmail.com>,<CAKywueTUqhathrJmPc7eyNojv1F=199mNcFCENzoQjntK+CAzw@mail.gmail.com>
In-Reply-To: <CAKywueTUqhathrJmPc7eyNojv1F=199mNcFCENzoQjntK+CAzw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [160.92.209.239]
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Pavel,

> Do we have any more-up-to-date version of the cifs-utils patch other
> than the one attached to the email thread? I would like to merge the
> patch into the "next" branch so it makes the next release of
> cifs-utils.

I'm also not aware of a newer version. As one of the initiators of the disc=
ussion, who's highly interested in seeing this merged, I'm standing by to h=
elp out with background context, testing or improving the code. (The patch =
was meant as a PoC which is why I skipped some reindenting and niceties to =
keep its approach and impact easy to gauge.)

> Also there is a potential helper script mentioned above that is needed
> to set up gssproxy properly?

I'm not aware of a helper script. gssproxy just needs to be told about cifs=
-utils and how it should be treated using a single config drop file. Also i=
n the meantime, Jacob and I have streamlined the configuration so a separat=
e UNIX domain socket and tweaking its permissions using a systemd service d=
rop-in file is no longer needed. Instead, gssproxy can distinguish multiple=
 clients on the same socket using the calling binary derived from getsockop=
t/SO_PEERCRED.

Finally, environment variable GSS_USE_PROXY needs to be set for cifs.upcall=
 to enable the gssproxy proxy mech. (Instead of using the env command, cifs=
.upcall could have a command line option similar to rpc.gssd[1] which ends =
up doing the same thing.)

Here's the config summary:

# cat /etc/request-key.d/cifs.spnego.conf
create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes /usr/sbin/cifs=
.upcall %k

# cat /etc/gssproxy/99-cifs.conf
[service/cifs]
  mechs =3D krb5
# not needed when program option is used
#  socket =3D /var/lib/gssproxy/cifs.sock
  program =3D /usr/sbin/cifs.upcall
  cred_store =3D keytab:/etc/krb5.keytab
  cred_store =3D ccache:FILE:/var/lib/gssproxy/clients/krb5cc_%U
  cred_store =3D client_keytab:/var/lib/gssproxy/clients/%U.keytab
  cred_usage =3D initiate
# allow process with any euid to use the service and receive impersonated
# tickets for services
  allow_any_uid =3D yes
# allow euid access to keytab
  trusted =3D yes
# allow impersonation
  impersonate =3D yes
# allow process with euid 0 to use the keytab
  euid =3D 0

The actual mount can be done using system credentials from the keytab. Smal=
l proof session showcasing that gssproxy is involved and working:

# systemctl stop gssproxy
# mount -o sec=3Dkrb5,multiuser,user=3DFEDORA33\$ //dc/share /mnt
# su - adsuser -c "touch /mnt/test"
touch: cannot touch '/mnt/test': Permission denied
# systemctl start gssproxy
# su - adsuser -c "touch /mnt/test"
#

[1] http://git.linux-nfs.org/?p=3Dsteved/nfs-utils.git;a=3Dblob;f=3Dutils/g=
ssd/gssd.c;h=3D833d8e0110a9737df8ef6ddeb439ba1a37ee9931;hb=3DHEAD#l1128

Thanks,
Michael

________________________________________
From: Pavel Shilovsky <piastryyy@gmail.com>
Sent: 24 September 2021 19:09:47
To: Jacob Shivers
Cc: Simo Sorce; Shyam Prasad N; Steve French; The GSS-Proxy developers and =
users mailing list; linux-cifs@vger.kernel.org; samba-technical@lists.samba=
.org
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy

Caution! External email. Do not open attachments or click links, unless thi=
s email comes from a known sender and you know the content is safe.

Catching up on the email thread. For some reason I missed it originally som=
ehow.

Do we have any more-up-to-date version of the cifs-utils patch other
than the one attached to the email thread? I would like to merge the
patch into the "next" branch so it makes the next release of
cifs-utils.

Also there is a potential helper script mentioned above that is needed
to set up gssproxy properly?

--
Best regards,
Pavel Shilovsky

=D7=D4, 23 =C6=C5=D7=D2. 2021 =C7. =D7 09:43, Jacob Shivers <jshivers@redha=
t.com>:
>
> I have tested the patches for cifs.upcall and can say that with some
> additional modifications to gssproxy the end setup brings a degree of
> feature parity to SMB clients that had been previously exclusive to
> NFS clients.
> Deployment does require some additional configuration, including the
> creation of a drop-in file for gssproxy under /etc/gssproxy and for
> the gssproxy service managed by systemd
>
>
> ### KDC configuration
>
>  *** delegation ***
>
> Constrained Delegation (CD) for the SMB host to the Kerberized SMB server
> Resource Based Constrained Delegation (RBCD) on the Kerberized SMB
> server to determine which SMB clients can delegate
>
>
> ### SMB client configuration
>
>  *** sssd ***
>
>  Configuration file modification.
>
> Disable using fully qualified domain names as impersonation does not
> correctly handle fully qualified names at time of ticket acquisition.
>
> use_fully_qualified_names =3D False
>
>  *** gssproxy ***
>
>  Drop file creation
>
> Add a drop file for gssproxy to create the necessary socket and
> corresponding settings.
>
> # cat /etc/gssproxy/99-cifs-client.conf with contents
> [service/cifs]
> mechs =3D krb5
> socket =3D /var/lib/gssproxy/cifs.sock
> cred_store =3D keytab:/etc/krb5.keytab
> cred_usage =3D initiate
> euid =3D 0
> impersonate =3D yes
> allow_any_uid =3D yes
>
>  Service drop-in file.
>
> Create a drop-in file to limit socket access for an unattended user, if d=
esired.
>
> # cat /etc/systemd/system/gssproxy.service.d/90-cifs.conf
> [Service]
> # Limit cifs.sock socket file accessiblility to just the unattended user.
> ExecStartPost=3D/bin/bash -c 'chmod 660 /var/lib/gssproxy/cifs.sock &&
> setfacl -m u:chang:rw /var/lib/gssproxy/cifs.sock'
>
>
>  *** cifs.upcall ***
>
>  cifs.spnego.conf modification
>
> Allow for gssprxy to be used and specify socket file
>
> # cat /etc/request-key.d/cifs.spnego.conf
> create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes
> GSSPROXY_SOCKET=3D/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.upcall %k
>
>    include the '-t' flag to allow for accessing a Kerberized DFS
> namespace using a domain based mount, i.e //example.net/dfs/share
>
> create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes
> GSSPROXY_SOCKET=3D/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.upcall -t
> %k
>
>
> The above does allow for unattended users to access a Kerberized SMB
> share while limiting access to only a specific user:
>
> # mount //win2k16-dfs1.example.net/greendale/ /mnt -o
> sec=3Dkrb5,username=3D'TEST-BOX$@EXAMPLE.NET',multiuser
>
> # su - jeff
> Last login: Fri Feb  5 12:14:42 EST 2021 on pts/0
> [jeff@test-box ~]$ ll /mnt
> ls: cannot access '/mnt': Permission denied
> [jeff@test-box ~]$ logout
>
> # su - chang
> Last login: Fri Feb  5 12:14:46 EST 2021 on pts/0
> [chang@test-box ~]$ klist
> klist: No credentials cache found (filename: /tmp/krb5cc_602001123)
> [chang@test-box ~]$ ls -l /mnt
> total 143
>
> drwxr-xr-x. 2 chang domain users      0 Oct  4  2018  DfsrPrivate
> -rwxr-xr-x. 1 chang domain users      0 Sep 22 10:07  test_file
> -rwxr-xr-x. 1 chang domain users      0 Dec 14 15:22  whoami
> drwxr-xr-x. 2 chang domain users      0 Dec  7 12:54  winhome
>
> [chang@test-box ~]$ klist
> klist: No credentials cache found (filename: /tmp/krb5cc_602001123)
>
>
> Feb 23 12:22:44.857956 test-box.example.net su[1672]: (to jeff) root on p=
ts/1
> Feb 23 12:22:44.866263 test-box.example.net su[1672]:
> pam_systemd(su-l:session): Cannot create session: Already running in a
> session or user slice
> Feb 23 12:22:44.867158 test-box.example.net su[1672]:
> pam_unix(su-l:session): session opened for user jeff by root(uid=3D0)
> Feb 23 12:22:46.253310 test-box.example.net cifs.upcall[1700]: key
> description: cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dwin2k16-dfs1.examp=
le.net;ip4=3D192.168.124.132;sec=3Dkrb5;uid=3D0x23e1cedc;creduid=3D0x23e1ce=
dc;pid=3D0x6a3
> Feb 23 12:22:46.253335 test-box.example.net cifs.upcall[1700]: ver=3D2
> Feb 23 12:22:46.253338 test-box.example.net cifs.upcall[1700]:
> host=3Dwin2k16-dfs1.example.net
> Feb 23 12:22:46.253342 test-box.example.net cifs.upcall[1700]:
> ip=3D192.168.124.132
> Feb 23 12:22:46.253344 test-box.example.net cifs.upcall[1700]: sec=3D1
> Feb 23 12:22:46.253348 test-box.example.net cifs.upcall[1700]: uid=3D6020=
01116
> Feb 23 12:22:46.253352 test-box.example.net cifs.upcall[1700]: creduid=3D=
602001116
> Feb 23 12:22:46.253365 test-box.example.net cifs.upcall[1700]: pid=3D1699
> Feb 23 12:22:46.253978 test-box.example.net cifs.upcall[1700]:
> get_cachename_from_process_env: pathname=3D/proc/1699/environ
> Feb 23 12:22:46.254995 test-box.example.net cifs.upcall[1700]:
> get_existing_cc: default ccache is FILE:/tmp/krb5cc_602001116
> Feb 23 12:22:46.255015 test-box.example.net cifs.upcall[1700]:
> get_tgt_time: unable to get principal
> Feb 23 12:22:46.255021 test-box.example.net cifs.upcall[1700]:
> handle_krb5_mech: getting service ticket for win2k16-dfs1.example.net
> Feb 23 12:22:46.255024 test-box.example.net cifs.upcall[1700]:
> handle_krb5_mech: using GSS-API
> Feb 23 12:22:46.259295 test-box.example.net cifs.upcall[1700]: GSS-API
> error init_sec_context: Unspecified GSS failure.  Minor code may
> provide more information
> Feb 23 12:22:46.259306 test-box.example.net cifs.upcall[1700]: GSS-API
> error init_sec_context: No Kerberos credentials available (default
> cache: FILE:/tmp/krb5cc_602001116)
> Feb 23 12:22:46.259311 test-box.example.net cifs.upcall[1700]:
> handle_krb5_mech: failed to obtain service ticket via GSS (851968)
> Feb 23 12:22:46.259314 test-box.example.net cifs.upcall[1700]: Unable
> to obtain service ticket
> Feb 23 12:22:46.259323 test-box.example.net cifs.upcall[1700]: Exit
> status 851968
> Feb 23 12:22:46.262827 test-box.example.net kernel: CIFS VFS:
> \\win2k16-dfs1.example.net Send error in SessSetup =3D -126
> Feb 23 12:22:47.398266 test-box.example.net su[1672]:
> pam_unix(su-l:session): session closed for user jeff
> Feb 23 12:22:49.159640 test-box.example.net su[1702]: (to chang) root on =
pts/1
> Feb 23 12:22:49.173264 test-box.example.net su[1702]:
> pam_systemd(su-l:session): Cannot create session: Already running in a
> session or user slice
> Feb 23 12:22:49.173967 test-box.example.net su[1702]:
> pam_unix(su-l:session): session opened for user chang by root(uid=3D0)
> Feb 23 12:22:51.878743 test-box.example.net cifs.upcall[1729]: key
> description: cifs.spnego;0;0;39010000;ver=3D0x2;host=3Dwin2k16-dfs1.examp=
le.net;ip4=3D192.168.124.132;sec=3Dkrb5;uid=3D0x23e1cee3;creduid=3D0x23e1ce=
e3;pid=3D0x6c0
> Feb 23 12:22:51.878765 test-box.example.net cifs.upcall[1729]: ver=3D2
> Feb 23 12:22:51.878769 test-box.example.net cifs.upcall[1729]:
> host=3Dwin2k16-dfs1.example.net
> Feb 23 12:22:51.878773 test-box.example.net cifs.upcall[1729]:
> ip=3D192.168.124.132
> Feb 23 12:22:51.878776 test-box.example.net cifs.upcall[1729]: sec=3D1
> Feb 23 12:22:51.878780 test-box.example.net cifs.upcall[1729]: uid=3D6020=
01123
> Feb 23 12:22:51.878783 test-box.example.net cifs.upcall[1729]: creduid=3D=
602001123
> Feb 23 12:22:51.878786 test-box.example.net cifs.upcall[1729]: pid=3D1728
> Feb 23 12:22:51.879060 test-box.example.net cifs.upcall[1729]:
> get_cachename_from_process_env: pathname=3D/proc/1728/environ
> Feb 23 12:22:51.879799 test-box.example.net cifs.upcall[1729]:
> get_existing_cc: default ccache is FILE:/tmp/krb5cc_602001123
> Feb 23 12:22:51.879819 test-box.example.net cifs.upcall[1729]:
> get_tgt_time: unable to get principal
> Feb 23 12:22:51.879824 test-box.example.net cifs.upcall[1729]:
> handle_krb5_mech: getting service ticket for win2k16-dfs1.example.net
> Feb 23 12:22:51.879827 test-box.example.net cifs.upcall[1729]:
> handle_krb5_mech: using GSS-API
> Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]:
> [2021/02/23 17:22:51]: Client [2021/02/23 17:22:51]:
> (/usr/sbin/cifs.upcall) [2021/02/23 17:22:51]:  connected (fd =3D
> 14)[2021/02/23 17:22:51]:  (pid =3D 1729) (uid =3D 602001123) (gid =3D
> 602000513)[2021/02/23 17:22:51]:  (context =3D
> system_u:system_r:kernel_t:s0)[>
> Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]: [CID
> 14][2021/02/23 17:22:51]: Connection matched service cifs
> Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]: [CID
> 14][2021/02/23 17:22:51]: gp_rpc_execute: executing 6
> (GSSX_ACQUIRE_CRED) for service "cifs", euid: 602001123,socket:
> /var/lib/gssproxy/cifs.sock
> Feb 23 12:22:51.886573 test-box.example.net gssproxy[1000]:
> GSSX_ARG_ACQUIRE_CRED( call_ctx: { "" [  ] } input_cred_handle: <Null>
> add_cred: 0 desired_name: <Null> time_req: 0 desired_mechs: { }
> cred_usage: INITIATE initiator_time_req: 0 acceptor_time_req: 0 )
> Feb 23 12:22:52.346639 test-box.example.net gssproxy[1000]:
> GSSX_RES_ACQUIRE_CRED( status: { 0 { 1 2 840 113554 1 2 2 } 0 "" "" [
> ] } output_cred_handle: { "chang@EXAMPLE.NET" [ { "chang@EXAMPLE.NET"
> { 1 2 840 113554 1 2 2 } INITIATE 36000 0 } ] [ K.....T.....pJv.... ]
> 0 } )
> Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]: [CID
> 14][2021/02/23 17:22:52]: Connection matched service cifs
> Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]: [CID
> 14][2021/02/23 17:22:52]: gp_rpc_execute: executing 8
> (GSSX_INIT_SEC_CONTEXT) for service "cifs", euid: 602001123,socket:
> /var/lib/gssproxy/cifs.sock
> Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]:
> GSSX_ARG_INIT_SEC_CONTEXT( call_ctx: { "" [  ] } context_handle:
> <Null> cred_handle: { "chang@EXAMPLE.NET" [ { "chang@EXAMPLE.NET" { 1
> 2 840 113554 1 2 2 } INITIATE 36000 0 } ] [ K.....T.....pJv.... ] 0 }
> target_name: "cifs@win2k16-dfs1.example.net" mech>
> Feb 23 12:22:52.348086 test-box.example.net gssproxy[1000]: [CID
> 14][2021/02/23 17:22:52]: Credentials allowed by configuration
> Feb 23 12:22:52.357103 test-box.example.net gssproxy[1000]:
> GSSX_RES_INIT_SEC_CONTEXT( status: { 0 { 1 2 840 113554 1 2 2 } 0 ""
> "" [  ] } context_handle: { [ ......H............ ] [  ] 0 { 1 2 840
> 113554 1 2 2 } "chang@EXAMPLE.NET"
> "cifs/win2k16-dfs1.example.net@EXAMPLE.NET" 36000 432 1 1 }
> output_token: [ .....>
> Feb 23 12:22:52.357419 test-box.example.net cifs.upcall[1729]: Exit statu=
s 0
>
>
> Ultimately a helper-script packaged with cifs-utils or a separate
> package entirely could be responsible for adding the file under
> /etc/gssproxy and the drop-in file for systemd. The helper script
> could take a series of users/groups as arguments that would limit
> access to the socket file or there could be a separate config file
> that is read from to determine if access to the cifs.sock socket
> should be limited.
>
>
> On Fri, Feb 19, 2021 at 12:38 PM Simo Sorce <simo@redhat.com> wrote:
> >
> > On Fri, 2021-02-19 at 03:30 -0800, Shyam Prasad N wrote:
> > > Hi Simo,
> > >
> > > > Finally the GSS-Proxy mechanism is namespace compatible, so you als=
o
> > > > get the ability to define different auth daemons per different
> > > > containers, no need to invent new mechanisms for that or change yet
> > > > again protocols/userspace to obtain container capabilities.
> > >
> > > Could you please point me to the documentation for doing this?
> >
> > I do not know if the kernel documents this, but the way gssproxy works
> > is that when you start the daemon it pokes at the kernel to let it know
> > the socket is available. So then the kernel opens the socket in the
> > namespace the proxy is running into (detected from the poking
> > operation, which is a write in a proc file).
> >
> > HTH,
> > Simo.
> >
> > >
> > > Regards,
> > > Shyam
> > >
> > > On Thu, Dec 17, 2020 at 5:41 AM Simo Sorce <simo@redhat.com> wrote:
> > > > Hi Steve,
> > > >
> > > > GSSAPI and krb5 as implemented in system krb5 libraries exists from
> > > > longer than Samba has implemented those capabilities, I do not thin=
k it
> > > > make sense to reason along those lines.
> > > >
> > > > GSS-Proxy has been built with a protocol to talk from the kernel th=
at
> > > > resolved a number of issues for knfsd (eg big packet sizes when a M=
S-
> > > > PAC is present).
> > > >
> > > > And Samba uses internally exactly the same krb5 mechanism as it def=
ers
> > > > to the kerberos libraries as well.
> > > >
> > > > Additionally GSS-Proxy can be very easily extended to also do NTLMS=
SP
> > > > using the same interface as I have built the gssntlmssp long ago fr=
om
> > > > the MS spec, and is probably the most correct NTLMSSP implementatio=
n
> > > > you can find around.
> > > >
> > > > Gssntlmssp also has a Winbind backend so you get automaticaly acces=
s to
> > > > whatever cached credentials Winbindd has for users as a bonus (alth=
ough
> > > > the integration can be improved there), yet you *can* use it w/o
> > > > Winbindd just fine providing a credential file (smbpasswd format
> > > > compatible).
> > > >
> > > > GSS-Proxy is already integrated in distributions because it is used=
 by
> > > > knfsd, and can be as easily used by cifsd, and you *should* really =
use
> > > > it there, so we can have a single, consistent, maintained, mechanis=
m
> > > > for server side GSS authentication, and not have to repeat and rein=
vent
> > > > kernel to userspace mechanisms.
> > > >
> > > > And if you add it for cifsd you have yet another reason to do it fo=
r
> > > > cifs.ko as well.
> > > >
> > > > Finally the GSS-Proxy mechanism is namespace compatible, so you als=
o
> > > > get the ability to define different auth daemons per different
> > > > containers, no need to invent new mechanisms for that or change yet
> > > > again protocols/userspace to obtain container capabilities.
> > > >
> > > > For the client we'll need to add some XDR parsing functions in kern=
el,
> > > > they were omitted from my original patches because there was no cli=
ent
> > > > side kernel consumer back then, but it i an easy, mechanical change=
.
> > > >
> > > > HTH,
> > > > Simo.
> > > >
> > > > On Wed, 2020-12-16 at 16:43 -0600, Steve French wrote:
> > > > > generally I would feel more comfortable using something (library =
or
> > > > > utility) in Samba (if needed) for additional SPNEGO support if
> > > > > something is missing (in what the kernel drivers are doing to
> > > > > encapsulate Active Directory or Samba AD krb5 tickets in SPNEGO) =
as
> > > > > Samba is better maintained/tested etc. than most components.  Is =
there
> > > > > something in Samba that could be used here instead of having a
> > > > > dependency on another project - Samba has been doing Kerberos/SPN=
EGO
> > > > > longer than most ...?   There are probably others (jra, Metze etc=
.)
> > > > > that have would know more about gssproxy vs. Samba equivalents th=
ough
> > > > > and would defer to them ...
> > > > >
> > > > > On Wed, Dec 16, 2020 at 8:33 AM Simo Sorce <simo@redhat.com> wrot=
e:
> > > > > > Hi Michael,
> > > > > > as you say the best course of action would be for cifs.ko to mo=
ve to
> > > > > > use the RPC interface we defined for knfsd (with any extensions=
 that
> > > > > > may  be needed), and we had discussions in the past with cifs u=
pstream
> > > > > > developers about it. But nothing really materialized.
> > > > > >
> > > > > > If something is needed in the short term, I thjink the quickest=
 course
> > > > > > of action is indeed to change the userspace helper to use gssap=
i
> > > > > > function calls, so that they can be intercepted like we do for =
rpc.gssd
> > > > > > (nfs client's userspace helper).
> > > > > >
> > > > > > Unfortunately I do not have the cycles to work on that myself a=
t this
> > > > > > time :-(
> > > > > >
> > > > > > HTH,
> > > > > > Simo.
> > > > > >
> > > > > > On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael wrote:
> > > > > > > Hello,
> > > > > > >
> > > > > > > I have a use-case for authentication of Linux cifs client mou=
nts without the user being present (e.g. from batch jobs) using gssproxy's =
impersonation feature with Kerberos Constrained Delegation similar to how i=
t can be done for NFS[1].
> > > > > > >
> > > > > > > My understanding is that currently neither the Linux cifs ker=
nel client nor cifs-utils userland tools support acquiring credentials usin=
g gssproxy. The former uses a custom upcall interface to talk to cifs.spneg=
o from cifs-utils. The latter then goes looking for Kerberos ticket caches =
using libkrb5 functions, not GSSAPI, which prevents gssproxy from interacti=
ng with it.[2]
> > > > > > >
> > > > > > > From what I understand, the preferred method would be to swit=
ch the Linux kernel client upcall to the RPC protocol defined by gssproxy[3=
] (as has been done for the Linux kernel NFS server already replacing rpc.s=
vcgssd[4]). The kernel could then, at least optionally, talk to gssproxy di=
rectly to try and obtain credentials.
> > > > > > >
> > > > > > > Failing that, cifs-utils' cifs.spnego could be switched to GS=
SAPI so that gssproxy's interposer plugin could intercept GSSAPI calls and =
provide them with the required credentials (similar to the NFS client rpc.g=
ssd[5]).
> > > > > > >
> > > > > > > Assuming my understanding is correct so far:
> > > > > > >
> > > > > > > Is anyone doing any work on this and could use some help (tes=
ting, coding)?
> > > > > > > What would be expected complexity and possible roadblocks whe=
n trying to make a start at implementing this?
> > > > > > > Or is the idea moot due to some constraint or recent developm=
ent I'm not aware of?
> > > > > > >
> > > > > > > I have found a recent discussion of the topic on linux-cifs[6=
] which provided no definite answer though.
> > > > > > >
> > > > > > > As a crude attempt at an explicit userspace workaround I trie=
d but failed to trick smbclient into initialising a ticket cache using gssp=
roxy for cifs.spnego to find later on.
> > > > > > > Is this something that could be implemented without too much =
redundant effort (or should already work, perhaps using a different tool)?
> > > > > > >
> > > > > > > [1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#=
user-impersonation-via-constrained-delegation
> > > > > > > [2] https://pagure.io/gssproxy/issue/56
> > > > > > > [3] https://github.com/gssapi/gssproxy/blob/main/docs/Protoco=
lDocumentation.md
> > > > > > > [4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#=
nfs-server
> > > > > > > [5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#=
nfs-client
> > > > > > > [6] https://www.spinics.net/lists/linux-cifs/msg20182.html
> > > > > > > --
> > > > > > > Thanks,
> > > > > > > Michael
> > > > > > > _______________________________________________
> > > > > > > gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> > > > > > > To unsubscribe send an email to gss-proxy-leave@lists.fedorah=
osted.org
> > > > > > > Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/=
project/code-of-conduct/
> > > > > > > List Guidelines: https://fedoraproject.org/wiki/Mailing_list_=
guidelines
> > > > > > > List Archives: https://lists.fedorahosted.org/archives/list/g=
ss-proxy@lists.fedorahosted.org
> > > > > >
> > > > > > --
> > > > > > Simo Sorce
> > > > > > RHEL Crypto Team
> > > > > > Red Hat, Inc
> > > > > >
> > > > > >
> > > > > >
> > > > > >
> > > >
> > > > --
> > > > Simo Sorce
> > > > RHEL Crypto Team
> > > > Red Hat, Inc
> > > >
> > > >
> > > >
> > > >
> > >
> > >
> >
> > --
> > Simo Sorce
> > RHEL Crypto Team
> > Red Hat, Inc
> >
> >
> >
> >
>
