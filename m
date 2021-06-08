Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18358C47082
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 09:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE1B61185
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 09:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhFHJ4U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Jun 2021 05:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhFHJ4U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Jun 2021 05:56:20 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107E5C061574
        for <linux-cifs@vger.kernel.org>; Tue,  8 Jun 2021 02:54:28 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id b13so29322553ybk.4
        for <linux-cifs@vger.kernel.org>; Tue, 08 Jun 2021 02:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oWJnTeYW4yAXv0/uOXXTCZfwvWs8b2zQu8ghME4XqSU=;
        b=AnA36HV1vPjKXAP3vDxMrjIlIzbAmWwJjp1kLpuG2DgkyMMfBdBa8JkviQ+RFWUB2C
         Owg4SnW3ZELWxnh7YDpqeFscGCx207TArWUsFakjUZH7+P+PLrNyShDI4WUSHQhy/DHt
         UudlBxq11Ci9tyAbhmhrJLUXtuoZ1BHq84G3cyYrkFk1Xt1eYBUp0xVsDxFIkV1yuci1
         ot68EU6JfUdBCTqIv86venHrLdwQvOtWuz6779bB9jX7bKCiNWHZkf8CMfdQ/BH1u2c0
         59SbE+pAH63yAe5O5/WddVZwYpToqNnWd6IC417DFnz9dT48lLLyOLr4+o7foMhN70u8
         i2gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oWJnTeYW4yAXv0/uOXXTCZfwvWs8b2zQu8ghME4XqSU=;
        b=RJCwY05fGS8UqrFfHrvXbn46SVPghkW2zMHL+dZiLXp9c+TYHbOt0RwSjeWO5lCn9r
         EUf9w3C7DAOwPXCLM/cG5sNb/7nVNM2g/V7XXDy8vxBoYGslAb7TpBWrodLPpTcHXsSS
         mFxKYK+eWPD4nOkNHiEa9+JpV1XwEMscq9kUmJXsAPrhHers3SIoNduZQB8zYRfASvSr
         9CmaQky7e5Pds2J5U1zIV0ESZ6CsjOqVr47nK0B3zzeJRQjdqd0jphxJh4BM8dR0YU8/
         1EfWf+IifnKgcyMGeHeeEBtT5cBjNPEeavjLnTzzLMK8chJIaDQacAj9q23q/QH+7hWt
         l3CQ==
X-Gm-Message-State: AOAM530eZOS3VFfaiIfT0tOmVOxlUzMv6ev6kqQGtC+5hSxnxLeUxUeW
        l8JOEkWadrYeV9vXBu57itT7mONLrd8TVhFu3Mk=
X-Google-Smtp-Source: ABdhPJx7JvnQi3EuJeisEghYe46EWa7dEvKojZsk6rlSAAEqEa88VH31AWvF6pqwBtYdEmyBSuGFTMWzIfuobxQQu1s=
X-Received: by 2002:a25:42d4:: with SMTP id p203mr29869191yba.97.1623146065063;
 Tue, 08 Jun 2021 02:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <875yywp64t.fsf@cjr.nz> <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
 <87y2bpk5xu.fsf@cjr.nz> <CANT5p=ro-sZfc8bPhh7COEp_KBHF6KNzbSV30WyRo2NHLneqAw@mail.gmail.com>
 <CAH2r5muZ_6Eg==AfPKtc4Jiz7kJg+wWDCPSt=7vcLSxwNFu+UA@mail.gmail.com> <CAH2r5muW5Vgx93KrVOZqaueAw44p4sVtSZPLmFExtqRUg6Ufcw@mail.gmail.com>
In-Reply-To: <CAH2r5muW5Vgx93KrVOZqaueAw44p4sVtSZPLmFExtqRUg6Ufcw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 8 Jun 2021 15:24:14 +0530
Message-ID: <CANT5p=qq1w=XzbtByp_jCcOG1jJMdno0EEcvkGi8b-QaRvEKUg@mail.gmail.com>
Subject: Re: Multichannel patches
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Here's a revised list of patches with review comments and fixes:
https://github.com/sprasad-microsoft/smb-kernel-client/pull/7

Please consider this instead of the old patches submitted.

-------

Revised set of patches after reviews and fixes.

Made a bunch of fixes in mchan reconnect scenarios with these patches.
The reconnect codepath did not play well with mchan. Making it work
involved several changes described in the commits.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/36016fc917bec3c324125c203dc1b8d58041ca26.patch
A trivial ref-counting fix in session find codepath.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/6522de38368eaf11306b747e2235d75428fbf487.patch
Fixes in reconnect codepath, involving changes to introduce a
per-channel bitmask for a session, instead of a boolean, and to
reconnect the session only when we have all channels marked for
reconnect. This makes sessions more resilient in mchan scenarios.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/7b591b0b9ea949fbf84bcc3676170fcb7fe8e7ac.patch
Fix to get rid of the serialization of requests during channel
binding. This involved passing the channel server pointer to all
negotiate and session setup related functions. This has increased the
diff size, otherwise the changes are quite minimal.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/83b90f46e37a73bbd563e840d57f519e31f774ed.patch
Fix for getting rid of duplicate fscache cookie warnings for
multichannel scenario.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/394d14080417a037d22db1812a3ca932615fdd25.patch
Adjust DebugData to print connection status of each channel.

On Sat, Jun 5, 2021 at 11:27 PM Steve French <smfrench@gmail.com> wrote:
>
> test run started with those 9 patches (8 multichannel, and Aurelien's
> small patch)
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/11/builds/68
>
> On Sat, Jun 5, 2021 at 12:43 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Had to fix two things in those recently updated patches to get them to
> > build.  You may want to fold those in as well to make the patches
> > clearer to read and bisectable
> >
> > smfrench@smfrench-ThinkPad-P52:~/cifs-2.6/fs/cifs$ git diff -a
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 6e4934052159..f340b7d389ef 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -260,7 +260,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >
> >                 /* If all channels need reconnect, then tcon needs reconnect */
> >                 if (!CIFS_ALL_CHANS_NEED_RECONNECT(ses))
> > -                       goto skip_tcon_reconnect;
> > +                       continue;
> >
> >                 list_for_each(tmp2, &ses->tcon_list) {
> >                         tcon = list_entry(tmp2, struct cifs_tcon, tcon_list);
> > @@ -268,8 +268,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >                 }
> >                 if (ses->tcon_ipc)
> >                         ses->tcon_ipc->need_reconnect = true;
> > -
> > -skip_tcon_reconnect:
> >         }
> >         spin_unlock(&cifs_tcp_ses_lock);
> >         mutex_unlock(&ses->session_mutex);
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index cdbd256be4e4..202d98d06606 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -92,10 +92,10 @@ unsigned long cifs_ses_get_chan_index(struct cifs_ses *ses,
> >  void cifs_chan_set_need_reconnect(struct cifs_ses *ses,
> >                                    struct TCP_Server_Info *server)
> >  {
> > -       size_t chan_index = cifs_ses_get_chan_index(ses, server);
> > +       unsigned long chan_index = cifs_ses_get_chan_index(ses, server);
> >
> >         set_bit(chan_index, &ses->chans_need_reconnect);
> > -       cifs_dbg(FYI, "Set reconnect bitmask for chan %u; now 0x%lx\n",
> > +       cifs_dbg(FYI, "Set reconnect bitmask for chan %lu; now 0x%lx\n",
> >                  chan_index, ses->chans_need_reconnect);
> >
> > On Sat, Jun 5, 2021 at 9:08 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > The buildbot testing once hit a deadlock when running with the above patches.
> > > I found one possibility during cifs_reconnect, where a deadlock can occur.
> > >
> > > I've fixed that and some warnings that kernel bots have identified in
> > > the below two patches:
> > > https://github.com/sprasad-microsoft/smb-kernel-client/pull/5/commits/f3e65f72b03b03bc4b301e8e04e9babb0e9582cf.patch
> > > https://github.com/sprasad-microsoft/smb-kernel-client/pull/5/commits/7b3e867e994a7cbc88efe85c95167ae49d4b7a9d.patch
> > >
> > > Regards,
> > > Shyam
> > >
> > > On Fri, Jun 4, 2021 at 8:55 PM Paulo Alcantara <pc@cjr.nz> wrote:
> > > >
> > > > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > >
> > > > > @Paulo Alcantara That would be great if you can help testing my
> > > > > changes. Please test with these new changes.
> > > >
> > > > OK.
> > > >
> > > > >> The super is only used for providing cifs_sb_info::origin_fullpath as key to find the corresponding failover targets in referral cache.
> > > > > I'm wondering what would happen if there are multiple tcons to the
> > > > > same origin_fullpath (possibly in different sessions)?
> > > >
> > > > That is certainly a problem, indeed.  I'm waiting for the DFS tests to
> > > > finish and then send a series that contains a potential fix for that --
> > > > e.g. not sharing TCP servers when mounting DFS shares.  We used to not
> > > > share tcons with DFS mounts because they might contain different prefix
> > > > paths but connected to same share, however that wasn't enough because
> > > > multiple DFS mounts may connect to same target servers, although they
> > > > might failover to completely different servers.
> > > >
> > > > > Also, doesn't failover targets apply to each channel under a session?
> > > > > Shouldn't we switch targets on reconnect of secondary channels too?
> > > >
> > > > That's a interesting question.  I recall discussing this with Aurelien
> > > > some time ago while running a few DFS + multichannel tests.
> > > >
> > > > So yes, I agree with you that when we successfully reconnect to failover
> > > > target (primary channel), then we should also update all secondary
> > > > channels with the new server's ip address and reconnect them.
> > >
> > >
> > >
> > > --
> > > Regards,
> > > Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Regards,
Shyam
