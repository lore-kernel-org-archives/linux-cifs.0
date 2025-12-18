Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3612A33E342;
	Thu, 18 Dec 2025 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766070608; cv=none; b=Q8qDer3OPEsnYh7fj0vA6JyQx2rfTpJAFoI/ccrUASDr1vmE0oKQaEnq0kT9m7ZqOnzdXuyJRHj1cW2kchMHz2dsGOr41RuMRp4kEkEIeKFhSTog0Db35Aznd7p4M1rZfYpFfMR16Jjm2Et/5ywRMlFUJxLMsZ/lH/VolCsNexE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766070608; c=relaxed/simple;
	bh=BUmnQxqOJ3d00ZoaOpUEYSmpHz3NYcD6l1+3MK6nDHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3VGLJNmTyiXRx/orGFdAIcfmYmY2WnR8xNBsMCFJfTKhIP1ERJSC86U/bJfnGuEhfYTCqmsEDfs2FLHjAKYv9taLyeTEiUslTnFKzK0tn/+/Ccrj83LIhYTJ5gxKPD513cOtShpNCHQk9+MII5umJRMdauobWBK/ewPoOt2s3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pjdooKeH; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pjdooKeH"
Message-ID: <b5ebd3be-c567-44bb-9411-add5e79234dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766070592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y6p6e/EZtS1hyywF6vdE4TQ+N9KvYFnksenMNlGoM3E=;
	b=pjdooKeHo20UlE+eNbSSyoDL8aAJeLpUdbhzUrzvJPNy8EMF7p0lz2X3FuIE9PZprDIQv6
	k5OOM5ColSzuPioxGHLLJ1G8v4ZBqqDQjjQe5kVSLwtHm3mgua4UD94GyNeKN4JTg3YMNF
	+xSuwSX3byYe6NFX0ahdrdFhnx9jQkI=
Date: Thu, 18 Dec 2025 23:09:32 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: Fix to handle removal of rfc1002 header from
 smb_hdr
To: David Howells <dhowells@redhat.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <sfrench@samba.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, Paulo Alcantara <pc@manguebit.org>,
 Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org,
 netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <712257.1766069339@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <712257.1766069339@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

`ksmbd_conn_handler_loop()` calls `get_rfc1002_len()`. Does this need to 
be updated as well?

Thanks,
ChenXiaoSong.

On 12/18/25 10:48 PM, David Howells wrote:
> Hi Namjae,
> 
> Does this (untested) patch fix the problem for you?
> 
> David
> ---
> The commit that removed the RFC1002 header from struct smb_hdr didn't also
> fix the places in ksmbd that use it in order to provide graceful rejection
> of SMB1 protocol requests.
> 
> Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
> Reported-by: Namjae Jeon <linkinjeon@kernel.org>
> Link: https://lore.kernel.org/r/CAKYAXd9Ju4MFkkH5Jxfi1mO0AWEr=R35M3vQ_Xa7Yw34JoNZ0A@mail.gmail.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Steve French <sfrench@samba.org>
> cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> cc: Tom Talpey <tom@talpey.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Shyam Prasad N <sprasad@microsoft.com>
> cc: linux-cifs@vger.kernel.org
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>   fs/smb/server/server.c     |    2 +-
>   fs/smb/server/smb_common.c |   10 +++++-----
>   2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
> index 3cea16050e4f..bedc8390b6db 100644
> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -95,7 +95,7 @@ static inline int check_conn_state(struct ksmbd_work *work)
>   
>   	if (ksmbd_conn_exiting(work->conn) ||
>   	    ksmbd_conn_need_reconnect(work->conn)) {
> -		rsp_hdr = work->response_buf;
> +		rsp_hdr = smb2_get_msg(work->response_buf);
>   		rsp_hdr->Status.CifsError = STATUS_CONNECTION_DISCONNECTED;
>   		return 1;
>   	}
> diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
> index b23203a1c286..d6084580b59d 100644
> --- a/fs/smb/server/smb_common.c
> +++ b/fs/smb/server/smb_common.c
> @@ -140,7 +140,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
>   	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
>   		return ksmbd_smb2_check_message(work);
>   
> -	hdr = work->request_buf;
> +	hdr = smb2_get_msg(work->request_buf);
>   	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
>   	    hdr->Command == SMB_COM_NEGOTIATE) {
>   		work->conn->outstanding_credits++;
> @@ -278,7 +278,6 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
>   						  req->DialectCount);
>   	}
>   
> -	proto = *(__le32 *)((struct smb_hdr *)buf)->Protocol;
>   	if (proto == SMB1_PROTO_NUMBER) {
>   		struct smb_negotiate_req *req;
>   
> @@ -320,8 +319,8 @@ static u16 get_smb1_cmd_val(struct ksmbd_work *work)
>    */
>   static int init_smb1_rsp_hdr(struct ksmbd_work *work)
>   {
> -	struct smb_hdr *rsp_hdr = (struct smb_hdr *)work->response_buf;
> -	struct smb_hdr *rcv_hdr = (struct smb_hdr *)work->request_buf;
> +	struct smb_hdr *rsp_hdr = (struct smb_hdr *)smb2_get_msg(work->response_buf);
> +	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb2_get_msg(work->request_buf);
>   
>   	rsp_hdr->Command = SMB_COM_NEGOTIATE;
>   	*(__le32 *)rsp_hdr->Protocol = SMB1_PROTO_NUMBER;
> @@ -412,9 +411,10 @@ static int init_smb1_server(struct ksmbd_conn *conn)
>   
>   int ksmbd_init_smb_server(struct ksmbd_conn *conn)
>   {
> +	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb2_get_msg(conn->request_buf);
>   	__le32 proto;
>   
> -	proto = *(__le32 *)((struct smb_hdr *)conn->request_buf)->Protocol;
> +	proto = *(__le32 *)rcv_hdr->Protocol;
>   	if (conn->need_neg == false) {
>   		if (proto == SMB1_PROTO_NUMBER)
>   			return -EINVAL;
> 
> 

