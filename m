Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F45403135
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 19:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789588551; cv=none; b=u949Mx0LZBQGTvb9Yc1b/z55jyvqFNU8Hd0BhGTjFAJjYUw2Q5COF5O9JDlYEa+Ec9GC65XuqKcIVXVACjwB4UPHnkYncv++2r1obJpGJyFbRw7k+0jBQPhsMvMwpHvUz7h9mcIKe6DpS/k0hmQyojbmKTHV1YyuvAsuFulbykQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789588551; c=relaxed/simple;
	bh=0BB7n4OsVPiCeQwV+ZDfw2ZUAnB3mwRRXE1PfcfFZl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aemQnzUDpJyFghsMzwvK+GMsbB/9i+gqp+0IW1F+U91suWPxkyn2QJx6pZukg6PV6kimxiaXJIzXieMpF0+Eko7aYp4IMiheeK4ZV4mHz9VhRuBuSfLSLZwsy0oXVlpz+dsHp9F9dC9dRqj0Wnf4Hpmb2oudmqMr4ysaNn+vmg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YF1INYa6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DABWVbb5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YF1INYa6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DABWVbb5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789588537;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XVmhTWYbPZkjM+QbvC5ZRGrC4NCNOKB9vcL4AApcbiM=;
	b=YF1INYa6mNw220btfFuq3K4wd+pVUCAvP+gHmlc6HH8lQsBU3qHdtAFUyHJSC2aRmids91
	7dAdCkL9xVrsSVr7xWS4NtuapIm8uOSg5FBTPtB3loydCFI/yrEJIpPuE+f82h73hrbdha
	LbLvO9/LMAWcKiF7WJi4hHbGlB4VBso=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1-XWVKHbfHMdm1S7PzIoACmw-1; Wed, 16 Sep 2026 15:55:36 -0400
X-MC-Unique: XWVKHbfHMdm1S7PzIoACmw-1
X-Mimecast-MFC-AGG-ID: XWVKHbfHMdm1S7PzIoACmw_1789588535
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-939f3426a7cso9036585a.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 12:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789588535; x=1790193335; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XVmhTWYbPZkjM+QbvC5ZRGrC4NCNOKB9vcL4AApcbiM=;
        b=DABWVbb5J1cW/lD2WXFKb/4LMuu+ydYNNYsQwmE07RxpwNXKoIR6iM+rGe7k/m10Op
         iWEWdaLE/XOkqPGyGc/2IYhAOljDXYB6iOg+bJXQENeb9151b4ZetQiAGk7yFcZagIt/
         vgOXm0C/+sSdpqlfyuicRdmgP/BV2gQ6I9m4PPHx4a4O3QHOu3py6hiSAYwMEm4lu7dH
         2GaLOwbnd9/RKWYbNYOyE5H4BXEC6p4fs8L5FAic3cDE53OiMf51et759gevAqJrIAkb
         5nHajgWyJ5bn3Cpelgtiw0rZrai1rdIIX2LAV0yyXPI2bWAWLoeqshT+W54BbyOXV1PW
         JRWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789588535; x=1790193335;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:reply-to:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XVmhTWYbPZkjM+QbvC5ZRGrC4NCNOKB9vcL4AApcbiM=;
        b=yUW37xRitqCFkh84GaG9x8A5mHNnXhUhFQf6qJrRhKtS0Z7OIzZN8ISzrvZ1YYkpir
         hgi2hn1OIR+jPoCY1aUurBwNkx0Jymxv6EzkrrCLsm1nvGeWurz0VRzwfMGC5ZBWV6xD
         kEGd4FZbP9/IIbM+sHDfnOOwcdhxBoImHdLrbJKXs9PEYMRMmTN3nB74+HcHtPCmJeYx
         dqKAd/st5eRX55V32aKcA8+LSVwF8+jPJvoh45fNrf08yM1ZvKg0fP5kjC1a21r+pvbG
         D/Z88yqRqoPl647cBDurTDhSIAU0u+sgzsUVUiCSHNUx9P/ZDLFrC+IhOBFlgDpDX4DK
         j9Pg==
X-Forwarded-Encrypted: i=1; AKwUvByGy9wLE29U/F6hPNC28kOl/EIgjWw8D6zCzhzRruyfvEfkVlZJ1aYPVGrhY7AkfVEOCv4xgXYzv7eN@vger.kernel.org
X-Gm-Message-State: AFuF++nqixEmPVoKANK9E/bNagAAazQl3gH+iPcqUCloZbnCkmWv7VmM
	WaJtZsXztf1nDEG1RzPzgyWPbyWC8BEfVooxOkf1kSbEUE4CNIKYvb6kc/VL2qsgBMc0vSfz3VO
	PkX7iYoQ8ooyAY+LWc+EJvCwoK8DLl17Bu8BoVbO/NGdKp2En2NrkZ5I0xpmGzxzKbL1Fdns=
X-Gm-Gg: AYBFou0ffoOypl+5mRgED8nQ4t81MR0DfkKE6S0xb3l3bzx7BW315upZFTVRDTULalA
	qxv1XSwSMF+qQ7UZ6THgb5lhllkwsSEhXlRfEZIDyOfQMzMWd3q+SUpWNOnbhDtzY4m/4hDtqbb
	T0rLlHSDajnVCBOtKvMqIp7QIttcV2HPqcq+6VhPI9hp1Ld5IGegxfY/kfBWEDjxG6m4759SgCU
	pU4DF0x9BzcyjD/HWER2l+918z6nFe8uaBJklb0dgFnEVoGFGyR+rDdfXHaWvxB/lL81U5qkOXv
	wevdZMSdIRp2+YpjIEL0xEie7VOcI2Uruco3UiqVTBsoUK7k0KDfUfkdZ2OI9F7iTFW3JOVWIRv
	S7HHumYdGxDds1WveFYMoH40PXFmLgIOjECNj/Fxj
X-Received: by 2002:a05:620a:40c1:b0:934:ab73:ac53 with SMTP id af79cd13be357-93bb7273a53mr662075285a.0.1789588535447;
        Wed, 16 Sep 2026 12:55:35 -0700 (PDT)
X-Received: by 2002:a05:620a:40c1:b0:934:ab73:ac53 with SMTP id af79cd13be357-93bb7273a53mr662068285a.0.1789588534884;
        Wed, 16 Sep 2026 12:55:34 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123bddd40esm33094356d6.4.2026.09.16.12.55.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 12:55:34 -0700 (PDT)
Message-ID: <52e23047-5e50-43e1-935c-be536dc0bc75@redhat.com>
Date: Wed, 16 Sep 2026 14:55:33 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v4 02/10] smb: client: validate minimum PDU size before
 smb2_get_data_area_len()
To: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
References: <20260913214510.3071370-1-sorenson@redhat.com>
 <20260913214510.3071370-3-sorenson@redhat.com>
 <0b3d295a3f9ada22c99ac4e49b935106@manguebit.org>
 <6a11c41e-d636-4051-9b89-95186eb8e280@redhat.com>
 <61c3e91f49dd33c4acc172eb95730d31@manguebit.org>
Content-Language: en-US
From: Frank Sorenson <sorenson@redhat.com>
In-Reply-To: <61c3e91f49dd33c4acc172eb95730d31@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 9/16/26 9:22 AM, Paulo Alcantara wrote:
> Thanks.  Please also check if you could replace some of the cifs_dbg()
> calls with cifs_server_dbg() or cifs_tcon_dbg(), respectively.  It could
> be useful to log the hostnames or UNCs from such broken servers.

I can replace all the cifs_dbg() calls in smb2_check_message() easily,
and in parse_server_interfaces() with just a little work, but the others
would require plumbing in either the server or ses variables to the
functions.

I'll change the cifs_dbg() I'm adding in smb2_check_message, and
then make a couple follow-up patches to convert the existing ones.

Frank
-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

