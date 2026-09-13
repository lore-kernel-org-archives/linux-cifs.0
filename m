Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B267437E304;
	Sun, 13 Sep 2026 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789323984; cv=none; b=WQGCQQ9EyKpC+RcTR3Aab2aIdolxBVFSDAHIbyP1/iU9QbNjJ9fGD3RdjY6LzGj13zTUcCEXqotdbGpeRJiftVeMCHBM7f1WvzO6WWnAaJ8t8znPR63U3yq6TyxCQkaBBSwp+o/pTUoDqUZQQJJVBM57VN27wBRsmW4TXMMUvoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789323984; c=relaxed/simple;
	bh=aMz3LhyvzL0UNX+fKfz5MaMvXA88V+072oEqKjTlUrY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=GccaZIC1Rid9EC9Q0bJktIdr9tAMXnKHtg/vAtnOi/YHYzBks1K7sLjaHVYDPgl3ltTiO9o/6XNoytY41gOZ35XWdxXFYiZQ6jJEU3LvvD3Vii3+4if1Whm8v1SNiaCP105gLsd0bqlfairQnIRJXUfzLzz7RGu49ffhh+vSVAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Ej0G+AaO; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Ej0G+AaO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ppfZBqrKZfnd3U/kNsshWPsEGj74HFB25woC8i2RF7s=; b=Ej0G+AaOzSYcGkTEjAO4cwHLjo
	aisgARYX/5UgFaJuC/jPP2J4OF0DUzoLiSW+vECox5sJxeg0w76GSoQbjIAQNhIygUlBtYHn5fjBX
	nauPq3n1gX5MWnLFm+Vdt2dkScnuiFt1JqS5LKpOL7aN/kzhxc5ew/meTB+wTdwjsbFJOa9ccvZwg
	J7f/vS35+uHz8tLoMX5oOat1KqFz9cLhV91c3+awKEp69UX+2jG6ye+LeTxcLDSFBkl2bpgr5Ijkw
	PU7Q/+ly51q+fYIBVanN40sLgjJR1ZdGCqzJ6aBHUspXL7eRt86a/u0ewWx47XsLUO8hm8K8XU58r
	WFbEs7Wg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5ou2-00000001LCP-1GWL;
	Sun, 13 Sep 2026 15:26:10 -0300
Message-ID: <dacbe87f887b4ce6c93846c8d34c162e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: syzbot+5003556314abc915a71f@syzkaller.appspotmail.com, David Howells
 <dhowells@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>, Bharath
 SM <bharathsm@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>,
 stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: cancel reconnect work in
 clean_demultiplex_info()
In-Reply-To: <20260912152008.392251-1-pc@manguebit.org>
References: <20260912152008.392251-1-pc@manguebit.org>
Date: Sun, 13 Sep 2026 15:26:09 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> clean_demultiplex_info() cancels server->echo delayed work but not
> server->reconnect, which can cause a use-after-free when the
> demultiplex thread exits while a reconnect work is still queued:
>
>   cifs_demultiplex_thread()
>     cifs_readv_from_socket()
>       cifs_reconnect()
>         __cifs_reconnect()
>           cifs_queue_server_reconn()
>             mod_delayed_work(cifsiod_wq, &server->reconnect, 0)
>     clean_demultiplex_info()
>       cancel_delayed_work_sync(&server->echo)   // echo canceled
>                                                  // reconnect NOT canceled
>       kfree_sensitive(server)                    // server freed
>
>   ...later, on cifsiod_wq:
>
>   smb2_reconnect_server()
>     server->srv_count  // UAF read of freed server
>
> Fix this by canceling server->reconnect delayed work in
> clean_demultiplex_info() before the server is freed, the same way
> cifs_put_tcp_session() already does.
> ...

Applied.
