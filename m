Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2A0C433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Feb 2021 18:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3D764E29
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Feb 2021 18:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBTSSn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Feb 2021 13:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhBTSSn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Feb 2021 13:18:43 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFC6C061574
        for <linux-cifs@vger.kernel.org>; Sat, 20 Feb 2021 10:18:02 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hs11so22137963ejc.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Feb 2021 10:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=T7NgBNx+OMHrp9qNYyTl565o7Lma6CuD9ZPuocJtTOg=;
        b=MaunoyviVWagBdIbOwnue4U3rx3PzF9A6tSotc7KB50H8nOUeu2FfHem9qcB5EAEBI
         lHM7I/K083Pn2ytsQTWpHWxPtb6eXINMcPsK9s8DbJejO4w6EkbnCBK//rKdRHSuo2iz
         Xxgl49CxznqZPpR+bX14Az6/SghGY6i6Bbllh/zayWMD4lIwtLUsM+TJer5znsJL6KHO
         eF++BXjLntoi+qVe6jyaZNg+ZL2U0zSUVVyF4IFbDzmYsucpU2nNkj0g8xBWhfELliXT
         LAuAfRZjhdmDzkxxFniyvPGCCIKdjAnBje3/Kdyzdu9+91DcLR9IaLWE9D49/xZ3DtVj
         Ip9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T7NgBNx+OMHrp9qNYyTl565o7Lma6CuD9ZPuocJtTOg=;
        b=g0evFy/jA9tszcp1qvYJvO74dp0TQ37g3uTduUGIkZJ5jB3nDcLpYrdVzafKNg0elC
         1RUa48GoHP8AbHm4oHq68UfXFM8b/Gc/rGLAlZKjLBK3jQTwHaphCKc7ilvGQ0Z77IXX
         IO2lzx3IiIMzLo1QvvPVKnSgteSbo+1a/YK7upG9HK3ZMgKFiOdbOxScijWzug3GXNtr
         kJ8NerOt5m2FeiFob42FQlXz3DxjE3xAvT1cpQEnskZ22jb06XSu6pJ9YNWRGGg8TRwo
         Jl2CR5cnAG50STZCSK56umY8nJDsgSVWIyLXkMFsFFBIzPu++SdQmvUoiKAZUMjLp+ic
         s/eg==
X-Gm-Message-State: AOAM532rH6e+fg2aVykyFrzWwS3bIFIl9yipIhZf2JaS1xjw0WcFFzYk
        GOMNmFl/BVe5bM1QipGRLc3hGoFEpM8TEsdDdLjqXnVqSbJp
X-Google-Smtp-Source: ABdhPJyBqHGX2RmFoBXUQOLRZMoB/orfrSKBqgqitIU08a6SxcGASWNx2nMQmwbzSS1H7x3c+qN6sD6kquInbDd366Y=
X-Received: by 2002:a17:906:15cc:: with SMTP id l12mr13965839ejd.280.1613845081628;
 Sat, 20 Feb 2021 10:18:01 -0800 (PST)
MIME-Version: 1.0
References: <1A318EB9-A257-4A11-B319-EA3F2628C8B7@hxcore.ol>
 <CAKywueROT6yAn6Eer4sncxsaZZyih3kApKmLacb3xsxDJfWfMQ@mail.gmail.com> <80BC289A-88D1-45CB-A751-0382211ED4B8@hxcore.ol>
In-Reply-To: <80BC289A-88D1-45CB-A751-0382211ED4B8@hxcore.ol>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 20 Feb 2021 10:17:50 -0800
Message-ID: <CAKywueRuwHXG65i6XQknXgqtQ+=AdrLCCqft+vwE5XFLWwo=Gw@mail.gmail.com>
Subject: Re: TCON reconnect during STATUS_NETWORK_NAME_DELETED
To:     Rohith <rohiths.msft@gmail.com>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "sribhat.msa@outlook.com" <sribhat.msa@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 08:10, Rohit=
h <rohiths.msft@gmail.com>:
>
> Hi Pavel,
>
>
>
> Addressed review comments. Can you please take a look.
>
>
>
> >> Btw, I think is_status_io timeout should be called in this loop for
>
> >> every mid not outside the loop (sorry, missed that in the original
>
> >> review). Could you please fix that separately?
>
>
>
> Yes, will send out different patch for status_io_timeout.

Thanks!

The patch looks good. Please find my minor comments below:

1.
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 10fe6d6d2dee..b2f51546c2ef 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -993,6 +993,10 @@ cifs_demultiplex_thread(void *p)
  if (mids[i] !=3D NULL) {
  mids[i]->resp_buf_size =3D server->pdu_size;

+ if (server->ops->is_network_name_deleted) {
+         server->ops->is_network_name_deleted(bufs[i],
+                              server);
+ }

^^^
remove extra {}

2.
+static void
+smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
+{
+ struct smb2_sync_hdr *shdr =3D (struct smb2_sync_hdr *)buf;

+ struct list_head *tmp, *tmp1;
+ struct cifs_ses *ses;
+ struct cifs_tcon *tcon;
+
+ if (shdr->Status =3D=3D STATUS_NETWORK_NAME_DELETED) {

^^^
let's do the opposite check: if status is not
STATUS_NETWORK_NAME_DELETED then return immediately from the function.
This will remove overall indentation for the nested for loops.

3.
@@ -4605,6 +4632,10 @@ static void smb2_decrypt_offload(struct
work_struct *work)
 #ifdef CONFIG_CIFS_STATS2
  mid->when_received =3D jiffies;
 #endif
+ if (dw->server->ops->is_network_name_deleted) {
+         dw->server->ops->is_network_name_deleted(dw->buf,
+                                  dw->server);
+ }

^^^
remove extra {}

--
Best regards,
Pavel Shilovsky
