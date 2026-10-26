Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793014440;
	b=AC1xVMtKDgNaSSG43Ptrz3EJjmmq+t53xWYn4XzBSuEBVZPPkre60IAn3nWF3w72CY4k
	 7u2w9bJPJ9dAQxAkNr2zDHH2S+irMuUkzpVGFIh3wfNTw3tXIKpaQbMpPhN68fSU7+dk1
	 k2H10Sww3Vipsr2O4DBhHmdI6Pr9bWZIADBAYDYXA3J+tVQ+LSgCdWzXU5M5kpARKPVMj
	 dMlCbZ7s1tI73Ag7QTS+5qomHmkHW3NFpzXu6s1mQ8baa/Bx/OIFd0EBuTSCTSnKOBXCI
	 +6IM6JgEX1wPD1N8/qKN4hZ/IGbcg1wnHlnr2tdL0YjlyM+uB+3Goku5OWPzM7oVgMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793014440;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=EnoQwbQDOol9R6saHZYobfo+/Uc//qo+uchucMOY9GY=;
	b=LuSz6G8lVVgmA9ZKPRHSjkoNwH1eK1afFUvwzArnkSiCiciAN50gqwau5ycIiVDIZ1lP
	 8b2IhGRVF4XiLdK5hG3nVDDN7MbhQ3RDju4xm7lsjTUZPM33DQw5oeYBSEeldMNRgnQi9
	 WFc9Ev/2w2mhcbG+BUbELgQc95SRSLpivZsb0TTgWXe0Sxiwe1Y/kVxWPo5kYkGr8JfEG
	 +BgSkY4YJmr0nVBl9DBEunOjnRitZXL/Nr3pEAXvxBLbwQ6Ygue3SzH/HxyYDgBW2R9/L
	 SWmqzbt8scyywt+PZS0BrHuZVNnbRmGusBlkWi3AJ5r4+pMHtge51hY71fDxgfYCUkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k9ROjH6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92BB606A321
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 11:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k9ROjH6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8723D1F01825
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 11:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793014439;
	bh=EnoQwbQDOol9R6saHZYobfo+/Uc//qo+uchucMOY9GY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k9ROjH6uHOM+m8BEHHXTq+MD06SvSFwMaTHt+YoL3WM/iCp5CdsW7Jhfjeju8ZJMr
	 R33P+eTLzuc8vVXXqndaa1DtVCwM07ZZ8Hjmq4AzQVrxIDnAf4TJwYLdqjQnAZ51Bz
	 I6P//zIZ3awnUZgCqvLuK2vSrg2uQkLN0zGPyH+3xkl4y5S7QoNdKzvbCW23pWODzX
	 rMnmCqnBYOgipENgp9BONY+96O/eL0/qCBZFKO2qm3/u7ZqELKwoSGIjAbR5k/SHJ+
	 0pRAwYzwKKIhmvAmk07O1YQhi97xoKDlVDkJ1M/fzuqUNdDbcvMDhuBFEUh0S3hN1x
	 G9ug+LmYxgjjg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c498fa2f365so101854866b.3
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 04:33:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxzZCCz98XpW0gsxrRYHhpzS5kh1CdJ4uDEsVTTGRF6N6ImMoYYlshLnLjqjMw5KriuZQvci7UpD/z9@vger.kernel.org
X-Gm-Message-State: AFq9FYIc2i2xCphTMUXWTRs8eGWVU6QkcsDKb4TGAekb+LptcbX41wPj
	zJVlyognSPdmdTe+2LnMmX6XACoXer2AY/aU9mcrxVQHnsweR7EsodvsYZLsqxjCYVk7Vh/NB3K
	G/ZmHjxakFPVaNjwqOhFJTBMYeYfxXGM=
X-Received: by 2002:a17:907:86a8:b0:c41:53a9:c65c with SMTP id
 a640c23a62f3a-c46bde7f3bemr744230866b.34.1793014438182; Mon, 26 Oct 2026
 04:33:58 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
In-Reply-To: <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 26 Oct 2026 20:33:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
X-Gm-Features: AclHuK9wyvhGZ0Z_cDfHThPRIQVqxvlYYneHouD6ekkP3yRVT6ncgYJTKQ-07wY
Message-ID: <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ksmbd: fix named-pipe reply loss with small output buffers
To: Wang Zhaolong <wangzhaolong3@outlook.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -9294,46 +9307,59 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
>         rpc = ksmbd_session_rpc_get(work, id);
>         if (IS_ERR(rpc)) {
>                 err = PTR_ERR(rpc);
> -               rpc_resp = NULL;
>                 goto out;
>         }
> -       rpc_resp = ksmbd_rpc_read(work->sess, rpc);
> -       if (rpc_resp) {
> -               void *aux_payload_buf;
>
> +       length = le32_to_cpu(req->Length);
> +       if (!length)
> +               goto empty;
> +
> +       if (!rpc->pending) {
> +               rpc_resp = ksmbd_rpc_read(work->sess, rpc);
> +               if (!rpc_resp) {
> +                       err = -EIO;
> +                       goto out_put;
> +               }
>                 if (rpc_resp->flags != KSMBD_RPC_OK) {
> +                       kvfree(rpc_resp);
>                         err = -EINVAL;
>                         goto out_put;
>                 }
> +               rpc->pending = rpc_resp;
> +       }
>
> -               aux_payload_buf =
> -                       kvmalloc(ALIGN(rpc_resp->payload_sz, 8),
> -                                KSMBD_DEFAULT_GFP);
> -               if (!aux_payload_buf) {
> -                       err = -ENOMEM;
> -                       goto out_put;
> -               }
> +       rpc_resp = rpc->pending;
> +       nbytes = min(length, rpc_resp->payload_sz - rpc->pending_offset);
> +       if (!nbytes) {
> +               smb2_pipe_response_done(rpc, 0);
> +               goto empty;
> +       }
>
> -               memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
> -               if (rpc_resp->payload_sz & 7)
> -                       memset(aux_payload_buf + rpc_resp->payload_sz, 0,
> -                              ALIGN(rpc_resp->payload_sz, 8) -
> -                              rpc_resp->payload_sz);
> +       aux_payload_buf = kvmalloc(ALIGN(nbytes, 8), KSMBD_DEFAULT_GFP);
> +       if (!aux_payload_buf) {
> +               err = -ENOMEM;
> +               goto out_put;
> +       }
> +       memcpy(aux_payload_buf, rpc_resp->payload + rpc->pending_offset, nbytes);
> +       if (nbytes & 7)
> +               memset(aux_payload_buf + nbytes, 0, ALIGN(nbytes, 8) - nbytes);
>
> -               nbytes = rpc_resp->payload_sz;
> -               err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
> -                                            offsetof(struct smb2_read_rsp, Buffer),
> -                                            aux_payload_buf, nbytes);
> -               if (err) {
> -                       kvfree(aux_payload_buf);
> -                       goto out_put;
> -               }
> -               kvfree(rpc_resp);
> -       } else {
> -               err = -EIO;
> +       err = ksmbd_iov_pin_rsp_read(work, rsp,
> +                                    offsetof(struct smb2_read_rsp, Buffer),
> +                                    aux_payload_buf, nbytes);
> +       if (err) {
> +               kvfree(aux_payload_buf);
>                 goto out_put;
>         }
> +       smb2_pipe_response_done(rpc, nbytes);

if (rpc->pending)
    rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
Should we add this check ?

> +       goto done;
>
> +empty:
> +       err = ksmbd_iov_pin_rsp(work, rsp,
> +                               offsetof(struct smb2_read_rsp, Buffer));
> +       if (err)
> +               goto out_put;
> +done:
>         rsp->StructureSize = cpu_to_le16(17);
>         rsp->DataOffset = 80;
>         rsp->Reserved = 0;
> @@ -9349,7 +9375,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
>         rsp->hdr.Status = smb2_pipe_error_status(err,
>                                                 STATUS_UNEXPECTED_IO_ERROR);
>         smb2_set_err_rsp(work);
> -       kvfree(rpc_resp);
>         return err;
>  }
>
> @@ -9947,7 +9972,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
>         if (IS_ERR(rpc)) {
>                 err = PTR_ERR(rpc);
>                 rsp->hdr.Status = smb2_pipe_error_status(err,
> -                                                       STATUS_INVALID_HANDLE);
> +                                                        STATUS_INVALID_HANDLE);
>                 smb2_set_err_rsp(work);
>                 return err;
>         }
> @@ -11440,20 +11465,25 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
>         struct ksmbd_rpc_command *rpc_resp;
>         struct ksmbd_session_rpc *rpc;
>         char *data_buf = (char *)req + le32_to_cpu(req->InputOffset);
> -       unsigned int nbytes;
> -       int err;
> +       unsigned int nbytes = 0;
> +       int ret;
>
>         rpc = ksmbd_session_rpc_get(work, id);
>         if (IS_ERR(rpc)) {
> -               err = PTR_ERR(rpc);
> -               rsp->hdr.Status = smb2_pipe_error_status(err,
> -                                                       STATUS_INVALID_PARAMETER);
> +               ret = PTR_ERR(rpc);
> +               rsp->hdr.Status = smb2_pipe_error_status(ret,
> +                                                STATUS_INVALID_PARAMETER);
>                 smb2_set_err_rsp(work);
>                 return 0;
>         }
>
> -       rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
> -                                  le32_to_cpu(req->InputCount));
> +       /* Write new input without reading past an already buffered reply. */
> +       if (rpc->pending)
> +               rpc_resp = ksmbd_rpc_write(work->sess, rpc, data_buf,
> +                                          le32_to_cpu(req->InputCount));
> +       else
> +               rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
> +                                          le32_to_cpu(req->InputCount));
This WRITE leaves KSMBD_DCERPC_RETURN_READY set in mountd. After the
cached reply is drained, the next TRANSCEIVE can return the previous
reply without processing its own input.

Thanks.
