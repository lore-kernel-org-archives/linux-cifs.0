Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794617931;
	b=u1siptgha1Xz3jyYgWrFjk5L8a32msveDiqH4x33lbHNkv9CGr9dOC7Q69T+Og9vXH+B
	 9tlljqMy2T1BBjJxIxa4ud+5AgRqNcKn8ZUA48W4ToLlBwMYCQdF6XPo5WiRdl3ldBaqR
	 kkq26RoiCptUD7VlR6Kvbld95LuaGX+6X0tfHmOcaxBjI7vJOTJAFz6MMwxb86K4WfYre
	 FrbPZoVzJP7cYqRd2ltDr7RStz2rIn4uLH8FP+kH4no7Zs4/Torh+xUSLqbvQMDWvr9jm
	 wckndkwermMYb6j/45ntC2z2uCC6GlCR4/bevHPgt46ciKY9OebQlMkMHqiLnGLb71w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794617931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:X-Mailer:
	 References:In-Reply-To;
	bh=crOpJ2cqOy+GjGG0L4IaOXRwYaty5nWl+NmdzCXk0qo=;
	b=svqkM7BRwYHuEluhT/57RDoblUELxM6Wv1+opmpcoB0c2FGCQcDX24lsWbLzTln5ND+b
	 Pnh3+ogP/hy3H8y0Wv+6ux4h+P5MjUORUBDiMvNL4jn8f3QDgBfG/SHWjUnQVa0xOQ2po
	 egTwD65uUgn8ZtcPYGvKNuBGGOibObTM2CpGn+vP6Tl6YY8MQNNYwpQD7lWPgBzudKCy+
	 KgEXxzTGb6CSbXZN0nwO+rrKFOzCrkakxeHoVDU2M6VRv0hRYd872WMRHl1LTEt2bujAZ
	 mx8hWODNtmRU2tlSiuoO/27n69yaGfVvnRfQKUoTnunhhdIwbXDznIJxdJQiqev5Xpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="M/qg9xkW";
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4877606A334
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 00:58:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4877606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M/qg9xkW
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so2030637f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 16:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794617929; x=1795222729; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=crOpJ2cqOy+GjGG0L4IaOXRwYaty5nWl+NmdzCXk0qo=;
        b=M/qg9xkWolKuD5YqNDfw+VHAlP0rrU7QaaJLRpncd01ZY/EOuRZU3xnWy4NAyAAt9Z
         dMT2k4F8LmSOvGEXcfs8WHpPdX2WOFnWoFPkUpxjp+JdYsGYKH45yzDNo/W+hcnG23Ud
         LQPcA0dt2kPo5oIAme/wADlCZg5FilYxwXcmBOsko0qMUY1wjtBmPOXXDG/SSMX8pWuF
         o+SigH5SSxJhFMuzrhdnIZBXxT/+9FBC1hcwHgV0fBr5VjCZu5vau2jLRC+DKnaTNAgS
         y0StImCtWyH1Z0Ic5SFtnqcSE4bk1STutneW9FQhSQG0IHS8X/V0jhnPWZ55FWT6qtwe
         /PsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794617929; x=1795222729;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=crOpJ2cqOy+GjGG0L4IaOXRwYaty5nWl+NmdzCXk0qo=;
        b=pS9GpeUmJTE2gl8BalIejAS4uf+8MUxcL5v5/TvQwy7pip40TIDcHCRm/NSYx327ht
         aUSlp2CJwSeGn86kjGe3Y8dV9KLVmugf8V0EwXAg6AIXRK5g5Z2R78sJTUTpLtLYU23n
         G0wTS1/4ApBrwdytLBOmNIxMxUO2ZHeObmCcWLzEyIbp0wt2tGB86gPvmoAZFPht5OIS
         FTjG+h9L9R80hQ2zk1K5tM/nvBwepOFR4h3imS6wOUaBXblRKyldtLImwsawRBZ97Tk1
         1M9sMY0wCBOWRud06BQ/5vKS6QOz1907GNtlhQ0qt1iFoZmboeagxcQdXenM2PDKQhxp
         Nz5Q==
X-Forwarded-Encrypted: i=1; AL+hErFaw6yU9U0bVP1dIlOwlVCkhbhsck9fPpah35BPhdruRoR47Af7Ev/H4cEcbIVzEEh/XmO1lsuwe4+/@vger.kernel.org
X-Gm-Message-State: APuU4Z/2Z/aEhJiZITEeQn/0n8eIQOLDu8dIREs+3bzlph3EvoZK2mdt
	ylRYjWsGFiVSQnYOT4F0QoCrZk16ncqwX+rHbFR1CltRTNcEbUz/OcAJLf1YH1m5
X-Gm-Gg: AYBFou0tT9Gt7edz16vu1bLScbb1E2fRr/SWfNs/zFbSupkpkT9J5cXZno77miOg63i
	blblgb3+sBQdC2YhcxqTzKxxGNBQ9+fu8kTjRaCAe4N+ADJS3OCup+58dpoI3tbI9H0gHFXhEw0
	dMt4EfFN6afS51e5Qtjow3HOk2x0fadbNUKsBjuuKN5HZr2f8yENdmDFkt9TZ5ePFYHwF30NhUW
	ap2EBGluyH3AF20/mPPwJW7BFnXAGqeIPimotvvnAMmRB9KP8hI/li/+j0gjYf6gFrMBbGGBuCX
	HEtEgIhNZOHYI56NWs7DXXTGVjEmWNl6SnJXsBdZoFrHIdiMRzh3jkb0Ni8wjl0kk2ZykAEVI1/
	J8yBZy+VNg2OHwOH6tar1mBLtvEFQELsuIByZAusAkEW2/j/yVVa2WmB3BnEiSUFH/McGvYrR+M
	IVCPstxnjZrLsHrJulFT1A7m5TK/Cl2gOVS4Hu/DrhzGnUl4keMHbZmjzjDA8qvkticU1igIWcc
	cyzxixw98LqY5vcJt9q2LUYUKSnr4setcGDjYcwvysvE367nOD9gSmFMElhsksdGu3bTOwsinye
	WpHn4tnP/Fldi8paCysBNZT7q40=
X-Received: by 2002:adf:e18f:0:b0:491:895b:4c02 with SMTP id ffacd0b85a97d-49c713ae4d2mr8542490f8f.23.1794617928804;
        Fri, 13 Nov 2026 16:58:48 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c607d12c4sm7604135f8f.41.2026.11.13.16.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 16:58:46 -0800 (PST)
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
 boundary=1074bd5dedbe45ba3972039c5e99707aeb3248ade54706ce7dc6c0e646f7;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sat, 14 Nov 2026 01:58:45 +0100
Message-Id: <DMUIYLA1N1WI.58082D8BPB0T@gmail.com>
To: "Namjae Jeon" <linkinjeon@kernel.org>, "koraynilay"
 <koray.fra@gmail.com>
Cc: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Tom Talpey"
 <tom@talpey.com>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>, "Hyunchul
 Lee" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ksmbd: decode and honor DOS attribute validity flags
From: "koraynilay" <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261113221610.392113-1-koray.fra@gmail.com>
 <CAKYAXd-X_u1CapKjpLPJF+ecUo5LN15Zj9T8bLguhyYWY7YrWQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-X_u1CapKjpLPJF+ecUo5LN15Zj9T8bLguhyYWY7YrWQ@mail.gmail.com>

--1074bd5dedbe45ba3972039c5e99707aeb3248ade54706ce7dc6c0e646f7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Sat Nov 14, 2026 at 1:26 AM CET, Namjae Jeon wrote:
> On Sat, Nov 14, 2026 at 7:16=E2=80=AFAM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Currently, when setting file attributes via FSCTL_SET_SPARSE,
>> FSCTL_SET_COMPRESSION or FileBasicInformation, ksmbd hardcodes
>> flags =3D 0x51 (XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
>> XATTR_DOSINFO_ITIME). This injects unrequested creation time and itime
>> into user.DOSATTRIB on disk, even though the client only requested an
>> attribute modification.
>>
>> Furthermore, ndr_decode_dos_attr() discards the validity flags on read
>> by reading them into NULL. When reading a file with an attribute-only
>> xattr (flags =3D 0x01, where create_time on disk is 0), ksmbd treats the=
 0
>> as a valid timestamp and reports NTTIME(0) instead of falling back to
>> the underlying filesystem's btime. Modifying any attribute via
>> set_file_basic_info() then clobbers the xattr back to 0x51.
>>
>> Fix this by:
>> 1. decoding da->flags in ndr_decode_dos_attr() and only updating
>>    create_time and itime if their validity flags are set (in
>>    smb2_update_xattrs() and ksmbd_vfs_fill_dentry_attrs());
>> 2. reading existing attributes and only setting XATTR_DOSINFO_ATTRIB in
>>    fsctl_set_sparse(), __ksmbd_vfs_set_compression(), and
>>    set_file_basic_info() so unrequested timestamps are not injected.
>>
>> Reproducer, with /tmp as the local filesystem folder exported as [test]
>> in ksmbd.conf and /mnt as the smb folder mounted with mount -t cifs:
>>
>>   mount -t cifs //127.0.0.1/test /mnt -o username=3Duser,password=3Dpass
>>
>> test with sparse (for compression, use chattr +c instead of fallocate):
>>
>>   echo data > /tmp/sparse.txt
>>   chmod 777 /tmp/sparse.txt
>>
>>   stat -c 'Local btime (%n): %w' /tmp/sparse.txt
>>   getfattr -n user.DOSATTRIB -e hex /tmp/sparse.txt
>>
>>   # punching hole via CIFS triggers FSCTL_SET_SPARSE
>>   fallocate -p -o 0 -l 4 /mnt/sparse.txt
>>   getfattr -n user.DOSATTRIB -e hex /tmp/sparse.txt
>>
>>   stat -c 'CIFS btime (%n):  %w' /mnt/sparse.txt
>>   smbclient //127.0.0.1/test -U user%pass -c 'allinfo sparse.txt'
>>
>>   # evict cache so btime is read fresh again
>>   umount /mnt
>>   mount -t cifs //127.0.0.1/test /mnt -o username=3Duser,password=3Dpass
>>   stat -c 'CIFS btime (%n):  %w' /mnt/sparse.txt
>>
>> which prints:
>>
>>   Local btime (/tmp/sparse.txt): 2026-11-13 21:13:27.167926440 +0000
>>   /tmp/sparse.txt: user.DOSATTRIB: No such attribute
>>
>>   # file: tmp/sparse.txt
>>   user.DOSATTRIB=3D0x000004000400000051000000200200000000000000000000209=
542d3b373dd01
>>      0x51 =3D 0x1 | 0x10 | 0x40 -----^^         |      unrequested --^^^=
^^^^^^^^^^^^^
>>    (ATTRIB | CREATE_TIME | ITIME)             |   creation time =3D btim=
e
>>                                      SPARSE --^
>>   CIFS btime (/mnt/sparse.txt):  2026-11-13 21:13:27.167926400 +0000
>>   [...]
>>   create_time:    Fri Nov 13 21:13:27 2026 UTC
>>   [...]
>>   CIFS btime (/mnt/sparse.txt):  2026-11-13 21:13:27.167926400 +0000
>>
>> test with setmode:
>>
>>   echo data > /tmp/attrib.txt
>>   chmod 777 /tmp/attrib.txt
>>
>>   stat -c 'Local btime (%n): %w' /tmp/attrib.txt
>>   getfattr -n user.DOSATTRIB -e hex /tmp/attrib.txt
>>
>>   # modify attribute via CIFS
>>   smbclient //127.0.0.1/test -U user%pass -c 'setmode attrib.txt +r'
>>   getfattr -n user.DOSATTRIB -e hex /tmp/attrib.txt
>>
>>   stat -c 'CIFS btime (%n):  %w' /mnt/attrib.txt
>>   smbclient //127.0.0.1/test -U user%pass -c 'allinfo attrib.txt'
>>
>>   # evict cache so btime is read fresh again
>>   umount /mnt
>>   mount -t cifs //127.0.0.1/test /mnt -o username=3Duser,password=3Dpass
>>   stat -c 'CIFS btime (%n):  %w' /mnt/attrib.txt
>>
>> which prints:
>>
>>   Local btime (/tmp/attrib.txt): 2026-11-13 21:13:27.195647069 +0000
>>   /tmp/attrib.txt: user.DOSATTRIB: No such attribute
>>
>>   # file: tmp/attrib.txt
>>   user.DOSATTRIB=3D0x000004000400000051000000210000000000000000000000f6c=
f46d3b373dd01
>>      0x51 =3D 0x1 | 0x10 | 0x40 -----^^       |        unrequested --^^^=
^^^^^^^^^^^^^
>>    (ATTRIB | CREATE_TIME | ITIME)           |     creation time =3D btim=
e
>>                                  READONLY --^
>>   CIFS btime (/mnt/attrib.txt):  2026-11-13 21:13:27.195647000 +0000
>>   [...]
>>   create_time:    Fri Nov 13 21:13:27 2026 UTC
>>   [...]
>>   CIFS btime (/mnt/attrib.txt):  2026-11-13 21:13:27.195647000 +0000
>>
>> After this patch, the outputs should be:
>>
>> sparse:
>>
>>   Local btime (/tmp/sparse.txt): 2026-11-13 21:20:25.856425751 +0000
>>   /tmp/sparse.txt: user.DOSATTRIB: No such attribute
>>   # file: tmp/sparse.txt
>>   user.DOSATTRIB=3D0x000004000400000001000000200200000000000000000000000=
0000000000000
>>           0x01 =3D 0x1 (ATTRIB) -----^^         | no creation time --^^^=
^^^^^^^^^^^^^
>>                                      SPARSE --^
>>   CIFS btime (/mnt/sparse.txt):  2026-11-13 21:20:25.856425700 +0000
>>   create_time:    Fri Nov 13 21:20:26 2026 UTC
>>   CIFS btime (/mnt/sparse.txt):  2026-11-13 21:20:25.856425700 +0000
>>
>> setmode:
>>
>>   Local btime (/tmp/attrib.txt): 2026-11-13 21:20:25.976415893 +0000
>>   /tmp/attrib.txt: user.DOSATTRIB: No such attribute
>>   # file: tmp/attrib.txt
>>   user.DOSATTRIB=3D0x000004000400000001000000210000000000000000000000000=
0000000000000
>>           0x01 =3D 0x1 (ATTRIB) -----^^       |   no creation time --^^^=
^^^^^^^^^^^^^
>>                                  READONLY --^
>>   CIFS btime (/mnt/attrib.txt):  2026-11-13 21:20:25.976415800 +0000
>>   create_time:    Fri Nov 13 21:20:26 2026 UTC
>>   CIFS btime (/mnt/attrib.txt):  2026-11-13 21:20:25.976415800 +0000
>>
>> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3") # ndr=
 decode/basic info
>> Fixes: f44158485826 ("cifsd: add file operations") # ksmbd_vfs_fill_dent=
ry_attrs
>> Fixes: 159e727f763d ("ksmbd: persist FSCTL_SET_SPARSE state") # sparse
>> Fixes: 0fb327626ad9 ("ksmbd: support file compression attributes") # com=
pression
>> Cc: stable@vger.kernel.org
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.3
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
> Can you check Sashiko's review comments ?
>
> https://sashiko.dev/#/patchset/20261113221610.392113-1-koray.fra%40gmail.=
com

Yes thanks, I am able to reproduce what sashiko said, I'll send a v2.

Best,
koraynilay

>
> Thanks.



--1074bd5dedbe45ba3972039c5e99707aeb3248ade54706ce7dc6c0e646f7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCaveyRQAKCRDmj22qf5IG
XLkAAQCk4kn1twGLgYRkTmV9wGbuAfIgxtpE0meq6TbIXtuOkAEAn/vMht7ADRhO
5f7Ep0WUqPBfRfstcbovrcOEm2I4KAU=
=oaAq
-----END PGP SIGNATURE-----

--1074bd5dedbe45ba3972039c5e99707aeb3248ade54706ce7dc6c0e646f7--
