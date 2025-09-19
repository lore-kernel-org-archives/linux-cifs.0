Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E36430F541
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 14:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758292934; cv=none; b=DG5mQUXsX9n2x0CVz4FocMOLoqAMtMr71vpJ2IbpYydsO6qhdyJ2nK/vL4HZSWmnCV9O2iehjnoZpUItQOKKzcj/XT91mZs9x3/uwwBgNnR5V2SVcMGcRgNvo2kz9a1LFLWWfHBYzHcDqoVe6+pVn5Tjm7vxwf8WaS9O95cYGWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758292934; c=relaxed/simple;
	bh=HZlHpTpdK3mBVkCcSAL9bV9vZzv/zqfoBlqlG5Frizc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gU43flXWpivA/7jzDrGREgYTOWJUfUTmTq/eJnr89AqvRxA9u5DYy9r22rby/JNR5gF1DsrCxpH1gBThEuukAP25mayXrraQKwgj53JEsoI5TRxtclPjm175Hvgfb/VVhv5Pev4nrcCWd0m7f0rmejisHAvUGUCckzf3Ld6H1Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PD9xCNea; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PD9xCNea"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32326e2f0b3so1895757a91.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 07:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758292932; x=1758897732; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZlHpTpdK3mBVkCcSAL9bV9vZzv/zqfoBlqlG5Frizc=;
        b=PD9xCNeaVUUeDQrcnuf00PCvNREtBKCP9IGxxAAnHkhHUjJ0PW6ttEA+36mxM41RPE
         8vYa+2rAh9YvFkkbLClTEh8nzQgOnDrrRwL6i+nWrxMgFy32osvPZ5yv+UhGr0TSlWbL
         /5smMhSTyS6AOwQeevDETegO47hjs/2MulsZX7QBi5YfHqV8raQ+BVfrqTDhYwXDvFWZ
         m49yzY/KQsrt+lZCI1EwBWnSSv2PUmBEFaQRIz3OD78DD3oSy8k8Nvs7PBUo3JhdlbRk
         S//OMvH5e5mCJ1ytn9TKJRkzDgXdChUzq9Sc5i4hKbVZtMYOM+LlCPk7wjHKSAXIPkRm
         lhow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758292932; x=1758897732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZlHpTpdK3mBVkCcSAL9bV9vZzv/zqfoBlqlG5Frizc=;
        b=P5/7zuTZVsbEUtk5GhwalUt8Uc53hn/EUEbwVGaj/uDwUQcJfSOC6+hRJgV2gOIGoD
         Y+27ABSCXywOO6nrt3YS8eK8Tt8K0XfGbvqA6XTyzGzl2sDQFCTLvj4jAo7+Yh+TyZPt
         ZQEIZWCiNhnGomWMdv8LGVzUOohqwtsWSp17a/OWndD399uh5jo8FIECEyROyiC7uGpc
         a2qC4V1P/sQ6k0UeLimZ4dNIarOBhbeLfKlVUHtBV2ODOfQIbdXNXNpyMFuKJwo1UnU0
         6u36Ul25WrDBpFU74eBVx/kKt7vT6SOsIvlUeUENYRhzz7/tNjLr08ZWsG2VncIkjw0h
         cvqw==
X-Forwarded-Encrypted: i=1; AJvYcCUdb9otStRYdpBUIgsODxu5KnNyJgWi/g82OorUmd8ZCsQC2WeUA5cxlhPn/zksdloLY9ftvI6DDQmk@vger.kernel.org
X-Gm-Message-State: AOJu0Yw52m+z6HpXQu4GiwjbSDEfRWjUB69Kol1aR72+JgSDOpbhYqgC
	8U/54XDPY9kE29oxIYsR9bgJVRYYwcclbKqQ2dvSGlPdQECPyocslXjxNaFfVibrp5ofbt7peNO
	JtufmzqCV82NZz7eKCAwhPLLDzVgUQYI=
X-Gm-Gg: ASbGncuttye+oNIkSlogKnxpmFIh61wMoFSyMqIPkM2802LrbsrjOSS/dUeByk17PyW
	F2Y28wHx/dpKpaZjo7eRVos/tRBW1BWmyRvzMvapbShFe3ABnAi3nThKpu+QExDgAVRIs4+6Jxw
	tXYSokakc3O+JJhHpTkT2kn1mgaEB/IiPABx2bEsyvYcjjiDqiG53mINTsyvtOLC101s4/KCwJy
	AUF0qw=
X-Google-Smtp-Source: AGHT+IGo9OakPjgwrSXJF/qJMVUBdi/e7cF1r+aV53PwjCNFN9R0QdCmHkVhEX7Lqj+jz4p4vZqIYSn6l+tyCyIEnog=
X-Received: by 2002:a17:90b:1a8c:b0:32b:d8bf:c785 with SMTP id
 98e67ed59e1d1-3309834a0c4mr5086454a91.20.1758292931548; Fri, 19 Sep 2025
 07:42:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <c64e0dde-ce6a-4528-ad11-bfe3a90c2623@suse.de>
In-Reply-To: <c64e0dde-ce6a-4528-ad11-bfe3a90c2623@suse.de>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Sep 2025 10:41:58 -0400
X-Gm-Features: AS18NWCO3T47VA_L1EGQq0v2eLMYVU-h3utg8wzRNRsnOhBYSQghROeeV9IDBfk
Message-ID: <CADvbK_d1fuyoG_F8jXNSyuicFqDxmbwSp06mkE1GvgTFkYRm5A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Hannes Reinecke <hare@suse.de>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gRnJpLCBTZXAgMTksIDIwMjUgYXQgMjo0NOKAr0FNIEhhbm5lcyBSZWluZWNrZSA8aGFyZUBz
dXNlLmRlPiB3cm90ZToNCj4NCj4gT24gOS8xOS8yNSAwMDozNCwgWGluIExvbmcgd3JvdGU6DQo+
ID4gSW50cm9kdWN0aW9uDQo+ID4gPT09PT09PT09PT09DQo+ID4NCj4gPiBUaGUgUVVJQyBwcm90
b2NvbCwgZGVmaW5lZCBpbiBSRkMgOTAwMCwgaXMgYSBzZWN1cmUsIG11bHRpcGxleGVkIHRyYW5z
cG9ydA0KPiA+IGJ1aWx0IG9uIHRvcCBvZiBVRFAuIEl0IGVuYWJsZXMgbG93LWxhdGVuY3kgY29u
bmVjdGlvbiBlc3RhYmxpc2htZW50LA0KPiA+IHN0cmVhbS1iYXNlZCBjb21tdW5pY2F0aW9uIHdp
dGggZmxvdyBjb250cm9sLCBhbmQgc3VwcG9ydHMgY29ubmVjdGlvbg0KPiA+IG1pZ3JhdGlvbiBh
Y3Jvc3MgbmV0d29yayBwYXRocywgd2hpbGUgZW5zdXJpbmcgY29uZmlkZW50aWFsaXR5LCBpbnRl
Z3JpdHksDQo+ID4gYW5kIGF2YWlsYWJpbGl0eS4NCj4gPg0KPiBbIC4uIF0+DQo+ID4gLSBQZXJm
b3JtYW5jZSBUZXN0aW5nDQo+ID4NCj4gPiAgICBQZXJmb3JtYW5jZSB3YXMgYmVuY2htYXJrZWQg
dXNpbmcgaXBlcmYgWzhdIG92ZXIgYSAxMDBHIE5JQyB3aXRoDQo+ID4gICAgdXNpbmcgdmFyaW91
cyBNVFVzIGFuZCBwYWNrZXQgc2l6ZXM6DQo+ID4NCj4gPiAgICAtIFFVSUMgdnMuIGtUTFM6DQo+
ID4NCj4gPiAgICAgIFVOSVQgICAgICAgIHNpemU6MTAyNCAgICAgIHNpemU6NDA5NiAgICAgIHNp
emU6MTYzODQgICAgIHNpemU6NjU1MzYNCj4gPiAgICAgIEdiaXRzL3NlYyAgIFFVSUMgfCBrVExT
ICAgIFFVSUMgfCBrVExTICAgIFFVSUMgfCBrVExTICAgIFFVSUMgfCBrVExTDQo+ID4gICAgICDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIANCj4gPiAgICAgIG10dToxNTAwICAgIDIu
MjcgfCAzLjI2ICAgIDMuMDIgfCA2Ljk3ICAgIDMuMzYgfCA5Ljc0ICAgIDMuNDggfCAxMC44DQo+
ID4gICAgICDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIANCj4gPiAgICAgIG10dTo5
MDAwICAgIDMuNjYgfCAzLjcyICAgIDUuODcgfCA4LjkyICAgIDcuMDMgfCAxMS4yICAgIDguMDQg
fCAxMS40DQo+ID4NCj4gPiAgICAtIFFVSUMoZGlzYWJsZV8xcnR0X2VuY3J5cHRpb24pIHZzLiBU
Q1A6DQo+ID4NCj4gPiAgICAgIFVOSVQgICAgICAgIHNpemU6MTAyNCAgICAgIHNpemU6NDA5NiAg
ICAgIHNpemU6MTYzODQgICAgIHNpemU6NjU1MzYNCj4gPiAgICAgIEdiaXRzL3NlYyAgIFFVSUMg
fCBUQ1AgICAgIFFVSUMgfCBUQ1AgICAgIFFVSUMgfCBUQ1AgICAgIFFVSUMgfCBUQ1ANCj4gPiAg
ICAgIOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgA0KPiA+ICAgICAgbXR1OjE1MDAg
ICAgMy4wOSB8IDQuNTkgICAgNC40NiB8IDE0LjIgICAgNS4wNyB8IDIxLjMgICAgNS4xOCB8IDIz
LjkNCj4gPiAgICAgIOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgA0KPiA+ICAgICAg
bXR1OjkwMDAgICAgNC42MCB8IDQuNjUgICAgOC40MSB8IDE0LjAgICAgMTEuMyB8IDI4LjkgICAg
MTMuNSB8IDM5LjINCj4gPg0KPiA+DQo+IEkgaGF2ZSBiZWVuIGZvbGxvd2luZyB0aGUgUVVJQyBp
bXBsZW1lbnRhdGlvbiBwcm9ncmVzcyBmb3IgcXVpdGUgc29tZQ0KPiB3aGlsZSwgYW5kIGFsd2F5
cyBmb3VuZCB0aGUgcGVyZm9ybWFuY2UgaW1wYWN0IHJhdGhlciBmcnVzdHJhdGluZy4NCj4gQXQg
dGhlIG9uc2V0IGl0IGxvb2tzIGFzIGlmIHlvdSB3b3VsZCBzdWZmZXIgaGVhdmlseSBmcm9tIHRo
ZSBhZGRpdGlvbmFsDQo+IGNvbXBsZXhpdHkgdGhlIFFVSUMgcHJvdG9jb2wgaW1wb3NlcyB1cCB5
b3UuDQo+IEJ1dCB0aGF0IHdvdWxkIG1ha2UgdGhlIHVzZSBvZiBRVUlDIHJhdGhlciBwb2ludGxl
c3MgZm9yIG1vc3QgdXNlLWNhc2VzLg0KPiBTbyBvbmUgd29uZGVycyBpZiB0aGlzIGlzIG5vdCBy
YXRoZXIgYSBwcm9ibGVtIG9mIGFuIHVuc3VpdGFibGUgdGVzdA0KRm9yIGZhc3QgbmV0d29ya3Ms
IGxpa2UgdGhlIG9uZXMgSSB1c2VkIGluIG15IGlwZXJmIHRlc3RzLCBpdOKAmXMgZXhwZWN0ZWQN
CnRoYXQgUVVJQyBkb2VzIG5vdCBvdXRwZXJmb3JtIFRDUCtUTFMgYXQgdGhlIHRpbWUsIFRoZSBt
YWluIHJlYXNvbiBpcyB0aGF0DQpUQ1AgaGFzIGRlY2FkZXMgb2Yga2VybmVsLWxldmVsIG9wdGlt
aXphdGlvbnMsIGluY2x1ZGluZyBmZWF0dXJlcyBsaWtlDQpHU08vR1JPIGFuZCBldmVuIGhhcmR3
YXJlIG9mZmxvYWQgc3VwcG9ydCwgd2hpY2ggSSBkb24ndCB0aGluayBRVUlDIGNhbg0KY2F0Y2gg
dXAgZHVlIHRvIGl0cyBjb21wbGV4aXR5Lg0KDQpUaGF0IHNhaWQsIFFVSUMgc2hvd3MgYWR2YW50
YWdlcyBpbiBvdGhlciBzY2VuYXJpb3Mgd2ViIGJyb3dzaW5nIG9yDQpzaW1pbGFyIHdvcmtsb2Fk
cy4gUVVJQyBjYW4gb3V0cGVyZm9ybSBUQ1ArVExTIGJlY2F1c2Ugb2Y6DQoNCi0gRmFzdGVyIGNv
bm5lY3Rpb24gc2V0dXA6IFFVSUMgY29tYmluZXMgdGhlIHRyYW5zcG9ydCBhbmQgVExTIGhhbmRz
aGFrZXMsDQogIGF2b2lkaW5nIHRoZSBleHRyYSByb3VuZCB0cmlwcyBvZiBUQ1DigJlzIHRocmVl
LXdheSBoYW5kc2hha2UgcGx1cyBUTFMNCiAgbmVnb3RpYXRpb24uDQoNCi0gTm8gaGVhZC1vZi1s
aW5lIGJsb2NraW5nIGFjcm9zcyBzdHJlYW1zOiBRVUlDIG11bHRpcGxleGVzIG11bHRpcGxlDQog
IHN0cmVhbXMgb3ZlciBhIHNpbmdsZSBjb25uZWN0aW9uLCBzbyBhIHNpbmdsZSBsb3N0IHBhY2tl
dCBkb2VzbuKAmXQgc3RhbGwNCiAgdW5yZWxhdGVkIHN0cmVhbXMsIHVubGlrZSBUQ1AuDQoNCj4g
Y2FzZS4gRnJvbSBteSB1bmRlcnN0YW5kaW5nIFFVSUMgaXMgZ2VhcmVkIHVwIGZvciBoYW5kbGlu
ZyBhDQo+IG11bHRpLXN0cmVhbSBjb25uZWN0aW9uIHdvcmtsb2FkLCBzbyBvbmUgc2hvdWxkIHVz
ZSBhbiBhZGVxdWF0ZSB0ZXN0IHRvDQo+IHNpbXVsYXRlIGEgbXVsdGktc3RyZWFtIGNvbm5lY3Rp
b24uIERpZCB5b3UgdXNlIHRoZSAnLVAnIG9wdGlvbiBmb3INCj4gaXBlcmYgd2hlbiBydW5uaW5n
IHRoZSB0ZXN0cz8NCj4NCj4gQW5kIGl0IG1pZ2h0IGFsc28gYmUgYW4gaWRlYSB0byBhZGQgUVVJ
QyBzdXBwb3J0IHRvIGlwZXJmIGl0c2VsZiwNCj4gZXNwZWNpYWxseSB0cmFuc2Zvcm1pbmcgdGhl
ICctUCcgb3B0aW9uIG9udG8gUVVJQyBzdHJlYW1zIGxvb2tzDQo+IHByb21pc2luZy4NCj4NClll
cywgd2UgY291bGQgYWRkIFFVSUMgdG8gaXBlcmYsIGJ1dCB0aGVuIHRlc3Rpbmcgd291bGQgbmVl
ZCB0byBpbmNsdWRlDQpwYWNrZXQgbG9zcyBhbmQgZW5zdXJlIHRoZSBDUFUgaXNu4oCZdCB0aGUg
Ym90dGxlbmVjaywgd2hpY2ggbW92ZXMgYXdheQ0KZnJvbSBhIGZhc3QtbmV0d29yayBlbnZpcm9u
bWVudC4NCg0KVGhhbmtzIEhhbm5lcyBmb3IgeW91ciBjb21tZW50LiBJ4oCZZCBiZSBnbGFkIHRv
IGhlYXIgYW55IGZ1cnRoZXIgaWRlYXMgb24NClFVSUMgcGVyZm9ybWFuY2UgdGVzdGluZy4gU28g
ZmFyLCBJIGhhdmVu4oCZdCBzZWVuIGEgY29tbW9uIG1ldGhvZCBvciB0b29sDQphZG9wdGVkIGZv
ciBpdCBmcm9tIHRoZSBjb21tdW5pdHkuDQo=
