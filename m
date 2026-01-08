Received: from outbound.ms.icloud.com (p-west3-cluster2-host1-snip4-4.eps.apple.com [57.103.74.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495603D3D0A
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 10:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.74.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767868388; cv=none; b=bZXBxoW3beMBz3hFrSz0kQX5mfv0mm55YZMf640ytIIk0PisKV3tlKITggdZb4SB0qWq3lj2SwFy95ppX0eesU+PejgiMAUZZIrX45OZ/BJG14V5639vdy4DR36Bn18Q8AMcQwiK5she5Cq6AVcWx4m+lnOcbz7QciI2k7yqg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767868388; c=relaxed/simple;
	bh=3VvZc5Pxqa2DYWHioCPMHDe+wkeZBiz42WkZ8pZYGKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pew8Ht8lLVtHsY9Jo6JSbZHTwjliUQx83NU7YtIGOAQlkvdo8i8mSpV2RZcJwrzp7I4NvmRfgyMuHggK42M5asC5q8mDdXVtRCzq0gkWqPtfcI4nLY6rD1m8S9kur7Q+hho/k2CkdNyR7QCcPULmxFw1lLt0m7DUMpVrUbM9Gr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=y-koj.net; spf=pass smtp.mailfrom=y-koj.net; dkim=fail (0-bit key) header.d=y-koj.net header.i=@y-koj.net header.b=lPvKeEbS reason="key not found in DNS"; arc=none smtp.client-ip=57.103.74.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=y-koj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=y-koj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=y-koj.net header.i=@y-koj.net header.b="lPvKeEbS"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-7 (Postfix) with ESMTPS id F0F4718001A0;
	Thu,  8 Jan 2026 10:32:57 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=y-koj.net; s=sig1; bh=LUPYqb/Z3vOvooaWSeMwubFxJknkvN/Ii7q3nM4iWGk=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=lPvKeEbSaYiwAJreUhoH7n0SbBz6UjbzJJQ4dHgB/I870dUntaME2dbfU1GfSOjy08nMiy2V1rnTWxFjSVaKa/GE4FF9Hnmfz5zc4zvs1c+FS+fUqhMgwpc9hAbSCsXY9wimIbzlZ3NY9BS3jAJhOE70kLQVJXFXeus9DJB/aOrJcwLbkLSsx5dKsBfxlP4kqcL/BK9xwYOvD1+ou/tf+2UJS4odvhJS15T0aCEgfHG878nm54fGW2TlFIBYnaqLtl7MrFCTaIG2YkcrIio7eomuYgP/CUaqUQ2w2v05PpK3JJtjx0Qg7XQ84HTjJiSpI+pzkhpGxQJRiGYAuBu9oQ==
mail-alias-created-date: 1719758601013
Received: from desktop.y-koj.net (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-7 (Postfix) with ESMTPSA id 3401718001EA;
	Thu,  8 Jan 2026 10:32:53 +0000 (UTC)
Date: Thu, 8 Jan 2026 19:32:51 +0900
From: Yohei Kojima <yk@y-koj.net>
To: Stefan Metzmacher <metze@samba.org>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev, davem@davemloft.net, kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v6 05/16] quic: provide quic.h header files for
 kernel and userspace
Message-ID: <aV-HgBCqGx0pc-pL@desktop.y-koj.net>
References: <cover.1767621882.git.lucien.xin@gmail.com>
 <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
 <aV9AwNITeyL71INz@desktop.y-koj.net>
 <a0453a42-ee41-466a-b8aa-8eaaa38d7905@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0453a42-ee41-466a-b8aa-8eaaa38d7905@samba.org>
X-Proofpoint-GUID: JLj43OVRav7MR6VFNVjRS8okeeDqPRLl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA3MSBTYWx0ZWRfX5hmb4oSR963s
 Iog93epKphb/mOgoQFR2UR0U/5XfwAfFsTfEQ4nQMrcr+FPjIqramaOeSCwRvmj8rf9iSDSgsIv
 W6/W7tjhh7SqHpJjM4r55aaEV2IqF+y2575cy7C9MJLxlf7koDWNka+jMlFuf5F2Z2xBSCfCQ2S
 XrsKjRJM/RgmECGh39aCoQN3gkkVMqbQJjobWeUpqlWYMJ1lseR8PyqGljS6GfZtw2+526+Z+vo
 PgLY8NoybtybcIuy2WRVcpj4lUZK6hISKEa1LYm+swQHyl+fGA0w425eCRKg7fzXo2PldzD4BsX
 1guYZzAOZjXBxXxcSvw
X-Authority-Info: v=2.4 cv=b/G/I9Gx c=1 sm=1 tr=0 ts=695f87db
 cx=c_apl:c_apl_out:c_pps a=qkKslKyYc0ctBTeLUVfTFg==:117 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=_cr4Ci8WIZHmLF2k5DQA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: JLj43OVRav7MR6VFNVjRS8okeeDqPRLl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_02,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=576
 phishscore=0 clxscore=1030 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 classifier=spam authscore=0 adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2510240001 definitions=main-2601080071
X-JNJ: AAAAAAAB7HiKDXe6q/z6mwBqEPBcxpgq2SZdZu0d1zTRUl+8Mh95RVMlNCbhqB+hmtxz+g4tD+gGurL6TBbAhgIQuBly6NiLQN798UYk7PSEJhiwZmbWLPn6vMJK8bYsUSKAd+ij8lEBEUtB9ktehSVNt4cQN1VeuOSh5H7scQ2P7D54iIbo1B8XBDcH0AR1k49dlRWuEddjBy1m/Zl3LHTa8Rm+r+4UzyEgEGJVC80zc4ZZwg/ApYc6CI/ITLTRMiyQFTBMOrxT7V1dt+ViZb0hoD011JDkDSrQCDJAuqagF1ZJgMoST0qzZVculNtwA1NmfULwZ8mrGgHF1Z0vBNQWfPmQukAWW6jDjAxX9r533dhqURLZTggPlXjSAInYjfPT/XlW/HRn2Osw3P3FOt+Ffb+zWG5qjBM4WYw1Bvsit+ffzTzt4LOQAHntvs6qTVqNQHhrdFGWSr+X/wnJCPZW225TGNkuc0qxr4LwubF7vA37Hcgm772/rargMeyJ//XVCe5vIToXNDQUvWkxNKizKjLQ64CxuV9Tr/tUah7MGYOtOQuRfgbklcqXjqWDBEC5P6M41qPR7KeRQt9TJwKwta0IL8OOdSjcRcXfNrNr+qQZ19h2+MR27/Let2ltPgqRsQb1wz4Dx12YQBc+LFiG5ac++Pgyd5m3pNKOoYDlFV0IAw86GHwl6scWEpdSKiuamL7Cws8g6/NTcsA2XGNfMrZwkQzuUm7vX+DadEBhjWBYLnZbFqqhCvyAFi/sOq0lpnL+dC1KMOtpId0s/e/Y/Q03njmQjYfxet4jvsZwYPyxhAt3sUCxlvBNim/V0y54AUHbUltGFSkhmlubiEs/Mux+SDUuK5EyjgNjL/ZVGseFCnxuSjc280tnz7X6pqpgKm5t+U7bXnKRck3JwrqriSv3EVdzzwh5AX+DqUo25uV7/FdfgWKKNWW6takhr+NbB2SJCe1eUXYcvsdZsZUA1i83wnN
 ktib/Dr/kuVOMgFo+6wJLHt+wiQuS/JE04xvE87fdV1qj9GqXt8Ghl8cQWu+pMDazHVlfiHhU7mCAav8Ow/xcWcSplmOQlc3AWZWpL6E=

On Thu, Jan 08, 2026 at 10:15:13AM +0100, Stefan Metzmacher wrote:
> >> +
> >> +/* Socket Options APIs */
> >> +#define QUIC_SOCKOPT_EVENT				0
> >> +#define QUIC_SOCKOPT_STREAM_OPEN			1
> >> +#define QUIC_SOCKOPT_STREAM_RESET			2
> >> +#define QUIC_SOCKOPT_STREAM_STOP_SENDING		3
> >> +#define QUIC_SOCKOPT_CONNECTION_ID			4
> >> +#define QUIC_SOCKOPT_CONNECTION_CLOSE			5
> >> +#define QUIC_SOCKOPT_CONNECTION_MIGRATION		6
> >> +#define QUIC_SOCKOPT_KEY_UPDATE				7
> > 
> > This is a trivial point, but it would be better to align the indentation
> > of the line above.
> 
> This is just the diff output in mail, now in my reply
> the value 5 is also moved one tab to much.
> 
> It's all aligned correctly in the actual file.

That's embarrassing! I'm very sorry for the noise.

Yohei
