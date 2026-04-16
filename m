Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98A539D6EA
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 12:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776342695; cv=pass; b=OFcb4Uzp6dJ5goVqR/yZCdrddZazIvNLSmZhdn7GUhEOnupcGl6GELmVfjdWVnYyMiPh57q+weP1QHnl29KHbMZC4NVk0LyOehpgEC+9cLET1KtmFkE06od7joznvTRt19xGjs4Nv+lyhHYyHOmS/hOdTUPS+Y+0PKiAkcg3NwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776342695; c=relaxed/simple;
	bh=1foxb2XbhwoaiqgWKnSMylvJvOALw7VOGS+0GSZBLy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rAZLgxJ88JKv+0YDpKdO4eomxNcv1Jm53Y5ckiV43yn9t8rWvJsC2YPKUGrlgLNolgKV+4KEhAZa3HpjVyQ/pUAi8tGmK1NTw3oO/8ABOlXkte27QWDjXNzscLt3/3/Hq9usr1hMpf1paImLwUXjANQJ+JJZUgMbvxMBrERewYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n1vjq4+T; arc=pass smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n1vjq4+T"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-794719afcd4so86157757b3.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 05:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776342693; cv=none;
        d=google.com; s=arc-20240605;
        b=VFsYf1x9Aa5BKDa0nARhtkEO1bhMnjrIxF+8hwzkSuQ/vlGdcBHMi6t0p9zTZoTue5
         IB9XTsUOWrdiDkCn9tZr4D0vVi8O4KboFgHQO16HTyCyOPZBJ7GA6DCV5+1HGbBQ4CFv
         3Q+jknwib9/wBkdkivJQrXv1/u63x81N96TUy3pRUJ9HUdqZjvGecsINGiMN1Cl+J8jd
         WgVoiTPBOXdQ2t9+JsiZC4ub3vSb6R2EFVEucKC4NwoQrAbOu8K6HLD8GFiOW61NoGZR
         kyZmtKC1Fxqrx9X+wCOFc+5+7+2C8fgGl9fkH6xdLPmBKYojkPWPNe/cz7UqMu7+k+ve
         q6gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yp6YdSs5n62rLAXnXK4Ph/XrzamVhhUR8LZ+qIJe3bU=;
        fh=BW0R8rsxojpAvGnZwO/vR7iBMTvIVSq4EkQsxnbf8MQ=;
        b=IZxUN4h2Ul/dPNMbVda3XILU/2zWqh+iK8FiN4q2IfG4D/W9VYEvmtsea61u0rP4wR
         2L6VMbJH63SLc0H2mrjN10vgLNKcm84jzdzEwqwJFPJCQMZjFYozREo3tQi2a+7XMOc9
         Z0rK4Y0qjkbWpCcoA0dZroOfWyiaOJ/fg5M2QlvpMffAuqQsLQ4nLS+NmekJchGUor9f
         jbuLRtnv7MMe1UOxfLeMNBz8BEq5iH4UMthjcJaZQ+yWVISN4pFSUCDCz0Z+4s9Ygdpg
         ipfKOVj7g5KhoTZH/xk+lJUTDDfvjsi+haeD9nj/71tqDGECXTqMRMoWVavDLiGYcbmY
         hVZg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776342693; x=1776947493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yp6YdSs5n62rLAXnXK4Ph/XrzamVhhUR8LZ+qIJe3bU=;
        b=n1vjq4+TiNs7OdQgXfOQzBbcL/wHj4op0ugOTl3NLmdvHzUU75FzB8w9js5XCoDMNJ
         F9zKHQJ6dJTMqvUKeOO0IdrCHvmLsEjzHAnLwcyhWz+AcSaEpxlXVlbPi4JSAQCvzaO0
         bhAyZKPvgMrg0d98wR/9ViYSvKbVfT9JhZcTNlepN5XttnGKCfjj4oKECje9Xb50mZNo
         /Nurvapd+RDXz206b4PsYLSMifk9QcExHGsEixsfZ+vb4CCQr+ygXKLi9FKpvdQwrCTC
         ISo1G4YK7e2Fs/unfrKovYZa+j5FpZfkJRDtlZU1BpBGkUtPaaC61MguuU7zNJH2+Iu3
         1s/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776342693; x=1776947493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yp6YdSs5n62rLAXnXK4Ph/XrzamVhhUR8LZ+qIJe3bU=;
        b=R0K8ZRoklg/TyIwPV036RTLPwrE5rsmAVfzFiQ3hocZomaAxfJ7/oq/GmZgij6xBXZ
         0d5eGA+PItyMnvltZjn6rMhq57w1L25gMzp29OC1c0sSBioVFviwoYAHRRvH/eY8ezaU
         xA1z82HT8s5fF1x3xKpqbMLgS+MbsGrHZdHQ6YvIIV3ykdoWFygLcp4dynkzC0JMNqdM
         N9iGfYuf1KLGfQHOyW7UQVLqFBVdGNGBXxem7Vv0r/M1PmpUtLGKs3rlfqmiKG2Jxdl6
         wnhRbM9HdgQ4iiNRDG8j+SzFMa03j4d2EbNiNXH8bxw3EUKQqc5GGn6IflPYRMwJXFGr
         XKlw==
X-Forwarded-Encrypted: i=1; AFNElJ8KIly7cPNvJzpMAqjuMrHNNARHNhq6XxH4WESWzL6D9AkR5hgjkpHv3aovegYYGvGU/Ybr7UaY+qiK@vger.kernel.org
X-Gm-Message-State: AOJu0YyXGSz1HrGaqnk6W7aiIEQnqjMjHzK8+dIUTeyK/e3gAkvIweu+
	7IDw6/lMhA3hoHe4YihIcdcgWqnXse1gvzJ43unU403QsZG/9ZLCpeGnY7pyB91ceaNclelsVYB
	S21pnFvwk/dWWDXXG0fl1DERqdJaB6TI=
X-Gm-Gg: AeBDiet3837kz8bVC/degvqo4iQgqAttnGjDN574ghw+/W50kaK+2H3DBrkH98qeV5o
	sQFxqrTiljAepzjXudwBHk2m04DqOfEkvc+/GD3joLX62QmjW1riYiZcmag4cfYTuRWETWy3hPt
	UggHn5EyaKEP35WIdiX8saXH7pNAWpDI0YGsjJ5Ad0m0C0JtMj/TUFz21ks0Q+5tMhsKpne1hfx
	71P7y3NbYgiwMQXogVpNorxocVnlRbdfbqe+9ZWxn0GptANBSZY50oJ9gQSoB2I2bft7xKpgQgM
	NxszuTgZOwAx7GA=
X-Received: by 2002:a05:690c:85:b0:7b4:6f40:635 with SMTP id
 00721157ae682-7b46f400c77mr141541987b3.16.1776342692805; Thu, 16 Apr 2026
 05:31:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129140948.621754-1-plambri@redhat.com> <CAH2r5mvgd9W4QJ603uv9UAQ6R=ASnORea532o8Ok7kjhJvEh4A@mail.gmail.com>
In-Reply-To: <CAH2r5mvgd9W4QJ603uv9UAQ6R=ASnORea532o8Ok7kjhJvEh4A@mail.gmail.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 16 Apr 2026 12:31:21 +0000
X-Gm-Features: AQROBzCm_obqq7kWpQBYNw479ojC8g-TOPkBYhX2sX85Kv-5crrm2sVT3eT06tU
Message-ID: <CAGypqWx=051_KjZrfhXJfKVKjRDszkAXNz4fRfvv3S74g+BF=w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] cifs.upcall: add option to enable debug logs
To: Steve French <smfrench@gmail.com>
Cc: Pierguido Lambri <plambri@redhat.com>, 
	Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 13, 2026 at 7:23=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> merged the three patches into cifs-utils for-next
>
> On Thu, Jan 29, 2026 at 8:09=E2=80=AFAM Pierguido Lambri <plambri@redhat.=
com> wrote:
> >
> > cifs.upcall uses two levels of logs, DEBUG and ERR.
> > However, when using systemd, these logs will always be recorded.
> > When the system does a lot of upcalls, the journal could be filled
> > with debug logs, which may not be useful at that time.
> > Added then a new option '-d' to enable debug logs only when needed.
> > This will set a logmask up to LOG_DEBUG instead of the default
> > of LOG_ERR, thus reducing the amount of logs when no debug is needed.
> >
> > Signed-off-by: Pierguido Lambri <plambri@redhat.com>
> > Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> > ---
> >  cifs.upcall.c | 12 ++++++++++--
> >  1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > index 69e27a3..9c2843d 100644
> > --- a/cifs.upcall.c
> > +++ b/cifs.upcall.c
> > @@ -1356,7 +1356,7 @@ lowercase_string(char *c)
> >
> >  static void usage(void)
> >  {
> > -       fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/k=
rb5.conf] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
> > +       fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/k=
rb5.conf] [-d] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
> >  }
> >
> >  static const struct option long_options[] =3D {
> > @@ -1379,6 +1379,7 @@ int main(const int argc, char *const argv[])
> >         size_t datalen;
> >         long rc =3D 1;
> >         int c;
> > +       int mask;
> >         bool try_dns =3D false, legacy_uid =3D false , env_probe =3D tr=
ue;
> >         char *buf;
> >         char hostbuf[NI_MAXHOST], *host;
> > @@ -1395,12 +1396,19 @@ int main(const int argc, char *const argv[])
> >         hostbuf[0] =3D '\0';
> >
> >         openlog(prog, 0, LOG_DAEMON);
> > +       mask =3D LOG_UPTO(LOG_ERR);
> > +       setlogmask(mask);
> >
> > -       while ((c =3D getopt_long(argc, argv, "cEk:K:ltve:", long_optio=
ns, NULL)) !=3D -1) {
> > +       while ((c =3D getopt_long(argc, argv, "cdEk:K:ltve:", long_opti=
ons, NULL)) !=3D -1) {
> >                 switch (c) {
> >                 case 'c':
> >                         /* legacy option -- skip it */
> >                         break;
> > +               case 'd':
> > +                       /* enable debug logs */
> > +                       mask =3D LOG_UPTO(LOG_DEBUG);
> > +                       setlogmask(mask);
> > +                       break;

I agree that journal can get very verbose when cifs makes many upcalls.
Looks like logging behavior is similar across other cifs-utils
programs like cifs-idmap.

If we need debug logs from customer devices, asking them to manually modify
cifs.spnego.conf with -d could be error-prone.

Should we consider a standardized way to enable debug logging across all
cifs-utils components and also with per binary basis to ensure
consistent behavior
and reduce misconfig?
One idea could be something like having /etc/cifs-utils/debug file to confi=
gure
debug level for cifs-utils and also additionally for per binary level.
Thoughts.?
