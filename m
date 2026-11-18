Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795023477;
	b=eBWXgxettX60faXKk1hI+P3umWTexV1H2u70GCgUSd1f8CxbpbZ5adorsc9d0wXHbp7v
	 2fktKhb/PAAtZeyvTpuoAnPmKV8qliODt4yvrtIRkD6cfYSiyXQxXWzuXxZFr39dTBpZP
	 YIUYmceo4ELUSAWcdjFZuoAa4dcZZoPb12KlsNt0WkMyfBiy2GEPv9JlTlmZLMeNSK0jV
	 GKTllXI8lsE7tZ+Mgfcq6llnQ9Gr7kIwGr4QRj+Qo7QVd1r56q2lCs+lcW8HrNHgYW9LA
	 ebWJQWb+lB7rnS/0EgrWCf46hYz5dxbyGBG9aN+RiGrQ+ChobOrnRT3NmzEvsQZSBng==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
	b=0qJFqq2HSaLXTd1lxBLeyAHh5YQHcvVfl2NEFnOC28lSmhzBa3PbEjLbXOuXKIZpy68H
	 mccrLF+Kjc2oRVam+KUi9q84PcyINjocRYLnZYQxTZ9xZlzxBz/CfFEJFG86I6y+eHOia
	 8AbiArdq7efhyoMd6eTXCSyhWw/BWtfheQI/Zws5xEcQ/XyCdqPrC+7++KhiAKsti2hAK
	 +6NLYnmz5STw/3RVPiCHZ6sRIcUtdbFT6zfm5slo9rD/GtKPmc9I5wX+5w1gqFDvF6bkr
	 iwodSEU/C+oSPoRZ4GjmFbHsUf01xtFyJvFcO5ghDoG2aX2fAsILKyGfdrVLXFdC09A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4Fx1cvZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D18606A334
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 17:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1D18606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4Fx1cvZ
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c40e30c26a4so14887166b.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 09:37:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795023475; cv=none;
        d=google.com; s=arc-20260327;
        b=Dcic7d5ynNygPZ7cH7UwfcTFR+533NQUpQ23gLAYVUkRNbvdra37SoLmHF5O/6Mk1K
         PgfGGqt8O46g2FfSSH8OBRqRjFkMRA4Yzz/u17eC8zu0r1PJf03lxSAssCr+1oQ+VrzI
         XmGKBetIqiYCjmo54fdDPrjLhF41HyUL7etJ492RPB4SdNi5KVHX0WOgYEYTP1nD2Nyr
         nDV+b9oVeHj2xCXAuDtE5cr6FIuAbYBkI6s/YSZCCEulvdOdff8WOZaiBUFwpS46g53y
         9oz5jLSDCOq2ED9PCpPxRuU11MjWjrEuQB/Ypqj4Xqm9NnaMUZxt294OgJqTOBFiA5F+
         WtEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        fh=40i/1jrUJScsJ5DS0g9xSbbXfQd4RhFbsB7yuKzWv4I=;
        b=HCU4fkCiJAhGot9vBGl77HEx+6zXtOpseQTjwbKoK7wak13AWJboUOTTlmbEz1wJnA
         9cM3HtW/U8lHSiJEf7soU08F5D8C5FuiTMFddty6P2UvVh++MPobsq/2Vi/CMF0x/x19
         w+eN3SixmINKjnLuubx1wdk6ZVPoHzBoLDxC48P9pDJnVommgq+VYGAEbc4IeZQUVPS/
         TSCZ9WxZg0VrNJTmbXczkWQgrAmG3gfd5WoMIDfHrWWqFcxzC5YTrVAd/d6WXHO7AHfB
         IbKe7o7QzRSU3H/KjHnezCGUg8cldHR3eZOC5JMqI7zuncAyjbxdL+2lrBPc6jaQNxKw
         s5jg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795023475; x=1795628275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        b=B4Fx1cvZRSB70oxXa7PXzsQOiKHd8kick7ujHIg5sKZfXngwM/J3md0QrwQw4limgc
         gzD04fGPnUdH4vsdPqK10mZdRL8XnpJIKSo8akWEM5mP1fwpa3D6R1ZVi3kB4ftkkRYT
         t3eglWK1B2yIv1p5oKl1PvLjjuez6SSOZkvKdegYNTew2mBmZIppnHMoZW7XAD514J2T
         Wkz+jc4JDJW+IYh3dYSMGjOQlspp4IYbioQrh478oLfKYgEeEOCfp3zOdH8mfHNwLEAs
         a87jaYO1D21yfJt0MK/CqLT0XQY2LPKrrUvneOLh7WazFrteu6Qq14s3DdjdZZ4eW7Xb
         Uy7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795023475; x=1795628275;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R67yuyz8qBaN7OEJjW4cC9fhK33d87+KjfsWBVWkcBA=;
        b=f2yKgVfwiLXsc/nM4idAop7CfBvDsdMVj14XnogapzEWj0Yr50zx28Lu6NExSlbeIa
         s2pXcdieMM86Wmgy3LooJZHHd80F0TBcmZTrteV4cDTqMa7VXYZl0xV37+JmdScQsSM1
         YMFV/+lThmu6WO/eyDt1ZehN75Ib4NzRk+RtYaqhetDsoTHP5ejK1jwm5Jd+2GfDPccD
         tOyM1EAzAOCr62tYfqx22q5+/2euUsqp0vXqXryEZLe7Fsq1wytvUYQBMdEbHpIyGL6/
         1LeNH3Gr8Q3KIILtSjTkJC8SDNdPyj+zyVArVRUQOZFLolEU9zOjYn3k47pxvkLUg1/q
         Gdbw==
X-Forwarded-Encrypted: i=1; AL+hErFUgNSW/s301hJmxaSNageqqGAXSA7eV8g0gHK7qtJlwAsF4lPb6RrzPIm0fYz+JX74B5TZsd9w2QF7@vger.kernel.org
X-Gm-Message-State: APuU4Z/pSoNJYmnsPpmfjOCLA+r8Ojna/aNVWzpnTdybWqR/YqvmgVjY
	NGqqWerSSJuDHYY3zlvGebZm56u+BbTNKus6nLVrmT0OPQoqcSKZeiG19ekvKGo4e77BulRdNKe
	mrad7DUSmQe2Qrb6IMfBMRUO+a9hbvp4=
X-Gm-Gg: AYBFou1Ln0P6OWLi5LkyPslT+oDcyHg+QOg9o+T4MAOSSRFuAqLMudHunZ/YC/fIiiz
	9Hl1qYq+kKicZvIEXsOHu204mhltYRLCbblXFzIfNbzBo5Koa1kLrNkDUE9pqKekFVP4873p4mU
	b79OymJUD92XzsFFrKgagsZ9FOp17XCkneK124hVsGLlsw92S4VbokO8cxE54SW55l6Ffcc9WqD
	O0UP+W8yKBdIUnofGbU2Ij+LMqsIMGSupsh+A8xRz4lgCPa80Cb8N3awZHAy2vABChim9KV9d8f
	ZQgfOajYpzMXqWbILuFSUv7OwW4SMWPDzQ3Y1KiwpRSNj4hkeN7OutSBKn0fXg8yjtqJS3Lf1rs
	hJgQM49PN18bvp3ieP3T3euOmts1Js1A7WuJlXJH23u4i6kddf/fH6gcvJe5/qhOQahHfoQ==
X-Received: by 2002:a17:907:da1:b0:c49:b6db:1 with SMTP id a640c23a62f3a-c5126364307mr15604866b.12.1795023474965;
 Wed, 18 Nov 2026 09:37:54 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-8-koray.fra@gmail.com>
 <f297d9ea-ebd7-47f4-ab7b-de5c45980000@app.fastmail.com> <CAOQ4uxhpMARO_ZMJDeoa044BwufLVnS0o4Fv0abBF=tjaZmtWQ@mail.gmail.com>
 <cd49ce48-58d7-4341-b4fc-34e63daf3c52@app.fastmail.com> <CAOQ4uxjme9sJ5LGNDnP6rEKZLTJzX_ZdcMohgu2iLULK96GPOA@mail.gmail.com>
 <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
In-Reply-To: <9c4a509c-b6af-4da1-8a64-9d5c26c74bff@app.fastmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Nov 2026 18:37:42 +0100
X-Gm-Features: AclHuK9j8na9qQXXbOgij3n-j2Bo4JySgielhO0fgIJ-weX9anWXgtr5UxF7Q-Y
Message-ID: <CAOQ4uxguPD+PWEUZtAzSdA-15d_C5cn=34ZmCm0v_b0MWK_sfw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/10] nfsd: add provenance time (ptime) via FATTR4_TIME_CREATE
To: Chuck Lever <cel@kernel.org>
Cc: koraynilay <koray.fra@gmail.com>, David Sterba <dsterba@suse.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 18, 2026 at 6:14=E2=80=AFPM Chuck Lever <cel@kernel.org> wrote:
>
>
>
> On Wed, Nov 18, 2026, at 11:36 AM, Amir Goldstein wrote:
> > Can't an NFS client be connected to another NFS server
> > implementation which does allow this?
> >
> > I can't wrap my head around the problem.
>
> You already named the problem in a previous email: What happens
> when the NFS server's kernel is upgraded from an NFSD that exposes
> only btime to one that picks either ptime or btime?
>
> Clients will see a file's btime before the server restart, and
> afterwards, they will see a changed TIME_CREATE but the file's
> NFSv4 change attribute will be unchanged.
>
>

Indeed I have.

My newish proposal (on cover letter thread) is that we
abolish the ptime/btime duality and make mutability of btime
a pre-fs decision which is advertised via the get_fileattr() API.
So from the user POV or nfsd POV the values will never diverge.

Thanks,
Amir.
