Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E879EC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Apr 2022 09:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiDHJMT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Apr 2022 05:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiDHJMD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Apr 2022 05:12:03 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D2E11E7A7A
        for <linux-cifs@vger.kernel.org>; Fri,  8 Apr 2022 02:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
         s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aBArbqz3OvKQKOmAVAWjT2sNWTveG1Mo8tpAZ1JOcao=; b=px57545eZmH1t7ADVUaMOOJOzA
        tnOA9T8G/WsQ4Ww/cObURjOLr2TS1l5gOFYK4TImtTfJmhqEmv9vjI4aF5psiSyefUyhACuDiafrj
        OaQplP232osc/oHJ7lcZlPab6K+Z1eJKYRnlJmUbfb1HFYjjbc+2+vql5PpTJHju2Z6fSIgk99i39
        wvW0NrMsYIc9X8i5D81nMk4QiTdR5Oj9/5hWqGrYl1NyUxweG+RY83DPLYQO2kvoPWd0oeP1Rtaln
        fXgSYmo9jcnVJ3c2yDJPF1RYtspZuFHxIrEW3/jnRKPzCfU7W/x/6CPJF3WcrclNeJyf9c49+cuKy
        /RfA7fcA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aBArbqz3OvKQKOmAVAWjT2sNWTveG1Mo8tpAZ1JOcao=; b=LA/lG1Rky67lLx5jVIXxXPH9pG
        A12KTt3vxfIAZYwWafdybUhSL4lBOopfOPUBUukCVfJPnfG6uKPkZdfqIbDg==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1nckc2-0003Gq-Ro; Fri, 08 Apr 2022 11:09:02 +0200
Received: by intern.sernet.de
        id 1nckc2-0003Nb-PO; Fri, 08 Apr 2022 11:09:02 +0200
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1nckc2-005cUm-Ky; Fri, 08 Apr 2022 11:09:02 +0200
Date:   Fri, 8 Apr 2022 11:09:02 +0200
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bjacke@SerNet.DE>
To:     Steve French <smfrench@gmail.com>
Cc:     samba@lists.samba.org, linux-cifs@vger.kernel.org
Subject: Re: [Samba] samba-ad linux clients random access denied to network
 share
Message-ID: <20220408090902.GA1328207@sernet.de>
Mail-Followup-To: Steve French <smfrench@gmail.com>, samba@lists.samba.org,
        linux-cifs@vger.kernel.org
References: <20220406231135.024f1ea5@jeeg20151223.verlata.it>
 <48371ac062c13d0acb1ac4266e46ac65a49af023.camel@samba.org>
 <20220407115146.GA1277129@sernet.de>
 <CAH2r5mv9uS3=YJsRB=GPAebTSY+-oZ3nQQuNs5gAxknmMM-UVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAH2r5mv9uS3=YJsRB=GPAebTSY+-oZ3nQQuNs5gAxknmMM-UVQ@mail.gmail.com>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve and other cifs developers,

On 2022-04-07 at 16:25 -0500 Steve French via samba sent off:
> If you have particular hot bugs for cifs.ko that you need fixed - please
> let me know.

back in 2020 we've added the cifs mailing list as qa contact in bugzilla, so
that bugzilla bugs get more visible to the developers.

At the same point I also went through all the open bug reports of cifs vfs,
which had partly been very old. I also closed a bunch of them as they had b=
een
fixed a while after they were reported there - but not because they were
reported in bugzilla obviously. I was hoping to improve that situation with=
 bug
reports getting not enough attention my adding the cifs mailinglist as qa
contact, this was my motivation.

Just pointing out those bugs that I myself reported in bugzilla.samba.org in
2020, all stayed uncommented till today; except for the "better error messa=
ge"
bug all of them are important for enterprise customers, this is also where =
they
popped up:

14398  	cifs vfs should pause if krb5 ticket is not valid=20
14440   creator owner (S-1-3-0) ACE not honored=20
14506   cifs mount with missing krb5 key should give better error message=
=20
14507   cifs ACL exec permission granted where it should be denied=20

And last but not least a big topic:

14499   expose NT ACLs via system.nfs4_acl EA=20

This idea popped up in the discussion of the 2020 SambaXP discussion after =
your
talk. Having a standardized permission management tool like the nfs4-acl-to=
ols
is really something that is important.

Also the fact that Linux still has no standardized ACL implementation (NFS4=
 ACL
are the only standardized ones) in the kernel is preventing many enterprise
customers to use Linux on client machines. Without that, permission managem=
ent
is such a pain that they usually give up any client installation efforts so=
oner
or later.  I think the cifs vfs developers would have the power to convince=
 the
responsible kernel developers to add this to the kernel.

I can say from my experience at various customer sites very clearly that ci=
fs
vfs will *not* be accepted widely in the enterprise world, without generic =
NFS4
ACLs implemented in the kernel alongside.


> SMB3.1.1 is simpler in some ways than NFS (no SunRPC to deal with) and
> should be easier to fix bugs in many cases.

maybe it is simpler, but for the above mentioned reasons, SMB on the Linux
client side is no option for most enterprise environments. They prefer NFS =
and
I understand why. I really wish this would change, this is why I write these
lines so bluntly.

Bj=F6rn
--=20
SerNet GmbH - Bahnhofsallee 1b - 37081 G=F6ttingen
phone: +495513700000  mailto:contact@sernet.com
AG G=F6ttingen: HR-B 2816 - https://www.sernet.com
Manag. Directors Johannes Loxen and Reinhild Jung
data privacy policy https://www.sernet.de/privacy

Samba eXPerience 2022 - online edition!
=66rom May 31st to June 2nd, 2022 at Zoom
sponsored by Google, Microsoft & SerNet
more information at https://sambaXP.org
