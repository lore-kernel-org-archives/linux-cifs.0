Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C4EC4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Jan 2023 06:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjADGOd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Jan 2023 01:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjADGOa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Jan 2023 01:14:30 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7483183B2
        for <linux-cifs@vger.kernel.org>; Tue,  3 Jan 2023 22:14:28 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id bf43so49028714lfb.6
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jan 2023 22:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7qLAJ8QLgWzTuMG2kz7xtNQEOKmFgfrm43QFAh0/+Dc=;
        b=IZmQ0bubw7HS9vJIVX8E2GG3IefPTIvNbkVIIzeWQ0+JSdOP5M93ZF4/sAXtRsKs4x
         l3PV4sI0SYlefBbfdwUCJ8WA1OUjm9zRN8S3EYjzBZXH42PlXHVIX6nBNXPWPe1+D9np
         RQsliAfxbkYuDJxL5uN+oscQFmj8MA0Xa5IQaTfNPE7nK8aYK26O2WELEfXBPRVfQ+hj
         pUvdd/CANiWKiJ4/t3xN2xsLG6ynVteeuZYeeuDZ0MTVuxdtX8KhPdCa+KA42Ylx16Ns
         M/iA5eQD+uz79zRSN8rMTw8to1trupu3rxYCrEtfhSwGbBHCYEkKs/TXuEI5M13ZTR9M
         49CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7qLAJ8QLgWzTuMG2kz7xtNQEOKmFgfrm43QFAh0/+Dc=;
        b=71pVwQmGDD9LBR8XVfVAA0RMb/q+s9NAnE4DjqGeAnpwZQ1s1YSlGQ6TSVz4RggWyc
         9axyM5VcaBZSpGrfvAsOOEaY/AAwvqdVDpEXBt1XcswpWitfHm7m4ElrW+TPHbwdRcMm
         FG8ZbgD8Hw2+xxAmVtqsIe+XeZA1TiAcZLiwtQRsGG6rXxybSqDd/vjnTQAr+5c2ddGK
         Jq5HMXSb5EpeHqFRxJMI/OIAU1Ii15gBKsNDVbBCcYi0rBiAueDcv8NhgltcuG3Bw7r6
         FB5nqStRm//Fn4/koNh32Wqq3UvwlepafIQZ31rYM50SerN+Ybex+LLxKBRrorzDswCO
         YDuQ==
X-Gm-Message-State: AFqh2kpYvWKNS4KNoqlFre5MOmU/+7w11Xq+rS56EJ6WljLQA0qAakpD
        Ei8f9wRfOeO8vP+cDMs2VliMEX5/4IB15G4FosIVMA/D
X-Google-Smtp-Source: AMrXdXtSq+DNUDxnN95wLN8YpfW6ZV9AYatq9qfNoNrQxtOzcQB4HJTYR7OiTta/cO5pWriOw2xE2PJW+ZrWTeF3w+U=
X-Received: by 2002:a05:6512:3d28:b0:4a2:2c4b:8138 with SMTP id
 d40-20020a0565123d2800b004a22c4b8138mr2315569lfv.14.1672812866872; Tue, 03
 Jan 2023 22:14:26 -0800 (PST)
MIME-Version: 1.0
References: <20221229153356.8221-1-pc@cjr.nz> <20221229153356.8221-2-pc@cjr.nz>
 <20221229201448.bzxqnsea52zcb4xw@suse.de> <CAH2r5mso6PLpKpVxtcUHW4RQ1jc-Tmj5ALOEba2z+40uSDf0JA@mail.gmail.com>
In-Reply-To: <CAH2r5mso6PLpKpVxtcUHW4RQ1jc-Tmj5ALOEba2z+40uSDf0JA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Jan 2023 00:14:15 -0600
Message-ID: <CAH2r5mu+C0kxvdg8XEyYJYaZQc0Q2EzddtwwLPmzR4=djsQmOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: fix race in assemble_neg_contexts()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 4, 2023 at 12:12 AM Steve French <smfrench@gmail.com> wrote:
>
> merged into cifs-2.6.git for-next
>
> On Thu, Dec 29, 2022 at 2:14 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> On 12/29, Paulo Alcantara wrote:
>> >Serialise access of TCP_Server_Info::hostname in
>> >assemble_neg_contexts() by holding the server's mutex otherwise it
>> >might end up accessing an already-freed hostname pointer from
>> >cifs_reconnect() or cifs_resolve_server().
>> >
>> >Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>>
>> Couldn't reproduce this one as easy as the other one, but it makes sense
>> anyway.
>>
>> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>>
>> >---
>> > fs/cifs/smb2pdu.c | 11 +++++++----
>> > 1 file changed, 7 insertions(+), 4 deletions(-)
>> >
>> >diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> >index a5695748a89b..2c484d47c592 100644
>> >--- a/fs/cifs/smb2pdu.c
>> >+++ b/fs/cifs/smb2pdu.c
>> >@@ -541,9 +541,10 @@ static void
>> > assemble_neg_contexts(struct smb2_negotiate_req *req,
>> >                     struct TCP_Server_Info *server, unsigned int *total_len)
>> > {
>> >-      char *pneg_ctxt;
>> >-      char *hostname = NULL;
>> >       unsigned int ctxt_len, neg_context_count;
>> >+      struct TCP_Server_Info *pserver;
>> >+      char *pneg_ctxt;
>> >+      char *hostname;
>> >
>> >       if (*total_len > 200) {
>> >               /* In case length corrupted don't want to overrun smb buffer */
>> >@@ -574,8 +575,9 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>> >        * secondary channels don't have the hostname field populated
>> >        * use the hostname field in the primary channel instead
>> >        */
>> >-      hostname = CIFS_SERVER_IS_CHAN(server) ?
>> >-              server->primary_server->hostname : server->hostname;
>> >+      pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
>> >+      cifs_server_lock(pserver);
>> >+      hostname = pserver->hostname;
>> >       if (hostname && (hostname[0] != 0)) {
>> >               ctxt_len = build_netname_ctxt((struct smb2_netname_neg_context *)pneg_ctxt,
>> >                                             hostname);
>> >@@ -584,6 +586,7 @@ assemble_neg_contexts(struct smb2_negotiate_req *req,
>> >               neg_context_count = 3;
>> >       } else
>> >               neg_context_count = 2;
>> >+      cifs_server_unlock(pserver);
>> >
>> >       build_posix_ctxt((struct smb2_posix_neg_context *)pneg_ctxt);
>> >       *total_len += sizeof(struct smb2_posix_neg_context);
>> >--
>> >2.39.0
>> >
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
