Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D94423170
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 12:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768913658; cv=none; b=ZaOdYMR1a4FAGGpfROmR7nyd6DgghRtRdNVj4T4mQu0ffrIM0S4vUdsi5kyNUD95tKiBq8ie3hTbjdWENv/J+5DFk+Jy/rmz3QM3wv4+WPrNtd4m64RQ0hB4rQIF9Mtu82sn8sPkflBBNZZc7CncKUETL5E/MsRdtw/dmbrrLNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768913658; c=relaxed/simple;
	bh=vyeZL1FnH7ju2rMsh0p2OxV8dY6BFBjIJFjRtoaSiFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNd8c7Vcxq+J5TV5WjBjlI+3EIWM2c33n07RwZR9mR6SgrOe08WdO8TtObHn+w+mvOgCaHiHIeMiIKPnKNHrUEgIqKFFP/q8c3pQSvLtrLDDnSHVOQsZYoEMCVfykZKMz0NgnEubutTkG06/YfwFXLSORd+2WG58cq6uKUgdfbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XnOZn/OS; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XnOZn/OS"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47ee974e230so42861265e9.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 04:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768913654; x=1769518454; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NvtVi6bcE3dFbnkmEXkyFO/i+Tlc6JyIoYPcJZzXNhA=;
        b=XnOZn/OSElYJl86VJvgO7TospoAsIJwrRiXcFnFm7bqUTDqsPYN6NWA+1fBlxmQLWA
         F9HOPlw2PxXp/438OaWha3iixJceFHjVwNVRl7RjyIO/GrVbRBEzzdWbGDfN9+9nP9Qk
         +RAqRtW9SA2U2MzQfrhKVTI4f46/9atdYUjsw67eQqRkurfvzbURgQcmuFaDK92Jadg0
         fq3EfOpHTY8neWdio0ckWtIcteWkCFK73uoRKufhk/bgr0wi4l372GYhqx4Ky+lq1vU9
         oWWqguf43JTeT4tKlgllbAtdgaVH30jNLNli2zmLc4oW+gAPZS26cfTfwi5Dz9d6ysNn
         tQDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768913654; x=1769518454;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvtVi6bcE3dFbnkmEXkyFO/i+Tlc6JyIoYPcJZzXNhA=;
        b=RMjDE+H/q630it5a+pFZX7vpP5B7u/WrGwAjLCF8hTcUmi5+h0IVxOnMPsZL9Yt4qZ
         alckydMf6HF0fWsAsML0lAj8HuNE0c7lmJG0nifLoIklUVIkm2VX2f45snV9dVz7HvKa
         bHT/oatGG5vG4dYUTNiMnTgiZpzcnrNoFrVaAm+mGH6lKVfntj4+Y9qFqebc6padPTZA
         9wO47F/3xbUo2o2setb+eKv/2QVeixSpLClacciKC+wZBU0DTWMCQAjRTnfkUR0PzpFZ
         wGJYvslcpGG+hkc3lGVtXZvdM64F9+xZIlg90N/1Vfw2K/ED6Etj8eSgf/id+5MaXVTM
         iyug==
X-Forwarded-Encrypted: i=1; AJvYcCXG7icnTchZgIGc2KgmMixShlizfDxB7TVQDxaIqgRzz6GFPMJst8n9q7BmvMv5V/XV2x3aSkwd7SNR@vger.kernel.org
X-Gm-Message-State: AOJu0YyevP10DlmaOS9t+bdxa6eSy2imQ6cGSmzWqJ6l49mNo8t4jVal
	dS1LcifoetvDuxi0rG8XiUWNwlYmT64niEOj8XLvV2PaZMiTfKjU9AYAdIefbNav5VU=
X-Gm-Gg: AY/fxX5Bwefrab3YK1XcyJOT5vpeTLwNVmcYOBByFwAHwo4pajbK2Le2qfMnRrdqNzd
	X4VHTLqM247O+PqAaVSRTax/vW5eQmDUbOViL6spJKFqqOWGff1rgumdpVrBeLpVAiEOO9+lUgI
	Gc50GAEbPXYfFMtY0EyyJxdNHfFquFQUwBok05A/mMzmAubzDHRq5/xNvIe4vGLcBo8MXuwGImG
	8ORwiXJ/DWM/ZOC0jAAgY8pdjqOFCqztTlHrcSfQDojAqNTTXi9gHFA5d2I6Kf3tTp7iOp12U1t
	FsT9fDZRXRh6s/2ly/dZtbzWGIavrORrniIU4uWWeMRNp1yWGzSvsHAeisEgppflhiTdq6cVBS7
	K+ng8MeVPTgn+vcRCYbFiyypfbuE4LJ7loucaSgdS/IlAH9G3FJsJkfCue0H1BE9t2M5yJETFeX
	e03d0quLNtlusTVUIv
X-Received: by 2002:a05:600c:4fcb:b0:47a:7fd0:9eea with SMTP id 5b1f17b1804b1-4803e79b85fmr24911525e9.3.1768913654461;
        Tue, 20 Jan 2026 04:54:14 -0800 (PST)
Received: from precision ([177.115.49.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b365564csm17002640eec.27.2026.01.20.04.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 04:54:13 -0800 (PST)
Date: Tue, 20 Jan 2026 09:54:08 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: prevent races in ->query_interfaces()
Message-ID: <yigr6qjcd2i6dtbivgi2as6joezfzhystbjtc6wtybhqvupy5b@uuw32dyhtwaj>
References: <20260119175445.800228-1-henrique.carvalho@suse.com>
 <CANT5p=qBM7qWVDFimQ9xzNegWEysDaV3BcNsKESGsrSnwSS8ag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=qBM7qWVDFimQ9xzNegWEysDaV3BcNsKESGsrSnwSS8ag@mail.gmail.com>

On Tue, Jan 20, 2026 at 12:22:31PM +0530, Shyam Prasad N wrote:
> On Mon, Jan 19, 2026 at 11:25 PM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > It was possible for two query interface works to be concurrently trying
> > to update the interfaces.
> >
> > Prevent this by checking and updating iface_last_update under
> > iface_lock.
> >
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> >  fs/smb/client/smb2ops.c | 19 ++++++++-----------
> >  1 file changed, 8 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index c1aaf77e187b..edfd6a4e87e8 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> >         p = buf;
> >
> >         spin_lock(&ses->iface_lock);
> > -       /* do not query too frequently, this time with lock held */
> > -       if (ses->iface_last_update &&
> > -           time_before(jiffies, ses->iface_last_update +
> > -                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> > -               spin_unlock(&ses->iface_lock);
> > -               return 0;
> > -       }
> 
> I originally had this second check so that I could test it under
> iface_lock here. i.e. we do one check without the lock (in
> SMB3_request_interfaces) and another one here with the lock held.
> 

The idea is that we would use this check to exit the function earlier
with another thread since we would know that either the
ifaces were recently updated or they would still be updated.

Updating iface_last_update before the ioctl establishes a single-flight
guarantee for the polling interval.

Otherwise, we could have many tcon works queued and many ioctls executed
concurrently.

> >
> >         /*
> >          * Go through iface_list and mark them as inactive
> > @@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> >                                  "Empty network interface list returned by server %s\n",
> >                                  ses->server->hostname);
> >                 rc = -EOPNOTSUPP;
> > -               ses->iface_last_update = jiffies;
> >                 goto out;
> >         }
> >
> > @@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
> >              + sizeof(p->Next) && p->Next))
> >                 cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
> >
> > -       ses->iface_last_update = jiffies;
> > -
> 
> You are right to point that these updates do not happen with
> iface_lock held. I'd lean towards fixing this after the "out" label
> below (where the lock is actually held).
> 

So the reasoning for updating the iface_last_update above in
SMB3_request_interfaces is to allow another thread to exit earlier.

Fixing this after the out label would still allow multiple threads to
issue ioctls concurrently.

> >  out:
> >         /*
> >          * Go through the list again and put the inactive entries
> > @@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
> >         struct TCP_Server_Info *pserver;
> >
> >         /* do not query too frequently */
> > +       spin_lock(&ses->iface_lock);
> >         if (ses->iface_last_update &&
> >             time_before(jiffies, ses->iface_last_update +
> > -                       (SMB_INTERFACE_POLL_INTERVAL * HZ)))
> > +                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> > +               spin_unlock(&ses->iface_lock);
> >                 return 0;
> > +       }
> > +
> > +       ses->iface_last_update = jiffies;
> > +
> > +       spin_unlock(&ses->iface_lock);
> 
> The ioctl is still not done by this time. So there's a possibility of
> ioctl failing, yet we update iface_last_update.
> 

Yes, you're right.

This a matter of policy, should we fail in any ioctl failure or should
we allow some failures to not suffer time backoff?

If the latter is the case we could do:

+ } else if (rc != 0) { /* rc != -EOPNOTSUPP */
+ 	spin_lock(&ses->iface_lock);
+ 	ses->iface_last_update = 0;
+ 	spin_unlock(&ses->iface_lock);
+ 	goto out;
+ }

This allows for the next thread to access the SMB3_request_interfaces
and retry.


-- 
Henrique
SUSE Labs
