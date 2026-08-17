Received: from mta0.migadu.com (out-229.mta0.migadu.com [91.218.175.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B871E3290DB
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 09:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786957727; cv=none; b=JxVAvsFHIH5cTGSHTaRI23iKDOFz3fE9aXfPGTVVMn/eH39y90+MFCvbu9o6+oLt8NcvY5I9jhmJBR1Jemjhuc4rR5RO1va/IgmVb8fzkYDchVotHtxtW+GvAQlcGJowQnY0fv7J9bIYZxEa3IToaWIoYqvQYf7CaSkPwtVr7MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786957727; c=relaxed/simple;
	bh=esbCDSLnJSk5ZzDvX+CGnmZ6wNI60+825cnF7d02IYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZvH4e5DY57gCfMOj4Ho2pjIuXKsfsdebe87aliPijb4bONCcI1wjl/JtL1armheg5GPq+2Z37zAhSodfdJg+hx8VnvoXM4EOXNivkxbE4lrWvVtjhjd05zL47zRLYIDujDUnqB5dTC5ktri42s7T92tYM+aauIv2bY4Gy+o/yXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=NQ+Mirvb; arc=none smtp.client-ip=91.218.175.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="NQ+Mirvb"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=esbCDSLnJSk5ZzDvX+CGnmZ6wNI60+825cnF7d02IYo=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786957719; v=1; x=1787562519;
 b=NQ+MirvbvLAUk5o8ZEmqm5y4ZLeZ+i+iDzUaoJ5a8G/Dl8dbMWQDE5xBlrry8nWil9DlUAH5
 Lvs9Xquuuo1xbyxJgxwZuCDjePfJ8Te77Xc1igi7o3Sm1nOzqmZbTuXDM/899RsnXb3likFazCX
 vJEqhGUUSIHYfaqF8SklHPP7eo7HjzabNwrm5on3t400HXXOVpgGYd/93pTcUz7NfsvDXMOXooo
 zqGXZNTb1VGRqImuypUzO+xSsCWdDh1iixdE0py/uDsew6rEf3PaWsI4qiaz/W0P7sYiwPYz+8u
 TnQlHxgClzAP60fGNYHnhlSUQuUC50pHwZcj7B9PjlYXw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 5516108e9d7136dc;
	Mon, 17 Aug 2026 09:08:38 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <29a25297-2f21-4763-b537-f6a895ce7dfe@chenxiaosong.com>
Date: Mon, 17 Aug 2026 17:08:36 +0800
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

On 8/12/26 18:39, Hang Nan wrote:
> diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
> index 08d8b7a965a6..05d16052b9a7 100644
> --- a/fs/smb/server/Kconfig
> +++ b/fs/smb/server/Kconfig
> @@ -72,3 +72,16 @@ config SMB_SERVER_KERBEROS5
>   	bool "Support for Kerberos 5"
>   	depends on SMB_SERVER
>   	default y
> +
> +config SMB_SERVER_KUNIT_TEST
> +	tristate "KUnit tests for SMB3 server helpers" if !KUNIT_ALL_TESTS
> +	depends on SMB_SERVER && KUNIT && SHMEM


depends on SMB_SERVER && SMB_KUNIT_TESTS && TMPFS_XATTR

depends on TMPFS_XATTR because it calls ksmbd_vfs_set_sd_xattr().


> --- a/fs/smb/server/Makefile
> +++ b/fs/smb/server/Makefile
> @@ -19,3 +19,4 @@ $(obj)/ksmbd_spnego_negtokentarg.asn1.o: $(obj)/ksmbd_spnego_negtokentarg.asn1.c
>   
>   ksmbd-$(CONFIG_SMB_SERVER_SMBDIRECT) += transport_rdma.o
>   ksmbd-$(CONFIG_PROC_FS) += proc.o
> +ksmbd-$(CONFIG_SMB_SERVER_KUNIT_TEST) += smbacl_kunit_test.o


obj-$(CONFIG_SMB_SERVER_KUNIT_TEST) += smbacl_kunit_test.o

The kunit tests should be built as a separate .ko instead of being 
linked into ksmbd.ko.


> +static struct kunit_case ksmbd_smbacl_test_cases[] = {
> +	KUNIT_CASE(ksmbd_dacl_walk_must_stop_at_declared_size),
> +	KUNIT_CASE(ksmbd_smb_check_perm_dacl_boundary_test),


We can also add a maximal-access variant of the smb_check_perm_dacl() 
boundary test.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

