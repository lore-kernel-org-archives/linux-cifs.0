Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B3219D093
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 15:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776354492; cv=none; b=J7auYTTLNdnA40p6d52B960frsEd8Mqvxr9F2ZNjQcVVSC5GsDH9tATdB2AlyrElQBH3JcBei2DUEm8FRHv+ubBc7Dm+BUWee8qxcYOhTIrY6Pl0nhd/PJzL61WlsS2yMmIuH/BjM2wBeCoeQp/IM9Qo2PHtNohqro/gS1OrzD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776354492; c=relaxed/simple;
	bh=hwZFhQIelvPFjAfHD5HdfNs20TZhFLZm708jedZ80rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YV4OTV03UcS9f9CT6sL+or6wYQ9ZVXafgJAuIqmqBwMHRG/pnULLAtNOL0PWu3NAGG7+bomQmJ7V5+LeMB5V34wzJTVmpdI4ZN0S6cJX7Cv5j9BkDd2tyKlBXVkW7snuMBY5vTXCbIZwh8Mmw95MgY5H6qy6VwZUm8RSsIOiSO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WGQCPa21; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WGQCPa21"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so58361025e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 08:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776354489; x=1776959289; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FkhH3vKqP4FUt7rWsyq+PlRfGLrYykKyfQpciwbqXv0=;
        b=WGQCPa21BspMOdjjGvSYfm/v+hZiRqpmerBy6Z79zIhFwqrmGfTkh1l1HI3Y4zLGau
         Nz6moh7nNCMhoEMjcK3wsLXUo14erKI5zVz3V+YQwbH49fJgpvRjI8HbjOfZT4wMrQ1/
         Y8MgRZh6lcaWLQyxKg72mOkRMIJaWqQxKzykD1bfXtZc1u/rPRG0Qh1+DPjPpaa2aKga
         hE26Sk1N6/nETU0HVBjKgvRaAcZlSaC5ycWBsNxpSiWAXUwvZYURh9J0dDW7jh+64oOm
         ijIrIf2XYXmgBbyixoRwdw4pPA9VxNRPG+HHPdZbfGjpBhMwXI1MI7eZwRMmvCp5Vabv
         MTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776354489; x=1776959289;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FkhH3vKqP4FUt7rWsyq+PlRfGLrYykKyfQpciwbqXv0=;
        b=oroVTk6tDkELrL5e6p2LqLZOnUIP/OnyNrMufXN0zVypz5bgbwLsie61jkK8mMW2Au
         KioGIGoQY75xN8jzMcsFZR1o/i40vuaVrdJJttIeYct47ByWWOxZXYXavtAZ2Evgn55B
         VfqK4ycRJ6sLWAjosJKGXpV+ZkPbd+vFc6uJPNaNyi/KNg5Tz62cEKD5VWepQ+w+C7nx
         yDN/CO/ytXNl+Zw/PTHqbpO1mugLmm5qocFjlCg9OOvtB1eS2hgslGojCc9EC+/GVVoE
         GVpujMy/IyYbA10fU1juYfeCG3C8rZywNXAMQAnmDKKFifMs8ypanWONJvmphfyoxfzp
         NAdA==
X-Forwarded-Encrypted: i=1; AFNElJ9vzfBxwzlhGrQ6s7IXSopTFivplLIj5Tkst0QytEnyj/I/2u23quUan5K1CmX7BiXs8Mc6GKbF91uL@vger.kernel.org
X-Gm-Message-State: AOJu0YymuY6tXkNFMwj4uAl21THz4uw1WcEoyOV4uQNoWRbvcIFcNQ8g
	/YH3nzrfsv3t5TetbdrYQrr8dyirYZGIJUtSY02Qjv2F55oExiLJUyV4eVrlYzosl8Q=
X-Gm-Gg: AeBDiev0US9VROCZLPf9YekDLE1a72k84ln7rKDVczEW4hN5mHHkXGhtiaEnxQgVRWm
	LlBYU7nEvfYyPtAD8c/Z8YIfLuQfm4P8HUE8G5/yxP6eK2U7/7FYwOwaUjJxuddE4SFLUwLd3Z9
	uKzo3yOvD4g/kRxv+0I33e9SBZPSxpB4JTLxZP9RfFeFunLhlHHDZ6vohESBsHDmnW8wnBHtWOW
	+UW1r7cyXfyy9i+oIhJZ8ztA5sMCX2xSwwNOVmPIR0VEo25wfULMry6gyOxF1b6VWDoCtm3gToG
	TckSzJ9ll76SPGhT6F+2+4r5I/DPvfEirblZV4rUVZfZ00E4UEoWQpJ6rgRK0NW4uCUgD79fIcJ
	YqQ3ZgsY20EOch7JsGEpNQtrSr7pB28bKB+QcAIg39z1Eg6vuLSh1GtxtoZ+8qC9ryVKPZlRy9s
	3rFueMkWmWPloJ7jjCdFdWNP0KS/KUZA==
X-Received: by 2002:a05:600d:2:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-488d681f36amr289279475e9.8.1776354489349;
        Thu, 16 Apr 2026 08:48:09 -0700 (PDT)
Received: from precision ([2804:14c:61:8c96:217b:6bed:9d72:8046])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56fa23b7a49sm132695e0c.17.2026.04.16.08.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 08:48:08 -0700 (PDT)
Date: Thu, 16 Apr 2026 12:48:02 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: DaeMyung Kang <charsyam@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	rajasimandalos@gmail.com, rajasimandal@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] smb/client: fix chan_max and UNC state corruption in
 smb3_reconfigure
Message-ID: <xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v>
References: <20260416022811.2692096-1-charsyam@gmail.com>
 <20260416151839.3315696-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416151839.3315696-1-charsyam@gmail.com>

Isn't this a policy change? If multichannel fails all the other changes
up to that point are persisted (i.e. password change). Despite that, we
will be returning an error to the user, but have a state that we have no
idea what actually happened. Did the password change fail? Did the
multichannel change fail?

Before we had a best-effort remount and after this change we will be
having a partial success reported as failure.

So I would say that, for this change, if this is indeed a bug,
no need for mchan_rc, roll back all the changes that happened during
smb3_reconfigure.

Futhermore, we need to handle mchan update ses channels just like we do
during mount, because remount could end up being delayed the same way as
mount, AFAICS. I have a patch for this with the series of that
serialization smb3_update_ses_channels patch.

-- 
Henrique
SUSE Labs
