Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523E101C7
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="KB15ZBi3"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F2030CD
	for <linux-cifs@vger.kernel.org>; Thu,  9 Nov 2023 05:28:17 -0800 (PST)
Message-ID: <abf890046207efea833cf9f5f9d589ab.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699536495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUFcprh9ib/PubOlOUkpFOrPp/YnowCj/eILD3p/eHU=;
	b=KB15ZBi3ex2afBieadi95IGZrhJEDv5FMH3jQjMiSGREclu+1hCynT3l6H3VgGQFs65cqW
	3xv++WRUGn4XP60LP7PFgUzb9LltPgZbEaf1aAptmQppFQYOtf6nLzjC37okkV1DA83YHS
	fVbcG1VxKMug9euH8UdJBDJIhCtYhK0Tig6B8kSpOVXSkzst16uaTb79BNBgqyzjYJQ4Pg
	kmnNQIS0tW92vY6aOJCx1EKCoHvsPmyUWHdFlwR7UFyy4RXE/PX4BBcfN53R3dvzeqXROr
	HjOxCPuzsEpOjOR9WOE6Rcz86aiGim6V8Qj9YQL5iWcNTrxQffmfNTBOW+Yl+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699536495; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oUFcprh9ib/PubOlOUkpFOrPp/YnowCj/eILD3p/eHU=;
	b=P3+gqFL9o5c713hn0NA05Mv6Be0SQEAsrPCGxRtCbAl3kD+JpXLMeGMWaJj6oNT21xNd0v
	5C7lpVkhnvKENNc9ukLSrxe4q29SSEQu6K0TZDJaHHapLBnO+m7E/lJPir7YdwsCOZWcuX
	ny8ZHv8ahBHdphsF99wrXfv4IpgriLDrN7ommOxKz+r72K8FTNQtMcLfrLDHD4JRUY7juG
	1vbEQ1/S/6tIjX4J9HD8g3xhVMwCykxyC+SwEEgQfhUK9mGoWzrYCpG28/8WA+G1KfRGF+
	wC8I87hLfIEFm7uhitY9squAhXnWvus1IGAUnxpn+wBnARYoHxVDxewasnxdew==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699536495; a=rsa-sha256;
	cv=none;
	b=iQVpHo17Hdp0BBdq0nKoWaOcTFq353WDBMcTuWUnwg+yy0AUCmnR3QKi7Sv+LBsqVCSCod
	K3uHDfZ4rWHeW/IozkM1FvrRoas1hMYqVeD1jr0MtK8lDCqot704K2wMkQZBnKhmiIDI6U
	9VyVt9NwmBZ2t7zA7BNnwndmkiB5gigOnzuLZwucYKMZufFZpnYH5u387b9gdrCVbvF6No
	MiJ1GiRFxSky4tFVQpGS5tBVf3s8OVXu8ELW4ygwvmLIsfRFevOLMeKUSVUwcmAOr11yCK
	Kpox4HOGPm+tGkFANkcFSlqdY+4MDRkNUUyk1/QgHQNSqbhxLzGZejX8Lrrs6A==
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: smfrench@gmail.com, bharathsm.hsk@gmail.com, linux-cifs@vger.kernel.org,
 Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting
 multichannel
In-Reply-To: <CANT5p=pawpExEBXp93rK-kmoBPRY4QDMiyXvDCv7Ug0_vrxUPQ@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-12-sprasad@microsoft.com>
 <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com>
 <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
 <CANT5p=pawpExEBXp93rK-kmoBPRY4QDMiyXvDCv7Ug0_vrxUPQ@mail.gmail.com>
Date: Thu, 09 Nov 2023 10:28:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Thu, Nov 9, 2023 at 1:11=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>>
>> > and leaked server connections
>> >
>> >       Display Internal CIFS Data Structures for Debugging
>> >       ---------------------------------------------------
>> >       CIFS Version 2.46
>> >       Features: DFS,FSCACHE,STATS2,DEBUG2,ALLOW_INSECURE_LEGACY,CIFS_P=
OSIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
>> >       CIFSMaxBufSize: 16384
>> >       Active VFS Requests: 0
>> >
>> >       Servers:
>> >       1) ConnectionId: 0x70e Hostname: w22-root2.gandalf.test
>> >       ClientGUID: 44DAE383-3E91-3042-85FE-87D6F17298B7
>> >       Number of credits: 1,1,1 Dialect 0x210
>> >       Server capabilities: 0x300007
>> >       TCP status: 4 Instance: 77
>> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespa=
ce: 4026531840
>> >       In Send: 0 In MaxReq Wait: 0
>> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link10
>> >
>> >               Sessions:
>> >                       [NONE]
>> >       2) ConnectionId: 0x706 Hostname: w22-root2.gandalf.test
>> >       ClientGUID: C8CF45E4-F70D-DF40-8821-0234A2E20DD4
>> >       Number of credits: 1,1,1 Dialect 0x210
>> >       Server capabilities: 0x300007
>> >       TCP status: 4 Instance: 81
>> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespa=
ce: 4026531840
>> >       In Send: 0 In MaxReq Wait: 0
>> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link6
>> >
>> >               Sessions:
>> >                       [NONE]
>> >       3) ConnectionId: 0x6ae Hostname: w22-root1.gandalf.test
>> >       ClientGUID: AB059CDD-12FF-B94D-B30C-9E1928ACBA95
>> >       Number of credits: 1,1,1 Dialect 0x210
>> >       Server capabilities: 0x300007
>> >       TCP status: 4 Instance: 96
>> >       Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespa=
ce: 4026531840
>> >       In Send: 0 In MaxReq Wait: 0
>> >       DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link9
>> >
>> >               Sessions:
>> >                       [NONE]
>> >         ...
>>
>> I ended up with a simple reproducer for the above
>>
>>         mount.cifs //srv/share /mnt/1 -o ...,echo_interval=3D10
>>         iptables -I INPUT -s $srvaddr -j DROP
>>         stat -f /mnt/1
>>         # check dmesg for "BUG: sleeping function called from invalid co=
ntext"
>>         iptables -I INPUT -s $srvaddr -j ACCEPT
>>         stat -f /mnt/1
>>         umount /mnt/1
>>         # check /proc/fs/cifs/DebugData for leaked server connection
>
> Ack. I'll try and get a repro locally and debug this one.

This should be related to patch 10/14 as you're taking an extra
reference of @server over reconnect, and when the client reconnects and
umount, that reference don't seem to be put afterwards.
