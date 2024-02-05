Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251E9125A4
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707123133; cv=none; b=SHQZKgiVM+XY7Cm0KEn3uWbQt8dhuENUz38IeplOWepfCMadiEarC0DKKTsFmYN4RfAySPs6Lx/am2tdDscH1oFgcKhA5zwYRNu2PLyR2mzGzqfWe0ePh3HDKTqYhl8o0caaTeWasG6GpTH5rfl9nfvqqlqnvTHkl4VnGucaj4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707123133; c=relaxed/simple;
	bh=fYYIoMRmzFDfyxPkBsuFwVklQDqMIpweJJmKoOAHvgw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cQWT/p2Uy9So7NktA+d5bg7lrpzMYZjaipPBwp1ou7v7caR/ffyOob7RhJkYOAoZ3kD5FyiCjk0v5ymYwLaUDF/OX6STcWlicVYVJvigZ7x1Advv3yhzTENUscZrBilILTgud5CAcGG5Xe7rzWEhQJg37/gzFkoZwjD38auo9oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vOyjcV74; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vOyjcV74"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a30f7c9574eso552075266b.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 Feb 2024 00:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707123130; x=1707727930; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sb3cRRNCca8/UgisG0PwCGs4o3iFKIvaXbVoym3EWrU=;
        b=vOyjcV74Xku+IgHqWT/GiJgOSRCSCsWCYTxFXyL981TocnNhAGAiXML4MtQM7LJCWu
         oj8eLPjtLbWXbTpmGb3dYwEGVdeDd87OC3V2kOmoB0KUOVsMvZ29ZgxuF+Ts0nFo6Vdi
         0Syi9yTxXT0QzvZL5w9T2xuXtSs64SqUzYO2wRnOkOImQs31aNJS65H/FNtMsxcuwbmi
         9ieQMP1lPgxlYfxyF3poKlZ/KApmhF0rjMEj+cUg4lJLZTEGiceo24HorO2+Rg4/7Gb6
         pXgkRH1IV7ar8siJN3JqU3UnmhXLb0ZaCT4MRefE4JauvRXpgSzuAu6K4ZhUX4HOLaXB
         CR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707123130; x=1707727930;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sb3cRRNCca8/UgisG0PwCGs4o3iFKIvaXbVoym3EWrU=;
        b=YyK315WHWC+Qecf2MwvY8jHNZ8lOsWBiF4kKMmEoewYwi//JCz85KrZo/2DP6yYjTP
         FxhPWBvT8JVT+1a0XWvdUhnPa82/GlRwYS15JxfSV3H438JNVQK5WkIDQ4aiLSomUjf+
         74aYifkccw20ZgWrEpI61D4ApdDBHdqjHP73CsOCN6saUf1D02G2JzKwBMP3iRd5BkKD
         dtfXaEiBtPZIRSkQRETn/HPIzyV67v9hAI7MJVO9TDfAfbrJf1vxt4rcQfmj69Z6ZH7w
         zvCRoatpvc1JRSbcVxz1vJHE675W+zNvTi8oXqWIoNyXiInkM32HsZ7gvHEZb64bW4r6
         uOTg==
X-Gm-Message-State: AOJu0Yymo/kruUQWqIc4F1av1w90KL5yeADriNfoPqzStKPiRncHvIS4
	ndl488j5LUiLUqBHOHXUsFaagAi33hotZQpCflk5qbSoIjalDDv1YLvOgtYEeFrP+Y4RtDyl22C
	Y
X-Google-Smtp-Source: AGHT+IHoQiKmJDe0KOcxJsDj47CIF4VEorHOH0V/4F+XVIlBktPvVB5Loxk6gH57ds4wZoSAhkHkrw==
X-Received: by 2002:a17:906:1990:b0:a37:b22f:f4e5 with SMTP id g16-20020a170906199000b00a37b22ff4e5mr1600421ejd.38.1707123130240;
        Mon, 05 Feb 2024 00:52:10 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWTL/IovXfk8fA9hNZ3kTOIlUngfCEYrD7xAJcJE6i3820k42tQTXgc+knOdjNi/Y/Pu6Lhbe1gtUL5KMtVc2Zi36rDAdydXZM=
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id ps6-20020a170906bf4600b00a37ad5169d1sm1167275ejb.35.2024.02.05.00.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 00:52:09 -0800 (PST)
Date: Mon, 5 Feb 2024 11:52:06 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: sprasad@microsoft.com
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] cifs: do not search for channel if server is terminating
Message-ID: <84dddfd9-c8d3-4e68-a228-f599649c8e8c@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Shyam Prasad N,

This is a semi-automatic email about new static checker warnings.

    fs/smb/client/sess.c:88 cifs_ses_get_chan_index()
    warn: variable dereferenced before check 'server' (see line 79)

fs/smb/client/sess.c
    78		/* if the channel is waiting for termination */
    79		if (server->terminate)
                    ^^^^^^^^^^^^^^^^^
The patch adds an unchecked dereference

    80			return CIFS_INVAL_CHAN_INDEX;
    81	
    82		for (i = 0; i < ses->chan_count; i++) {
    83			if (ses->chans[i].server == server)
    84				return i;
    85		}
    86	
    87		/* If we didn't find the channel, it is likely a bug */
    88		if (server)
                    ^^^^^^
But the existing code assumed that server could be NULL

    89			cifs_dbg(VFS, "unable to get chan index for server: 0x%llx",
    90				 server->conn_id);

regards,
dan carpenter
