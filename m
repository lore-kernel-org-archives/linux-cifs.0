Return-Path: <SRS0=KPcv=IF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72462C433DB
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Mar 2021 10:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A736512B
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Mar 2021 10:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhCGKvE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Mar 2021 05:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhCGKua (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Mar 2021 05:50:30 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59123C06174A;
        Sun,  7 Mar 2021 02:50:30 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id c131so7016829ybf.7;
        Sun, 07 Mar 2021 02:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VuSNp8ohCEDTVNqOLRIMNo7zaXhyGLF+pvmM+1TvWQg=;
        b=g2GpQyn+lSSG941waxTRsJNyYVrlP+w4Z1byHE6B11GbHqF1ij4Bg+3I5KpB4EDgnJ
         B1tgnEyQS9XTafRwNoYit2OUoYikss0E8qxrfxoHpQn1gFLoPve9mA1vQG7k4sIXfIrg
         P61/iE60aSupZHVQvUlJI9Ur+a0QKCnV15iGyjV1Jha5drAiZCIpkdli9fNG26Fb94Xa
         QXHsELSumBNe2xMCPUo+8P8WiR3q3pLFbzeEGiFA81GG3iYBYHQ+1ba7iqWZxCvIT1FL
         Q3590rHIW6CDAtURAlGI2zF9VoDzbk0mSxIwoR5Yj+/qZkvE1CdBeKlLz31zLzom+1Fq
         vE1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VuSNp8ohCEDTVNqOLRIMNo7zaXhyGLF+pvmM+1TvWQg=;
        b=BHrciYPuwnHULU7Z7DjMNcILrzoSVRQ/BCbhXuuCdb3ECZheicpm2Tx426JEGHGLCh
         hZnuEz6HwJ7Mfcm9r+5uTQ87/kbk6OTlti9+pkVOsUx01LmXXfCXT6kNRyUWyuPJbF8A
         ymITV2IjNc4BWxyxAsJnmdb6xE5ApIo7gQf2/lphGfvwRzYhVwBzKfM/9hKhS/j1T9TF
         SP41vo0/G3Vrb3z/x6gCuNACL9FvqZibWXJcFMPMnKqUcfDYVMrAaDFFvGMgSb1Z1C8w
         zV+2zUtqW2TVOlS6nh/m2li8/QIpV+PAyj/DEi1jYX38NVkWungaU/BVUd9XYk9GZKTu
         /hJw==
X-Gm-Message-State: AOAM530BwKwXKw+4545SL+QevnthenTaRSeyjuTk082HaQ+FqPw8Q/dT
        lofBOUAKDkL0Z82/ft2o6ZxkpMHDS7fOmnh7iMI=
X-Google-Smtp-Source: ABdhPJxMe+8aOlcrc2X9rehsYaYuitly26CDn6yA8BqexdDs5ZwoiRRL4LwO3ovwBuua1q6WRcnqBSheWy4yYWrWaK0=
X-Received: by 2002:a25:ab82:: with SMTP id v2mr26092512ybi.97.1615114229379;
 Sun, 07 Mar 2021 02:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20210305094107.13743-1-vincent.whitchurch@axis.com>
In-Reply-To: <20210305094107.13743-1-vincent.whitchurch@axis.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sun, 7 Mar 2021 16:20:18 +0530
Message-ID: <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Prevent error log on spurious oplock break
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <sfrench@samba.org>, kernel@axis.com,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Vincent,

The reason for rejecting the request maybe a number of things like:
corrupted request, stale request (for some old session), or for a
wrong handle.
I don't think we should treat any of these cases as a success.

Also, from the MS-SMB2 documentation:
https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/4f35576a-6f3b-40f0-a832-1c30b0afccb3

"The client MUST locate the file in the GlobalFileTable using the
LeaseKey in the Lease Break Notification. If a file is not found, no
further processing is required."

So I don't think we should be changing the logic here.
If SMB v1 had a different behaviour, we should check if that is as per
the protocol documentation. If not, change it.

Regards,
Shyam

On Fri, Mar 5, 2021 at 3:12 PM Vincent Whitchurch
<vincent.whitchurch@axis.com> wrote:
>
> The SMB1 version of ->is_oplock_break() returns true even if the FileId
> is not found, as long as the oplock break notification message structure
> itself appears to be valid.  A true return value makes
> cifs_demultiplex_thread() to not print an error message for such
> packets.
>
> However, the SMB2 version returns false in such cases, leading to an
> error "No task to wake, unknown frame received!" followed by a hexdump
> of the packet header being printed by cifs_demultiplex_thread().
>
> Note that before commit fa9c2362497fbd64788063288d ("CIFS: Fix SMB2
> oplock break processing"), SMB2 also returned true for the case where a
> connection was found but the FileId was not, but it's not clear to me if
> that commit really intended to change the behaviour of the error prints.
>
> Change the behaviour of SMB2 to be the same as SMB1 and avoid the error
> messages for these packets which we ignore as per the spec.
>
> Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> ---
>  fs/cifs/smb2misc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 60d4bd1eae2b..3ea3bda64083 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -679,7 +679,7 @@ smb2_is_valid_lease_break(char *buffer)
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>         cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
> -       return false;
> +       return true;
>  }
>
>  bool
> @@ -755,7 +755,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>         cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
> -       return false;
> +       return true;
>  }
>
>  void
> --
> 2.28.0
>


-- 
Regards,
Shyam
