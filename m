Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154625;
	b=Dk4XCJihU/UAiNuzCv8PxJGJKG1ZgITIP49VNrLkP0FqphrznYzioSgfFtsp+jtvJtxJ
	 omEYY0OhyTnt7Eo52wvCmeFpbzqg09KAXsarVDaKUVIttvbnK2oygL278J4o/eYwQMRTy
	 PvNq3Ws93lWjCXi3t0O5y/jQzOtNpsJFsbGu99HDh/bzcsGZWpRHImfYkLjaa6bXP8drj
	 EVotKYGVkUQV6OhoIcB607kKtOmPigbqzOTKYa9ibWxo+fcNLhiC6bgW5FqV0qHDfLEIV
	 0JfI9SnCH+PsjacXflVQ8NjuvkSxU8REJ5oBwkSYLN8RUCej02EKamG8c39LXFdvnfw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154625;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
	b=SjJxmbbGlUt5bOaUz4aRTZcTFHoReSMJfHrI806BPQDakfHRxS4SrlVmjrvSN+NQBQck
	 uHaSsIVZ+92QRA7hmGyQyWJvf4zQTDj98eynq+pWnsYulYHCSSSK3HCLahlGckDMkcG9l
	 dlJhOJXCg7OBUJGGYEWWzKEualH82zcV0pP6hRgVHEdnbxWjKingPgum4SdqjAEPr0my1
	 157rQEXTpvUTN+jnifW4IiMz+T0BnCYO06zlJFkpqCx+fLn11k85B4fgOJQDAHZLEk6v5
	 lzX73xTC4fdC8s3uPCizdpVvJ8IQMxM6D50/un9H6ThDPNtw5jHwmgo5zHQMYpoVUyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=twd3LSyP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E3660A2608
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 06:03:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87E3660A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=twd3LSyP
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so668106a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 22:03:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795154624; cv=none;
        d=google.com; s=arc-20260327;
        b=mmuipdGl4nY+/z//yRwABvKryCP9w33d5fb0LUzPpEM/e61dACQEdYtBl7GL6grJzQ
         i4ZLaE2l2TvMiypENNEAbLZaCj75G6sK1LN+gZ8MVDmUK8taEjLyW6ApIGB5T4lRChDg
         e41gk7dafFgRU0LwXJKrYTHtQba7/3mDcUQHATG5jFFUShBJ6z+/BGdkQTarcPIOmLiY
         JaoI9pTuHiQqTpnUDKm+FnemC9CgLdphIk/8mvTGxayHgKCfmMzdxXpHMSNqtaOIeBBC
         17RNpsXrHphE10R0kx253HQ8fK0S67BJKUdlP8+3V7GQ1HZcLUPcj9Q7XuOPHGM6rX+V
         3cPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
        fh=bYdE/Qx8y+bqgLKyEigHlLIMjD4/XDcHDzTJyQFWt6I=;
        b=X0VrRW8fSNzt2IdPTj9tmBJkHCMnIL7b/acoP4dROokNEZXyRYVw2TnqFNDqyPWZXm
         a1Yol11oXesIDNvWzCIqwMs1Vr1lP8+Jl3W2H0U4PCV/OC+ROX7W6G8tFFjrjyZuwpUn
         q/bx/lXA1FOR8O0E4dquRudUJb2VWIjBO2UG20Wk3tRI4ce9zseMyxRph8LaLGFxrnJ7
         m7gVMbqGo6N7e1P/JA9DZuWpjTX4I4oKD6lC4AFgAm/CX+wuD0HBvTcSdac/wUuvh0wo
         xpYdI20Wpozc5CVUASOUeEGQd03VbTF9JUQg4RD2keKzl5/IID/9fvk3/DbQTVFyLnL4
         rRBQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795154624; x=1795759424; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
        b=twd3LSyPhh/xqGTUhGQCUkwTgPz0ozSKLDTUdzWfuC88iwf9vuQaz4Cbapmx3zwlEj
         zlPpp5xjkBRG0SDqC55ar8nBqU+85ZN/BbmT34kWJ4vxhbdyZbdyEQy2606KHlPpAcFA
         JFJXbHJDQWbyltdYp5JJ76dGIZsXzMVaFFB2lWR6MIffBbfdMhvs931PsHwOVCxf6WxW
         wy21QWjJiN1/vrK+nMRXh+VMOYDU0hoTkIxn3m45nhUC91hezeDKP97nETUPcHv6eNo8
         2LkA2JYHzh73ui1UQni7id0o3aSMFPuYuUQVmp+IzjGqkrZikwiCYxOEdafgsA18VMyB
         JQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795154624; x=1795759424;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pGOGVjzDtRAIxks4mvGvAXFdrHYvYvSfhVh3EqISUwM=;
        b=N8lJkGeNcbreLhJPjohmQUMvM2S/SyYr2WW+qCgdaB6/FdJO6DmyOyP8uzGjJ1lUun
         /cFAzPJqh4tPIcyDl10WpZlAEY7i4jXR0f5RXYmcFrqNFzubSrwisuGGhHAXbfjvrem7
         qkNjCyjpL42eH5vkazpml005jIjvlaTPYCuYM9TebAknnRtvicWgwPpLhd6k43y1Fdt7
         QkiEuH01kwB5xeuxnF4xRSKjnxQnKmgGtznXy90e4SDkae3j/bMMqyLGohDescvVWnB0
         HG+scIHiCoHQJTuv/5Cp0JPpM8e28gOjab2OT/drkfSjpnqBhnRFBLN6Ofsfls127twe
         nv2Q==
X-Forwarded-Encrypted: i=1; AL+hErHeekNTo4vHnqSNj33ZnMrxTAf5gQBxjfVBhimPIvx41z7oKH/hx5WodECZIEaFavlchzk1UB+b2lrn@vger.kernel.org
X-Gm-Message-State: APuU4Z/gr9Nx516Y9l+USCaFbOvfVKhiNrFYYbz6PP9QI+IYhC0gjH9K
	/3h5NV9DMQCm59cGL+mXDNi0tPkOBSJ1K9K/b+v2hX2pGW91AB4WcjV5wDr3DsWOv4u2a1SYSfP
	+tXxBpevuGOFUFiFdi5f6wfauBNZfYTg=
X-Gm-Gg: AZFdTZd25HIDMvww3MqaXpWM3BnXHZWEFSWdklFVpErpXL9rQVoms/Dwg0h4r3D+OIn
	ellE6os9+NQxp/yQCQd5+gIaj06XK9hSO1yeyKt0EVArhVjkrhTteTbmReoWMe3H8sm0/Zhk/AF
	aVNVx1zbTO6gKTO15sUnyVWT5DCY+S208bFjDGynHfs8PwXctP9++pSTm0auwzk3+FG/nS2xhZp
	KkuXoy4dLZKCCkoYGfKaLt7Gs5crvvfph8iOmKKIRcDuQJYfhPhuBI6D4d7h3AxQtSWpe1PxnGP
	FkwedoNgrBkNgGfX5UniX7af15q65phQ9R7Fcb9xyfcONKSza+kHEG/TUc4imqeAjTcdxKE2nTB
	NN4FMtmiPrq6UF++KRpMI8BNIdnJd4wMWn1iIkypP1/KPL2x2H/hJmPig28w6ll0+3QXpmzU54I
	8t8YAc+R38Q+MlVVU=
X-Received: by 2002:a05:6402:e06:b0:6b5:4f5c:cb2 with SMTP id
 4fb4d7f45d1cf-6ba37ec320fmr1108851a12.34.1795154623771; Thu, 19 Nov 2026
 22:03:43 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-10-koray.fra@gmail.com>
 <CAOQ4uxhjxp5sxYphWoB=8sgX3XHOv9zLVYf+8ZjYbS_gQDxO3w@mail.gmail.com>
 <DMZIQG4U1NTH.2IN0S2YIWEYTG@gmail.com> <20261119220936.mssmaixcorn2gzli@pali> <DMZJGB07CO56.IZ20OCGGH6C@gmail.com>
In-Reply-To: <DMZJGB07CO56.IZ20OCGGH6C@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Nov 2026 07:03:31 +0100
X-Gm-Features: Aa3M54rvTAbJYlhFUqobPAqFrpuIqbxGTrlnaPynQQoE0nz09X_6dT10Gv8Q47Y
Message-ID: <CAOQ4uxhqgsh9ahJsX7C4YyZH2n_r8VwOe9X9jZwsKALCoYvyag@mail.gmail.com>
Subject: Re: [RFC PATCH v4 09/10] ksmbd: add provenance time (ptime) and map
 it to CreationTime
To: koraynilay <koray.fra@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	exfat@lists.linux.dev, ntfs3@lists.linux.dev, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 11:25=E2=80=AFPM koraynilay <koray.fra@gmail.com> w=
rote:
>
> On Thu Nov 19, 2026 at 11:09 PM CET, Pali Roh=C3=A1r wrote:
> > On Thursday 19 November 2026 22:51:26 koraynilay wrote:
> >> On Thu Nov 19, 2026 at 6:34 PM CET, Amir Goldstein wrote:
> >> > On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.=
com> wrote:
> >> >>
> >> >> Implement provenance time (ptime) in ksmbd, as introduced in a
> >> >> previous commit ("vfs: add provenance time (ptime)").
> >> >>
> >> >> Map it to SMB's CreationTime, making it settable by SMB clients. Wh=
en
> >> >> reporting CreationTime to clients, prioritize ptime over da.create_=
time
> >> >> memorized in the user.DOSATTRIB xattr.
> >> >
> >> > That doesn't sound like the right thing to do.
> >> >
> >> > If the server stored a CreationTime that client had set, you cannot
> >> > override this.
> >>
> >> Ah, yes, but how would we handle older files which get a custom
> >> CreationTime both before (in the xattr) and after (in ptime) a kernel
> >> upgrade?
> >
> > Just to note that this problem is already there. ksmbd can export for
> > example ntfs filesystem on removable disk. And this removable disk can
> > be connected to Windows machine which will always only touch
> > CreationTime and ignores xattr DOSATTRIB.
> >
> >> > When the client sets CreationTime, the server can decide if it can a=
nd wants
> >> > (may be a policy decision) to store CreationTime in PTIME and not st=
ore
> >> > it in user.DOSATTRIB.
> >>
> >> To fix the above problem we should probably keep storing it in both
> >> ptime and the xattr though.
> >
> > IMHO for a long term solution it is better to not have duplicated
> > information in xattr. Because duplicated information are going to be
> > out-of-sync. Windows NTFS driver will not update xattr DOSATTRIB.
>
> Yeah, to avoid out-of-sync issues is why I made ksmbd prefer ptime over
> the xattr's CreationTime.
>
> >
> > For me it looks like that this needs some policy / configuration
> > decision done by user. We do not know if the user will replug that disk
> > also to Windows NTFS driver (and then those xattr DOSATTRIB could cause
> > out-of-sync issues) or will only use it from Linux or Samba and then
> > xattr DOSATTRIB is probably fine.
>
> I'm not sure if this is the best solution, it doesn't feel too right
> to me, but maybe there isn't a better one.
>

If you ask me, this is not your problem and I agree with Pali that
this is a policy decision.

I would not include this patch at all in the series if I were you.
Maybe as a demo user, but you could just as well include a demo
user application.

The nfsd user is a simpler demo, so as long as the nfsd maintainers
are on the same page wrt the mutable btime plan, you could include
it in your series.

The problem you raise with DOSATTRIB xattr is similar to the problems
that Chuck raised for ptime vs. btime as the source of FATTR4_TIME_CREATE

Thanks,
Amir.
