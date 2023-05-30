Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0139C7EE23
	for <linux-cifs@archiver.kernel.org>; Tue, 30 May 2023 07:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjE3HcI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 May 2023 03:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjE3Hbs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 May 2023 03:31:48 -0400
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 May 2023 00:31:08 PDT
Received: from smarthost4.atos.net (smtppost.atos.net [193.56.114.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690F7E58
        for <linux-cifs@vger.kernel.org>; Tue, 30 May 2023 00:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=atos.net; i=@atos.net; q=dns/txt; s=mail2022;
  t=1685431868; x=1716967868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D5BH7s3tsl7E+60A9+c95gmK481ck4TnE3kun3DnkaI=;
  b=UPu+jxwEi50x98o1o1WHDeH67vdDUJztmYzFn6U677A9seYu53RcvpB0
   Zk9N6L0z9+C9pVKu/N8J16hzdJlTbRII25yIkusjylbyGTf5OJMG51wuI
   kp/MIYYw9MmglqsC1yAURqvDl+eqB3X3rMMdr3VeA8jLE7tNvrKNmOBXG
   IUOAfDn3fnWSqvqxw+tbs4QcaYIDSM0INDJDIlAx2bF3MlHCL47Cb+iBn
   dI7FbFMkHy8smsXyWPHdLtu6ILzsTBqHUpzJg5ePh3e8yjcGq2E6cL6B4
   oa01VamPuGbXB/ZUhhuFetP/TarpsSMxr7jML5fRcfHiyAj+Gv5LpOpz2
   A==;
X-IronPort-AV: E=Sophos;i="6.00,203,1681164000"; 
   d="scan'208";a="527299903"
X-MGA-submission: =?us-ascii?q?MDH2bzNMsuenOZJRZRyL9swZlWwDuoA+EPaiGs?=
 =?us-ascii?q?rJGBOP8LJxX9py3K9Svn3avCFFf2DyMfBPcN1gbvldskh9yb0iUun4X8?=
 =?us-ascii?q?z/g4FqpwRuFSCniI3T/5jSmPGkr1e5cODI4HBH54/s8O//CyjOGKILIE?=
 =?us-ascii?q?3S?=
Received: from mail.sis.atos.net (HELO GITEXCPRDMB12.ww931.my-it-solutions.net) ([10.89.28.142])
  by smarthost4.atos.net with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2023 09:26:01 +0200
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net (10.89.28.144) by
 GITEXCPRDMB12.ww931.my-it-solutions.net (10.89.28.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 09:26:01 +0200
Received: from GITEXCPRDMB14.ww931.my-it-solutions.net
 ([fe80::4817:dcd:3f05:31dd]) by GITEXCPRDMB14.ww931.my-it-solutions.net
 ([fe80::4817:dcd:3f05:31dd%8]) with mapi id 15.01.2507.023; Tue, 30 May 2023
 09:26:01 +0200
From:   Michael Weiser <michael.weiser@atos.net>
To:     =?iso-8859-1?Q?Bj=F6rn_JACKE?= <bj@SerNet.DE>
CC:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Displaying streams as xattrs
Thread-Topic: Displaying streams as xattrs
Thread-Index: AQHZjFJZnfDh67Aygk62iSnnSxgxLK9lkuWAgAAjWQCAAKKBgIAERo0AgAATxoCAAFzlAIAAP/iAgAADBgCAAB+DgIAAGqqAgAEP4ACABdantw==
Date:   Tue, 30 May 2023 07:26:01 +0000
Message-ID: <40d4244e21ff46bb8c18812f65434779@atos.net>
References: <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop>
 <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
 <ZG/DajG6spMO6A7v@jeremy-rocky-laptop> <20230525221449.GA9932@sernet.de>
 <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>,<20230526160320.GA13176@sernet.de>
In-Reply-To: <20230526160320.GA13176@sernet.de>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.79.0.29]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Bjoern,

thanks for raising this point!

> If there is something the the Linux VFS layer should *really* add to help
> interopearbility with basically all other major OS implementations is NFS=
v4
> ACLs.  Seriously, for so many people living with Linux is a real pain due=
 to
> the lack of NFS4 ACLs here.
[...]
> The NFS4 ACL model needs to be supported by the Linux kernel also to be r=
eally
> helpful. The nfs4-acl-tools are there to manage NFS4 ACLs already. To bec=
ome
> really helpful for Linux NFS4 ACLs need to be managable natively and also=
 be
> supported with generic filesystems and tools.

> I've seen people who abandon to use Linux as client machines because of t=
he
> lack of ACL managability. Have in mind that the so called POSIX ACLs are =
not a

FWIW: I can second that: Many of our clients (as in customers) run (for
example) Linux HPC cluster headnodes with directly attached storage. For th=
em,
exporting a local filesystem like ext4 or XFS via NFS *and* SMB is an impor=
tant
use-case.

They don't have the time and expertise to dive into VFS modules and quirks =
of
NFSv4-to-POSIX-ACL mappings. So they actually limit themselves to just
standard permission bits and write cron jobs to regularly reset permissions=
.
Even if we manage to come up with a working setup for them, it's going to b=
e
fragile in multiple dimensions. It's a pain.

Having consistent and powerful ACL support and enforcement across all acces=
s
paths (remote shell, NFS, SMB) that just works would be a huge leap forward=
 for
them. Having cp -a retain the ACLs and their effects during copy from NFS m=
ount
to local /tmp and back to an SMB mount would be a dream come true.
--
Thanks,
Michael
________________________________________
From: samba-technical <samba-technical-bounces@lists.samba.org> on behalf o=
f Bj=F6rn JACKE via samba-technical <samba-technical@lists.samba.org>
Sent: 26 May 2023 18:03:20
To: Steve French
Cc: CIFS; samba-technical; Jeremy Allison; Christoph Hellwig
Subject: Re: Displaying streams as xattrs

Caution: External email. Do not open attachments or click links, unless thi=
s email comes from a known sender and you know the content is safe.


On 2023-05-25 at 18:50 -0500 Steve French via samba-technical sent off:
> Today the "RichACLs" can be displayed multiple ways (e.g. "getcifsacl"
> and various other
> tools and also via system xattrs).
> Being able to display "RichACLs" makes sense - and I am fine with
> mapping these (and
> probably would make sense to at least have a readonly mapping of the
> existing richacls on
> a file to "posixacl") and RichACLs are very important.
>
> Wouldn't it be easier to let them also be queried for cifs.ko via
> "system.getrichacl" (or whatever
> the "getrichacl" tool used in various xfstests uses)?
>
> I was also wondering how we should display (and how to retrieve via
> SMB3) "claims based ACLs" (presumably these are reasonably common on a
> few server types like Windows)?

let's stop calling them RichACLs becuase that was only the name that Andrea=
s
Gr=FCnbacher was giving his implementation of the NFS4 ACLs, which however =
never
mede it upstream to the kernel. Andreas is no longer interested in working =
on
those actually because because of a long lack of interest by the Kernel
maintainers back in those days. In any case, NFS4 ACLs are the right name, =
even
if the SMB people don't like the "NFS" in the name.

We have a summary of the state of NFS4 ACLs here:
https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwiki.sa=
mba.org%2Findex.php%2FNFS4_ACL_overview&data=3D05%7C01%7Cmichael.weiser%40a=
tos.net%7C359c5b89a4aa453c20c108db5e02cb6a%7C33440fc6b7c7412cbb730e70b0198d=
5a%7C0%7C0%7C638207138314989061%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDA=
iLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=3D96X=
1GeVCoPYo1s3wmxtiDMdnXkR%2Bn%2Bw%2BcVfILLB3HGo%3D&reserved=3D0 . I recommen=
d taking a
closer look at this.

If cifs.ko would add a mapping of SMB ACLs to the corresponding system.nfs4=
_acl
EA, this would be nice already but It will only be a limited help if cifs.k=
o.

The NFS4 ACL model needs to be supported by the Linux kernel also to be rea=
lly
helpful. The nfs4-acl-tools are there to manage NFS4 ACLs already. To becom=
e
really helpful for Linux NFS4 ACLs need to be managable natively and also b=
e
supported with generic filesystems and tools.

I've seen people who abandon to use Linux as client machines because of the
lack of ACL managability. Have in mind that the so called POSIX ACLs are no=
t a
standardized permission model. The POSIX ACLs never passed the status of a
draft standard and the only standardized ACL permission model are in fact t=
he
NFS4 ACLs. One of the main reason why FreeNAS or TrueNAS these days are bas=
ed
on FreeBSD is the lack of NFS4 ACLs also.

I really wonder why the responsible people in the Kernel developer communit=
y
ignore this important topic since so many years. Would be nice to see them =
join
this thread ...

Bj=F6rn

