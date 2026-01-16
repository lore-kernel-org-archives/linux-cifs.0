Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29D225485A
	for <linux-cifs@vger.kernel.org>; Fri, 16 Jan 2026 08:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768551317; cv=none; b=dL0q4ucg9cE4MGRIMnwGKM2wdTPQbXPC3XSU+jFj/FbTg1RzKFOW7WccoB/xJuFATHIqtpNqK2jGNbPSrJnXzXxCZB8qEyVC5oLk1CSFhFx3eDoCwF+AhS/umIx4kVm1W/niM2dtYO7ouW64gl49oq/cXQ2v12P/+ETdQZ/R1No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768551317; c=relaxed/simple;
	bh=kcIHaYAzKBqpr7iMZ2u6YnNwL5HGg04COqpBFLB2bws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3i+pezuEBFMSODntGz8Epk44FpjDLh4E945giMMnf3taF5anOUfL3dXyn7GUi+m65EgqllzCl8jVc2bjCrpL5AO2gJdk18VsVx2TErzcOq75eHuHvhWzTTMxcilg5I/Dfi0P9ix3sM/Vf6dxrWJxVCXjlWr9setrWdslLm2f1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iExo9G/X; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iExo9G/X"
Message-ID: <983350d5-aace-4db4-a20b-c1866bfd7bf3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768551312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1OWhdHCYNDo/ZtLZ3k9EQAcH/IKBTPDPKh/pN5k4Bk=;
	b=iExo9G/XgJCQ4Thbbk2CxW5DOLPa1rMM/7JJCnGUUjfOwJgtOw+DINV+9fVe1OmYnfprZc
	zs90uNWzbxAJwqpA7pnYwOBjmnV2LUVgxt2sDM6BBCgTnNv4Pm10XspUjqzUbst1RsSx3m
	qT554MIctnfa2r+TfQ2qAeoplOdVeqI=
Date: Fri, 16 Jan 2026 16:14:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 2/5] cifs: Autogenerate SMB2 error mapping table
To: chenxiaosong.chenxiaosong@linux.dev, smfrench@gmail.com,
 linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
References: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
 <20260106071507.1420900-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260106071507.1420900-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

In this patch, I added the following comments to make the code easier to 
understand. Please see GitHub repository tag `smb2maperror`: 
https://github.com/chenxiaosonggithub/linux/commits/smb2maperror/

--- a/fs/smb/common/smb2status.h
+++ b/fs/smb/common/smb2status.h
@@ -27,6 +27,12 @@ struct ntstatus {
         __le32 Code;
  };

+/*
+ * The comment at the end of each definition indicates `posix_error`
+ * field of `struct status_to_posix_error`, it is used to generate the
+ * `smb2_error_map_table` array.
+ */
+
  #define STATUS_SUCCESS                         cpu_to_le32(0x00000000) 
// 0
  #define STATUS_WAIT_0                          cpu_to_le32(0x00000000) 
// 0
  #define STATUS_WAIT_1                          cpu_to_le32(0x00000001) 
// -EIO

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 1/6/26 15:15, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: David Howells<dhowells@redhat.com>
> 
> Autogenerate the SMB2 status to error code mapping table, from the
> smb2status.h common header, sorting it by NT status code so that it can be
> searched by binary chopping. This also reduces the number of places this
> list is duplicated in the source.

