Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71182E0938
	for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 16:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771605515; cv=none; b=H86Z4tvyuxNfjnFLRc0+GnLUCKDzue/ndYyujl9GN4h11Fz50zo7l4/1xb1UPTyE61DwUPHxYIQK66Mr5OPsUoMntmkzGB2vFbIALgzNBIekvicqnKcWp2+jZfK98UX1OwcOMnigkqjVVrpmPGjsOVAlYh+NYP9r8CQPmkbhJX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771605515; c=relaxed/simple;
	bh=2d5vQ9RmdamSCEiZk5c5SbTeL6QnnOM/+o3tMg3BfMY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=qF+s/uXre7kc9cXVO6F2jsGMI2RNUt7ef+a+uAmJvPMJmIYbyrQfbCjZ7rjlUYq8bqUifICSwtulnFeR3uEQNUrt/BBtlEUpgKzudOHHEGtfM6El+cYff8uVUqAKmmnAOY3xhzjnd26cJoyWmNxuyEU5LNsUjQ/XOjxP17zYCEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=yPbcsnsT; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="yPbcsnsT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=YDGBsTef0g84aPlc42L0PS7/k4rchBrxHshugP8eedM=; b=yPbcsnsT81Hv94eyyAMBjQHsQl
	Mq8A/5jg5nZsWmNwW8QH8kn7kPAN2qU0Z8WggOQkL/FKprGIkzPHUbBLNO9JJ0iEFYw9Y4WIPkB1+
	PnvC4imdAsxuoDHdgH8nnPk7LMCugCnz2ADMe/io2/Gm8UHbMk5bbsgsvel7NStHq4CZ5oBqKJ+CR
	cjC2mUpIrlVHdt02iyndLyjvFI+aBw/kTFGC1Hf2Z3JDnGd7Nh08u6eYfMbeb2l5dqI1r3Ni2tZis
	TlCQMt9rT5B6QbQH30mUERouTZU+HIbK3IdY82YjH21bYcTGt7i1xHxJ2Zl1LyQe4qkoOKqSAkIS0
	Z1RIgTNQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vtTFX-00000000Uqg-32pV;
	Fri, 20 Feb 2026 13:21:03 -0300
Message-ID: <180ef3d4933495c273eea31e09243130@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org
Cc: ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channels are
 equally loaded
In-Reply-To: <20260120201822.2218308-1-henrique.carvalho@suse.com>
References: <20260120201822.2218308-1-henrique.carvalho@suse.com>
Date: Fri, 20 Feb 2026 13:21:03 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> cifs_pick_channel uses (start % chan_count) when channels are equally
> loaded, but that can return a channel that failed the eligibility
> checks.
>
> Drop the fallback and return the scan-selected channel instead. If none
> is eligible, keep the existing behavior of using the primary channel.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/transport.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> index 75697f6d2566..26987f261850 100644
> --- a/fs/smb/client/transport.c
> +++ b/fs/smb/client/transport.c
> @@ -807,11 +807,16 @@ cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>  }
>  
>  /*
> - * Return a channel (master if none) of @ses that can be used to send
> - * regular requests.
> + * cifs_pick_channel - pick an eligible channel for network operations
>   *
> - * If we are currently binding a new channel (negprot/sess.setup),
> - * return the new incomplete channel.
> + * @ses: session reference
> + *
> + * Select an eligible channel (not terminating and not marked as needing
> + * reconnect), preferring the least loaded one. If no eligible channel is
> + * found, fall back to the primary channel (index 0).
> + *
> + * Return: TCP_Server_Info pointer for the chosen channel, or NULL if @ses is
> + * NULL.
>   */
>  struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
>  {
> @@ -850,10 +855,6 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
>  			max_in_flight = server->in_flight;
>  	}
>  
> -	/* if all channels are equally loaded, fall back to round-robin */
> -	if (min_in_flight == max_in_flight)
> -		index = (uint)start % ses->chan_count;
> -

After removing the check, @max_in_flight is no longer neeeded.

Otherwise, looks good.
