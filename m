Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92801241695
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780757791; cv=none; b=avIdN9kMTQvo41rYOAEVlpyLm+6o2lp/WScAaR5zXTKOF48ocOY/ep8LAOd4Yh/W9xATFAg5cRkiTGx44fWQvGS0IbK2j+PWicGCOk8d8ETS1T8815mDIkcpdEAcWIwBhKRv+npUHudi4WrvrlgP67KhKJx41oCkcy+/OSUWL/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780757791; c=relaxed/simple;
	bh=+bU0cyYXMFXsIF0fqwVHB1maLQjBuLzhVHy2EpXj1pM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GfhR3HWMcpg6OVh5+5mwqLe9/8W8IK1QLF2b78x56wy9J5i1iOdN+n2vSc09sTlHjyqmz1Hiulm/0x0MYcW+kOnYaOc2A0BpccE0oZutWMHgXE3EVfIaVz5zmke7et24Ep05O+6cr7BpcEOSc3PxTgN+lNvxExGEIwqHs6mjx0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=JoX1BRsC; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="JoX1BRsC"
Message-ID: <ac3b69d0-748a-45c9-881a-38219abd7787@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780757784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csOcR7Ls7lvkIDYxrvK0x4AnZ31YV7Ra2vK467rJEbg=;
	b=JoX1BRsCWlIRRP1826g0TCIkjq9M9d+7i63vXAFGEZBMaw3jaUTUXCcYDhKZM6qqQ6xeGA
	4HaREHJeq113R0hK3KV9Hu9MUAfv/wOC7Ae+Ij3IAFnTVYXybShWEmHk+MVaV4CnpK3TN0
	0g98/MsPu9j1U1RIn2s+g8PTUdS+y/2+6rN+y2o6D5s3beeJUHoVq2f6IwLUcsPF2d61VW
	lDW9/iPKnkX48QpVEpOlcc7Ywpwyw5X+b5mb9C9X/g9P7Y2ouG5Aqc+4kfjLyF0OplGeyO
	nxOKmUWrSuMe4Y57Rd8cTpO/wlF73/OS4t0gMpX/7YivzktxL43KcGRSWTqJTQ==
Date: Sat, 6 Jun 2026 22:55:32 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] smb: move compression definitions into common/fscc.h
To: Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-2-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
 <a4502395-735d-4c90-a116-754a3e91137b@chenxiaosong.com>
 <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
 <de411d1c-36ba-4fb5-94cd-4ac6026e0465@talpey.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <de411d1c-36ba-4fb5-94cd-4ac6026e0465@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Tom,

I'm only using DEFAULT for now，it seems reasonable，right?

在 2026/6/6 22:41, Tom Talpey 写道:
> It's a behavior (choice), and the Windows Behavior note states
> what Windows implements. Per the WBN link in the quoted fragment:
> 
>    <62> Section 2.3.67: Equivalent to COMPRESSION_FORMAT_LZNT1.

