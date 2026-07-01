Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A183F0AA8
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 09:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782899317; cv=none; b=qBsWkeoRgMGiesViCHmwB22GDfzysShQ0VC/0VIEQhjkt9frkvZfsnAGZwQLccWk/3WTiUAdACbr4fa3MaEeBodDlhIXXkIq35nesF2vjYnUp06Bf+hsZLnjVK1X7lJpVEKGgmCs2WTRF/asCWK9CXUFNHdscpAdBrmXBxms8yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782899317; c=relaxed/simple;
	bh=qWZDsommoiU0TXGd/kowr08CJtkiOCT4s0M0mVr/3bM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TsodeQtpNNvoSeMYsQSTcxV60PLhUPe2V7NK0ZZ+praJOUsqHXHlxEJdcpxMA1yna4JCuhHtJpYwY/SL6MVJnd0B65A1iCtGLLRB2j+M8lq/Cmlu8fAr4xpZ080ADGrLeOHv0uIhN9WYG2C5mzeTSq48BeF5zrI9s1q5rIMmlak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=SgSDh3tn; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="SgSDh3tn"
Message-ID: <b3fa548e-fd2f-4f66-b6d0-cce759e99068@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782899310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqS5gNBCFXJn/el9JdXoq7cQ939rnIYGOsp0vt89xBY=;
	b=SgSDh3tn2vMqn1ZnNUapChiOL/p9IpCgLww2iLGz5XbMVXsetErUV5zxjjFwksAxNMVB7v
	gQvi5GDSByfcIDBnWSEajuye2t82qUqXXa/6dvsDS19DndS0MDgLD75UC87JpvtNHMxrPn
	/sy5gYxwjlSJuTxipb7hYidgFySXhlTV6/COesPAF/EZcyG58ED6uVYHXhZFN/YiAkL13f
	K6Xi4oIHXm4XsDYYKjxQTeSuk98zmOhLRdTzFlTGZfF6JkOwegq/xwqZhuEhUIjvuby0NZ
	cXejksao5izHisfmmVyY1ZfXewRGeqLXKdl0++Myd8NzxzfD2ew6NC6Vjl8DmQ==
Date: Wed, 1 Jul 2026 17:48:15 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/client: fix incorrect nlink returned by fstat()
To: Steve French <smfrench@gmail.com>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260629152659.703943-1-chenxiaosong@chenxiaosong.com>
 <CAH2r5mt2Jonpx-YZ9ea0icKtGTCHFcEF77F0nJdFXRn97eUC=w@mail.gmail.com>
 <243d6eda-796d-45d9-8c26-6372af5efe20@chenxiaosong.com>
 <CAH2r5mufBWn7P-iRhHN5xs6d2E2--hFPwVY4sZ3QRm=wXJup4Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mufBWn7P-iRhHN5xs6d2E2--hFPwVY4sZ3QRm=wXJup4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Sashiko has a better idea:
https://sashiko.dev/#/patchset/20260629152659.703943-1-chenxiaosong%40chenxiaosong.com

在 2026/6/29 23:44, Steve French 写道:
> Not really, was hoping that there was a way to cache the link count
> locally as additional hardlinks are done

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

