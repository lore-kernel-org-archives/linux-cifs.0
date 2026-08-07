Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76093BCD2F
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 20:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786133777; cv=none; b=MokCxjYc3tlwq5XYfllGTBBfRyWBNcOXo263Dwy8pF6Y2albE3bVtNwHNe1NZqS912j2tSonO0eInY/10cToshpmFBd03psb7HxXiyDmZGxvTVDwMUKybBkxP2f6t5VpT8F+ZYlmbVbzLlaz0cqMQ/tHG8IHy7RqCa+92VbW3MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786133777; c=relaxed/simple;
	bh=nWpADil6eJoTNo1XCQ8JzmPKFCnQ1EsztrAUiLjGVqw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=D62lzdyLF07a4QD58YkrP5/plGU82+rj4XnDqC9CbmxcAYxuaEDACx6IcnEIufuZFL94C3jdgaQtXz3I3LBEsWgkoVbpCfazIHIwOWO61GVJekXaPzMAqdjMC7+XvOAj0e6R7OO5FWhFiBIuyX0m01TZoBSGUczLL7Y2yNON0HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vq9M73Q4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SpJSPMPe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vq9M73Q4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SpJSPMPe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786133774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jgjapU+OWmRMKjoM6AGnQ3v+7mZANAmnXlSRZgcZulA=;
	b=Vq9M73Q4Ia7hDAbK/ALTEMFvaph1V/RUIdUi0EgP5vf7XY9zpIZBmK33CRgOEF9w2ESnf9
	PCK16yA0lXzFiypXIp2rx5siR7qEbfXwPx6gV1e8xPl53jHDD3Yf7OYmvE36P06YwEhsfb
	MTVRFFDFaIReUpx4i3wwMVYRktLzEDw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-grwahUEvO4CC5NQtXf8CgA-1; Fri, 07 Aug 2026 16:16:13 -0400
X-MC-Unique: grwahUEvO4CC5NQtXf8CgA-1
X-Mimecast-MFC-AGG-ID: grwahUEvO4CC5NQtXf8CgA_1786133772
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4954fd771baso14660425e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 07 Aug 2026 13:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786133772; x=1786738572; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jgjapU+OWmRMKjoM6AGnQ3v+7mZANAmnXlSRZgcZulA=;
        b=SpJSPMPeO/SGxAGzH7TCVH9eXQFAXsgzealjkcZYwh57S7OrGlTXPiNiioZI6ukeO4
         m3w1rcS2Qwq5/JqH0YNTnSGcyJ5W3y3EmRfoAeJs42m3iRxDHJxngANmmeVv4Yp3GvDz
         a+dRN4lsnXNN/j5mTdLe4ehD3Jefs9NgR+WMahXRvaOp7Pb+yhpoB0E7AdPQ6/8mcHyw
         7IunfRHS9DHDPEPK/1sJSDtbpQy6pVq7mG+9rMHJ7eHhKSWsXB3GjdqDQqVpWfWs+kLZ
         6bM38bdj7D48LBDbcgjdM9Cnbmb64xJvBzu9c9A6LHnBWTcBuAm48HTJWN+3OzzMVjly
         9NoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786133772; x=1786738572;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jgjapU+OWmRMKjoM6AGnQ3v+7mZANAmnXlSRZgcZulA=;
        b=pYhQ/sJ/3+7tPGUZhflN4w32tYZthLiZes5VsuNGeUVcmA+PZT/736ZWRraOD5MyFc
         h9zb2M3XZUka+vjBfx9cpl3ZYzwRxob1/D0WlcuhJoWFyQ6vL6yWYuJApd4ML2DQrfbG
         22bZ+ObYViBEUJyT/E3+k04OfdtMWadqN0y67742beQXGBhP157SJmlWlw+3ILMG6X7m
         lpMnwFmuuGKIXqmw4shqXb44lCVVK9vChWtnFmFizctqVNTDjZ4ogF6AFMmhQDHgcuPV
         CKrsipnN9lebis9Hip7HH/Vk//AMhld7rwyfM7Ymhk3tA7Sg+ctGFrGX3x4ZjqfKEw4l
         vBcg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1tHVHMlDfJ6ZkH08RjmGW3WfHuD4aRyKlDw718iFDaYo6BodwJyEjHzGq5RBciFZRg7iBcHfq0jOi@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4WvwNdnRz78bvJTOA69KKWrBkONgJP0qQZf+rg93f0RdB80eP
	zmQtDkOmVCH22YTLlzGb8Wdfhi0Iv4TAKOa5URX8o2BzxJR9N6lGImvxS6uKG3AD5/2MAe8O6e8
	+C0sMhe3CKnPT98w57ndaFY2hzejzZzoxlEmvmyrJuA//3TL9///s6GAhauLW0to=
X-Gm-Gg: AR+sD11HkW1poGTSm3rp6kXtlSMvGt3NMOBS/oNZMZsi8gfw9q++8eJ9rW5Cfl6/pCf
	MtsCdapVARRYGDFGAMWqNVgFK745AIm6w7tlQ+Wd8mGnHQN9/dCUKFSHOkzJ4qli62TapmMCNbx
	htIxJNJKeAL5SGBI/KOo2Tf6HAgNaGuF1nQn/w/R88aFM7PqD/UdsAnuiJVguvvzUmmDP01/6rk
	WoxvnwsaQBmH/jzjEmeYigwSb4bxcizDqSRid0mDH1fX4zlwlGbjMhWXmv4QRi0sAiPwGkJc5Gz
	cMq9QQcCEjRoRU4ZKS64Clquy+LIMsgJFMnu91JdrsUe8ObEA5lEE6Bn31oDtZPD4HBM8hwe
X-Received: by 2002:a05:600c:8a6:b0:498:1577:e11a with SMTP id 5b1f17b1804b1-499624840d3mr10053565e9.5.1786133771985;
        Fri, 07 Aug 2026 13:16:11 -0700 (PDT)
X-Received: by 2002:a05:600c:8a6:b0:498:1577:e11a with SMTP id 5b1f17b1804b1-499624840d3mr10053345e9.5.1786133771525;
        Fri, 07 Aug 2026 13:16:11 -0700 (PDT)
Received: from [192.168.0.9] ([47.64.115.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm9553658f8f.1.2026.08.07.13.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 13:16:10 -0700 (PDT)
Message-ID: <17fe311c-f47a-424f-8977-81c88d820e80@redhat.com>
Date: Fri, 7 Aug 2026 22:16:08 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: server: Clear sensitive stack and heap data in
 auth.c
From: Thomas Huth <thuth@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260807171024.1529513-1-thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20260807171024.1529513-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/08/2026 19.10, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Sensitive data like keys that are stored in stack-local arrays could be
> leaked via the stack to the calling functions, or via the heap when using
> only normal kfree() functions. There is no known vulnaribility for this in
> this code right now, but it's good security style to explicitly zeroize this
> sensitive material as soon as possible to avoid that it could be exploited
> together with other bugs later.
> 
> In calc_ntlmv2_hash(), the struct hmac_md5_ctx is normally cleared during
> hmac_md5_final() already, but in case of errors, this function is skipped
> and ctx is never zeroized, so add a memzero_explicit(&ctx, sizeof(ctx))
> there to fix the problem.
> 
> In ksmbd_krb5_authenticate(), the ksmbd_spnego_authen_response contains
> the session key in the payload. It's currently freed with plain kvfree().
> Let's better use kvfree_sensitive() instead.
> 
> In generate_key(), the prfhash[] array is used to calculate the key,
> but it's never cleared, so it leaks on the stack. Thus clear this with
> a memzero_explicit(), too.
> 
> In ksmbd_crypt_message(), the sign[] and key[] arrays are leaked via
> the stack, too. Make sure to clear them via memzero_explicit() at the
> end.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>   fs/smb/server/auth.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
> index 4e7b6f0e6b8cd..acdac40bee813 100644
> --- a/fs/smb/server/auth.c
> +++ b/fs/smb/server/auth.c
> @@ -122,6 +122,8 @@ static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>   out:
>   	kfree(uniname);
>   	kfree(domain);
> +	if (ret)	/* Done by hmac_md5_final() already if ret == 0 */
> +		memzero_explicit(&ctx, sizeof(ctx));
>   	return ret;
>   }
>   
> @@ -464,7 +466,7 @@ int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
>   	*out_len = resp->spnego_blob_len;
>   	retval = 0;
>   out:
> -	kvfree(resp);
> +	kvfree_sensitive(resp);
D'oh, self-nack, I really should not send patches in a hurry on Friday 
afternoon, sorry!

I will send a fixed version next week.

  Thomas

