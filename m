Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACF4C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 15:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbiEWPFg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 11:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbiEWPFf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 11:05:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18095BE41
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 08:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B92B5CE1370
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 15:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16EEC36AE3
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653318329;
        bh=bUpRsXRW7zGlk9x4oQ05qJ8c/FazwjpfC3koG/2vbEM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=j//s8hlsCOpkxnDu73k0UXb8UazTk3806Vr+QD9MiCPg/nh0f2V6Zgz9Cr/nhH1Mx
         ugvqb7kB6X+9royKTKmnK9UF6nW3i9mQIaY9eGKbOvOHl8u9I1Y6TQDxpfrHm/ueTj
         aqhElTh0PJW3W2X1z9PmtZBhUZHNJ7ztJTqDyrvPYh4kKDeagnX7CgWSU4GPDI2qEO
         pACHAJlo42LeLFGNMas4NpBZBoEEEz8KfM38z4Wk4rJc2QKnG7elx1m7Hxaxq6q1WR
         j3BAtzycLjCYda/ZD5CTPia3HQiwWcKwHk8GcxhmxzUziiaCDCe6ipaONsPuGAvIjP
         LI1WC81xgiE2w==
Received: by mail-wr1-f41.google.com with SMTP id p10so3178538wrg.12
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 08:05:28 -0700 (PDT)
X-Gm-Message-State: AOAM531bnygJsFnBWHbjAE1V7CbaaVBYR2ifk4J4cGxyZQAQCa5joEzR
        /cbjEHJQhvFb6lTMZeSXo0IPWA7fmO1QMUfCydo=
X-Google-Smtp-Source: ABdhPJx1PdcdCzKwSHCCmSZGVL8doevnul35VFr3fyng5DDa4DcnCo52lHL4WSkoOLB/O+na9r3j89jEeNMaZGmjrqQ=
X-Received: by 2002:adf:ee52:0:b0:20f:de1d:9fda with SMTP id
 w18-20020adfee52000000b0020fde1d9fdamr4632176wro.62.1653318327136; Mon, 23
 May 2022 08:05:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f344:0:0:0:0:0 with HTTP; Mon, 23 May 2022 08:05:25
 -0700 (PDT)
In-Reply-To: <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com> <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 24 May 2022 00:05:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
Message-ID: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     Tom Talpey <tom@talpey.com>
Cc:     David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-05-23 22:45 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 5/22/2022 7:06 PM, Namjae Jeon wrote:
>> 2022-05-21 20:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>
>>> On 5/20/2022 2:12 PM, David Howells wrote:
>>>> Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>>> SoftROCE is a bit of a hot mess in upstream right now. It's
>>>>> getting a lot of attention, but it's still pretty shaky.
>>>>> If you're testing, I'd STRONGLY recommend SoftiWARP.
>>>>
>>>> I'm having problems getting that working.  I'm setting the client up
>>>> with:
>>>>
>>>> rdma link add siw0 type siw netdev enp6s0
>>>> mount //192.168.6.1/scratch /xfstest.scratch -o
>>>> rdma,user=shares,pass=...
>>>>
>>>> and then see:
>>>>
>>>> CIFS: Attempting to mount \\192.168.6.1\scratch
>>>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6
>>>> too
>>>> small
>>>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>>>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6
>>>> too
>>>> small
>>>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>>>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>>>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6
>>>> too
>>>> small
>>>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>>>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6
>>>> too
>>>> small
>>>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>>>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>>>> CIFS: VFS: cifs_mount failed w/return code = -2
>>>>
>>>> in dmesg.
>>>>
>>>> Problem is, I don't know what to do about it:-/
>>>
>>> It looks like the client is hardcoding 16 sge's, and has no option to
>>> configure a smaller value, or reduce its requested number. That's bad,
>>> because providers all have their own limits - and SIW_MAX_SGE is 6. I
>>> thought I'd seen this working (metze?), but either the code changed or
>>> someone built a custom version.
>> I also fully agree that we should provide users with the path to
>> configure this value.
>>>
>>> Namjae/Long, have you used siw successfully?
>> No. I was able to reproduce the same problem that David reported. I
>> and Hyunchul will take a look. I also confirmed that RDMA work well
>> without any problems with soft-ROCE. Until this problem is fixed, I'd
>> like to say David to use soft-ROCE.
>>
>>> Why does the code require
>>> 16 sge's, regardless of other size limits? Normally, if the lower layer
>>> supports fewer, the upper layer will simply reduce its operation sizes.
>> This should be answered by Long Li. It seems that he set the optimized
>> value for the NICs he used to implement RDMA in cifs.
>
> "Optimized" is a funny choice of words. If the provider doesn't support
> the value, it's not much of an optimization to insist on 16. :)
Ah, It's obvious that cifs haven't been tested with soft-iWARP. And
the same with ksmbd...
>
> Personally, I'd try building a kernel with smbdirect.h changed to have
> SMBDIRECT_MAX_SGE set to 6, and see what happens. You might have to
> reduce the r/w sizes in mount, depending on any other issues this may
> reveal.
Agreed, and ksmbd should also be changed as well as cifs for test. We
are preparing the patches to improve this in ksmbd, rather than
changing/building this hardcoding every time.

diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index a87fca82a796..7003722ab004 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
 } __packed;

 /* Default maximum number of SGEs in a RDMA send/recv */
-#define SMBDIRECT_MAX_SGE      16
+#define SMBDIRECT_MAX_SGE      6
 /* The context for a SMBD request */
 struct smbd_request {
        struct smbd_connection *info;
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index e646d79554b8..70662b3bd590 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -42,7 +42,7 @@
 /* SMB_DIRECT negotiation timeout in seconds */
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120

-#define SMB_DIRECT_MAX_SEND_SGES               8
+#define SMB_DIRECT_MAX_SEND_SGES               6
 #define SMB_DIRECT_MAX_RECV_SGES               1

 /*

Thanks!
>
> Tom.
>
