Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385DD29C327
	for <linux-cifs@vger.kernel.org>; Sun, 30 Aug 2026 02:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788057832; cv=none; b=qBiHZXjNVIkRdEa72OQ7oYqRLJsXhDm2ZKzB1KmCjypzbM5047iqK4pvVFVGg+3fqN+m7GxW3WpNpFtP5T5cBxafVBCI4yudvd/3siJUVSK9ETv1J3HYaXJA/AFNKcP2+R1HsOD3feXVSLP4Mp+THdcpT6e/8h7uYDdzhkm4q08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788057832; c=relaxed/simple;
	bh=epQUHLTJ6lspUNYLo1CADgrhTDsITqwSc3xETJFfWKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zi0SBAWE1HPSBpG0ngMeAPa6aYsi34PN13bl3xnA0Dal+wqklfJz7miX99l6OIDvdD0O+08azCv8ptTIuK1wWMbrDyGOaYc8D8nIXYqt+ViaBH+3UTzUGGMFyIO3a1dk+M2N0SGCTBGid5vztlYMCRiUJqWb9xa73K8JmYlgtTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RafPYI0D; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=efr5VQr3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RafPYI0D";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="efr5VQr3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788057830;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTemELdXqVG41Nq1q1zZeAEWsWh+9e0ynY3SaKub2o4=;
	b=RafPYI0Dpllj6HTuiujLkWYeoP6wLE3R3o9MD9rdLj2hy6G+hS+8fw0s9ctzGw/TllVoBy
	7AnZc4A6PATPw/Opn+dxATYFlPGbD5OUL5v3MXe0ti7yZm3AxQX9I+124mC9BxpeWsYJf+
	mGWWG7zFfQ8+O37u1ZDHBbwFvzGuDhI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-lM7ocRqjPAmu7cE_AnGr7Q-1; Sat, 29 Aug 2026 22:43:47 -0400
X-MC-Unique: lM7ocRqjPAmu7cE_AnGr7Q-1
X-Mimecast-MFC-AGG-ID: lM7ocRqjPAmu7cE_AnGr7Q_1788057827
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-939281526e1so34560385a.0
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 19:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788057827; x=1788662627; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZTemELdXqVG41Nq1q1zZeAEWsWh+9e0ynY3SaKub2o4=;
        b=efr5VQr3L69gM0LXtU4eIencisDmHMbGUMkMzrjnImjgDZK/u3agini32dWZKNVUJg
         QqXpfsr+qgWrXUy3ZSFE4hL2d86/97mmwNJr75BBw7xvKUZwqb4RMlPaAMlxgEu51Vo/
         oAXoTLlYL9D/v5ctHHMEn36uSjDa238UlZsFU0t/fFlMcHHh8awESgvxfZcfb0zMkAj5
         1f2EOGo0E1MkMSk/SRJRknRdprLtSE/p44egUWVSMpRl+RX9PK5+VPIY3g7h20osjXVM
         ZBUNKpBVEkJYR0hzQtciYOpTeltEUch6/vs9xBEKPtl3n7wh0t4kNf2ZzgKn6VsnHzl+
         8svg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788057827; x=1788662627;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZTemELdXqVG41Nq1q1zZeAEWsWh+9e0ynY3SaKub2o4=;
        b=TXCFR/fPwUe1CD8ZEeMYVgOgE7Jjtko0XGPkxuZ0/r/BRds+fdThqTUx7ln0CXDD3i
         1BBDi4Ked1NTl01vGVbwNxed23iB1KfBpoW5PKxOAEyz2Y+xG/Zds0efQ0Q+CNiWJ4Z2
         0Lt84dFswtXvq6zjii+PaQnSUeUwy5NE4NM3Nof/YfeZUiU0fuKuZb+Os3nDdqnh8KAU
         j19Fg2K1bnO9qCMiNqtyZyO9ZcgAeZixWmOxUl7sk8mfdYKayxNF6taibuOcn9M7nhBx
         +bcFohRfzgmPe9jef1J4umQSzhaGMh4uZq3JI/+3wfNwLX4m6OvW6WOwWLPbFzhxZnj3
         RCgQ==
X-Gm-Message-State: AFuF++k1lCftKTzSHJwGV9Xgp8xj5LubIHNmOaeeIbXW+eaaF8HgyqRq
	mwTjFYjARVEMA+rYhDGgn9LrWwk2DicYwdppA3NrV0rYdxISTMZRXWeQnPPZK3VcCN7NnfwfkK7
	4YGeUlUZZd1rbLsz8+0bi4GzY0/5He4mCTBS7vaFPI4PMFe0AImivgLlGfssjOKQ=
X-Gm-Gg: AR+sD10sI3MMCdw3xHyuvhxm7Dfhe6gTqsJDSnY1LyOiE1IF+lUmdFzD60NFnHdm1Zt
	7qfJbt/EVWwg0vPJS7sXc9Jtq5plDoSZ8l+6XNJKPBeVFHUTl04NiKoRy4B+5Fhyxl6dBZc+4Tm
	et3NtgAXR+W82c82mKo1dmU40DPiC24V/1uPi/u83NWTEL8VoKMR72iIp5wpBUnvV8UAINRAOL0
	WAJazaJiGUgSSFHB0Zht64yGsP8akoZfXQmGpNMPPd9LxcxciahDdtzbW4zn6HDE+DQPrPUCdtC
	SslL5EJLBFuIf/Wm+Ls6qExiRIUeDj6jId7l8X2Mr9YxoDJE2WQOT26/+Hkl4SYikLfs6s3hEDU
	mR7gzH/z/7hi3bPt17aBpA6iIdSSRlElm4gjaYnhv
X-Received: by 2002:a05:620a:178f:b0:939:31f0:4475 with SMTP id af79cd13be357-93931f0450cmr190784985a.32.1788057827076;
        Sat, 29 Aug 2026 19:43:47 -0700 (PDT)
X-Received: by 2002:a05:620a:178f:b0:939:31f0:4475 with SMTP id af79cd13be357-93931f0450cmr190782985a.32.1788057826507;
        Sat, 29 Aug 2026 19:43:46 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93918b0f825sm461342385a.40.2026.08.29.19.43.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2026 19:43:46 -0700 (PDT)
Message-ID: <bb4993ee-c7e7-4808-a7fe-05d70b90b06e@redhat.com>
Date: Sat, 29 Aug 2026 21:43:44 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v3 02/11] smb: client: validate PDU length before
 smb2_get_data_area_len() struct access
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org
References: <20260826153147.4112943-1-sorenson@redhat.com>
 <20260826153147.4112943-3-sorenson@redhat.com>
 <CAKYAXd_1jw417=uA-1apBR4SQfkGCJX9Amj-uJuxfPhaqdJzeQ@mail.gmail.com>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd_1jw417=uA-1apBR4SQfkGCJX9Amj-uJuxfPhaqdJzeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/29/26 5:31 AM, Namjae Jeon wrote:
>> +/* Enforce: smb2_min_pdu_len[x] != 0 for every x where has_smb2_data_area[x]. */
>> +static void __maybe_unused smb2_check_min_pdu_len_table(void)
>> +{
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_NEGOTIATE_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_SESSION_SETUP_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_CREATE_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_READ_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_IOCTL_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_QUERY_DIRECTORY_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_CHANGE_NOTIFY_HE]);
>> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_QUERY_INFO_HE]);
>> +}
>> +
> I don't understand why this helper is necessary, and I don't prefer it.

Understood.  I'll eliminate it in the next rev.

Frank

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

