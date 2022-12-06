Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7003C47090
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Dec 2022 06:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiLFGhD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Dec 2022 01:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLFGhD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Dec 2022 01:37:03 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440B3220D1
        for <linux-cifs@vger.kernel.org>; Mon,  5 Dec 2022 22:37:02 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 003C66732D; Tue,  6 Dec 2022 07:36:57 +0100 (CET)
Date:   Tue, 6 Dec 2022 07:36:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Steve French <sfrench@samba.org>,
        Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        David Howells <dhowells@redhat.com>
Subject: Re: RFC: remove cifs_writepage
Message-ID: <20221206063657.GA6939@lst.de>
References: <20221116131835.2192188-1-hch@lst.de> <CAH2r5msoMJ6jNFDtHigKOqq9EwxEb9buxGVi8duW8EMz6wwgBg@mail.gmail.com> <20221204081913.GB26937@lst.de> <CAH2r5mvZh+5S74fec0o8EGf+OdjP4LaRKsK-FKh-ctf4uzHX0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mvZh+5S74fec0o8EGf+OdjP4LaRKsK-FKh-ctf4uzHX0Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Dec 05, 2022 at 06:22:12PM -0600, Steve French wrote:
> Ran some tests today with the three patch (remove writepage for
> cifs.ko) series.  Let me know if any updates for those.  Also let me
> know which gti branch you would like to see these merged from (mine or
> yours e.g.)

If they work and look fine to you please queue them up in the cifs
tree as-is.

> I did see an intermittent  failure (when run with these three patches)
> that doesn't appear to be obviously related to yours but am still
> investigating it.   Test 043 failed once, and on one of retries of the
> group  -  test 045 failed once. See example below.  This looks related
> to an issue with deferred close (handle leases) and reference counts
> holding up unmount, and not related to these patches (at least at
> first glance).   Continuing to debug

Yes.  I have no good idea but to may suggest what NFS does about
silly renamed inodes to ensure they don't try to get in the way
of mount.
