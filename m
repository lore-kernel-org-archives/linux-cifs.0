Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0D4C433E6
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 13:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F74322D6F
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jan 2021 13:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbhAGNwf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jan 2021 08:52:35 -0500
Received: from mail.fioriti.org ([95.216.23.138]:33540 "EHLO mail.fioriti.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbhAGNwf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 7 Jan 2021 08:52:35 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2021 08:52:33 EST
Received: from pico.ipa.ssimo.org (cpe-158-222-141-151.nyc.res.rr.com [158.222.141.151])
        by mail.fioriti.org (Postfix) with ESMTPSA id C429B260085;
        Thu,  7 Jan 2021 08:45:13 -0500 (EST)
Message-ID: <34f05c896fc95047e2cee8252441ec3420cf06e2.camel@ssimo.org>
Subject: Re: [gssproxy] Re: cifs-utils, Linux cifs kernel client and gssproxy
From:   Simo <simo@ssimo.org>
To:     samba-technical@lists.samba.org
Cc:     "Weiser, Michael" <michael.weiser@atos.net>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        The GSS-Proxy developers and users mailing list 
        <gss-proxy@lists.fedorahosted.org>
Date:   Thu, 07 Jan 2021 08:45:11 -0500
In-Reply-To: <2d5a7cf3b6e8e31db010f6a3d159109ca48ca998.camel@samba.org>
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net>
         , <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
         <e562d3fb430e4c87b0700a70267ef930@atos.net>
         <2d5a7cf3b6e8e31db010f6a3d159109ca48ca998.camel@samba.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Adding back missing people in CC, as I incorrectly pressed reply-to-
list and lost them.

On Thu, 2021-01-07 at 08:37 -0500, Simo via samba-technical wrote:
> On Thu, 2021-01-07 at 11:04 +0000, Weiser, Michael via samba-
> technical
> wrote:
> > Hello Simo,
> > Hello Steve,
> > 
> > > If something is needed in the short term, I thjink the quickest
> > > course
> > > of action is indeed to change the userspace helper to use gssapi
> > > function calls, so that they can be intercepted like we do for
> > > rpc.gssd
> > > (nfs client's userspace helper).
> > 
> > To get the ball rolling and give people (including myself and
> > client)
> > something to play with I went that route and extended cifs.upcall
> > to
> > fall back to GSS-API if no ticket cache nor keytab can be found for
> > the user. An unpolished PoC patch is attached. (Sorry, for not
> > putting it inline, have to rock the groupware at work. I will try
> > to
> > sort that once we've agreed this is the/a way to go.)
> > 
> > With that patch applied,  I can do a multiuser cifs mount using the
> > system keytab and machine identity as usual and then have users
> > access the mount using impersonated credentials from gssproxy.
> > Quick
> > demo:
> > 
> > [root@fedora33 ~]# umount /mnt
> > [root@fedora33 ~]# mount -o sec=krb5,multiuser,user=FEDORA33\$
> > //dc/share /mnt
> > [root@fedora33 ~]# ls -la /mnt
> > total 0
> > drwxr-xr-x.  2 root root   0 Jan  7 10:20 .
> > dr-xr-xr-x. 18 root root 238 Jan  6 13:59 ..
> > -rwxr-xr-x.  1 root root   0 Jan  5 17:02 bar
> > [root@fedora33 ~]# klist
> > klist: Credentials cache keyring 'persistent:0:krb_ccache_WZh7W8n'
> > not found
> > [root@fedora33 ~]#
> > 
> > [adsuser@fedora33 ~]$ kdestroy
> > [adsuser@fedora33 ~]$ echo test > /mnt/test
> > [adsuser@fedora33 ~]$ cat /mnt/test
> > test
> > [adsuser@fedora33 ~]$ klist
> > klist: Credentials cache keyring
> > 'persistent:1618201110:krb_ccache_SrGqT3F' not found
> > [adsuser@fedora33 ~]$
> > 
> > Server-side permissions are enforced:
> > 
> > [m@fedora33 ~]$ cat /mnt/test
> > test
> > [m@fedora33 ~]$ echo mytest > /mnt/test
> > -bash: /mnt/test: Permission denied
> > [m@fedora33 ~]$ klist
> > klist: Credentials cache keyring 'persistent:1000:1000' not found
> > [m@fedora33 ~]$
> > 
> > The gssproxy config for this configures a cifs-specific socket and
> > enables impersonation for any user id:
> > 
> > [root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
> > [service/cifs]
> > mechs = krb5
> > socket = /var/lib/gssproxy/cifs.sock
> > cred_store = keytab:/etc/krb5.keytab
> > cred_usage = initiate
> > euid = 0
> > impersonate = yes
> > allow_any_uid = yes
> > 
> > And request-key config for cifs.spnego enables use of gssproxy and
> > the service-specific socket through environment variables:
> > 
> > [root@fedora33 ~]# cat /etc/request-key.d/cifs.spnego.conf
> > create  cifs.spnego    * *  /usr/bin/env GSS_USE_PROXY=yes
> > GSSPROXY_SOCKET=/var/lib/gssproxy/cifs.sock /usr/sbin/cifs.upcall
> > %k
> > 
> > (I see that nfs-utils' gssd does the same by setting the variables
> > itself based on command line options. That could easily be done
> > here
> > as well.)
> >  
> > User FEDORA33$ (the computer object) needs to be enabled for
> > delegation to service cifs. I've tested with a Fedora 33 client and
> > Windows 2016 Active Directory server.
> > 
> > The patch is against current cifs-utils HEAD. It is lacking all the
> > autoconf trimmings and intentionally forgoes reindents of existing
> > code for clarity of what's being touched.
> > 
> > What do you think?
> 
> Sounds great!
> 
> > > Unfortunately I do not have the cycles to work on that myself at
> > > this
> > > time :-(
> > 
> > I have a client in very tangible need of this functionality who is
> > a
> > RedHat customer. Would it be helpful if they were to open a case
> > with
> > Redhat on this?
> 
> Yes!
> CC me if you need to.
> 
> > As an extension the above (but not to distract from the focus of
> > getting something to work at all first):
> > 
> > I rather accidentally also played around with delegating retrieval
> > of
> > the mount credentials into gssproxy as well (due to not realising
> > that username=FEDORA33$ would just activate the keytab codepath in
> > cifs.upcall).
> > 
> > This can be done by leaving out the username from the mount
> > command,
> > marking euid 0 as trusted for access to the keytab in gssproxy and
> > adding a fallback principal to the gssproxy config (because
> > cifs.upcall in this case does not submit a desired name for the
> > credential):
> > 
> > [root@fedora33 ~]# mount -o sec=krb5,multiuser //dc/share /mnt
> > [root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
> > [service/cifs]
> > mechs = krb5
> > socket = /var/lib/gssproxy/cifs.sock
> > cred_store = keytab:/etc/krb5.keytab
> > cred_usage = initiate
> > euid = 0
> > trusted = yes
> > impersonate = yes
> > krb5_principal = cifs-mount
> > allow_any_uid = yes
> > 
> > While this works, it requires a separate user who would then
> > carefully need to be kept out of any sensitive file access groups.
> > 
> > When trying to use the machine identity FEDORA33$ instead, I ran
> > into
> > a peculiar error from the AD KDC:
> > 
> > [root@fedora33 ~]# cat /etc/gssproxy/99-cifs.conf
> > [service/cifs]
> > mechs = krb5
> > socket = /var/lib/gssproxy/cifs.sock
> > cred_store = keytab:/etc/krb5.keytab
> > cred_usage = initiate
> > euid = 0
> > trusted = yes
> > impersonate = yes
> > krb5_principal = FEDORA33$
> > allow_any_uid = yes
> > [root@fedora33 ~]# gssproxy -i -d &
> > [2] 3814
> > [root@fedora33 ~]# [2021/01/07 10:01:10]: Debug Enabled (level: 1)
> > [2021/01/07 10:01:10]: Service: nfs-server, Keytab:
> > /etc/krb5.keytab,
> > Enctype: 17
> > [2021/01/07 10:01:10]: Service: cifs, Keytab: /etc/krb5.keytab,
> > Enctype: 17
> > [2021/01/07 10:01:10]: Service: nfs-client, Keytab:
> > /etc/krb5.keytab,
> > Enctype: 17
> > [2021/01/07 10:01:10]: Client [2021/01/07 10:01:10]:
> > (/usr/sbin/gssproxy) [2021/01/07 10:01:10]:  connected (fd =
> > 11)[2021/01/07 10:01:10]:  (pid = 3814) (uid = 0) (gid =
> > 0)[2021/01/07 10:01:10]:  (context =
> > system_u:system_r:kernel_t:s0)[2021/01/07 10:01:10]:
> > 
> > [root@fedora33 ~]# mount -o sec=krb5,multiuser //dc/share /mnt
> > [2021/01/07 10:01:13]: Client [2021/01/07 10:01:13]:
> > (/usr/sbin/cifs.upcall) [2021/01/07 10:01:13]:  connected (fd =
> > 12)[2021/01/07 10:01:13]:  (pid = 3824) (uid = 0) (gid =
> > 0)[2021/01/07 10:01:13]:  (context =
> > system_u:system_r:kernel_t:s0)[2021/01/07 10:01:13]:
> > [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 6
> > (GSSX_ACQUIRE_CRED) for service "cifs", euid: 0,socket:
> > /var/lib/gssproxy/cifs.sock
> > gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS
> > failure.  Minor code may provide more information, KDC has no
> > support
> > for padata type
> > [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 8
> > (GSSX_INIT_SEC_CONTEXT) for service "cifs", euid: 0,socket:
> > /var/lib/gssproxy/cifs.sock
> > gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS
> > failure.  Minor code may provide more information, KDC has no
> > support
> > for padata type
> > [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 6
> > (GSSX_ACQUIRE_CRED) for service "cifs", euid: 0,socket:
> > /var/lib/gssproxy/cifs.sock
> > gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS
> > failure.  Minor code may provide more information, KDC has no
> > support
> > for padata type
> > [CID 12][2021/01/07 10:01:13]: gp_rpc_execute: executing 8
> > (GSSX_INIT_SEC_CONTEXT) for service "cifs", euid: 0,socket:
> > /var/lib/gssproxy/cifs.sock
> > gssproxy[3814]: (OID: { 1 2 840 113554 1 2 2 }) Unspecified GSS
> > failure.  Minor code may provide more information, KDC has no
> > support
> > for padata type
> > mount error(126): Required key not available
> > Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and
> > kernel log messages (dmesg)
> > 
> > With more debugging it appears that gssproxy tries to impersonate
> > user FEDORA33$ with a credential which is also for FEDORA33$. After
> > further testing it seems this is generally not allowed or just not
> > working due to never being tested because it is unnecessary: If we
> > can acquire a impersonation credential for that identity we should
> > also be able to get the actual access credential as well.
> 
> Sounds like a bug in gss-proxy, can you file a github issue/PR ?
> We should certainly shortcut the impersonation if we already have a
> valid credential.
> 
> > From looking at the nfs-utils gssd code it appears the only reason
> > it
> > hasn't run into this case yet is because it handles the machine
> > credentials itself using krb5 functions.
> > 
> > The second attached patch against current gssproxy HEAD adds that
> > distinction and makes this case work as an optional extension with
> > fallback into the default codepath on error.
> > 
> > Does that make sense?
> 
> Yes the patch looks good!
> 
> > Is it sane, security wise, do you think?
> 
> Sane, you are just avoiding a useless call in a special case.
> 
> Simo.
> 
> 

