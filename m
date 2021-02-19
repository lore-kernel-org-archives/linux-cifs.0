Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E18C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 11:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C01E964E5C
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Feb 2021 11:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBSL2p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Feb 2021 06:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhBSL1q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Feb 2021 06:27:46 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E64C061574
        for <linux-cifs@vger.kernel.org>; Fri, 19 Feb 2021 03:27:05 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id l8so5187867ybe.12
        for <linux-cifs@vger.kernel.org>; Fri, 19 Feb 2021 03:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E0PTur+wLehSfA+x2DPI0/q8bPKlsNFaLCcyfsrYS1Q=;
        b=Mx6bDkFSf7g3vdCwXtVCEfOBeTVZin8ohEPRWi0dL9yiRJQStENwwmbIIUFCoQdiAQ
         UPVbd3DvxSfR7q7P9nn970zkJodrpaTrbqRo2gAEn2wKTnBg2nbHsekQqP8efaYUy144
         u/+w9draj+VdihDTE4U+46sA1W7jopWPLlEo60AJBTRmBDghU1y4pNRD9fijrJWM1Wh/
         SgvX0mXP6X8yeaWwu3KGPULhmFLZKXLCGjZ1cMfP4D4WsCpdsYgjs9abcbajQenrUWV0
         s9QX9EiDv0dkIQk5pdzK+0omi8bKnXCIsodsv6ygFa/zbmgfWyFYFXvveUo2OHZdxXYB
         Bm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E0PTur+wLehSfA+x2DPI0/q8bPKlsNFaLCcyfsrYS1Q=;
        b=jXLaOjQ+DTSfXn/6m8liYcAvYqb0+vIoDhDN8CCz/uailmdfihQ4hwXM7BeRWWYPBW
         Ozshueo7BXLq6tjLMnIPXeyjSSsyCLYNc/34E6D8uFWCgzcRA3nrvDnNH0QnZofWAAkH
         RfVtMecIiWgzRQcfha2XswALARDZImiGpi+rHwG5EtFke+wlnuA+9JaGadOW5K+L4KBb
         6VAs33EWYssxzezO+MoyvYge5srPNRlK+uegCixQ7w8RyW47VXRAmq4PoO5ckkKkJcZM
         4OXOFoXmRCxlkyEuBjwex7/f4f88wp9qfRVsNYHZq/BzGTYLcpb7cDF297k/QFpPy4ad
         nC7w==
X-Gm-Message-State: AOAM531nlAtaRNn4Wvia3On1l9E1zKcZSaoNx/N1yKcQnCv7K4D82nso
        HLS/3iZuGtdRM4fp25Q/4B3novp+AES8JnmMV6MNZxjtHvsx/uzR
X-Google-Smtp-Source: ABdhPJz8P36n/lbEgI2emUzmyS4ynCGqPvrwfVL3ptXJJ3MYdUWY9JTo9XkLN8WJP4KIJev8T2hvpNjeIQRdTPTXfUc=
X-Received: by 2002:a25:83cc:: with SMTP id v12mr13390634ybm.293.1613734024845;
 Fri, 19 Feb 2021 03:27:04 -0800 (PST)
MIME-Version: 1.0
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net> <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
 <e562d3fb430e4c87b0700a70267ef930@atos.net>
In-Reply-To: <e562d3fb430e4c87b0700a70267ef930@atos.net>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 19 Feb 2021 03:26:53 -0800
Message-ID: <CANT5p=rOJO6s7Ro9bQG4DN70m-=Eb4Ax9A+jJe7oBdj9Xm_EYQ@mail.gmail.com>
Subject: Re: [gssproxy] Re: cifs-utils, Linux cifs kernel client and gssproxy
To:     "Weiser, Michael" <michael.weiser@atos.net>
Cc:     Steve French <smfrench@gmail.com>, Simo Sorce <simo@redhat.com>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        The GSS-Proxy developers and users mailing list 
        <gss-proxy@lists.fedorahosted.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Michael,

What happens when credentials are not supplied in keytab files? Is
there a way to supply the credentials from other sources in that case?
The reason why I'm asking this is that this same code can be used by
cifscreds (or a new executable) to perform the authentication, and
collect the krb5 tickets.

Also, in the cifs.upcall changes, you could check for the
GSS_USE_PROXY env variable. In the absence of which, fallback to the
older code. If that is done, it gives the user an option to go for one
option or the other.
Other than that, the changes look fine to me.

Regards,
Shyam

On Thu, Jan 7, 2021 at 3:08 AM Weiser, Michael <michael.weiser@atos.net> wr=
ote:
>
> Hello Simo,
> Hello Steve,
>
> > If something is needed in the short term, I thjink the quickest course
> > of action is indeed to change the userspace helper to use gssapi
> > function calls, so that they can be intercepted like we do for rpc.gssd
> > (nfs client's userspace helper).
>
> To get the ball rolling and give people (including myself and client) som=
ething to play with I went that route and extended cifs.upcall to fall back=
 to GSS-API if no ticket cache nor keytab can be found for the user. An unp=
olished PoC patch is attached. (Sorry, for not putting it inline, have to r=
ock the groupware at work. I will try to sort that once we've agreed this i=
s the/a way to go.)
>
> With that patch applied,  I can do a multiuser cifs mount using the syste=
m keytab and machine identity as usual and then have users access the mount=
 using impersonated credentials from gssproxy. Quick demo:
>
> [root@fedora33 ~]# umount /mnt
> [root@fedora33 ~]# mount -o sec=3Dkrb5,multiuser,user=3DFEDORA33\$ //dc/s=
hare /mnt
> [root@fedora33 ~]# ls -la /mnt
> total 0
> drwxr-xr-x.  2 root root   0 Jan  7 10:20 .
> dr-xr-xr-x. 18 root root 238 Jan  6 13:59 ..
> -rwxr-xr-x.  1 root root   0 Jan  5 17:02 bar
> [root@fedora33 ~]# klist
> klist: Credentials cache keyring 'persistent:0:krb_ccache_WZh7W8n' not fo=
und
> [root@fedora33 ~]#
>
> [adsuser@fedora33 ~]$ kdestroy
> [adsuser@fedora33 ~]$ echo test > /mnt/test
> [adsuser@fedora33 ~]$ cat /mnt/test
> test
> [adsuser@fedora33 ~]$ klist
> klist: Credentials cache keyring 'persistent:1618201110:krb_ccache_SrGqT3=
F' not found
> [adsuser@fedora33 ~]$
>
> Server-side permissions are enforced:
>
> [m@fedora33 ~]$ cat /mnt/test
> test
> [m@fedora33 ~]$ echo mytest > /mnt/test
> -bash: /mnt/test: Permission denied
> [m@fedora33 ~]$ klist
> klist: Credentials cache keyring 'persistent:1000:1000' not found
> [m@fedora33 ~]$
>
> The gssproxy config for this configures a cifs-specific socket and enable=
s impersonation for any user id:
>
> [root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
> [service/cifs]
> mechs =3D krb5
> socket =3D /var/lib/gssproxy/cifs.sock
> cred_store =3D keytab:/etc/krb5.keytab
> cred_usage =3D initiate
> euid =3D 0
> impersonate =3D yes
> allow_any_uid =3D yes
>
> And request-key config for cifs.spnego enables use of gssproxy and the se=
rvice-specific socket through environment variables:
>
> [root@fedora33 ~]# cat /etc/request-key.d/cifs.spnego.conf
> create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=3Dyes GSSPROXY_SOC=
KET=3D/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.upcall %k
>
> (I see that nfs-utils' gssd does the same by setting the variables itself=
 based on command line options. That could easily be done here as well.)
>
> User FEDORA33$ (the computer object) needs to be enabled for delegation t=
o service cifs. I've tested with a Fedora 33 client and Windows 2016 Active=
 Directory server.
>
> The patch is against current cifs-utils HEAD. It is lacking all the autoc=
onf trimmings and intentionally forgoes reindents of existing code for clar=
ity of what's being touched.
>
> What do you think?
>
> > Unfortunately I do not have the cycles to work on that myself at this
> > time :-(
>
> I have a client in very tangible need of this functionality who is a RedH=
at customer. Would it be helpful if they were to open a case with Redhat on=
 this?
>
> As an extension the above (but not to distract from the focus of getting =
something to work at all first):
>
> I rather accidentally also played around with delegating retrieval of the=
 mount credentials into gssproxy as well (due to not realising that usernam=
e=3DFEDORA33$ would just activate the keytab codepath in cifs.upcall).
>
> This can be done by leaving out the username from the mount command, mark=
ing euid 0 as trusted for access to the keytab in gssproxy and adding a fal=
lback principal to the gssproxy config (because cifs.upcall in this case do=
es not submit a desired name for the credential):
>
> [root@fedora33 ~]# mount -o sec=3Dkrb5,multiuser //dc/share /mnt
> [root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
> [service/cifs]
> mechs =3D krb5
> socket =3D /var/lib/gssproxy/cifs.sock
> cred_store =3D keytab:/etc/krb5.keytab
> cred_usage =3D initiate
> euid =3D 0
> trusted =3D yes
> impersonate =3D yes
> krb5_principal =3D cifs-mount
> allow_any_uid =3D yes
>
> While this works, it requires a separate user who would then carefully ne=
ed to be kept out of any sensitive file access groups.
>
> When trying to use the machine identity FEDORA33$ instead, I ran into a p=
eculiar error from the AD KDC:
>
> [root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
> [service/cifs]
> mechs =3D krb5
> socket =3D /var/lib/gssproxy/cifs.sock
> cred_store =3D keytab:/etc/krb5.keytab
> cred_usage =3D initiate
> euid =3D 0
> trusted =3D yes
> impersonate =3D yes
> krb5_principal =3D FEDORA33$
> allow_any_uid =3D yes
> [root@fedora33 ~]# gssproxy -i -d &
> [2] 3814
> [root@fedora33 ~]# [2021/01/07 10:01:10]: Debug Enabled (level: 1)
> [2021/01/07 10:01:10]: Service: nfs-server, Keytab: /etc/krb5.keytab, Enc=
type: 17
> [2021/01/07 10:01:10]: Service: cifs, Keytab: /etc/krb5.keytab, Enctype: =
17
> [2021/01/07 10:01:10]: Service: nfs-client, Keytab: /etc/krb5.keytab, Enc=
type: 17
> [2021/01/07 10:01:10]: Client [2021/01/07 10:01:10]: (/usr/sbin/gssproxy)=
 [2021/01/07 10:01:10]:  connected (fd =3D 11)[2021/01/07 10:01:10]:  (pid =
=3D 3814) (uid =3D 0) (gid =3D 0)[2021/01/07 10:01:10]:  (context =3D syste=
m_u:system_r:kernel_t:s0)[2021/01/07 10:01:10]:
>
> [root@fedora33 ~]# mount -o sec=3Dkrb5,multiuser //dc/share /mnt
> [2021/01/07 10:01:13]: Client [2021/01/07 10:01:13]: (/usr/sbin/cifs.upca=
ll) [2021/01/07 10:01:13]:  connected (fd =3D 12)[2021/01/07 10:01:13]:  (p=
id =3D 3824) (uid =3D 0) (gid =3D 0)[2021/01/07 10:01:13]:  (context =3D sy=
stem_u:system_r:kernel_t:s0)[2021/01/07 10:01:13]:
> [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 6 (GSSX_ACQUIRE_=
CRED) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
> gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure. =
 Minor code may provide more information, KDC has no support for padata typ=
e
> [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 8 (GSSX_INIT_SEC=
_CONTEXT) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
> gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure. =
 Minor code may provide more information, KDC has no support for padata typ=
e
> [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 6 (GSSX_ACQUIRE_=
CRED) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
> gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure. =
 Minor code may provide more information, KDC has no support for padata typ=
e
> [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 8 (GSSX_INIT_SEC=
_CONTEXT) for service "cifs", euid: 0,socket: /var/lib/gssproxy/cifs.sock
> gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS failure. =
 Minor code may provide more information, KDC has no support for padata typ=
e
> mount error(126): Required key not available
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel l=
og messages (dmesg)
>
> With more debugging it appears that gssproxy tries to impersonate user FE=
DORA33$ with a credential which is also for FEDORA33$. After further testin=
g it seems this is generally not allowed or just not working due to never b=
eing tested because it is unnecessary: If we can acquire a impersonation cr=
edential for that identity we should also be able to get the actual access =
credential as well.
>
> From looking at the nfs-utils gssd code it appears the only reason it has=
n't run into this case yet is because it handles the machine credentials it=
self using krb5 functions.
>
> The second attached patch against current gssproxy HEAD adds that distinc=
tion and makes this case work as an optional extension with fallback into t=
he default codepath on error.
>
> Does that make sense?
> Is it sane, security wise, do you think?
> --
> Thanks,
> Michael
> ________________________________________
> From: Simo Sorce <simo@redhat.com>
> Sent: 16 December 2020 15:31:40
> To: The GSS-Proxy developers and users mailing list; linux-cifs@vger.kern=
el.org
> Cc: samba-technical@lists.samba.org
> Subject: [gssproxy] Re: cifs-utils, Linux cifs kernel client and gssproxy
>
> Caution! External email. Do not open attachments or click links, unless t=
his email comes from a known sender and you know the content is safe.
>
> Hi Michael,
> as you say the best course of action would be for cifs.ko to move to
> use the RPC interface we defined for knfsd (with any extensions that
> may  be needed), and we had discussions in the past with cifs upstream
> developers about it. But nothing really materialized.
>
> If something is needed in the short term, I thjink the quickest course
> of action is indeed to change the userspace helper to use gssapi
> function calls, so that they can be intercepted like we do for rpc.gssd
> (nfs client's userspace helper).
>
> Unfortunately I do not have the cycles to work on that myself at this
> time :-(
>
> HTH,
> Simo.
>
> On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael wrote:
> > Hello,
> >
> > I have a use-case for authentication of Linux cifs client mounts withou=
t the user being present (e.g. from batch jobs) using gssproxy's impersonat=
ion feature with Kerberos Constrained Delegation similar to how it can be d=
one for NFS[1].
> >
> > My understanding is that currently neither the Linux cifs kernel client=
 nor cifs-utils userland tools support acquiring credentials using gssproxy=
. The former uses a custom upcall interface to talk to cifs.spnego from cif=
s-utils. The latter then goes looking for Kerberos ticket caches using libk=
rb5 functions, not GSSAPI, which prevents gssproxy from interacting with it=
.[2]
> >
> > From what I understand, the preferred method would be to switch the Lin=
ux kernel client upcall to the RPC protocol defined by gssproxy[3] (as has =
been done for the Linux kernel NFS server already replacing rpc.svcgssd[4])=
. The kernel could then, at least optionally, talk to gssproxy directly to =
try and obtain credentials.
> >
> > Failing that, cifs-utils' cifs.spnego could be switched to GSSAPI so th=
at gssproxy's interposer plugin could intercept GSSAPI calls and provide th=
em with the required credentials (similar to the NFS client rpc.gssd[5]).
> >
> > Assuming my understanding is correct so far:
> >
> > Is anyone doing any work on this and could use some help (testing, codi=
ng)?
> > What would be expected complexity and possible roadblocks when trying t=
o make a start at implementing this?
> > Or is the idea moot due to some constraint or recent development I'm no=
t aware of?
> >
> > I have found a recent discussion of the topic on linux-cifs[6] which pr=
ovided no definite answer though.
> >
> > As a crude attempt at an explicit userspace workaround I tried but fail=
ed to trick smbclient into initialising a ticket cache using gssproxy for c=
ifs.spnego to find later on.
> > Is this something that could be implemented without too much redundant =
effort (or should already work, perhaps using a different tool)?
> >
> > [1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#user-imper=
sonation-via-constrained-delegation
> > [2] https://pagure.io/gssproxy/issue/56
> > [3] https://github.com/gssapi/gssproxy/blob/main/docs/ProtocolDocumenta=
tion.md
> > [4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-server
> > [5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-client
> > [6] https://www.spinics.net/lists/linux-cifs/msg20182.html
> > --
> > Thanks,
> > Michael
> > _______________________________________________
> > gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> > To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.org
> > Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/project/co=
de-of-conduct/
> > List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
> > List Archives: https://lists.fedorahosted.org/archives/list/gss-proxy@l=
ists.fedorahosted.org
>
> --
> Simo Sorce
> RHEL Crypto Team
> Red Hat, Inc
>
>
>
> _______________________________________________
> gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.org
> Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/project/code=
-of-conduct/
> List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
> List Archives: https://lists.fedorahosted.org/archives/list/gss-proxy@lis=
ts.fedorahosted.org



--=20
Regards,
Shyam
