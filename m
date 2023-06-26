Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49C6EB64DA
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 06:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjFZGOA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbjFZGN5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 02:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0356CE66;
        Sun, 25 Jun 2023 23:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B91660C8B;
        Mon, 26 Jun 2023 06:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9042CC433C0;
        Mon, 26 Jun 2023 06:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1687760033;
        bh=54PtTxWRzFP0itf/Mt4orIihn+z6G/UUgX7hBydsugs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hmkF/rPXG9eQj6OGjBFN4dFWFRcGsMKk0gm++h01AQ/avdwPb7yyG7aAnZx4fxs4R
         KDaN0TuRCZzzP+HRruBhFjaSiP7Ds3xczQgS7QM5aiNtvGmBdrG6Huo0cjY/Qv1hIx
         Z/CWyZmFWGASwSNFUgySHcrRxqySr3BKpPtgT9vg=
Date:   Mon, 26 Jun 2023 08:13:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Rishabh Bhatnagar <risbhat@amazon.com>, pc@cjr.nz,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.4 3/5] cifs: Introduce helpers for finding TCP
 connection
Message-ID: <2023062626-bless-cytoplast-a147@gregkh>
References: <20230623213406.5596-1-risbhat@amazon.com>
 <20230623213406.5596-4-risbhat@amazon.com>
 <CANT5p=o3KqnxfLEuJ+veVaK1EdYJapevP60oCSS76-UhuQ101w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=o3KqnxfLEuJ+veVaK1EdYJapevP60oCSS76-UhuQ101w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jun 26, 2023 at 11:34:44AM +0530, Shyam Prasad N wrote:
> On Sat, Jun 24, 2023 at 3:14 AM Rishabh Bhatnagar <risbhat@amazon.com> wrote:
> >
> > From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>
> >
> > commit 345c1a4a9e09dc5842b7bbb6728a77910db69c52 upstream.
> >
> > Add helpers for finding TCP connections that are good candidates for
> > being used by DFS refresh worker.
> >
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
> > ---
> >  fs/cifs/dfs_cache.c | 44 +++++++++++++++++++++++++++++++-------------
> >  1 file changed, 31 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> > index 3ca65051b55c..31b3dc09e109 100644
> > --- a/fs/cifs/dfs_cache.c
> > +++ b/fs/cifs/dfs_cache.c
> > @@ -1305,6 +1305,30 @@ static char *get_dfs_root(const char *path)
> >         return npath;
> >  }
> >
> > +static inline void put_tcp_server(struct TCP_Server_Info *server)
> > +{
> > +       cifs_put_tcp_session(server, 0);
> > +}
> > +
> > +static struct TCP_Server_Info *get_tcp_server(struct smb_vol *vol)
> > +{
> > +       struct TCP_Server_Info *server;
> > +
> > +       server = cifs_find_tcp_session(vol);
> > +       if (IS_ERR_OR_NULL(server))
> > +               return NULL;
> > +
> > +       spin_lock(&GlobalMid_Lock);
> > +       if (server->tcpStatus != CifsGood) {
> > +               spin_unlock(&GlobalMid_Lock);
> > +               put_tcp_server(server);
> > +               return NULL;
> > +       }
> > +       spin_unlock(&GlobalMid_Lock);
> 
> We've moved away from using GlobalMid_Lock for anything other than MIDs.
> Please use server->srv_lock instead.

This is just a backport of a commit that showed up in the 5.6 release.
It's not new development.

thanks,

greg k-h
