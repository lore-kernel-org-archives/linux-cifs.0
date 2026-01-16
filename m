Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F002E224B0E
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573908; cv=none; b=mrxexWtk+4I1r7ra7oIJLLHzuHn/VRlatRPmzY/dE/LU8pZgbCBN45+PN2E5TD/fq/vKjYgQs3zgieT7qkhiJP/5BmqReBgkviRY6R7W8PY7xDh5jbdVQrEUJAkFNXhip8m/dky29eYqD72gD9ss8pUON+0N3QnWvjvhoY0UCCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573908; c=relaxed/simple;
	bh=7q0W8nTjswikItGggKjqhBPI0Alsvd1nVRiRZiHOPww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LJMCACsKZ2IMSeqyVFH9v+ZfREqk6JZ/rEJLk6FbSXrcxiCqD9XWIBKVNnXNMbTefgZfJl1gVXJzdQOsZvTVNZDv60N3P5B4ejrLXA4FGEq9K6vMjIQo1SBq49HK2aLNsuDaverL2WJl/pg9PdMqScQYzIVtYkouBd/PMJ0Naek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sGD5hFGi; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sGD5hFGi"
Message-ID: <3782f12b-b2be-42d0-a91b-eb1239548684@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768573903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Y3so5kiFx6TKmQLP22NKR2OBaYe4Z76bjuqjw74dnM=;
	b=sGD5hFGioLFTxBC6HQmR4l1bwcBNOUj5dDm/Oc/J71TGa3rRhQTpZcY8Qjx3n+D1X0A/we
	NaxruQJ8+Fv1Q/CbNVU4QfBjXFxJZogLXo8PIv61vLMamhD5c8lC79cNCw1qj/h0o1+PwO
	K90u3SfTXFASHu2UQyBnlOfkrAidgsU=
Date: Fri, 16 Jan 2026 22:30:57 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/5] cifs: Autogenerate SMB2 error mapping table
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260106071507.1420900-3-chenxiaosong.chenxiaosong@linux.dev>
 <CA+5B0FOT_H1vO+9cfSbpFsUauQ_V1KM0GGKjp=+_K+z-SEWNeA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CA+5B0FOT_H1vO+9cfSbpFsUauQ_V1KM0GGKjp=+_K+z-SEWNeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I am concerned that X macros may make the code harder to read. What do 
others think?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/16/26 21:48, Aurélien Aptel wrote:
> May I suggest using X macros?
> you don't need pre-processing and generation of files and you can keep
> as much metadata as you want in the macro at zero runtime cost and
> build what you need.
> 
> You can have one .h file like this:
> 
> #define SMB2_ERR_LIST \
>   X(STATUS_WAIT_1, 0x00000000, -EIO, <whatever else>) \
>   X(STATUS_WAIT_2, 0x00000001, -EIO, <whatever else>) \
> ...
> 
> and then do things like:
> 
> enum smb2_error {
> #define X(code, val, ...) code = cpu_to_le32(val),
> SMB2_ERR_LIST
> #undef X
> };
> 
> Might have to use typed enum to get the le32 through
>   https://gcc.gnu.org/onlinedocs/gcc/Enum-Extensions.html
> 
> struct smb2_errno_map { le32 code; const char *name; int errno; };
> struct smb2_errno_map smb2_to_errno[] = {
> #define X(name, val, errno, ...) {cpu_to_le32(val), #name, errno},
> SMB2_ERR_LIST
> #undef X
> };
> 
> Also you can use bsearch() to do log(N) lookup. But maybe the compiler
> optimizes a larger switch to the same thing already.
> 
> static int cmp_smb2_err(const void *key, const void *elt)
> {
>      return *(const enum smb2_error *)key - ((const struct
> smb2_errno_map *)elt)->val;
> }
> 
> int smb2_err_lookup(enum smb2_error err)
> {
>      struct smb2_errno_map *res = bsearch(&err, smb2_to_errno,
> ARRAY_SIZE(smb2_to_errno), sizeof(smb2_to_errno[0]), cmp_smb2_err);
>      ...
> }
> 
> 
> (code untested)

