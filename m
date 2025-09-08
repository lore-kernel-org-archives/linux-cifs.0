Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955D414AD2D
	for <linux-cifs@vger.kernel.org>; Mon,  8 Sep 2025 08:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757321411; cv=none; b=lsnDj67JWG+qxHF3JrNk/I17Ha4hhPxkfzYf7OZfLOsco2IDB1I7DUkaxcVoGm0qAsBxM1fxxcozuAMv0FB5s4O2dILZO9UBeP/zUdCBF5rvFJfR7c95GUj7ygISEgJhmsXszav3FSD383DKdDa8p+79nYgHFZ/+fcIFO2YXD7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757321411; c=relaxed/simple;
	bh=RWgGTNT0KB12FAbq4wtcS8Rpr2Qp5B0jR4ZnVCKLXGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sHDZtWCq/JRrRcpLg2hpahkfUKwZ+dHznuNCbt65wMgbFlv1yc6ccxEbOo7jNGHo4LvtjTj6RAWgIx3PkAS6UL0fV74KnRLsD7GuvzffNCX6FpBTW6FWFNoxgyZtH1p2BK6aVxFFYF6J8u3C4TmSFiaoE4BiF0B8IhBAZmsyU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fsrTCofN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fsrTCofN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=p2MXBGccQsNucSFWw520nsPaNqkRcggFQoELEgtx0ks=; b=fsrTCofNwtPQaLCSHJ4kEPatRH
	hi7yH44NIdIHr+Uuxsn3b8pd7Su6eaLSQPGXXW4dfgjFS9lFQu94tPn4P2BDfLSice6j7FDtTslYs
	HRSiiDFVM8xAUdAM/u9S2moA/2qJzgDKJow4h/JT/z7HcmdWX+c0F/G4kpPcgx3AekdZigxbMRi5c
	8XUx/Nv9MswPNF2+eV/NsIWle5RxWOI3fwMekCsdPS8Bdy1kg8UGnqogCHoJQc4ikcJwqsBpCx+Lj
	JkQJhKqMkwqhz831OiHeOgFhEMlSElK5OEIlOpoyanlcyeuGi8hyBaOBNXusVtWHnlDc40jnZBbrR
	t3QPYO0Bg//q4+yaHbARfTi6X05zZnG7SdXCD/iBhmrAGYywI01aOsTgyRL0mCtXA67ygJeAuXl17
	nIsysya0VA/aBiZjyrRY3FQsOT9cu5lCP3M5kmovX1mdme7DLynUuLNXvGAoO7EfGong0kuaRHRRX
	Gf+g+ont2WOESFWVtohLcwRt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uvXZY-0030F4-0j;
	Mon, 08 Sep 2025 08:50:00 +0000
Message-ID: <8aaf1c25-1778-4853-a23b-20ecc902f1ce@samba.org>
Date: Mon, 8 Sep 2025 10:49:59 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 004/142] smb: smbdirect: introduce
 smbdirect_socket.send_io.pending.{count, wait_queue}
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
 Namjae Jeon <linkinjeon@kernel.org>
References: <cover.1756139607.git.metze@samba.org>
 <2512d1dd03eec49674f317f9b78fc0bee60c2e60.1756139607.git.metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <2512d1dd03eec49674f317f9b78fc0bee60c2e60.1756139607.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 25.08.25 um 22:39 schrieb Stefan Metzmacher via samba-technical:
> This will be shared between client and server soon.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/common/smbdirect/smbdirect_socket.h | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
> index 79eb99ba984e..bfae68177e50 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.h
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.h
> @@ -54,6 +54,14 @@ struct smbdirect_socket {
>   			struct kmem_cache	*cache;
>   			mempool_t		*pool;
>   		} mem;
> +
> +		/*
> +		 * The state about posted/pending sends
> +		 */
> +		struct {
> +			atomic_t count;
> +			wait_queue_head_t wait_queue;

While doing the rebase on "smb: server: let smb_direct_writev() respect SMB_DIRECT_MAX_SEND_SGES"
I'll change 'pending.wait_queue' into 'pending.zero_wait_queue' to indicate it's woken
when count reached 0. And I'll add a 'pending.dec_wait_queue' in addition that is woken
when count is decremented. I realized that this in needed for the client changes in order
to avoid changing the logic for now.

metze




