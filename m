Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AE715383D;
	Fri, 13 Dec 2024 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734105220; cv=none; b=GnnLbwjG2BARp9t4f0PrSVMAiSpIVsBMV42uS9Z/xLTpBXicqGXmkMvmg9YtmYGXzFLE1QZvZlpKqe+u3r0HLYOfpbseY1qSO6rh667DXqxbGjYO97SD25oYEanQNcGeAtAaPiVeLau1TduiVJp5inHqQ49zkkPrBH2IcivQgu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734105220; c=relaxed/simple;
	bh=mOvHkMa1klms9zwmGi+zeiumaiMREKkxuAOwzOiS/i0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QiGP3K/2SQQCuk55hcM8HtoTCnDe7F29Y2M580INhct6rYd5SwHAiz8H6Mg12v3+BoRmOaMX2OkGbeAFcyl5uHBR2ejMKtnpK2pLiGXPGYB5NiI78t/KkuibV8Og1XQWrfM5PRwMjaH1w33dTAPOgR64mmxye+rVGUTslVjyMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hkkybmtz; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hkkybmtz"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-aa67ac42819so315451566b.0;
        Fri, 13 Dec 2024 07:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734105217; x=1734710017; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEUXvu3WplUGAImvLKR5ANM1lkKlhji+jjNGMmfuG90=;
        b=hkkybmtzd4y59Dd1vGRe9F6GU/SuW43FbfzEH6Vf5+OMo7bvufJcatL0iddD7sbq27
         aPs2lzha/9vaU0dpRj+8ur6jSt/Ki1AeSRKWTt9dj+2kUUR6hYddqR36s/xy9Equ/Xco
         hRD67IN95JAmsWyw47G+8WYufVyzxfHItogBzCcnQU7J1mhKz/RLzt69MdB4n659VAML
         7tNuyzdCk0E7+9qh7YZuZuhHMs0uD7brHt+zjNYVzWh45BHBQkaFZS0wKZtdR90qvHQw
         N0qQi6hnRGXghkW7uwa/Vu4K2sch91ZJEOHkQ/2PLavTkNf8gl4m8trRNnviJjGiw2tg
         FZSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734105217; x=1734710017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cEUXvu3WplUGAImvLKR5ANM1lkKlhji+jjNGMmfuG90=;
        b=Llx1MDtZB003HfV0/bIrqDgcagHCld8QtjG63lIZicEmuaDaZf1H5RCSR5nBvg5LwG
         RxeXiXf1H3o0lzl06WCPRYj4q46pHyT/NgDlPGujHDdgpKF6yF7XSgSxvJcBDyBPoMnN
         DgifTMtgTd/qH4H3dVuBBO/YbaKTOJdoV3vWQPdtQdHve66vktLosAsEU+3irj1rdzgN
         IkQ7aPPbc6plw5BIFfVKcGS1zGSkOUKGjgK5qxHjvP0s/btmzdoDo2G1wEnTRsklyL1E
         QocRvkx+xJVdX6y0vo3nUVXFfYUuatla1niAN80Kq745EBgT1cK+PS3VqV2LwIM9yYcE
         EKDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWf4sAUSt2InUUA0/Vn3Znw5H96m5FMvO92l8qEPHGT0jMfNnfxzNXFhmgkHmwu/gWR6AV1vMSI@vger.kernel.org, AJvYcCXuN2YejwfDsKqPlLdExNVo64dIGhiDDJU8s5oszltOhcu71wS1yOzXqOn5Njh8ERalKQ4onmIvwVts@vger.kernel.org
X-Gm-Message-State: AOJu0Yyfz6eMLlglyZUM0YYyblgt2eMkxd1VPxVSy+nzdQSC5foM+e/g
	kvEJd8nSmxzztO5w9gs//lGKM1cQ1HB3ShCeaEevpSqpFIeVmI5W
X-Gm-Gg: ASbGnct5+hbsmDb/SCDci0pi2OYzLM4bhZO5RGaLdNh2Cr9QR2ZvuohUqCkMERv3HBS
	XOajAhkkpvFxvm/FCv+jumATPo39HIMjj3+J9MvMF+Sr8XhjU8bBkrtpiLenbZauNltNimGGKfS
	VRV+6dvfTJvg4ivpKVshwODwUfWcQefuz8nF8wq8AuNd7f+LKltpB6zDJlZEVEQYPiRSp6rs7Ij
	0haaiKktF57kMLEU8WrVzwtRLtUSSYGr/mlDsVvpsJLUqb9D7NvStka0r3AQx2Ht+uh1dOYq31w
	XTE6U2Z/VKCEkVn8
X-Google-Smtp-Source: AGHT+IGun8MHXHJ039qeIZdnuPWxA27zM6w+KtErL7eauHjYq66Nj34wIwshE0VMI4nSoQcxHYlGGQ==
X-Received: by 2002:a17:907:25c7:b0:aa6:5d30:d974 with SMTP id a640c23a62f3a-aab779ab58dmr387070566b.28.1734105216774;
        Fri, 13 Dec 2024 07:53:36 -0800 (PST)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa692846ac8sm655979866b.168.2024.12.13.07.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 07:53:36 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 21C3DBE2EE7; Fri, 13 Dec 2024 16:53:35 +0100 (CET)
Date: Fri, 13 Dec 2024 16:53:35 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michael Krause <mk@galax.is>, Paulo Alcantara <pc@manguebit.com>,
	Michael Krause <mk-debian@galax.is>,
	Steve French <stfrench@microsoft.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, linux-cifs@vger.kernel.org
Subject: Re: backporting 24a9799aa8ef ("smb: client: fix UAF in
 smb2_reconnect_server()") to older stable series
Message-ID: <Z1xYf9ShY2OuNiZo@eldamar.lan>
References: <2024040834-magazine-audience-8aa4@gregkh>
 <Z0rZFrZ0Cz3LJEbI@eldamar.lan>
 <2e1ad828-24b3-488d-881e-69232c8c6062@galax.is>
 <1037557ef401a66691a4b1e765eec2e2@manguebit.com>
 <Z08ZdhIQeqHDHvqu@eldamar.lan>
 <3441d88b-92e6-4f89-83a4-9230c8701d73@galax.is>
 <2024121243-perennial-coveting-b863@gregkh>
 <e9f36681-2d7e-4153-9cdf-cf556e290a53@galax.is>
 <2024121316-refresh-skintight-c338@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024121316-refresh-skintight-c338@gregkh>

Hi Greg,

On Fri, Dec 13, 2024 at 03:33:31PM +0100, Greg KH wrote:
> On Thu, Dec 12, 2024 at 10:48:55PM +0100, Michael Krause wrote:
> > On 12/12/24 1:26 PM, Greg KH wrote:
> > > On Tue, Dec 10, 2024 at 12:05:00AM +0100, Michael Krause wrote:
> > > > On 12/3/24 3:45 PM, Salvatore Bonaccorso wrote:
> > > > > Paulo,
> > > > > 
> > > > > On Tue, Dec 03, 2024 at 10:18:25AM -0300, Paulo Alcantara wrote:
> > > > > > Michael Krause <mk-debian@galax.is> writes:
> > > > > > 
> > > > > > > On 11/30/24 10:21 AM, Salvatore Bonaccorso wrote:
> > > > > > > > Michael, did a manual backport of 24a9799aa8ef ("smb: client: fix UAF
> > > > > > > > in smb2_reconnect_server()") which seems in fact to solve the issue.
> > > > > > > > 
> > > > > > > > Michael, can you please post your backport here for review from Paulo
> > > > > > > > and Steve?
> > > > > > > 
> > > > > > > Of course, attached.
> > > > > > > 
> > > > > > > Now I really hope I didn't screw it up :)
> > > > > > 
> > > > > > LGTM.  Thanks Michael for the backport.
> > > > > 
> > > > > Thanks a lot for the review. So to get it accepted it needs to be
> > > > > brough into the form which Greg can pick up. Michael can you do that
> > > > > and add your Signed-off line accordingly?
> > > > Happy to. Hope this is in the proper format:
> > > 
> > > It's corrupted somehow:
> > > 
> > > patching file fs/smb/client/connect.c
> > > patch: **** malformed patch at line 202:  		if (rc)
> > > 
> > > 
> > > Can you resend it or attach it?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Ugh, how embarrassing. I'm sorry, I "fixed" some minor whitespace issue directly in the patch and apparently did something wrong.
> > 
> > I redid the white space fix before diffing again and attach and inline the new version. The chunks are a bit alternated to the earlier version now unfortunately. This one applies..
> 
> Doesn't apply for me:
> 
> checking file fs/smb/client/connect.c
> Hunk #1 FAILED at 259.
> Hunk #2 FAILED at 1977.
> Hunk #3 FAILED at 2035.
> 3 out of 3 hunks FAILED
> checking file fs/smb/client/connect.c
> 
> Any ideas?

Hmm, that is strange. I just did the follwoing:

$ git branch 6.1.y-backport-smb-uaf-smb2_reconnect_server v6.1.119
$ git checkout 6.1.y-backport-smb-uaf-smb2_reconnect_server
$ git am /tmp/backport-6.1-smb-client-fix-UAF-in-smb2_reconnect_server.v2.patch
Applying: smb: client: fix UAF in smb2_reconnect_server()
.git/rebase-apply/patch:102: space before tab in indent.
        spin_unlock(&ses->ses_lock);
warning: 1 line adds whitespace errors.

The warning looks correct, there is a space before the indent here:

[...]
180 +^Ido_logoff = ses->ses_status == SES_GOOD && server->ops->logoff;$
181 +^Ises->ses_status = SES_EXITING;$
182 +^Itcon = ses->tcon_ipc;$
183 +^Ises->tcon_ipc = NULL;$
184 + ^Ispin_unlock(&ses->ses_lock);$  <--- space before the indent
tab
185 +^Ispin_unlock(&cifs_tcp_ses_lock);$
186  $
187 -^Iif (ses->ses_status == SES_EXITING && server->ops->logoff) {$
[...]

Regards,
Salvatore
