Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C243BED42
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 08:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786954342; cv=none; b=COrdNBcI5Ir/R6pazTg9YBIbSScH9k0Z+LXo5dMKqLQ+Fq8cHGxOiBVj4PQr/MSu3PvgkxGfV6CGLDkC7RTIJa1AmDmL0iP2ZnK1oUnxflGohkb+d6x9r/bbskXVPHUTv395wJyFJY2HnGnXqGcph2WJf/igF/g5XkQKU/ID9EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786954342; c=relaxed/simple;
	bh=LLGSTNuZh8PMtRSRhEsuh+6u/nKVjFN1a/funpwowSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3A3dIZwLBFjiBO7uQcFkQmw1T0TU1dZCn3hMPanxSFwL/s6l9q/fg3eyRCjriaPLreGx+KvXdoB08wxfi48fLTT2b6VpJRgd52KsKmJ9gcCeuQ/o5GpeermmeiiMidXkynS3tejz+uX513oL1V4UIRcAQSrNob4c2HBye6LLZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=PeRBzG7+; arc=none smtp.client-ip=91.218.175.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="PeRBzG7+"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LLGSTNuZh8PMtRSRhEsuh+6u/nKVjFN1a/funpwowSc=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786954334; v=1; x=1787559134;
 b=PeRBzG7+svcJnvTPYIGNE2FTEDd92qQ+uvTMdbRof3E0vTBcuzoyPBpUA8kV/dj/xGpCoRqo
 LF29nnydVQP0EUJa0/wat6JUbvwrTKDIg1RdxWoNCZGIlnHyhY67lwOJBOyi1ULqKl1RDEPZS65
 SU3ADdb8KiYAT8RXaIHQihB3B4eoL4/H1gr4nKtuMFV28dWbUtkq19mD8sX5CJhg2nGRtnxz7Ur
 rLd1XHoFtKCw0knmDXnt9ctW9JMpsC31/b1SF+yHVMuHAHCHwClKA2Pu1IDIv7LTf37EkEvIQfY
 rChdGzaiy6OikRz6tutE8u/UpQRzQbtGa8oVkNzwyx29A==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 6a2fb4d233c3b3f1;
	Mon, 17 Aug 2026 08:12:04 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <966e202f-ebaf-4073-8216-094d63eeb3fe@chenxiaosong.com>
Date: Mon, 17 Aug 2026 16:11:56 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH samba] smbd: break directory leases before sending
 notify events
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, tom@talpey.com, senozhatsky@chromium.org, metze@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260810082955.1128900-1-chenxiaosong@chenxiaosong.com>
 <a30dd591-dd3c-4881-8088-69d2b001c6e3@samba.org>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <a30dd591-dd3c-4881-8088-69d2b001c6e3@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I look forward to your better solution. Please CC me when you send it, 
and if you want, you can also add:

   Reported-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 8/17/26 16:00, Ralph Boehme wrote:
> Hi!
> 
> Thanks for looking into this and trying to address the issue!
> 
> Unfortunately, iirc it won't be as simple due to the way Samba 
> internally integrates inotify with changes coming in over SMB. I have 
> this sitting on my todo list for the next months, the plan is add a new 
> change-notify backend based on fanotify, where, in contrast to inotify, 
> change notifications contain the pid of the triggering process. We need 
> that information as a differentiator in notifyd to correctly drive the 
> machinery.
> 
> As an example, iirc with just your patch, we would break the dirlease 
> for changes done by the client owning it and the change correctly 
> referencing it via the parent dirlease key in the handle triggering the 
> change.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

