Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6660FC4361B
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 13:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D3F238EF
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Dec 2020 13:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgLQNlJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 08:41:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727354AbgLQNlJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Dec 2020 08:41:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608212382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8wlz3/0iQnzzkXl44dSRZEBGu1Ze6Jd85KeRi2ZTwsI=;
        b=J5YQUTp090WKzFdpm9FJOadmnIIE8tI3WrcJrbN2JkZIZVuGSaFPHqAVJp7bogWtNSK5sL
        Bejhvt01qMfXdpPCJMIFRR1F7QMvBuyTWZ3fvv3/o3Ck0JeUHczsOvFPgVlmAwZqrsJiUt
        YriXoZE2TkmtshcRxhYY4jIbakIEmTo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-bc2x_AJMNyuf3drEAx29Tg-1; Thu, 17 Dec 2020 08:39:39 -0500
X-MC-Unique: bc2x_AJMNyuf3drEAx29Tg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 735FD800D55;
        Thu, 17 Dec 2020 13:39:38 +0000 (UTC)
Received: from ovpn-112-247.phx2.redhat.com (ovpn-112-247.phx2.redhat.com [10.3.112.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB5DE60BE5;
        Thu, 17 Dec 2020 13:39:37 +0000 (UTC)
Message-ID: <c49c0a18c228e6aa43dbb2cbab7e0a266d1c0371.camel@redhat.com>
Subject: Re: [gssproxy] cifs-utils, Linux cifs kernel client and gssproxy
From:   Simo Sorce <simo@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     The GSS-Proxy developers and users mailing list 
        <gss-proxy@lists.fedorahosted.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Date:   Thu, 17 Dec 2020 08:39:36 -0500
In-Reply-To: <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com>
References: <2e241ceaece6485289b1cddb84ec77ca@atos.net>
         <04d24a21a7a462b3dc316959c3a3b1c8be8caac3.camel@redhat.com>
         <CAH2r5mt9r6nWop_ekbe1CsinztUiGhP2-bxWFkRqHXOP=MXcVQ@mail.gmail.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

GSSAPI and krb5 as implemented in system krb5 libraries exists from
longer than Samba has implemented those capabilities, I do not think it
make sense to reason along those lines.

GSS-Proxy has been built with a protocol to talk from the kernel that
resolved a number of issues for knfsd (eg big packet sizes when a MS-
PAC is present).

And Samba uses internally exactly the same krb5 mechanism as it defers
to the kerberos libraries as well.

Additionally GSS-Proxy can be very easily extended to also do NTLMSSP
using the same interface as I have built the gssntlmssp long ago from
the MS spec, and is probably the most correct NTLMSSP implementation
you can find around.

Gssntlmssp also has a Winbind backend so you get automaticaly access to
whatever cached credentials Winbindd has for users as a bonus (although
the integration can be improved there), yet you *can* use it w/o
Winbindd just fine providing a credential file (smbpasswd format
compatible).

GSS-Proxy is already integrated in distributions because it is used by
knfsd, and can be as easily used by cifsd, and you *should* really use
it there, so we can have a single, consistent, maintained, mechanism
for server side GSS authentication, and not have to repeat and reinvent
kernel to userspace mechanisms.

And if you add it for cifsd you have yet another reason to do it for
cifs.ko as well.

Finally the GSS-Proxy mechanism is namespace compatible, so you also
get the ability to define different auth daemons per different
containers, no need to invent new mechanisms for that or change yet
again protocols/userspace to obtain container capabilities.

For the client we'll need to add some XDR parsing functions in kernel,
they were omitted from my original patches because there was no client
side kernel consumer back then, but it i an easy, mechanical change.

HTH,
Simo.

On Wed, 2020-12-16 at 16:43 -0600, Steve French wrote:
> generally I would feel more comfortable using something (library or
> utility) in Samba (if needed) for additional SPNEGO support if
> something is missing (in what the kernel drivers are doing to
> encapsulate Active Directory or Samba AD krb5 tickets in SPNEGO) as
> Samba is better maintained/tested etc. than most components.  Is there
> something in Samba that could be used here instead of having a
> dependency on another project - Samba has been doing Kerberos/SPNEGO
> longer than most ...?   There are probably others (jra, Metze etc.)
> that have would know more about gssproxy vs. Samba equivalents though
> and would defer to them ...
> 
> On Wed, Dec 16, 2020 at 8:33 AM Simo Sorce <simo@redhat.com> wrote:
> > Hi Michael,
> > as you say the best course of action would be for cifs.ko to move to
> > use the RPC interface we defined for knfsd (with any extensions that
> > may  be needed), and we had discussions in the past with cifs upstream
> > developers about it. But nothing really materialized.
> > 
> > If something is needed in the short term, I thjink the quickest course
> > of action is indeed to change the userspace helper to use gssapi
> > function calls, so that they can be intercepted like we do for rpc.gssd
> > (nfs client's userspace helper).
> > 
> > Unfortunately I do not have the cycles to work on that myself at this
> > time :-(
> > 
> > HTH,
> > Simo.
> > 
> > On Wed, 2020-12-16 at 10:01 +0000, Weiser, Michael wrote:
> > > Hello,
> > > 
> > > I have a use-case for authentication of Linux cifs client mounts without the user being present (e.g. from batch jobs) using gssproxy's impersonation feature with Kerberos Constrained Delegation similar to how it can be done for NFS[1].
> > > 
> > > My understanding is that currently neither the Linux cifs kernel client nor cifs-utils userland tools support acquiring credentials using gssproxy. The former uses a custom upcall interface to talk to cifs.spnego from cifs-utils. The latter then goes looking for Kerberos ticket caches using libkrb5 functions, not GSSAPI, which prevents gssproxy from interacting with it.[2]
> > > 
> > > From what I understand, the preferred method would be to switch the Linux kernel client upcall to the RPC protocol defined by gssproxy[3] (as has been done for the Linux kernel NFS server already replacing rpc.svcgssd[4]). The kernel could then, at least optionally, talk to gssproxy directly to try and obtain credentials.
> > > 
> > > Failing that, cifs-utils' cifs.spnego could be switched to GSSAPI so that gssproxy's interposer plugin could intercept GSSAPI calls and provide them with the required credentials (similar to the NFS client rpc.gssd[5]).
> > > 
> > > Assuming my understanding is correct so far:
> > > 
> > > Is anyone doing any work on this and could use some help (testing, coding)?
> > > What would be expected complexity and possible roadblocks when trying to make a start at implementing this?
> > > Or is the idea moot due to some constraint or recent development I'm not aware of?
> > > 
> > > I have found a recent discussion of the topic on linux-cifs[6] which provided no definite answer though.
> > > 
> > > As a crude attempt at an explicit userspace workaround I tried but failed to trick smbclient into initialising a ticket cache using gssproxy for cifs.spnego to find later on.
> > > Is this something that could be implemented without too much redundant effort (or should already work, perhaps using a different tool)?
> > > 
> > > [1] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#user-impersonation-via-constrained-delegation
> > > [2] https://pagure.io/gssproxy/issue/56
> > > [3] https://github.com/gssapi/gssproxy/blob/main/docs/ProtocolDocumentation.md
> > > [4] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-server
> > > [5] https://github.com/gssapi/gssproxy/blob/main/docs/NFS.md#nfs-client
> > > [6] https://www.spinics.net/lists/linux-cifs/msg20182.html
> > > --
> > > Thanks,
> > > Michael
> > > _______________________________________________
> > > gss-proxy mailing list -- gss-proxy@lists.fedorahosted.org
> > > To unsubscribe send an email to gss-proxy-leave@lists.fedorahosted.org
> > > Fedora Code of Conduct: https://docs.fedoraproject.org/en-US/project/code-of-conduct/
> > > List Guidelines: https://fedoraproject.org/wiki/Mailing_list_guidelines
> > > List Archives: https://lists.fedorahosted.org/archives/list/gss-proxy@lists.fedorahosted.org
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
> 

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




