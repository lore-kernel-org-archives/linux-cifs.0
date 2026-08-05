Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D43A377A86
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785909255; cv=none; b=oq5K+GqlSAoOESi+vt8FygC2M2sUUzRycZtNAadA/LAJFsFmW0Isj+19RHVFehY0/7SYBhXe9i9V01RFtVVGE5y7vV3vSfwfKEYyY1ktYQdSBJ/tknS5U/+5SR3HhR7mRnkm7muZX0+huvnenO9Ff+vVHLPxcYf26NMRRmvSfDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785909255; c=relaxed/simple;
	bh=HYeEOf1H3eBP2QydAE0tAtM9zwUNRMqZWBbyqEiDTmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W9FNY/Jj5SF4g+U0FsO3u7QidOWAhBds/KW+yibU8zkDIeWk1YufxH34+fx2Be7OvHvD5wE6QN48NDy2+ktMIEBG5iNJIMpL6vwNK1zw1JUS/VjDiOYPmRiziWtUBFEHItdOQqEbRWQ4T5gJfx2xaN24lYV5/tpFb3R1bt+5uvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Q0C1EHVb; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Q0C1EHVb"
Message-ID: <1f15d63d-cb4b-40b9-922f-e7ccad055771@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785909246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MtfWn1YSrWbGEGcdwlqpgz+B1zyB5/2l3o0bW8PhurU=;
	b=Q0C1EHVbDD++6L4Y069lrT4sF4CI2umPdnGuhKcys6wjYB93gxpC50ofEPha8pMKdGcBiW
	98KNfb2Fh7m0BYyLIAusj20+taV09AyzF+9+aSLS4vpyvPfMr/d0Wn39F1Kpx1MFZ7EWoL
	in4/Tit9qWqaa5GuttvwJ/8N0bQT5C7ENRHUBQOavIpvZ7hzdcaKyanHd0nbir96DaG6uy
	BfWWD1bdqQibH20CTICULqi8dspBnfkiVh96ZYDI+CtKuHaLAkIVnHfjYf7Bhuk/W6vnss
	HTPuvr8oAlvtMqepgDu93eR01SC0jqpeIa6IDfZrYbpeyBUlS979RqXVXBcbxQ==
Date: Wed, 5 Aug 2026 13:53:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/3] smb/server: deny overwriting targets with
 non-POSIX opens
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 slow@samba.org, linux-cifs@vger.kernel.org
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
 <20260804123301.285434-3-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-A2hup+WnYZj+AaVTzgZ9hHQgg8zKswtw=-VqStE6VFw@mail.gmail.com>
 <2df0ad6e-fa5c-425d-9ec1-5c668f84a4bd@chenxiaosong.com>
 <CAKYAXd9OQKQVURduu0iRL-H8rAL4coCK79w8HZiSt3f8CpdymA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9OQKQVURduu0iRL-H8rAL4coCK79w8HZiSt3f8CpdymA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

I have sent v3: 
https://lore.kernel.org/linux-cifs/20260805051112.305078-1-chenxiaosong@chenxiaosong.com/

On 8/5/26 13:46, Namjae Jeon wrote:
> Looks ok. I will apply after running my tests tonight.
> Thanks!

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

