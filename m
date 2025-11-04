Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C891D26FDB3
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 16:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273551; cv=none; b=itx0cfnvqbcuYR9PCjzVJQo4LP5onyd4mYmFI8ys2gwLx0LR+pLq/Z6EFaFau20KrBSnD6nWoswxDAGh3zxlLMgkrGPhz4xDsLjn6uT8igssYmH/GzJh1V1F0lF+I+7Wys83xp9vOkKwoSrTxTNrJOZZ1Oso2T0mD5hMpSgC6I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273551; c=relaxed/simple;
	bh=qtUlZPIvwB/gYjNgToSLBp2+/9TzzxHQwlQvLSmCuas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J7Gh16lguhHmo3gqnoyAHhH5LOM1SoT/jBrVTSOiureKwwCUtDOLGGnAIOJN2meln7r+mEj4aJYh1A6ZJJcErQLrufu5IIwSrW0siR2TDITI97QSPK5/7q6k7GQ+oHkzQsQEtik8qQQ2FnMbALJmPS0k9U2DSTFOe4NirFfmrNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DE5KIayB; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DE5KIayB"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso2382825f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 08:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762273546; x=1762878346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cVEicm+5HOPZi8EXNv//e7Ln/RMba4QPS1zib01aWog=;
        b=DE5KIayBW5I5oJxy7IFkVMtf7QUBgIhSLZlCmFY3J4P3gjvqtoemuqomAcOAAqXuFm
         KZewJtClhFAMzPmRD76GGJFerbdSDvV3PhnTz3g4t8NYim1c4jrHSSA34XG63Higikwn
         H5OFVCGxL3rFI3qxUOgiI5jX+RcPCJ8hFhJgjOYmtUKpXbV71gktgK1lxGV6g/tw0ORz
         R7u5RN+9H2MOU9yPluqX74QT6p1FJQWnvy9J7aAJiKrZjhuQF95Df1Y9C5Hq86GOKxXm
         19NYk9W7ExALV5bFTeBVAPhCVkVcjKR/YacrNN9Em6pwdwLOPfp332RkBOX8WMs+izx/
         pDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762273546; x=1762878346;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVEicm+5HOPZi8EXNv//e7Ln/RMba4QPS1zib01aWog=;
        b=vmuDK/iTeAwxSKljc9iY9fCVgfeuYHht/DqfRaMCx5aDCN4LBDDrz0qPh+zTom2wn2
         3ckAsrilQD7RcdMWKqOeRD4yVLVJ1RiqiPYuukPMMdRHY4uGxkuPGHjf2biIFzhugQay
         Ny4dm4IXpc4H/AX1gf/DFeyouGBDsft2oB9UlsRfrJmyO0emtTdHvrrpznZepy5fM5kH
         bmCBR/G+ZxRAhfLNFYJY2gRrlirHV4Fce3chuYww0+r3RMQTRu8C/gdEmRc+i4a9KJ6a
         pP+tc/604LqamrCl9uHQ7gipKThh56GSecKOwP39DdzGo4Sbwtjwc+PLmZFzXD3D5+uG
         c94A==
X-Forwarded-Encrypted: i=1; AJvYcCXJSPJXtWus8ROm+lHd2eik4cXbd4KJeVO14l/oHvF7NtdLpFGAXeX/RJH48qPdHaUAa6vLKSeXaBnB@vger.kernel.org
X-Gm-Message-State: AOJu0YzuCYsA6mqMIT5Qyqg0+Jb4QMZOVV9vDk38Jug9I4Un5sEKEEfV
	PFYDVdjg0E0Z48PxHzqcp2WLVrFs9R/Cn5reOZSePvIeziWR5k7afyU51AYG7ujYOOo=
X-Gm-Gg: ASbGnct5cNlLAPRnCo/8BzHQ5FWzGMY8hzMaY5mOSDBx24k+b1ZHXtJuc1O2JRaTedU
	6ofAnIuqp31qFm5P5W48kefIsqOg8wPasAjGpuxhy223565xYCoXm2j1H/Kq5wNuit5gIbVFSrn
	AuN9Jz7eW+Ih+bnye9HGZsvL1mwMjedCF2C9/QtdjyDGl8ZhD0trO4ClQANpFf2pp1P/kNMvrKt
	fliv2WIj5uoqeEGebCleAST1EUqYgyRbUmoOXgukyjYh5bvZed0984SA8YuJ4sewn+Frz3doG+M
	lQsbe93vGG9j0Pr+gy2U5hfgKDkP0Ka+FoG2rizI61z5pJIEjK24kgYZmEgtRm8ezg2AUnpb+d2
	msXn83u3anFcqNIl2gLJ+Y7hGxi44t+7Gvs59eiUmhE1/zrY4F/auBRfrM6FRv3M6bB8q8enDDF
	53HRvgj8BhN4sm
X-Google-Smtp-Source: AGHT+IEl3pqh9+PexvH3KC2PQlUbr9Np6CLrnpnOqU7agbJsCdYwehbiMJU1OoVTZIRJc55erxVavw==
X-Received: by 2002:a5d:5d12:0:b0:427:53e:ab25 with SMTP id ffacd0b85a97d-429bd6e3ccemr13481854f8f.49.1762273546158;
        Tue, 04 Nov 2025 08:25:46 -0800 (PST)
Received: from [192.168.15.14] ([152.234.106.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601a5070fsm32382905ad.75.2025.11.04.08.25.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 08:25:45 -0800 (PST)
Message-ID: <648b7b14-d285-449a-a1b3-4cd062a55b02@suse.com>
Date: Tue, 4 Nov 2025 13:23:33 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix refcount leak in smb2_set_path_attr
To: Steve French <smfrench@gmail.com>, Shuhao Fu <sfual@cse.ust.hk>
Cc: Tom Talpey <tom@talpey.com>, Shyam Prasad N <sprasad@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>, Bharath SM <bharathsm@microsoft.com>
References: <aQoYCxKqMHwH4sOK@osx.local>
 <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <CAH2r5mu7s4p88RhUbCm5mqUvEVM60OOTTJOZ+rz09nFfc+t3mQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/4/25 1:12 PM, Steve French via samba-technical wrote:
> There are multiple callers - are there callers that don't call
> "set_writeable_path()" ?    And so could cause the reverse refcount
> issue?

Yes... Even if it does not cause an issue today, that fix looks like it
belongs inside smb2_rename_path?

> 
> On Tue, Nov 4, 2025 at 9:21 AM Shuhao Fu <sfual@cse.ust.hk> wrote:
>>
>> Fix refcount leak in `smb2_set_path_attr` when path conversion fails.
>>
>> Function `cifs_get_writable_path` returns `cfile` with its reference
>> counter `cfile->count` increased on success. Function `smb2_compound_op`
>> would decrease the reference counter for `cfile`, as stated in its
>> comment. By calling `smb2_rename_path`, the reference counter of `cfile`
>> would leak if `cifs_convert_path_to_utf16` fails in `smb2_set_path_attr`.
>>
>> Fixes: 8de9e86c67ba ("cifs: create a helper to find a writeable handle by path name")
>> Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
>> ---
>>  fs/smb/client/smb2inode.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
>> index 09e3fc81d..69cb81fa0 100644
>> --- a/fs/smb/client/smb2inode.c
>> +++ b/fs/smb/client/smb2inode.c
>> @@ -1294,6 +1294,8 @@ static int smb2_set_path_attr(const unsigned int xid, struct cifs_tcon *tcon,
>>         smb2_to_name = cifs_convert_path_to_utf16(to_name, cifs_sb);
>>         if (smb2_to_name == NULL) {
>>                 rc = -ENOMEM;
>> +               if (cfile)
>> +                       cifsFileInfo_put(cfile);
>>                 goto smb2_rename_path;
>>         }
>>         in_iov.iov_base = smb2_to_name;
>> --
>> 2.39.5 (Apple Git-154)
>>
>>
> 
> 

-- 
Henrique
SUSE Labs
