Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C987348C63
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 13:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779198828; cv=none; b=Ve4n2mKA5vshrYkI24YsxqFp1z3SstWGfApavV3psBEpYJGxyiQ3IoSUs8zEPvp2nhLHluvlKq48R+vAA6pOXSP9zvsCqTBkJSd2juwbGWElamvXFCLBwQfV2dXdvpkfA1U57h8cQiCTmBpZkpjljLwsHdhQPNET0hxtNJIyfAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779198828; c=relaxed/simple;
	bh=yZ0hUkLceswbWWJhOCp//9DAZjjG2YVuVXcdUkfxHSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0xY8PC4bFmXBu8l6YmguS5JNVBOu1dpmIgrAwZCoMuGOndqjZ1PxrQ1Un9wQohIRYYXki/DfzhwF6yI2G9utwc/ao81hakIQSzOvwh2pWkd8/eWF8v9b8tT/od/Ne+C1Uc27cqHhWzLLu3iSTpTJqlzi8bPAvLkKBfyvUkwbdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=KzmzhsTT; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="KzmzhsTT"
Message-ID: <f957b03c-ce73-4425-873a-0f4bd5673b76@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779198821;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iXzKKT0/KFjfCDKl76GW8cjnL3fv2M3FPDk+OFCgSu8=;
	b=KzmzhsTT+tKCW3XRF2KlAQtNE8Hw0lOzo7/t/EsO9Eo7upNcuBFgm32IrXi78wZrcEyBbF
	TTckWbcLTh4x/AQHX9nsDYZW9Jr5xB+ok8jx6Ts/O5DN8BCAfEuXoWmxaktwweiVy74IUC
	th8xAFvl92b5nqWyNhEcVSrjGnh7agToO/lBZAaNbLn5tk7gSxu9eOZvPEo8XDxVPk4IaU
	GF6l4TJBEaLHssUY7ADAU7BQ1z9ZeHE8qcjF9oLHbM9f2J0LDWhetQjEWuvUe2wfIAO99w
	1/zzG/5N66ptedENn8AXmeKCUKbaNJZI1+CjwFAgKWmoc+0Ik/c/xYnIIKO2hw==
Date: Tue, 19 May 2026 21:52:54 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when
 close
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>, Huiwen He <hehuiwen@kylinos.cn>
References: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd_JEGF8X314cR3czBkcBAj-Z6yv6twYMPNFPVNB-UVbMw@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd_JEGF8X314cR3czBkcBAj-Z6yv6twYMPNFPVNB-UVbMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

`S_DEL_ON_CLS` flag only triggers deletion when the file is closed.

I also checked the Samba implementation, `S_DEL_ON_CLS` corresponds to 
Samba's `initial_delete_on_close`, and `S_DEL_PENDING` corresponds to 
Samba's `delete_on_close`. Samba promotes `initial_delete_on_close` to 
`delete_on_close` in `close_share_mode_lock_prepare()`.

If my understanding is incorrect, please let me know.

On 2026/5/19 20:55, Namjae Jeon wrote:
>> +       down_write(&ci->m_lock);
>> +       /* Promote S_DEL_ON_CLS to S_DEL_PENDING when close */
>> +       if (ci->m_flags & S_DEL_ON_CLS) {
>> +               ci->m_flags &= ~S_DEL_ON_CLS;
>> +               ci->m_flags |= S_DEL_PENDING;
>> +       }
>> +       up_write(&ci->m_lock);
>> +
> Why do we need to promote S_DEL_ON_CLS to S_DEL_PENDING here?
