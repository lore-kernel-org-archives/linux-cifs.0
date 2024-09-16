Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B6B1BC41;
	Mon, 16 Sep 2024 15:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726500781; cv=none; b=LOrswj9i5dW5tCBipg02J+mqbaP1cCsFrqxsQPpfXi/V/k4GNadKPC7PCLawA3/Iw+t5taDndB/IfPlxLX1OdY9YHjyH9YMvHfGWMrCGPHI0sEk9epYNIxQlpKJ8a+SF5voqvPgonkdPuXZD41PiBnUuFuEW22c6rtN/Zs3Vgwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726500781; c=relaxed/simple;
	bh=zvcSW8EuY//F/y8pECjb1mh4ZJKhb1Rn1e0qwBOj/KA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VobXG+zQ8hqGh2Xw+ETmRDldXyaaWy9ctBN9gSsaBhbtqXdtvPj2eThCrucELDB/AtNoUSMGd8ctmo2MRF8bczu/+SQshFgUb1irSuC0IQMchP0/vlWBfq234EZt9Y2znE1trmMZ4pm2DR45cAlboQU9TV0/raSWXllrIhQgLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pny2pgXG; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pny2pgXG"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a0a0d3be2fso7023005ab.3;
        Mon, 16 Sep 2024 08:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726500779; x=1727105579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvcSW8EuY//F/y8pECjb1mh4ZJKhb1Rn1e0qwBOj/KA=;
        b=Pny2pgXG5azHxQPD1vnPLeQB7wcGavKdsGNEUquHScnizFhRFbdiNd16DK4O5qiUYu
         9Qf/SIkP/d2qjRthBUjahOLVIdJ3nr9Zj2tOtWr4v/2kFJcmtjsGiymyLEKJX8sUGnJD
         sy0l9bOMw8e23GsFsnjq8H1m++umPZ0lcA5a+Z3epX0JpnCuJdgBKuZJQbrr7IGs48CI
         iLmbcG25exBsqUjgSULjR8rJ26cR43DUIkWtLBEGkD5QRuJr7mqurF/D6P/NN2vWixrT
         6/64u/Xt0qG3HeeNYl+EWAgCzz/iqNsPMMRhbe+rw3yDHCQrUBVTiE9+5T6dbVGraaVz
         zcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726500779; x=1727105579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvcSW8EuY//F/y8pECjb1mh4ZJKhb1Rn1e0qwBOj/KA=;
        b=dTgzyI9Y48R/lBuWdrT5/fSTCf8Q8RCbM6LD6ndeHhNynFfAqWHFuBYPvJplrDI2FL
         TRB9/J5IfY+xcwG6fw6B9Ua2/CLZ3p2b4VwAV/gzovmOQ8JaZaGWNJgmwR06h22+kJs3
         4zyIB+g5K5U91RFHoWAcwfDyUMv39pFWfItoSFTr70pNydsz69PEqZn43p0/J6Kjbmkf
         oo7W/upJGuom1g1hHcU96DJvo+Fu5k0t6okmkXYSh56Ld02HG2dqFPuegV1ybLO+VFFH
         KhpYl2pRpXDV+1Kc9UliUYoNOix3MPDlRazgkJJLaMKpKpH3YvV+Jgsk9MsUOoYmR4kL
         QUEw==
X-Forwarded-Encrypted: i=1; AJvYcCUjbgXwnSWsJ5dIyq5oqNgFICk/Qa7uqLTcfleD123yf9wPVZNcKnVYXQpRxyWzU8kfF3smIHOkHI9z@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5ODO1bHKgTa6zH2pnJJtvGmPyxl6JOHe2eSLd2vwZyotWgQrE
	CGIDzVwqCPu+yBfPdqe6UfKUhZP6y3wMun+MIX8CdUDE4YdzgOlcRzUKwCKWayOk7H5bo6B4dJu
	TaAjE/bcTkzjYvZeS3dstiBTczNM=
X-Google-Smtp-Source: AGHT+IEC9cLgnKA3gDBetNOTZAhcwp0v+aK0ZR8DiMugbaWpsZg4/Mdk0aDy+B+2x8CM1Ap0e/mzZNaYMz16xK8VxKU=
X-Received: by 2002:a05:6e02:1a8e:b0:3a0:4d1f:519c with SMTP id
 e9e14a558f8ab-3a0848b0589mr145306775ab.3.1726500778933; Mon, 16 Sep 2024
 08:32:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725935420.git.lucien.xin@gmail.com> <ZuThZdPILnCKpOmO@pop-os.localdomain>
In-Reply-To: <ZuThZdPILnCKpOmO@pop-os.localdomain>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 16 Sep 2024 11:32:47 -0400
Message-ID: <CADvbK_e0m=kWyJJMWMf_-9bg_OS9aBnsyuRSXpOc6DzZbS2gZQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] net: implement the QUIC protocol in linux kernel
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBTZXAgMTMsIDIwMjQgYXQgOTowNeKAr1BNIENvbmcgV2FuZyA8eGl5b3Uud2FuZ2Nv
bmdAZ21haWwuY29tPiB3cm90ZToNCj4NCj4gT24gTW9uLCBTZXAgMDksIDIwMjQgYXQgMTA6MzA6
MTVQTSAtMDQwMCwgWGluIExvbmcgd3JvdGU6DQo+ID4gNC4gUGVyZm9ybWFuY2UgdGVzdGluZyB2
aWEgaXBlcmYNCj4gPg0KPiA+ICAgVGhlIHBlcmZvcm1hbmNlIHRlc3Rpbmcgd2FzIGNvbmR1Y3Rl
ZCB1c2luZyBpcGVyZiBbNV0gb3ZlciBhIDEwMEcNCj4gPiAgIHBoeXNpY2FsIE5JQywgZXZhbHVh
dGluZyB2YXJpb3VzIHBhY2tldCBzaXplcyBhbmQgTVRVczoNCj4gPg0KPiA+ICAgLSBRVUlDIHZz
LiBrVExTOg0KPiA+DQo+ID4gICAgIFVOSVQgICAgICAgIHNpemU6MTAyNCAgICAgIHNpemU6NDA5
NiAgICAgIHNpemU6MTYzODQgICAgIHNpemU6NjU1MzYNCj4gPiAgICAgR2JpdHMvc2VjICAgUVVJ
QyB8IGtUTFMgICAgUVVJQyB8IGtUTFMgICAgUVVJQyB8IGtUTFMgICAgUVVJQyB8IGtUTFMNCj4g
PiAgICAg4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSADQo+ID4gICAgIG10dToxNTAw
ICAgIDEuNjcgfCAyLjE2ICAgIDMuMDQgfCA1LjA0ICAgIDMuNDkgfCA3Ljg0ICAgIDMuODMgfCA3
Ljk1DQo+ID4gICAgIOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgA0KPiA+ICAgICBt
dHU6OTAwMCAgICAyLjE3IHwgMi40MSAgICA1LjQ3IHwgNi4xOSAgICA2LjQ1IHwgOC42NiAgICA3
LjQ4IHwgOC45MA0KPiA+DQo+ID4gICAtIFFVSUMoZGlzYWJsZV8xcnR0X2VuY3J5cHRpb24pIHZz
LiBUQ1A6DQo+ID4NCj4gPiAgICAgVU5JVCAgICAgICAgc2l6ZToxMDI0ICAgICAgc2l6ZTo0MDk2
ICAgICAgc2l6ZToxNjM4NCAgICAgc2l6ZTo2NTUzNg0KPiA+ICAgICBHYml0cy9zZWMgICBRVUlD
IHwgVENQICAgICBRVUlDIHwgVENQICAgICBRVUlDIHwgVENQICAgICBRVUlDIHwgVENQDQo+ID4g
ICAgIOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgA0KPiA+ICAgICBtdHU6MTUwMCAg
ICAyLjE3IHwgMi40OSAgICAzLjU5IHwgOC4zNiAgICA2LjA5IHwgMTUuMSAgICA2LjkyIHwgMTYu
Mg0KPiA+ICAgICDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIANCj4gPiAgICAgbXR1
OjkwMDAgICAgMi40NyB8IDIuNTQgICAgNy42NiB8IDcuOTcgICAgMTQuNyB8IDIwLjMgICAgMTku
MSB8IDMxLjMNCj4gPg0KPiA+DQo+ID4gICBUaGUgcGVyZm9ybWFuY2UgZ2FwIGJldHdlZW4gUVVJ
QyBhbmQga1RMUyBtYXkgYmUgYXR0cmlidXRlZCB0bzoNCj4gPg0KPiA+ICAgLSBUaGUgYWJzZW5j
ZSBvZiBHZW5lcmljIFNlZ21lbnRhdGlvbiBPZmZsb2FkIChHU08pIGZvciBRVUlDLg0KPiA+ICAg
LSBBbiBhZGRpdGlvbmFsIGRhdGEgY29weSBvbiB0aGUgdHJhbnNtaXNzaW9uIChUWCkgcGF0aC4N
Cj4gPiAgIC0gRXh0cmEgZW5jcnlwdGlvbiByZXF1aXJlZCBmb3IgaGVhZGVyIHByb3RlY3Rpb24g
aW4gUVVJQy4NCj4gPiAgIC0gQSBsb25nZXIgaGVhZGVyIGxlbmd0aCBmb3IgdGhlIHN0cmVhbSBk
YXRhIGluIFFVSUMuDQo+ID4NCj4NCj4gVGhpcyBpcyBub3QgYXBwZWFsaW5nLg0KPg0KPiBIb3dl
dmVyLCBJIGNhbiBvZmZlciB5b3Ugb25lIG1vcmUgcG9zc2libGUgYWR2YW50YWdlIG9mIGluLWtl
cm5lbCBRVUlDLg0KPiBZb3UgY2FuIHRoaW5rIGFib3V0IGFkZGluZyBpb3VyaW5nIHN1cHBvcnQg
Zm9yIFFVSUMgc29ja2V0LCBiZWNhdXNlIHRoYXQNCj4gY291bGQgcG9zc2libHkgY2hhaW4gdGhl
IHNvY2tldCBmYXN0cGF0aCBvcGVyYXRpb25zIHRvZ2V0aGVyIHdoaWNoIG9wZW5zDQo+IHRoZSBk
b29yIGZvciBtb3JlIG9wdGltaXphdGlvbi4NCj4NCkkgaGF2ZW4ndCBoYWQgdGhlIGNoYW5jZSB0
byB0cnkgaW9fdXJpbmcuIEZyb20gd2hhdCBJIHVuZGVyc3RhbmQsIGl0DQpkb2VzbuKAmXQgcmVx
dWlyZSBhbnkgY2hhbmdlcyB0byB0aGUgcHJvdG9jb2wgc3RhY2sgKExpbnV4IFFVSUMgZG9lc27i
gJl0DQpzdXBwb3J0IE1TR19aRVJPQ09QWSBhdCB0aGlzIHRpbWUpLg0KDQpUaGFua3MgZm9yIG9m
ZmVyaW5nIHRoaXMgc3VnZ2VzdGlvbiwgaXQgc291bmRzIHdvcnRoIGV4cGxvcmluZyB3aGVuDQp1
c2luZyB0aGUgUVVJQyBzb2NrZXQgaW4gdGhlIGZ1dHVyZS4NCg0KVGhhbmtzLg0K
