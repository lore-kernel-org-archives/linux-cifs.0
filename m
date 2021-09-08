Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5F2C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 07:51:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE84060EE1
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 07:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346759AbhIHHw3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Sep 2021 03:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346391AbhIHHw3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 8 Sep 2021 03:52:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5CA361051
        for <linux-cifs@vger.kernel.org>; Wed,  8 Sep 2021 07:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631087481;
        bh=wNEjeSw5ORXOEsn/O+wR/nnAMWrLf+/LR+BijE99M/U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=igBkOxbAhDXjA986DNuaQ7mJcXckENcNx0UPODvRuJwOBA3ovf4WBE6cUvgIRGc//
         j8cjFw4FAnoQptJcUYgi8mX6eGKA8yyq4we2BB7DfvCdyaerybGmNLe63LUUYHzlpN
         7DiyNQUrDus++lfy16+q2nvSDWOWcuwPzQyJFIjooSrE094UIj3ytQRcoU1oYg8LRW
         29kE7kFaKJ5BdkUCaAyrRLUF631a4l6onfG/HekfhNUzvIlLIP3rDZUNnc8xGun230
         /1rNn7SQIk3BP6pzVIHXpZDDnaweondwUl6Cy8l9BXWFR8LYCq0sJqiNbAKwnAmIya
         0yy/NWWY3PKZw==
Received: by mail-oi1-f173.google.com with SMTP id w19so2017920oik.10
        for <linux-cifs@vger.kernel.org>; Wed, 08 Sep 2021 00:51:21 -0700 (PDT)
X-Gm-Message-State: AOAM532ZZVkcRztpi3dEzZ5NBvSYUdRuBsp/7QSDuUts9p1/eBJALg5N
        b++Tw+JjfA6meUopHmEdFjcPUahmBmyO9nxzYbk=
X-Google-Smtp-Source: ABdhPJyYdAU9aaCL6f6Iic036HXpybwYQhb93U52CXAy+bdFWtVSrl0sbwfNErwSOpXGTfEMqiQCsWE/4BOFia6DYGo=
X-Received: by 2002:a54:4f03:: with SMTP id e3mr1473322oiy.32.1631087481094;
 Wed, 08 Sep 2021 00:51:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Wed, 8 Sep 2021 00:51:20 -0700 (PDT)
In-Reply-To: <20210907082523.2087981-4-lsahlber@redhat.com>
References: <20210907082523.2087981-1-lsahlber@redhat.com> <20210907082523.2087981-4-lsahlber@redhat.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 8 Sep 2021 16:51:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SRaAPUEeyAFs+6SYBB25dYts=b+7VZrmzuySj+dDEVw@mail.gmail.com>
Message-ID: <CAKYAXd9SRaAPUEeyAFs+6SYBB25dYts=b+7VZrmzuySj+dDEVw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ksmbd: Use the SMB3_Create definitions from the
 shared area
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,
> @@ -2525,9 +2525,7 @@ int smb2_open(struct ksmbd_work *work)
>  		    req->CreateOptions & FILE_RANDOM_ACCESS_LE)
>  			req->CreateOptions = ~(FILE_SEQUENTIAL_ONLY_LE);
>
> -		if (req->CreateOptions &
> -		    (FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
> -		     FILE_RESERVE_OPFILTER_LE)) {
> +		if (req->CreateOptions & FILE_OPEN_BY_FILE_ID_LE) {
Is there any reason to remove CREATE_TREE_CONNECTION and
FILE_RESERVE_OPFILTER_LE check here ?
smb2.create.gentest failed by removing this check.

test: gentest
time: 2021-09-08 07:04:21.276746
time: 2021-09-08 07:04:21.413606
failure: gentest [
(../../source4/torture/smb2/create.c:222) Incorrect value for ok_mask
0x00ffcffe - should be 0x00efcf7e
]
The command "./bin/smbtorture //127.0.0.1/cifsd-test3/ -Utestuser%1234
smb2.create.gentest" exited with 1.


> @@ -3475,9 +3473,9 @@ static int smb2_populate_readdir_entry(struct
> ksmbd_conn *conn, int info_level,
>  		posix_info->Mode = cpu_to_le32(ksmbd_kstat->kstat->mode);
>  		posix_info->Inode = cpu_to_le64(ksmbd_kstat->kstat->ino);
>  		posix_info->DosAttributes =
> -			S_ISDIR(ksmbd_kstat->kstat->mode) ? ATTR_DIRECTORY_LE :
> ATTR_ARCHIVE_LE;
> +			S_ISDIR(ksmbd_kstat->kstat->mode) ? FILE_ATTRIBUTE_DIRECTORY_LE :
> FILE_ATTRIBUTE_ARCHIVE_LE;
checkpatch.pl error happen.

WARNING: line length of 116 exceeds 100 columns
#274: FILE: fs/ksmbd/smb2pdu.c:3476:
+			S_ISDIR(ksmbd_kstat->kstat->mode) ? FILE_ATTRIBUTE_DIRECTORY_LE :
FILE_ATTRIBUTE_ARCHIVE_LE;

I can directly update this patch, so no need to send v2 patch.

Thanks!
