Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DE4C32771
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 00:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiI0Ahb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Sep 2022 20:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiI0Aha (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Sep 2022 20:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0326AA01
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 17:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8E086103F
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 00:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296F8C433D7
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 00:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664239049;
        bh=Eril/FGMXzFF5IM3n6A+j0eS22ZKM1Lbpdf4dRCRMhI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Ft20Ya9FmHVbzKncSGAnM+nA58dq4WwJ8yvcxzy2c2s1Q09vQxo1C+Www2kr2a200
         CvPK9vIlWQb5b4a7nusWifgcWPduYByfE2CHBpG8v8LH81Z5+XP1Yii2MjGvvu02/f
         6Xjq7qLAvcRbAlG20Kox8kL1gRB8dKYra14Te8dz5mZhaacJ8CTa3wH1ZOHRhiaDNC
         FlVMo1RNt1UcY8aaWb4jxijcMKJS+J7f+E3n4+pBt6JP28HjtcyJ1tTeMwev9Yg5w6
         5CDs7/MJzYKVWMxOe/U/dl+s5wYM0LyN/aVsTOGp99BTACt4aiCJQCOs0TUX47m+3u
         uEUCLhikQz7Sw==
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-130af056397so11423821fac.2
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 17:37:29 -0700 (PDT)
X-Gm-Message-State: ACrzQf3On+0QRQU2lOtOf9r7p7zS+rIh0SyWvZhbu6VrImj1YzI08xsu
        1L6BzGpLmMC+K3B8RqBv/skctaVO/oACl9IQkIc=
X-Google-Smtp-Source: AMsMyM6jsOe4hHmNkhWEWPCpWnJmsrtwTBA4VFqOh7BDZ4QBLs6NKH4b6r6yItAQhwtpvGb4FrQO2iEgIUusr9zqTP0=
X-Received: by 2002:a05:6871:893:b0:131:84aa:5b80 with SMTP id
 r19-20020a056871089300b0013184aa5b80mr35242oaq.257.1664239048344; Mon, 26 Sep
 2022 17:37:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Mon, 26 Sep 2022 17:37:27
 -0700 (PDT)
In-Reply-To: <c16ac0947a26d94ff084512b305bd525c93f6bec.1663961449.git.tom@talpey.com>
References: <cover.1663961449.git.tom@talpey.com> <c16ac0947a26d94ff084512b305bd525c93f6bec.1663961449.git.tom@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 27 Sep 2022 09:37:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8-ymYA9P0qmhVJy8cqigHMSNgVntFauxgAQqo6gpG1RA@mail.gmail.com>
Message-ID: <CAKYAXd8-ymYA9P0qmhVJy8cqigHMSNgVntFauxgAQqo6gpG1RA@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] Decrease the number of SMB3 smbdirect server SGEs
To:     Tom Talpey <tom@talpey.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
> The server-side SMBDirect layer requires no more than 6 send SGEs
> The previous default of 8 causes ksmbd to fail on the SoftiWARP
> (siw) provider, and possibly others. Additionally, large numbers
> of SGEs reduces performance significantly on adapter implementations.
>
> Signed-off-by: Tom Talpey <tom@talpey.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!
