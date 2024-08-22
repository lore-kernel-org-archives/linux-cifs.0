Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF56A3FC2;
	Thu, 22 Aug 2024 00:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724285915; cv=none; b=e35xM28dDYHPZdjB/CsZMObduX5ImnqIL1fKt04+jh4rvFlunBQcJyeHuK4gPmvUtG5Scu4QKfD3G7L9fI+S+BXW1zz0ObEBpVSTwqt6huQrhkcaHqjn/H/CO3xGTTvMNwenLqLCyEHeOueFyRX9SxTuBXcZOFSpSDAIkOMY80M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724285915; c=relaxed/simple;
	bh=YCfGQLY4ta0TdR4ANpzxrEdExx8N15CmIRJOa2f/wCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ARbYfaZKa1QvMudlLrLomwTqBSSTWvHJomfqmD2oqwdhVdJtZqDINv3C1kWaeP8eJL2PkZnl2p2g0nsvE9Y4rCkMHOtpmMzclTdo5vi29yjlu7ZpKucYSPwTZWQL7Y9B9k23UxgbE4ITXMxqqpVZn5vNiwOUY6ggl0cAa4oIZyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtp87t1724285812tq2bijg4
X-QQ-Originating-IP: dixtll8uRqqTyNQAVc5mWvuoSSnfSCJoXmnJJVvx9YM=
Received: from [192.168.3.223] ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 22 Aug 2024 08:16:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15102028674120964960
Message-ID: <74BD461E3A54DB61+0e15d4dc-350e-4ece-b6a9-6abd51b0def9@chenxiaosong.com>
Date: Thu, 22 Aug 2024 08:16:50 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] smb: move some duplicate definitions to
 common/smbacl.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com,
 chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn,
 liuyun01@kylinos.cn
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com>
 <20240820143319.274033-7-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8mX+2gRuPyEuamg-nCTdyLb7G6bYKw0YiUrGb2GGTaaQ@mail.gmail.com>
Content-Language: en-US
From: chenxiaosong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8mX+2gRuPyEuamg-nCTdyLb7G6bYKw0YiUrGb2GGTaaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0

Thanks for your reply. I will try to rename the prefix of cifs_ntsd, 
cifs_sid, cifs_acl struct, send v2 patchset soon.

On 2024/8/22 07:48, Namjae Jeon wrote:
> On Tue, Aug 20, 2024 at 11:35 PM <chenxiaosong@chenxiaosong.com> wrote:
>>
>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> In order to maintain the code more easily, move duplicate acl
>> definitions to new common header file.
>>
>> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> If you rename the prefix of cifs_ntsd, cifs_sid, cifs_acl struct, we
> can move more ones to /common/smbacl.h.
> Looking forward to the next patch.
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Thanks!
> 

