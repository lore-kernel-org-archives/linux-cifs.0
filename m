Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792963842;
	b=TVfnq6IJAIi9JNLlsU7ZfKbX2GWL5Whz3oiXI5sPYuc95IPI/ezUZjSShBM7WSNHUZRj
	 Y3IuEE++Jrw02wJNy0MXN2DDseiAAuYLYB/e/OqRc8zE/m6q19VPTy3B86AVSnHDgtrp1
	 RAxVOcxa1xCrWdO0zGMmqQYR1gFEw5Em/DTsUQY57MJIvk283z9pfPqxRiGyiDulXVvPu
	 98+A3tSkYs/ZW1Du9WeMJp7961w4qJ/8sUQs+H/vEdgyjJBvSaPg7U9a3Sle6PSf21CJm
	 wf6zEtCmB6iSRo4t4nRzDPphFJ2DXpW+pNSnpprYa2XiTWcQmyJBvJp0V4t3TFXKjWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792963842;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=aL92h1Uv7NEE66S53alksq3YwtJLQSDi0AgnJQ/5iBk=;
	b=31xaNBX3Q/qrXE/cFd1vKWDtvrYyLgbkYIyVzZwIL4M1L6v9bqv3ClQWeVvUjZ4nFD2R
	 EZZr+ucXDSeG4pZxxY04ohguYzrN/m9si9GuLi2isD7UjR+NLQaT9ZrVUwe0ifGRcu4WE
	 Tl1rVp+MIvKR00d9TDUxtDlVxNimOUiBSIl/YiZjLYX9OH/vjiHyrLtgC959IZyHMSk2/
	 EMwIHGCzW9lrVRljDK+tWVBGiFR1fk5dlROOeaP88rrFM+fPUH/neHlhMohrlxi84wBKZ
	 nqghNv4MspNITxcctXs8tbtAd86kjXVcScSO7iqIe187WwFKCnv4ydW6g2immeE9Vkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WL4nL9cR;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=DLLR98b3;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C59606A31A
	for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 21:30:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17C59606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=WL4nL9cR;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=DLLR98b3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792963841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aL92h1Uv7NEE66S53alksq3YwtJLQSDi0AgnJQ/5iBk=;
	b=WL4nL9cRe/j07wefjNh+crFZruojv0j+0b9N73f7i05p78o8vdKRJwRKcbwGJIVTs2AOlT
	tJ8Szc/SFE1G3KAIFW1L8DSqk0qWjkTgxRTzUS5/mafDPNQWwOAj+hcmc3TlaPd+N2Mv+1
	8lqzrm/8pFbHJTmf70+tFoc8g4jwNPc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-6uB6OAhkMOifAxu6GnIuwA-1; Sun, 25 Oct 2026 17:30:37 -0400
X-MC-Unique: 6uB6OAhkMOifAxu6GnIuwA-1
X-Mimecast-MFC-AGG-ID: 6uB6OAhkMOifAxu6GnIuwA_1792963837
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5363b06bcb2so55268711cf.2
        for <linux-cifs@vger.kernel.org>; Sun, 25 Oct 2026 14:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792963837; x=1793568637; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aL92h1Uv7NEE66S53alksq3YwtJLQSDi0AgnJQ/5iBk=;
        b=DLLR98b3oRnlIMWt0XjaEWIPuTdOB/k1X1nFeXlnMvxKFmcOl7VioPjdsBLw05MNI7
         YyfzzOCEJPeLV/+cRlLQX5Spraci8gOUL1KDqO3xkrGEkmS0q8bYJiu5qLq2XR64aXmr
         nzycTp/mbzVSlyqGdyR6614uJ6CTDetbJcd+r4A1K+K3hKkWl8w1xaTIIBRlnND4n7Ha
         WmXA/eefiVP6xsS4JGORBhsyw8YL+BXXVIpKkEhE55Ew3fXVh698VX2Php9VqK+7dHZb
         7zB+gXBE+9ktnkrgEBCck0UwykblRGB3IYdD1W7MSSeZi84Xu7AIoC2pYKmtlgTIybQk
         sQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792963837; x=1793568637;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aL92h1Uv7NEE66S53alksq3YwtJLQSDi0AgnJQ/5iBk=;
        b=w0OAUAe65RUtcdr/6Ct8Ek0mNaZqJVJBJAHb3U3O1Ka1Z8SHD9PbKEBSQNhI1/UbQ9
         Uk8g1b1NqaPElkKLhnPZqRkAMoFlkLS7rvcuog2wsarE6BQkukrD1q9MDfk+9uwmt2yO
         b2dnSAUeYaFGqPL0KPIv1KjhINfxVg3jYU5s2ryyE4QZDtBwNXdhlU+VLsr/ocQ7Vkof
         ivtDdcdlKZyV+JiYhroxEz3SP8WtqI3aTGHBAL7N0yaePnIOZnmvxRRane+yyFOpCCDB
         VgxSl7xttBMHMkEKRkvOMFnrYejfNiiTx7zPiR+GKmytvHW/3Is/7mztGo/C3vWZPjqF
         aI2g==
X-Gm-Message-State: AFq9FYL6HWYmOe7Vvdy/82uAIy/cABu3rIqqUZmvURhv7CLU7TzsRlUL
	95QCECO3rBReXnzcwO0RO1tN1O6F/VB0C5bKU85Sf50xIO6pZ9ntDEB10ko/V9HZm7BZWokYpcb
	Tqy2yUDKevWIiYgvuj/vqTNzZOTSzg/GX6RXFxU/dBiYSyiLYyn+JweSFlggLzxJcbEj1SC6Ux5
	/H8rlXOAiuMCJ6szGXS//ZhbsPUcZnZYaaRdtiLvY7JtZdDbY=
X-Gm-Gg: AYBFou2/upW3eK4y/Plc0jDkQIFfqvOzkYzLnoW2QbWZbANoQJrukES/C8o/jy/0xEF
	jf8MH/vgiSfQLt8DdyPMo64s1rdBiUiTrWU69xVvXhnXKNRUndEb5JxItORfKf51ws2Rh+NgoSM
	1cfaIuLHQ/pEk/3YT6iRfrVT2NLAOVELDNKi9KQ6b7CNtXFqfbHAWmqkIoxqkXW1kFDagk/PAqA
	nqFQgz3GrQbwtk/qD3GJ+zKiAKYHwbzYd7Zy6Uzs1aPzTG79TZ5MrgpCQbVqSeASkiFT7SSQiUk
	O8W85ojU9Pq5k86+42/UMIdrVNFLZQivk/3ublCx7pot6iEUCwhPo3AH7kUUJeDtW0eZ2uNYvtl
	ckrxONwnHoMjPsTkVuJEo0ff0OdWvGIAK1XOaaulF
X-Received: by 2002:ac8:5756:0:b0:536:4482:2c5d with SMTP id d75a77b69052e-5383b5d80b8mr76387931cf.19.1792963837155;
        Sun, 25 Oct 2026 14:30:37 -0700 (PDT)
X-Received: by 2002:ac8:5756:0:b0:536:4482:2c5d with SMTP id d75a77b69052e-5383b5d80b8mr76387411cf.19.1792963836527;
        Sun, 25 Oct 2026 14:30:36 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5383973f314sm40494221cf.24.2026.10.25.14.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 14:30:35 -0700 (PDT)
Message-ID: <2d973a3a-0a94-4f83-84a0-275561db93c9@redhat.com>
Date: Sun, 25 Oct 2026 16:30:34 -0500
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
Subject: Re: [PATCH] smb: client: fix OOB read due to invalid data_offset in
 CIFSSMBQAllEAs
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, pc@manguebit.org
Cc: linkinjeon@kernel.org
References: <20261025204845.3427727-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20261025204845.3427727-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sashiko is correct in both cases.  I will need to fix up both of Sahiko's findings.

Frank

On 10/25/26 3:48 PM, Frank Sorenson wrote:

> Due to insufficient validation of the server-supplied DataOffset,
> an invalid DataOffset could lead to OOB read of kernel memory.
>
> Fix this by verifying that the DataOffset is at least long enough
> to cover the mandatory portion of the response header, but also
> leaves sufficient bytes to contain the response data.
>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>   fs/smb/client/cifssmb.c | 21 ++++++++++++++++++++-
>   fs/smb/client/trace.h   |  1 +
>   2 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index b8c53627f194..35a1c3b614cc 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -6286,9 +6286,28 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
>   	/* check that each element of each entry does not
>   	   go beyond end of list */
>   	/* validate_trans2_offsets() */
> -	/* BB check if start of smb + data_offset > &bcc+ bcc */
>   
>   	data_offset = le16_to_cpu(pSMBr->t2.DataOffset);
> +	if (data_offset < offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset)) {
> +		cifs_dbg(VFS, "data_offset %u out of range [%zu, %zu]\n",
> +			 data_offset,
> +			 offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset),
> +			 (size_t)bytes_returned - sizeof(struct fealist));
> +		rc = smb_EIO2(smb_eio_trace_qalleas_invalid_data_offset,
> +			      data_offset,
> +			      offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset));
> +		goto QAllEAsOut;
> +	} else if ((size_t)data_offset + sizeof(struct fealist) >
> +		   (size_t)bytes_returned) {
> +		cifs_dbg(VFS, "data_offset %u out of range [%zu, %zu]\n",
> +			 data_offset,
> +			 offsetofend(TRANSACTION2_QPI_RSP, t2.DataOffset),
> +			 (size_t)bytes_returned - sizeof(struct fealist));
> +		rc = smb_EIO2(smb_eio_trace_qalleas_invalid_data_offset,
> +			      (size_t)data_offset + sizeof(struct fealist),
> +			      bytes_returned);
> +		goto QAllEAsOut;
> +	}
>   	ea_response_data = (struct fealist *)
>   				(((char *) &pSMBr->hdr.Protocol) + data_offset);
>   
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index 5331ce6dc8b3..5c9a3db05f75 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -67,6 +67,7 @@
>   	EM(smb_eio_trace_pend_del_fail,			"pend_del_fail") \
>   	EM(smb_eio_trace_qalleas_bcc_too_small,		"qalleas_bcc_too_small") \
>   	EM(smb_eio_trace_qalleas_ea_overlong,		"qalleas_ea_overlong") \
> +	EM(smb_eio_trace_qalleas_invalid_data_offset,	"qalleas_invalid_data_offset") \
>   	EM(smb_eio_trace_qalleas_overlong,		"qalleas_overlong") \
>   	EM(smb_eio_trace_qfileinfo_bcc_too_small,	"qfileinfo_bcc_too_small") \
>   	EM(smb_eio_trace_qfileinfo_invalid,		"qfileinfo_invalid") \

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

