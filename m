Received: from mta-outp-cfd-1.case.edu (mta-outp-cfd-1.case.edu [129.22.103.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922BE278E40
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 12:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=129.22.103.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747227077; cv=pass; b=ksRAhaU8a26/Sfc3GV7cmkvqZWk1z/PZ92Oxvv+qXMOG+PbpQZgg/TQpd/uWjAdmKvVsOUG6aUeXVI+R6/vMYRcpzb9/Q029L0OWOa0DoOhUmMq3l0o4gGFPWtJPq1flZoFWMJEPtfMwN6S/3RKXz53A5k/21VFliadm88J/cFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747227077; c=relaxed/simple;
	bh=ziBnVImEQka1k/5ArPVUpuK5Uv55pJxDufSS4gEWcPs=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pa7O7h7X2rG4W80wNBW6jd0ddpUlQf6pjK1uQ3ACgqMTtOkiUJQgqpbsWb7TXJlh2OQJx2JHo1qYtV4/mhqyX0MxdYgfcq1o2Kq/gbR2Fqmp0e1u3oiyJlGiIYzo9HTW9i+1T50X+vl4u19TilJkZmpNsRM/+VrKImGfepGIums=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=case.edu; spf=pass smtp.mailfrom=case.edu; dkim=pass (2048-bit key) header.d=case.edu header.i=@case.edu header.b=CCKy4DG9; arc=pass smtp.client-ip=129.22.103.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=case.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=case.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=case.edu header.i=@case.edu header.b="CCKy4DG9"
Authentication-Results: mta-outp-cfd-1;
       spf=pass (mta-outp-cfd-1.case.edu: domain of case.edu designates 209.85.219.71 as permitted sender) smtp.mailfrom=case.edu ;
       dkim=pass (Good 2048 bit rsa-sha256 signature) header.d=case.edu header.i=None header.s=g-case;
       dmarc=pass (p=REJECT sp=Undefined pct=100 dis=NONE) header.from=case.edu;
ARC-Filter: OpenARC Filter v1.0.0 mta-outp-cfd-1.case.edu 8D5DE11CF
Authentication-Results: mta-outp-cfd-1; arc=none smtp.remote-ip=129.22.103.196
ARC-Seal: i=1; a=rsa-sha256; d=case.edu; s=cwru-mta; t=1747227074; cv=none;
	b=DsFlCdMpwKQfMb+EowC9VUazZVACkemZbS4YTWQg17XxcnUusUpYCOH2lTGs3l1eMWnfOabb5WQ5xq4zjbBMOp7xveQmzscgc15nn8nebiyYWETK6bRfE2Q9w0GkusWQcENd6XzfnBc45+Ak8HVhvrk+zDGyZL6XuEVaHRTmLEkfWBY1kETmhN6r3GezR3+svolyEpe9gidJPTv56YDOUclUCJZxhXK0iyxK6txkyYtfasSF6z0CqSqpOtvJJiSFRsJPl5cWfHyhfm2kqpdiHRg3M4U/dPtjiy6HRE/ZdIB+mwxsKoIET++nt/eppDHCdrJ4zGJy4JJyazAtLa19HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; d=case.edu; s=cwru-mta;
	t=1747227074; c=relaxed/simple;
	bh=ziBnVImEQka1k/5ArPVUpuK5Uv55pJxDufSS4gEWcPs=;
	h=DKIM-Signature:Message-ID:Date:MIME-Version:Subject:To:From:to:
	 subject:message-id:date:from:mime-version:dkim-signature; b=ouyVpeti4ntDRNVLq3s6lFaPPHt9f6KrBkUT8Qr2nuB9BdvLPcFzbCudCGbdQN9/o0ThNOtowMF7I9sRKRyLzjXk8zxhg+DzTTFUgWlXrXlp+tNWA5xx/SRIz2JSkucujJbgCIwbFWy683Eu2nqbVCajb9QV0O+eDiqeyeFYIAnxP6Gg5nu2B/GuVKRdYe433xvk+06aqKgFFKhriNbVHSL+aBXp97yUZKXWN8ZyNWQ4CoU1M5CQ+lC8EqA5YKU6n4zJ6npWAFJ9D4JRbsB1bhw9M97jARju8vHKWQO4y10grnxdzxtyaldUyOYL653d5Ki7WJg+Bouu8rdWHAcDhw==
ARC-Authentication-Results: i=1; mta-outp-cfd-1; spf=pass (mta-outp-cfd-1.case.edu: domain of case.edu designates 209.85.219.71 as permitted sender) smtp.mailfrom=case.edu; dkim=pass (Good 2048 bit rsa-sha256 signature) header.d=case.edu header.i=None header.s=g-case; dmarc=pass (p=REJECT sp=Undefined pct=100 dis=NONE) header.from=case.edu
Received-SPF: Pass (mta-outp-cfd-1.case.edu: domain of case.edu designates 209.85.219.71 as permitted sender) client-ip=209.85.219.71
Received: from mpv-out-cfd-1.case.edu (mpv-out-cfd-1.case.edu [129.22.103.196])
	by mta-outp-cfd-1.case.edu (Postfix) with ESMTPS id 8D5DE11CF
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 08:51:14 -0400 (EDT)
Received: from mpv-local-ksl-1.case.edu (EHLO mpv-local-ksl-1.case.edu) ([129.22.103.235])
	by mpv-out-cfd-1.case.edu (MOS 4.4.8-GA FastPath queued)
	with ESMTP id DED33713;
	Wed, 14 May 2025 08:51:14 -0400 (EDT)
Received: from mail-qv1-f71.google.com (EHLO mail-qv1-f71.google.com) ([209.85.219.71])
	by mpv-local-ksl-1.case.edu (MOS 4.4.8-GA FastPath queued)
	with ESMTP id EKB30384;
	Wed, 14 May 2025 08:51:13 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6f53d97079aso226009936d6.0
        for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 05:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=case.edu; s=g-case; t=1747227071; x=1747831871; darn=vger.kernel.org;
        h=in-reply-to:organization:autocrypt:from:references:to
         :content-language:subject:cc:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ziBnVImEQka1k/5ArPVUpuK5Uv55pJxDufSS4gEWcPs=;
        b=CCKy4DG9qAi8npFSU4KYpiJdM7VctWjY/ia0ogbHh21SjhbPdbSHjyqnYg4mCqg2PB
         BDFdPgbOxMwg5xB3ZiH/SjNRuttEJcz8M7Ahd/AY6hP/rfdvsNsNS6rFXBGRx3tkkFgw
         WxJkSUnYgH6Rsy/op/aJjiM56f5ZqKhCOWz1TItcKwUnu2AAdCCndmy4H25fL14w8HWS
         4t75mpKuhqusS5tl2qEXdGloIin1mtFpZhABYSFoXcuGxCS1m8dpz3NNY3yTS+ZFXDDU
         ldrq1bKU9Yw15jB62GA/Z2O3K1+68JQvDjaAC6lJNOaGjOj8VqTOWigKi1tf9rY5pcJe
         gsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747227071; x=1747831871;
        h=in-reply-to:organization:autocrypt:from:references:to
         :content-language:subject:cc:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ziBnVImEQka1k/5ArPVUpuK5Uv55pJxDufSS4gEWcPs=;
        b=TTY0TcVl1gd9D4arKZoPP4bRLOfdSxz4PU2jrKvkD9ukNxmjCN0y24Uyuunrz3Lwo8
         chkduShKDoter5x7lTyHIBK9XUaWEYFIT41wmwNHogJ44esgyoWlA86IkuimuccJutsQ
         1JJ+dtql/+/mL73Cy+p5OSJF1TPp9kqU/6QgVY9xDRCt3KMxmqrKSMJUEHgyqDOtskpd
         w6guPLy0OTAldV4Tojkr2ZqZ36w7q/6fx+HpKrVkyQK/2kxmTIIWsjMA/dXqKRMGSibX
         tbphoh/YunXbjkuQrf0nM9sbhYzPng4jazlJ7+5+4muOfPxnPyRx5hLy7LmF8H/MO67W
         UMmg==
X-Forwarded-Encrypted: i=1; AJvYcCV6BbfOGswg59T+Raua2DE4jxlUObEHoSgllL5CwX9liPxPqAu5b0sH6R1HzAHrpxRfqDSeNwrgwNeD@vger.kernel.org
X-Gm-Message-State: AOJu0Yze98MoHjPK8TPePl33oN4CRXZbL4HdCv0FAWfzhgl327Ja8W+t
	VNxh06B+RAHUvgSn6CDxK8uMwZOSmFFGdfaotAa/gw5+RSLhc2xXp0qvFIzTFiPx23tYugZZrWu
	mrqC0lgJGlYEDeEeYaHd0lb4duZg9+4I2O+r92YbNR4QTYu5phgXhAUmQ1pNbmWx2Baak
X-Gm-Gg: ASbGncs/9pVJT/oy5/YTo+o5BWjWKGq+pkakZHsDbgatJ8coCNDS4QnGMbP1gGQemNv
	1KhHyouQx0rUaRLpWUBKKsiGUyJRrf9La18mVpv0FK25fcdJIrJzYBZhiLDH7WbwqptZ4qMTfNk
	0wCg+MgiPBYPmReKx9grDHoJWZS3/U3b6IEoZDJbfTJOsE2prKy9Riw6qWacwl7M70t4rIi6Rek
	2MBk0FtM2fZbmbWz/m4K1xQLhSanqMFLadG1CmTNsYiTtT0BJHXc7087D0KfvT7Ige104cGjHUF
	CVOqcW3IuKQ6xWvEzXyDzVBcYcP+Ozt3vVpJUgkIpQUzpk8p9hbapnhaqzX4TFdPUwPA0kHskw=
	=
X-Received: by 2002:a05:620a:27c7:b0:7c5:4c49:769c with SMTP id af79cd13be357-7cd287c542amr715131885a.6.1747227061258;
        Wed, 14 May 2025 05:51:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzQHI2rEryjYi08itQLGH9hVhvibYUYkKurYuspAd1v6/xkb8OjQbB/Q3z9M0RpvvTMatudg==
X-Received: by 2002:ad4:5bae:0:b0:6e8:f470:2b11 with SMTP id 6a1803df08f44-6f896e566cdmr50454446d6.23.1747227049536;
        Wed, 14 May 2025 05:50:49 -0700 (PDT)
Received: from ?IPV6:2603:6010:dc00:1e:f5e5:3614:5780:f83d? ([2603:6010:dc00:1e:f5e5:3614:5780:f83d])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e39e0b8bsm80792476d6.20.2025.05.14.05.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 05:50:48 -0700 (PDT)
Message-ID: <ad62849c-1728-4bae-b0d5-7d87dc94825f@case.edu>
Date: Wed, 14 May 2025 08:50:47 -0400
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: chet.ramey@case.edu
Cc: chet.ramey@case.edu, David Howells <dhowells@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
        Linux AFS mailing list <linux-afs@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>
Subject: Re: [PATCH] afs, bash: Fix open(O_CREAT) on an extant AFS file in a
 sticky dir
Content-Language: en-US
To: Jeffrey E Altman <jaltman@auristor.com>,
        Etienne Champetier <champetier.etienne@gmail.com>,
        Christian Brauner <brauner@kernel.org>
References: <433928.1745944651@warthog.procyon.org.uk>
 <20250505-erproben-zeltlager-4c16f07b96ae@brauner>
 <CAOdf3grbDQ-Fh2bV7XfoYvVBhgBAh7-hZyyxTNt1RfGekrA-nA@mail.gmail.com>
 <66c958db-0408-451d-b362-fed1f56d7c6d@auristor.com>
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
In-Reply-To: <66c958db-0408-451d-b362-fed1f56d7c6d@auristor.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------L5LSTY5M39gWnvMqVGp47caB"
X-Mirapoint-Received-SPF: 209.85.219.71 mail-qv1-f71.google.com chet.ramey@case.edu 5 none
X-Mirapoint-Received-SPF: 129.22.103.235 mpv-local-ksl-1.case.edu chet.ramey@case.edu 5 none
X-Junkmail-Status: score=10/90, host=mpv-out-cfd-1.case.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A006399.682491D0.0051,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2016-11-06 16:00:04,
	dmn=2013-03-21 17:37:32,
	mode=single engine
X-Junkmail-IWF: false

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------L5LSTY5M39gWnvMqVGp47caB
Content-Type: multipart/mixed; boundary="------------frKCS23FeCmgMLcTNF0WGjn4";
 protected-headers="v1"
From: Chet Ramey <chet.ramey@case.edu>
Reply-To: chet.ramey@case.edu
To: Jeffrey E Altman <jaltman@auristor.com>,
 Etienne Champetier <champetier.etienne@gmail.com>,
 Christian Brauner <brauner@kernel.org>
Cc: chet.ramey@case.edu, David Howells <dhowells@redhat.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Marc Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>,
 linux-fsdevel@vger.kernel.org,
 Linux AFS mailing list <linux-afs@lists.infradead.org>,
 linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
 "openafs-devel@openafs.org" <openafs-devel@openafs.org>
Message-ID: <ad62849c-1728-4bae-b0d5-7d87dc94825f@case.edu>
Subject: Re: [PATCH] afs, bash: Fix open(O_CREAT) on an extant AFS file in a
 sticky dir
References: <433928.1745944651@warthog.procyon.org.uk>
 <20250505-erproben-zeltlager-4c16f07b96ae@brauner>
 <CAOdf3grbDQ-Fh2bV7XfoYvVBhgBAh7-hZyyxTNt1RfGekrA-nA@mail.gmail.com>
 <66c958db-0408-451d-b362-fed1f56d7c6d@auristor.com>
In-Reply-To: <66c958db-0408-451d-b362-fed1f56d7c6d@auristor.com>

--------------frKCS23FeCmgMLcTNF0WGjn4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS81LzI1IDEwOjQyIEFNLCBKZWZmcmV5IEUgQWx0bWFuIHdyb3RlOg0KDQo+Pj4gU28g
dGhlbiBqdXN0IGRvbid0IHJlbW92ZSBpdC4gSSBkb24ndCBzZWUgYSByZWFzb24gZm9yIHVz
IHRvIHdvcmthcm91bmQNCj4+PiB1c2Vyc3BhY2UgY3JlYXRpbmcgYSBidWcgZm9yIGl0c2Vs
ZiBhbmQgZm9yY2luZyB1cyB0byBhZGQgdHdvIG5ldyBpbm9kZQ0KPj4+IG9wZXJhdGlvbnMg
dG8gd29yayBhcm91bmQgaXQuDQo+PiBUaGlzIGJhc2ggd29ya2Fyb3VuZCBpbnRyb2R1Y2Vk
IGFnZXMgYWdvIGZvciBBRlMgYnlwYXNzIGZzLnByb3RlY3RlZF9yZWd1bGFyDQo+IA0KPiBD
aGV0LCBJIGRvbid0IHRoaW5rIHRoaXMgaGlzdG9yeSBpcyBjb3JyZWN0LiANCg0KSSB0aGlu
ayBFdGllbm5lJ3MgdGVyc2UgY29tbWVudCBhY2N1cmF0ZWx5IHN1bW1hcml6ZXMgdGhlIGN1
cnJlbnQgcHJvYmxlbQ0KKGFuZCBtYXliZSBpdCB3b3VsZCByZWFkIG1vcmUgY2xlYXJseSBp
ZiBoZSBoYWQgdXNlZCBgYnlwYXNzZXMnKS4NCg0KLS0gDQpgYFRoZSBseWYgc28gc2hvcnQs
IHRoZSBjcmFmdCBzbyBsb25nIHRvIGxlcm5lLicnIC0gQ2hhdWNlcg0KCQkgYGBBcnMgbG9u
Z2EsIHZpdGEgYnJldmlzJycgLSBIaXBwb2NyYXRlcw0KQ2hldCBSYW1leSwgVVRlY2gsIENX
UlUgICAgY2hldEBjYXNlLmVkdSAgICBodHRwOi8vdGlzd3d3LmN3cnUuZWR1L35jaGV0Lw0K


--------------frKCS23FeCmgMLcTNF0WGjn4--

--------------L5LSTY5M39gWnvMqVGp47caB
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQR8ATX7CIqvbGbGULm7WGnwZOp0qwUCaCSRpwUDAAAAAAAKCRC7WGnwZOp0q8F+
AJ9LqPEdLlhWqcMgSVEfvfVvQQaLUQCeJ3uT3ggHKj9klGbE8GZKsHHVarM=
=1TNa
-----END PGP SIGNATURE-----

--------------L5LSTY5M39gWnvMqVGp47caB--
