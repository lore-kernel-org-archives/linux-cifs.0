Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D41B1078F;
	Tue,  5 Aug 2025 06:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754374094; cv=none; b=MbWf/WXnF2ne2MPgmVT2SuF1/M4XoYqJXG2DbaqZrBx8oM1Rph6u4q7nLzOslhBkO5blOVPW8B3wG+EWzZgRpUEN4Fd2ir2U+IDc1fBnEnRyzcIBCcZhnxq2YRzDY3clzoXgj+gqEJCWt4WhvIrdgQN5NdqBftE0z2DQwq/VULs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754374094; c=relaxed/simple;
	bh=Kn2asmhOnJH+xytk5D59Px4zd8CfOBsQMsP3YtAGj8w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UWsHTDxpTXmNLrZ4cZqcsiUCwiE7cBmpWWXxqTMunoWxjHhz9LCdffq7yT3HGHbZ9VE0EY+HECWiyA4baoQlhDI/b4UgTKS10X6JgVqgeT9OICSz75WGF7ZuO1/BimvaecZnhEF725RlrN3BNB/nRSdkGpd4mb6ksAvAf+nArg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bx2zF1G8xzYQv0j;
	Tue,  5 Aug 2025 14:08:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CC72B1A0CDC;
	Tue,  5 Aug 2025 14:08:07 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxPGn5Fo6_KACg--.23766S3;
	Tue, 05 Aug 2025 14:08:07 +0800 (CST)
Message-ID: <9b725fd7-a9fa-4e3a-a6a3-01c222891752@huaweicloud.com>
Date: Tue, 5 Aug 2025 14:08:06 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] smb: client: fix mid_q_entry memleak leak with
 per-mid locking
To: Steve French <smfrench@gmail.com>
Cc: pshilov@microsoft.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250804134006.3609555-1-wangzhaolong@huaweicloud.com>
 <20250804134006.3609555-5-wangzhaolong@huaweicloud.com>
 <CAH2r5mu8bn_j98zuDoTOPnW3ShnDr+YFOkG7_Y5Frk=4eiixUA@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <CAH2r5mu8bn_j98zuDoTOPnW3ShnDr+YFOkG7_Y5Frk=4eiixUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxPGn5Fo6_KACg--.23766S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr1rAFWUWw4rCr1xWF18AFb_yoWxCFXEvr
	Wktr4kGw129rnFvay5Ga1DXrnrG3y0va4rZa4UZ398Aa4ruw4q9w4kAFZ5ZrWUG39Fqr98
	WF1YqwnYyFn8XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

> minor sparse warning when compiling this:
> 
>    CHECK   smb2ops.c
> smb2ops.c: note: in included file:
> cifsglob.h:1362:40: error: marked inline, but without a definition
> 
> On Mon, Aug 4, 2025 at 9:00 AM Wang Zhaolong
> <wangzhaolong@huaweicloud.com> wrote:

This seems to be a warning caused by the static analysis
tool analyzing the smb2ops.c file individually. The
implementation of mid_execute_callback() is actually in
connect.c, and the compiler can handle this situation
correctly.

Perhaps I should inline it directly in smb2ops.c to
eliminate the warning issue in the header file. I will
send the V2 version patch later.

Best regards,
Wang Zhaolong

