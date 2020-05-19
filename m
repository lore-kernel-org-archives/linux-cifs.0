Return-Path: <SRS0=BTJv=7B=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBB8C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 16:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24BB12075F
	for <linux-cifs@archiver.kernel.org>; Tue, 19 May 2020 16:15:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IUaEgqQc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgESQPe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 May 2020 12:15:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42179 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729001AbgESQPe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 May 2020 12:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589904930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLGOZACrkrZkUifpneXWStCopOQzwOjHoMpFa69h0CM=;
        b=IUaEgqQcuPGtQ2+DDCpaNKueAvPyll1/czWnWCPdg0rselIhXcoChNAov1D1DoIy1fyLed
        rN71oVh8qdNpsnOhZuJc/mgKVAfza+rTXxxZnHRi33Z1xDQQO0NiJSpvyHkRfyCe3IimyQ
        VU6Ksn9O/9zoQGZsPN9yb98GmrTlA98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-X9Eh-cR_Oq2dPk-w6Lo_Rg-1; Tue, 19 May 2020 12:15:24 -0400
X-MC-Unique: X9Eh-cR_Oq2dPk-w6Lo_Rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D95618014D7;
        Tue, 19 May 2020 16:15:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D1B1E50F54;
        Tue, 19 May 2020 16:15:23 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id CB38A4ED2D;
        Tue, 19 May 2020 16:15:23 +0000 (UTC)
Date:   Tue, 19 May 2020 12:15:23 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Message-ID: <2024477496.29432550.1589904923298.JavaMail.zimbra@redhat.com>
In-Reply-To: <87k119maco.fsf@suse.com>
References: <1628934597.29140043.1589817685407.JavaMail.zimbra@redhat.com> <87k119maco.fsf@suse.com>
Subject: Re: How to verify multichannel
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.68.5.20, 10.4.195.18]
Thread-Topic: How to verify multichannel
Thread-Index: fXeIIHd8iPYbwY3tMXpzN2AXixvupg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Aur=C3=A9lien for your professional information. It's very detailed =
and
useful.

Now I can see the multiple channel info in network package when mount with
option "max_channel=3D2". If doesn't specify it. Client will only open one=
=20
channel. And my smb.conf setup below can work for multichannel. Seems serve=
r
and client don't require multiple network interfaces. And also don't need=
=20
network team.

But When test seedup, it isn't change. I use two vm in the same host. And
each have 4 cpu and 1G memory. Maybe it's the problem.

Thanks so much.

----- Original Message -----
> From: "Aur=C3=A9lien Aptel" <aaptel@suse.com>
> To: "Xiaoli Feng" <xifeng@redhat.com>, linux-cifs@vger.kernel.org
> Sent: Tuesday, May 19, 2020 1:17:11 AM
> Subject: Re: How to verify multichannel
>=20
> Hi Xiaoli,
>=20
> Xiaoli Feng <xifeng@redhat.com> writes:
> > Hello,
> >
> > When I test multichannel. I don't know how to verify if it works. I jus=
t
> > catch network
> > packages to see if server and client communicate with multiple IP. But =
from
> > my test, it
> > doesn't. Does any one know how to verify multichannel?
>=20
> Testing if it works vs checking speed improvement are 2 different
> things unfortunately.
>=20
> Source code
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> First you need the latest patchset which is available on my github remote=
:
>=20
>     https://github.com/aaptel/linux.git
>=20
> You can use the "multichan-page" branch or you can extract the last
> patches of it (with "multichannel:" in the title). These patches add the
> multichannel support to the main read/write codepaths from memory pages.
>=20
> Client setup
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Then you need to mount with "vers=3D3.11,multichannel,max_channels=3DN" w=
here N
> will be the total number of channels the client will try to open.
>=20
> Do a network capture of the mount and run couple of commands in the
> mount point (ls, cat, stat, ...).
>=20
> If the client also has multiple interface, make sure you capture all
> interfaces traffic (otherwise you might ignore the other channels).
>=20
> Interface list check
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Look at the trace in wireshark and use "smb2" filter.
>=20
> Look for "Ioctl Response FSCTL_QUERY_NETWORK_INTERFACE_INFO", if the
> server has multiple interfaces you should see a list.
>=20
> You can also look at /proc/fs/cifs/DebugDate to see the list of
> interfaces the client saw and has connected to.
>=20
> Multichannel check
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Still in wireshark:
> - right-click on the first "Negotiate protocol" packet
> - "Colorize conversation" > "F5 TCP"
>=20
> You can repeat this for each channel to see clearly different colors for
> each channels.
>=20
> I have made some screenshots, maybe this can help:
>=20
> https://imgur.com/a/j3IBewF
>=20
> You can see the alternating colors in my traces that shows different
> channels being used.
>=20
> Speedup check
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Now this is the hard part.
>=20
> If you test with VMs and the interface are "virtual", when you make 2
> channels you are actually just dividing by 2 the bandwidth of the
> virtual bus, so you won't see much speedup.
>=20
> To see a speedup you need to limit the bandwidth of the server
> interface, for example 1MB/s to each, so that together with 2 channel
> you might see 2MB/s.
>=20
> You can look into iperf to check raw bandwidth and tc to limit it:
> - https://iperf.fr/
> - https://netbeez.net/blog/how-to-use-the-linux-traffic-control/
>=20
> Also similarly if the VM only has 1 CPU you might not see much
> improvement as it will switch from one NIC to the other sequentially
> instead of in parallel.
>=20
> This gets tricky very quick...
>=20
>=20
> > Setup:
> > server is samba server in linux upstream.
> > client is linux upstream.
> > smb.conf is:
> > [global]
> > interfaces =3D eth1, eth2, team0
> > server multi channel support =3D yes
> > vfs objects =3D recycle aio_pthread
> > aio read size =3D 1
> > aio write size =3D 1
> > [cifs]
> > path=3D/mnt/cifs
> > writeable=3Dyes
>=20
> This looks ok but I've mostly used Windows Server 2019 in my test.
>=20
> Let me know how it goes.
>=20
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>=20
>=20

