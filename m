Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68845C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF9161352
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhJEIAg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 04:00:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232916AbhJEIAf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 04:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B032C61352
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 07:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633420725;
        bh=AA59a/dmuvJHX99vhNNM2M9Gtrftr/KBLlcIl/WEjc8=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=GbS9d4TdlVxs2ufOocYsJdWKlCAFLjjXTLEzgB0p1EQ008y42DEPFKwiTnfk4PuFj
         Y01ict9G1453FSpDZhEx/IRCzUmCeny1Y30ayLNEJwAQ6IlE+J5FYGVYhX6IPtuyzT
         RWkU60cHFHWS52GD6XndJ3FmxGMxMyD26NRJkq4WlfODmFp5FmB+39r0sbDqGsRLA6
         g0LR3C+6bVVIOaNrHmwUuC83vpBUdq237wCbwxkW8qao9T/Csg9w28+MNd5mX7oVMo
         PXY2Lf0SjKHg0SydIL6LBXfARlee3qWW6iJHuZFQzg8SYUq9p5Y1yJtIImHu31Syrg
         UZzrTB0ilEWsA==
Received: by mail-ot1-f47.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so24823645otq.7
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 00:58:45 -0700 (PDT)
X-Gm-Message-State: AOAM530ORwCnLF+gy5CVWXFE9oDsZal+KyKWQ3issPo6utJCujCpRZ68
        405mfSO1v3pi5wGfzJQ6aRqVmXju0+XAtnylnSo=
X-Google-Smtp-Source: ABdhPJwLxxpNWUGTh76YaYj5lHFAwC/VdlT4LERdkhEtqLP6SW8TpkOglUT5Tzy6KrO8jCYxzTe8NtloNO0hqKUKoY4=
X-Received: by 2002:a9d:67cf:: with SMTP id c15mr13151550otn.232.1633420725126;
 Tue, 05 Oct 2021 00:58:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 00:58:44 -0700 (PDT)
In-Reply-To: <20211005050343.268514-6-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org> <20211005050343.268514-6-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 5 Oct 2021 16:58:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8sn=AAsHdtWUUpFN44YCVfF7M3wYLcXv_zQUifYTxofw@mail.gmail.com>
Message-ID: <CAKYAXd8sn=AAsHdtWUUpFN44YCVfF7M3wYLcXv_zQUifYTxofw@mail.gmail.com>
Subject: Re: [PATCH v7 5/9] ksmdb: validate credit charge after validating
 SMB2 PDU body size
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-05 14:03 GMT+09:00, Ralph Boehme <slow@samba.org>:
> smb2_validate_credit_charge() accesses fields in the SMB2 PDU body, but
> until
> smb2_calc_size() is called the PDU has not yet been verified to be large
> enough
> to access the PDU dynamic part length field.
>
> Signed-off-by: Ralph Boehme <slow@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your work!
