Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028014;
	b=Z85vHJLQOLOfNZ9pm5JM+uTeyCNK09I1yvTQ3Uruqh1CvyX9WvesAc7tTyBfCti7sKCS
	 6ISzXROXfQGaKx+roAAY2K56O9eOiZLOnixd742E0NWa42RN7KijivsBBh/DwredpraOl
	 ZypUNRFIL8y4v4693/VMm+B7PBXTHYZK/LI3VBRVUvquBRkr8NCFlH3T02vGVUBO4mMM/
	 iDRj0jIr9wnQPrurE8dZ3EF3LxKwfLTnmTUZ9wUOsEFSjNGE2Ru0Qpkq5nvVaz2zg2bM6
	 lLwpw9J49iv6P65CsejPAuL52bAdnY4M40Q+WoqC+rdKnmmiOc2P277wxh2a9DrDSEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028014;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=GDoT1f97HMSzIl27AFxsGzgU14gBpQzsSaLQbUyRuPE=;
	b=Vn+6jhYVZijrMs+bn7F4xg5I0sZcwrEsnIIi6JYZ4KbA6oZb9ZMPss66RR80RDbfaK1l
	 vUIpTJaMrIRUR1yi++c+sL3mYno7LF3uJeOSVf6v21QSmG3nrSxmVMlzeBpsQdoi/5xzP
	 6JvUmg2rH1/TN+ef14s2BI/kYQFMmxEbP4dxDCT9gxsRbhuu57tAvZRVMtOSpCL/zM+Ci
	 t90k8yuzmI5tfkpjkWkvEDkLdS4Y1wS9Ek4E+QzN2eR9/ez2uff8fqxqRgnZanBoY8Cgh
	 gokELWeA6Ds6ojT+/DLtG5qugzaFHS3ZdJy+zns5MtFGyroRVbYhNriZrWK9Jr2DPsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ToNzRoTL;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1330E606A31B
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 15:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1330E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ToNzRoTL
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3adf5f6833cso1115028a91.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 08:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028013; x=1793632813; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GDoT1f97HMSzIl27AFxsGzgU14gBpQzsSaLQbUyRuPE=;
        b=ToNzRoTLP4HJzM6XNq6Q3Qj8LuNiIenfeWp0aOxyA/K5ytxu5ZsC3I2YihUkowTmBo
         6xPeIK7d7VwVycUAy+tvEa3GZwfo803+5TJb1itvtPBr/NEiZIYAbLpKdE0YTXA9ANNf
         2AeuzW1okTGm/goAuj8aI465AEMoDrCdRKDM6fDi9xoG4MpsrbMkmUH6hYutlRz7zi8t
         1nnsRv4+ERNzZuHxkeZxVX/GWP6HEClUCjqp5Hbd+JQYze4gglesifdNgYVts8EtPLwQ
         RLDBiFme4GMN/7InZpF7Bxl88jdxwOKnuIjMOHNMuHQUOkAwL6lGJ8jOPGFOuVmORTL3
         R9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028013; x=1793632813;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GDoT1f97HMSzIl27AFxsGzgU14gBpQzsSaLQbUyRuPE=;
        b=iGTLwtVnbVeaj+VGhVItiqwGyyJIATq3wyQ04XDUfjMqHiCzxNrzec67vkPTWMkeSj
         XTegx6ZKxqarLMYOwggUDjq252cyz3BFLqHGJ3pkqs9ygXbych3OZ1hGcrKHjw1CxcXn
         dd5484Go4cWzeYEaQSPntS/nlnfCG4tZEcdpDYFEShwi32ytnB0ODoUknvsUJuiFUI0z
         Le4BPLhj9cGs88xyqkLAaWMJRjO4OBk4axQkCPafi+DPeNk1UNhx2b0r2r9dOR/G0qp+
         /IDblG6YgAwC/lOCLg7ehrGlgJPCkCKQqV0CQpNz4oHfM9nQ7Z1fYsGyUq1ytKfsasH1
         7roQ==
X-Forwarded-Encrypted: i=1; AKwUvByERTAPaQ096SeB+snL7ejeLTX/Isf7KKeehSKCl5x+TpK3ae3Gum3tC/XD77XR8RSnBjugNjEZmrDA@vger.kernel.org
X-Gm-Message-State: AFq9FYK3kmfkS1jrMZfZRBwV2nsyNxZwaY8I0P4uI/IrLC/ugLL6TX/4
	zGuF3IljXWrLHc9UpP4inPxelISFSecn9uRwFnwPqk2g4zIy3HdKUQw9
X-Gm-Gg: AYBFou1sMiWfajRFva/0GGlchY3ONs5j6NdGGQpRa52QEer9IqDU1lxNGs9W7VLJjBf
	tkpt/7AIdpYnD7jWif5WCPcJX5HwQmokh80XmCkcKan3CHWadPVvk4czBr2es/Y6j1yGws6feFT
	xa1PeV09wogsUuDrGdgdFMrA7uJlr9dONCCbVuQcVjHu5gjxvFSny55t/ot3VbnNE/6HiEfdg0j
	CSBJoMvCKKvTJnTk+jPm/2AhqWOinZTPT9lKMM84LbT1L7joDnis5QLF2YJcdUpqKqe94KEyIOk
	RF81xmOajOGsdMYCO+bbpE3rRwAk2OCwXT47ODZ1YwCaS9lj0/1Rftyi4xRXpk4DZfdRB3ff65t
	AmcG67jDY129B5ueaM5Pt3BmuoRhBIIh1CZkcfBZFszmmHkaw04uZDqhwPdq6FtrswEccRJ0iRy
	V4odbBvz3tZL44KPzNdfUuorKEEl3i6MwrrjPBFOVLX0rLHUFsQlFbTSOzprnO3I7jwQ4o/8WaX
	K7REVCWuMdZn00OGBJ3F0tNPs7Xq3OPaj6v0mjgXRBiF1g=
X-Received: by 2002:a17:90b:4a81:b0:3a8:a98c:ea07 with SMTP id 98e67ed59e1d1-3adea8966e7mr5384743a91.13.1793028011866;
        Mon, 26 Oct 2026 08:20:11 -0700 (PDT)
Received: from [198.18.0.1] ([38.182.104.55])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8ccc682d8sm1799598a12.18.2026.10.26.08.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 08:20:11 -0700 (PDT)
Message-ID: <af546d6b-d1c0-45df-8f81-ad839e7e4d6d@gmail.com>
Date: Mon, 26 Oct 2026 23:19:58 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksmbd: fix named-pipe reply loss with small output
 buffers
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
Content-Language: en-US
From: Wang Zhaolong <wangzhaolong633@gmail.com>
In-Reply-To: <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Namjae,

>
> if (rpc->pending)
>     rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
> Should we add this check ?
>
>> +       goto done;
>>
>> +empty:
>> +       err = ksmbd_iov_pin_rsp(work, rsp,
>> +                               offsetof(struct smb2_read_rsp, Buffer));
>> +       if (err)
>> +               goto out_put;
>> +done:
>>         rsp->StructureSize = cpu_to_le16(17);
>>         rsp->DataOffset = 80;
>>         rsp->Reserved = 0;
>> @@ -9349,7 +9375,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
>>         rsp->hdr.Status = smb2_pipe_error_status(err,
>>                                                 STATUS_UNEXPECTED_IO_ERROR);
>>         smb2_set_err_rsp(work);
>> -       kvfree(rpc_resp);
>>         return err;
>>  }
>>
>> @@ -9947,7 +9972,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
>>         if (IS_ERR(rpc)) {
>>                 err = PTR_ERR(rpc);
>>                 rsp->hdr.Status = smb2_pipe_error_status(err,
>> -                                                       STATUS_INVALID_HANDLE);
>> +                                                        STATUS_INVALID_HANDLE);
>>                 smb2_set_err_rsp(work);
>>                 return err;
>>         }
>> @@ -11440,20 +11465,25 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
>>         struct ksmbd_rpc_command *rpc_resp;
>>         struct ksmbd_session_rpc *rpc;
>>         char *data_buf = (char *)req + le32_to_cpu(req->InputOffset);
>> -       unsigned int nbytes;
>> -       int err;
>> +       unsigned int nbytes = 0;
>> +       int ret;
>>
>>         rpc = ksmbd_session_rpc_get(work, id);
>>         if (IS_ERR(rpc)) {
>> -               err = PTR_ERR(rpc);
>> -               rsp->hdr.Status = smb2_pipe_error_status(err,
>> -                                                       STATUS_INVALID_PARAMETER);
>> +               ret = PTR_ERR(rpc);
>> +               rsp->hdr.Status = smb2_pipe_error_status(ret,
>> +                                                STATUS_INVALID_PARAMETER);
>>                 smb2_set_err_rsp(work);
>>                 return 0;
>>         }
>>
>> -       rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
>> -                                  le32_to_cpu(req->InputCount));
>> +       /* Write new input without reading past an already buffered reply. */
>> +       if (rpc->pending)
>> +               rpc_resp = ksmbd_rpc_write(work->sess, rpc, data_buf,
>> +                                          le32_to_cpu(req->InputCount));
>> +       else
>> +               rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
>> +                                          le32_to_cpu(req->InputCount));
> This WRITE leaves KSMBD_DCERPC_RETURN_READY set in mountd. After the
> cached reply is drained, the next TRANSCEIVE can return the previous
> reply without processing its own input.
>
> Thanks.


Thanks for catching this.

I reproduced the sequence you described and confirmed the problem.

For the READ path, your suggested STATUS_BUFFER_OVERFLOW check looks
appropriate when a positive-length read leaves unread bytes from
the same reply.

For TRANSCEIVE, I think the correct fix needs some discussion.
One possibility is to return STATUS_PIPE_BUSY when cached reply
data remains, without issuing another IPC request or consuming the
cached data. The client would need to drain that reply through READ
before submitting another transaction. MS-FSCC §2.3.48[1] lists
PIPE_BUSY for a pipe containing unread data.

However, I would like to confirm that this is the intended behavior
for this SMB2 path before preparing v4. Simply omitting the WRITE
and returning cached data would still silently discard the input.

Would rejecting the transaction with STATUS_PIPE_BUSY be appropriate
here, or would you prefer a different approach?

[1] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f48cecf1-98d8-48dc-926f-2f3a48f07cf6

Thanks,
Wang Zhaolong

