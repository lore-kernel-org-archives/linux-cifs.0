Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D69BAC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Mar 2022 22:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbiCOWlw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Mar 2022 18:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352283AbiCOWlv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Mar 2022 18:41:51 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6825D193
        for <linux-cifs@vger.kernel.org>; Tue, 15 Mar 2022 15:40:38 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id t25so883509lfg.7
        for <linux-cifs@vger.kernel.org>; Tue, 15 Mar 2022 15:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xuML/SGMU/zAurDdom+t6jQ6qjxFIlAY6W2oSUcDCZo=;
        b=W6hQS3SfXzDSbaAd27YNgh6FzBq/0SD1cmzQJrXoIBdxwur5m6MwzJ/I3vMq1bEthn
         z1sd594tJOyxaqIsTz7KQdilkPnxxIEHiqT80DoCLCuyFkIED0WzfwawbDTb9vMdgXyr
         V8Y7wLWo5EMDNAunOXfo3TZiXF5m+Vpnleq+SIvx2CmojS06NN1oWCDmXNijL16hPX79
         GXp3gzRKa37NM/bVlSfRcjSZMv+59Dtt7VsUhJwt3BPSCLga3tAii+5opjyep84mZ6qh
         MqeBToQPqZ5f8Kt8KNvAUN7pVi7GOTkOOvI1hQaBWKsTQJA2ADkrKfOaxMGxZTkSjio/
         6ERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xuML/SGMU/zAurDdom+t6jQ6qjxFIlAY6W2oSUcDCZo=;
        b=ZKQeJnMq3iietbAhCZCxgTOMZERYLBQDDdx8jyTNajMAaU8e/Dq5j+cpuuW90CuAlB
         hBU8Ed68uhuJbVtR7G8toRXm+QFe2PXFJp5sybO3j5Rnp1Bw3HOmV465RsjdfYNoCesA
         rosTrmArSh0jBrufap/HNLKpLGOpK6HjrvFeCfBc4hYZdSVVGvLMYasmHk9Y9Jib3lLD
         hbaghVDH0hqubKLCasoGNW+/lxU2LAGaLNKCZ/JlfXDINvzSkEmT9FiquUixdug7QnWG
         +WQOMd7DtoLV3vF4Hd2llJ9vxEG24yw7fwM3gunp8ytRA8xHMrHaHxECW6pJvtI6+odV
         aoVQ==
X-Gm-Message-State: AOAM531rjGpR3ee8na5GkMXzWyG4pqTjDXYJ6datMynkkSyPmXqNRqj9
        77TBJ97kdjxfCaMd5odSH5O1K4q5+sQcZCCw0dXUqUQ58sg=
X-Google-Smtp-Source: ABdhPJw9b6sgRhczl4MN8Vk3K4V4im9cAOVJOKw2BPEnOmYoBG1gjDhTDztRHDJcSu9/zYWZ3K4l3sFpJcIIat/UCek=
X-Received: by 2002:a19:490f:0:b0:448:4bf8:6084 with SMTP id
 w15-20020a19490f000000b004484bf86084mr17116932lfa.537.1647384036777; Tue, 15
 Mar 2022 15:40:36 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Mar 2022 17:40:26 -0500
Message-ID: <CAH2r5mvrgzqncUVhDC1bwn8fkrJt7RFs+gTvgByGsDpwfr9eOg@mail.gmail.com>
Subject: multiuser mount option regression
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I narrowed the regression for multiuser mounts down (which Ronnie had
mentioned) to this patch (one of the first applied to 5.17 merge
window for cifs.ko).   I am curious whether this is also related to
the hard to reproduce reconnect issue that the regression tracker was
monitoring

commit 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 (HEAD -> tmp)
Author: Shyam Prasad N <sprasad@microsoft.com>
Date:   Mon Jul 19 17:37:52 2021 +0000

    cifs: maintain a state machine for tcp/smb/tcon sessions

    If functions like cifs_negotiate_protocol, cifs_setup_session,
    cifs_tree_connect are called in parallel on different channels,
    each of these will be execute the requests. This maybe unnecessary
    in some cases, and only the first caller may need to do the work.

    This is achieved by having more states for the tcp/smb/tcon session
    status fields. And tracking the state of reconnection based on the
    state machine.

    For example:
    for tcp connections:
    CifsNew/CifsNeedReconnect ->
      CifsNeedNegotiate ->
        CifsInNegotiate ->
          CifsNeedSessSetup ->
            CifsInSessSetup ->
              CifsGood

    for smb sessions:
    CifsNew/CifsNeedReconnect ->
      CifsGood

     CifsNew/CifsNeedReconnect ->
      CifsInFilesInvalidate ->
        CifsNeedTcon ->
          CifsInTcon ->
            CifsGood

    If any channel reconnect sees that it's in the middle of
    transition to CifsGood, then they can skip the function.



-- 
Thanks,

Steve
