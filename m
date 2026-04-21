Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5322A817
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 13:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776777029; cv=pass; b=HPkO3rV+Dc5Ya3snffjflSh91ctBJ6KyOCtbU7+HbrnhjOX39Dx3NR2ugs/L+JLI6IttVos9EE5s7Iodmc3OlJtbAeWGACgpqGBLhMa4jMiRVoG24da7m79YAnW14CzgqWroGO5mzYzJGeyQZ/r2mThJqOioOqQ49ceUQwS0Tq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776777029; c=relaxed/simple;
	bh=n/ecjVxZIlo9oNHI4Tdg2IsEuomy3IMt9LqTq7Z2QPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G6Fj9QsV8BjiJhwQimKJ1m2aW5uBTIyuneIf1aelyLAqGDW2AlXvmg+jHVlsvA6OqDoXiVG0PMQAYYufxVcg6rzqYc1fYXW0yzUb2BYZoAqhyg9PkvLaOROm/W3yp2MGeYHkdAL1mRDAe0xaW7/4Xmd9pjfsm+/Vj5RjOvlocL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bz/i7sZ3; arc=pass smtp.client-ip=74.125.224.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bz/i7sZ3"
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-651bc83e74aso3442354d50.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 06:10:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776777027; cv=none;
        d=google.com; s=arc-20240605;
        b=MCtGkoX+idKqv5spHtaPomGTTLNeZx40vFi7azVrniIEzFaKSSgB86Jumu2HGjOgZs
         SAkI0OZWWBMokAKclgnuoNz78U0igAIWzuAU+fhKGHSFOXbXjcdmyR9pL4oAz2riOC9Z
         oB+vnnRIhtnyp/9rvQB3W8gL3X9IY9d4Vj3X+teGqRhdsiVYSMrZo9xAu/N4KoRwdhRk
         Gz/OmE/ka2Ep0uJMVNCyBKKc15+K+5FAcg4sf6V+z9s3HYew7vPBY9lRyztsVBx1ziVI
         n4QG8GfqlhrQqYcHIxlqUdnNkDHx4/10Xrl6pq3bFMMdYIWZtrDSzttc1QosyDvezkwj
         6sGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qLhX0h43niDz2msdmsxrq2bnS7G6Ss+DAtDx0EbLqTs=;
        fh=+J2Ej/q8uoMHMZbmFWHeRobXp+eMZfnMThi3ZZEk9to=;
        b=f/f6bEBLYkzPJYk1MKBDMzvcukB/GuOmlOCLH2nH/ct/NOJA3awiIZK7xkHP0GoVKf
         KmmT2iFqJovbA/XCIpN5PbI73OorBhZAtCOcar9SjifmqcyQWALNuxXtd73x7CrPw5fW
         YPBe4Zm49oIsoBcWLiowmOhTe9WohQxTzlc4fnu1+zf4aA2XnA1Vnrot2/yRTjLiZLy6
         gxhbWKYeSaMclaCMVb/QDbWcXR4jv1tjb5tqmUW3iXo0zFVb4gdQ1/erMBDBHvIRqj0y
         xR7U+QjYv5eAF7+Ma6t024Te137fci8P6IBxvHnTLUGN+tOqa3kvDUZ79ONMJzfsfhRR
         shIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776777027; x=1777381827; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLhX0h43niDz2msdmsxrq2bnS7G6Ss+DAtDx0EbLqTs=;
        b=bz/i7sZ3ESfHfqTBPc/ww3XYqa8Ki46qOHrZ3GcQjM91lNFcNGu3/3hF+d/EZhrf5/
         fXdqQII49QsoqxLWOeyg6PcgD8cx9WC/BjMYhzoFejefIwVWLa88E3VwVum/PbiO8jga
         Uvrxp934CHta15z3t3wqA+u/rb32MZH7mOXIM/mpOFu3fM2zrLe2VVh10q63/8zcNKcn
         1dniwjp0rvQQ4uesZvUiB7CKo54Oxcr0/CbBrgE2opSYACmDbDI0IUpuUzmm1gsGibTB
         zy+LJKeYk9wa2t4KIF7okzZRJVg0Rgw75ARbeUmEcQErqv2rkLvnnzE/Lv8p+AcxA7Tg
         00pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776777027; x=1777381827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qLhX0h43niDz2msdmsxrq2bnS7G6Ss+DAtDx0EbLqTs=;
        b=cEvUOAHzwmmDNt+I8h7irKakqBFbRkVs2+SXVzi7WVn+PTNPC6lzHl5StS6rXQmSKk
         CoFVj8IRT30K3XWw3WMK0xSv0bO6InAoW8xjNZq1OATQjNcVI3sHNmIDgUV36jOe6Twc
         pFXoDUK0mAZV7SaQAcJhhajry7eXYXDrw4k7zf9cLWsYHCzoW3TFXvo5yzpHLiZaltMb
         9j6W2bNhKhy2uFWFhWVONzgVMw9rsMFz3O0TpOM2dBoLSAHQEGlJ5wWGIJYXj9Zj3dhM
         q/xwyxzZSEirSZz4XsmcDwNY18byUjfROCMCTdZB0BKoXOXtoXP9dA+yONCX0O7w0srx
         TlSw==
X-Gm-Message-State: AOJu0YxBE81f7YTlZee6gWP9KIk6NzQs0AxvgttyndQ9ga0THvxu8Zcr
	4LtlNp5UW2HucTZQjxDL5WKXZTAAYdtEqh9LWM08CyFa9jgNe+x3rDVGrfFxq6kebjRTrtDW8FL
	HRXj8VMx+qAJuLWOuMQ/TJFlYsXdVj7Q=
X-Gm-Gg: AeBDiev0sB10x+bT9uwvU8i6D6eq3smYkZWD3lwtJEIaBZirwNV9C4sIJa2u7vCCaP8
	jX90fR+KW/OZFG0cFanCdUN8POEIrN5fOmIaplQxM8baJKk6MjQogb7E8P3WMrchEQC+NIio6+U
	N7TFEn9pciQQGohBX15k1YZ1j5FqZoUu480ndth2dBHs76pAHEJ9bs/HtFSyJ0tLkw+T0z8JEpE
	/1H0J/N9PObrBSKQmh6UehFaMngY/74tZ9rHydNZ9rJSpDzKlreK2UcbuaaumLWFc/49nBB4WZl
	QZeHBv99wRiFaS/XVluC/HKp35fwxTD5394Tci98TbRGY3ZF+Q==
X-Received: by 2002:a05:690e:43ce:b0:651:bd21:e272 with SMTP id
 956f58d0204a3-65310866564mr11892816d50.22.1776777026598; Tue, 21 Apr 2026
 06:10:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421170524.266984-1-ematsumiya@suse.de>
In-Reply-To: <20260421170524.266984-1-ematsumiya@suse.de>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Tue, 21 Apr 2026 06:10:15 -0700
X-Gm-Features: AQROBzDig4NL35bjPk6k6JlX3OyFSErPAoXBS0dKZ02PHiVw5XYwT2x_0CMAm30
Message-ID: <CAGypqWymOkBHF8o12TT7OsrBkwDd0qbEV5OFgd5Z=d3taE1AKw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix (remove) drop_dir_cache module parameter
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Enzo for fixing this.

On Tue, Apr 21, 2026 at 5:46=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Being a module parameter, it's possible to do:
>
>   # modprobe cifs drop_dir_cache=3D1
>
> Which will lead to a crash, because cifs_tcp_ses_list hasn't been
> initialized yet:
>
>   [  168.242624] BUG: kernel NULL pointer dereference, address: 000000000=
0000010
>   [  168.242952] #PF: supervisor read access in kernel mode
>   [  168.243175] #PF: error_code(0x0000) - not-present page
>   [  168.243394] PGD 0 P4D 0
>   [  168.243524] Oops: Oops: 0000 [#1] SMP NOPTI
>   [  168.243703] CPU: 2 UID: 0 PID: 1105 Comm: modprobe Not tainted 7.0.0=
-lku #5 PREEMPT(lazy)
>   [  168.244054] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS=
 rel-1.17.0-2-g4f253b9b-prebuilt.qemu.org 04/01/2014
>   [  168.244557] RIP: 0010:cifs_param_set_drop_dir_cache+0x7c/0x100 [cifs=
]
>   ...
>   [  168.248785] Call Trace:
>   [  168.248915]  <TASK>
>   [  168.249023]  parse_args+0x285/0x3a0
>   [  168.249204]  ? __pfx_unknown_module_param_cb+0x10/0x10
>   [  168.249448]  load_module+0x192b/0x1bb0
>   [  168.249637]  ? __pfx_unknown_module_param_cb+0x10/0x10
>   [  168.249882]  ? kernel_read_file+0x27d/0x2b0
>   [  168.250088]  init_module_from_file+0xce/0xf0
>   [  168.250291]  idempotent_init_module+0xfb/0x2f0
>   [  168.250496]  __x64_sys_finit_module+0x5a/0xa0
>   [  168.250694]  do_syscall_64+0xe0/0x5a0
>   [  168.250863]  ? exc_page_fault+0x65/0x160
>   [  168.251050]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   [  168.251284] RIP: 0033:0x7fcaa12b774d
>
> Instead of fixing this with some kind of "is module initialized"
> approach, this patch instead moves that functionality to procfs,
> setting a write op for the existing open_dirs entry, where
> writing a 0 to it will drop the cached directory entries.
>
> Also make it available only when CONFIG_CIFS_DEBUG2=3Dy.
Can you please let me know it needs to be under CONFIG_CIFS_DEBUG2,
I prefer it to be under CONFIG_CIFS_DEBUG as most distros
disable the CONFIG_CIFS_DEBUG2.
This parameter might be helpful in customer environments to mitigate issues=
 in
cases if we hit rare directory lease bugs which might keep dirs open.
Please let me know your thoughts.?
