Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5B9306B31
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784986046; cv=none; b=ZDTLJhwaA+83Zwz2AjS5Fl5+xyGVl+HIVXuL8JpMqNIOlazqlmV86bhlyNmx6Ycz6b8vcpIYkT93xdZMBj/FAhRkHaqm91s4L29HSNhQNAZa9n9N9gA6X/XGK3xOUHE6aRv5f2Bs7a5SND4iBD92V0ywt/wmZayp1HAKiyF78Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784986046; c=relaxed/simple;
	bh=MbwOlW8RSrFzQOt1/eTbAyivMA+synKW5OySy4K0Tnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6viQ0ZTF099ohBDpDEq+bRFG6RfcSUQu1lgq1PaIOjzRe/jFaSPceTvS7rFBOK7eo36oo/dN+/mCNZ8IG5wRFABqfStMHQU7tT3KDBw/IuKWQ1SguT3WPxYWFqv9jmiYxVzZKRtuXDKiKesbcu/SzxpSNQv+gKULPj+9TkFiiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mH4U1Hbw; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mH4U1Hbw"
Message-ID: <f36dc0fa-260f-493d-a91e-1092acb5f430@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784986036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0PrhGhx20v7hSucuAcTIB2XX//mf8IBBjCpLX6ErfI=;
	b=mH4U1HbwdtPK9ycquwOc8LYLRpm7TRFly0HDqpM2sshFC41iFxp736iQbWYIQoY/1w+Muv
	hqFPBIOh4QgM+CzH3OSuVJ/oG3sR+jPlC/2HrF/DDV7jlky3dGLSmn87cHHj67Z+UkZbeQ
	4xm0jUomymwOJ86ldOIDkG7i9XZs0NuhTxtrGifie0bOCAe2eojrzwuYRbyFL+W4DNot06
	3GCyfxNLAmnnBk+wjo36ISAUa/lq5jnoOH0l8WyZHyD+P87tOhnNmg6Jp7LKd6REVhKgAC
	R1r1KvZgnUGq75T9Rj6sMSv4Ohh9OixoPKPC3X3PhaDAEi/NieUNk2ZGAVD4JA==
Date: Sat, 25 Jul 2026 21:27:09 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] ksmbd: refactor smb2_notify() to a blocking wait,
 matching smb2_lock()
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org, chenxiaosong@kylinos.cn,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linkinjeon@kernel.org
References: <20260725102737.33616-1-g.blivet@me.com>
 <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Gaël,

Would you mind if I include your patch in my new version of the change 
notify feature patchset? I may make some changes to this patch, but I 
will ask for your approval on the final version.

在 2026/7/25 21:12, ChenXiaoSong 写道:
> When Windows is used as the client, this check must be removed because 
> Windows sends a compound request:
>    CREATE dir; CHANGE_NOTIFY, fid = compound fid (FFFF...FFFF)
> 
> However, I am not yet sure whether skipping this check could cause any 
> issues when macOS is used as the client. I will test it with a macOS 
> client tomorrow.
> 
> 在 2026/7/25 18:26, Gaël Blivet-Bailly 写道:
>> @@ -10967,56 +10908,17 @@ int smb2_notify(struct ksmbd_work *work)
>>       }
>> ...
>> +     * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF
>> +     * (share-root sentinel) to watch for changes on the share root
>> +     * without holding an open handle.
>>        */
>>       if (req->VolatileFileId == SMB2_NO_FID &&
>>           req->PersistentFileId == SMB2_NO_FID) {
>> ...
>> +        rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>> +        smb2_set_err_rsp(work);
>>           return 0;
>>       }
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

