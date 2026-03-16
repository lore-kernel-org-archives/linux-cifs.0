Received: from mail.whitenite.de (mail.whitenite.de [37.120.171.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0596391838
	for <linux-cifs@vger.kernel.org>; Mon, 16 Mar 2026 20:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.171.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773692819; cv=none; b=THVS8cA38jJOIC1HfI/IZfe5Tia6i13fsQdWtxhxyaqjKxMSv6RHiwF8onPFu0/RLpqk9Rf6PC+IjMt2SyJVvcr/EIlt76RZrixzKlT4ct90UuItEZtGUe/fdOiBX7nmuYE9HgmmApt6qozqaurXSopOeBdceFSiuuDpgJ2bbhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773692819; c=relaxed/simple;
	bh=SqyBhjRu90/3AeovOA5PMZSFhn4KMK/ySUsC7D+YHUY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=QzHmj11eInhg/Yx+Sr5KmHjc4J7lKmfYwC8pLu2kVSteiX2hnSQ31ar58i/ndKpurrGJ41B+4/MNynFBJevSuCEGuIm6FoqY/D9Zk6zqqUBiKXLI5ZV6oEWQq5AlrOde2CPmS4PLYixYXA07BK4bkYYYz+9TG/jdoTYF1eRphY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=whitenite.de; spf=pass smtp.mailfrom=whitenite.de; dkim=pass (2048-bit key) header.d=whitenite.de header.i=@whitenite.de header.b=A5Buh7Y7; arc=none smtp.client-ip=37.120.171.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=whitenite.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=whitenite.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=whitenite.de header.i=@whitenite.de header.b="A5Buh7Y7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=whitenite.de;
	s=excisionRSA; t=1773692815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tctLBZP9hKWPagalZr5JSxDIsCUCChpJRsFDnGUA9Uc=;
	b=A5Buh7Y7ySUombOSX30x+jQM1tyJetr8/yYMN7GbAKEVbpSgLkUTQ0axRu9WKRgHNDszqN
	bmZ1upl95c1s3wdAWiDRh8b9HQz3YuDOftckwyk0SXmJn5HUgX5BNvR2uD7wYzEJsOaKvy
	kzRQv1bU6lY10iCpBDsSdoufflLCArOrq3ZOYN2IMfPwqiWAzlpmaraRIBAAG6e1ai0Ytr
	d2FW2H2e7xnQbNwF8cHWd1Z5v27t2r8ydk2Asw5aodRfxBOV+yjsO74u/IxIgnXs6o76iJ
	AKCfBXvrN+scZE5GJCJZIrqoSLvCuD3q6EpVXnsBPlKNH+32vvwc+LnYkZ3e6w==
Received: 
	by mail.whitenite.de (OpenSMTPD) with ESMTPSA id 8e98ed94 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO) auth=yes user=elias@whitenite.de
	for <linux-cifs@vger.kernel.org>;
	Mon, 16 Mar 2026 21:26:55 +0100 (CET)
Message-ID: <103cbfdc-9dc5-49b9-b89c-9555a79e7ae0@whitenite.de>
Date: Mon, 16 Mar 2026 21:26:54 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Elias <sec@whitenite.de>
Subject: IPv6-only client loses connection after server disconnect
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hey all,

on a client with IPv6-only connectivity, my share becomes unavailable when the server disconnects itself after 60 minutes idle. The client will then try to 
reconnect over IPv4.

```
# /etc/fstab
//u559000-sub1.your-storagebox.de/u559000-sub1 /srv/smb/control/ cifs 
iocharset=utf8,rw,seal,file_mode=0660,dir_mode=0770,uid=1052,gid=1052,mfsymlinks,credentials=/etc/cifs-creds-u559000-sub1.txt 0 0
```

 From what I could find out so far, it only happens on clients where `keyutils` package is installed (when `/sbin/key.dns_resolver` is available). On initial 
mount the client connects via IPv6 as expected, in either case. The server has A- and AAAA-records.

* With `keyutils` installed, as soon as the server has disconnected, the client will resolve the servers hostname via `dns_resolve_server_name_to_ip`, but this 
will only return the DNS A-record, while the client can not reach IPv4 destinations. The share will hang and report "Host is down".
* Without `keyutils` installed, as soon as the server has disconnected, the client fails to resolve the servers hostname, and it will just continue with a 
`generic_ip_connect` to the initial IPv6 address. The share reconnects successfully.

Is this expected? Is this a keyutils-specific issue?

Client reconnect with `keyutils` installed:
```
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: Received no data or error: 0
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: Mark tcp session as need reconnect
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: cifs_mark_tcp_ses_conns_for_reconnect: marking necessary sessions and tcons for reconnect
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for chan 0; now 0x1
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: cifs_mark_tcp_ses_conns_for_reconnect: channel connect bitmap: 0x1
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: cifs_abort_connection: tearing down socket
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: State: 0x3 Flags: 0x20
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: Post shutdown state: 0x3 Flags: 0x20
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: cifs_abort_connection: moving mids to private list
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: cifs_abort_connection: issuing mid callbacks
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: probably server name is whole unc: \\u559000-sub1.your-storagebox.de
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: u559000-sub1.your-storagebox.de to 203.0.113.195 expiry 0
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: __cifs_reconnect: reconn_set_ipaddr_from_hostname: rc=0
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to 203.0.113.195:445
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: Socket created
[Mon Mar 16 11:08:43 2026] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
[Mon Mar 16 11:08:46 2026] CIFS: fs/smb/client/connect.c: Error -113 connecting to server
[Mon Mar 16 11:08:46 2026] CIFS: fs/smb/client/connect.c: __cifs_reconnect: reconnect error -113
```

Client reconnect without `keyutils` installed:
```
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: Received no data or error: 0
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: Mark tcp session as need reconnect
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: cifs_mark_tcp_ses_conns_for_reconnect: marking necessary sessions and tcons for reconnect
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for chan 0; now 0x1
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: cifs_mark_tcp_ses_conns_for_reconnect: channel connect bitmap: 0x1
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: cifs_abort_connection: tearing down socket
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: State: 0x3 Flags: 0x20
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: Post shutdown state: 0x3 Flags: 0x20
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: cifs_abort_connection: moving mids to private list
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: cifs_abort_connection: issuing mid callbacks
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: probably server name is whole unc: \\u559000-sub1.your-storagebox.de
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/dns_resolve.c: dns_resolve_server_name_to_ip: unable to resolve: u559000-sub1.your-storagebox.de
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: reconn_set_ipaddr_from_hostname: failed to resolve server part of u559000-sub1.your-storagebox.de to 
IP: -2
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: __cifs_reconnect: reconn_set_ipaddr_from_hostname: rc=-2
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: generic_ip_connect: connecting to [2001:db8::1]:445
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: Socket created
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/smb2ops.c: smb2_set_credits: set 1 credits
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/smb2ops.c: set credits to 1 due to smb2 reconnect
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/smb2pdu.c: Reconnecting tcons and channels
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/smb2pdu.c: sess reconnect mask: 0x1, tcon reconnect: 1
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/transport.c: wait_for_free_credits: remove 1 credits total=0
[Mon Mar 16 11:07:41 2026] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=268
```

More system details: (SMB server is a Hetzner Storage Box)
```
# uname -r
6.12.57+deb13-cloud-amd64

# cat /etc/debian_version
13.4

# mount.cifs -V
mount.cifs version: 7.4

# dpkg -l | grep -E 'keyutils|cifs'
ii  cifs-utils                              2:7.4-1                              amd64        Common Internet File System utilities
rc  keyutils                                1.6.3-6                              amd64        Linux Key Management Utilities
ii  libkeyutils1:amd64                      1.6.3-6                              amd64        Linux Key Management Utilities (library)

# cat /proc/fs/cifs/DebugData
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.51
Features: DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x18 Hostname: u559000-sub1.your-storagebox.de
ClientGUID: C24CEA2E-E952-0644-A6BA-FE1A3355486C
Number of credits: 256,1,1 Dialect 0x311
Server capabilities: 0x300047
TCP status: 1 Instance: 4
Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840
In Send: 0 In MaxReq Wait: 0
Compression: no built-in support

	Sessions:
	1) Address: 2001:db8::1 Uses: 1 Capability: 0x300047	Session Status: 1
	Security type: RawNTLMSSP  SessionId: 0x99045274 encrypted
	User: 1052 Cred User: 0

	Shares:
	0) IPC: \\u559000-sub1.your-storagebox.de\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
	PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 encrypted
	Share Capabilities: None	Share Flags: 0x8000
	tid: 0xa12e332	Maximal Access: 0x1f00a9

	1) \\u559000-sub1.your-storagebox.de\u559000-sub1 Mounts: 1 DevInfo: 0x20 Attributes: 0x1006f
	PathComponentMax: 255 Status: 1 type: DISK Serial Number: 0x9b2ff988 encrypted
	Share Capabilities: None Aligned, Partition Aligned,	Share Flags: 0x8000
	tid: 0xf57a0175	Optimal sector size: 0x200	Maximal Access: 0x1f01ff


	Server interfaces: 2	Last updated: 17723362 seconds ago
	1)	Speed: 10Gbps
		Capabilities: rss
		IPv4: 203.0.113.195
		Weight (cur,total): (0,1)
		Allocated channels: 0

	2)	Speed: 10Gbps
		Capabilities: rss
		IPv6: 2001:db8::1
		Weight (cur,total): (1,1)
		Allocated channels: 1
		[CONNECTED]


	MIDs:
--
```

Thank you for any help!

Cheers,
Elias
