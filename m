Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8107323A6;
	Mon, 16 Jun 2025 02:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750040136; cv=none; b=X552mKhGvRkx/Eyw3cHIXADW+g4IUZj9FGUEekOjtAU+qxRT36xi+i5y4EC7xyThbRG1BYOVYABjP63DnHuV6VE3xg2hKWK488bn6o+HOBuaEIoZTgpn8mJluPebDAifUWBrHFb0ACTkMdWkwMWQD7StJhLzVylHEzNZIiFlHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750040136; c=relaxed/simple;
	bh=T8y7tazk1u9sC49flh8XDM30QBf2ammv89G3xlUrfh4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:CC:
	 In-Reply-To:Content-Type; b=Iw2wk5JY6XFSHFJiGPWL/k2m4Qd4DHYlhHwjtLanLYgmNbOzLuWMJHoyycsPxMYQ4voXq3fA3l8IWBbU3V+FLAOlNPnFtORNCBknJFeBf9zr3Yq4Pd+2h99ocmpOy3rUgw1MkSKNDutW4kogfNkOR88LR8fTmrccXhS7PG/x+RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bLD8775hpz2sCyt;
	Mon, 16 Jun 2025 10:13:59 +0800 (CST)
Received: from kwepemp200004.china.huawei.com (unknown [7.202.195.99])
	by mail.maildlp.com (Postfix) with ESMTPS id D538F1400CB;
	Mon, 16 Jun 2025 10:15:24 +0800 (CST)
Received: from [10.174.186.66] (10.174.186.66) by
 kwepemp200004.china.huawei.com (7.202.195.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Jun 2025 10:15:24 +0800
Message-ID: <a759b723-05f4-4f47-b9c6-55ea2739da72@huawei.com>
Date: Mon, 16 Jun 2025 10:15:23 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXTERNAL] Re: [PATCH] smb: client: fix first failure in
 negotiation after server reboot
From: "zhangjian (CG)" <zhangjian496@huawei.com>
To: "Shyam Prasad (Azure Files)" <Shyam.Prasad@microsoft.com>
References: <32686cd5-f149-4ea4-a13f-8b1fbb2cca44@huawei.com>
 <a4435153-eb55-4160-9b46-aa937cffa575@huawei.com>
 <CAH2r5mshSVCms8hwJepT25jyYmF-qEKFp3mDdwYG1e7nXfs_2g@mail.gmail.com>
 <TYPP153MB14907291155DA3320C8F6A909471A@TYPP153MB1490.APCP153.PROD.OUTLOOK.COM>
 <186d442d-69db-4a52-b65b-f67370547c45@huawei.com>
CC: <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <186d442d-69db-4a52-b65b-f67370547c45@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemp200004.china.huawei.com (7.202.195.99)

In addition, If negotiation received no response, there are two possible
actions:
1. server_unresponsive may trigger reconnecting again and return true.
2. server_unresponsive may return false and client falls back to
CifsNeedNegotiate state and trigger reconnecting in SMB2_echo.

There two conditions are similar to the stage when first mounting to
cifs server.

On 2025/6/16 10:01, zhangjian (CG) wrote:
> 
> 
> 
> 
> On 2025/6/15 21:08, Shyam Prasad (Azure Files) wrote:
>> Can we have a situation where we just got the sock_recvmsg just timed out, and before we loop back to server_unresponsive, if another parallel negotiate updates lstrp?
> 
> Negotiation only comes when connection is touchable. Client will send a
> negotiation message to server. If we just got the sock_recvmsg timeout
> and loop back to server_unresponsive, it will return false. Client calls
> sock_recvmsg again and wait for negotiation response. Everything is Ok.
> 
>> That will cause us to not detect the server unresponsive situation, even if that did happen.
>> server->lstrp is meant to store the last "response" time from the server.
> 
> server->lstrp is also updated during setting up and aborting connection
> even when there is no response. These can be regarded as initial value
> for server->lstrp.
> I think server->lstrp needs an initial value before negotiation rather
> than connection.
> 
>>
>>
>> Regards,
>>
>> Shyam
>>
>>
>>
>>
>> ________________________________
>> From: Steve French <smfrench@gmail.com>
>> Sent: Friday, June 13, 2025 20:53
>> To: zhangjian (CG) <zhangjian496@huawei.com>
>> Cc: Shyam Prasad (Azure Files) <Shyam.Prasad@microsoft.com>; Paulo Alcantara <pc@manguebit.com>
>> Subject: [EXTERNAL] Re: [PATCH] smb: client: fix first failure in negotiation after server reboot
>>
>> Could you clarify the reproduction scenario? It was a little hard to read
>>
>> On Fri, Jun 13, 2025 at 5:44 AM zhangjian (CG) <zhangjian496@huawei.com> wrote:
>>>
>>> After fabc4ed200f9, server_unresponsive add a condition to check whether
>>> client need to reconnect depending on server->lstrp. When client failed
>>> to reconnect in 180s, client will abort connection and update server->lstrp
>>> for the last time. In the following scene, server->lstrp is too
>>> old, which may cause failure for the first negotiation.
>>>
>>> client                                                 | server
>>> -------------------------------------------------------+------------------
>>> mount to cifs server                                   |
>>> ls                                                     |
>>>                                                        | reboot
>>>     stuck for 180s and return EHOSTDOWN                |
>>>     abort connection and update server->lstrp          |
>>>                                                        | sleep 21s
>>>                                                        | service smb restart
>>> ls                                                     |
>>>     smb_negotiate                                      |
>>>         server_unresponsive cause reconnect [in cifsd] |
>>>         ( tcpStatus == CifsInNegotiate &&              |
>>>                     jiffies > server->lstrp + 20s )        |
>>>         cifs_sync_mid_result return EAGAIN             |
>>>     smb_negotiate return EHOSTDOWN                     |
>>> ls failed                                              |
>>>
>>> The condition (tcpStatus == CifsInNegotiate && jiffies > server->lstrp + 20s)
>>> expect client stay in CifsInNegotiate state for more than 20s. So we update
>>> server->lstrp before last switching into CifsInNegotiate state to avoid
>>> this failure.
>>>
>>> Fixes: fabc4ed200f9 ("smb: client: fix hang in wait_for_response() for
>>> negproto")
>>> Signed-off-by: zhangjian <zhangjian496@huawei.com>
>>> ---
>>>  fs/smb/client/connect.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
>>> index 28bc33496..f9aef60f1 100644
>>> --- a/fs/smb/client/connect.c
>>> +++ b/fs/smb/client/connect.c
>>> @@ -4193,6 +4193,7 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
>>>                 return 0;
>>>         }
>>>
>>> +       server->lstrp = jiffies;
>>>         server->tcpStatus = CifsInNegotiate;
>>>         spin_unlock(&server->srv_lock);
>>>
>>> --
>>> 2.33.0
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 

