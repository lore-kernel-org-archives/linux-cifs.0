Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833575;
	b=p3x/qICU/vaSQvaJvdI4Ddl+xrn9iTFuZdwcTnKMZ628UR10MMXuG4BlKM+LBao+p2oO
	 Crjiuf5d8OnIakgVBHuB+zTzuB/nWoURm74F8eG+GqggJENMP0ENkeR4JU0V+C9wlOznp
	 S6ghUbOUllkdk21ZYSRZ9fvjKnq85DAW4msagRcs2J/m5KuEs6o6Lz67LaG4BUai85I38
	 VUlL17gldIInamNOC3tVJsmlCsulR0LYG15NqQ8zXrAjgLZKIbEUVCk39el1XSzbUqmUC
	 j4Hs7N7lbu6aTaXuJzHwzK51+UsNzc+iYpeixRJKw0PDcWvuZ5OWwYM33syUqakYQ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833575;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:X-DetectorID-Processed:
	 Content-Type;
	bh=1o5c/SmXC1d3cq5tJy2yEd5p9DnBV1uQYeSSUuvebpQ=;
	b=g2nQybi3VVHSA3lHYOvLgGi9YzwzPdrfDVRZcqnfT5HHIpia5c/OnlPjFWP5jyNY0Q1B
	 WUOFehSchV5jC8voNBUEn3LdoDmNq3VXm6bM9mE5oGLqen3FD/vjTlCLYZf4LYD9kM4mg
	 73F80PluX16Mgfnzz6RD9rgcociKIRp0p7VQWv9YO2+4Q5bbO09TCsZ2tAnAtsZ7l9u6x
	 BjSReDfsWpp1jrSCVO9/J5LsS2MtJwz70qtCQRTU+m7vYuv5WG+62uTKKGfXaNx/lk7Hn
	 5i4xOViL/8dIvHzMcG7tQpV0aTvUGFK+/YqbKRo9teVy+E5eixZstnvduVeaMCaAJlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=NB9nfZ3G;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0E606A329
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2B0E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=NB9nfZ3G
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso1895227a91.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 04:52:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794833574; x=1795438374;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1o5c/SmXC1d3cq5tJy2yEd5p9DnBV1uQYeSSUuvebpQ=;
        b=CLNMaFOwQNsJzT/NUpGrnmpz33gQO480VhULUp/hK4c+KY46TOdrJMRolzHyLZJUr3
         YpHAy+xZI+2l/e68gPV+oFH8vPWW4tnH+BDhXeY9WQ+s2LfXVyQZsd48WZPVMFpR5shl
         gkZ+4zbgRkzNc/82av6UB6py1c/zOpK4I/Cr9XyiWV9SSlXz8WgWCG1XVyaoXNuPiJDp
         Cj2FLKf7gTj3k/M67PCl41LqsqAKZAg6wkD2HuTmo37V1L6Oo5L0WfdGmzEOVMI7awEE
         o2jMM4heakDd920aduNm7rT85W+xGrpgOuhyq8VmOD+DhrKni5OHjea3pHCQy6MV6j77
         JAEA==
X-Forwarded-Encrypted: i=1; AL+hErHdPZGq2GgaMieeRjzBgdl6tEXJx8H489mHhZfjnngrkLyo+4owlaOKv5IVL9lyKDm7bAgxZqzoY6bP@vger.kernel.org
X-Gm-Message-State: APuU4Z8J6V+pGMgBCtHzy834hlW2C/PqWf7XECZI+YJGh4UM1cFwh25o
	bHmqVVqbidUvos77ps+1XItTs3FsNxpxB8ZBrv53HaqAdKHnVydR9KKzk+yfPGqBuCXeJt+Qddl
	0o5QLT/0cgFwlgtFcK8T500ehHWANHqciZfGyNdDxrGS5FaGebuNhp6Pzr15MYmM7JtYu2jzzJI
	9vfuJERv5WHFCnbF9gcEO87FYbkAp+eAqnHXCcN6uUzbF3fIL1WzXQuBkx/Wl/MNmcypXNQ8czE
	TC+iZodQFbUo2dLOZU5Yw==
X-Gm-Gg: AZFdTZcO/jciaoxwKdAiqNF/+HP+b+dBgN77bKnNEAGCbDWkyNjLsDVOYyWPYV5/D29
	W3FfPWiM7CXR9/jIxy/p4OsAbFlZ1gMjZEoqkycywnOscoiL6VtQGKITAcrFhd0H6uau4gqTDWL
	dL+Xpe+TURHaLdB9yj5HTvJmPtekQ6dfibGZGQ2+DGbBdq73fG+JFWxYwwXFtE/hs/7o1lK9mnK
	hnkTHtsOR5oy2kJgPL0Ucj+62f+VmJhcjKzzsB/TuAK5V/VVcIPbVROgeNCDimRZ34LssPtZ2TM
	gFV13dYy1GfcrTkRsimDfjoTPBvljVA6ul3QRIoYPWT7TdAA31xkIocLFlwO7OETkJN8JCfPT/N
	u6qFtPNS/PXNjzjRyJrsb1l5MriZBoQQ5WPmPiqSZl6VRl57Zg0E+lsecaAgSKlExVMTmHrkxRy
	CYdO38Wj6SzAifp8frovxaz17Vb+R9rHxBAwZOKg==
X-Received: by 2002:a17:90a:e550:b0:3b3:a4ef:dcce with SMTP id 98e67ed59e1d1-3b3a4efdd63mr302913a91.24.1794833573657;
        Mon, 16 Nov 2026 04:52:53 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b197ca0af1sm14033409a91.3.2026.11.16.04.52.53
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 04:52:53 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a0688a43d3so2328385b3a.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 04:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794833572; x=1795438372; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1o5c/SmXC1d3cq5tJy2yEd5p9DnBV1uQYeSSUuvebpQ=;
        b=NB9nfZ3Gj5ISUsIyYKgnidhn2NVWLc+5RfbrjEFfDJhQV+iCkkrKSN4d2cstjKgAIX
         xtBXqlIkHTC5cR6qH1kCGeV5a0b88Vms6He63D2OXow1shHpwmFeYkBadVgHovH7syvY
         ZpjCpG17y5fhSBm6JisM3VgxTVZpVeHCrPYw8=
X-Forwarded-Encrypted: i=1; AL+hErFmBtQtWezMXCl6z+KmE8Z45BMaH/P8TAOA2ZI1utDEeE0nAoYLFaNQLQN8ZVgDVdNFJ8rSLKuIBWwf@vger.kernel.org
X-Received: by 2002:a05:6a00:94e2:b0:886:458a:42e9 with SMTP id d2e1a72fcca58-8beb7a215b4mr8976134b3a.49.1794833571785;
        Mon, 16 Nov 2026 04:52:51 -0800 (PST)
X-Received: by 2002:a05:6a00:94e2:b0:886:458a:42e9 with SMTP id
 d2e1a72fcca58-8beb7a215b4mr8976113b3a.49.1794833571334; Mon, 16 Nov 2026
 04:52:51 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116074849.475815-1-stefan.chulski@broadcom.com> <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
In-Reply-To: <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
From: Stefan Chulski <stefan.chulski@broadcom.com>
Date: Mon, 16 Nov 2026 14:52:38 +0200
X-Gm-Features: AclHuK9lYUd8y1LqoNm1jEUvWpEAcJYPxDr98Khy91qci9OKo3WAm_R4ih0-tig
Message-ID: <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilya Lifshits <ilya.lifshits@broadcom.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000007f39290660644163"

--0000000000007f39290660644163
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 2:10=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Mon, Nov 16, 2026 at 4:49=E2=80=AFPM Stefan Chulski
> <stefan.chulski@broadcom.com> wrote:
> >
> > The "ksmbd-io" workqueue has always been per-CPU. Commit 69635d7f4b34
> > ("fs: WQ_PERCPU added to alloc_workqueue users") only made that
> > default explicit as part of the treewide transition to unbound-by-defau=
lt;
> > it was not a ksmbd-specific decision.
> >
> > Per-CPU work keeps request processing on the CPU that queued it, which
> > is good for cache locality, but it also runs work on CPUs that were
> > isolated from workqueue noise (isolcpus=3D, nohz_full=3D) and prevents =
the
> > scheduler from placing blocked or long-running workers elsewhere.
> > Which behaviour is better depends on the workload and platform.
> >
> > Add a boolean use_unbound_wq module parameter. It defaults to false, so
> > behaviour is unchanged unless it is set; when true, "ksmbd-io" is
> > allocated with WQ_UNBOUND instead of WQ_PERCPU. The "ksmbd-break"
> > workqueue is already WQ_UNBOUND and is not affected.
> >
> > Document the parameter in ksmbd.rst.
> >
> > Signed-off-by: Stefan Chulski <stefan.chulski@broadcom.com>
> Hi Stefan,
>
> Do you have numbers comparing the per-CPU and unbound queues,

Yes, on our systems we observed up to an 18% performance improvement
when using the unbound workqueue.

The primary reason for this improvement is that with the default
per-CPU workqueue, ksmbd-io work can sometimes start on a CPU that is
already heavily loaded. Because it is bound to that specific CPU, the
scheduler cannot move it to a less loaded or idle CPU, leading to
bottlenecks. By using WQ_UNBOUND, the scheduler is free to migrate the
work to less loaded CPUs, which significantly improves our CPU cycle
efficiency.

> How does this compare with the earlier following RFC ?
>
> https://lore.kernel.org/linux-cifs/20261022092514.2590010-1-huiwen.he@lin=
ux.dev/
>
> Thanks.

While both address the underlying scheduling limitations of per-CPU
workqueues for ksmbd, my patch introduces the `use_unbound_wq` module
parameter rather than changing the behavior unconditionally. Because
the optimal behavior (cache locality vs. load balancing) heavily
depends on the specific workload and platform, this approach keeps the
existing per-CPU behavior as the default while allowing platforms to
easily opt-in to the unbound workqueue when it yields better
performance.

Thanks,
Stefan

--0000000000007f39290660644163
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
+on8kJB/PnAxkj03/27iq+2cUc24qOys/j8E0+8b7g8IqeBaIpwClphXMx05qyEBoWMAIpQLZbkr
OATk694WJesPHv9odFrMQtDbCLh16vurgAd9Qq6mgitZPPT/GHV13zkVnDcZWG4aDngDu5ndfy24
0TvBvFiz97uV//NoG5MT5mkYufFR7tyBwvBpDXUTVfngSJoqcaYQp1VFSBfcxcwHZrHAg0JIoAwz
hB4nFy1Atlx2IGORgTec+dS1Pqb/eM9gFpM7GIvVcUZJeo0CAwEAAaOCAd8wggHbMA4GA1UdDwEB
/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0
cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5
BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIz
MGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsG
AQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4
MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmww
JgYDVR0RBB8wHYEbc3RlZmFuLmNodWxza2lAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUF
BwMEMB8GA1UdIwQYMBaAFAApNp5ceroPry1QLdugI4UYsKCSMB0GA1UdDgQWBBSA6GJTxU+RxobV
IBVB3gwY7k1pCjANBgkqhkiG9w0BAQsFAAOCAgEAKfbTNIK78LyptWReJFdtRrzB9gx3Jofx6oEu
aSkOv5+3/KNAtjL+sY/p0my4x5xAr+mHI6MNDedzID49xZdmI5u3800ZMGWXmrbaRpWmfo09/wOQ
xGZtfLy1H4piX46qT1DZkmiQtQYkaa7xRI2uiYZdllc+582mK7AGYmqPQFqbh8gX5DvxFV3kq8O0
0gsh5AIE7tRHb6VfZ3JCjxTqdiwL8WnTY7FslEK3p4Wc2A7ZxJM6amC+a2W7OqJGc+g/V/u9FZrO
RhtLtawYf/avRo5+p+cjx4rwXN7jN5qK28puewzFfxLTUsUEkyuICNEBK1xfUjeRwLrIN7M5+PDK
j66gi0licY/V9HrmbDOWh0bLATQTchsWZhY9Ih95akVDxnojrIHWohI6/ErCVV/G8qxL++gYG/rF
cW8Vyymevyu0yuWWLQYWWUONLwyXXNax3Nb+5gBB8tZnS/ByN5EIRsD9bWBk0Tq/P8cAfgpFyZiX
Zk/VjquAbx6WvASAhn/DcOGK5Uv8zH4HdeP+28/g+3owRPfiAppmcf4PHwoaxLA8BxVxvGh2Picq
y9is+1FwS9+fDcaMBLN8gZ/2OR0AYIekVjw4CASYMdNqfA/hvArgxjbhU/NhnxRTJ8kPZE5HCzyJ
/umztNrpaS8TJ+9J2QY2KsZTT3BQzF0AEejizDwxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBT
TUlNRSBDQSAyMDIzAgw32pL13CSveOhTCOgwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkE
MSIEIAvuchvdb+8v+FOrs/F6LepDcrVis4lcasz9bhXQpM0hMBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MTExNjEyNTI1MlowXAYJKoZIhvcNAQkPMU8wTTALBglg
hkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAAuv02rND9B+Vl9jEXwbinHxaPYb12Gq
kUdDUrZenhh985Dk3FqzyKfO1JPOVwAokAb3yVGR0zCuijNN4oF4b6XyzXsiTwELh8PXD+tWYoCU
5efTSRWWwoNyrg2JbPZ3lB5gOTpjVCEAKYpX+9RHZra7RLMemJwiwL9a8FRFMkEr6Qock0wxeVze
m++lJKFWeqrEX8XZBW3dUfcW+7Y7czrSy4ikcpyRmsK159K7cPdX73vGhCRxWpseyrQhpMdTSZiy
xrf5TlKxJiHUVjxH4C9ktw3qaSrio8ON7tJzeO9yTLH4ASdmYxBeD1IcXjJYSfHa8woN4crDF5j+
V+NXU9E=
--0000000000007f39290660644163--
