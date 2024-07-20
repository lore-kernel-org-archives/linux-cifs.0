Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638FA163
	for <linux-cifs@vger.kernel.org>; Sat, 20 Jul 2024 00:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721434350; cv=none; b=GjWOnK7ynI49X/U8BulW3cU8+J1PnAtnfIVBDWCLEbinqsoekKB0kjStvvwmKWg6ZgceJ1iVPleGonX58w/ubBEPtI+O4ll0K7PB2thjLeOSwpnLoPknaYny058vTzag5HED8uyMLLmrC8w4ZMmgXl01RvC7LcTDRBpij606gHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721434350; c=relaxed/simple;
	bh=zEK2IS1PLt9gUYd35ObU8MyLzrfm8JfHjmvRQDthTqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTb1PA0Q/kvCd1rhr6Eo1+y5L1ATB/F5K1zdd+5IUo2W6mx4VULMuAy/G+uk+ucyssryW2/MhghNy8XqSuRgwDz+xgHKHQ3aA00L+xdL7ivngfyzSmjjGM0PhB+CnQtBA2A6sTsRMiPJ58qaFhX3otVtl413Eyh+PHAu6whMJu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hf8WWnN0; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hf8WWnN0"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-70361c6fd50so1184141a34.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 17:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721434348; x=1722039148; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2SZA4FRs3EZicDbPWt28mTFia1UqhM1V27bUvJX/X84=;
        b=hf8WWnN0LQPlbo9GMJKjm9X+XH3OFCIqrYG5wGdoN8oh1FBq8zbrzNm8xZwSzPaolq
         wlvlwh/Ft2ipZmJ5+OD33ySmsYJyAJqVkRCuAdMGG+mgMLZ0eb9aOVs2IjZ1Ka4FnN1B
         EPcEya7uPPU84iKR++2SjK+XlfGuwRWh/woSuOSClEDFwgcqrS4rphuJnEx8YwGhgdbs
         l/l5vMoSHrWEsjnj8eMrjqrJkgr5u133FmtPy8B2tProATLbj4WLR/BYhiKR85kflmDg
         zh1LBfcMBmsr5ApBzjjfk6qrK92V97fyXDTqUyyF7Hcu2SSrUhXLgRNLByAs8ll4afZ9
         cwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721434348; x=1722039148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SZA4FRs3EZicDbPWt28mTFia1UqhM1V27bUvJX/X84=;
        b=m5/j+Hfch8j1l0oUxGc1ueQIt2N0OdKR8TsF9iX4Pm8NIQkOjSjtSI01I5aFlmTKy0
         xhLoi18stZkiik/npEJxOsq+ggaqyJZ1+HkHNFPBmyDCLSkshG9fhiXqHqlbiC9A3Ngb
         a7vvg/g+cqvmUEzB6B3HuxynY6TtzCWrEpdKaNR9baIx4UwKfKgQd1myrGwYAXY8TgTO
         LPTg/IkxSmnAlpvQAL6Iw66ul5LtRh8KFsSjrtAXUuZusdUiYfJEbKUvyJ9jVEq4+4z3
         ClPKjRHp+j+hCzTwaoNHA7PTderhkjqQb8IqwzMcS3t9u8oGrM9mEgoWrWp4/ryuYXDw
         0NIw==
X-Forwarded-Encrypted: i=1; AJvYcCWEPzgvCecrcx0IR65flrVm/wSYH//7sIV7sDfRYtQHES0+0+kro22gkplUIZurxHkjR8Vbz23xgH5DfFbPCr3kTIMh6/e5WOeWvg==
X-Gm-Message-State: AOJu0YyHZRB36uT3X7lKDMkcJMnaIYwsiSA/VMrNUl3gugQYXvGzWJf6
	XlD6wft5ILh5JJkH7X01xds3ud8AP+fyj4wRl4GtDSyHvqP6cLzhVNUG6ZzEJ8M=
X-Google-Smtp-Source: AGHT+IFQ1kuTZw30w/pECE7vvt41a016Eor8HEapLf5CI9IbJmDy7mN6V4gdRXVWIidGiPIMuDTeOg==
X-Received: by 2002:a05:6830:381a:b0:703:5ba3:581b with SMTP id 46e09a7af769-708fda82952mr1887147a34.5.1721434348411;
        Fri, 19 Jul 2024 17:12:28 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:4528:a9e:1eaf:80c5])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708f60d5581sm528951a34.34.2024.07.19.17.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 17:12:27 -0700 (PDT)
Date: Fri, 19 Jul 2024 19:12:25 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Steve French <smfrench@gmail.com>
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [bug report] smb3: retrying on failed server close
Message-ID: <d51d743a-319b-4750-94a7-c41b57eaf31e@suswa.mountain>
References: <6487f3bc-102c-40a0-96ec-dd97dc00c49c@stanley.mountain>
 <CAH2r5muQRMd1CG6YVNyt2JLyrwP4n+DAQb+QW56LGCaSpSvWnA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muQRMd1CG6YVNyt2JLyrwP4n+DAQb+QW56LGCaSpSvWnA@mail.gmail.com>

On Fri, Jul 19, 2024 at 07:00:42PM -0500, Steve French wrote:
> Wasn't this merged to mainline (commit 173217bd7336). Does the warning
> apply to mainline?
> 

Yes, it applies to mainline.  I only test linux-next though and
sometimes people wander which tree I'm testing because the line numbers
are different from their tree.

regards,
dan carpenter

