Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A51BEB64DC
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jul 2023 16:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjGCQD6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jul 2023 12:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjGCQD5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jul 2023 12:03:57 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F57E52
        for <linux-cifs@vger.kernel.org>; Mon,  3 Jul 2023 09:03:56 -0700 (PDT)
Message-ID: <223dd925bd50acd04bfb25fa18cf276e.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1688400234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Muo8gHVfDnc1GsMpTl5WumMo5KCiLcLxpv4eUwbZDLA=;
        b=V+1ZoWKWQNFA6emZg+ZgX5LV2lUtMxIXlOWZ8NG7fD2wlmJHhWuqlM33efwPiEtRCk2/d8
        4foMD7/Gtlc78r+y6MYOs9BQFJR+zLYPbhRtS8ljK2cxA4Lc23v4Wm0RSE6WrYdQ6jgSHi
        KxCuL/nQMWFCkHLMlqUzEMP1FV0t6ZAKWDzSKEda9KUQ4xlPOr2l4E8IIHuM70ufWfruRt
        xRqJWYv//A75Hhzv8em/633fhLPPovVoDiELsTrJtfotUe1kPSL48IYKPsHNvK+JnlUjax
        F0BcvWWvO0pyQ4AOtfXdb4d4lVgnQ55Zt4s/L+rBxvylj1TE4SekGg0is6GsSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1688400234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Muo8gHVfDnc1GsMpTl5WumMo5KCiLcLxpv4eUwbZDLA=;
        b=UXS/8AI9HiPNzdctmolisSzfKOlm/EfhEmCT5N6QOANmr2HRlAcNzLKoLi5Ynx7wPPPW5T
        26gedkxf+k9+/z5mncXU/VfBbzwnzOMvHOJ1YQQYqYqbU/GVI/Mv2ZXpRH93qpJB0Ig3Ee
        pQLfJ399nlGdJjBBT+St58NXptjvXV3atg+94/1XZ5x0YmsX3is6wpsg+eCJvYqAW27M4n
        fxUHhpvgj8pzhZns2ih7CGUOp+Fvu5GD9Kw6M1g8n5WwaWQbppfciS1Hyp6YHk8qewsEAj
        Mc7EkQVkxAzFxdMAwzw/iijYONZVKYCy+rNvdpYEc/WvrvBvqQDZmhDJVTkKuw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1688400234; a=rsa-sha256;
        cv=none;
        b=QyAjcl9H/LbPsfF3ztsEu0mvtAK7HNrijnqQD2mjIP8oNpYoM7qfS//n7H1cr7EidFyu7y
        OEXYpVMqCJzvkCgJOHupbDCwGKIJ6opmY4p2SorWmwxAA8CNKttPNsuciLV6v0ynMfKSO9
        F9mw0KsZYxmZNHAKFGcvi7ObU/w57QwBjgObav2wVNVmdS0SHi06DCmq5Uql/uRPLTmgx7
        +8CglkHFhkWbpDdCuX31vZXMiU3MUlL6zvZ6dTM124ujXUKewNW/AYS3Q2FkLtd00XQaxG
        e/qoZvAP+gvlXauVhmmBpWSnmU0GDAnHT6TdlUwWsVcL18RIY680UPxF2ApneQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Bharath SM <bharathsm.hsk@gmail.com>, sfrench@samba.org,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com,
        nspmangalore@gmail.com
Subject: Re: [PATCH] smb: add missing create options for O_DIRECT and O_SYNC
 flags
In-Reply-To: <20230703120709.3610-1-bharathsm@microsoft.com>
References: <20230703120709.3610-1-bharathsm@microsoft.com>
Date:   Mon, 03 Jul 2023 13:03:49 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Bharath SM <bharathsm.hsk@gmail.com> writes:

> The CREATE_NO_BUFFER and CREATE_WRITE_THROUGH file create options
> are correctly set in cifs_nt_open and cifs_reopen functions based
> on O_DIRECT and O_SYNC flags. However flags are missing during the
> file creation process in cifs_atomic_open, this was leading to
> successful write operations with O_DIRECT even in case on un-aligned
> size. Fixed by setting create options based on open file flags.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/dir.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 30b1e1bfd204..4178a7fb2ac2 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -292,6 +292,12 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  	 * ACLs
>  	 */
>  
> +	if (oflags & O_SYNC)
> +		create_options |= CREATE_WRITE_THROUGH;
> +
> +	if (oflags & O_DIRECT)
> +		create_options |= CREATE_NO_BUFFER;
> +

Looks good, thanks.

I see that cifs_nt_open(), cifs_reopen_file() and cifs_do_create() use
cifs_create_options().

I'd rather have those flags set in cifs_create_options() by passing a
new @flags to it, so if we need to make any changes later, only
cifs_create_options() will require it.  What do you think?
