Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66161C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 00:08:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F0260FDC
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 00:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbhIYAJv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 20:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345042AbhIYAJu (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 24 Sep 2021 20:09:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1134E610F7
        for <linux-cifs@vger.kernel.org>; Sat, 25 Sep 2021 00:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632528497;
        bh=iCyfsjgPqefPjLkT/0Ed6p++lB1DH9G2zbUdfzMSf4I=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=SzU8prAsDQad3HKJ0W2Ve8yJdg+z9kHe7jD/IWRrzPYhq9sf08XWTW2Ewq2nKaGbp
         B3xYhUlxH/QOP/Lcu7JbR2cVPPMuhwL36M4yuJpv9cRlQ1vpLSAc02HgywZUbVGu8m
         JFMoElo28hibw2BhK333T+1qIkt0WWUqxxBjXxQ9+WJ7lp9Jicvf/DMS3hgvBOSmy9
         gCKEiD5/Xi2HeILKvyrqD2MwgP8rQ2BF8rBXz/g9pmjpTLJfGYHXnmyqw+/9DdmVtG
         rEeoTyrHMqJ+8eulmP3HR/33Py3EToxHPaJHfdwzeyqfJKK6ECbXZxjG6RTKdsYJfd
         SM9WXF6cc1EcA==
Received: by mail-ot1-f52.google.com with SMTP id o59-20020a9d2241000000b0054745f28c69so13334926ota.13
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 17:08:17 -0700 (PDT)
X-Gm-Message-State: AOAM531txHeyHCvN1JSabgwHlj+Rk00ZNTjEkf1T2pYPY8A7tEGHuPiI
        qjpZXD03kX1jLtQwn8z4B2EowDWR+l94LM4jQuU=
X-Google-Smtp-Source: ABdhPJzCFX89SaQsClFXpeh+ZMa/AunUA1ddcjE2Gx0Ud9Sv0IR6GKEJFOcM8+me69iylC/yZwCjWvsLqO+IHzIk5yw=
X-Received: by 2002:a9d:729d:: with SMTP id t29mr6399431otj.61.1632528496439;
 Fri, 24 Sep 2021 17:08:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Fri, 24 Sep 2021 17:08:15
 -0700 (PDT)
In-Reply-To: <YU4I3zUm3UOOXrBz@jeremy-acer>
References: <20210924150616.926503-1-hyc.lee@gmail.com> <YU4I3zUm3UOOXrBz@jeremy-acer>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 25 Sep 2021 09:08:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ujkC3A7KuE7az6-G0SzX4vrt0sC3uPmwTzXxJ3TfdgA@mail.gmail.com>
Message-ID: <CAKYAXd-ujkC3A7KuE7az6-G0SzX4vrt0sC3uPmwTzXxJ3TfdgA@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: use LOOKUP_BENEATH to prevent the out of share access
To:     Jeremy Allison <jra@samba.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Ralph Boehme <slow@samba.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-25 2:20 GMT+09:00, Jeremy Allison <jra@samba.org>:
> On Sat, Sep 25, 2021 at 12:06:16AM +0900, Hyunchul Lee wrote:
>>instead of removing '..' in a given path, call
>>kern_path with LOOKUP_BENEATH flag to prevent
>>the out of share access.
>>
>>ran various test on this:
>>smb2-cat-async smb://127.0.0.1/homes/../out_of_share
>>smb2-cat-async smb://127.0.0.1/homes/foo/../../out_of_share
>>smbclient //127.0.0.1/homes -c "mkdir ../foo2"
>>smbclient //127.0.0.1/homes -c "rename bar ../bar"
>
> FYI, MS-FSCC states:
>
> "Except where explicitly permitted, a pathname component that is a dot
> directory name MUST NOT
> be sent over the wire."
>
> so it might be easier to just refuse with an
> error a pathname containing "." or ".." on input
> processing rather than try and deal with it.
>
> Might be interesting to test this against a
> Windows server and see what it does here.
When I have tested it, it's allowed...

$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/./bar/../
bar                  DIRECTORY               0 Sat Sep 25 08:50:02 2021

..                   DIRECTORY               0 Sat Sep 25 09:02:12 2021

.                    DIRECTORY               0 Sat Sep 25 09:02:12 2021


When last component is dotdot(..) and first component is dot(.),  it
seem to refuse connection.

$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/../
failed to create/open directory (Invalid argument) Opendir failed with
(0xc000000d) STATUS_INVALID_PARAMETER.

$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/./
failed to create/open directory (Input/output error) Opendir failed
with (0xc0000033) STATUS_OBJECT_NAME_INVALID.

./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/../
failed to create/open directory (Invalid argument) Opendir failed with
(0xc000000d) STATUS_INVALID_PARAMETER.

$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/./foo
failed to create/open directory (No such file or directory) Opendir
failed with (0xc000003a) STATUS_OBJECT_PATH_NOT_FOUND.

$ ./examples/smb2-ls-async smb://172.30.1.42/homes2/foo/.
bar                  DIRECTORY               0 Sat Sep 25 08:50:02 2021

..                   DIRECTORY               0 Sat Sep 25 09:02:12 2021

.                    DIRECTORY               0 Sat Sep 25 09:02:12 2021


>
