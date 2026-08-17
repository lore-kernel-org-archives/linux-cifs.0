Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0F246D2CE
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 18:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786992102; cv=none; b=dxTShCg+EU8OKfBvDTM/vyvNzcwYA3XCXXVypTqQxUvHEoN9tZZrVwkl+oGesw4ljNfX9Byda5HZusrC3RPMy48u4jxkEiHBHKTDELspiFB8ikDj9Ra+V3Lut08cP3TnMPIoAjQIPlza7/43N8nibpx4oNaToKGfnFytmQbU6m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786992102; c=relaxed/simple;
	bh=0hn3MsFTxaWHs9kX8O8U/5Rgm6ADJ3UWztsNQ0gfQ2M=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=s5NW7OSvnSIik5clo0Kfq4JPOsh/n63VrWVk9VezrDoBf5h79zTs9+wFdhpABuRd9AeHDrUoUGSYmrTDcRqtcrD+kfe+aKa/JKHPqZ2WUpMs2r5LtgarrSfSKRL9qqVb6Qhukq+R4CbohrTQmPZhgKZ4QmNSB48Q53n+kGMwcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LqZE4lOj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YmOvygcf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LqZE4lOj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YmOvygcf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786992099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1f7MnS/DbKFV+HvG7L8VJ09Y737/X7x2nbUREKrcEU=;
	b=LqZE4lOjumpDU/ct1LJdfnF5Z5aPNO7/i4wmjdYSXy0A1W6nynbAkhkmNnHZDxVhMOBASr
	dXtLPSgxx1Ic1hCPX+lpyqYg+5ws/Y1M4gtARH3cgiVwwUx/+ANStsuUZrNI3WljTIBYBF
	FT9ZWNI9P7C+B0N0nlf0kjrzSPxCkoc=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-YQXRfAqQN_WgCypefgbsRg-1; Mon, 17 Aug 2026 14:41:37 -0400
X-MC-Unique: YQXRfAqQN_WgCypefgbsRg-1
X-Mimecast-MFC-AGG-ID: YQXRfAqQN_WgCypefgbsRg_1786992097
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a17baa4d18so1073495eaf.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 11:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786992097; x=1787596897; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=N1f7MnS/DbKFV+HvG7L8VJ09Y737/X7x2nbUREKrcEU=;
        b=YmOvygcfWBtBeAaJ6DpktHQHgjH6qL/NPA2ath0Adj3CgY99qNBjzNppwghV81vy+W
         L46tCUflMWMNP2xKJrwe8039R4XIMAY2/2ySWWxtRCKhefU83U9RyvPgtbgF1MBF47wK
         OaMWZW+P3mJY90FfrWJa5bc38Dn59YOiwOTBkwhhk/JYxWefZjvbOkRUMcF0Fh+kVjTD
         lhbUpjdWZGC8uYJ1Xdvn/zw3kG6/8y380QJn2RjAJ1L3/mseiTfvC0bFXjcg6HTuY56W
         kooVDnNJTPWAs+eBXAZlduL9176ijOfccv869r0kpPQofCi2bz3TCeEUl38oO8r/9eid
         yrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786992097; x=1787596897;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=N1f7MnS/DbKFV+HvG7L8VJ09Y737/X7x2nbUREKrcEU=;
        b=UHWO3A+JznHypYa/iHcYTi952K31GzmgMS4xnvy38Ma69GGOUMFkNM7PiTPFj3iuRl
         1Gvmzc8avqn8z+CY+hxzee8e+Vsp+dt4D5+JbUfai1qWTsrFkvLXOc4VGAPuIPaI0k8Z
         krPx2og/d0NtZD8HhbahEvzoSaiKfs+sUK1mT8tP4R7IEukZCMoOeHhHIEi/3zHYcdcf
         strT4sVWUTx7ICwmMGnv/2vb9GIEOnFxz2NtyqkbRV8PFdkr+7M8F9ZIDXMDQ7XmoUBC
         lfoB5MOwUfRuI/2UDlbb2OG2dt+48m4vkg1WjBtFOTALQT9gACG1h9EqGEvEZ9LVMa51
         RT+Q==
X-Gm-Message-State: AOJu0Yz6h2vs0/+bvLGqErBpmdRYfGsDFNQjKaKL6LU6QidMCowO4bc0
	Tjg6EzkXZUNcUqShPOFQy5/kdkekchnNKCCcqWH9aOJaX3M1yAzrMjG2jyPJkm6k58PV6fKE7na
	/nm8nGt7XAOzWoGZL0iG2xO+y7rTGB3r7aRcKKh0WQBQ4fx2CokFXV5Kq8bM5oXYOXI6VHCdw/X
	W6O9+KK17D7Of9DW5olh9yM9qwztp/cTnce4E5h9b4aeNVqaM=
X-Gm-Gg: AR+sD12JD1UYovkOsulLeuMyel2umuomRKw+4HFraOlEP7qObhXj0/pDp2skOEc8bvp
	KH48bHKdyXq8nJaoTlfbgjY+kTWEevCfBgWdyl9p0rrMYftigJiFLQG4lvxi4V/onfqimBQmLCK
	z9/s6ZrL6tHMDzrh1WCtGzGFGjmpNMjwVQzFG4midA8/8n6A0vhqqeh5xN+DS3/Ji38veP5FvbM
	92b26HNlXqiXgQrZzRoyGwVn0h0+ZDOTjbh69GP0QrQ94TYHoLyrmvkIwe7Zo8egwFCNCUMu848
	eVtw3YlCH8ft+4YLtvY3YceOQXLplhWvcLJFjCHkPT+QwQ41UGcTy5TyYcMW+N/oBdvhAs5Wanj
	/fvbAJBd5lVJThYC4s6n+IaCp0qAtlnhUhGFzTST1
X-Received: by 2002:a05:6820:1c8a:b0:6b0:f389:da5a with SMTP id 006d021491bc7-6b11dd3244amr2367503eaf.8.1786992096922;
        Mon, 17 Aug 2026 11:41:36 -0700 (PDT)
X-Received: by 2002:a05:6820:1c8a:b0:6b0:f389:da5a with SMTP id 006d021491bc7-6b11dd3244amr2367453eaf.8.1786992096313;
        Mon, 17 Aug 2026 11:41:36 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41bcffb48sm2197903a34.0.2026.08.17.11.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 11:41:35 -0700 (PDT)
Message-ID: <92add2b2-825a-4f1f-ab43-9105106daf74@redhat.com>
Date: Mon, 17 Aug 2026 13:41:34 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: reject lease breaks with reserved
 NewLeaseState bits set
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, stfrench@microsoft.com
References: <20260817171634.212571-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260817171634.212571-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On this one, Sashiko calls attention to a potential problem...

On 8/17/26 12:16 PM, Frank Sorenson wrote:
> smb2_tcon_has_lease() and smb2_tcon_find_pending_open_lease() assign the
> server-supplied __le32 NewLeaseState field directly to a __u8 local
> variable, silently dropping bits 8-31.  Valid SMB2 lease-state values use
> only the lower three bits (READ_CACHING=0x01, HANDLE_CACHING=0x02,
> WRITE_CACHING=0x04); a server that sets reserved upper bits would have
> those bits silently discarded, causing the client to record an incorrect
> lease state and potentially miss cache invalidations.
>
> Decode NewLeaseState to a u32 first and reject the response if any
> reserved bits are set before narrowing to __u8.

> -	lease_state = le32_to_cpu(rsp->NewLeaseState);
> +	ls = le32_to_cpu(rsp->NewLeaseState);
> +	if (ls & ~(SMB2_LEASE_READ_CACHING_HE | SMB2_LEASE_HANDLE_CACHING_HE |
> +		   SMB2_LEASE_WRITE_CACHING_HE)) {
> +		cifs_dbg(VFS | ONCE, "%s: invalid NewLeaseState 0x%x\n",
> +			 __func__, ls);
> +		return false;

 From Sashiko:
======================
If we return false here, will the demultiplex thread in receive_fd()
treat this lease break as an unknown frame and drop it without sending
an acknowledgment?
Looking at the caller smb2_is_valid_lease_break(), returning false causes
the packet to fall through to the unhandled frame path in receive_fd():
fs/smb/client/connect.c:receive_fd() {
     ...
     } else {
         cifs_server_dbg(VFS, "No task to wake, unknown frame received! ...
         cifs_dump_mem("Received Data is: ", bufs[i], ...
     }
     ...
}
Since the packet is dropped entirely, does this mean the client never
downgrades its lease and never sends the required lease break acknowledgment
to the server?
Could this lead to a split-brain scenario where the server forcefully 
revokes
the lease after a timeout and grants access to other clients, while this
client incorrectly assumes it still holds the caching lease?
Would it be safer to mask out the invalid bits and process the valid ones,
or downgrade the lease to SMB2_LEASE_NONE (0) and acknowledge it, rather
than completely dropping the protocol message?

========================

There's a similar complaint later as well...


I can resend with either masking out the invalid bits or downgrading the 
lease...  Masking off the invalid bits makes the most sense to me.  
What's the preference?


> +	}
> +	lease_state = (__u8)ls;
>   
>   	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>   		cinode = CIFS_I(d_inode(cfile->dentry));
> @@ -609,11 +617,20 @@ static struct cifs_pending_open *
>   smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
>   				  struct smb2_lease_break *rsp)
>   {
> -	__u8 lease_state = le32_to_cpu(rsp->NewLeaseState);
> +	u32 ls = le32_to_cpu(rsp->NewLeaseState);
>   	int ack_req = le32_to_cpu(rsp->Flags &
>   				  SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);
>   	struct cifs_pending_open *open;
>   	struct cifs_pending_open *found = NULL;
> +	__u8 lease_state;
> +
> +	if (ls & ~(SMB2_LEASE_READ_CACHING_HE | SMB2_LEASE_HANDLE_CACHING_HE |
> +		   SMB2_LEASE_WRITE_CACHING_HE)) {
> +		cifs_dbg(VFS | ONCE, "%s: invalid NewLeaseState 0x%x\n",
> +			 __func__, ls);
> +		return NULL;

sashiko again

Does this validation logic successfully reject invalid lease breaks for
cached directories?
If this function and smb2_tcon_has_lease() both fail to find or reject the
lease (returning NULL and false respectively), the caller
smb2_is_valid_lease_break() falls through to check cached directories:
fs/smb/client/smb2misc.c:smb2_is_valid_lease_break() {
     ...
     if (smb2_tcon_has_lease(tcon, rsp)) {
         ...
     }
     open = smb2_tcon_find_pending_open_lease(tcon, rsp);
     if (open) {
         ...
     }
     if (cached_dir_lease_break(tcon, rsp->LeaseKey)) {
         spin_unlock(&cifs_tcp_ses_lock);
         return true;
     }
     ...
}
Since cached_dir_lease_break() does not check NewLeaseState and simply
drops the lease if the key matches, will an invalid lease break directed
at a cached directory bypass the new rejection checks and be successfully
processed?
Should the validation be placed at the top of smb2_is_valid_lease_break()
to consistently cover all lease types?
=============================




> +	}
> +	lease_state = (__u8)ls;
>   
>   	list_for_each_entry(open, &tcon->pending_opens, olist) {
>   		if (memcmp(open->lease_key, rsp->LeaseKey,



-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

