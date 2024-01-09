Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EDB9455
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jan 2024 07:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OqdyB/+j"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3368d1c7b23so2574034f8f.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jan 2024 23:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704785996; x=1705390796; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FCGnpiVOUgVBf9FWkplPUtkcGPH1yZ1U7MpKIuVpA0s=;
        b=OqdyB/+jfheR41GiV1sV/u3R4imyL91OuwPqYFcPfK4JSBX2Onjuyl3lHdAdXgfvnL
         uQn+dB1janbiYi5IkKbfum7xHUR7zPlDOTwCrXuGGCMh2zdxEc9sBvsUMhVOQuWXhEb7
         wCdqlUEZZrdbNm3NGRlin56i5qP898KAoMoBUzvVrG8tHLGhWxQR836v2qr2Ba1XURky
         i2QX4NprTJY9izIWhDmStqH854Jrqt8nLgeUTuyQ+4JZWQ8X9JfVXxaTMs676pOEAClZ
         iPnRQAl5+Wz1oJ+JoaNnfX1SNgTbfWBeWjxkA5oreiA1USaTMWcX4Aoz6w0zAYvK+L2A
         MqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704785996; x=1705390796;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FCGnpiVOUgVBf9FWkplPUtkcGPH1yZ1U7MpKIuVpA0s=;
        b=KBdfxbZUfT1G0b8jN0JNhrRI0yUko+sd/sM6RptfNDVEas2uhRQkJbH7ydmc2k1y/2
         EdmjX7IVqoux6i5Kwnc89nK3kxiYxp8sZ/jrEDRVkmveNWql0Pzq0xWa52L9oDSge3ON
         hAYsA2tUz8zMZS8F32xCkXViovRdpEOKjUxgP5zI+sw//yYLvQ2ODoCM9CNVz8MByL6O
         NTUA2IZo2Oe0GvTUzO7x2/jr7xQuk0frO7XsiQ7r7QYr/6YvZraTNsbuwMIA9JtOi+WU
         grAlp2WSKPLlzF9OOJ3Fn3VLH8xC0RR3ccf1mn7eRhAKhaRj7LeLHs5rMBQ1dZDcW+/E
         LjCw==
X-Gm-Message-State: AOJu0YyYBd1wtZhhkacEszvm3asUFSQ6v67R0Y8CvuOu/FOUuiEJGwMK
	cnX1xDhyt2IZCz89CXtBdGAW2n/UhabnsA==
X-Google-Smtp-Source: AGHT+IEvk3ncbEGc3LkVgi8d+aEnFalCwAwKUCaY4/yteX7pPp3uVJedSRrAiFOv8VuIvMhiRNJVSA==
X-Received: by 2002:a5d:5966:0:b0:337:6535:3642 with SMTP id e38-20020a5d5966000000b0033765353642mr336509wri.43.1704785996635;
        Mon, 08 Jan 2024 23:39:56 -0800 (PST)
Received: from localhost ([102.140.209.237])
        by smtp.gmail.com with ESMTPSA id k14-20020a5d6e8e000000b003366c058509sm1618608wrz.23.2024.01.08.23.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jan 2024 23:39:56 -0800 (PST)
Date: Tue, 9 Jan 2024 10:39:49 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] cifs: make cifs_chan_update_iface() a void function
Message-ID: <5c29dddd-2952-4993-9347-7bb11bdf2914@moroto.mountain>
References: <b628a706-d356-4629-a433-59dfda24bb94@moroto.mountain>
 <eac139a7-76d4-4067-8c25-15e30692aaf9@moroto.mountain>
 <4c6b12c9-0502-400a-b2ba-dad89ef4f652@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c6b12c9-0502-400a-b2ba-dad89ef4f652@wanadoo.fr>

On Mon, Jan 08, 2024 at 08:09:17PM +0100, Christophe JAILLET wrote:
> > @@ -478,13 +475,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
> >   	chan_index = cifs_ses_get_chan_index(ses, server);
> >   	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
> >   		spin_unlock(&ses->chan_lock);
> > -		return 0;
> > +		return;
> >   	}
> >   	ses->chans[chan_index].iface = iface;
> >   	spin_unlock(&ses->chan_lock);
> > -	return rc;
> > +	return;
> 
> just remove this one?
> 

Doh.  Yeah.  I'll send a v2 of this tomorrow.

regards,
dan carpenter

