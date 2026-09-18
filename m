Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCC92D5436
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 01:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789695863; cv=none; b=gKXz7Ud7ZYf9X1NQ4VjCGGZyX4Si62uaB6BCT3oGY8uG0wlVVNGaBX2BzNbwy4rXLxxE/0SfKm2GglijE8Wca1wdBijw4CotXHi34w/XEqYDvBMkZLjRd51s0gKY/tHA4nzaLvKCSPPXDPWJPKHVobvGg5+DgUrCat3QRLBciAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789695863; c=relaxed/simple;
	bh=AhuZwVTTC/1nU6YkD/HCUC2pbhEU63P/DHqLsiNyDk0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YcBzlLHDFLh0Wf8tG7gzE3NE/V6Id9SDjZAQkt41A92NRZkiYzNoXpWttoQL0sPzf68Ju4ygJb1NvH58HZ86eUEe4QzOdy7Eft/Q0K7DZhU/6fiyx6AO0TX3xtxI9DmTS0TDYnVbaPTJdHM5Cr+pehMy4xVpN8UMzI+XxxHxL3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/WmxpJJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqVaVtru; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/WmxpJJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqVaVtru"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gmK8P3XeCEw2Kl7yv61jHybl1lElrtzJ9/W+3yl0xM=;
	b=M/WmxpJJ0sbA1immKkDYrMpT8p7qLZmZD3tygb8Z8vtbT7Xk1FEF2I4XvF743ZknaTLpIz
	5U28TOtsl1WkACgQUhICNcCwgqUObCrAFlugp7uGsuB+WB4PAyMopKk3fpFcQhQ2RPEizN
	fcGxoPIeMXi5ya/K6tZzqTnTZKItTSE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-lrcELPYfOfSCwL5khaBRTg-1; Thu, 17 Sep 2026 21:44:18 -0400
X-MC-Unique: lrcELPYfOfSCwL5khaBRTg-1
X-Mimecast-MFC-AGG-ID: lrcELPYfOfSCwL5khaBRTg_1789695858
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52ffe24490bso6692911cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 18:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789695858; x=1790300658; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/gmK8P3XeCEw2Kl7yv61jHybl1lElrtzJ9/W+3yl0xM=;
        b=dqVaVtrurs5bcY3w5g3emOLwJcklg7jZuA6X+6MO5S/UVKEDJ/RdO2gcyQqGYFiDhH
         Bkg3wcbiDBDP4t+iG7I388CbsWeUzXy64eFtS3aKDMcQiWlsSMka5fjwK31dLPLSJ5qm
         //mk0w8Ko9VihSzvKggSvd3O7wMWH54Jdm4H8ENaKzJyz9yX4kPfPgIhlnzOb94ivEIe
         V1MB58O2xFdz/066WslaqZIZxSw/o8fHxsD+lTrKtWYf+Mw3CgIdQES7NrallzQFBjAf
         nPKmnOG1Lb4xJB+ybjRdE9QVKM9bjG2AjKgzgcDmJxTGgKjtZsxItyGlMRa334mJDES5
         CA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789695858; x=1790300658;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/gmK8P3XeCEw2Kl7yv61jHybl1lElrtzJ9/W+3yl0xM=;
        b=wbQze0IPSnTG8aFEPcuShyAbcq1b/yicY8kFMg4LtcLGMxEPDHjP6i6FxnJcTA+HMj
         cSL74r7gP8nWdlIBSTByc71/Osp2yRv/BB4I32TMbWF+gKvBObuE3BZSYh/iU6lK1e6t
         WxV3RhY9m0XcjhyLDl8uPdUoDy/Q+4EJPQyTRxdO/LahxeInzkIkOnGUbvulpaZPATyW
         9ZfQlvvk3qUMqUH6sGZbxqiSUPI7qMr0UCbNe+EyVExgHT02KaEC68wHrjI7rwdHgZ2u
         wUPCjgL7r/EZyaO0rikfTH8zThZvqYJzUCjksPtSo5x6fnJ0LsZkiTeucxji/HjzAIZL
         sLPw==
X-Gm-Message-State: AFuF++mJm6ajg09zM0EV5O5QARco2qxi4EYHyyH5Noy+OqmM8lX8igQo
	PvqyEm/KcUXKc9qaqZ1RarCRCDYXGJn7hqVVINZ9b59pm1DzJCwpxL+WMzoi3rq+jtuj1jNVEZb
	sQG5B/78R4fe3w70SpsGAgTxNswmWs6kg/R7nEkkCddwzyUO4DbtVrohqb5xU1q1didE0pbO1cZ
	n6U4/uyPLs7h8dsXyK9aqvoJ5n5g1nIwoGIDPR/F/iOred7qg=
X-Gm-Gg: AYBFou255ND+oLrLP+Sg9r0YLhNZ+0HsuoUJ14mVBQ9wdVG2l3XVJb9lgMilo97RO5T
	EsmyqVUD1u0YeAXqn/lm6jzDl9EkvIgJok359sy2Vabwl0xtx9chr25XmQHoKTIn2WH8tliRvkW
	Iix09l8ffLAynTjQJvCUwgHkj9r7UAmbLlBoAURgCZ16YwhaiQsxD5EXD/pibD0X93jNp8pwY8D
	FUjMOb3xn6pH8FAbcRhEqY6WljJ1Zyu10VvUqb266aynX01e3Z2LSbNgrh/9FsA47GT1JvnF5qt
	Qca+vot8IdH9ckhBEBysM27gHHrkURTQX/7ifDHbrBrBtCrXMUrlXcz4qQO8Bdd3NpYwGNPjtLk
	A5utaYo+fGpbkjk6mMjTO30FgVqf/iIsRFmmkopmx
X-Received: by 2002:a05:622a:4292:b0:530:dab5:d43a with SMTP id d75a77b69052e-5329e2aafa3mr19749211cf.24.1789695857820;
        Thu, 17 Sep 2026 18:44:17 -0700 (PDT)
X-Received: by 2002:a05:622a:4292:b0:530:dab5:d43a with SMTP id d75a77b69052e-5329e2aafa3mr19748911cf.24.1789695857054;
        Thu, 17 Sep 2026 18:44:17 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532a19a452asm1997361cf.14.2026.09.17.18.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 18:44:15 -0700 (PDT)
Message-ID: <798adeb8-ef0f-47d6-9934-a19a23cafa4f@redhat.com>
Date: Thu, 17 Sep 2026 20:44:13 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: fix potential use-after-free with
 TCP_Server_Info->hostname
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org, pc@manguebit.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
References: <20260918003327.2539470-1-sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <20260918003327.2539470-1-sorenson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Please disregard this patch.  Two of the cifs_server_dbg() are called
with 'type=ONCE', for which cifs_dbg_func() doesn't ever print.

I will re-evaluate the rest of the patch and may resubmit the
other hunks later.

Frank


On 9/17/26 7:33 PM, Frank Sorenson wrote:
> The TCP_Server_Info->hostname pointer may be updated during a reconnect
> event. Accessing ses->server->hostname outside of the srv_lock is
> unsafe and can lead to a use-after-free if another thread reallocates
> the hostname string.
>
> Fix this by replacing instances of cifs_dbg() that print the hostname
> with cifs_server_dbg() across multiple files (smb2ops.c, sess.c, and
> smb2pdu.c).  cifs_server_dbg() correctly acquires the srv_lock before
> printing and standardizes the output by prepending the server hostname
> to the message.
>
> Fixes: 4659f01e3cd9 ("smb3: do not log confusing message when server returns no network interfaces")
> Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
> Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>   fs/smb/client/sess.c    | 5 ++---
>   fs/smb/client/smb2ops.c | 7 +++----
>   fs/smb/client/smb2pdu.c | 5 ++---
>   3 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index e095f41b5882..5c2c9cabf7ef 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -192,8 +192,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>   		spin_lock(&ses->iface_lock);
>   		if (!ses->iface_count) {
>   			spin_unlock(&ses->iface_lock);
> -			cifs_dbg(ONCE, "server %s does not advertise interfaces\n",
> -				      ses->server->hostname);
> +			cifs_server_dbg(ONCE, "server does not advertise interfaces\n");
>   			break;
>   		}
>   
> @@ -395,7 +394,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
>   	spin_lock(&ses->iface_lock);
>   	if (!ses->iface_count) {
>   		spin_unlock(&ses->iface_lock);
> -		cifs_dbg(ONCE, "server %s does not advertise interfaces\n", ses->server->hostname);
> +		cifs_server_dbg(ONCE, "server does not advertise interfaces\n");
>   		return;
>   	}
>   
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 3464470d3297..08ea340f01b6 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -632,6 +632,7 @@ static int
>   parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>   			size_t buf_len, struct cifs_ses *ses, bool in_mount)
>   {
> +	struct TCP_Server_Info *server = ses->server;
>   	struct network_interface_info_ioctl_rsp *p;
>   	struct sockaddr_in *addr4;
>   	struct sockaddr_in6 *addr6;
> @@ -666,10 +667,8 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>   	if (bytes_left == 0) {
>   		/* avoid spamming logs every 10 minutes, so log only in mount */
>   		if ((ses->chan_max > 1) && in_mount)
> -			cifs_dbg(VFS,
> -				 "multichannel not available\n"
> -				 "Empty network interface list returned by server %s\n",
> -				 ses->server->hostname);
> +			cifs_server_dbg(VFS,
> +					"multichannel not available - Empty network interface list returned by server\n");
>   		rc = -EOPNOTSUPP;
>   		goto out;
>   	}
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index dea05aeb53a1..bb30cfa156aa 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -173,9 +173,8 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>   	unsigned int chan_index;
>   
>   	if (SERVER_IS_CHAN(server)) {
> -		cifs_dbg(VFS,
> -			"server %s does not support multichannel anymore. Skip secondary channel\n",
> -			 ses->server->hostname);
> +		cifs_server_dbg(VFS,
> +				"server does not support multichannel anymore. Skip secondary channel\n");
>   
>   		spin_lock(&ses->chan_lock);
>   		chan_index = cifs_ses_get_chan_index(ses, server);

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

