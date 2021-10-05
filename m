Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2007BC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E18760F59
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhJEH2c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 03:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhJEH2b (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Oct 2021 03:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47F226117A
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 07:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633418801;
        bh=5TVnfea7HX1WtzgzC2AdPVD4u/jJugyfk0TktnT5D2s=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=AIdAe/2FhN48CuinnrZdJaTR9BTlq7E+/U07AKGPTWYJbEOmZHoZQ0uNCUynhY1fn
         37uQJVGhSXivOwAeS27XiYIWUYuQfWUbPz4o2cF0S2RvglNjwqYhcYChFyuh/JOX1I
         BQsZgIoNa7y5mPEG8iUofOFSFG5/Jk6MPSWnaiQmXvgu1Z6ik+RODzSE0pW9+wNQQO
         OUPtev37erQeV2qjqf9KTHLhVERbyWBe8bTEg76OgezHeb53STeaEhJ5Fe5KArcInb
         5xuB68z7vElTmmjxF9/S9SMDv1uia8t2+tYy34b9YZkMX7T85Uxr2/l3xejXGUGmZo
         YXAgOypcmadHQ==
Received: by mail-ot1-f49.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so24744125otq.7
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 00:26:41 -0700 (PDT)
X-Gm-Message-State: AOAM532D1+Qq3ZAtQzGHWcoek8rOtRoIsOh28P8IlfNNCQb3dKbN5yc5
        JkYyfogngZ+9CisI/l0Sn2b5eXtpKlzSnN0YUfI=
X-Google-Smtp-Source: ABdhPJxiCF6v4Hn1DHbIFV/JhoEdfZeSBMgRLW+E4L6xoReagqmL6y+eUe2cGXnBsszt7LPu32Q6m48cK1M1m46z6yQ=
X-Received: by 2002:a9d:67cf:: with SMTP id c15mr13054422otn.232.1633418800650;
 Tue, 05 Oct 2021 00:26:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Tue, 5 Oct 2021 00:26:40 -0700 (PDT)
In-Reply-To: <20211005050343.268514-2-slow@samba.org>
References: <20211005050343.268514-1-slow@samba.org> <20211005050343.268514-2-slow@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 5 Oct 2021 16:26:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9BAAFhQKw=mffwMY6i7LVRm9U_8q-20S7JZsHCs2YCqg@mail.gmail.com>
Message-ID: <CAKYAXd9BAAFhQKw=mffwMY6i7LVRm9U_8q-20S7JZsHCs2YCqg@mail.gmail.com>
Subject: Re: [PATCH v7 1/9] ksmbd: use ksmbd_req_buf_next() in ksmbd_verify_smb_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-05 14:03 GMT+09:00, Ralph Boehme <slow@samba.org>:
> No change in behaviour.
>
> Signed-off-by: Ralph Boehme <slow@samba.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks for your patch!
