Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EC92E3EB
	for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 11:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709032606; cv=none; b=QsUGRORzYdwqsD1LM8cQ0mufbjWoGN7y0HH1ztQhkp22i7uFl5aCYUk2lPXtMqgscBbawlecdGm8g8DNqhdY0yve/IaJWwJql06ZSNkK854HGcQn8ylzTZtzS9UdlsaeqPphN0Oc33Mv4uarePqHhAFBC7Gw7661cHZtf5rZ4Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709032606; c=relaxed/simple;
	bh=1gaEDmNOVRml9fS6nqQ4XU65DMVolDGYGSAHdUVeeG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=noDhs+idQdgfA4p0x/TGSUJIJYFV6+wGjDH0iaktrURrtb/CRSi9eJM6R5YhvdFYUABDkBwGSl9HfCjfaCiokLuAzf2pst8cOutZqByODVD3owStHWXIV5+BsDIw+JSMShSFzRgDhfFwgEVGR/qZIwOQ+OUUKpCV0ljJXYKD0+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz; spf=pass smtp.mailfrom=sairon.cz; dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b=hf6NEEYY; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sairon.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sairon.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sairon.cz header.i=@sairon.cz header.b="hf6NEEYY"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a3f1bf03722so441574766b.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 03:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sairon.cz; s=google; t=1709032603; x=1709637403; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8maodQ7SVk0lsGRMUshinQhJllk+8zH3K5kldXH3WEE=;
        b=hf6NEEYYHf948KQ1FMDIg4nYVr4qKroKOvA5l9GCGy5kTUSlFpKjitneOp2PtGQJ/N
         gP1WxCht3UPm+X8XtOzJNe2b49OPZl6GjJO/+twHOcQMnPkSG0LajIMoqmmv7MW6tFbr
         IS/OqV6QxMN40uy0rdboeF9mQuEC8tfdlptMtiokYqH/1ddQDia4iblyx0macqZelgJo
         ozHXBxa2xbDdWSeqLDZgfGe6Z0ecU207CInsljjBAExg0f9vsky95fcYMAzi1fvsCvBT
         lyWAxsdUS1ex8H3EErRZDllUIEIxyl8D04SzThjJuc8zrAos8lDxRJeRbsu/VtL/lX+B
         GYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709032603; x=1709637403;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8maodQ7SVk0lsGRMUshinQhJllk+8zH3K5kldXH3WEE=;
        b=qzQkDD4dxiZvIEt0HP/FsXF5lKVFFyMJymjSpWOb2MDtWCdWwTzWD2YcI8SwULTOco
         2KUsrPw+ssl+oyh30y2qA5FF371lUor5nojaqGrrpSmu0moOvGw0pbtmx6iQuDvIavp1
         GNfy3j/dTbpc7OKIq/uMyX5X1J9/9BLUmrFU8GeZjv+qOPSWiXvZTmwxiQOsSLFk7yiP
         IFNrfSd9F3fIHWLkMtHqFjizin3Pxs6IQxXEYAn3gyYY9LJoOXL3IHpTJhq0ucO3L0ZZ
         EAQT6WxIZ/zuYXY3HDNci5URRNATuWNifSktdrftaRXgM7v1ns/S6arIrCUTgtMXzZC5
         Tm8g==
X-Forwarded-Encrypted: i=1; AJvYcCXsGLW0nNGOCERu208qYZIZanTIzUWVW+dqbImZmUpJMZ6TY130yiMk/H8ikNqoia8Koe8SYCxqyiI0CYNfqvM7fn3iX7AaOd+qsg==
X-Gm-Message-State: AOJu0YzkBi3gGdgMbDiLCL7ub8WLOKzRNFFpdEcN6eOltkcvB7VSLWQr
	lwXMpT0lbfLrXY8vIYEnGwOitwQmmQnrTtZSG1Hc2g0S8epJxxD2VDVFNaEvBVI=
X-Google-Smtp-Source: AGHT+IFSDEZMw4pB3qIf0ADk/Sl8+9EQWUUj6CGFXQtfJNm7NkQsovbyK2dKUim2oxfMVSf4ZHYhtQ==
X-Received: by 2002:a17:906:b216:b0:a43:4335:cbbb with SMTP id p22-20020a170906b21600b00a434335cbbbmr3811723ejz.75.1709032602962;
        Tue, 27 Feb 2024 03:16:42 -0800 (PST)
Received: from [192.168.127.42] (ip-89-103-66-201.bb.vodafone.cz. [89.103.66.201])
        by smtp.gmail.com with ESMTPSA id lv8-20020a170906bc8800b00a4306ac4c77sm646652ejb.197.2024.02.27.03.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 03:16:42 -0800 (PST)
Message-ID: <4b04b2c4-b3ff-48e7-9c24-04b1f124e7fa@sairon.cz>
Date: Tue, 27 Feb 2024 12:16:41 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] cifs: distribute channels across interfaces based
 on speed
Content-Language: en-US
To: Shyam Prasad N <nspmangalore@gmail.com>, smfrench@gmail.com,
 bharathsm.hsk@gmail.com, pc@cjr.nz, tom@talpey.com,
 linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>, Stefan Agner <stefan@agner.ch>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <20230310153211.10982-8-sprasad@microsoft.com>
From: =?UTF-8?B?SmFuIMSMZXJtw6Fr?= <sairon@sairon.cz>
In-Reply-To: <20230310153211.10982-8-sprasad@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Shyam, everyone,

On 10. 03. 23 16:32, Shyam Prasad N wrote:

> +	if (!ses->iface_count) {
> +		spin_unlock(&ses->iface_lock);
> +		cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
> +		return 0;
> +	}

May I ask why this is now being logged, and what can be tweaked in the 
case that a server does not advertise interfaces? After updating the 
kernel from 6.1 to 6.6 in Home Assistant OS, we got a report [1] of 
these messages appearing, yet so far only from a single attentive user. 
I wonder if we are going to see them more often, and it that case a 
suggestion to users would come handy. If there's not a simple 
resolution, could the verbosity be lowered to FYI, maybe?

Thanks,
Jan


[1] https://github.com/home-assistant/operating-system/issues/3201
