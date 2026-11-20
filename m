Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795204640;
	b=mqOcAtTY8EpRks+rbAcO8DGAEAZpTQS+qNLUS8f4MRuxMxkTWSyMl60XFCEkqgxXBQ0B
	 OQZ1R9uhKyf5ZbA7z/rgQDrgNlk0j7tjENoGJFvwmbjyQ+Bg2Q6l1r2DokAFSaiIcfxGJ
	 eE4A/qiFomuBGuEoLuaE+YoCEAeSpNzXefOWvPrJqH1aPIxALmbw63G3HFxWcsbgYzVGE
	 xnlE2GY4NFoRdy6zqDYNnhTwtqVob7udwBmJ8DZND5V2jJKQnAdoLJ6s7Pi5iJ7gyEqXf
	 ko9JlJz3VVnmcrQMVc7ZKUM/jy9/aD6GV9TdNt4g+UVZkBc1U9JRG49Qox+UG3p5ivA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204640;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=bepP2SIrLZrZLh3YoUhcI7r4qP8FXfE4vnBTwIQ4Skc=;
	b=jN4wfUjR+LIr+V3x3wSX+s3Vpn9aWEZjIgjVqrdy+YJpRxpHSJ5DXPvJKWB780Ln7o71
	 zthETmcEuri2bRPccXTzPnO03yHhMTTQrpftHGur2djTVYsODZ/RX2oB0u4WUXG0ibyvr
	 c4o58/mhrXi4nAYs044qaUZAJRQHAp7zNugR/Cxgrs+3iLADHA30TSRc1irUYG2wtvP8N
	 1cuiEcoLZVWOFGbsm1xspis2IvllrPGts8SICJjp8/ZAdHMAKUB8RYxofpg3UyOOvFCL5
	 ovHOOCafmZN7exIRIcFWhVMaQ+k6TWlC0VNuSm2OMiKRYymlNyciiUX+hIxvXhuiCww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AyTB9L41;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1CF60A2605
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 19:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F1CF60A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AyTB9L41
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb702a7548so10774585e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 11:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795204632; x=1795809432; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bepP2SIrLZrZLh3YoUhcI7r4qP8FXfE4vnBTwIQ4Skc=;
        b=AyTB9L411sWeTLrB7sHYPusz60A/1/Nv/TJkQTNNIeffYmh5yaV9kxmJlFcKpU5ORq
         rEcgDnLB0ZviSU3SHZQDeZx4auT1Tbi2Bx6Hvn4840ApcbI0hJQbC4obcQdmLQDZ94s9
         sF850yLI25iBMPAfhk1lw6XgZG1G0JRQpdJO+Qh5O+DZbsKYCRx8VmR2BjML2uYw7RjI
         Ss/ozztQvFAL44SPp/zOhqrZMlvYwp3/C02wmdtBcneEI9GClXWjC0Wfz/UDJLLRi2uW
         /LfLhc6X5fTJFRgIBDtEGVYEQbRINXzgzQ+S7eQafxUJW8Urdx8bLpc+0oHF3lur40xH
         KVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795204632; x=1795809432;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bepP2SIrLZrZLh3YoUhcI7r4qP8FXfE4vnBTwIQ4Skc=;
        b=xQtM+R24XC9MtZ0lzFMv3/d48L83FwVe4zmWuSjOvmnVZEbXDbOQXlePpEir7R1a3+
         gOaT6vZEgAoTBVtNMGc/5kekCOf/mbV6Q99FsO0fOIOOnCEbB7nr7sXQCJm7IObqkTH0
         WAzFU+z08Md5TKaRt5iGCBVrnu5Hbf55E2ai4zioDX02R7Zt4a9k7wePhwfmF4iSQGCN
         08IBmXpnFXtrcadLrk0RjuQfMJW6B/DhI/Ev+n9wLof4q8BLOLdbrIafmEEilwCMBXXq
         tt1o4wN7NbhX5kD1FbgOZaOM6dw6Bm+3vqOQCowBXR+KYnYGozB0ce1KlfO/jqBaEBJ6
         VlGg==
X-Forwarded-Encrypted: i=1; AL+hErEr5PN6wqGuqwSg0Q9Jj75ymldsMopJfibuN6j2hsEQldgIHxxqGUPkzT9CwdgVbxnGbw/jNUimTwDO@vger.kernel.org
X-Gm-Message-State: APuU4Z/wSMp/QI23NRK8Mj3GKNK3qP0P/Q9LzkseDn/TGG6V5LCUe7b1
	lU2tWVOpAeaYr8YERANRdN0uxmJti9yl81BCefEMhRNA3Ss3/hunvlWo
X-Gm-Gg: AYBFou2wIXTpnffwvM/MEiRfcuMkjJzppby6iewyY4P1Pge0dq5f1dX810DIenX9DVy
	fBO8aQblPfkoBERYxIrRiG799cv0cAAwrkCYO2xk43wgEc5JfZfaAl2virFXPXrwDtVstfV6wna
	pHFbkh0FoZEHWbjX0Mk3LbIpFkCMW2ReMGb5pSRXyGCvO67Qk+7SkZTuemIsrkVD9EnIkOC0mMK
	vozj+s2qllbMPLKDHnUoB5TxxUwVNC14BUJZoGYWvXk9R98hzXtjqjfLRaXb5ANkQVHLjB9aYO+
	mIkxcDjl7A2Hzax5iMu3fHsQmRUU9cdeVItOSZeegdRrKKQEpiq6LrQ4wEjNIZ3mbbyrhmhNuog
	lYfpA6SN4zWv4keWDzw35Rl+Cd7PvMHZnSJ1NUcIrgBaE37iw9rPAxmpJVUtiM904GwnPjMQ34Y
	jWgkUdBRcfVo1Lwya8CMzvgOBnX8yLsKoH3rSWR8sH5Wnw8b9cRzT/sQb0NhqHrTHBZduQuW19R
	fjengyUNXTYksR6NpYzOkV2+OpXYVxdw0EneYOkzomRfcFXz87BqFTu5ACczQkneToDJ6Tvu13O
	KbKOuoAxlYlSB6nbR+u5bNHjgg==
X-Received: by 2002:a05:600c:638e:b0:4bb:6c5e:b006 with SMTP id 5b1f17b1804b1-4bb887e265fmr93789305e9.3.1795204631450;
        Fri, 20 Nov 2026 11:57:11 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm177401215e9.0.2026.11.20.11.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 11:57:10 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 20:57:05 +0100
Message-Id: <DN0AXFYCMGXO.1O5VDUA6GJCT4@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 03/10] ntfs3: make crtime user-settable using
 ptime
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-4-koray.fra@gmail.com>
 <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxjdEiuJMQxtSL8XrPYHSamtfMh+BM8kS1wj_PVME4JynQ@mail.gmail.com>

--0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 4:58 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Since NTFS supports user-settable file creation timestamps, map
>> provenance time (ptime) to NTFS file creation time (crtime) by using the
>> newly introduced ptime API (in commit "vfs: add provenance time
>> (ptime)").
>>
>> To do this, update ntfs_fileattr_[gs]et(), ntfs_getattr() and make it
>> persist to disk in ni_write_inode().
>>
>> The timestamp is now retrievable by using file_getattr() or statx(), and
>> is settable by using file_setattr() with the FS_XFLAG_PTIME flag.
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/ntfs3/file.c    | 20 ++++++++++++++++++--
>>  fs/ntfs3/frecord.c |  8 +++++++-
>>  2 files changed, 25 insertions(+), 3 deletions(-)
>
> Please don't change the unmaintained ntfs3 driver.
>
> If you want to include an ntfs patch work on the new fs/ntfs driver.

Huh, I thought ntfs3 was the modern and latest one by Paragon.
But apparently I missed some news[1][2] lol.
I'll use fs/ntfs for the mutable btime patch then.

Thanks,
koraynilay

[1]: https://www.phoronix.com/news/New-NTFS-Driver-Submitted-Linux
[2]: commit 1e9ea7e04472d4e5e12e58c881eaacfb3e49b669

> Thanks,
> Amir.



--0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCawCmEQAKCRDmj22qf5IG
XMFuAP4jbqqWLf0rzRDeTfZI93Ntri5exvb2a4tXBADewtwEHQD+MLXXfUDqNxpu
FJSnl3dfZi2d0aWeniR+psgoM+VAKw0=
=6Hcz
-----END PGP SIGNATURE-----

--0ce1f2737ac23ac54221dfe9ad89c8615ea720b53f7a9f6f6b271bd43f0e--
