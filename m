Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74002FBE1F
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786105521; cv=none; b=dD3rqOnmg1FDRvkAcC/RfT5unK5u/mYNyTKsa/qyHJEkqMjJm81cbBTptZO0M4G4M7V+bz7Dyl5ka3gtLTa+UlwnSfN7oRUbuBv6Hlk9boUxshCuTxVgOnpOYJhORQEFzJV9nnCLfCD462tLX4lArYLKwEpQc0vD9vZPtnhewYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786105521; c=relaxed/simple;
	bh=I2dGuc5lqM8srFqFQVTHagVKG21e0bC0+QKM4IIraJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsMoM5w0cnJ9lmzfTw5eJIpZpO2nf89NgFR1kw5VE9C3p4qQrqRtveBtV3ZfTT69sT1Z5n6BqImWh3cxiE0+TWsRJ99L+X97t+cSc1t4Qr4CsFeCcqtycexsC3B3XS5YjidBwwOgOjwT64VMkyi0cutyypPV7wGSiCtEE+zcDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=eJ0VGc6O; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="eJ0VGc6O"
Message-ID: <8231ce4e-2a6f-4177-a7e3-5c210ae9a44a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786105507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zY3Wb2ykZjQJCbFlthjZxGshlIVv4gCa+mT7GjgLYCc=;
	b=eJ0VGc6OwDKmosqkn2iQIfTs/ohtlnNKIUICGxxePa33+6EbjTjpbK1TF0uNBmfWPl0uoF
	JbZE/4/ODvloMrBOrjl3Df8buxsygLeAr4JsavMj4hcGrWv6CkqbxwIidIAAnIZtA1QW6l
	8FURERFlIntw0480OGRUpSwNRg5VUODWY9cin0jkTSR9rtpT5p4tjH+nMEmUg9L0B/7Rdx
	KgYRW9n9XdINI4szMKFPe2IlmqOrIagouByr8sXH/s8DI8XuEOJUOj2lGy3OWjaPzwnVGL
	liklF6MQ0ceaPO2qiuZDxnTYMIBG3FaEVyBgjPaPjtimFyogLrnv0G4gRADXqg==
Date: Fri, 7 Aug 2026 20:24:18 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Fwd: ksmbd NTLM challenge blob heap buffer overflow (pre-auth)
To: vova tokarev <vladimirelitokarev@gmail.com>, linkinjeon@kernel.org,
 stfrench@microsoft.com
Cc: security@kernel.org, linux-cifs@vger.kernel.org
References: <CAGBKPgMzL+67L=wrKoCoOq-OQWW1enRLYUtUTHwcPSZ1vt0T8w@mail.gmail.com>
 <CAGBKPgOX-cc8FkeUfBZvUFEABH6dMmKj28jv1w+xatn4+dvYQg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAGBKPgOX-cc8FkeUfBZvUFEABH6dMmKj28jv1w+xatn4+dvYQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi vova,

I could not reproduce the issue using your poc. I am not sure if I 
missed any steps.

Below is the information about my test environment:

- kernel: v7.1, CONFIG_KASAN=y
- Architecture: aarch64
- Linux distribution version: Fedora release 40 (Forty)

Below is the log after running the poc (indicating the poc ran 
successfully), but there are no error messages in the ksmbd dmesg output:

```
./poc_ksmbd_ntlm_oob 192.168.53.211 445
=====================================================
   ksmbd NTLM Challenge Blob Heap Overflow (RV-W1-001)
   Pre-auth remote: SMB2 SESSION_SETUP, no credentials
   Overflow: ~1620 bytes past kmalloc-512 boundary
=====================================================

[+] Connected to 192.168.53.211:445
[+] NEGOTIATE: status=0x00000000
[>] Sending SESSION_SETUP with NTLMSSP_NEGOTIATE
[>] Server will build challenge blob with its long netbios name
[>] If name > ~47 chars: blob > 448 bytes = heap overflow
[+] Response: 290 bytes, status=0xc0000016
[+] STATUS_MORE_PROCESSING_REQUIRED -- server survived

[*] Check dmesg for:
     BUG: KASAN: slab-out-of-bounds in ksmbd_build_ntlmssp_challenge_blob
     or: Unable to handle kernel paging request at <name-derived address>
```

On 8/7/26 18:34, vova tokarev wrote:
> Hi,
> 
> It's been almost two months since I reported this, and I haven't heard
> back. Reaching out to you directly as the ksmbd maintainers.
> 
> The bug: ksmbd_build_ntlmssp_challenge_blob() in fs/smb/server/auth.c
> copies the netbios name (UTF-16LE) into TargetName + 4 AV_PAIR entries
> with no check against the 448-byte MAX_CIFS_SMALL_BUFFER_SIZE response
> buffer. A netbios name > ~47 chars overflows into adjacent kmalloc-512
> objects (up to ~1620 bytes). Triggered pre-auth by any SMB2 client
> sending raw NTLMSSP_NEGOTIATE (no SPNEGO).
> 
> ksmbd accepts names up to 255 bytes via netlink with no enforcement of
> the 15-char NetBIOS limit.
> 
> Confirmed with KASAN: slab-out-of-bounds in
> ksmbd_build_ntlmssp_challenge_blob. Full PoC and KASAN output in my
> original report.
> 
> Thanks,
> Vladimir
> 
> ---------- Forwarded message ---------
> From: *vova tokarev* <vladimirelitokarev@gmail.com 
> <mailto:vladimirelitokarev@gmail.com>>
> Date: Fri, Jul 3, 2026 at 6:01 PM
> Subject: ksmbd NTLM challenge blob heap buffer overflow (pre-auth)
> To: <security@kernel.org <mailto:security@kernel.org>>
> 
> 
>   Hi,
> 
> ksmbd_build_ntlmssp_challenge_blob() in fs/smb/server/auth.c writes the
> NTLM challenge blob into a 448-byte SESSION_SETUP response buffer without
> checking the size. With a netbios name longer than ~47 characters, the blob
> overflows up to ~1620 bytes into adjacent kmalloc-512 objects.
> 
> The trigger is a pre-auth SMB2 SESSION_SETUP with NTLM Negotiate. (this 
> works with No credentials) KASAN confirms slab-out-of-bounds writes; 
> corrupted adjacent data
> causes kernel crashes at netbios-name-derived addresses.
> 
> Affected: Linux 5.15+. Confirmed on 7.1.0 (aarch64) with KASAN.
> 
> Attached ZIP: report, userspace PoC (poc_ksmbd_ntlm_oob.c), KASAN output.
> 
> Suggested fix: reject blob_len that exceeds available response buffer space.
> 
> Thank you,
> Vladimir Tokarev

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

