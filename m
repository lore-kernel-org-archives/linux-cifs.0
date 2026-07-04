Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E6F30FC27
	for <linux-cifs@vger.kernel.org>; Sat,  4 Jul 2026 10:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783161118; cv=none; b=sq7LVLDhuveX/ZusFTOMEU1rwpLdZdxL0Aqg2z2haCEOUnw3WQOFlhEVVHHk3wMm3wkFTR/LJdSatbeQ9uV0nYpcou5sc+FkqmjCyetp77IUgg7hxo2fKXy8wV2pljhQEn9G7BnTRfRZSo/1AwjnG8U8U5A3HKXXhHCKWAjfZ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783161118; c=relaxed/simple;
	bh=lPpTkV3fWovLXDGffGbZmhGSTsAvwspnvQxiD+mTCM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f0J24CHeP1jwC7H9PldaYN4nsuFm+n8oZdTAOFXhh/cguLK/pOJwRPZtOdjFPHrvvBwX2w8sum/j71ZSwNSAaV/c3Xq6y4YkQ0WM9twyyGWE7kupBSRe7XTGglgomv7hyvNytd1vb4nuxgxJyWLPPoqVIRtdxiW2OLUW7Jnv3Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=dWCM2KAW; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="dWCM2KAW"
Message-ID: <a1487806-326a-42ef-a975-b0de93e8ee6a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783161112;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h11m7M+JbBF62L2whPvVLqN94vICwRsuqUCKc2fCZ44=;
	b=dWCM2KAWtSVEJOow2sDprOn0vVL2Vezy+Uq7AHMU2oOJ5BDKnPaBajfyymIetwMOrcU8mA
	YDQce4EMZMh0+/loYObZ6TRSuGn/mvn9VgEqqddZGqMTv515mxscITeDuqE4XQDLZEtyK+
	6/HBDs4nnZThEE/DvQ79EAmATwyK5g/t+ZajwsryeFObaF2U4Wy4JXoJIS83rnPrBDHiGv
	fKQRwaJ+bAoxYwWvWRH4w8oI5LKaQM1FX8SZEGJwj7JAtHdD7KOosjcNwhGuiNAjsC8jas
	6HDvSXXkHgn+cMpbSvb8wh6ZDkiagBdjHZ4y7osTAgXLOgrVTaeH40stNcE0Vw==
Date: Sat, 4 Jul 2026 18:31:46 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] smb/server: preserve compound prefix for async
 interim responses
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
 <20260702110522.911411-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8F_2ZTFc5eUmo2xS_irPnsmFmEq9OKhGSSY-Ra=b882w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I will debug these test cases to find the root cause. Thanks for your 
testing.

在 2026/7/4 16:52, Namjae Jeon 写道:
> Could you please take a look at the three smbtorture failures caused
> by this patch?
> 
> smb2.compound.compound-padding
> smb2.compound_async.write_write
> smb2.compound_async.read_read

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

