Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BA3C433E3
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 11:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67997619A1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Mar 2021 11:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhCVLbL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbhCVLau (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 07:30:50 -0400
Received: from mail.sernet.de (mail.sernet.de [IPv6:2a0a:a3c0:0:25::217:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBE8C061574
        for <linux-cifs@vger.kernel.org>; Mon, 22 Mar 2021 04:30:50 -0700 (PDT)
Received: from intern.sernet.de by mail.sernet.de
        with esmtps (Exim Mail Transfer Agent)
        id 1lOIle-0000XQ-CB; Mon, 22 Mar 2021 12:30:42 +0100
Received: by intern.sernet.de
        id 1lOIle-0001h2-9Z; Mon, 22 Mar 2021 12:30:42 +0100
Received: from bjacke by pell.sernet.de with local (Exim 4.93)
        (envelope-from <bjacke@sernet.de>)
        id 1lOIle-004F44-3A; Mon, 22 Mar 2021 12:30:42 +0100
Date:   Mon, 22 Mar 2021 12:30:42 +0100
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@sernet.de>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?iso-8859-1?Q?Aur=E9lien?= Aptel <aaptel@suse.com>,
        Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net
Subject: Re: we actually need richacls ...
Message-ID: <20210322113042.GA1001620@sernet.de>
References: <bug-14494-10630@https.bugzilla.samba.org/>
 <bug-14494-10630-dugIJZXmUw@https.bugzilla.samba.org/>
 <20210318075025.GA600594@sernet.de>
 <CAH2r5msva0XmGjNMonOp0PtXXi5aJeAZ92Cr_MeohEwhzK-kWQ@mail.gmail.com>
 <CAN05THTtitSbSEbXtFDJUB3dpTzBFEh5bQLSE=mSheLrsvvNrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN05THTtitSbSEbXtFDJUB3dpTzBFEh5bQLSE=mSheLrsvvNrA@mail.gmail.com>
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2021-03-20 at 16:35 +1000 ronnie sahlberg sent off:
> What we are talking about is NTFS semantics and how to integrate it
> into a posix environment like Linux.

as we are talking here about Unix systems, let's call what we're talking about
NFS4 ACLs. See:

https://wiki.samba.org/index.php/NFS4_ACL_overview


> We are not going to implement NTFS semantics in the kernel, that train
> left the station 20 years ago.

the train of NFS4 ACLs in Linux actually didn't leave the station at all, it's
still in the station waiting for lights switching to green :)


> What we can do is to try to emulate. Try to map NTFS onto posix in a
> way that makes most sense for most
> average people.

As mapping the ACLs is too lossy, cifs has the cifsacl mount option, but that
is buggy, issues with that don't get a lot of attention.


> But that is it. We can never do 100% ntfs.

true, this why Samba started the acl_xattr to manage the ACLs on its own in
userspace. This is making it difficult to manage though as you have to do that
through the SMB layser then only. Also no interoperability with native file
access or different layers like NFS is impossible with that. The acl_xattr
modules was born out of pitty that we're in that we lack NFS4 ACLs on Linux.


> And we cover the main use cases.

with "cover most use cases" you are still talking generally about POSIX draft
ACLs vs. NFS4 ACLs here?

> Are there use cases where the mappings will not work becasue we are
> not NTFS? Very likely.

lot's of cases. Starting from the concept of ACL inheritence which doesn't
exist in POSIX draft ACLs at all (no, POSIX draft default ACLs are not
comparable with it).


> Maybe those use cases that require full 100% NTFS semantics should
> just use windows?

you want to ask people who need NFS4 ACLs to use Windows, seriously? I rather
recommend using other Unix systems that support NFS4 ACLs. Actually all other
actively developed Unix systems do support NFS4 ACLS.

Customers, who want to use SMB also for their Linux clients, give up quite
soon because of the shortcomings of the permission management.. Without native
NFS4 ACLs this will probably not change - this is why I ask the cifs vfs and
the cifsd people here to help push to get NFS4 ACLs aka richacls in he kernel
vfs layer.

You know that POSIX draft ACLs had never been finally standrarized, they were
were withdrawn in 1997. However NFS4 ACLs are standarized.


> If not, patches sent to the mailinglist are welcome.

Andreas Grünbacher sent working patches long time ago, see the links from
the wiki article above.

Björn
