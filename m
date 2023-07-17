Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054AFEB64DC
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Jul 2023 16:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjGQQAZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jul 2023 12:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbjGQQAY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jul 2023 12:00:24 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B9D8
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jul 2023 09:00:23 -0700 (PDT)
Message-ID: <4a56f0980bb467d34705c8c21ff6f068.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689609620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHJT4g7V1e2rj5DfXctKust347QDSMAe4bLR2YPm7Aw=;
        b=S8YolU+rBLjLa/zEsl9kKkCE+C8PDgcwx+GEftwFBmfYiT/Owcy7L3y0GaFN7/N/mzz4ui
        6rcTAQ7fSbxT+ozNEIxto6IPLWhk+riIE/YQqxvXcKjtStgY/fQRZWXlUwWxw/8ybY21Zh
        NSSo5R4dsLBAI87ZzBSuvuVd1XuLRPyRh1tdbkfoLCgdB3DuZbg28Sw4vrs1LAyQUEiIXH
        xb2/7FLJG929BOp0zeRM/RdTxQOLsIyCNvC3aXeOCub6YgCCqKZyYs+hDONdSPKoMv4Yql
        /g8/sL2C2spSCQq+O3ThuOpKkRCfKw7uRaoujCwcG5DeaRiHpiI3TFr91dk7pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1689609620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHJT4g7V1e2rj5DfXctKust347QDSMAe4bLR2YPm7Aw=;
        b=JO71ebGQrX0+pcrXOLbXSRGNnOQEfeyZS1WB/XbPprlA+4d2SjTnyeJv3w58Ov3FVhDYlF
        T40E0FrqzFqYUIxtC6vgx7Z+5ZZF+enlhEpoeWG5D0J7z6DVG6oW8/kd/O619UzRZt2ZRN
        fwIG/1GEvsvtNSDMkzBIpXfRatycL3valTc0hIROYQBZXTqS49RXetSEAo/D8Otiq+MQGG
        fMMAW6neFi/s51QykZMzM5AX/opjGCaY/g/o6LEPL/D+UHk2e2gCD0etSqWn8emijhXZ7c
        OQNPXIWgh5fy5QiAMcvY6TRVbJvGmV/2fXwgrcBxsVUZlJ9CRV/ZS1risxk4OA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1689609620; a=rsa-sha256;
        cv=none;
        b=kAyUt2NsWqAyw4abCUYc9PJtVN5TWYMA6ZrcJvPNZvyXKOiGPxVPINNRrIo82yG01/y6+M
        iislpGP3S2pFnwLv3Mq9yT6PTL+I8lb+jO+BB8AmL+H+SY3Xx5nBPOeFNZbLmHpiD0PZlF
        SP870g4koM+5NV0HLT3Encmv59BtulN6tMlXWav3LhwY7WEhfcVH0EVn6Whsi8NyQUUNS5
        jk0w2R6X+DuVU2+tgE4S5Fk+e79RYs+QUGTdR9sEovLnHdJw+C8LkABSFWcI3fbdsvNK9N
        Wiqxa4ZhNSw6ygvuBH1A996Nz8zO0sMNxQz0f4OWEK2SZBAOgpRG+JYxlE2XhQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Winston Wen <wentao@uniontech.com>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, sprasad@microsoft.com
Cc:     Winston Wen <wentao@uniontech.com>
Subject: Re: [PATCH] cifs: fix charset issue in reconnection
In-Reply-To: <20230717022227.1736113-1-wentao@uniontech.com>
References: <20230717022227.1736113-1-wentao@uniontech.com>
Date:   Mon, 17 Jul 2023 13:00:16 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Winston Wen <wentao@uniontech.com> writes:

> We need to specify charset, like "iocharset=utf-8", in mount options for
> Chinese path if the nls_default don't support it, such as iso8859-1, the
> default value for CONFIG_NLS_DEFAULT.
>
> But now in reconnection the nls_default is used, instead of the one we
> specified and used in mount, and this can lead to mount failure.
>
> Signed-off-by: Winston Wen <wentao@uniontech.com>
> ---
>  fs/smb/client/cifsglob.h | 1 +
>  fs/smb/client/connect.c  | 6 ++++++
>  fs/smb/client/smb2pdu.c  | 3 +--
>  3 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index c9a87d0123ce..31cadf9b2a98 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1062,6 +1062,7 @@ struct cifs_ses {
>  	unsigned long chans_need_reconnect;
>  	/* ========= end: protected by chan_lock ======== */
>  	struct cifs_ses *dfs_root_ses;
> +	struct nls_table *local_nls;
>  };
>  
>  static inline bool
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 5dd09c6d762e..abb69a6d4fce 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1842,6 +1842,10 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>  			    CIFS_MAX_PASSWORD_LEN))
>  			return 0;
>  	}
> +
> +	if (strcmp(ctx->local_nls->charset, ses->local_nls->charset))
> +		return 0;
> +
>  	return 1;
>  }
>  
> @@ -2027,6 +2031,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>  		}
>  	}
>  
> +	unload_nls(ses->local_nls);

Please move this call to sesInfoFree().

cifs_reconnect_tcon() also needs to be fixed by using @ses->local_nls
rather than load_nls_default().

Otherwise, looks good te me.  Thanks!
