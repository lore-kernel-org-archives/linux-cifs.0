Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7592FC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 23:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37E2E64E3F
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 23:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhBIXly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 18:41:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233868AbhBIWoP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 17:44:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612910565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZ7uCNlA2uIi2Zywr96bupyWhGmv/tkzQj/R8fIDK/I=;
        b=c79CMMqXTroewiGPEZ2YdcW1087MhjRQva3KlhBnM6uCX02vN/FbCKqpjfsXBVgaajf030
        A9CAQZIEt+eyaTNCIVTvRRMQVXS/gp7gY8V1tvb7bdm+3HxXtrdrkQx7UI7FA/Ah6MozoV
        /A1TearfBSMSdd/OMD/CfOxj5WtVeCI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-OonVfQ94M8KXsTi2yaC--w-1; Tue, 09 Feb 2021 17:42:41 -0500
X-MC-Unique: OonVfQ94M8KXsTi2yaC--w-1
Received: by mail-ej1-f70.google.com with SMTP id 7so270983ejh.10
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 14:42:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GZ7uCNlA2uIi2Zywr96bupyWhGmv/tkzQj/R8fIDK/I=;
        b=rJi+FExFNwPCpTYi++aLfDx1tOY0kB/PcEBZ3L+r8uDZcCJs9X8qaSkt1uny4QU1dR
         nikiv+0Tjj0szrXg/8HkylH+GbEq63j3dc0KJVYm/emrpseBH3WcAlBcScvFL//gYkT+
         KUr8n64m0w2pHqUu926n0OWva7gt+hEsbWJ9jLep4Nb+NTw2WmTF8HERYrGiXLjXzHMx
         sKvsmi6O5VE6Ev8fGX3i9OzWLB610xQ0n0j/J90bBK1rPp+HenRu5X4W+ZNF7MOlSTtU
         7CoTvECkdqkt1/VrxyaIzztzyuHESxoNZs6PaDkXT7AUJc4Ohw9T3AlDNpqWvfe/vpMS
         WzVQ==
X-Gm-Message-State: AOAM532jkDMvuTT2uuQIj81fMuezRzq8gO8mdxJ5gfsMTD2e525esZNs
        nERsr9DwsQwah8B3Qf6sYUgyLoJxoMYQBmmFh10o4WulyQDBlB6tE8MAEqboo3kT7bT2kdpfSdT
        URfGRsfUBD6dYhSpXoJS5ofoZXwu6drlHWKmzDg==
X-Received: by 2002:a17:906:b351:: with SMTP id cd17mr24871295ejb.110.1612910560580;
        Tue, 09 Feb 2021 14:42:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWZ/SxMb2EYr3Wx/r9tLm+ytvzx5rNbM3Mu7nYLvi+QXirS/jRZBjDCWHtM3Wa2pEsJ4PdxjPocMuO52GFZ9o=
X-Received: by 2002:a17:906:b351:: with SMTP id cd17mr24871281ejb.110.1612910560352;
 Tue, 09 Feb 2021 14:42:40 -0800 (PST)
MIME-Version: 1.0
References: <591237.1612886997@warthog.procyon.org.uk> <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
In-Reply-To: <CAHk-=wj-k86FOqAVQ4ScnBkX3YEKuMzqTEB2vixdHgovJpHc9w@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 9 Feb 2021 17:42:04 -0500
Message-ID: <CALF+zOkMKqvidLf8WZD889PUN-KofdiRPOcbO4hxboVmUGiOgw@mail.gmail.com>
Subject: Re: [GIT PULL] fscache: I/O API modernisation and netfs helper library
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@redhat.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        ceph-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cachefs <linux-cachefs@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 9, 2021 at 2:07 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So I'm looking at this early, because I have more time now than I will
> have during the merge window, and honestly, your pull requests have
> been problematic in the past.
>
> The PG_fscache bit waiting functions are completely crazy. The comment
> about "this will wake up others" is actively wrong, and the waiting
> function looks insane, because you're mixing the two names for
> "fscache" which makes the code look totally incomprehensible. Why
> would we wait for PF_fscache, when PG_private_2 was set? Yes, I know
> why, but the code looks entirely nonsensical.
>
> So just looking at the support infrastructure changes, I get a big "Hmm".
>
> But the thing that makes me go "No, I won't pull this", is that it has
> all the same hallmark signs of trouble that I've complained about
> before: I see absolutely zero sign of "this has more developers
> involved".
>
> There's not a single ack from a VM person for the VM changes. There's
> no sign that this isn't yet another "David Howells went off alone and
> did something that absolutely nobody else cared about".
>

I care about it.

I cannot speak to your concerns about the infrastructure changes, nor
can I comment about a given maintainers involvement or lack thereof.
However, I can tell you what my involvement has been.  I got involved
with it because some of our customers use fscache with NFS and I've
supported it.  I saw dhowells rewriting it to greatly simplify the
code and make it easier to debug and wanted to support the effort.

I have been working on the NFS conversion as dhowells has been
evolving the fscache-iter API.  David first posted the series I think
in Dec 2019 and I started with NFS about mid-year 2020, and had my
first post of NFS patches in July:
https://marc.info/?l=linux-nfs&m=159482591232752&w=2

One thing that came out of the earlier iterations as a result of my
testing was the need for the network filesystem to be able to 'cap'
the IO size based on its parameters, hence the "clamp_length()"
function.  So the next iteration dhowells further evolved it into a
'netfs' API and a 'fscache' API, and my November post was based on
that:
https://marc.info/?l=linux-nfs&m=160596540022461&w=2

Each iteration has greatly simplified the interface to the network
filesystem until today where the API is pretty simple.  I have done
extensive tests with each iteration with all the main NFS versions,
specific unit tests, xfstests, etc.  However my test matrix did not
hit enough fscache + pNFS servers, and I found a problem too late to
include in his pull request.  This is mostly why my patches were not
included to convert NFS to the new fscache API, but I intend to work
out the remaining issues for the next merge window, and I'll have an
opportunity to do more testing last week of Feb with the NFS "remote
bakeathon".  My most recent post was at the end of Jan, and Anna is
taking the first 5 refactoring patches in the next merge window:
https://marc.info/?l=linux-nfs&m=161184595127618&w=2

I do not have the skills of a Trond or Anna NFS developers, but I have
worked in this in earnest and intend to see it through to completion
and support NFS and fscache work.  I have received some feedback on
the NFS patches though it's not been a lot, I do know I have some
things to address still.  With open source, no feedback is hard to
draw conclusions other than it's not "super popular" area, but we
always knew that about fscache - it's an "add on" that some customers
require but not everyone. I know Trond speaks up when I make a mistake
and/or something will cause a problem, so I consider the silence
mostly a positive sign.



> See my problem? I need to be convinced that this makes sense outside
> of your world, and it's not yet another thing that will cause problems
> down the line because nobody else really ever used it or cared about
> it until we hit a snag.
>
>                   Linus
>

