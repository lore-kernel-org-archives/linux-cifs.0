Received: from mta-outp-cfd-1.case.edu (mta-outp-cfd-1.case.edu [129.22.103.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC4F328B62
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=129.22.103.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784820153; cv=pass; b=Io++g9wSuyGnE8N8L8+dU4C953AQ02kWlptDlqtbDz2jXv29gvcFPGHPtbdgszYHBtilOL4STM6ppdihB3zYXL++C5DyLi+jHqE8SjdGysUy5U8/9SCgmP1dr4ycpC/aM6S0QXNrp6MJAJ/qnnS9XWOF6g1uMMJOSbZYbcGmOzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784820153; c=relaxed/simple;
	bh=8+aighc15BvkODcWSrNWjFd6CGTfRCT3fUT4xN9L3dk=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=D+DRel/pgJVeRt63pejdOivr+fVJPUQOVeq5iH3Xa+xWlFk6OSDGYEZvdG6ekGcvm58FtvCMqTWDcatnfSpIvvaPl1KVq5nN3QtQ6WBbfUFyPcklLogtOAw8OO16PQpp01loe0QR9fe1jhem8VJFXqGExpzA/fEHM5lJy9WR1jM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=case.edu; spf=pass smtp.mailfrom=case.edu; dkim=pass (2048-bit key) header.d=case.edu header.i=@case.edu header.b=VfxC99/B; arc=pass smtp.client-ip=129.22.103.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=case.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=case.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=case.edu header.i=@case.edu header.b="VfxC99/B"
ARC-Filter: OpenARC Filter v1.3.0 mta-outp-cfd-1.case.edu 54FDC4C4
Authentication-Results: mta-outp-cfd-1; arc=none smtp.remote-ip=129.22.103.196
ARC-Seal: i=1; d=case.edu; s=cwru-mta; a=rsa-sha256; cv=none; t=1784819797;
	b=cYAjQeJua6Jw+/dTSI69vSrXxhllujn0tOJ6pYSr9jksXL0Hc0rUBlb8BsC2itX8Buov
	 N+a3TRI2KoNKis+vcawQnCb92eUlKCpKx02V1/pbxfhjhcRPZAyu6rXWi0/mAcCdFE5kB
	 f8djxWPUvLPFd11lQ1CNfSRt6EfOF1LlNHp+4nmihSzCBLWZ6r3uqPSnNWAniaQBMsk+r
	 uFjGV+ad6oezZ2UpheKiFPy4ZVER/BUW6qmBAllEWd4bEI/OUtwt4iTwjifgMtqIVlRHm
	 24NCdVGb7ZJ9/+w+HeBBEEj0ZgR9CmvVHoBeg7uPcu1lhgREIBgp8dWDL/1XWEML3Qg==
ARC-Message-Signature: i=1; d=case.edu; s=cwru-mta; a=rsa-sha256;
	c=relaxed/simple; t=1784819797;
	h=DKIM-Signature:Message-ID:Date:MIME-Version:Subject:To:From:to:
	 subject:message-id:date:from:mime-version:dkim-signature;
	bh=8+aighc15BvkODcWSrNWjFd6CGTfRCT3fUT4xN9L3dk=;
	b=b4IWZ/IngYBipZysYUff42ZuPLjxaCGKe8b0gxiqUoswgXoN5DsAjWPh42M4SeZpPDfV
	 +iUwofV1pT98J9DpTTUO+jZnaOqict/L8/xhJioTRmHFVikQRiYFTlfVnqA2RPFGJCxRo
	 f20clELOUuRYQMxOULoubLGbUoXGuRDvxhLeN0gDq9mp05ul7IxghAUdTSIjPi34Piq3H
	 isZhwe8kWLTEezZgiaRRwHJd7dNC9xrtngMMwcC72uqcHh6CKuVEUioNlNkpV6poIsCg3
	 GjS/54QDMy/y6Cr+ZroXcFR1cyqFuOQEFN3J6Nw4T2Rf5ngEaZXPIC+c+DIziNRrpMw==
ARC-Authentication-Results: i=1; mta-outp-cfd-1; spf=pass smtp.mailfrom=case.edu;
	dkim=pass header.d=case.edu header.i=None header.s=g-case;
	dmarc=pass header.from=case.edu;
	arc=none smtp.remote-ip=129.22.103.196
Authentication-Results: mta-outp-cfd-1;
       spf=pass (mta-outp-cfd-1.case.edu: domain of case.edu designates 209.85.219.71 as permitted sender) smtp.mailfrom=case.edu ;
       dkim=pass (Good 2048 bit rsa-sha256 signature) header.d=case.edu header.i=None header.s=g-case;
       dmarc=pass (p=REJECT sp=Undefined pct=100 dis=NONE) header.from=case.edu;
Received-SPF: Pass (mta-outp-cfd-1.case.edu: domain of case.edu designates 209.85.219.71 as permitted sender) client-ip=209.85.219.71
Received: from mpv-out-cfd-1.case.edu (mpv-out-cfd-1.case.edu [129.22.103.196])
	by mta-outp-cfd-1.case.edu (Postfix) with ESMTPS id 54FDC4C4
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 11:16:37 -0400 (EDT)
Received: from mpv-in-ksl-1.case.edu (EHLO mpv-in-ksl-1.case.edu) ([129.22.103.243])
	by mpv-out-cfd-1.case.edu (MOS 4.4.8-GA FastPath queued)
	with ESMTP id EDA54377;
	Thu, 23 Jul 2026 11:16:36 -0400 (EDT)
Received: from mail-qv1-f71.google.com (EHLO mail-qv1-f71.google.com) ([209.85.219.71])
	by mpv-in-ksl-1.case.edu (MOS 4.4.8-GA FastPath queued)
	with ESMTP id RXX06689;
	Thu, 23 Jul 2026 11:16:35 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-907ca5abf1bso12793946d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 08:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=case.edu; s=g-case; t=1784819795; x=1785424595; darn=vger.kernel.org;
        h=content-type:in-reply-to:organization:autocrypt:from:references:to
         :content-language:subject:cc:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8+aighc15BvkODcWSrNWjFd6CGTfRCT3fUT4xN9L3dk=;
        b=VfxC99/BP8/2nC7pRQypolsHeSBQNZWYAFIL1ViOmIgEg7SH2kXpfpGiNajCtboGEk
         UMiXEfVLW+encZ9OVVuSvdFRtd2U7R29D5mtQ3c+3XjQHtrKRGxiR/nFy6zIsoan7u7z
         dPXJLNFiXUrwGdjkjcnuUWQLaCwsnqLeAYp8OLnYhJxyl71L/k0g+QRV38mvBfTgewmP
         RgcSQ4WrZBefLoknEdagYpXs5/CgHIdifIrwC4Rb6oIFD4JPdojwyoV+HCcipeuCeRMa
         5Pv9SMGBp+PjkDnFk2IOU56977VoQRQV2fH5MXLwdX+koaaSH1L4V7uGy77ojhy38MPq
         yufA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784819795; x=1785424595;
        h=content-type:in-reply-to:organization:autocrypt:from:references:to
         :content-language:subject:cc:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8+aighc15BvkODcWSrNWjFd6CGTfRCT3fUT4xN9L3dk=;
        b=ixFbgodKT2oOrQbRnLgoM6jK9hzyIzTvZJwhsxI9X8kE7/MiKo40Q8xRR7fUYSeFmo
         F18GAjA1+DAfkqdKddFpYluewS8tth+Ffzhvd6zk9G0zEgGsYdHCVBYszTSNRKhH3YAi
         dNs1JIt4DTcuwYNBaGqjz6nOV7t8KSH+PL0be64StKTT9PBoDOhpBXeZYaCfKBHz0YfN
         9MrGIHT2pUP0+PHx64t9xGWaJP3Ovw5kY8aw99X/lmtrfSoy1zBSns0l+Xi7UKfNA6be
         z2MGhsQ/Hovq1HbHJR5/Sk/6dBiXz7fXYQ8Eoozu4bxTj2SuDmnVg7QHJDbDHiJftd4c
         COUw==
X-Forwarded-Encrypted: i=1; AHgh+RqUMZSpn7cTrliZbSNqzFGUPu+4+7hVzofIOixIK5U9MZDZlfks01NDdkUhDx3QQsoaJP3G78X3ud8G@vger.kernel.org
X-Gm-Message-State: AOJu0YzmOrIgQ/Oa2gFEXQ36nN/KmV0agCxD/DK+L7dfTjzMXZsXbdRf
	1TsBo5JPgM8BLGH1aXPt3sVjfyjzwdBx4pB5/p8LFAu7HhT1CA3R+RN1A0YtGkNAPVtFS9gxk8J
	/GLRHxbX0TcAER3u1pIeGa6RYxBQhG2WBnhR1S1oqFnhakFN0wvn9n2v4dvAC4EVM
X-Gm-Gg: AR+sD10UGzhXxuvC8C4BnoYsYHBuuiXdkX2zIxzJvOl/CbRfanzx7aQMCo9ZJJHjTQV
	L4oJGVSYPWe4K55F2TUxcihAiGK4q7mIMvOsmqJctwTvXRuSUbJjqJRuHEdRtNTXc7msaqkm9iA
	7Hbt0XjLn9pwtWh7XvErtOq+/6k67SIbtMMaZ4yom5yTQ7KOhvHbG11PtVmakOkH9htkmtHgNNW
	ZRZAuHtTvsI1AopjbV+1z2pNw3OPd6GNiYmDzdVkA4hVLOAI8YvF3PIR9xP588wrZSr4imrl6oF
	s8GYQEp1n5FxHw1HEpBvG49lG1cuc5ixpq7F/HodoxRNDppkT4bM1Is1CTh3SuCRWopCjSJsyMx
	fx/POSxXdHcXp9YBG3glL2Q6IM01HV5ZO6y615/mVSE+BJxq4NORiNwKnwyocHV0QUFQ=
X-Received: by 2002:a05:6214:4199:b0:8fd:6de3:dd7c with SMTP id 6a1803df08f44-907ca8f97a9mr39086276d6.62.1784819794958;
        Thu, 23 Jul 2026 08:16:34 -0700 (PDT)
X-Received: by 2002:a05:6214:4199:b0:8fd:6de3:dd7c with SMTP id 6a1803df08f44-907ca8f97a9mr39085746d6.62.1784819794529;
        Thu, 23 Jul 2026 08:16:34 -0700 (PDT)
Received: from ?IPV6:2603:6010:dc00:1e:1dba:3b93:7cc9:dec8? ([2603:6010:dc00:1e:1dba:3b93:7cc9:dec8])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba9004aesm46818876d6.22.2026.07.23.08.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 08:16:33 -0700 (PDT)
Message-ID: <e7575f17-9546-452c-ad08-d908adeb72e5@case.edu>
Date: Thu, 23 Jul 2026 11:16:31 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: chet.ramey@case.edu
Cc: chet.ramey@case.edu, Marc Dionne <marc.dionne@auristor.com>,
        Jeffrey Altman <jaltman@auristor.com>,
        Steve French <sfrench@samba.org>, linux-afs@lists.infradead.org,
        openafs-devel@openafs.org, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Etienne Champetier <champetier.etienne@gmail.com>,
        Cheyenne Wills <cwills@sinenomine.net>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v2 2/2] afs, bash: Fix open(O_CREAT) on an extant AFS file
 in a sticky dir
Content-Language: en-US
To: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian@brauner.io>
References: <20260723140047.702495-1-dhowells@redhat.com>
 <20260723140047.702495-3-dhowells@redhat.com>
From: Chet Ramey <chet.ramey@case.edu>
Autocrypt: addr=chet.ramey@case.edu; keydata=
 xsDiBEEOsGwRBACFa0A1oa71HSZLWxAx0svXzhOZNQZOzqHmSuGOG92jIpQpr8DpvgRh40Yp
 AwdcXb8QG1J5yGAKeevNE1zCFaA725vGSdHUyypHouV0xoWwukYO6qlyyX+2BZU+okBUqoWQ
 koWxiYaCSfzB2Ln7pmdys1fJhcgBKf3VjWCjd2XJTwCgoFJOwyBFJdugjfwjSoRSwDOIMf0D
 /iQKqlWhIO1LGpMrGX0il0/x4zj0NAcSwAk7LaPZbN4UPjn5pqGEHBlf1+xDDQCkAoZ/VqES
 GZragl4VqJfxBr29Ag0UDvNbUbXoxQsARdero1M8GiAIRc50hj7HXFoERwenbNDJL86GPLAQ
 OTGOCa4W2o29nFfFjQrsrrYHzVtyA/9oyKvTeEMJ7NA3VJdWcmn7gOu0FxEmSNhSoV1T4vP2
 1Wf7f5niCCRKQLNyUy0wEApQi4tSysdz+AbgAc0b/bHYVzIf2uO2lIEZQNNt+3g2bmXgloWm
 W5fsm/di50Gm1l1Na63d3RZ00SeFQos6WEwLUHEB0yp6KXluXLLIZitEJM0wQ2hldCBSYW1l
 eSAoQ2FzZSBzdGFuZGFyZCkgPGNoZXQucmFtZXlAY2FzZS5lZHU+wl8EExECAB8FAkPi19EC
 GwMHCwkIBwMCAQMVAgMDFgIBAh4BAheAAAoJELtYafBk6nSrelkAn31Gsuib7GcCZHbv5L5t
 VKYR9LklAJ4hzUHKA49Z0QXR+qCb80osIcmPSc7ATQRBDrBvEAQAkK6TAOKBEM+EC4j6V/7o
 /riVZqcgU5cid2qG9TXdwNtD9a3kvA/ObZBO93sX59wc6Bnwo4VJxsOmMlpGrAjJsxNwg3QH
 akEtf8LXRbVpj5xStdmBdQZUhIQyalo/2/TZq5OijtddUQcL5cs70hTv/FpT3wUvr2Xr8rjF
 41IFEz8AAwcD/A0CZEGlzIrT5WCBnl6xBog/8vKiUCbarByat3d1mL6DbizvKNXQRTC9E/vE
 dENAWCQCjr75Bu55xT8n3SXGtWdDC5xmZ/P3OBYORP8yl8H8I1FIosWOFirbIeYdZPq8SPD1
 HL+EXo9zSiHVrrZRJ19ooCKKbSdXHFCY+aJG+0KZwkkEGBECAAkFAkEOsG8CGwwACgkQu1hp
 8GTqdKvjcACfZlkVCDwaz/NTO9cy3t69oWpVPNwAnRwe0qk/WL/gfhH346xh5B3HFbFN
Organization: ITS, Case Western Reserve University
In-Reply-To: <20260723140047.702495-3-dhowells@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------CxlVvhftc5dxjbET27xndGG5"
X-Mirapoint-Received-SPF: 209.85.219.71 mail-qv1-f71.google.com chet.ramey@case.edu 5 none
X-Mirapoint-Received-SPF: 129.22.103.243 mpv-in-ksl-1.case.edu chet.ramey@case.edu 5 none
X-Junkmail-Status: score=10/90, host=mpv-out-cfd-1.case.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A2D030A.6A623055.003F,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2016-11-06 16:00:04,
	dmn=2013-03-21 17:37:32,
	mode=single engine
X-Junkmail-IWF: false

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------CxlVvhftc5dxjbET27xndGG5
Content-Type: multipart/mixed; boundary="------------SH99zPIpueenVUjGfvttoHtT";
 protected-headers="v1"
From: Chet Ramey <chet.ramey@case.edu>
Reply-To: chet.ramey@case.edu
To: David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <christian@brauner.io>
Cc: chet.ramey@case.edu, Marc Dionne <marc.dionne@auristor.com>,
 Jeffrey Altman <jaltman@auristor.com>, Steve French <sfrench@samba.org>,
 linux-afs@lists.infradead.org, openafs-devel@openafs.org,
 linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Etienne Champetier <champetier.etienne@gmail.com>,
 Cheyenne Wills <cwills@sinenomine.net>,
 Christian Brauner <brauner@kernel.org>
Message-ID: <e7575f17-9546-452c-ad08-d908adeb72e5@case.edu>
Subject: Re: [PATCH v2 2/2] afs, bash: Fix open(O_CREAT) on an extant AFS file
 in a sticky dir
References: <20260723140047.702495-1-dhowells@redhat.com>
 <20260723140047.702495-3-dhowells@redhat.com>
In-Reply-To: <20260723140047.702495-3-dhowells@redhat.com>

--------------SH99zPIpueenVUjGfvttoHtT
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNy8yMy8yNiAxMDowMCBBTSwgRGF2aWQgSG93ZWxscyB3cm90ZToNCg0KPiBBcyBhIHJl
c3VsdCB0aGUgQmFzaCBmYWxsYmFjayBsb2dpYyBtYXNrcyBhbiBpbmNvbXBhdGliaWxpdHkg
YmV0d2VlbiB0aGUNCj4gb3duZXJzaGlwIGNoZWNrcyBwZXJmb3JtZWQgYnkgbWF5X2NyZWF0
ZV9pbl9zdGlja3koKSBhbmQgbmV0d29yaw0KPiBmaWxlc3lzdGVtcyBzdWNoIGFzIEFGUyB3
aGVyZSB0aGUgdWlkIG5hbWVzcGFjZSBpcyBkaXNqb2ludCBmcm9tIHRoZSB1aWQNCj4gbmFt
ZXNwYWNlIG9mIHRoZSBsb2NhbCBzeXN0ZW0uDQo+IA0KPiBIb3dldmVyLCB0aGUgYmFzaCB3
b3JrIGFyb3VuZCBpcyBnb2luZyB0byBiZSByZW1vdmVkWzJdLg0KDQpUaGlzIHdhcyByZW1v
dmVkIGluIGJhc2gtNS4zLCB0aGUgY3VycmVudCB2ZXJzaW9uLiBUaGF0IG1heSBub3QgbWFr
ZSBhcyBiaWcNCmEgZGlmZmVyZW5jZSBhcyB5b3UgdGhpbmsgLS0gc29tZSBMaW51eCBkaXN0
cmlidXRpb25zIHN0aWxsIHNoaXAgd2l0aA0KYmFzaC00LjIgLS0gYnV0IGl0IHdpbGwgYmVj
b21lIG1vcmUgY29tbW9uIG92ZXIgdGltZS4NCg0KLS0gDQpgYFRoZSBseWYgc28gc2hvcnQs
IHRoZSBjcmFmdCBzbyBsb25nIHRvIGxlcm5lLicnIC0gQ2hhdWNlcg0KCQkgYGBBcnMgbG9u
Z2EsIHZpdGEgYnJldmlzJycgLSBIaXBwb2NyYXRlcw0KQ2hldCBSYW1leSwgVVRlY2gsIENX
UlUgICAgY2hldEBjYXNlLmVkdSAgICBodHRwOi8vdGlzd3d3LmN3cnUuZWR1L35jaGV0Lw0K


--------------SH99zPIpueenVUjGfvttoHtT--

--------------CxlVvhftc5dxjbET27xndGG5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQR8ATX7CIqvbGbGULm7WGnwZOp0qwUCamIwTwUDAAAAAAAKCRC7WGnwZOp0q1ts
AJ9lHbB9KorRuGnv0zbi+/1FDyDO0QCeP0Ag7LXnUSG187Zn6EvbIxMvRsA=
=Q4MK
-----END PGP SIGNATURE-----

--------------CxlVvhftc5dxjbET27xndGG5--
