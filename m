Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D526A3D3CE8
	for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 10:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778841558; cv=none; b=IxeQFJNmfaCaCpxV62eI7QoxEU+8C/aKCWZ9umXwHncQ8fD8mCi8CpyhmcLwt8zAsIc3RFHWKdaR/C84zVW7onuMf+PT9quIqhg0MdaEp6NJfx50IT/JxaxPAb8+W2sNRh7fMev9spMApJWsshcVtSJnnXL9ocKOxiGq7bilJGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778841558; c=relaxed/simple;
	bh=jhDglwtHZ1w70nHIGACT03ciiA/jdDtdnR1g3rACmVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTbW49OX/9tqHAzPyKhZgO23/2xW/6Hx0prHjo2/E69duIdBwvfvJkjvxrqNlAhHq7DBOjur5LLsx9rXIo3VlzLxI3tN379JNJnQ5M3XISEKDFbZ/d8GRMoHjNS8PZO7/9a2MdyDNN0t1rlQPmEcymn4OlNzZu23xXJKPEGDJyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OnWvUSw8; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OnWvUSw8"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so85504215e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 15 May 2026 03:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778841555; x=1779446355; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhDglwtHZ1w70nHIGACT03ciiA/jdDtdnR1g3rACmVQ=;
        b=OnWvUSw8LxL6XPUwaf034XS5E71LKz3mTPVLaMrXgD05dhWGLXhMaPoPp//YpO6K9R
         lQldePW8mnp8ztXi7h69q+jie5YHbHBhlyjZA41eGHWGIjSrT4MyRFydJ5c2rxaxr3y7
         iENuoCGG+YVp+oJriBu7iuPXG4ZRB0t8w4zjx6Kh4ExNJqTrgEswr63pui7LusgAsUkN
         kWdq49wUMgh0KmpbKWyeyC7ayJse8W0HqLA8S6vcz/P9C2eeD54IdsgxDT63Z4JfSeBM
         1zLHnagoAPKnHW3slxQuGPM0E8IiQdhBMOUbI0s1I9Z6re4mZGYIAdOBjmpALilcL/zJ
         K+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778841555; x=1779446355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jhDglwtHZ1w70nHIGACT03ciiA/jdDtdnR1g3rACmVQ=;
        b=Hxr5mJsyOkQldb0XiDykxyn4jW5u9Qc9lX5lSxQVGqH4wynP1DYdCMyfgjbgMoxkXj
         IHQ/vcqzIDyPHu+unuktogmyFElon9u/gUQYlAaUiYVMQjYcd27hvgqi4iLLjqKee3dH
         i2/HWYu9HzUBV4lPnje+Gblry+VLmlUFNXQL/D2mldGErnOzcRYS5KWj7ieWL5/kH90Q
         XER46SFmr6hzCF/6mM2OWNSfl+Ier3ytkqWiH0RVVRQDRlMGtFPxZpjwcpGBqsSnVTjo
         239KhmUXiAP4bzGlR6y7SQjpFTpCuxsIGXbYwQCDb35rZrhZTi/tECL/H4hsF8vG1Q9S
         2yFg==
X-Forwarded-Encrypted: i=1; AFNElJ+27XLoPFvofE8dPxpLCBqC5/H1yGD78PZWpLc9mDLYa3uScpgBwba/YmJb3M7pwu0f44glMo/un2Wn@vger.kernel.org
X-Gm-Message-State: AOJu0YzWr8/wyDRQ0VzOWG0Lu0GZikimoUrYUeKt2aPGhTjF4U/Ne21j
	UHetAroZRXrmySvfrsnwYszJJXquVBjm7Z5WHY/5xDlpNWMy5AQOO82IJb6FUttq8Js=
X-Gm-Gg: Acq92OHyXJ9XXnSVPTDJOkgCOPMT+0QdzbFrOLXqxy7cpqLxWaIUeZSNTXAe4Ns7UMn
	u8a98MMp/mnKF9IJ2p1EDs/vA6OZjRINEN6AOe6m4Cf5HCJG8VdBnDwyXNRBaFw/lOLP6y5dtBK
	+mWJk9vmTolCtJHo8v6zV2KeQ1cAIcmlK38JQdV2zm9ri9w6zuqhSQKsExt19H2TPC6xRGaw0Pl
	cBiGbcph1e3s5HwYcMgkMxt0RPXp/Gug705QHodhJftNf3rwrLmqYDWsB/B5Q532jMr4t9S5+St
	ZYsVPK+szHa+FDzHJknCynXSsZ8rtn5PILmDFVuln5e+dY6xOhqfJndu/GEQXJuMYAF97VDtEXO
	118U8E+iblkQFvQmIwHlyw25U6pa5VFmdtfjegI35Z/KhvSIyQ2aF9e4QpcnqH3rhdvtip+Rgsh
	94B4czXd5UpejVTKDPm9ynmSJP07TlBTN/9GoC34m4FWO4SCus4ITGU2MYxo0ZkJQaszHz2w0Lo
	9g3ZYwPTBdmm/I=
X-Received: by 2002:a05:600c:c167:b0:48f:d410:6065 with SMTP id 5b1f17b1804b1-48fe66138dfmr47198095e9.29.1778841555259;
        Fri, 15 May 2026 03:39:15 -0700 (PDT)
Received: from precision (ppp-88-217-117-152.dynamic.mnet-online.de. [88.217.117.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe58638sm10398815e9.17.2026.05.15.03.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 03:39:14 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linkinjeon@kernel.org
Cc: ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	linux-cifs@vger.kernel.org,
	metze@samba.org,
	senozhatsky@chromium.org,
	sfrench@samba.org,
	tom@talpey.com
Subject: Re: [PATCH v2 06/11] smb: server: add shared transport helpers in preparation for QUIC
Date: Fri, 15 May 2026 07:39:11 -0300
Message-ID: <20260515103911.9549-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <CAKYAXd8FOiVgmMDaAP+AcUb_Msjf476ennF_5CUR++Shpw7StQ@mail.gmail.com>
References: <CAKYAXd8FOiVgmMDaAP+AcUb_Msjf476ennF_5CUR++Shpw7StQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ACK
