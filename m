Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F25201017
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jan 2025 10:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736419399; cv=none; b=lVnXyQG0clBQZuYQZuPurwkNmsVIEQRi67/CAIe9c9j0PKrAZrI6sOX0RKWDNMmrRfcKh+pBtRLMb4/gegrprYz0tyh3t7ibeNuVuKIWHgfyoYE4bwjrAdxlpiQjKTiUTLyhOZ86VOx2OBUmGZTjo0JFdYeZTcukkbGv9qEiA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736419399; c=relaxed/simple;
	bh=AjUOxvZhIGEaZICVuCVkncdKmdoLETgzms3fMWVHI/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V0oDFuKRTIpvLlucVn4NPsuEGuYRQEzoP0SvoB1ACRgN2fU8QauZ+s3HVXBgFKYn14//u+7jVuEuXbWWPTwRANV/k9o0s8r3Ka/hf20vy6k37gXAtsGhmq/2e2NgjtSECAq79kpakGka8cZD9RBGaP1S+vnXG8QntENh3c0HW2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ihGr0rCo; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ihGr0rCo"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e537d9e3d75so1177276276.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jan 2025 02:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736419397; x=1737024197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6c+jC21WX/zRIgFaDn+D9zBJPCv2ixR+ja/PtFSmsU=;
        b=ihGr0rCoUkDpbhqKbJGQFrzlh1lfaaeYLzQQnI2ThvjMPj6/CrOMcX58ZcO23fdH2B
         bgtkbY2IXCIa/cJC1xYQq2rzMhIYC4F/zunrloHTC9vLu9zUIGOdmhHCWFG8NvR+d/2s
         3jkn37nmDVHusF01Fuj5KSL/eK7gB5H8tWCkWg/nfn5kg2YCEMVxZTYvDt2K1NDIfLdy
         4vv07lBqSJGGDiXQM/lu7l3aWfTbHNRoxkrcwuDP6mB0M/28A/N0p5f6OXycAl5jabio
         heFBmgaQ217DAgShB7PY5IpZGlYQcadVbBdeYTlwrUyrxdq9QgHCBqstO/7JEXknRWO/
         4bYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736419397; x=1737024197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z6c+jC21WX/zRIgFaDn+D9zBJPCv2ixR+ja/PtFSmsU=;
        b=SCMA0NBxHa8BJv478FSh5fqazuH8RnDDCEIbiCB+kUiLBEnXFTjicPCgAZTPBq+0Jp
         wvF0Psh0V6eJvANVWqvO5KWJs2dMQlPIuyDLRUShwaCIESub0qCQxcZ5HmWrQNAmLHBV
         oX+pfFmTRktmDSCtLCPssjxRueZ0hS5w9EDJispYD1FBUAbnA7mDZvNBFss2TS2zC6Aw
         XKMQ4tOFhV15+a7zOFDARIs8Jl93jgLOPCATVjM6vlOmh1h3OG9H7UAkuyo/XmCbkBSg
         k0hSa4ldSIVqvpJiP1hrY/mdy1lXkg2QCO0O0e0nkun1+dZWpONS+xC1ozhplYCkVmHN
         85EA==
X-Forwarded-Encrypted: i=1; AJvYcCVtzYeRo2J5vOksuhFuHKqWNRd6+J+lV/watjoPuDuUuHi2OxGQPfixDHn/E400NMxKwOsf4UBo/xpb@vger.kernel.org
X-Gm-Message-State: AOJu0YzZiL/sKtj34k5OJjEL8h9FO+B6gJXMGIXRhl2WrCfYMcISGHQP
	E3bnsNQPYRTZ1ZqD0Q3LhinFZFAy2OxZzUOJrx91zr8UM0LDbN+0uQIRiEXQqddhnrCZV/HYPW6
	8HSZSVjFkgxj3dMTtK6sfFnECuXqpnJH9RA==
X-Gm-Gg: ASbGncuCuNs1z2mh2nIQnLeNlmyjhyU90sQAf5ak9TO0C1TyEZvAcHF6cHD2KDZdTBw
	NkKOWaXA4iDDf2X2sCFq7/v3q1cviFFGixsy3kLe2gQIINY898H7eE1Pezo5Imi2ARYVEBw==
X-Google-Smtp-Source: AGHT+IE2ffSQVUYJf+1oWp2NMTwmd8zedU9iZWYuMAnA7d1AugUQXmK2Qgxjfb5TCEFeC3NVUW+yvDHd8jw7PmF4lug=
X-Received: by 2002:a05:690c:6383:b0:6ef:6107:69b9 with SMTP id
 00721157ae682-6f5312034d8mr47822547b3.7.1736419397054; Thu, 09 Jan 2025
 02:43:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106135910.GF5006@unreal> <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal> <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com> <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal> <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
 <Z3-CrT64eQdPQIDu@infradead.org>
In-Reply-To: <Z3-CrT64eQdPQIDu@infradead.org>
From: Kangjing Huang <huangkangjing@gmail.com>
Date: Thu, 9 Jan 2025 10:43:00 +0000
X-Gm-Features: AbW1kvaOr3nGzKK-MayDsX3zQLxbAsxAUeqft1PsVmbdz70PVrewB6VX2cRmXH4
Message-ID: <CAPbmFQawOrGmgYrg8z73E4hCiE3JAw7e1SGS0BApbQCfv90xzA@mail.gmail.com>
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using ib_device_get_netdev()
To: Christoph Hellwig <hch@infradead.org>, Leon Romanovsky <leon@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 9, 2025 at 8:02=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
> > This is good to know. However, since the SMB protocol explicitly calls
> > for enumeration of all network interfaces on the server host,
> > including their RDMA capabilities, I believe this is a sensible
> > exception to the layering rule. Or is there anyway else to do this
> > enumeration from the kernel space?
>
> No, it's not a sensible exception.  It's a massive data leak and a
> completely idiotic protocol feasture Linux should not support.  If the
> protocol requires a lsit of network interfaces, a Linux server should
> require explicitly require that list to be configured and not expose
> private information to the untrusted network.
>

I see the point. I wasn't thinking about it from the security
perspective too much and would agree with you on this argument about
data leaks.

The protocol itself is not necessarily unsecured, since in the spec it
calls for enumeration in an "implementation-specific manner"[1]. I
would interpret that as the implementation could enumerate interfaces
as it sees fit to its functional and security perspectives. The spec
only requires the server to always return a list of client-usable
interfaces, that does not need to always be the full interface list.

That being said, from ksmbd's implementation perspective, this
definitely needs to be something to be explicitly configured.

ref: [1](https://winprotocoldoc.z19.web.core.windows.net/MS-SMB2/%5bMS-SMB2=
%5d-240729.pdf)
sec 3.3.5.15.11

On Thu, Jan 9, 2025 at 7:59=E2=80=AFAM Leon Romanovsky <leon@kernel.org> wr=
ote:
...

> Except SMB spec, why do you need to provide "RDMA-capable" information?
> Is it must? What will it give to the users? Why can't you treat IPoIB
> like any other netdevice?

...

> Let's start with an answer to more simple question: "why do you need
> this capability flag?"

The short answer is: a Windows client requires this flag to be present
to actually utilize RDMA.

Long answer:

Although SMB-Direct (Microsoft speak for SMB over RDMA) protocol
technically is just wrapping SMB packets in RDMA transport, allowing
for a SMB connection to be completely handshaked and established in
RDMA context, without any need for transferring ip packets. This kind
of connection seems to be never happening for the actual client
implementation in Windows.

Under Windows, SMB Direct is only enabled when SMB multichannel is
enabled. And there is no way for the user to specify if they want to
connect to the IPoIB endpoint or RDMA endpoint - the client simply
connects to the ip interface first, uses the aforementioned IOCTL
request to query the RDMA capabilities for all interfaces, and upon
finding usable RDMA-capable interfaces, opens preferred data channels
on RDMA transport to carry the actual data.

As far as I know there is no way from a Windows user's perspective to
modify this behavior and upon disabling SMB multichannel, SMB will
just disable RDMA support and transfer everything over IP. The RDMA
transport is only "automatically upgraded to", no explicit
configurations are available whatsoever.

So if ksmbd does not send out capability flags to indicate the Windows
client to initiate RDMA transport as a side channel, the client will
just keep working with connections on the ip stack and the user can
never utilize RDMA.

To be clear: I would strongly agree that the Windows client's behavior
here is pretty stupid and is just outright dumb design. In configuring
my two-workstation setup utilizing this protocol, the no-config design
of the Windows side has created far more problems than it has solved.
It also somehow brought me here submitting my first kernel patch.
However if we want any interoperability of ksmbd with Windows clients
on the RDMA front, we would need to implement the IOCTL response to
some degree and send out the RDMA capability flags.

My apologies for not making this context earlier, I was too
hyper-focused on the code itself to fall into the classic XY problem
trap.

Disclaimer: all my knowledge and research about windows client is
limited to the edition I have access to (Windows 10 Pro Workstation),
I have no idea if Windows server edition's client is different.

...

>
> Yes, ib_device_get_by_netdev and get_netdev are intended to perform
> lookup of ib device based on underlying netdev, but in IPoIB case you
> are interested in ib device based on upper netdev.
>
> So this leads to another question, if user didn't ask to connect SMB to
> IB device and chose netdevice (IPoIB) instead, why are you still forcing
> him to take IB path? If it is not user's decision and you are choosing
> devices from the list, you already have in your list the IB device which
> is connected to IPoIB.

This is related to the long answer to the first question. Basically
using a Windows client the user cannot make decisions to use RDMA or
not, it is not the decision of the server, either - the client will
enumerate the interfaces and make decisions for the user. And due to
the presence of SMB multichannel, the ip interface receiving the
interface enumeration request is not even guaranteed to be the
connected IPoIB interface - the multichannel protocol is designed to
work with service discovery, where it is totally possible that the
initial connection will be established on another data path, before
the client discovers another better path potentially with RDMA
capability. The only way for ksmbd to be fully compatible with these
is to implement the interface enumeration to some degree. Although I
am indeed convinced that this needs to be explicitly configured to
avoid any security risks.

Thanks


>
> Thanks




--
Kangjing "Chaser" Huang
