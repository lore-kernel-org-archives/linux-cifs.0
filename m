Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F0C8C433DB
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 11:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C149C23125
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 11:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbhAGLF4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 06:05:56 -0500
Received: from smtppost.atos.net ([193.56.114.177]:11258 "EHLO
        smarthost2.atos.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725974AbhAGLFz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jan 2021 06:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=atos.net; i=@atos.net; q=dns/txt; s=mail;
  t=1610017551; x=1641553551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=H6wrSKh+lCGxYVciChj+dFrYm3FI7w/0oz8shxslIiE=;
  b=4MHSezaJDPR84JogjMs+4//07tCmf1vfS15eyKQja1+c2w49yNYk9NpK
   EmyumBqdkVpAHOCjhCXJ0DX21mMJmde+rCe+SpCvZ+XbrUPgCkWrgc3Ki
   Nfc7CI/t6oJKGxinNK+vngaM13pGX3jnoKfu4atyN9EuPbBiRbkdUMnQn
   Y=;
IronPort-SDR: 58A6NqUUVFjPg362oJZvE7Rjd6Bk/SzuOLsQT+mOTEXPNQoBjam0xmZxh3nSy15DI5FvhsrwJr
 9vsGBY4CSrWDl4V2eKCG5nc441Ftwff/1ofYHM6QWAAuIAtpo+ssp/aqj3q6Nu+z/k1KzZHnXF
 LI8emCKMK2t8TFgCIvT53h7WB8O8naL/pESSN3fXxaAq2miMby1ReQ6EnnRGLN8dFnirzkK0iH
 zLEyFVW87balU4ZpBd105nyFcjVEuHdZ90p+H1FQU9zSAZtUXOWbaRJJDphXf/GKSy1sU/W7Nn
 y8BktzRYzNfbkBXuxKvpd5vG
X-IronPort-AV: E=Sophos;i="5.79,329,1602540000"; 
   d="scan'208,223";a="145698042"
X-MGA-submission: =?us-ascii?q?MDFeT7iOrSHZ3ocUftkxz5AUry3LOmbS56G6+3?=
 =?us-ascii?q?F45s5lBDe1HK1s1tiWGkDhTH8ExnTcB5oVCVDPLuB8dOVumWZ9XBXS90?=
 =?us-ascii?q?/Eut6KOhRnoBmL1SOzkaVcb+Y78i9ukskSfq+rGODPmOsFVK9MSeZsXk?=
 =?us-ascii?q?mp?=
Received: from unknown (HELO GITEXCPRDMB13.ww931.my-it-solutions.net) ([10.89.28.143])
  by smarthost2.atos.net with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2021 12:04:29 +0100
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net (10.89.28.144) by
 GITEXCPRDMB13.ww931.my-it-solutions.net (10.89.28.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2044.4; Thu, 7 Jan 2021 12:04:27 +0100
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net ([10.89.28.144]) by
 GITEXCPRDMB14.ww931.my-it-solutions.net ([10.89.28.144]) with mapi id
 15.01.2044.004; Thu, 7 Jan 2021 12:04:27 +0100
From:   "Weiser, Michael" <michael.weiser@atos.net>
To:     Steve French <smfrench@gmail.com>, Simo Sorce <simo@redhat.com>
CC:     "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "The GSS-Proxy developers and users mailing list" 
        <gss-proxy@lists.fedorahosted.org>
Subject: Re: [gssproxy] Re: cifs-utils, Linux cifs kernel client and gssproxy
Thread-Topic: [gssproxy] Re: cifs-utils, Linux cifs kernel client and gssproxy
Thread-Index: AQHW0tgPe397r8v2v0y1SGaypM9pOan5ueIAgCJKLuE=
Date:   Thu, 7 Jan 2021 11:04:27 +0000
Message-ID: <e562d3fb430e4c87b0700a70267ef930@atos.net>
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net>,<04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
In-Reply-To: <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [160.92.209.239]
Content-Type: multipart/mixed;
        boundary="_003_e562d3fb430e4c87b0700a70267ef930atosnet_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--_003_e562d3fb430e4c87b0700a70267ef930atosnet_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Simo,
Hello Steve,

> If something is needed in the short term, I thjink the quickest course
> of action is indeed to change the userspace helper to use gssapi
> function calls, so that they can be intercepted like we do for rpc.gssd
> (nfs client's userspace helper).

To get the ball rolling and give people (including myself and client) somet=
hing to play with I went that route and extended cifs.upcall to fall back t=
o GSS-API if no ticket cache nor keytab can be found for the user. An unpol=
ished PoC patch is attached. (Sorry, for not putting it inline, have to roc=
k the groupware at work. I will try to sort that once we've agreed this is =
the/a way to go.)

With that patch applied,  I can do a multiuser cifs mount using the system =
keytab and machine identity as usual and then have users access the mount u=
sing impersonated credentials from gssproxy. Quick demo:

[root@fedora33 ~]# umount /mnt
[root@fedora33 ~]# mount -o sec=3Dkrb5,multiuser,user=3DFEDORA33\$ //dc/sha=
re /mnt
[root@fedora33 ~]# ls -la /mnt
total 0
drwxr-xr-x.  2 root root   0 Jan  7 10:20 .
dr-xr-xr-x. 18 root root 238 Jan  6 13:59 ..
-rwxr-xr-x.  1 root root   0 Jan  5 17:02 bar
[root@fedora33 ~]# klist
klist: Credentials cache keyring 'persistent:0:krb_ccache_WZh7W8n' not foun=
d
[root@fedora33 ~]#

[adsuser@fedora33 ~]$ kdestroy
[adsuser@fedora33 ~]$ echo test > /mnt/test
[adsuser@fedora33 ~]$ cat /mnt/test
test
[adsuser@fedora33 ~]$ klist
klist: Credentials cache keyring 'persistent:1618201110:krb_ccache_SrGqT3F'=
 not found
[adsuser@fedora33 ~]$

Server-side permissions are enforced:

[m@fedora33 ~]$ cat /mnt/test
test
[m@fedora33 ~]$ echo mytest > /mnt/test
-bash: /mnt/test: Permission denied
[m@fedora33 ~]$ klist
klist: Credentials cache keyring 'persistent:1000:1000' not found
[m@fedora33 ~]$

The gssproxy config for this configures a cifs-specific socket and enables =
impersonation for any user id:

[root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
[service/cifs]
mechs =3D krb5
socket =3D /var/lib/gssproxy/cifs.sock
cred_store =3D keytab:/etc/krb5.keytab
cred_usage =3D initiate
euid =3D 0
impersonate =3D yes
allow_any_uid =3D yes

And request-key config for cifs.spnego enables use of gssproxy and the serv=
ice-specific socket through environment variables:

[root@fedora33 ~]# cat /etc/request-key.d/cifs.spnego.conf
create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes GSSPROXY_SOCKE=
T=3D/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.upcall %k

(I see that nfs-utils' gssd does the same by setting the variables itself b=
ased on command line options. That could easily be done here as well.)
=20
User FEDORA33$ (the computer object) needs to be enabled for delegation to =
service cifs. I've tested with a Fedora 33 client and Windows 2016 Active D=
irectory server.

The patch is against current cifs-utils HEAD. It is lacking all the autocon=
f trimmings and intentionally forgoes reindents of existing code for clarit=
y of what's being touched.

What do you think?

> Unfortunately I do not have the cycles to work on that myself at this
> time :-(

I have a client in very tangible need of this functionality who is a RedHat=
 customer. Would it be helpful if they were to open a case with Redhat on t=
his?

As an extension the above (but not to distract from the focus of getting so=
mething to work at all first):

I rather accidentally also played around with delegating retrieval of the m=
ount credentials into gssproxy as well (due to not realising that username=
=3DFEDORA33$ would just activate the keytab codepath in cifs.upcall).

This can be done by leaving out the username from the mount command, markin=
g euid 0 as trusted for access to the keytab in gssproxy and adding a fallb=
ack principal to the gssproxy config (because cifs.upcall in this case does=
 not submit a desired name for the credential):

[root@fedora33 ~]# mount -o sec=3Dkrb5,multiuser //dc/share /mnt
[root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
[service/cifs]
mechs =3D krb5
socket =3D /var/lib/gssproxy/cifs.sock
cred_store =3D keytab:/etc/krb5.keytab
cred_usage =3D initiate
euid =3D 0
trusted =3D yes
impersonate =3D yes
krb5_principal =3D cifs-mount
allow_any_uid =3D yes

While this works, it requires a separate user who would then carefully need=
 to be kept out of any sensitive file access groups.

When trying to use the machine identity FEDORA33$ instead, I ran into a pec=
uliar error from the AD KDC:

[root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
[service/cifs]
mechs =3D krb5
socket =3D /var/lib/gssproxy/cifs.sock
cred_store =3D keytab:/etc/krb5.keytab
cred_usage =3D initiate
euid =3D 0
trusted =3D yes
impersonate =3D yes
krb5_principal =3D FEDORA33$
allow_any_uid =3D yes
[root@fedora33 ~]# gssproxy -i -d &
[2] 3814
[root@fedora33 ~]# [2021/01/07 10:01:10]: Debug Enabled (level: 1)
[2021/01/07 10:01:10]: Service: nfs-server, Keytab: /etc/krb5.keytab, Encty=
pe: 17
[2021/01/07 10:01:10]: Service: cifs, Keytab: /etc/krb5.keytab, Enctype: 17
[2021/01/07 10:01:10]: Service: nfs-client, Keytab: /etc/krb5.keytab, Encty=
pe: 17
[2021/01/07 10:01:10]: Client [2021/01/07 10:01:10]: (/usr/sbin/gssproxy) [=
2021/01/07 10:01:10]:  connected (fd =3D 11)[2021/01/07 10:01:10]:  (pid =
=3D 3814) (uid =3D 0) (gid =3D 0)[2021/01/07 10:01:10]:  (context =3D syste=
m_u:system_r:kernel_t:s0)[2021/01/07 10:01:10]:

[root@fedora33 ~]# mount -o sec=3Dkrb5,multiuser //dc/share /mnt
[2021/01/07 10:01:13]: Client [2021/01/07 10:01:13]: (/usr/sbin/cifs.upcall=
) [2021/01/07 10:01:13]:  connected (fd =3D 12)[2021/01/07 10:01:13]:  (pid=
 =3D 3824) (uid =3D 0) (gid =3D 0)[2021/01/07 10:01:13]:  (context =3D syst=
em_u:system_r:kernel_t:s0)[2021/01/07 10:01:13]:
[CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 6 (GSSX_ACQUIRE_CR=
ED) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure.  M=
inor code may provide more information, KDC has no support for padata type
[CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 8 (GSSX_INIT_SEC_C=
ONTEXT) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure.  M=
inor code may provide more information, KDC has no support for padata type
[CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 6 (GSSX_ACQUIRE_CR=
ED) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure.  M=
inor code may provide more information, KDC has no support for padata type
[CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 8 (GSSX_INIT_SEC_C=
ONTEXT) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure.  M=
inor code may provide more information, KDC has no support for padata type
mount error(126): Required key not available
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log=
 messages (dmesg)

With more debugging it appears that gssproxy tries to impersonate user FEDO=
RA33$ with a credential which is also for FEDORA33$. After further testing =
it seems this is generally not allowed or just not working due to never bei=
ng tested because it is unnecessary: If we can acquire a impersonation cred=
ential for that identity we should also be able to get the actual access cr=
edential as well.

From looking at the nfs-utils gssd code it appears the only reason it hasn'=
t run into this case yet is because it handles the machine credentials itse=
lf using krb5 functions.

The second attached patch against current gssproxy HEAD adds that distincti=
on and makes this case work as an optional extension with fallback into the=
 default codepath on error.

Does that make sense?
Is it sane, security wise, do you think?
--=20
Thanks,
Michael
________________________________________
From: Simo Sorce <simo@redhat.com>
Sent: 16 December 2020 15:31:40
To: The GSS-Proxy developers and users mailing list; linux-cifs@vger.kernel=
.org
Cc: samba-technical@lists.samba.org
Subject: [gssproxy] Re: cifs-utils, Linux cifs kernel client and gssproxy

Caution! External email. Do not open attachments or click links, unless thi=
s email comes from a known sender and you know the content is safe.

Hi Michael,
as you say the best course of action would be for cifs.ko to move to
use the RPC interface we defined for knfsd (with any extensions that
may  be needed), and we had discussions in the past with cifs upstream
developers about it. But nothing really materialized.

If something is needed in the short term, I thjink the quickest course
of action is indeed to change the userspace helper to use gssapi
function calls, so that they can be intercepted like we do for rpc.gssd
(nfs client's userspace helper).

Unfortunately I do not have the cycles to work on that myself at this
time :-(

HTH,
Simo.

On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael wrote:
> Hello,
>
> I have a use-case for authentication of Linux cifs client mounts without =
the user being present (e.g. from batch jobs) using gssproxy's impersonatio=
n feature with Kerberos Constrained Delegation similar to how it can be don=
e for NFS[1].
>
> My understanding is that currently neither the Linux cifs kernel client n=
or cifs-utils userland tools support acquiring credentials using gssproxy. =
The former uses a custom upcall interface to talk to cifs.spnego from cifs-=
utils. The latter then goes looking for Kerberos ticket caches using libkrb=
5 functions, not GSSAPI, which prevents gssproxy from interacting with it.[=
2]
>
> From what I understand, the preferred method would be to switch the Linux=
 kernel client upcall to the RPC protocol defined by gssproxy[3] (as has be=
en done for the Linux kernel NFS server already replacing rpc.svcgssd[4]). =
The kernel could then, at least optionally, talk to gssproxy directly to tr=
y and obtain credentials.
>
> Failing that, cifs-utils' cifs.spnego could be switched to GSSAPI so that=
 gssproxy's interposer plugin could intercept GSSAPI calls and provide them=
 with the required credentials (similar to the NFS client rpc.gssd[5]).
>
> Assuming my understanding is correct so far:
>
> Is anyone doing any work on this and could use some help (testing, coding=
)?
> What would be expected complexity and possible roadblocks when trying to =
make a start at implementing this?
> Or is the idea moot due to some constraint or recent development I'm not =
aware of?
>
> I have found a recent discussion of the topic on linux-cifs[6] which prov=
ided no definite answer though.
>
> As a crude attempt at an explicit userspace workaround I tried but failed=
 to trick smbclient into initialising a ticket cache using gssproxy for cif=
s.spnego to find later on.
> Is this something that could be implemented without too much redundant ef=
fort (or should already work, perhaps using a different tool)?
>
> [1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#user-imperso=
nation-via-constrained-delegation
> [2] https://pagure.io/gssproxy/issue/56
> [3] https://github.com/gssapi/gssproxy/blob/main/docs/ProtocolDocumentati=
on.md
> [4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-server
> [5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-client
> [6] https://www.spinics.net/lists/linux-cifs/msg20182.html
> --
> Thanks,
> Michael
> _______________________________________________
> gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.org
> Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/project/code=
-of-conduct/
> List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
> List Archives: https://lists.fedorahosted.org/archives/list/gss-proxy@lis=
ts.fedorahosted.org

--
Simo Sorce
RHEL Crypto Team
Red Hat, Inc



_______________________________________________
gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.org
Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/project/code-o=
f-conduct/
List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
List Archives: https://lists.fedorahosted.org/archives/list/gss-proxy@lists=
.fedorahosted.org

--_003_e562d3fb430e4c87b0700a70267ef930atosnet_
Content-Type: text/x-patch; name="0001-GSS-API-PoC.patch"
Content-Description: 0001-GSS-API-PoC.patch
Content-Disposition: attachment; filename="0001-GSS-API-PoC.patch"; size=7469;
	creation-date="Thu, 07 Jan 2021 10:25:00 GMT";
	modification-date="Thu, 07 Jan 2021 10:25:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2MWU5ZWQ5YjgxMTU3M2FkMDJmNDA4NTk3OTkyNWEzZDJiMTY0NzYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIFdlaXNlciA8bWljaGFlbC53ZWlzZXJAYXRvcy5u
ZXQ+CkRhdGU6IFR1ZSwgNSBKYW4gMjAyMSAxNzowODozMCArMDEwMApTdWJqZWN0OiBbUEFUQ0hd
IEdTUy1BUEkgUG9DCgpQb0MgdG8gdGVzdCBvdXQgZ3NzcHJveHkgdXNhZ2UgdGhyb3VnaCBHU1Mt
QVBJLiBJZiBubyB1c2VhYmxlIHRpY2tldCBjYWNoZSBvcgprZXl0YWIgY2FuIGJlIGZvdW5kLCBm
YWxsIG9uIHRocm91Z2ggaW50byBjcmVkZW50aWFsIGhhbmRsaW5nIGFueXdheSBidXQgdGhlbgpk
aXZlcnQgaW50byBHU1Mgcm91dGluZXMuIElmIG5vIGdzc3Byb3h5IGlzIGF2YWlsYWJsZSB0aGlz
IHdpbGwgc3RpbGwgZXJyb3Igb3V0CnNpbGVudGx5IGJlY2F1c2Ugbm8gdGlja2V0IGNhY2hlIGlz
IGF2YWlsYWJsZS4gV2l0aCBnc3Nwcm94eSBlbmFibGVkLApjcmVkZW50aWFscyBjYW4gYmUgcmV0
cmlldmVkIGZyb20gdGhlcmUgYW5kIGFsbG93IHVuYXR0ZW5kZWQgYWNjZXNzIHRvIHNoYXJlcwpl
LmcuIGZyb20gYmF0Y2ggam9icy4KClNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgV2Vpc2VyIDxtaWNo
YWVsLndlaXNlckBhdG9zLm5ldD4KLS0tCiBNYWtlZmlsZS5hbSAgIHwgICAyICstCiBjaWZzLnVw
Y2FsbC5jIHwgMTQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDE0MSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9NYWtlZmlsZS5hbSBiL01ha2VmaWxlLmFtCmluZGV4IDg0ZGQxMTku
LjM4YmFiYjMgMTAwNjQ0Ci0tLSBhL01ha2VmaWxlLmFtCisrKyBiL01ha2VmaWxlLmFtCkBAIC0z
MSw3ICszMSw3IEBAIHNiaW5fUFJPR1JBTVMgPQogaWYgQ09ORklHX0NJRlNVUENBTEwKIHNiaW5f
UFJPR1JBTVMgKz0gY2lmcy51cGNhbGwKIGNpZnNfdXBjYWxsX1NPVVJDRVMgPSBjaWZzLnVwY2Fs
bC5jIGRhdGFfYmxvYi5jIGFzbjEuYyBzcG5lZ28uYwotY2lmc191cGNhbGxfTERBREQgPSAtbHRh
bGxvYyAtbGtleXV0aWxzICQoS1JCNV9MREFERCkgJChDQVBOR19MREFERCkKK2NpZnNfdXBjYWxs
X0xEQUREID0gLWx0YWxsb2MgLWxrZXl1dGlscyAtbGdzc2FwaV9rcmI1ICQoS1JCNV9MREFERCkg
JChDQVBOR19MREFERCkKIHJzdF9tYW5fcGFnZXMgKz0gY2lmcy51cGNhbGwuOAogIwogIyBGaXgg
dGhlIHBhdGhuYW1lcyBpbiBtYW5wYWdlcy4gVG8gcHJldmVudCBAbGFiZWxAIGJlaW5nIHJlcGxh
Y2VkIGJ5IG00LCB3ZQpkaWZmIC0tZ2l0IGEvY2lmcy51cGNhbGwuYyBiL2NpZnMudXBjYWxsLmMK
aW5kZXggNDAwYjQyZC4uMWE0YjFhNiAxMDA2NDQKLS0tIGEvY2lmcy51cGNhbGwuYworKysgYi9j
aWZzLnVwY2FsbC5jCkBAIC0zNiw2ICszNiwxMSBAQAogI2VsaWYgZGVmaW5lZChIQVZFX0tSQjVf
SCkKICNpbmNsdWRlIDxrcmI1Lmg+CiAjZW5kaWYKKworI2luY2x1ZGUgPGdzc2FwaS9nc3NhcGlf
Z2VuZXJpYy5oPgorI2luY2x1ZGUgPGdzc2FwaS9nc3NhcGlfa3JiNS5oPgorI2luY2x1ZGUgPHN5
cy91dHNuYW1lLmg+CisKICNpbmNsdWRlIDxzeXNsb2cuaD4KICNpbmNsdWRlIDxkaXJlbnQuaD4K
ICNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KQEAgLTQ1Nyw2ICs0NjIsOCBAQCBpY2ZrX2NsZWFudXA6
CiAJZ290byBvdXQ7CiB9CiAKKyNkZWZpbmUgQ0lGU19TRVJWSUNFX05BTUUgImNpZnMiCisKIHN0
YXRpYyBpbnQKIGNpZnNfa3JiNV9nZXRfcmVxKGNvbnN0IGNoYXIgKmhvc3QsIGtyYjVfY2NhY2hl
IGNjYWNoZSwKIAkJICBEQVRBX0JMT0IgKiBtZWNodG9rZW4sIERBVEFfQkxPQiAqIHNlc3Nfa2V5
KQpAQCAtNDc4LDggKzQ4NSw4IEBAIGNpZnNfa3JiNV9nZXRfcmVxKGNvbnN0IGNoYXIgKmhvc3Qs
IGtyYjVfY2NhY2hlIGNjYWNoZSwKIAkJcmV0dXJuIHJldDsKIAl9CiAKLQlyZXQgPSBrcmI1X3Nu
YW1lX3RvX3ByaW5jaXBhbChjb250ZXh0LCBob3N0LCAiY2lmcyIsIEtSQjVfTlRfVU5LTk9XTiwK
LQkJCQkJJmluX2NyZWRzLnNlcnZlcik7CisJcmV0ID0ga3JiNV9zbmFtZV90b19wcmluY2lwYWwo
Y29udGV4dCwgaG9zdCwgQ0lGU19TRVJWSUNFX05BTUUsCisJCQkJCUtSQjVfTlRfVU5LTk9XTiwg
JmluX2NyZWRzLnNlcnZlcik7CiAJaWYgKHJldCkgewogCQlzeXNsb2coTE9HX0RFQlVHLCAiJXM6
IHVuYWJsZSB0byBjb252ZXJ0IHNuYW1lIHRvIHByaW5jICglcykuIiwKIAkJICAgICAgIF9fZnVu
Y19fLCBob3N0KTsKQEAgLTU3OCw2ICs1ODUsMTIwIEBAIG91dF9mcmVlX3ByaW5jaXBhbDoKIAly
ZXR1cm4gcmV0OwogfQogCitzdGF0aWMgdm9pZCBjaWZzX2dzc19kaXNwbGF5X3N0YXR1c18xKGNo
YXIgKm0sIE9NX3VpbnQzMiBjb2RlLCBpbnQgdHlwZSkgeworCU9NX3VpbnQzMiBtaW5fc3RhdDsK
Kwlnc3NfYnVmZmVyX2Rlc2MgbXNnOworCU9NX3VpbnQzMiBtc2dfY3R4OworCisJbXNnX2N0eCA9
IDA7CisJd2hpbGUgKDEpIHsKKwkJKHZvaWQpIGdzc19kaXNwbGF5X3N0YXR1cygmbWluX3N0YXQs
IGNvZGUsIHR5cGUsCisJCQkJR1NTX0NfTlVMTF9PSUQsICZtc2dfY3R4LCAmbXNnKTsKKwkJc3lz
bG9nKExPR19ERUJVRywgIkdTUy1BUEkgZXJyb3IgJXM6ICVzXG4iLCBtLCAoY2hhciAqKSBtc2cu
dmFsdWUpOworCQkodm9pZCkgZ3NzX3JlbGVhc2VfYnVmZmVyKCZtaW5fc3RhdCwgJm1zZyk7CisK
KwkJaWYgKCFtc2dfY3R4KQorCQkJYnJlYWs7CisJfQorfQorCit2b2lkIGNpZnNfZ3NzX2Rpc3Bs
YXlfc3RhdHVzKGNoYXIgKm1zZywgT01fdWludDMyIG1hal9zdGF0LCBPTV91aW50MzIgbWluX3N0
YXQpIHsKKwljaWZzX2dzc19kaXNwbGF5X3N0YXR1c18xKG1zZywgbWFqX3N0YXQsIEdTU19DX0dT
U19DT0RFKTsKKwljaWZzX2dzc19kaXNwbGF5X3N0YXR1c18xKG1zZywgbWluX3N0YXQsIEdTU19D
X01FQ0hfQ09ERSk7Cit9CisKK3N0YXRpYyBpbnQKK2NpZnNfZ3NzX2dldF9yZXEoY29uc3QgY2hh
ciAqaG9zdCwgREFUQV9CTE9CICogbWVjaHRva2VuLCBEQVRBX0JMT0IgKiBzZXNzX2tleSkKK3sK
KwlPTV91aW50MzIgbWFqX3N0YXQsIG1pbl9zdGF0OworCWdzc19uYW1lX3QgdGFyZ2V0X25hbWU7
CisJZ3NzX2N0eF9pZF90IGN0eCA9IEdTU19DX05PX0NPTlRFWFQ7CisJZ3NzX2J1ZmZlcl9kZXNj
IG91dHB1dF90b2tlbjsKKwlnc3Nfa3JiNV9sdWNpZF9jb250ZXh0X3YxX3QgKmx1Y2lkX2N0eCA9
IE5VTEw7CisJZ3NzX2tyYjVfbHVjaWRfa2V5X3QgKmtleSA9IE5VTEw7CisKKwlzaXplX3Qgc2Vy
dmljZV9uYW1lX2xlbiA9IHNpemVvZihDSUZTX1NFUlZJQ0VfTkFNRSkgKyAxIC8qIEAgKi8gKwor
CQlzdHJsZW4oaG9zdCkgKyAxOworCWNoYXIgKnNlcnZpY2VfbmFtZSA9IG1hbGxvYyhzZXJ2aWNl
X25hbWVfbGVuKTsKKwlpZiAoIXNlcnZpY2VfbmFtZSkgeworCQlzeXNsb2coTE9HX0RFQlVHLCAi
b3V0IG9mIG1lbW9yeSBhbGxvY2F0aW5nIHNlcnZpY2UgbmFtZSIpOworCQlnb3RvIG91dDsKKwl9
CisKKwlzbnByaW50ZihzZXJ2aWNlX25hbWUsIHNlcnZpY2VfbmFtZV9sZW4sCisJCQkiJXNAJXMi
LCBDSUZTX1NFUlZJQ0VfTkFNRSwgaG9zdCk7CisJZ3NzX2J1ZmZlcl9kZXNjIHRhcmdldF9uYW1l
X2J1ZjsKKwl0YXJnZXRfbmFtZV9idWYudmFsdWUgPSBzZXJ2aWNlX25hbWU7CisJdGFyZ2V0X25h
bWVfYnVmLmxlbmd0aCA9IHNlcnZpY2VfbmFtZV9sZW47CisKKwltYWpfc3RhdCA9IGdzc19pbXBv
cnRfbmFtZSgmbWluX3N0YXQsICZ0YXJnZXRfbmFtZV9idWYsCisJCQkoZ3NzX09JRClnc3NfbnRf
c2VydmljZV9uYW1lLCAmdGFyZ2V0X25hbWUpOworCWZyZWUoc2VydmljZV9uYW1lKTsKKwlpZiAo
R1NTX0VSUk9SKG1hal9zdGF0KSkgeworCQljaWZzX2dzc19kaXNwbGF5X3N0YXR1cygiZ3NzX2lt
cG9ydF9uYW1lIiwgbWFqX3N0YXQsIG1pbl9zdGF0KTsKKwkJZ290byBvdXQ7CisJfQorCisJbWFq
X3N0YXQgPSBnc3NfaW5pdF9zZWNfY29udGV4dCgmbWluX3N0YXQsCisJCQlHU1NfQ19OT19DUkVE
RU5USUFMLAkvKiBjbGFpbWFudF9jcmVkX2hhbmRsZSAqLworCQkJJmN0eCwKKwkJCXRhcmdldF9u
YW1lLAorCQkJZ3NzX21lY2hfa3JiNSwJLyogZm9yY2Uga3JiNSAqLworCQkJMCwJLyogZmxhZ3Mg
Ki8KKwkJCTAsCS8qIHRpbWVfcmVxICovCisJCQlHU1NfQ19OT19DSEFOTkVMX0JJTkRJTkdTLAkv
KiBpbnB1dF9jaGFuX2JpbmRpbmdzICovCisJCQlHU1NfQ19OT19CVUZGRVIsCisJCQlOVUxMLAkv
KiBhY3R1YWwgbWVjaCB0eXBlICovCisJCQkmb3V0cHV0X3Rva2VuLAorCQkJTlVMTCwJLyogcmV0
X2ZsYWdzICovCisJCQlOVUxMKTsJLyogdGltZV9yZWMgKi8KKwlpZiAobWFqX3N0YXQgIT0gR1NT
X1NfQ09NUExFVEUgJiYKKwkJbWFqX3N0YXQgIT0gR1NTX1NfQ09OVElOVUVfTkVFREVEKSB7CisJ
CWNpZnNfZ3NzX2Rpc3BsYXlfc3RhdHVzKCJpbml0X3NlY19jb250ZXh0IiwgbWFqX3N0YXQsIG1p
bl9zdGF0KTsKKwkJZ290byBvdXRfcmVsZWFzZV90YXJnZXRfbmFtZTsKKwl9CisKKwkvKiBhcyBs
dWNrIHdvdWxkIGhhdmUgaXQsIEdTUy1BUEkgaGFuZHMgdXMgdGhlIGZpbmlzaGVkIGFydGljbGUg
Ki8KKwkqbWVjaHRva2VuID0gZGF0YV9ibG9iKG91dHB1dF90b2tlbi52YWx1ZSwgb3V0cHV0X3Rv
a2VuLmxlbmd0aCk7CisKKwltYWpfc3RhdCA9IGdzc19rcmI1X2V4cG9ydF9sdWNpZF9zZWNfY29u
dGV4dCgmbWluX3N0YXQsICZjdHgsIDEsCisJCQkodm9pZCAqKikmbHVjaWRfY3R4KTsKKwlpZiAo
R1NTX0VSUk9SKG1hal9zdGF0KSkgeworCQljaWZzX2dzc19kaXNwbGF5X3N0YXR1cygiZ3NzX2ty
YjVfZXhwb3J0X2x1Y2lkX3NlY19jb250ZXh0IiwKKwkJCQltYWpfc3RhdCwgbWluX3N0YXQpOwor
CQlnb3RvIG91dF9mcmVlX3NlY19jdHg7CisJfQorCisJc3dpdGNoIChsdWNpZF9jdHgtPnByb3Rv
Y29sKSB7CisJY2FzZSAwOgorCQlrZXkgPSAmbHVjaWRfY3R4LT5yZmMxOTY0X2tkLmN0eF9rZXk7
CisJCWJyZWFrOworCisJY2FzZSAxOgorCQlpZiAobHVjaWRfY3R4LT5jZnhfa2QuaGF2ZV9hY2Nl
cHRvcl9zdWJrZXkpIHsKKwkJCWtleSA9ICZsdWNpZF9jdHgtPmNmeF9rZC5hY2NlcHRvcl9zdWJr
ZXk7CisJCX0gZWxzZSB7CisJCQlrZXkgPSAmbHVjaWRfY3R4LT5jZnhfa2QuY3R4X2tleTsKKwkJ
fQorCQlicmVhazsKKwlkZWZhdWx0OgorCQlzeXNsb2coTE9HX0RFQlVHLCAid3JvbmcgbHVjaWQg
Y29udGV4dCBwcm90b2NvbCAlZCIsIGx1Y2lkX2N0eC0+cHJvdG9jb2wpOworCQlnb3RvIG91dF9m
cmVlX2x1Y2lkX2N0eDsKKwl9CisKKwkqc2Vzc19rZXkgPSBkYXRhX2Jsb2Ioa2V5LT5kYXRhLCBr
ZXktPmxlbmd0aCk7CisKK291dF9mcmVlX2x1Y2lkX2N0eDoKKwkodm9pZCkgZ3NzX2tyYjVfZnJl
ZV9sdWNpZF9zZWNfY29udGV4dCgmbWluX3N0YXQsIGx1Y2lkX2N0eCk7CitvdXRfZnJlZV9zZWNf
Y3R4OgorCSh2b2lkKSBnc3NfZGVsZXRlX3NlY19jb250ZXh0KCZtaW5fc3RhdCwgJmN0eCwgR1NT
X0NfTk9fQlVGRkVSKTsKKwkodm9pZCkgZ3NzX3JlbGVhc2VfYnVmZmVyKCZtaW5fc3RhdCwgJm91
dHB1dF90b2tlbik7CitvdXRfcmVsZWFzZV90YXJnZXRfbmFtZToKKwkodm9pZCkgZ3NzX3JlbGVh
c2VfbmFtZSgmbWluX3N0YXQsICZ0YXJnZXRfbmFtZSk7CitvdXQ6CisJcmV0dXJuIEdTU19FUlJP
UihtYWpfc3RhdCk7Cit9CisKIC8qCiAgKiBQcmVwYXJlcyBBUC1SRVEgZGF0YSBmb3IgbWVjaFRv
a2VuIGFuZCBnZXRzIHNlc3Npb24ga2V5CiAgKiBVc2VzIGNyZWRlbnRpYWxzIGZyb20gY2FjaGUu
IEl0IHdpbGwgbm90IGFzayBmb3IgcGFzc3dvcmQKQEAgLTYwMywxMCArNzI0LDI0IEBAIGhhbmRs
ZV9rcmI1X21lY2goY29uc3QgY2hhciAqb2lkLCBjb25zdCBjaGFyICpob3N0LCBEQVRBX0JMT0Ig
KiBzZWNibG9iLAogCQkgREFUQV9CTE9CICogc2Vzc19rZXksIGtyYjVfY2NhY2hlIGNjYWNoZSkK
IHsKIAlpbnQgcmV0dmFsOwotCURBVEFfQkxPQiB0a3QsIHRrdF93cmFwcGVkOworCURBVEFfQkxP
QiB0a3Rfd3JhcHBlZDsKIAogCXN5c2xvZyhMT0dfREVCVUcsICIlczogZ2V0dGluZyBzZXJ2aWNl
IHRpY2tldCBmb3IgJXMiLCBfX2Z1bmNfXywgaG9zdCk7CiAKKwkvKiBmYWxsIGJhY2sgdG8gZ3Nz
YXBpIGlmIHRoZXJlJ3Mgbm8gY3JlZGVudGlhbCBjYWNoZSBvciBubyBUR1QKKwkgKiBzbyB0aGF0
IGdzc3Byb3h5IGNhbiBtYXliZSBoZWxwIG91dCAqLworCWlmICghY2NhY2hlKSB7CisJCXN5c2xv
ZyhMT0dfREVCVUcsICIlczogdXNpbmcgR1NTLUFQSSIsIF9fZnVuY19fKTsKKwkJcmV0dmFsID0g
Y2lmc19nc3NfZ2V0X3JlcShob3N0LCAmdGt0X3dyYXBwZWQsIHNlc3Nfa2V5KTsKKwkJaWYgKHJl
dHZhbCkgeworCQkJc3lzbG9nKExPR19ERUJVRywgIiVzOiBmYWlsZWQgdG8gb2J0YWluIHNlcnZp
Y2UgdGlja2V0IHZpYSBHU1MgKCVkKSIsCisJCQlfX2Z1bmNfXywgcmV0dmFsKTsKKwkJCXJldHVy
biByZXR2YWw7CisJCX0KKwl9IGVsc2UgeworCQlEQVRBX0JMT0IgdGt0OworCQlzeXNsb2coTE9H
X0RFQlVHLCAiJXM6IHVzaW5nIG5hdGl2ZSBrcmI1IiwgX19mdW5jX18pOworCiAJLyogZ2V0IGEg
a2VyYmVyb3MgdGlja2V0IGZvciB0aGUgc2VydmljZSBhbmQgZXh0cmFjdCB0aGUgc2Vzc2lvbiBr
ZXkgKi8KIAlyZXR2YWwgPSBjaWZzX2tyYjVfZ2V0X3JlcShob3N0LCBjY2FjaGUsICZ0a3QsIHNl
c3Nfa2V5KTsKIAlpZiAocmV0dmFsKSB7CkBAIC02MTksMTIgKzc1NCwxMyBAQCBoYW5kbGVfa3Ji
NV9tZWNoKGNvbnN0IGNoYXIgKm9pZCwgY29uc3QgY2hhciAqaG9zdCwgREFUQV9CTE9CICogc2Vj
YmxvYiwKIAogCS8qIHdyYXAgdGhhdCB1cCBpbiBhIG5pY2UgR1NTLUFQSSB3cmFwcGluZyAqLwog
CXRrdF93cmFwcGVkID0gc3BuZWdvX2dlbl9rcmI1X3dyYXAodGt0LCBUT0tfSURfS1JCX0FQX1JF
USk7CisJCWRhdGFfYmxvYl9mcmVlKCZ0a3QpOworCX0KIAogCS8qIGFuZCB3cmFwIHRoYXQgaW4g
YSBzaGlueSBTUE5FR08gd3JhcHBlciAqLwogCSpzZWNibG9iID0gZ2VuX25lZ1Rva2VuSW5pdChv
aWQsIHRrdF93cmFwcGVkKTsKIAogCWRhdGFfYmxvYl9mcmVlKCZ0a3Rfd3JhcHBlZCk7Ci0JZGF0
YV9ibG9iX2ZyZWUoJnRrdCk7CiAJcmV0dXJuIHJldHZhbDsKIH0KIApAQCAtMTEzMiwxMSArMTI2
OCw2IEBAIGludCBtYWluKGNvbnN0IGludCBhcmdjLCBjaGFyICpjb25zdCBhcmd2W10pCiAJaWYg
KGNjYWNoZSA9PSBOVUxMICYmIGFyZy51c2VybmFtZSAhPSBOVUxMKQogCQljY2FjaGUgPSBpbml0
X2NjX2Zyb21fa2V5dGFiKGtleXRhYl9uYW1lLCBhcmcudXNlcm5hbWUpOwogCi0JaWYgKGNjYWNo
ZSA9PSBOVUxMKSB7Ci0JCXJjID0gMTsKLQkJZ290byBvdXQ7Ci0JfQotCiAJaG9zdCA9IGFyZy5o
b3N0bmFtZTsKIAogCS8vIGRvIG1lY2ggc3BlY2lmaWMgYXV0aG9yaXphdGlvbgotLSAKMi4yOS4y
Cgo=

--_003_e562d3fb430e4c87b0700a70267ef930atosnet_
Content-Type: text/x-patch;
	name="0001-Handle-impersonation-of-oneself.patch"
Content-Description: 0001-Handle-impersonation-of-oneself.patch
Content-Disposition: attachment;
	filename="0001-Handle-impersonation-of-oneself.patch"; size=3044;
	creation-date="Thu, 07 Jan 2021 10:25:04 GMT";
	modification-date="Thu, 07 Jan 2021 10:25:04 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyZGI0MzNhOTk5OGRjZWNhN2YyZGZhYzhiMGIxYzhmMDk3YWVkNDg4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaWNoYWVsIFdlaXNlciA8bWljaGFlbC53ZWlzZXJAYXRvcy5u
ZXQ+CkRhdGU6IFRodSwgNyBKYW4gMjAyMSAxMDozNDoxNSArMDEwMApTdWJqZWN0OiBbUEFUQ0hd
IEhhbmRsZSBpbXBlcnNvbmF0aW9uIG9mIG9uZXNlbGYKCldoZW4gdHJ5aW5nIHRvIGltcGVyc29u
YXRlIHRoZSB1c2VyIHdoaWNoIGhhcyBiZWVuIHNlbGVjdGVkIGFzIGltcGVyc29uYXRpb24KY3Jl
ZGVudGlhbCwgYW4gQUQgS0RDIHJldHVybnMgZXJyb3I6CgpHU1NYX1JFU19BQ1FVSVJFX0NSRUQo
IHN0YXR1czogeyA4NTE5NjggeyAxIDIgODQwIDExMzU1NCAxIDIgMiB9IDI1Mjk2Mzg5MjgKIlVu
c3BlY2lmaWVkIEdTUyBmYWlsdXJlLiAgTWlub3IgY29kZSBtYXkgcHJvdmlkZSBtb3JlIGluZm9y
bWF0aW9uIiAiS0RDIGhhcyBubwpzdXBwb3J0IGZvciBwYWRhdGEgdHlwZSIgWyAgXSB9IG91dHB1
dF9jcmVkX2hhbmRsZTogPE51bGw+ICkKCkFwcGFyZW50bHksIHRvIGltcGVyc29uYXRlIG9uZXNl
bGYgaXMgbm90IGFsbG93ZWQuIEFsc28sIGl0IGlzIGxpa2VseSBub3QgZXZlbgpuZWNlc3Nhcnk6
IElmIHdlIGNhbiBnZXQgaW1wZXJzb25hdGlvbiBjcmVkZW50aWFscyBmcm9tIGNyZWRzdG9yZXMs
IHdlIGNhbiBhdApsZWFzdCB0cnkgdG8gc2hvcnQgY2lyY3VpdCBhbmQgZ2V0IGFjdHVhbCB1c2Vy
IGNyZWRlbnRpYWxzIHRoZSBzYW1lIHdheS4KCldpdGggdGhpcyBwYXRjaCBpdCBiZWNvbWVzIHBv
c3NpYmxlIHRvIGRlbGVnYXRlIHRoZSBhY3F1aXNpdGlvbiBvZiBlLmcuIGNpZnMKbW91bnQgY3Jl
ZGVudGlhbHMgZnJvbSBjaWZzLnVwY2FsbCBpbnRvIGdzc3Byb3h5IGFuZCB1c2UgdGhlIGhvc3Qg
aWRlbnRpdHkKKGUuZy4gSE9TVE5BTUUkQFJFQUxNIG9mIEFEKSB3aGlsZSBpdCBpcyBhbHNvIGJl
aW5nIHNlbGVjdGVkIGFzIGltcGVyc29uYXRpb24KY3JlZGVudGlhbCBkdWUgdG8gdGhlIG9yZGVy
IG9mIGtleXMgaW4gdGhlIGtleXRhYi4KClNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgV2Vpc2VyIDxt
aWNoYWVsLndlaXNlckBhdG9zLm5ldD4KLS0tCiBzcmMvZ3BfY3JlZHMuYyB8IDM1ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL3NyYy9ncF9jcmVkcy5jIGIvc3JjL2dwX2NyZWRzLmMKaW5kZXgg
NDI0Y2YzNS4uMTRhYjM2NCAxMDA2NDQKLS0tIGEvc3JjL2dwX2NyZWRzLmMKKysrIGIvc3JjL2dw
X2NyZWRzLmMKQEAgLTY2Nyw2ICs2NjcsNDEgQEAgdWludDMyX3QgZ3BfYWRkX2tyYjVfY3JlZHMo
dWludDMyX3QgKm1pbiwKICAgICAgICAgICAgIGlmIChyZXRfbWFqKSB7CiAgICAgICAgICAgICAg
ICAgZ290byBkb25lOwogICAgICAgICAgICAgfQorCisgICAgICAgICAgICBpZiAocmVxX25hbWUg
IT0gR1NTX0NfTk9fTkFNRSkgeworICAgICAgICAgICAgICAgIGludCBlcXVhbCA9IDA7CisKKyAg
ICAgICAgICAgICAgICByZXRfbWFqID0gZ3NzX2lucXVpcmVfY3JlZCgmcmV0X21pbiwgaW1wZXJz
b25hdG9yX2NyZWQsCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
JnRhcmdldF9uYW1lLCBOVUxMLCBOVUxMLCBOVUxMKTsKKyAgICAgICAgICAgICAgICBpZiAocmV0
X21haikgeworICAgICAgICAgICAgICAgICAgICBnb3RvIGRvbmU7CisgICAgICAgICAgICAgICAg
fQorCisgICAgICAgICAgICAgICAgcmV0X21haiA9IGdzc19jb21wYXJlX25hbWUoJnJldF9taW4s
IHRhcmdldF9uYW1lLAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHJlcV9uYW1lLCAmZXF1YWwpOworICAgICAgICAgICAgICAgIGlmIChyZXRfbWFqKSB7CisgICAg
ICAgICAgICAgICAgICAgIGdvdG8gZG9uZTsKKyAgICAgICAgICAgICAgICB9CisKKyAgICAgICAg
ICAgICAgICAvKiBpZiBpbXBlcnNvbmF0b3IgY3JlZGVudGlhbCByZXRyaWV2YWwgeWllbGRlZCB0
aGUgcmVxdWVzdGVkIGNsaWVudAorICAgICAgICAgICAgICAgICAqIG5hbWUsIHdlIGRvIG5vdCBu
ZWVkIHRvIGltcGVyc29uYXRlLiBBbHNvLCBpbiBBRCBhbiBhdHRlbXB0IHRvCisgICAgICAgICAg
ICAgICAgICogaW1wZXJzb25hdGUgb25lc2VsZiB5aWVsZHMgYW4gZXJyb3IgIktEQyBoYXMgbm8g
c3VwcG9ydCBmb3IgcGFkYXRhCisgICAgICAgICAgICAgICAgICogdHlwZSIgKi8KKyAgICAgICAg
ICAgICAgICBpZiAoZXF1YWwpIHsKKyAgICAgICAgICAgICAgICAgICAgIHJldF9tYWogPSBnc3Nf
YWNxdWlyZV9jcmVkX2Zyb20oJnJldF9taW4sIHJlcV9uYW1lLCBHU1NfQ19JTkRFRklOSVRFLAor
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAmZGVz
aXJlZF9tZWNocywgY3JlZF91c2FnZSwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJmNyZWRfc3RvcmUsICZ1c2VyX2NyZWQsCisgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFjdHVhbF9tZWNocywg
TlVMTCk7CisgICAgICAgICAgICAgICAgICAgICBpZiAoIXJldF9tYWopIHsKKyAgICAgICAgICAg
ICAgICAgICAgICAgICAqb3V0cHV0X2NyZWRfaGFuZGxlID0gdXNlcl9jcmVkOworICAgICAgICAg
ICAgICAgICAgICAgICAgIHVzZXJfY3JlZCA9IEdTU19DX05PX0NSRURFTlRJQUw7CisgICAgICAg
ICAgICAgICAgICAgICAgICAgZ290byBkb25lOworICAgICAgICAgICAgICAgICAgICAgfQorCisg
ICAgICAgICAgICAgICAgICAgICAvKiBmYWxsIG9uIHRocm91Z2gsIGlmIGZhaWxlZCAqLworICAg
ICAgICAgICAgICAgICB9CisgICAgICAgICAgICB9CisKICAgICAgICAgICAgIGlucHV0X2NyZWQg
PSBpbXBlcnNvbmF0b3JfY3JlZDsKICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICBjYXNlIEFD
UV9JTVBOQU1FOgotLSAKMi4yOS4yCgo=

--_003_e562d3fb430e4c87b0700a70267ef930atosnet_--
