Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD63C41A504
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 11:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786534110; cv=none; b=MlbjZN5ar1xi5WpGEloWJ1Hqx08yyk3S2SS1rqvuhdRXczNOfCaoU+FKT0EmwKnpB2BtAvt9Vpvxr5+IIjSF+P5VtBfcE2hFB72uc7CitTTR+JmX1V7XLZC6sDvFD8WJJ/TQ8SHu9qLd504d5FkLwXaiT69S78uMWmni8xckqSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786534110; c=relaxed/simple;
	bh=THI+tD1piJf+gjuYAlK9wo233bpWJjlibMyCV4Ey5B0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=erfOYzGqErXB94SADuSljnKhG3Z4cT1XxeMyqmLBg/Qp5Jij1oPcszybFaoieLmM6dawwt04SlfzWte2VbvpuqxK38H53T15jpZjUNj6yVaOgtqo7upnHuI0088R24y6MeiGGEhRdoUCYGY5E/w6ooa6PaS2wMU3Q2EOQFx4Jm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Mv674Of4; arc=none smtp.client-ip=91.218.175.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Mv674Of4"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=THI+tD1piJf+gjuYAlK9wo233bpWJjlibMyCV4Ey5B0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786534103; v=1; x=1787138903;
 b=Mv674Of4De9gUB7/g6oFLTJjY4BsGq2O8pMA5JMQAjSV/fzoTf0BSJiaz/UrbTOBvjrP6f9R
 /o6luVkNlgzJB93uCB1npbbMan34yrzgQ09xuMfxJ8MaDgXAGnRpGuFFmc/MVrpg57YDpyDgJny
 LGxC2BA02m4aKuZLXAHdcm7nJa99ogZmobRmtwPN/5nMBF6kVQAmgolXd4ToBfWI+rFIAv03s8t
 7t/jAgi+eEmNOajgJ58KirzufVr3frMdmsztLDKdLSrUGBI5FZGUQscuTkRWj0resvGWZ1IeeRl
 QPWSS9A9wOeUwqc5fkKk6M5PPxWrBihSIOUZQEdnmkrzg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id a6551322dfdde081;
	Wed, 12 Aug 2026 11:28:22 +0000
Message-ID: <0a841287-9810-43c9-8e7a-d8894d23cbef@chenxiaosong.com>
Date: Wed, 12 Aug 2026 19:28:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ksmbd: add KUnit tests for the DACL declared-size
 boundary
To: Hang Nan <2122295973@qq.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
 <20260812103945.82495-1-2122295973@qq.com>
 <tencent_A5CB0E2E28ECF588B59EF49004BE80D22B09@qq.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <tencent_A5CB0E2E28ECF588B59EF49004BE80D22B09@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for your patches. So far, I have found the following two areas 
that could be improved. I will finish the review as soon as possible.

On 8/12/26 18:39, Hang Nan wrote:

> diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
> index 08d8b7a965a6..05d16052b9a7 100644
> --- a/fs/smb/server/Kconfig
> +++ b/fs/smb/server/Kconfig
> +config SMB_SERVER_KUNIT_TEST
> +	tristate "KUnit tests for SMB3 server helpers" if !KUNIT_ALL_TESTS
> +	depends on SMB_SERVER && KUNIT && SHMEM
> +	default KUNIT_ALL_TESTS
> +


It would be better to use `SMB_KUNIT_TESTS` directly. We do not need to 
add a new config.


> diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
> index a3e9306055e8..dff9d3cd43bd 100644
> --- a/fs/smb/server/Makefile
> +++ b/fs/smb/server/Makefile
> +ksmbd-$(CONFIG_SMB_SERVER_KUNIT_TEST) += smbacl_kunit_test.o


obj-$(CONFIG_SMB_KUNIT_TESTS) += smbacl_kunit_test.o

The kunit tests should be built as a separate .ko instead of being 
linked into ksmbd.ko.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

