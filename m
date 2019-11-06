Return-Path: <SRS0=bD0R=Y6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C424C5DF62
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Nov 2019 08:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBB82217F4
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Nov 2019 08:47:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="Reg9I3F8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbfKFIrR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Nov 2019 03:47:17 -0500
Received: from mout.web.de ([212.227.17.12]:52139 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbfKFIrR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 6 Nov 2019 03:47:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573029944;
        bh=4YjA4Vh4zopqd5d3U1mZdQXcTGiVWYU9LJ9lq5juZWY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Reg9I3F8ktyjBtHqc8idz/DMmFZJOUO845vj2SJ2PWyQgPCWPO8n/hPGrJcekfnIc
         5bQ5g2cB35YMQN2tdR2EYmZypjIGmL0s/DMF6zNmE+U4DajGKDQ+Afrb3OqhAF2WLf
         z344kk1Ltq6V9qtnrsvkAUltCJDQI4ZwhTUw7W6A=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.91.235]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LZvcX-1i5LJq3pnR-00lpXE; Wed, 06
 Nov 2019 09:45:44 +0100
Subject: Re: [0/2] CIFS: Adjustments for smb2_ioctl_query_info()
To:     Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
References: <b797b2fc-1a33-7311-70d7-dd258d721a03@web.de>
 <CAH2r5mvWXtSdKb3RcSR_Z6LwsGhDmR0wBeKekwkS-VG4YnFNpQ@mail.gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <99299a4c-6cda-8d92-a851-e154a0e6bb79@web.de>
Date:   Wed, 6 Nov 2019 09:45:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvWXtSdKb3RcSR_Z6LwsGhDmR0wBeKekwkS-VG4YnFNpQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:z0chzV9uK+8ssV4ZLHhe0Iw4QRA+wRnG3SCsqTlSRjPXw+Cfz/K
 eJViNPsZmmmIgNZhozCh8P8NO5r+DR+L5eKsWQS7lWe79E3VxN3mikdAk/yOT7p4h3ZnbnG
 2SUWgsEzmUicFTyEjHjzOjvbhSyzPOHsECXM/7ULqmCAaJOwJhEx7WIhJiMizVykGPp50wS
 1I3CNHBp0K1H6S95rAZsw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Pek3KMd7YHk=:a+Es3/yAAc32KWaIydwHBa
 P1DPa2ivoJOyXwAgjrQCermKYs1YcOj0YgIB1VvWaZFRqLwbRHoucG9Ghn2+qJ0Y0VS7BPyVi
 lcEaIL6EWa5GIvSEtJZZduqQ9juqfJ1EOQ7kECXrRXQbO5RuYDusck7fnQoo29n3/HgCBGmmK
 9HOpNcfjwjFtNOs3z5DwRHK6WMcJ2PzsaSkRis3RwNmT7lpI+dl9kfJJFqPeBNj68jJqMrg9U
 ivzy5i8gFTdjYVimzKsMpw5H1EWRd+TyFOBbYdo3FOE5FpTK7q2gNCPK1INWeFsoAlhk1dHOl
 KcCkuI6DopdGLuRK+rKFfyr3ww2qvsm7fgBvQIJq2U710yl9XVfAHQPVf/sV7jBnreqXGcXQc
 UeJi6+rl2/9lUPcZOaEp/Ap+InRJlxRm65x+RhFaYF+/+wpkYvLLcijSgPjjk5R2Waax9bsog
 xId4WCdz92zLd6GpBfcrQ7whmjm1fwPndFYQoIvGsCoVRIGu+V9J92firp/JnOWuMeiKBNT9v
 n6b7VYKY1hHS2NtFIFEXlp0DvSE420iSqU7XCJUZHtJkHV/mxhNrM2koV4mfXEHI6ADILrDD/
 FWGEbTjHqk2UeQfmO0hFWaqoImFNi3/EhI2KeoVKadqZAGs7L/NH7d8CXIxIZaynzD5/c8zSk
 zbFWwTsIUxQaKnI69tsti281g9HjbAUlWfkujvg9nm/UTZbiCCwwKyuaK/n5ybeq/zTy3+VP8
 n+Hnne2zItb8sPdI08QZIB5Z7w14XelsbV6DjSWENeCGr0H9QlYa3MYZQMqsVm7smGXE3WAJn
 Acy3GpNzUCmZfGn8uAoMnxZ/sEiSMyErtmepek1IZxYEmKVZYUViYYy+hlxPRHdnn4bMDlxsC
 PNW60VYVcKMOD5Lv73ELLFLR9G5tpzzIKg6hclnxf3xyJLTalMXkx7LSo4xD2SSlvcbAW8AgY
 4S4A/Poqg/UPOarrzNFaMNk2HOWmtl3xOznRnsVgOD/8KFEUHnVTAc6xmuNwAjm101mYpdvsW
 NVS9gS/tEBAUGOSyGQMvpcRqJ0GwHgOtxoRldTu/2fDCxEHfC6Idv2+Eg8KzQbIgHl67b93mM
 5PMl7+h9yGU49gt8UK3TQnBqfskysQTtJrtto32HFLw7iYqFy1OLtfmrWlFONizMv9GZqiVsL
 s2/2nFoeHAheBWzobm4xJMXHPRPWWHchy9DQizdANFty+DdM0lepctBaoh4xZq0fhOm4Kup/F
 8V5DHocsWbzx86p/pAzt2sVF3DFt2ZioUjZuRJl+YD/OZZ3cJ7hjA2FQ82tM=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> merged into cifs-2.6.git for-next

Thanks for your positive feedback.


How are the chances to take another look at any more update suggestions
also from my selection of change possibilities?
https://lkml.org/lkml/2017/8/20/104

Regards,
Markus
