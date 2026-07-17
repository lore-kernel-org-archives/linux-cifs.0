Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471252165EA
	for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 12:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784292628; cv=none; b=m+tvoYsb/9bio0PvAJ1EUfA5DIRA3CFM3OIC6NyLgMWj5ahPsI2oqt3Q6NLYfIcXg1jr3NpeP8lSTl9kI3B37m96v2I13VOg/C02IjPCI1h9ePGR9s9nw5p8Myop61E+QPpLWJxG8WnhYvH9YPC82HIhabwM9RKwlPDSwcHbvQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784292628; c=relaxed/simple;
	bh=humEJTEouPCe/J7xDKETPkp6OVwtIDGgCzm84SuOVm0=;
	h=Subject:Content-Disposition:Date:In-Reply-To:Content-Type:To:Cc:
	 From:Message-Id:Mime-Version:References; b=VcRVV8eJuCGO8xyrg2kh3kw0aEiVhzk83oKUfp6rSm6/fevlPTiYxYBvLXWDwmyDV4O7OdlPZicqSOhbpFd7dvz1GWMAqzkj6oT3o+8RYPRbu665h6E7osso02zdJBiP7AwQ9UHJJHRZq4E9bSGe0Yn9qEMpC30GBibpGax4HHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NvepM3lk; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NvepM3lk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784292608;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Fzk3iO0i1p4feH5JCdP2LJz5basXOMQ7LGHvpaXzOlg=;
 b=NvepM3lkri0u/ftqzi/Xv5BkY8TBzUsYk8gKkpEYpM0voYewybiNcYWNU4P1MbhfCxHflB
 pTD+SNexO7UCXvyIj1jmhrxFeAwi/0NCAFanw6jtZu6/qFwpU+FWDalNci7dHMuLNrWqS/
 zEgixzy8uxPIo+FSbIAqHlnQfro8OD09qlGcyNChRh7158LOaGNSucRfM3o8uC1NGJLyqB
 R1usHSYTqxbYAU6uLxbppk6Xm4Qum2xU8pFEsmIiGsVtMbfPZVgr6ShWjBTmgvF6GGstdD
 c6va1S5/JWoexYVAbD51hJ1/UJz3j4atbDciwhYSLtdz1gs3Cy6xbrtSw9MmtQ==
Subject: Re: [RFC 3/3] ksmbd: use splice payloads for simple SMB2 READ
X-Original-From: Wang Zhaolong <wangzhaolong@fygo.io>
Content-Disposition: inline
Received: from MiniServer ([183.34.161.244]) by smtp.larksuite.com with ESMTPS; Fri, 17 Jul 2026 12:50:07 +0000
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 20:49:40 +0800
X-Lms-Return-Path: <lba+26a5a2500+10ab24+vger.kernel.org+wangzhaolong@fygo.io>
In-Reply-To: <CAKYAXd-ymPFFLwW+a6_88LHL_tZXEuffUW8NymbSp3t+OZHosw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
To: "Namjae Jeon" <linkinjeon@kernel.org>
Cc: <linux-cifs@vger.kernel.org>, "Wang Zhaolong" <wangzhaolong@fygo.io>, 
	<smfrench@gmail.com>, <senozhatsky@chromium.org>, <tom@talpey.com>, 
	<linux-kernel@vger.kernel.org>
From: "Wang Zhaolong" <wangzhaolong@fygo.io>
Message-Id: <alok5KscSC-xurtR@MiniServer>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260713071141.3909087-1-wangzhaolong@fnnas.com> <20260713071141.3909087-4-wangzhaolong@fnnas.com> <CAKYAXd-ymPFFLwW+a6_88LHL_tZXEuffUW8NymbSp3t+OZHosw@mail.gmail.com>

On Mon, Jul 13, 2026 at 05:58:46PM +0900, Namjae Jeon wrote:
> On Mon, Jul 13, 2026 at 4:18=E2=80=AFPM wang zhaolong <wangzhaolong@fnnas=
.com> wrote:
> >
> > From: Wang Zhaolong <wangzhaolong@fnnas.com>
> Hi Wang,
>=20
> Could you rebase the series on the current #ksmbd-for-next-next branch
> to test this ?
> >
> > Use the page-backed payload path for plain TCP SMB2 READ requests of at
> > least 64 KiB.
> Could you provide benchmark results ? and requests smaller than 64 KiB
> are unlikely to benefit from this optimization? Theoretically, it
> seems like it would improve, but I am wondering how much performance
> improvement there actually is.
>=20

Hi Namjae,

Thank you for the review.

I rebased the series on the current ksmbd-for-next-next branch. Functional
smoke testing passed.

---

Environment: one QEMU guest; ksmbd and the SMB client communicate over
loopback CIFS; warm 4 GiB regular file; SMB 3.1.1; cache=3Dnone; one
synchronous fio read job; 5 s ramp; 60 s runtime.

  request sizes:  4, 16, 32, 64, 128, 256 KiB, 1 MiB
  thresholds:     baseline, 4, 16, 32, 64, 128, 256 KiB
  formal matrix:  12 matched blocks, 252 valid selected cells
  control cells:  65 single-sample threshold/path-validation cells
  total:          317 accepted observations; no valid selected cell discard=
ed

The formal results below use whole-block paired bootstrap 95% confidence
intervals and Holm correction. BW, mean clat, and P99 clat are ratios to th=
e
baseline; a BW ratio above 1 is better, and latency ratios below 1 are bett=
er.

## RFC 64 KiB threshold versus baseline

 request    BW ratio [95% CI]             Holm p    mean clat    P99 clat
 64 KiB     1.262 [1.217, 1.304] +26.2%   0.00537   0.790 -21.0% 0.780 -22.=
0%
 128 KiB    1.317 [1.274, 1.357] +31.7%   0.00537   0.757 -24.3% 0.730 -27.=
0%
 256 KiB    1.450 [1.424, 1.478] +45.0%   0.00537   0.688 -31.2% 0.591 -40.=
9%
 1 MiB      1.403 [1.315, 1.496] +40.3%   0.00537   0.712 -28.8% 0.778 -22.=
2%

## Experimental 4 KiB threshold versus baseline

This forces the same splice path for the sub-64 KiB requests.

 request    BW ratio [95% CI]             Holm p    mean clat    P99 clat  =
 result
 4 KiB      1.052 [1.031, 1.074] +5.2%    0.01270   0.950 -5.0%  0.948 -5.2=
% ambiguous
 16 KiB     1.135 [1.095, 1.174] +13.5%   0.01270   0.878 -12.2% 0.883 -11.=
7% beneficial
 32 KiB     1.172 [1.151, 1.193] +17.2%   0.00537   0.851 -14.9% 0.842 -15.=
8% beneficial
 64 KiB     1.277 [1.245, 1.306] +27.7%   0.00537   0.781 -21.9% 0.774 -22.=
6% beneficial
 128 KiB    1.335 [1.289, 1.378] +33.5%   0.00537   0.746 -25.4% 0.724 -27.=
6% beneficial
 256 KiB    1.440 [1.398, 1.485] +44.0%   0.00537   0.693 -30.7% 0.602 -39.=
8% beneficial
 1 MiB      1.415 [1.343, 1.487] +41.5%   0.00537   0.706 -29.4% 0.765 -23.=
5% beneficial

## Same-splice control: RFC 64 KiB threshold versus 4 KiB threshold

 request    BW ratio [95% CI]             result
 64 KiB     0.989 [0.965, 1.012]          equivalent
 128 KiB    0.987 [0.969, 1.004]          equivalent
 256 KiB    1.007 [0.984, 1.028]          equivalent
 1 MiB      0.991 [0.941, 1.042]          ambiguous

## Threshold-boundary controls

Each entry is `path / BW change versus the same-run baseline`. L is the leg=
acy
path and S is the splice path. These are single-sample controls, not inputs=
 to
the formal statistical result.

 threshold     4 KiB       16 KiB      32 KiB      64 KiB      128 KiB     =
256 KiB
 4 KiB         S/+4.95%    S/+13.78%   S/+21.14%   S/+26.40%   S/+35.47%   =
-
 16 KiB        L/+2.65%    S/+11.84%   S/+20.20%   S/+26.42%   S/+38.27%   =
-
 32 KiB        L/-1.86%    L/-0.53%    S/+20.28%   S/+27.48%   S/+44.22%   =
-
 64 KiB        L/+4.67%    L/+2.54%    L/+3.52%    S/+32.22%   S/+44.22%   =
-
 128 KiB       L/+2.71%    L/+6.43%    L/+0.73%    L/+3.89%    S/+41.74%   =
-
 256 KiB       L/+3.65%    L/+13.00%   L/+4.18%    L/+8.38%    L/-6.54%    =
S/+31.55%

The ftrace path oracle matched every threshold boundary: below the threshol=
d,
ksmbd_vfs_read handled the request; at and above the threshold,
ksmbd_vfs_read_payload and ksmbd_tcp_write_read_payload handled it.

The 4 KiB result is not sufficient for a threshold decision: its confidence
interval lower bound is +3.1%, below the predeclared +5% benefit criterion.
The data support splice-path benefit from 16 KiB upward in this environment=
.

I will keep 64 KiB as the conservative initial threshold for this RFC. It h=
as
strong results and avoids the inconclusive 4 KiB case. The 16 KiB threshold=
 is
a reasonable follow-up candidate.

Best regards,
Wang Zhaolong
