Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4E12FE071
	for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771607480; cv=none; b=eE2M1JxQGhnofzZCJYbmijd18lBYX6P31fPyp21LC5agDaqDrFl/h7KomMGRhTNT3VwhYVW5dfNKGEb8x25hVdJTDpAvpEAQAmjB9CmtaEprvApqBg4zzUXfRu3mmUvFSrGvWNfqgCu3lIYfw4VTOKy9RpTXc9HTYNf8W7lq9x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771607480; c=relaxed/simple;
	bh=kffGaYuZ9MruzAgsSsh632aqdCkCe47CxBvWKnnHLOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdCYYUHbYa2BvYCPredpz102D8CWGbJJPI7URnL8n1XVlp9Rc7BaN+tSCRCM97UZDofoQq3F8XAcBArF1wlVRz4m/GWsqk9c3/zR+8ZnHg/pmtedi5Z0XiTxicTu/33zVragj+g20fxlKBuweSUWa2G8U7xc1l3GgwtxDP3UJGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XEu5Nhr/; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XEu5Nhr/"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4834826e5a0so26366335e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 09:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771607477; x=1772212277; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xoEag7aBsaRik/U/nolAKNI6lGv7n3e+JnHGR3OINQ0=;
        b=XEu5Nhr/8nf0tUTbq2N+OQGNLGwxbTrS6W2f5Q81I/bBuiBKCPlPyeuh+B93r2xO4d
         872p33d4rzUBO7Ta5PccmvkcThcvjP2OtWUPq8rt6CISPwNp7oAoUV2A5IeFmcSK647n
         5wT8YAX7zdh+9+ySdQg4TKivbBAcK8e/pvfyM80eYxxZH8FEbkFxUOmY5ep135XfsXki
         SHeIoNInKl3HK0mEH8r9JwTAST4uSBDC26fPlaWLgGJ33aVb/FoclXma5edlmXmIF2BL
         xhcutnfNIoeVAZdTlWuaBCoGCwrNhO3t3s47nEaR/XvS+spt08OOkVgPed69OT2fhlue
         CerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771607477; x=1772212277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xoEag7aBsaRik/U/nolAKNI6lGv7n3e+JnHGR3OINQ0=;
        b=Ua7v39OO+YjbWqaBKmkcUTJqaYfQ3sT9iai06zIL3dURk89zrW+5Dk0UTxc5yPuP1o
         Qdhgd4ymP1JV9FLdTUJzMfdC0C6d2e8TuL5ObibAxLojSnW8LvcOAhyznOSLNgpBwvxZ
         IpJU/ebicatgnXK/doiOn9B0FdTpw1OEjXaj9Z3dGnIn8RGjlnf+cJLmIbBgXDLJTbSY
         C8bbVUbGXCZd73ZpuDprEr+p9YnTsUxt3xuoemkWDV4JnE8ZDDCeZ6nyikVHd8mqqNFd
         KyUou/TWFYSLg4XqF00qkSJU3Sdm7gQMT8cF8qZH/4EruuJmqEjnKT8YplcvKfKgHg8T
         zlaA==
X-Forwarded-Encrypted: i=1; AJvYcCW9uHKi37hZ/MYqaqCAp01zDzaHRCIyta65bnSbNdIr0p9gKS6ZrbOsPp245YpGHvI4zjpCExFQ2+cd@vger.kernel.org
X-Gm-Message-State: AOJu0YzDjWvb3TaD6sUT81jrLW29E5jFbUUNBh3cbJbOU+u8+3FB2BvO
	UHTFfER3On5QRV2DasKf5s6jTyAApGoNSqxbcUjcauH5qD22FnA9vT7VzWcFITDUeYM=
X-Gm-Gg: AZuq6aLJKpQDUl82zK32XZdInoz1I4YHSna/3+452ocAnmvfkFjX8Mucs1TgM+ihyZa
	yoW7k9aDDiv+hiF4BBffksJWvnTxKMuyjNwP74l2hn+79lw+35+yiAlHw23z/D6qpfrkjSK/P9N
	YkumV0ABVy5Z5tHpyrEnOT1KeZ4NfqldvYk/3S7BStmfc3z1ZWEECxOGbRkiRr682CoHlvFebfV
	0wZAnDWzeuCiZ09T84hh4vQe0L4kNEwAiAWUtxqS102z3TGr1tq9LkluvbJCnHmjmG4d6/a/usr
	YsZMetkzte8xE0YY3yqqS08Ascf77xg7x9vh00V4xE9g1G1a1X5DYCIwZDv3r1jfupNg2X/r6/O
	s884E5/T7UAKR/Nbx6tZEbA8kmk9TjG5y6hBJxD2fuZjRirSR31CkytDqbkEsdTFkMqdFUhRqH5
	2gT4MTpZ1gkJcO4fa7x8+MwYbs2YJP14jsZnZW+zU2
X-Received: by 2002:a05:600c:4f94:b0:482:eec4:74c with SMTP id 5b1f17b1804b1-483a95e9562mr3827105e9.22.1771607476847;
        Fri, 20 Feb 2026 09:11:16 -0800 (PST)
Received: from precision ([179.82.226.246])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94afd3b76bfsm17023299241.14.2026.02.20.09.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 09:11:16 -0800 (PST)
Date: Fri, 20 Feb 2026 14:11:11 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: sfrench@samba.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix cifs_pick_channel when channels are
 equally loaded
Message-ID: <gnuog4zeyutlzbvzzp37gsotfjdlihnnfiabd5hcz7gffevwwj@xlvjaj2i5qkt>
References: <20260120201822.2218308-1-henrique.carvalho@suse.com>
 <180ef3d4933495c273eea31e09243130@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <180ef3d4933495c273eea31e09243130@manguebit.org>

On Fri, Feb 20, 2026 at 01:21:03PM -0300, Paulo Alcantara wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> 
> > cifs_pick_channel uses (start % chan_count) when channels are equally
> > loaded, but that can return a channel that failed the eligibility
> > checks.
> >
> > Drop the fallback and return the scan-selected channel instead. If none
> > is eligible, keep the existing behavior of using the primary channel.
> >
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/transport.c | 17 +++++++++--------
> >  1 file changed, 9 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
> > index 75697f6d2566..26987f261850 100644
> > --- a/fs/smb/client/transport.c
> > +++ b/fs/smb/client/transport.c
> > @@ -807,11 +807,16 @@ cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
> >  }
> >  
> >  /*
> > - * Return a channel (master if none) of @ses that can be used to send
> > - * regular requests.
> > + * cifs_pick_channel - pick an eligible channel for network operations
> >   *
> > - * If we are currently binding a new channel (negprot/sess.setup),
> > - * return the new incomplete channel.
> > + * @ses: session reference
> > + *
> > + * Select an eligible channel (not terminating and not marked as needing
> > + * reconnect), preferring the least loaded one. If no eligible channel is
> > + * found, fall back to the primary channel (index 0).
> > + *
> > + * Return: TCP_Server_Info pointer for the chosen channel, or NULL if @ses is
> > + * NULL.
> >   */
> >  struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
> >  {
> > @@ -850,10 +855,6 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
> >  			max_in_flight = server->in_flight;
> >  	}
> >  
> > -	/* if all channels are equally loaded, fall back to round-robin */
> > -	if (min_in_flight == max_in_flight)
> > -		index = (uint)start % ses->chan_count;
> > -
> 
> After removing the check, @max_in_flight is no longer neeeded.
> 
> Otherwise, looks good.

Thanks!

Will send a v2.
