Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B512701D9
	for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 13:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769521077; cv=none; b=F6z4wx2pDN2gA2Wdaa4ccN5NVph7XOrVgw2TIjDRJ82Kz6zE42+FDwldHZqljMHCT03pc4ZjAyqXbG00VYcW+q980iMATOV2d7pT0N+FxN9cZ2oP5XCvN2VSkYLAW91e46GvTGNbq6o9Fy2gSKtb3iG6hR7roqz+qiceZw1FYho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769521077; c=relaxed/simple;
	bh=MITPSXyck+NhpxTrP7rp/alNFqZfdUEyivgfbcfuzn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sQjUxw3yvuhsCGwJLz9bCzliF1kL89cWGUTxkSGSWNdUS7qD7JdhlOhSssKMAny4rJ7yFExKOIuGTqAOWEgljCPaFWxu1Gocf0uRH8uQ8yjWm4LMMu6ESlIoYpIEm40UdMjK6Xg/Srh3b8oeKh7vS0zoTv967Dbxe4hE8vwkvxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VpLN1Pan; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VpLN1Pan"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4801c1ad878so63836145e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jan 2026 05:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769521074; x=1770125874; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lkNTHrNoQmO+WcwLexdO+4sjYa8XjM1a7/EMBoYe4WA=;
        b=VpLN1Panacfz5tOZeQu1HQPd8D1W88Mm6JfUZ82TCEWymsX1vPoOzZhusOWy2f72Uw
         WsVihgY3hOIbvlt+33+fglNibotHtTLsAWhzOSXwP4ScDQzfmkD3yLeBDnI6uboRdX0N
         OjDKEh0KJyFew79jdNPpwMIjK1Re0/s0NuOso1yDwIWN/idB7S02DVBGMtoDiDD3CSB5
         gYjGeU+Bf5gytT+QaJkyHMkVIAsQspUpSVwR3O3RwhK3zVX+vDfM7wOwSxnsHOgVs3/w
         A0xKhIMVNWgCOEnoHlROm8wYO6idrfR0faIW3mEMARe4rgbHJcUtfvpZCoDfanu7oBTj
         DbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769521074; x=1770125874;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lkNTHrNoQmO+WcwLexdO+4sjYa8XjM1a7/EMBoYe4WA=;
        b=Lxuhx2IylSFEoQNV0aMYOuROkZBdQKKXqM+gW8+UqmEAY7BfqUmvvo6SEE3z6fEprG
         hhKRpbXD5XhQU2z6HVNm652oGWjH2MS47VWX6qrAxl5qlzoJeZeWishjm97Vtw5rs8XT
         jjgHc4XGbCVHwSTtl3eBaGf4PwNcQKNK3AcAZCmvlRT05hmvMNWciPbGQ3GgQG964GB7
         ZRgJXOhoH/egA1sk5SRVSe2f9f/l0vakwktDquK3mkq775IPDdKCtjYOm9eKPvao5fmR
         BntxDjAb4bLVuxk9ndaATbLe9Wo9Q9eCnuqeH0gBF6qUf3U/o4T1X89r/9EiF8iUJxCB
         AG7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX48UKKbCxWS0m9mgImlnZV4FqnG8cKalDrEBxUD+zP1q+VOqPQ3ojII82N4+m14mK9DreX8xIGarLW@vger.kernel.org
X-Gm-Message-State: AOJu0YzhUjBwJAOAZOVTuNsIqVKe/6ydG6pcXnknRmVlwB/gszHXuTO8
	8CHlfXL16JTXCoA6reKZUPl2DFF/Ysg6D3OM8MMXz2HVX5rEjzaohdyMYXo6VfaZE5Yp3nsx/GH
	YjUXg
X-Gm-Gg: AZuq6aJg3Vq2ugX9aHnl19N+I2R8dwX62eJlfk+gNKncpyEdveFWh/ntRhvPwWn2XEM
	IolIJZVLrZZRZ0XArH7LxMsRRquCfsgzlqB3pYYGJCsRNmZzXcJ1MYo4mRgF0unwX5qAGf0hiwb
	ejNWmuG7TphWxN3bPGYHRCG37IaLUSOZSn4Vjq3eHsMnqQlUgT6dvMTvCxRCmrt3dkV1KbDllVp
	pdr/4FSGxh5CIqXVzvdgeiLB1H3lSn5ZlXFLHyCB6Vs3o73MGf0gADiaMboMAmyqarPQlqyHEsJ
	LOG7Imfon39rRzrnAY1NXd4VRbDZ8IRt5DjycyJY3b+eHC9tPD5vo/3weQz1t8c9StetFi1In6I
	vlqdZYri4Yx8awhpeq7ZmhlPoNu+q/1Ry3jw0jfk3rMo8pFSPtZy6y/Orcm0x9clyQ/9P3Qmoos
	QkFi6uyjGzjThV81WJuubYSy//dBH/KolzBsNU5vjQ6V5ChsuDdw==
X-Received: by 2002:a05:600c:608f:b0:480:1dc6:269c with SMTP id 5b1f17b1804b1-48069ca0c0amr20738225e9.37.1769521073609;
        Tue, 27 Jan 2026 05:37:53 -0800 (PST)
Received: from precision (189-69-92-103.dsl.telesp.net.br. [189.69.92.103])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1247d91c541sm22116785c88.7.2026.01.27.05.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 05:37:53 -0800 (PST)
Date: Tue, 27 Jan 2026 10:37:47 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: prevent races in ->query_interfaces()
Message-ID: <l63id7fg3pbp5qq7mvy2carztxacutezgwtv2faiclvtjdkdov@z3mjk6hktdu7>
References: <20260119175445.800228-1-henrique.carvalho@suse.com>
 <CANT5p=qBM7qWVDFimQ9xzNegWEysDaV3BcNsKESGsrSnwSS8ag@mail.gmail.com>
 <yigr6qjcd2i6dtbivgi2as6joezfzhystbjtc6wtybhqvupy5b@uuw32dyhtwaj>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yigr6qjcd2i6dtbivgi2as6joezfzhystbjtc6wtybhqvupy5b@uuw32dyhtwaj>

Hi Shyam,

On Tue, Jan 20, 2026 at 09:54:08AM -0300, Henrique Carvalho wrote:
> On Tue, Jan 20, 2026 at 12:22:31PM +0530, Shyam Prasad N wrote:
> > On Mon, Jan 19, 2026 at 11:25 PM Henrique Carvalho
> > <henrique.carvalho@suse.com> wrote:
> > >
> > > It was possible for two query interface works to be concurrently trying
> > > to update the interfaces.
> > >
> > > Prevent this by checking and updating iface_last_update under
> > > iface_lock.
> > >
> > > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > > ---
> > >  fs/smb/client/smb2ops.c | 19 ++++++++-----------
> > >  1 file changed, 8 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > > index c1aaf77e187b..edfd6a4e87e8 100644
> > > --- a/fs/smb/client/smb2ops.c
> > > +++ b/fs/smb/client/smb2ops.c
> > > @@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> > >         p = buf;
> > >
> > >         spin_lock(&ses->iface_lock);
> > > -       /* do not query too frequently, this time with lock held */
> > > -       if (ses->iface_last_update &&
> > > -           time_before(jiffies, ses->iface_last_update +
> > > -                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> > > -               spin_unlock(&ses->iface_lock);
> > > -               return 0;
> > > -       }
> > 
> > I originally had this second check so that I could test it under
> > iface_lock here. i.e. we do one check without the lock (in
> > SMB3_request_interfaces) and another one here with the lock held.
> > 
> 
> The idea is that we would use this check to exit the function earlier
> with another thread since we would know that either the
> ifaces were recently updated or they would still be updated.
> 
> Updating iface_last_update before the ioctl establishes a single-flight
> guarantee for the polling interval.
> 
> Otherwise, we could have many tcon works queued and many ioctls executed
> concurrently.
> 
> > >
> > >         /*
> > >          * Go through iface_list and mark them as inactive
> > > @@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> > >                                  "Empty network interface list returned by server %s\n",
> > >                                  ses->server->hostname);
> > >                 rc = -EOPNOTSUPP;
> > > -               ses->iface_last_update = jiffies;
> > >                 goto out;
> > >         }
> > >
> > > @@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> > >              + sizeof(p->Next) && p->Next))
> > >                 cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
> > >
> > > -       ses->iface_last_update = jiffies;
> > > -
> > 
> > You are right to point that these updates do not happen with
> > iface_lock held. I'd lean towards fixing this after the "out" label
> > below (where the lock is actually held).
> > 
> 
> So the reasoning for updating the iface_last_update above in
> SMB3_request_interfaces is to allow another thread to exit earlier.
> 
> Fixing this after the out label would still allow multiple threads to
> issue ioctls concurrently.
> 
> > >  out:
> > >         /*
> > >          * Go through the list again and put the inactive entries
> > > @@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
> > >         struct TCP_Server_Info *pserver;
> > >
> > >         /* do not query too frequently */
> > > +       spin_lock(&ses->iface_lock);
> > >         if (ses->iface_last_update &&
> > >             time_before(jiffies, ses->iface_last_update +
> > > -                       (SMB_INTERFACE_POLL_INTERVAL * HZ)))
> > > +                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> > > +               spin_unlock(&ses->iface_lock);
> > >                 return 0;
> > > +       }
> > > +
> > > +       ses->iface_last_update = jiffies;
> > > +
> > > +       spin_unlock(&ses->iface_lock);
> > 
> > The ioctl is still not done by this time. So there's a possibility of
> > ioctl failing, yet we update iface_last_update.
> > 
> 
> Yes, you're right.
> 
> This a matter of policy, should we fail in any ioctl failure or should
> we allow some failures to not suffer time backoff?
> 
> If the latter is the case we could do:
> 
> + } else if (rc != 0) { /* rc != -EOPNOTSUPP */
> + 	spin_lock(&ses->iface_lock);
> + 	ses->iface_last_update = 0;
> + 	spin_unlock(&ses->iface_lock);
> + 	goto out;
> + }
> 
> This allows for the next thread to access the SMB3_request_interfaces
> and retry.
> 
>

Do you have any comments about this? Should I send a v2 with this last
suggestion on resetting the iface_last_update?

-- 
Henrique
SUSE Labs
