Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CE8C4743D
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 17:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136F66141C
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Jun 2021 17:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFERpn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Jun 2021 13:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhFERpn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 5 Jun 2021 13:45:43 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B37C061766
        for <linux-cifs@vger.kernel.org>; Sat,  5 Jun 2021 10:43:54 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id c11so15911261ljd.6
        for <linux-cifs@vger.kernel.org>; Sat, 05 Jun 2021 10:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UvR6Yd5mKo67biWwQQd7nCraMJ/qYOX844VTXiSJ8q0=;
        b=hbnZ1Vm7RSPCltNKHYM63OqzImK0OsfkETpbj7d+u3Vu5iwvLK9SCKH28ACWSSpb9s
         CDM4izP53xAdMQHBm81OTTSePUgZBS5MWBU3GiGLfKUzaZX/J3Trtw2XmLsB3bNfOnDF
         boyRBZo5esffd0/nnHdLVbRwLdBVXAvNIxVygb3Z4k27kdeDDqQN9IyDWCfLJSdD1oyK
         3JDkP3n6DhaXPrwNQBJJUN+N897WUqfJmvFHD5J1Pi52qidAIPmrKQLbW+792iwMQXhu
         cTaiKZlCn+Kgp2Nb+vCKDyK1jiihA+cPK6TNCfv0rBuvQVFNpu8Ecum9WMlGw4gTZ3gt
         +JKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UvR6Yd5mKo67biWwQQd7nCraMJ/qYOX844VTXiSJ8q0=;
        b=JjtfRdyBVLB4HbuvzQPW/ghQfffzIl7zZSQhHVrt5yTKgrxRKxwpHonmHtmkWtEAja
         AAAjnZ4wGAuSHcgVboEUWbwLIFyuMUaPY4hYwPRegBNGwHNcWUXY6F+dAIM1iH2QKDzi
         1hq2P1sRTWtgI/giIqKMplU22gHPuqgtnqSzJcNF1xxlBotTQrBFhldW4y+zVnnz8pzh
         YuBsavkVW7jjVkbnGOGLivTHZZjmu7+mOECpuzLzzxrq1ewbeeFW45KPCfVmI5dFavxr
         Cj28/cEDm+R5bxjuQDVWn3Be4ryHPP53GIHXbKJTjnz39tTDv/vaWn00TsZF3RlsZC4E
         DZMA==
X-Gm-Message-State: AOAM531LRB+BzE0Y+W5vQmyTE1tIn+WTQfzrq9iD6+NTJJ7oYHuSQ3lp
        yq2aSzq4RRa0O1bq4Q1kP4Do0p0PJcz0OLu32Qs=
X-Google-Smtp-Source: ABdhPJwRq1PqaFPvCrOCK8ZrLqCB7jwEt+M8t9C7oUwoWIuBbohzeaWthdu6OfQNKpSdwwE2a4XVWFSmUKFioRzby0U=
X-Received: by 2002:a2e:2285:: with SMTP id i127mr8363070lji.272.1622915030613;
 Sat, 05 Jun 2021 10:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <875yywp64t.fsf@cjr.nz> <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
 <87y2bpk5xu.fsf@cjr.nz> <CANT5p=ro-sZfc8bPhh7COEp_KBHF6KNzbSV30WyRo2NHLneqAw@mail.gmail.com>
In-Reply-To: <CANT5p=ro-sZfc8bPhh7COEp_KBHF6KNzbSV30WyRo2NHLneqAw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 5 Jun 2021 12:43:39 -0500
Message-ID: <CAH2r5muZ_6Eg==AfPKtc4Jiz7kJg+wWDCPSt=7vcLSxwNFu+UA@mail.gmail.com>
Subject: Re: Multichannel patches
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Had to fix two things in those recently updated patches to get them to
build.  You may want to fold those in as well to make the patches
clearer to read and bisectable

smfrench@smfrench-ThinkPad-P52:~/cifs-2.6/fs/cifs$ git diff -a
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6e4934052159..f340b7d389ef 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -260,7 +260,7 @@ cifs_reconnect(struct TCP_Server_Info *server)

                /* If all channels need reconnect, then tcon needs reconnect */
                if (!CIFS_ALL_CHANS_NEED_RECONNECT(ses))
-                       goto skip_tcon_reconnect;
+                       continue;

                list_for_each(tmp2, &ses->tcon_list) {
                        tcon = list_entry(tmp2, struct cifs_tcon, tcon_list);
@@ -268,8 +268,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
                }
                if (ses->tcon_ipc)
                        ses->tcon_ipc->need_reconnect = true;
-
-skip_tcon_reconnect:
        }
        spin_unlock(&cifs_tcp_ses_lock);
        mutex_unlock(&ses->session_mutex);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index cdbd256be4e4..202d98d06606 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -92,10 +92,10 @@ unsigned long cifs_ses_get_chan_index(struct cifs_ses *ses,
 void cifs_chan_set_need_reconnect(struct cifs_ses *ses,
                                   struct TCP_Server_Info *server)
 {
-       size_t chan_index = cifs_ses_get_chan_index(ses, server);
+       unsigned long chan_index = cifs_ses_get_chan_index(ses, server);

        set_bit(chan_index, &ses->chans_need_reconnect);
-       cifs_dbg(FYI, "Set reconnect bitmask for chan %u; now 0x%lx\n",
+       cifs_dbg(FYI, "Set reconnect bitmask for chan %lu; now 0x%lx\n",
                 chan_index, ses->chans_need_reconnect);

On Sat, Jun 5, 2021 at 9:08 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> The buildbot testing once hit a deadlock when running with the above patches.
> I found one possibility during cifs_reconnect, where a deadlock can occur.
>
> I've fixed that and some warnings that kernel bots have identified in
> the below two patches:
> https://github.com/sprasad-microsoft/smb-kernel-client/pull/5/commits/f3e65f72b03b03bc4b301e8e04e9babb0e9582cf.patch
> https://github.com/sprasad-microsoft/smb-kernel-client/pull/5/commits/7b3e867e994a7cbc88efe85c95167ae49d4b7a9d.patch
>
> Regards,
> Shyam
>
> On Fri, Jun 4, 2021 at 8:55 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> >
> > > @Paulo Alcantara That would be great if you can help testing my
> > > changes. Please test with these new changes.
> >
> > OK.
> >
> > >> The super is only used for providing cifs_sb_info::origin_fullpath as key to find the corresponding failover targets in referral cache.
> > > I'm wondering what would happen if there are multiple tcons to the
> > > same origin_fullpath (possibly in different sessions)?
> >
> > That is certainly a problem, indeed.  I'm waiting for the DFS tests to
> > finish and then send a series that contains a potential fix for that --
> > e.g. not sharing TCP servers when mounting DFS shares.  We used to not
> > share tcons with DFS mounts because they might contain different prefix
> > paths but connected to same share, however that wasn't enough because
> > multiple DFS mounts may connect to same target servers, although they
> > might failover to completely different servers.
> >
> > > Also, doesn't failover targets apply to each channel under a session?
> > > Shouldn't we switch targets on reconnect of secondary channels too?
> >
> > That's a interesting question.  I recall discussing this with Aurelien
> > some time ago while running a few DFS + multichannel tests.
> >
> > So yes, I agree with you that when we successfully reconnect to failover
> > target (primary channel), then we should also update all secondary
> > channels with the new server's ip address and reconnect them.
>
>
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
