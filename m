Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=83.149.199.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794212677;
	b=pclfjHnKj899IjKvga0GjmWsF9lKAFSsghtlPRcldKATfDluIFLvrTSpckyyGHHcnOmm
	 MckHU4XPVM8ISJpCcFP0bht5WBqWNI7C3aBQDXx0pZQ8cbxmam8PzJjz0+yNthi/388kO
	 3Am77N4pl1krqlW/eDdKEL3MUI9g91JY4v861069/pfJWD93dCevZX0TslQI3aM0PHvuP
	 fGAtb+5/nBrlH+NCXKIu1q+chWubbfTILE6pzQyHOGCpp0Mm6pU0FldodSkmiuAT/H8sI
	 p0JZIzSKTRJrE5lhRnpTmHsL5WiPeCLLAHV+RDHb4ZsmkkdUfY87Y/FzC5e2dKdgjZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794212677;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=OVoz92oNs2Ezhha7zJNPmA71hCd662/09DGYXCdVKRM=;
	b=T/L4Jf9BoRMaV7TK7y+7U/ButHAh2uss5dW3Pp8PSj3U7kT8aVLWsDutAmAsy16DH+U+
	 WmR6Kc/+IHLliNriF9Nm1+CrW/oI/osXa8q+S/Pjscv3mPuxDz4XCRJqkc3hGyXdmEolA
	 Ssnnlxs5het0jovT75LFYtDVrxbDsSWB4Lw8UGl4EjwmEua9OpOeeRgddJ+SGrhnZqd4M
	 IIwj8150kqYfaW6K0v1HNI29yQlD/qjO3oI7AWXKHxkD6sZG65sfLFwlNSOBo2B/wRPyV
	 AeW6E0fETQqi40+M3yr+SZ4/Q7ZhuybaGmDjkGv6bLtmWuYEjWEBRYhis6TDjWW0/+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ispras.ru;
	spf=pass smtp.mailfrom=ispras.ru;
	dkim=pass header.d=ispras.ru header.i=@ispras.ru header.a=rsa-sha256 header.s=default header.b=F9LvWubu;
	arc=none smtp.remote-ip=83.149.199.84
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F0B606A322;
	Mon,  9 Nov 2026 08:24:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7F0B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=ispras.ru header.i=@ispras.ru header.a=rsa-sha256 header.s=default header.b=F9LvWubu
Received: from localhost (unknown [10.10.165.10])
	by mail.ispras.ru (Postfix) with ESMTPSA id A6F97400E772;
	Mon,  9 Nov 2026 08:19:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru A6F97400E772
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1794212361;
	bh=OVoz92oNs2Ezhha7zJNPmA71hCd662/09DGYXCdVKRM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=F9LvWubupRXGAcSfSH9giFamWz6O47z59ApQhw9G+Ei8ds5M8ip4UtqtrlblIwyTS
	 S6OOmp3Me9BqcipSZ3cYU/luvfkHaAQQSvvvCsbAEvFgWRJCYI36rfHbuWKG6br+yo
	 Nep3zfCUHanU8xyp7TiiY/X4py1iVf/idQ2OWGXc=
Date: Mon, 9 Nov 2026 11:19:21 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, Steve French <smfrench@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Stefan Metzmacher <metze@samba.org>, Steve French <stfrench@microsoft.com>, 
	lvc-project@linuxtesting.org
Subject: Re: [PATCH 6.1 0847/1887] smb: client: let smbd_destroy() call
 disable_work_sync(&info->post_send_credits_work)
Message-ID: <20261109105427-98d730a74a61a1220d868813-pchelkin@ispras>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261028170518.701562757@linuxfoundation.org>

Hi Greg, Sasha

please see below on what may be potentially improved in managing these
huge amounts of backports, many of which come with adaptations to old
stable kernels.

Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stefan Metzmacher <metze@samba.org>
> 
> [ Upstream commit d9dcbbcf9145b68aa85c40947311a6907277e097 ]
> 
> In smbd_destroy() we may destroy the memory so we better
> wait until post_send_credits_work is no longer pending
> and will never be started again.
> 
> I actually just hit the case using rxe:
> 
> WARNING: CPU: 0 PID: 138 at drivers/infiniband/sw/rxe/rxe_verbs.c:1032 rxe_post_recv+0x1ee/0x480 [rdma_rxe]
> ...
> [ 5305.686979] [    T138]  smbd_post_recv+0x445/0xc10 [cifs]
> [ 5305.687135] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 5305.687149] [    T138]  ? __kasan_check_write+0x14/0x30
> [ 5305.687185] [    T138]  ? __pfx_smbd_post_recv+0x10/0x10 [cifs]
> [ 5305.687329] [    T138]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> [ 5305.687356] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 5305.687368] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 5305.687378] [    T138]  ? _raw_spin_unlock_irqrestore+0x11/0x60
> [ 5305.687389] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 5305.687399] [    T138]  ? get_receive_buffer+0x168/0x210 [cifs]
> [ 5305.687555] [    T138]  smbd_post_send_credits+0x382/0x4b0 [cifs]
> [ 5305.687701] [    T138]  ? __pfx_smbd_post_send_credits+0x10/0x10 [cifs]
> [ 5305.687855] [    T138]  ? __pfx___schedule+0x10/0x10
> [ 5305.687865] [    T138]  ? __pfx__raw_spin_lock_irq+0x10/0x10
> [ 5305.687875] [    T138]  ? queue_delayed_work_on+0x8e/0xa0
> [ 5305.687889] [    T138]  process_one_work+0x629/0xf80
> [ 5305.687908] [    T138]  ? srso_alias_return_thunk+0x5/0xfbef5
> [ 5305.687917] [    T138]  ? __kasan_check_write+0x14/0x30
> [ 5305.687933] [    T138]  worker_thread+0x87f/0x1570
> ...
> 
> It means rxe_post_recv was called after rdma_destroy_qp().
> This happened because put_receive_buffer() was triggered
> by ib_drain_qp() and called:
> queue_work(info->workqueue, &info->post_send_credits_work);
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/smb/client/smbdirect.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index 9b16840952c09..d2878973c1476 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -1358,6 +1358,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
>  			info->transport_status == SMBD_DISCONNECTED);
>  	}
>  
> +	log_rdma_event(INFO, "cancelling post_send_credits_work\n");
> +	cancel_work_sync(&info->post_send_credits_work);
> +
>  	log_rdma_event(INFO, "destroying qp\n");
>  	ib_drain_qp(info->id->qp);
>  	rdma_destroy_qp(info->id);

It would be good to see a small backporter's comment, you know, on the
reasons behind the performed backport adaptation.  Upstream commit adds a
call to disable_work_sync(), while the backport only does
cancel_work_sync() - and doesn't look to solve the problem completely.
The commit's message says the work can be queued again during ib_drain_qp()
processing a few lines below.  So canceling is not enough.

However, there is no info on why cancel_work_sync() was chosen still: to
reduce the existing race window as best effort, or maybe just calling
cancel_work_sync() is actually fine on 6.1 and fixes the bug properly?

I guess that adding a brief backporter's comment explaining the rationale
behind the adaptation won't be too resource-consuming on your side,
especially if major part is already done with AI stuff.  But it will make
things clearer on whether the backport fix is correct and complete.

--
Fedor
