Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7B930B502
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 12:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785500646; cv=none; b=o9Kfnj6Rym+3INlOO4OGnbC7SZLtWGaD83X03NZ94RABfNeNl8HGnsW7UkN7hHzI+wHHNr/i8lmA9Pm/G05MRd9dDQ1aCmUPdfqfWoLetCxRxzXe8Cgkruuw0RpBTUjxffu8kBFkAjsEvnY9jttTdpD2vhIGPvjQbWBT24BgjVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785500646; c=relaxed/simple;
	bh=2Cedmwl9BfHEJbc1wRml3yXWfzCCAfvbL8nBAPZ9v6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G23gB7SBqgbDrhW6An5hf+R9ngFp7jKZS6f27KlGUgfOJnyRMqOIBpryqqadsx0tZMRvBsiGxsFIZz3YGZCx++0AAcIuRvDSJXYYms3wtqCQQza1KnQbL+zy6cCd87h4S7lyUBJZgq89sQKE1kg3QPEGHdNjq35r34VHgRYsGTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=tximCxxv; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="tximCxxv"
Message-ID: <e6497446-e52f-4a5c-99ac-9db8faf28b47@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785500640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJwHBIWmzNZT0b7RZiUXDHIzxhEQxpJaEQu/W3dJtBU=;
	b=tximCxxvKRWcuByBJ6dEFLB1rhopgy7UiZWwzKdeKYpFIf+jYm6AN/3mrdA4xwKEwdaylt
	rOZB4YtaKByZsk6uuog3U88adTyuhFzU85kG2ffU/dtfyImwUIm4OHufU9ezs1t0GnomoK
	yX9BjuKg517Z9emmob7cn/s8w05hVyZV4fyKh+a9fFjqadRkEj+raNGvDLK4gQtJYmR6Up
	toXoePlcjxRGOBzh547wCAUWSGEHuQuWm68NC9VBrvyg4CEHvVYCddwB7hRm8mo94x0pob
	YSxRHDhSCR36Wz1qQNjvOMhYkK0qLy1SUH0idIQ6DZ3VV2g/I6mnIGz0vTHTEg==
Date: Fri, 31 Jul 2026 20:23:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: exempt FSCTL_PIPE_TRANSCEIVE from the generic
 file-id lookup
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>,
 linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20260731115424.9892-1-g.blivet@me.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260731115424.9892-1-g.blivet@me.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Before this patch:

     smbclient -m SMB3 -L 192.168.53.210 -U root
     Password for [WORKGROUP\root]:

             Sharename       Type      Comment
             ---------       ----      -------
     cli_rpc_pipe_open_noauth: rpc_pipe_bind for pipe srvsvc failed with 
error NT_STATUS_CONNECTION_DISCONNECTED
     SMB1 disabled -- no workgroup available

After this patch:

     smbclient -m SMB3 -L 192.168.53.210 -U root
     Password for [WORKGROUP\root]:

             Sharename       Type      Comment
             ---------       ----      -------
             test            Disk      content server share1
             ipc$            IPC       IPC share
             test2           Disk      content server share2
             test3           Disk      content server share3
     SMB1 disabled -- no workgroup available

在 2026/7/31 19:54, Gaël Blivet-Bailly 写道:
> From: Gael Blivet <gael.blivet@gmail.com>
> 
> smb2_ioctl() rejects FSCTL_PIPE_TRANSCEIVE with
> STATUS_OBJECT_NAME_NOT_FOUND before fsctl_pipe_transceive() runs. RPC
> pipe IDs live in sess->rpc_handle_list, a separate namespace from the
> ksmbd_file table the generic ksmbd_lookup_fd_slow() gate searches, so
> the lookup always misses.
> 
> Found while testing generic SMB browsing (Finder's "Connect to
> Server"): every DCE/RPC bind over a named pipe (SRVSVC, WKSSVC, SAMR,
> LSARPC) failed right after CREATE. Adding FSCTL_PIPE_TRANSCEIVE to the
> same no_fileid_ioctl exemption as FSCTL_PIPE_WAIT fixes it, confirmed
> by testing a build with and without the change.
> 
> Fixes: 0726814421c2 ("ksmbd: add SMB3 request replay support")
> Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
> Assisted-by: Claude:claude-sonnet-5
> ---
>   fs/smb/server/smb2pdu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 4bde5ab..8d6f42b 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -10133,6 +10133,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>   	case FSCTL_QUERY_NETWORK_INTERFACE_INFO:
>   	case FSCTL_VALIDATE_NEGOTIATE_INFO:
>   	case FSCTL_PIPE_WAIT:
> +	case FSCTL_PIPE_TRANSCEIVE:
>   		no_fileid_ioctl = true;
>   		break;
>   	default:

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

