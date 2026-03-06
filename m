Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAB33C52A
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 23:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772839846; cv=none; b=sMO2COKO9zHHE6+zlRb6bQBZMmfE9/GG0/OuKEhnqtaA2wgXN7mgaBsmb+rab40VavS7tyqxeJL0ABRPoL9pmMXu7VqyrBKQr/xtrGhTp1o+HoAYnQm+25tFrKhmn44QvtORo0jGYy3L0tzDv/LFv4M/5XMaJU13OWQjD0LOBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772839846; c=relaxed/simple;
	bh=g2NXQyKcvTUzzxIWbefo4ZJkJb/E7ahwbbcyXA7Sqz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLswhELGwlarin03LnEgn0acHM94pARZZsjDfBWEeyyEQt1RyXKiqJyMwZnl/m2I5gvz/Msyyl2bY2mtwXnoRSoaxj5D/4ynEWKAAxYuumorYJAlymA884gcAOKAX+YweR7Yo4KNRdo0iR5mGuhCm/0GEYGzhZkcYaDbNuX4zJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qd3RIue6; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qd3RIue6"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4837634de51so42573665e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 15:30:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772839843; x=1773444643; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BG2LwhYHa/E+CLmX8eJAihUFzcQRK/Dhhh2JZys60+A=;
        b=Qd3RIue6ijADrTOVAD0amnJNw7O/AZHTygWw+XDNp3t6I1s4PgeMruHgEke+K/4gcm
         yJ6akBfrJS7WopRbUclblPauv8CJcF2JeeHRIDdywb0L1bZJFJU+2/AJ1pg+7xKHICbO
         iFYrZ+1dJ9ldkCvZyUtlVe9LGdMbaqberCW6ypY7qrqDWVrh2hAgbVZXAo3fkaq0wHRt
         BFXRZ9w37faxNosd6q+hJijyPoJGIqOfc73GuzOp7W8EG/xMJqRWLRKDYjeFAQMzfuFk
         AYl9pIM3BcVQnMC13m7jz9RFVippvKSpZ6MAvJlKXtST8DYzzUsJnI0w6W6SQSJDhfUJ
         A2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772839843; x=1773444643;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BG2LwhYHa/E+CLmX8eJAihUFzcQRK/Dhhh2JZys60+A=;
        b=AZN/c4D+o2MRVmwj8uHlVanv581IWpewqn3iugP46mHD1D4Lowk41/u0Qj/ZaHtfi4
         43RS6/J2R0cZNpBILHCw1gymdiy/SluLSxapIPgL4VmNK2g/KL7n6DnpyiOChOs1woSW
         9PHMk24Qw+7WCTBaaeFtFHBEYG/CeMkEQL3ov2N9W6h0q6CiWU1fdlrP6F04tlSaSxLk
         1Hd2lkr5jDYQdmDoobF67WDMh+bBDbRNjhMads9GJQDtdfAYRZKgMrPnuASSYXU8Bpe+
         F6J1Ms6aQyrK9pMEWe+nDfonVq2XK1HgdsCkaqlYaIgbP6kPyVY2w1GKWAJryEkd+Eru
         V2FA==
X-Forwarded-Encrypted: i=1; AJvYcCVjeJwD8BxG2tSzRLeilF1V0x3DfA1ocRSDdPrtavsA66VOWbe4eskwGs4KDjJpxHFfLjs1jwLlUJ6R@vger.kernel.org
X-Gm-Message-State: AOJu0YyFyu87frNXuDv8jYXd26Zw+WOPfIc/KA757F58dayOBjxxxbqm
	WlVpkmwqnh6PZLkmA8Yc74NaaeprEa7KFGUo0reNLnLKBn6MuHOQ8yqKjmMfAEDaG8k=
X-Gm-Gg: ATEYQzxTpNC+fxxkENTGMaUI4XlPsvEfKP9zhoXQ2H6zyBzD+pPFK3kyPKT5w4DPcXc
	Xt9em349i5BIHN9RaE9j8LsNOy64NXL4dFi/TwZSJFRoDnJOPmyxRWAf+x0as5d1X+FW2AfpTf/
	9TpY5QOrdh1rs6HVTUMTzf9cLMY4Xkx21nZ3Jt/4RB9W72+V+Aioa+jIjyI5VJ0sr52KYIa68Ri
	nhSIlhn1jRmGcO4xNADt7Epw9hc4pWeb7sKJv/sR1tQci/z/EkBOh9dmeruSEDh+Vz/5h4+exIy
	3P9HZcfD5USJ1LhFnkOwNVEepksHTcOA+cWdOZQbmmzYSt24hHSQDBGgOc6/Xcef1Ap0qRFqtiX
	QKIh4gBok0oBrAsqZ+76sf089pPXWx8WdLRFTvY97xX0iHlY4iYPNWyIYTJI5XYficvsH1VtJYY
	PS3w1puqUTFyg9Em3iKHnkV26OzwfOFaCKgGd2NluHWsBMOyFp8dSxHnI=
X-Received: by 2002:a05:600c:3b02:b0:485:2f4a:6ae6 with SMTP id 5b1f17b1804b1-4852f4a6de6mr1251565e9.6.1772839843310;
        Fri, 06 Mar 2026 15:30:43 -0800 (PST)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6401:b8d7:ea6d:8ea1:ec5a:953d])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56b09b4bdb8sm3526365e0c.17.2026.03.06.15.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 15:30:42 -0800 (PST)
Date: Fri, 6 Mar 2026 20:30:38 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Steve French <smfrench@gmail.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, linux-cifs@vger.kernel.org, 
	pc@manguebit.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
Message-ID: <ym7qxt7f46gy4vq7isufgbz3svsvo3zp7irrjmekjebepg4u5z@ruu3s3h7tlkh>
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <CANT5p=rk44fGgUL_Swp1pbVUeE80GJS4hxF00U0X4_xUbb-7hw@mail.gmail.com>
 <4rrxsl6mx3lbpt32l4ly6psg3ni5nsfzgfiufzt4xecsbjh22o@z272atyrzzvh>
 <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mt4mDP+o4FWcJLhiXxcnjou7jxzPzUv1RqvmJxb=OSh6A@mail.gmail.com>

On Fri, Mar 06, 2026 at 05:04:20PM -0600, Steve French wrote:
> On Fri, Mar 6, 2026 at 4:45 PM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > On Wed, Mar 04, 2026 at 06:04:05PM +0530, Shyam Prasad N wrote: > On Wed, Mar 4, 2026 at 5:59 PM <nspmangalore@gmail.com> wrote: From: Shyam Prasad N <sprasad@microsoft.com>
> > >
> > > A proof-of-concept based on this draft from Bharath.
> > > Looking for comments on how to improve.
> >
> > Looks good.
> >
> > Just one minor thing for now. To me the cifs.ko module version doesn't
> > say much as it seems to be not reliable (apologies if I'm mistaken).
> 
> It does get incremented every 10 weeks.
> 

Okay. I guess we've skipped sometimes.

> > Also, the same version could have different implementations in different
> > distributions. modinfo -F srcversion cifs is a better way to
> > differentiate cifs versions but not to compare versions. So the solution
> > is either remove this or bump it in every change using X.Y.Z.
> 
> We do bump the module version every kernel release, e.g. we are at
> 2.59 in Linux 7.0 (7.0-rc2)
> Would bump it when someone does a 'full backport' of most cifs fixes
> to an earlier kernel.
> 
> > Further, have you thought about how the client can use this in its favor
> > other than diagnosing/debugging a faulty server?
> 
> I thought this was for the reverse - so the server support team can
> get metrics on whether the client is an old client with known bugs
> 
> > I think we need to be clear on what is allowed here, to me it seems
> > quirks, workarounds and perf tuning? Maybe this can be used to improve
> > interaction between linux client and linux server?
> 
> presumably primarily for customer support to be able to recognise
> known client problems on clients accessing a server
> 

Yes, but also the server will be able to send back context as well,
correct? This may allow more than bug triaging.

-- 
Henrique
SUSE Labs
