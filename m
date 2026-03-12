Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F493B6372
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 15:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327793; cv=none; b=aX6cEEsjOznUOLT2g7I9rmCgtOL5mpP54vTNi4+TCsh0WI+aTzrUpHMqDuVvfU63vykh8M4yAPkxS0T/mjB7yYbpmS2ScY4uK5T1usJ+zBa+q21DcltmYrOwn7RiuXdOJVRLdgnsZMlCt/XxyftDRyJ58LNB2JpGwaH2nn/4KuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327793; c=relaxed/simple;
	bh=gLc30Z+9vOBzkAprgy+ZzWzCvuoZOmSPjY+GSFBC7K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SsADpAcR50lQL6ESSak918Dw+TsnwKJO+4Xjyclr1gvzyDQYqB2PqSA8Wu7Acwn2xBGXXOzNFbQuPdy56YEGYxwwYBfRmjQAIcmsSgZLQG8hz9fZIyrsuSckVrOw8QC4fUNTS57Y/iP/uxvWefzu7s1kWrgAbrP4AsCKtmdJJes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=flePT0fZ; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="flePT0fZ"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-38a3f6da741so8384431fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 08:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773327790; x=1773932590; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w3Z0IgmvA6IrttCl9VcQbxLY4PbNB0saZqQGQHabijM=;
        b=flePT0fZwNRQZgW0P20rS0ZrbwqUg2FA3zQeyaNol8OO4Uc6VcGbF8CVpt2XenjcAS
         i+OY7I79ylP8WvZPCEYZKgf/HiMOC2K/v49hAa3wr9C0kICVdAE3W39H5nSvRzKud8Ep
         y54+2Pmf1Olbdd0IL4HRmvN9Zne7LfH2ZmcCDSYeD7lxadyIgcPsKxeTyC1CCjoFOoty
         wjj5WYkG6voM3QO/sL+lOQ16VaIuW0peXqhZTxDaoPTCHRNl9WH2m18iZJVGa046WVnf
         yqRFozLGSZrge0IrnMmPXMB6cRwl0hC6OfsZRpxT8B3N6brUHCmSYkUMTbcJo1xtXnGc
         TcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773327790; x=1773932590;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w3Z0IgmvA6IrttCl9VcQbxLY4PbNB0saZqQGQHabijM=;
        b=OP/Od+ldXVTZ31WoyTm20O9C67UAzhFHrYcbR8TWTOAskN4b5f/YIfeY3m08IssGVW
         g+xtXctchaXssPVhTU/5Ns+jTPe++PVMPAGJMd7GFgOXV9WShjl1SeiGzwQYgFmWWvMD
         1/QYalaFw2PneAql7/TVFGQbJG3AdQdiybdgYxMlf5FEBYJ6q8KkoZQk9UBLqYIeZhAM
         NlNH21vhcgzTlqnUig06yub6fz1Z1P2uO3tJZTaHGSnwlTZKJcQAvazqkyd3mIgN0Fm/
         ExXJuAv9BouP41EB6aBuo9KVPEFuFdC/+EnKl6iRU3/F8NYbu003K64LhFzyT4NIYWKV
         7HWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBSdcUoPHkoB+GAImwLORdjQHZJmkTX/UB/PSuXkzzsEVm9dxOJCw8E3qKTAWw+QyGkNED7vUMLMVk@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/TtY/xp7mU7L3RRZG6w1PvcWN1jcOR4r+M7++mfMo+MZPveVB
	AKFlRAaO+GfSZoEjKG8cqNlArJFH+ef02Lp8LHdPC341hAsOaoEtSwiduqbIQex4Tj4=
X-Gm-Gg: ATEYQzyPT+afwzkagpntNJc8r2IYBIYDaozQIRgruWCBkXufnTDmh0/fvasUDWOZ1E+
	PcxWmkBaH7utkx50lzlPGKr5um4ys2KVOxiFra596K26TyRTuis5GYZtB/3VQxQJRb2HgFBHY2S
	EzVFS9U/BJhjCgR5nKFeFv2a1lepRyOqhmfcKfFoVc4LPJBa9ijyLorX+etAN3vdgtlNtFYpg9H
	3rEZbegOzgieKW4HwYj6BL3tB0CyQ2nlB66ofpbNTaeMuBXl+CJ2ptnOsJ8UxVY+7oiWndDLCSH
	B/rftfK3XXg+LtQ7ildYZaTqbr6IO+coK1oUc658MWt13uQrL1/ahIdkcKphS3Ng9n3VrtACwhf
	atMMqwXtDDj7ViSmD3/eAoaTthNB/yDLkoosBIbec9uw5/gIh2Na0CDYW90wnWC31g/kZN7HPHX
	UI1vYlfGcB2IGVjGEJjfEwHs/ulImUjuTTJR5WIKmJbtJKlOsdotGZc98=
X-Received: by 2002:a05:651c:2102:b0:38a:45f8:6270 with SMTP id 38308e7fff4ca-38a67e1aa9cmr23403431fa.21.1773327787720;
        Thu, 12 Mar 2026 08:03:07 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be8aa7492dsm6507324eec.29.2026.03.12.08.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 08:03:06 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:03:01 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>, 
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <42utcrhajix2x3feckj7ap373osq65sgfz6ximnaj4rasszret@ymhf44ddz2wh>
References: <20260310235642.6d9798f4@plasteblaster>
 <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
 <CANT5p=q2Lv4pSvEm5EWcM73b7NZsbt1kYEFJtjaAZRS6Gz_OjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=q2Lv4pSvEm5EWcM73b7NZsbt1kYEFJtjaAZRS6Gz_OjQ@mail.gmail.com>

On Thu, Mar 12, 2026 at 05:44:58AM +0530, Shyam Prasad N wrote:
> On Wed, Mar 11, 2026 at 7:37 AM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > On Tue, Mar 10, 2026 at 11:56:42PM +0100, Dr. Thomas Orgis wrote:
> > > Dear Linux-CIFS maintainer(s),
> > >
> > > I stumbled upon a regression in the Linux cifs/smb3 client when working
> > > with a smbd using a non-standard port. I am not the first to note this, see
> > >
> > >       https://bbs.archlinux.org/viewtopic.php?id=306712
> > >
> > > which is a report from mid last year, indicating the problem sometime
> > > after Linux 6.6.72. It is a very simple issue, where details of the
> > > kernel builds or mount setup don't seem to matter much: Older kernels
> > > reconnect to a SMB server that was restarted (old processes killed and
> > > replaced), newer kernels do not and just have a defunct mount.
> > >
> > > I reproduced this in our HPC cluster environment with such smb.conf on
> > > the server side
> > >
> > > [global]
> > > security = user
> > > map to guest = Bad Password
> > > server role = standalone server
> > > smb ports = 1445
> > >
> > > [public]
> > > path = /some/path
> > > guest ok = yes
> > > read only = yes
> > >
> > > and such a mount command on the client:
> > >
> > > mount -t smb3 -o port=1445,user=guest,password=foo //server/public dir
> > >
> > > When I kill and re-start smbd on the server, older client kernels
> > > reconnect and continue to return listings and files from the share,
> > > while newer kernels give this:
> > >
> >
> > My suspicion is that the regression was introduced by:
> >
> >     5713127da855 ("cifs: update dstaddr whenever channel iface is updated")
> >
> > That change causes parse_server_interfaces() -- should this be running
> > without multichannel mount option? -- to overwrite the port stored in
> > server->dstaddr with CIFS_PORT.
> >
> > The attached patch preserves the existing port from server->dstaddr.
> >
> > Note that I have not yet tested this patch or confirmed the regression
> > with a bisect. If you can't, I will try to do that tomorrow.
> >
> > --
> > Henrique
> > SUSE Labs
> 
> Hi Henrique,
> 
> AFAIK, the ignoring of port from the results was by design and part of
> the original code back in 2018:
> CIFS: parse and store info on iface queries
> 
> Also, the comment in the code just above says why this is so.
> [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these
> 
> I checked this section and it says:
> Port (2 bytes): This field MUST NOT be used and MUST be reserved. The
> server SHOULD set this field to zero, and the client MUST ignore it on
> receipt.
> 
> Based on the conversations here, it looks like smbd ignores this.
> 
> I think the right fix would be to make sure that
> cifs_chan_update_iface gets called only for secondary channels. That
> way, it will not get called for single channel scenarios.

Sure, I read the comment in the code and the MS-SMB2 protocol. The
protocol states that "client MUST ignore [Port] on receipt". Since we
are not using p->Port, I don'se see how this is a protocol violation.

We're using the port that was selected on mount and copied over to
server->dstaddr, so that when server->dstaddr is overwridden,
server->dstaddr keeps the user selected port.

Now, even if we only fix that for primary channels, the secondary
channels will still get the wrong port when they are overwridden, no? So
I don't see how that fixes the issue.

Apologies if I'm missing something.

Best regards,

-- 
Henrique
SUSE Labs
