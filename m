Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB9518A93F
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784988872; cv=none; b=nq7oPX3g/OlUSY5lwqG61bhGqqmyFZ539zrzyRcUrrei6XVuKmB3fYvKAxtP76md0NFvlJJG3JMwfB1t8slnokwq2bN6mbzbqk4OBOQdAyjhU7+F123X9EIWE4deEymBYzurbTVN1ttP0SmNPKHwyN/JMK/p0DI/QTTvddH4IuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784988872; c=relaxed/simple;
	bh=CkM8vlqR0cLWxT4Q3ykwpkqAn6qr6O4ccYPYs/TaR5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o6h7M/E2ZUcDbOCETm2i8FxVN0ibEtcUeTMQke2Xf9djSaqHUZ3PqTey3w9WF4DikI8sCM7Rbl6U3E10LNafg124O5yrRKYDnZYweVmZ8nxc9C2x9YfM1lxiSqc0DMsbfECqjabeR2y6ZqsVPnwJ1T3KqEkcZzLu8PX5aW3ryyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Dz+JIBMu; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Dz+JIBMu"
Message-ID: <f127ad26-a024-42db-98ab-bc27f1995008@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784988865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sg5DrWJjjXt6dLEQwpYTqmTb4wCqwNpChvuG3M7W2s8=;
	b=Dz+JIBMucsL9xNdjD1s59rIenqWvIJ+1hnVXxL51grDKTCLQvihLW22qKFBKDO806vpZYb
	YtOT2XQTS+umZPZzWBb81TdJlSWzgtlZ1UMg0LUZ4dQCrTCk6YkhtKqdhVn/fLUNW1anz+
	TQrqJBHv3TYudGUKTooeoST5dQGvxO2xdP7ZJupuBV44YjLDZGSMpJo6ahE//djJzEbybx
	3/icu0D6M42cxr7qw7a88swVB25iU8Zbnm3iXer0bdeMrcVdpJbuUJVdY2XDw9iGBCU4FC
	J/ajnProLvsz3ge2U48wAq/o+WjdbUhuQnGjDf0MxGLdB+oxZkrAIvs/F9wkqA==
Date: Sat, 25 Jul 2026 22:14:09 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 10/11] smb/server: send notify events to the client
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 gael.blivet@gmail.com, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com>
 <20260723031644.312866-11-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-CNK07Z84fQD-mtdS=JAvKpyoWAJrrYNYPKWWSpcnHJA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd-CNK07Z84fQD-mtdS=JAvKpyoWAJrrYNYPKWWSpcnHJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your reviews. Your suggestions are very helpful to me.

在 2026/7/25 22:02, Namjae Jeon 写道:
>> +static int ksmbd_notify_reply(struct ksmbd_work *work,
>> +                             struct ksmbd_notify *notify,
>> +                             struct smb2_change_notify_req *req,
>> +                             struct smb2_change_notify_rsp *rsp,
>> +                             struct list_head *events)
>> +{
>> +       u32 max_len = min(le32_to_cpu(req->OutputBufferLength),
>> +                         notify->max_buffer_size);
> Why is the response limited by notify->max_buffer_size, which is
> captured when the watch is first created?
> The maximum amount returned for this completion should be governed by
> the current request's OutputBufferLength. Limiting it to the first
> request's buffer size can unnecessarily return STATUS_NOTIFY_ENUM_DIR
> even when a later request supplied a sufficiently large output buffer.
> 
> Thanks for the patch!

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

