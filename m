Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7223BC77B73
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 16:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbjEZQD1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 12:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbjEZQD1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 12:03:27 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03A6F7
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 09:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sernet.de;
        s=20210621-rsa; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MkmKNeCFSRiyIak7l4SgZKeHT277T4B9MfQhNYGMBtk=; b=VFUSiIKEsy8IJ5Rl1UJLm5EbB8
        km8ee4NZtK9R/RfJTg+xnqOdaCSInB9XJnDyKDQzD5vWnw/aDF8snl8+7B+Kgc9n7yxcfpVqIuS/2
        R6a3W1z3pkLz2KUV7VYosXu+mllqILTPwGLdkJQwhPoW59kpHLdEOcwAtBg9n/WDqN5mUkOAQm2Kc
        aA6O70EhmBOM9u6Mg/Ztn92N/ZO36Y4roIlIT5c8aJPRvLcCR2HvzawDiTJQxMBuQnDIxGUD5T/fi
        u5xVqkA9th2ec8XprnELtWUju7lyEZ/TOVTcUNz+ejNxy5b5fdTQOn3f9pNK2JynYfWew67GHEnaK
        HJAUfh/Q==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sernet.de; s=20210621-ed25519; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MkmKNeCFSRiyIak7l4SgZKeHT277T4B9MfQhNYGMBtk=; b=ubX1vi+5S92zGqgZF5FCJZG+bq
        fUA9q9m/GlUsS0IjNPUKIsOZRkDyXaw2hUA59b+KEaYgEBEC9IlgrUUqbFBw==;
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1q2ZuV-009jAa-7c; Fri, 26 May 2023 18:03:23 +0200
Received: by intern.sernet.de
        id 1q2ZuU-0055Rp-Up; Fri, 26 May 2023 18:03:22 +0200
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1q2ZuS-000926-RY; Fri, 26 May 2023 18:03:20 +0200
Date:   Fri, 26 May 2023 18:03:20 +0200
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
To:     Steve French <smfrench@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: Displaying streams as xattrs
Message-ID: <20230526160320.GA13176@sernet.de>
Mail-Followup-To: Steve French <smfrench@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Christoph Hellwig <hch@lst.de>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop>
 <20230525093900.GA261009@sernet.de>
 <CAN05THTi0BC_iwjXMiWn61fg3hRemi5Momwp3O0WGygyWLGomQ@mail.gmail.com>
 <ZG+LOKTr8B+zjQsC@jeremy-rocky-laptop>
 <CAH2r5mv7aZ8nm30oKyYpa-bd8-MqA13EcEmQWV4mOyrV-rj8Ug@mail.gmail.com>
 <ZG/DajG6spMO6A7v@jeremy-rocky-laptop>
 <20230525221449.GA9932@sernet.de>
 <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvGb_e-kjLoKpwF3Eg7f7oOGGKcM7rL95SkU4q=pSE1AQ@mail.gmail.com>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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

let's stop calling them RichACLs becuase that was only the name that Andreas
Grünbacher was giving his implementation of the NFS4 ACLs, which however never
mede it upstream to the kernel. Andreas is no longer interested in working on
those actually because because of a long lack of interest by the Kernel
maintainers back in those days. In any case, NFS4 ACLs are the right name, even
if the SMB people don't like the "NFS" in the name.

We have a summary of the state of NFS4 ACLs here:
https://wiki.samba.org/index.php/NFS4_ACL_overview . I recommend taking a
closer look at this.

If cifs.ko would add a mapping of SMB ACLs to the corresponding system.nfs4_acl
EA, this would be nice already but It will only be a limited help if cifs.ko.

The NFS4 ACL model needs to be supported by the Linux kernel also to be really
helpful. The nfs4-acl-tools are there to manage NFS4 ACLs already. To become
really helpful for Linux NFS4 ACLs need to be managable natively and also be
supported with generic filesystems and tools.

I've seen people who abandon to use Linux as client machines because of the
lack of ACL managability. Have in mind that the so called POSIX ACLs are not a
standardized permission model. The POSIX ACLs never passed the status of a
draft standard and the only standardized ACL permission model are in fact the
NFS4 ACLs. One of the main reason why FreeNAS or TrueNAS these days are based
on FreeBSD is the lack of NFS4 ACLs also.

I really wonder why the responsible people in the Kernel developer community
ignore this important topic since so many years. Would be nice to see them join
this thread ...

Björn
