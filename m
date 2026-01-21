Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FF93D34AE
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 04:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768970735; cv=pass; b=aEkDtAloT5SPxvyuveOWjeziLZ5p/BhvuzqKIpnxOUpNzxpQCGRreGsDtc+qz4cLHj6Rbs0aYPXGE60hFAKAXRIYh40U2hws7PkBE4FLLHv9eRbxk2VRMJhAfXwrvax30WHrKdN6hmeTex6+d2ZEoAbq2VYa1+AGxFHyhdtdqxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768970735; c=relaxed/simple;
	bh=gCUN6OAIvzGb/MjgerTWWaca6dxhvDUmClKm+Del618=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kCt8nr85+rxswTIZ6NKA7uj9jtvSWDVUXCdCZwl+kVgW3lQAymsl5ZOfEJS2Wvyy6zAAxBs1zECBUMIUq2Oq4o8JOJD8QRmUc03FZkZSsRqOmwotYWxV+WJnGlpacL4/DnPW2uDAF+ZuvOhhiPOOblfyqKhRzcR4mDbVrjE/XiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bT9ZYK3B; arc=pass smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bT9ZYK3B"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b876c0d5318so811222266b.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 20:45:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768970732; cv=none;
        d=google.com; s=arc-20240605;
        b=RQsW5FGibRR5F9vLMBINlH6oltXLdoYCJqo4gQHnFLvCEPNOYKUOGFCXR8b48IXZCS
         +cfA9zKPthybqQjmWfYLzejZx1XzIN9ex3/jlmzWXzXSVPt2gpWlRc4uh8mQ763OBGaT
         7kA8Bqe5Mmfap696Hvy5Q38qNY+Bcxe76tKoubWy1OgoRz2vrKwkLTHuvKNLOTnHmlL8
         rAyDsIKX0DPMM7RPIdiWHBJur5fwqk4to5kXn+wWbXF32pwrW2Af/PGow0BsEuLztz9n
         EjBFkr9+muS/SG7GqzEHeXtMwmHvN+7KCwZNGHNAZVl4gzOntF70xzHaYkWDpVo22yAt
         GUGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C8x3buc9DsmMK03+taROY+CIGN/wpygJa9yxTRvp0FQ=;
        fh=ivCwkVCbTDUI/zL2b/roBiCbp/G9xQ3FpSiz58Fn7qk=;
        b=eYRJ+LCy+JAwth7Yy9HyfMF9fOqRC1lNDCX9GaGrfRzP0iM8cOp1FzboayqZicpUZ4
         s/0o/0SZfOBDm2o+KBhzO0T6zGH0LElcJEXUUOJFPRUe4Z8zGlnS3Rn1V21hjTy6tWRZ
         RVWIeB2c9SPoh4v2jHLUQ3V+zAaMyt1gQmarTAp31HEOV+u5ateND2ZoVmHk3LvRmp6d
         cb37D4n9UTuV4UYVmGcSOn7wQ/W2ctPv6zf79rvTEPKtejBk3/2gFAiMdyQVRAGJyPcq
         SN9T3b6215xNf/Kf+xZVXq7eW0+oxC9ejR2QYZ5PzHYV2V3fOUG+bd5uyOFQZFHoOFIz
         HhFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768970732; x=1769575532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8x3buc9DsmMK03+taROY+CIGN/wpygJa9yxTRvp0FQ=;
        b=bT9ZYK3Byu4Wy4yGcGahNJ1pRpmSDl6mb2pyRKU+H3v9Ibk33sEufX07In0qpFpzyK
         tk/SPPXuJM66JAcul94dj6LMT7HdgJqul2nxwDDF1qFfu6Yc/YQ0Dvxa74WHNtWhSH5E
         e+Al2eg2wnslRifuX8aLSWHZoJ4oCtesLH+2J9pg4YBJ1fhVbF2D1l1lyNYASFHWR2WK
         uQupYfYTZ/chYCa6Gqh3cUS03n1x86Wh+psV0RVajDirjxyDw4q2mcurUjGPqBT+ulV1
         Jzuy8c3/VlS4fk52Q95l1B4Rm5s6u4s5GdksGS8pwGqzL+wvoXggql8U/FlWqbqLgMGl
         0zOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768970732; x=1769575532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C8x3buc9DsmMK03+taROY+CIGN/wpygJa9yxTRvp0FQ=;
        b=N93xw3rjy++UF5QYDzIZjVj93JiZEC3vLyE1ZQF3QRWzlbDw4A1rcKJ8Kli9fW4HMI
         fkIGxFebfC6YnZLeIwIGoMz95Sv/F3rMtGE1Y7EwAA2ers19Pzyg/ZGhyLfL+O6N9LBA
         4xDRUhbrSqFe9Dx1wU6oROW0JZTC0QI0CUD5vcLEnN4vgSUsWzpALs0UwIG6csJ/RaX+
         Xf7EwGgVI7obanBR2cahn6qEDr+fJTKAkM4grS5MvjqGQrYIoOcn8ynikFcDXyKpZrwG
         EmcZw4zQHcD/7/I6yrJgb5ICOs0cEMvD0LC76pH4+7dRKVA+v9b4TY3q047pJO5ZehsW
         x18w==
X-Gm-Message-State: AOJu0Ywj8dz1r49YTR5hM+DKbObNDNHHAEK/qm40P7M0pJdnD/7aXRET
	mf4AMg/MtPblBlDUFbqXri+19CsGxohXA/3ATCpe9JcxadtgTLYOOJD1dL+6wvyLCOZe29tvgnW
	UZJGsgw0cngNclLhHhPGqNU7Vt06Y6xvFbwgtbDQ=
X-Gm-Gg: AZuq6aIvQx13KmQ3uF6Xz9brygXJBqS2MRZpQjQPk9WawbH3DkW5Oc+hfHxymY78Qj5
	/oLMgJIG6tigkEX8aKc02AqPSxLC1d2ecuaYVZDgbsi5Zc5lFSadzZlVrZIYwJUCGZgy4Gtk9lF
	UvLdFR/Wjq6xi9Wsncd5tAMqSPxCv+P90EZA/fAscpEVVd581axRmAGEZKlLQzuNv+Q4oq+fNol
	h+TGLVI9f7yE50WifKP8/a3EDrhg2oD8y6FOQ4w9Y57RSBMt34/QzLvTFqKk4zptz2oj05p6FfG
	wsB9
X-Received: by 2002:a17:907:a08:b0:b86:f999:15ba with SMTP id
 a640c23a62f3a-b8800261037mr324014966b.18.1768970731755; Tue, 20 Jan 2026
 20:45:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120062152.628822-1-sprasad@microsoft.com>
 <20260120062152.628822-4-sprasad@microsoft.com> <1261425.1768928601@warthog.procyon.org.uk>
In-Reply-To: <1261425.1768928601@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 21 Jan 2026 10:15:20 +0530
X-Gm-Features: AZwV_QipLpKyE_Go5y-JgWqa4hOk6JPI0S-9DvRdX30TjYKrDfZQ1sRu6tXnqYM
Message-ID: <CANT5p=p2wha1GYpTqRUyxxYaajH3tQbAhCdqZZBmrCqkMjswCw@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent
 with other paths
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the review, David.

On Tue, Jan 20, 2026 at 10:33=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
>
> Hi Shyam,
>
> Some immediate thoughts for you.
>
> nspmangalore@gmail.com wrote:
>
> > +                     break;
> > +             } else
> > +                     trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace=
_io_progress);
>
> The 'else' is superfluous, given the 'break'.
>
> > +             trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retr=
y_needed);

checkpatch warned me about this too. I felt that the same change
needed to go into both read and write codepath, one of which I had not
changed w.r.t the behaviour.
I don't mind submitting another version with this change.

>
> Btw, feel free to add more trace values if you want to distinguish 'retri=
es'
> from 'replays' if that makes sense.

I think it should be fine.
In fact, I was wondering if we can move these trace points to within
the subreq_terminated functions in netfs itself. Do you see any
problem with that?
That can be a follow-up patch though.

>
> >                       break;
> > -             }
> > +             } else
> > +                     trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace=
_io_progress);
>
> Superfluous 'else' again.
>
> > -                     wdata->result =3D -ENOSPC;
> > +                     result =3D -ENOSPC;
>
> I wonder if wdata->result is redundant.  Can wdata->subreq.error be used
> instead (though that's unrelated to the subject of this patch).

I agree. I did notice that too. But wanted to make pointed changes
with this patch.

>
> David
>


--=20
Regards,
Shyam
