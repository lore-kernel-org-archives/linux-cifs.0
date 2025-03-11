Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241F7262D31
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 18:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741717732; cv=none; b=gFmP/D8KjsPhwXYB0VHjvSWbY7nNG2PtXeha5yaXJIObMYXe5c6nAdjyoYX5ISs0lQxR+zxAvj7eDWHUgKSr66zGcTavh73JvhmFI5+0TwajctG/yH5IVcCAR+dseQ20O0wBuH/EMCDOJ1jq4eJ6fmU7hnOwjicDa18CNG80Lw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741717732; c=relaxed/simple;
	bh=bwP/neOSAUamyAVotEXm1coNniNFQw6AauKL0NhwIKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hCwIRE0ienGdfh1PxIW+WyHf13RlHEuPYzNIQgEp5feDA3mv7I/xTjOgo/hP6PvfKvW+Hv1lZKOJ8iGKAK1Oo/e1LllVrehHl1YnIIidtgoZpb85WN1Ko5rYjSoiKm03581vhhDL3ACcY3xnkLo2VQZD6t5PFMuK4ASBMBlbP8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bdsBnXpl; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bdsBnXpl"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso72316f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 11:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741717728; x=1742322528; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bwP/neOSAUamyAVotEXm1coNniNFQw6AauKL0NhwIKY=;
        b=bdsBnXplapm+8E+D5lrLR7SPr7ghv5s7BBlYk/S6gl3x/68okXqLN5ksR+L0K7lGDo
         Nl6cyEgHzG0pLcWiT8hF2TM9mHgfqcqEKRJNcXtPc5LMnWCsecCgnOc8paqKQiSgfyPW
         JgCNVK2H8TyLvgzdTj+tZw4BWoQh483MZJkFXT1geX7zOgKAMpXIUE05f1J7TSLJawNn
         0Rx+VNYM1FBSqBi6sZdgiCsNAylyROoKw/kTdsyba8GSfhbe5L+HOTKFckKOhSCmGIk1
         EUp5C/PasP+mGDstPWxzpuiB+cKzEFVmLd+JqB1odwtlCwsvWBE5i19Uq/JPKHQj/vE8
         fjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741717728; x=1742322528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwP/neOSAUamyAVotEXm1coNniNFQw6AauKL0NhwIKY=;
        b=o8cWOMoT3jRsOtyYXM/cXLl5+eJNSCKC+caqtqBAivzLLyscQbAlu+b0NQCMHH7Bfj
         wZBUVd+prp9XzWlbhFspOI8yf/KlLSmCeyWidHAmKUpqOZDFbBPcdr5XZ528yzUy0gLC
         RwiL7UoRjDTLnxW+v3lKz5OEQWL5zLQeCqdxxEYldUzo6TB20WfOsn1tVo+E9ry/+5sF
         6Bho3fz6Ha4KqsUtA0mQP/Zy0WelOGfDEHb1m3wLWq6N4hXYQlu4MqoDq2cPBU8FGzOI
         TxUaJeNwOs0T7B2Y1f2i+WewrCzv04NFGV4JK1Egaj3RjHCtkya97l0jvhRY62riKLPV
         7tOw==
X-Forwarded-Encrypted: i=1; AJvYcCVz5gKC8+y3fqoIOR/hccaNFFL0VLyVERJkdzqWuD2fpyG5iiyt2dxptgMtJO4a67ocywa77LMCw+mM@vger.kernel.org
X-Gm-Message-State: AOJu0Yy990ebFknujCDOxTKc13+f3B7sUagQM1qNI3t8TJWTfnE/q+v3
	4k8W4+ruDnPVfcgf9P5gJ+yuVYYftyucajqkLSzbhtXMbOXRDY+Nh4oNEAnYdIQ=
X-Gm-Gg: ASbGncthQQ7z0WDgw36VRfS4NJ/5M+ggkWYR4Ii3E5ULVQ0KSIWmxURJLw7S/oANNxI
	x6ydl89tun9gNmPaaiv+ShLFLCtj0SsVZO8khpM8MZWIVPkmAEyYNTHzeTwpT2KYpF30+zVwBYe
	BkW2Dc6+AaP2XOMF6q3tmIMQopsA6MtXA2TcELPNyfmqvhxnacDlUnuSvQh3Bx+tQ1h6Zg6XAXJ
	LmkSYewAvLkKGf3pDXLjFOVvyM7NUj75RThjKZ3pEupfpB96OUDkG0SmypNIi3e/aTwx5m0lR45
	MP2yIcqHG8YY35V9VXS7wBOaH02ByHR7qttWL40qf4PyuHdkZKuyCcWwud0RdTUG
X-Google-Smtp-Source: AGHT+IEAzELwdKSrGGTui8OEvhIqqMz401vj/Y0HbODaeZJmnVS8texMt75tyhHDRaO0200+yMYz0A==
X-Received: by 2002:a5d:64ed:0:b0:391:2e6a:30fa with SMTP id ffacd0b85a97d-39279e5180amr5248077f8f.27.1741717728471;
        Tue, 11 Mar 2025 11:28:48 -0700 (PDT)
Received: from precision ([2804:7f0:bc02:64aa:5728:8c10:f0b3:bda8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a7f89dsm101778125ad.109.2025.03.11.11.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 11:28:48 -0700 (PDT)
Date: Tue, 11 Mar 2025 15:27:29 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: Fix match_session bug causing duplicate
 session creation
Message-ID: <Z9CAkVAr8O9EQwsL@precision>
References: <20250311013231.2684868-1-henrique.carvalho@suse.com>
 <qzsu6rfpof7ipuaaszyt6opjoepnmxfgdgqzecmrnz4itdl5rn@gb3haoqrul55>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qzsu6rfpof7ipuaaszyt6opjoepnmxfgdgqzecmrnz4itdl5rn@gb3haoqrul55>

On Tue, Mar 11, 2025 at 10:39:37AM -0300, Enzo Matsumiya wrote:

> Minor nit: I think your reproducer results are inverted -- on my tests,
> the session is reused when sec=ntlmssp is passed on first mount, not the
> other way around.

> Calling select_sectype() with ctx->sectype as argument works fine for
> Unspecified and ntlmssp* cases (because Unspecified will default to
> ntlmssp if server supports it), but if you do the first mount with
> sec=krb5 and the second with sec=ntlmssp/no sec=, the krb5 session
> will be reused (which is wrong).

Both fixed on v2.

Thanks, Enzo.

Henrique

