Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5ADEACE;
	Fri, 14 Mar 2025 01:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741915765; cv=none; b=e5UkJb0QcR4MsYA5ybQQb6E9g2dGIEeS032hlev8fnz+597OdX12eoidhvU7tebtSws6fHyU42CBS1x0M0xMePvXTqG1+SSsk1XDP0v3WkYZkg8izwQHAgI/2LxrI+7AwJ4FdccC2rUGhgoZVbzQe61hWxRUlzGYD7azo4Ktmw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741915765; c=relaxed/simple;
	bh=5/ISF98sVSlGWN+z1kITjsNRve35oHcym2fF9pVz5mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Aw+qiBfh0nlnKYmPTd/0uQcwu7U9LFBop4fCVQD6MV8ZHvh9cCR6IuyvJobr15Ay0COUevUsYiBR1d4nPHUPsQXys9mF5xYyURLKINAAKmtth30yot8SrXv2qKJtcafnYMceIXOb7BtPv5H/y82Ql1oPukXpalcx6VmXoSKjI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZDRVw0KSSz2RTR8;
	Fri, 14 Mar 2025 09:24:56 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id A6D0B1400CA;
	Fri, 14 Mar 2025 09:29:19 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:29:18 +0800
Message-ID: <c056ce12-2b02-fe11-5f61-ce913b6de5d9@huawei.com>
Date: Fri, 14 Mar 2025 09:29:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH] smb: client: Fix netns refcount imbalance causing leaks
 and use-after-free
To: Steve French <smfrench@gmail.com>
CC: <tom@talpey.com>, <kuniyu@amazon.com>, <ematsumiya@suse.de>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20250218143005.1318886-1-wangzhaolong1@huawei.com>
 <CAH2r5mstBkj5-aHcXLpb8YzrDHS+nWhW+i_Kf8eJK15sFmJx8A@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAH2r5mstBkj5-aHcXLpb8YzrDHS+nWhW+i_Kf8eJK15sFmJx8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500010.china.huawei.com (7.202.181.71)



> I was looking at this patch in more detail, and it does look important
> but I wanted to clarify a few things.  In your detailed description
> you mention that the retry on port 139 is missing a call put_net(0
> 
>>          ip_connect
>>            generic_ip_connect /* Try port 445 */
>>              get_net()
>>              ->connect() /* Failed */
>>              put_net()
>>            generic_ip_connect /* Try port 139 */
>>              get_net() /* Missing matching put_net() for this get_net().*/
> 
> but I found this confusing because generic_ip_connect() doesn't seem
> to treat the port 445 vs. port 139 differently (there are only two
> places the function does put_net() and the latter on line 3421 looks
> like the only one that matters for your example).  Here is the snippet
> from generic_ip_connect().  Could you explain why the retry on port
> 139 example is different here?
> 
>          rc = kernel_connect(socket, saddr, slen,
>                              server->noblockcnt ? O_NONBLOCK : 0);
>          /*
>           * When mounting SMB root file systems, we do not want to block in
>           * connect. Otherwise bail out and then let cifs_reconnect() perform
>           * reconnect failover - if possible.
>           */
>          if (server->noblockcnt && rc == -EINPROGRESS)
>                  rc = 0;
>          if (rc < 0) {
>                  cifs_dbg(FYI, "Error %d connecting to server\n", rc);
>                  trace_smb3_connect_err(server->hostname,
> server->conn_id, &server->dstaddr, rc);
>                  put_net(cifs_net_ns(server));
>                  sock_release(socket);
>                  server->ssocket = NULL;
>                  return rc;
>          }


Yes, both ports are treated similarly by the client; however, according
to the network packets I captured, the access error was returned by
the server.

This issue was identified through a flawed cifs test case, where
the cifs file system was mounted on the client before the server had
fully initialized the smbd service. Here's a breakdown of the process:

1. First Connection Attempt: The cifs client first attempts to connect
    to port 445. Since the server has not yet completed its initialization,
    it returns an error -111.

2. Subsequent Connection Attempt: The cifs client then tries to connect
    to port 139. At this point, the server has finished initializing, thus
    the `kernel_connect()` API call succeeds.

However, the server seemingly does not support the older data format associated
with port 139, likely due to server configuration settings. When the cifsd thread
processes the message, it detects this incorrect data format and triggers
cifs_reconnect(). This action leads to the issue of leakage.

By maintaining the test case essentially unchanged and simply blocking the
server's port 445 with a firewall, I can easily reproduce this issue.

The network packets I captured are as follows:

5	0.896004	192.168.11.3	192.168.11.2	TCP	74	38246 → 445 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 SACK_PERM TSval=210053990 TSecr=0 WS=128
6	0.896121	192.168.11.2	192.168.11.3	ICMP	102	Destination unreachable (Port unreachable)
7	0.896287	192.168.11.3	192.168.11.2	TCP	74	52196 → 139 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 SACK_PERM TSval=210053990 TSecr=0 WS=128
8	0.896336	192.168.11.2	192.168.11.3	TCP	74	139 → 52196 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM TSval=3568249692 TSecr=210053990 WS=128
9	0.896410	192.168.11.3	192.168.11.2	TCP	66	52196 → 139 [ACK] Seq=1 Ack=1 Win=64256 Len=0 TSval=210053990 TSecr=3568249692
10	0.896511	192.168.11.3	192.168.11.2	NBSS	142	Session message
11	0.896541	192.168.11.2	192.168.11.3	TCP	66	139 → 52196 [ACK] Seq=1 Ack=77 Win=65152 Len=0 TSval=3568249692 TSecr=210053990
12	0.898382	192.168.11.3	192.168.11.2	TCP	302	52196 → 139 [PSH, ACK] Seq=77 Ack=1 Win=64256 Len=236 TSval=210053992 TSecr=3568249692 [TCP segment of a reassembled PDU]
13	0.898427	192.168.11.2	192.168.11.3	TCP	66	139 → 52196 [ACK] Seq=1 Ack=313 Win=65024 Len=0 TSval=3568249694 TSecr=210053992
14	0.906736	192.168.11.2	192.168.11.3	TCP	66	139 → 52196 [RST, ACK] Seq=1 Ack=313 Win=65024 Len=0 TSval=3568249702 TSecr=210053992
15	0.906980	192.168.11.3	192.168.11.2	TCP	74	52206 → 139 [SYN] Seq=0 Win=64240 Len=0 MSS=1460 SACK_PERM TSval=210054001 TSecr=0 WS=128
16	0.907054	192.168.11.2	192.168.11.3	TCP	74	139 → 52206 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM TSval=3568249703 TSecr=210054001 WS=128
17	0.907099	192.168.11.3	192.168.11.2	TCP	66	52206 → 139 [ACK] Seq=1 Ack=1 Win=64256 Len=0 TSval=210054001 TSecr=3568249703
18	0.907175	192.168.11.3	192.168.11.2	TCP	66	52206 → 139 [FIN, ACK] Seq=1 Ack=1 Win=64256 Len=0 TSval=210054001 TSecr=3568249703
19	0.910324	192.168.11.2	192.168.11.3	TCP	66	139 → 52206 [ACK] Seq=1 Ack=2 Win=65280 Len=0 TSval=3568249706 TSecr=210054001
20	0.918673	192.168.11.2	192.168.11.3	TCP	66	139 → 52206 [FIN, ACK] Seq=1 Ack=2 Win=65280 Len=0 TSval=3568249714 TSecr=210054001
21	0.918714	192.168.11.3	192.168.11.2	TCP	66	52206 → 139 [ACK] Seq=2 Ack=2 Win=64256 Len=0 TSval=210054012 TSecr=3568249714

The detailed analysis process is as follows:

1. Initial Connection Attempt to Port 445 (SMB Direct):
  - Client (192.168.11.3) initiates a TCP connection to server (192.168.11.2) on port 445
  - Server immediately rejects this with an ICMP "Port unreachable" message
    - This indicates port 445 is either closed or blocked on the server

2. Fallback Connection Attempt to Port 139 (NetBIOS)
  - Client attempts to connect to the server on port 139 (NetBIOS)
  - Three-way TCP handshake succeeds:
      * Client sends SYN
      * Server responds with SYN+ACK
      * Client acknowledges with ACK

3. NetBIOS Session Setup:
  - Client sends a NetBIOS Session Service (NBSS) message
  - Server acknowledges receipt
  - Client sends additional data (236 bytes) as part of a larger PDU (Protocol Data Unit)
  - Server acknowledges this data

4. Connection Reset:
  - Server unexpectedly terminates the connection with RST+ACK flags
    - This indicates the server rejected the client's request after examining the session data

5. Final Connection Attempt:
  - Client tries again on port 139 from a new source port (52206)
  - Three-way handshake completes successfully
  - Client immediately initiates connection termination with FIN+ACK
  - Server acknowledges, then sends its own FIN+ACK
  - Client acknowledges, completing the graceful connection termination

Please let me know if there is any other information you require or
further details I can provide.

Best regards,
Wang Zhaolong

