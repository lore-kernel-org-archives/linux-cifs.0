Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B931437881;
	Thu,  8 Jan 2026 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767866137; cv=none; b=XTM/B89jJEaC2bePYJQmpGWoRtocvd5rae6Wc9nFD0MDv0FvbTguxSMTk4rlkIRtEVXg3+31y4YGfdSLfEiruQ4EeUP5jVIhTvTW/r2tB9CmR/BlDiYpB/IDqXSfspvOyK+++HZ7kQO9osKctAemcFlrqEbDYS/WMp2ghP3PGZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767866137; c=relaxed/simple;
	bh=B6S8TBSEiyZ4YvS8fr2U3VKqbBmcKmxGs9b0vsWOMtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tIWbNG3CoB92SvA5iK4rj7jla/JuZ8RvGi4GWoGKMUX6lePWcq5dHYjRNXMgPApUcLqbbqbjtKkPUT3Ala5pyxaCLy5C/G+eQzPW6J/bzRvUk64ADuEoRsqARlTSkBz2bQe8Kbq64SYWE1dK46G+gvZALojFHwItlaKjCuW/6gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1lgx+Ttr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1lgx+Ttr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=V322NNHDb3UZVoqZIix2wB9FULXm13D1D7TjShLxhms=; b=1lgx+TtrnOTcAWNaHwOJeJJVHn
	DyPjOfISZ4Kg/UeId70CNJkWdYZL/7CyDc0hGhjp5dOzsF4RdiVapAEoNCy0ub06Efqc2ul//Ytgg
	9iGRubksPBx36SZADmZcTH/atant2NAwafFCklQmAws4ZaSpEIPHjyx+iEU7+jRTTdBIobpdCBxq2
	Ov3/I3120b6hGm6/07ct1YEOTxQx1pEm0b3zaz2vLH3dlGfLtPYVLRglb+JIWT3IQlQIDgIV9bOsy
	V3PDm49bgH3If+PQjrOSiKjhfvZgR3n4o3mbMhYsX863RlE77jdGj7Y2POsUQ5Twr+Q4iGOMTugA4
	+/cTyhpuEehxGFkwoY9a1UEtidB0a0zk7U2bKjfrJHhwctV8WZTc011KVTpG0T7+D+RFZdfRL8YzC
	kW4e2dO9Z1+4uk7YorinwXnfFsNK3v/3o324J699DM3d3/rOY5teeMg3osG179RtWb8bFIgoN20l5
	f1rPWJJUBq+R+l4Zu3QFl334;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vdm6s-003RwX-1B;
	Thu, 08 Jan 2026 09:15:14 +0000
Message-ID: <a0453a42-ee41-466a-b8aa-8eaaa38d7905@samba.org>
Date: Thu, 8 Jan 2026 10:15:13 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v6 05/16] quic: provide quic.h header files for
 kernel and userspace
To: Yohei Kojima <yk@y-koj.net>, Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1767621882.git.lucien.xin@gmail.com>
 <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
 <aV9AwNITeyL71INz@desktop.y-koj.net>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <aV9AwNITeyL71INz@desktop.y-koj.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 08.01.26 um 06:29 schrieb Yohei Kojima:
>> +
>> +/* Socket Options APIs */
>> +#define QUIC_SOCKOPT_EVENT				0
>> +#define QUIC_SOCKOPT_STREAM_OPEN			1
>> +#define QUIC_SOCKOPT_STREAM_RESET			2
>> +#define QUIC_SOCKOPT_STREAM_STOP_SENDING		3
>> +#define QUIC_SOCKOPT_CONNECTION_ID			4
>> +#define QUIC_SOCKOPT_CONNECTION_CLOSE			5
>> +#define QUIC_SOCKOPT_CONNECTION_MIGRATION		6
>> +#define QUIC_SOCKOPT_KEY_UPDATE				7
> 
> This is a trivial point, but it would be better to align the indentation
> of the line above.

This is just the diff output in mail, now in my reply
the value 5 is also moved one tab to much.

It's all aligned correctly in the actual file.

metze
