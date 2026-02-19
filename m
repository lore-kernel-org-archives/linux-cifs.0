Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F19D3C2E
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 11:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771499661; cv=pass; b=HOJWx3DivMF9+N0UvOR757hhZpcPkMbiamx/0ZRh8Ukx2amo1mocPU+80rwDMhH68exinoezhGJqUyNwPqwXVjWVFw6U0ysFM1AxG5e3QGjOt+bHqcP5JLWBpbNVcO4Qj2hcHzL8s75tk+7NL+ajMlgfo+mHbCDrFpAy/3425tc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771499661; c=relaxed/simple;
	bh=niMibSQKj0KujlnHiRyqnt+sJ0wt/x7S9MkaXGceCsY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PUZWU4c5GV/22xTo6GM/QiFh7h75vScZ7f5pxKfO8N3cw3//Ao04HSmNVIOJ04qBaT97hkri3LPCaxPF37pPIDNdpAGxxSm6FHNsKmMzMH0tJlQi6nzUNZg8mQb27T5Hrq9+CTZ5beX9mM/h5uZJ1c99z/54vwSs6mUvFElb5NU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJx/mlhR; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJx/mlhR"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79800183233so10764467b3.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 03:14:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771499659; cv=none;
        d=google.com; s=arc-20240605;
        b=PUGHlUjeXZyrdVyVJ+9GETmMvMB4Qxi5AP0WNEl9TrTZDXEiPWA4zj+KFBpdOylp9H
         KcbN9NPPxAoiYP8ymv+KJ/Sn9FgKew7rMtUNMXkOFQ/wDTtwF5jyijnUPLXoECPOFSiW
         oEdYiUwXYgfkBYJXeNxda+q9IDzsCtRx91YQgv4hO4g5NQyHY/DBlrSwGvZ5rBGbbxpe
         lBedZhd8qruFml/L6IYSE9/N+CAeS1o17q5HduRvFFdPQZhJ7Q3USYR/m/GuYipEV9ho
         lb6dlBJEF/gVEyrk2n3Eq3IrohzNcXqv/0dhXsWdVMJ/+qPRw+vXpJe0oH/SwTvSmul3
         3CRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ECgE71r3e+aueNZiJIl4cET27fzF0zD/Q1EszPmyRNM=;
        fh=kTqMWLOlnfjHP8OTrk5LDtTBZQTIGlCpD66lxS0n9N8=;
        b=PF5MQztgVVr+BN8bwZTsk/X7PxZLgovTx/dPuZ+HBx7R1HzifWLyL5e3HQNjXPIotk
         nVKuX51U4EzTry2KNBVXUkM+xj+M3vkMaqlmyspci07ndV/IYiEz8n8RsOmDk8suiB+Q
         hnVmpjpElL9pKhPV4fg7jTZ2M0gRGlgNiYUztK5XFFQlCouMYwlOtmR1wzLZeJYaB2d5
         RGiz58OcCcE/v/gjVsD0ceifDAkR7s5c5BUZDbRjkz476PMERK4n7G7VSSki5qKBhsbe
         Ujwn5+k+cOjuU1232L0TjD2RH3TLEBLoZDKN+8PgO2gVwfBMV3mVU+/kamW80Y+m1cg1
         uQBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771499659; x=1772104459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ECgE71r3e+aueNZiJIl4cET27fzF0zD/Q1EszPmyRNM=;
        b=RJx/mlhR79T0+gOK82f5Aj1DzKOMJq6Qelr5q/nguPiF3YsoTi2bGREGl8JY1PBbmW
         aAFZ3nkeAWm+z0iUj0jhm+mMvUTjyfVvNdP4bF6e/lGRycs2cqA9rCBGq2WwrQlgRczL
         p4St35oSksRi/kx0SceYvjsCe6hq/zAMp4lTuCeVA8sNL5h106HMBB35jfEdM2WOwe9a
         rVsWkpr3CEEBF6CHj3rWOnIA7fImGYkKbhSzEr8A/R0ml//ONQw03SYj13gb0uR/Crnx
         0d8LTPY07ixmlAXQJAK3IywEnb3ZaFRQ8W9trnwkqVg0J8YMP60Vh93fmXjyCIZs+Fph
         oaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771499659; x=1772104459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ECgE71r3e+aueNZiJIl4cET27fzF0zD/Q1EszPmyRNM=;
        b=aNYAyi8r1nnERGxlyJP1TU4sqhXCWRks9MhQUsBthUYQ4RIxhbvqm4s8/ptn07lqxE
         mhjwDWBNdyBXMt1qWh3Kq1XP3ttIy7ZurKp7ejUZ2QbK4MqYIEtyqNbWmcR7aXXry+lM
         TJVwGTyMzDNV/P6ktPaSHqbbnYBNVZSkC/MMDSUHpjrBCyjtvZs+MSoBKCUNvaNCv+er
         gxBddUk+P24XoZn78WSZvtyZ5z3ol89XE0vMJLDyj5EZ4qdP5339+RK8e4lI0dkKBasu
         kkfFCWgcCSsckpwdHl0dwWqZpFMN9fdv/AhcgBBBb1k8x6rBFXI83mjLO4PL0Yk3vQvr
         hakQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbA/ScjkrLcwdSnP8V35OSV6kAM+o4WcaNQ6tCDebrF4LbjOm0e+al94BMO8s5pUOf32a6QDGJ6dL2@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2zj0wnNaW3+6LfzPHEu08AWrKkNqwS10bxDJSyU9GlgaqwxY9
	BrkVlRSJktk8Vjpr/ULzZpgPrTGcIhxOWYy+zrcSGlceDoWibDoES1LWhr0clblKld4QYXJ9HVW
	WrGS93gPz32FrV21N0//hx+caj15Il+UcLRQz
X-Gm-Gg: AZuq6aKaDfk0X5zoB5+2wzv/9VlPenvEhoJEsf852IaG7e0w2AnDuiiJcnqIbwXefmy
	iBqSim0XsB6UPYssx9CZzf0n4LCI9kub+EjvMMfFtBlSUMpAoQI3bCE0NH4fGrQP9/sDTKuouil
	crEa8Qgizp6+mD+qlHlKmtvp+KZbaypg63rz90TkscpZcsuxUKxVMFt0950Quj8S9ujJhpPpsyF
	sMDjVBmeyHlovY1vtSm/B8o2bfzHus7Bx72Dv0sNvJ0yBiHKocSEEEJrnsw6W3XZKlYMXERJngZ
	yRm8JdbswijvPRvcjkQodq/h9UGfmR88K1kCwlI=
X-Received: by 2002:a05:690c:6388:b0:795:e46:4eef with SMTP id
 00721157ae682-79807b4b733mr10428367b3.0.1771499659110; Thu, 19 Feb 2026
 03:14:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
 <1982283.1771499115@warthog.procyon.org.uk>
In-Reply-To: <1982283.1771499115@warthog.procyon.org.uk>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 19 Feb 2026 03:14:08 -0800
X-Gm-Features: AaiRm53HbiuFQ8gaknBXC0Fb0srz3ufgauqc4KJ6OGukDPT1yRnOigK6MxUJKHY
Message-ID: <CAGypqWwO0G0sT1+Tvi9+WRmtVf_exCYmzm15OuB4zSLGgA3Tnw@mail.gmail.com>
Subject: Re: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
To: David Howells <dhowells@redhat.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>, Shyam Prasad <Shyam.Prasad@microsoft.com>, 
	Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2026 at 3:05=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> wrote:
>
> > We are noticing a data corruption issue in kernels based on stable
> > 6.6.y. Especially, when a synchronous writes retried after a
> > connection reset.
> > ...
> > When SMB3 encryption is enabled, partial-page buffered writes hit the
> > synchronous write path in cifs_write_end()
>
> This is pre-netfslib, right?
Yes,  its v6.6 stable kernel which has folio changes but not netfs.
netfs cut happened in the ~6.10 kernel for SMB clients.
