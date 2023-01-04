Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38301C46467
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Jan 2023 06:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjADGOO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Jan 2023 01:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjADGON (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Jan 2023 01:14:13 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFE41582F
        for <linux-cifs@vger.kernel.org>; Tue,  3 Jan 2023 22:14:11 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id v25so1602566lfe.12
        for <linux-cifs@vger.kernel.org>; Tue, 03 Jan 2023 22:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sDZt+OUEMk33IyjiPH1bLca16LOkhf7ByuRNP9e7gVM=;
        b=kazS2uhrAAaK0MFzloiuFkles46MYKycn87b0jGuTx/lHc1AyHj3BWTEvTbm5pw9G+
         JGRgJSV/kI5dQRF1r7uVaPMI7Ex4C395N6IGBtAhu7Dj1gcyWD1U+hQw2Kh2WoUeWKPe
         wJIZmeYd3bc1ywjnBadu1YNEjyyKRPVbY9TKVWUyzxdIpCwT9kz3Mrue862fKkUCXnpz
         4GxD6AVTGotoLyWf5tYw4p0h2FIyKAni8AzTyVLNW3UmDTAI6y65ieHYr2ucCceDcph5
         3yHYk4FYftbw/YYHeAM3kLXAOrdELKPZtM7Rbwr2dKBVDyAZSs65k5KV4vWp5mu3kVGT
         DhAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sDZt+OUEMk33IyjiPH1bLca16LOkhf7ByuRNP9e7gVM=;
        b=1g5u6AoQgA290q2Tlq1Zy6xmYIw3asWVGU4CxibVFU+g0haoNkUASrk+xet+GdkdXx
         69GjdPlDlhcu8g9RXF4X6ncEtWTUqy5pxPPTAzKfw/p8YIhWlSQRiSw6Qh/CuoJtAiWU
         nsymhKqdma1NbZ6dQXJzh1zwH2APcCQ5Agd2Y+WRN1qQEcVKle+2OBcC/Pulyq0C/2k8
         vFx4NruOvMMNvUasE+3ghDMMMDZ56q50T4PhgyExv94dJm1c/SGLPcHOFydQfQ4t9xDG
         /Hz+BZIRXBxHZ1ILoGUTN2vUR8qVrz6CWjRmgoqJsHCycrcKb5dEN3b6D8KJUWX1CE5H
         LkeA==
X-Gm-Message-State: AFqh2ko0tO6TBA6H+4azm1+Do2wyJ5pEx35EEJ9SYERfsXGPE9CZaAOV
        Sp9wp/zOaf9enWHvmIQNpTQSj7UT7i0jkn2a+FoMbUe1
X-Google-Smtp-Source: AMrXdXsDxtP7rKvJMuEHABanI/t8dWTpPdY1mCgn/0V4sno1XpXwmUvm+D5BDXrmPTUnqZjFnQojzquR/k4/+cFr1B8=
X-Received: by 2002:a05:6512:14d:b0:4cb:3a2f:26d1 with SMTP id
 m13-20020a056512014d00b004cb3a2f26d1mr376599lfo.303.1672812849975; Tue, 03
 Jan 2023 22:14:09 -0800 (PST)
MIME-Version: 1.0
References: <20221229153356.8221-1-pc@cjr.nz> <20221229201029.lajhejwbbtca6poc@suse.de>
 <CAH2r5mv-2MPzd-zJSxDXh5avC4Bhp-BJG9nmr2f=1FR5m6B3Zg@mail.gmail.com>
In-Reply-To: <CAH2r5mv-2MPzd-zJSxDXh5avC4Bhp-BJG9nmr2f=1FR5m6B3Zg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Jan 2023 00:13:58 -0600
Message-ID: <CAH2r5msnXZXKYQD3sVKig0MWzrRo7rth1BVuFsvboWcO0J7eeg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: ignore ipc reconnect failures during dfs failover
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 4, 2023 at 12:13 AM Steve French <smfrench@gmail.com> wrote:
>
> merged into cifs-2.6.git for-next
>
> On Thu, Dec 29, 2022 at 2:10 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> On 12/29, Paulo Alcantara wrote:
>> >If it failed to reconnect ipc used for getting referrals, we can just
>> >ignore it as it is not required for reconnecting the share.  The worst
>> >case would be not being able to detect or chase nested links as long
>> >as dfs root server is unreachable.
>> >
>> >Before patch:
>> >
>> >  $ mount.cifs //root/dfs/link /mnt -o echo_interval=10,...
>> >    -> target share: /fs0/share
>> >
>> >  disconnect root & fs0
>> >
>> >  $ ls /mnt
>> >  ls: cannot access '/mnt': Host is down
>> >
>> >  connect fs0
>> >
>> >  $ ls /mnt
>> >  ls: cannot access '/mnt': Resource temporarily unavailable
>> >
>> >After patch:
>> >
>> >  $ mount.cifs //root/dfs/link /mnt -o echo_interval=10,...
>> >    -> target share: /fs0/share
>> >
>> >  disconnect root & fs0
>> >
>> >  $ ls /mnt
>> >  ls: cannot access '/mnt': Host is down
>> >
>> >  connect fs0
>> >
>> >  $ ls /mnt
>> >  bar.rtf  dir1  foo
>> >
>> >Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>>
>> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>>
>> >---
>> > fs/cifs/dfs.c | 3 +--
>> > 1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> >diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
>> >index b541e68378f6..30086f2060a1 100644
>> >--- a/fs/cifs/dfs.c
>> >+++ b/fs/cifs/dfs.c
>> >@@ -401,8 +401,7 @@ static int __tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *t
>> >               if (ipc->need_reconnect) {
>> >                       scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", server->hostname);
>> >                       rc = ops->tree_connect(xid, ipc->ses, tree, ipc, cifs_sb->local_nls);
>> >-                      if (rc)
>> >-                              break;
>> >+                      cifs_dbg(FYI, "%s: reconnect ipc: %d\n", __func__, rc);
>> >               }
>> >
>> >               scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
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
