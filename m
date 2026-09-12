Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424D835E1AC
	for <linux-cifs@vger.kernel.org>; Sat, 12 Sep 2026 02:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789181454; cv=pass; b=X6bydoZf5V6oVa6x/EBhkZNH8ck7GjYIodi4TnLpV4YO8SOmUm/yQB6uDbhbcJpXko9p+TMsckqHRE04eqQsWzb7ObHjYrqtI6jEX+w4dC55HZI5TZEBMlkzXnTPrIUksSmLNQZAx5p/5rlkxMAjvYKMfqUo5BTh0gBChjhu2uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789181454; c=relaxed/simple;
	bh=UBF68ob9rLLcJ+B4BGI8OMKoTXkffDblP9vHlbmSr8c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kVcTzBjc2cyarV1YILBR2KAhyHpHYUm8rKqXu+FY2Trin+UYnslxZOKPgTxbrqxOz8WKQgzlTbUHxxaFONI2DmhlgxzeD6b1JYtnf6GWyxd9ALHWtlUirz4x8kvQgx3hoJpVenIhpvyIPue/4tdbS5ZpxFga/X9YMzylBtrCjhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=soekMItX; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="soekMItX"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a2ff176d5eso4107191fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 19:50:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789181451; cv=none;
        d=google.com; s=arc-20260327;
        b=mDqf9KsxN5I3zP9FMci+iY7JOO3We8s6pkwZQuGTNGoCK0nRxnKIHPVasn7XTE9DGE
         dL7uJuizWyG7n1T4bdGRpDa/4Q8xgCn4Zbi53RM7jDhFIk2dw/NqBYnadKVfadGi3c9o
         g7LxduRRMLk/JifoQtAgkDGaSlWUtc33O69uCfmOC0dMfDRxw6C4ZUKVKo61+2zWs+Tc
         Fx/iBJJZvI0DdubVA7Sh32jNxJTC2TuPyg3y5xAxB98/TrGwmq1I5SP7MyAExkeZCJ64
         MPoSS1TsetTrmNbMcysk2bTB5HJ/HCDF7ErnFgv00VXeDfVEYJSeLSRl40CPbNsOWYTX
         P6Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7lm0hPUEiNGm9wQton/cSC99gHERZOkyr34L44cajdM=;
        fh=QqMst5RkZESzqan5AjRLLm5JBu+4bRUMWhsocIgBrJs=;
        b=bKa5xk8rIGuqQhQytJ6ZcePRurNKzr8E7pwcukRXRQlUK5d27r0MrWDYu43JNsnukF
         xBu8A4vyKmLGBDMj0CiGE+RTQXEXj9DqGPw7xFU5tz1be2STmtM2hYt4U1DveCGrW0U9
         6hx3ifZXV1NN3xHQYBM8KWx4DJ2N+ZBDF/+K2e93DooNfjfTyFUBHuopQQjP83FpBfkN
         ZyX90DCj/kaw1I0hmj5j7ZYVlTF65qAmmgfX+QRitTXWJEUnTKjZEDtElpTuA9Q7Ovho
         K8yK8ojn+P7sWvJIB/q+RS3krNV5nYdnv2HcxQxCA7ioVxeFZxpC11JTTUpKCEtCmNLB
         hVOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789181451; x=1789786251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7lm0hPUEiNGm9wQton/cSC99gHERZOkyr34L44cajdM=;
        b=soekMItXA9QqFaOQZUqkhYikTmgyQ3GxeHmtHh/W776sbTPTNFfZFQZxbFmJ5lGy1r
         UTDOsYLtWXJUhDejqN6oRafURawF+E01esZbvRgC1nPi+j4D1r3Ipwhc3jeEofjFTUKZ
         ldQoE1yCZ5ZFNnqhedj8lWp227/lVMVOvmM2yDkFbBv2sJVwprjh67H/psR1EnySNc9W
         e0CfxcQrSruWo1qh3jKeUZZe7VUD2sQQcyEs+Od4HNyA1U79SEutUp2caxRzR6VKiQx1
         pRnd4AHMowh+qp+/4l3tTZ7bwn+L17kIBucZWbG5eQQAg1DrRWavNsaIjxw2ZyD6HwqZ
         OOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789181451; x=1789786251;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7lm0hPUEiNGm9wQton/cSC99gHERZOkyr34L44cajdM=;
        b=sFBquTrufQqVxGwrBraWHYlsJjhBKU1TeU0b64NGjU3uZdkj3xdyTiD0xfJW1KDocV
         f7LIgFpw9NudtJ6ypWeoVo9P5wLgnOytC3IkiFWLDULkaDnJIUN+j4OgvUbRU9UyTJk3
         KKWlR6cFoSW8+UJFYP05nOMgUkUiT9NyZCFG/Q8JVMnJ6YVAxrH1YjfNHmbYpeSvt64q
         5pAFC0NI1CdaL9Nkvk1uog9MWqmlkATp4nLnGDP6EMcpV4Py5l62GcxAy603jfTKEoFu
         jlQuTj1H1L8Om0l60MXKjDzQB4P06H01pOZtH0G4IpuIXW50HgwSQUOgL6sNf5fQm0ZL
         ptbA==
X-Forwarded-Encrypted: i=1; AKwUvBw2t5aE43S+139BMfarPXgAYe5KwxmwVM4GzJqvQr9zyAhlqq9CMcWAyY8Qj+CZzfKogjZCWy9KDm5f@vger.kernel.org
X-Gm-Message-State: AFuF++k9dtR/hXai09PN7eKiTCh3Ml7Jdu+0RLXcvyarAANb++lSg8uR
	fjxyz8Fbs+P4be1Hj1DRptns8WFhWQXMnhdur6imSUzYV5AXI8g5ezRRhML2gyoTZlLADelOHQF
	poKcchKvFnlj0owSZMPo4AY1Iy/JWPg1ua0BNdlG3SSo=
X-Gm-Gg: AYBFou0DnjzLa2eTUw+XZ5Z9qF4Yp1diVutWCPqBnG64gYQhblol5mOvT5J8O0P7XKw
	VtcfV/cb4/TGdWtDZb75ApZOc/ZqfflyhVjaayI0xlD+QUNWgeMAzS2lyrGH0Pa9icKVuoru3AX
	KyH6QetFcSo0/csr7PML04K2fRy0rFA2dnd3On5hcTuIghMpyr0n51lC8gGP/QuYqqBJhRY7uyQ
	r/VHJRHYh1I6tZb1JiuRFy16K1dbGAng30BibJMsStkJDN3mHum1AMgEcKEAIgJ/Q8+MgSsamXQ
	sk9IHVYJJba+sG780Q6eXe1RlDn9DgfJ2uqLqZCcQQwDwk4mPzUK/4fX0Ci8XSQsn8KYjLBArfU
	QIuIXqiFsZQ==
X-Received: by 2002:a05:651c:1503:b0:3a4:99ed:beac with SMTP id
 38308e7fff4ca-3a5a51c9fc4mr17435271fa.4.1789181451073; Fri, 11 Sep 2026
 19:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1788516372.git.zihanx@nebusec.ai> <20260904140527.62354-1-zihanx@nebusec.ai>
 <20260911170034.1236993-1-sorenson@redhat.com>
In-Reply-To: <20260911170034.1236993-1-sorenson@redhat.com>
From: zihan xi <zihanx@nebusec.ai>
Date: Sat, 12 Sep 2026 10:50:38 +0800
X-Gm-Features: AcwNN1U-uRTqt8ykL8GuFuZ-SOYux8MbyRejD1SIf3LqoAgM1qpEMJQANafNEo0
Message-ID: <CAANe3eQwGetW4jWjGrjCwO+kXhGbDJpE5iMhVbWkJBGp+Do+MQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] smb: client: fix create context out-of-bounds reads
To: Frank Sorenson <sorenson@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Pavel Shilovsky <pshilovsky@samba.org>, Aurelien Aptel <aaptel@suse.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 1:05=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> On Fri, Sep 04, 2026 at 02:05:17PM +0000, Zihan Xi wrote:
> > smb2_parse_contexts() validates the complete create-context area but do=
es
> > not bound each context record by its Next field before dispatching to a
> > handler.  A malformed chain can therefore expose bytes past one context=
 to
> > the handler.  The QFid handler also used a full response-structure cast=
 even
> > though it only consumes DiskFileId.
>
> Hello,
>
> I have some thoughts/comments on your series.
>
> First, a possible reason for not getting a response on your v2, and
> delayed response on this v3: Steve French passed away in August, so
> mail addressed to him isn't reaching a maintaner, and things may
> have gotten missed during transitions.  You'll want to send future
> versions to Paulo Alcantara <pc@manguebit.org>, with Cc to
> Namjae Jeon <linkinjeon@kernel.org>
>
>
> I've been carrying an overlapping patch (an earlier posting:
> https://lore.kernel.org/r/20260826153147.4112943-12-sorenson@redhat.com).
> in a bounds-checking series of my own.  Like yours, my patch has
> been addressing the memory safety problem in the three handlers
> which read at fixed offsets, rather than the generic checks.
>
> But I think yours is probably a better fix, and you've got the
> PoC, so if we can perfect yours and get it in, I'll be dropping
> mine in favor of this series.
>
>
> A few points (take with a grain of salt):
>
> 1) The lease parser still reads at a fixed offset rather than from
>    DataOffset:
>
> >               case 4:
> >                       if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4))=
 {
> > -                             *oplock =3D server->ops->parse_lease_buf(=
cc, epoch,
> > +                             if (cc_len >=3D smb2_create_lease_min_cc_=
len(server))
> > +                                     *oplock =3D server->ops->parse_le=
ase_buf(cc, epoch,
> >                                                                      le=
ase_key);
>
> cc_len bounds the record, so the read stays in bounds.  But this is
> just like the QFid bug you just fixed nearby:  smb2_parse_lease_buf()
> and smb3_parse_lease_buf() reach the fields at the canonical offset
> of the create_lease layout, not at DataOffset, so a valid but non-
> canonical DataOffset could get in-bounds garbage rather than an
> OOB.  That's not a security fix, but since LeaseState drives client
> caching decisions, it's probably worth closing.  Reading lcontext
> from DataOffset, as with DiskFileId would make the two handlers
> consistent.
>
> (My version also had this, so it's more an observation than anything
> else)
>
>
> 2) You may want to consider matching DataLength exactly, rather than
>    taking a minimum.
>
> ksmbd's parse_lease_state() requires:
>
>         sizeof(struct lease_context_v2) =3D=3D le32_to_cpu(cc->DataLength=
)
>
> and validates DataOffset + DataLength against the create_lease_v2
> size, rather than accepting anything at least long enough.  It was
> suggested to me that having the client & server halves agree on
> strictness would be good.
>
> (I did confirm your minimums cover all the fields each of the parsers
> actually touch, so this is about strictness, not a hole)
>
>
> Frank
> --
> Frank Sorenson
> sorenson@redhat.com
> Principal Software Maintenance Engineer, filesystems
> Red Hat
>

Hi Frank,

Thank you for the review.  I'm sorry to hear about Steve.  I'll send
future versions to Paulo Alcantara, with Cc to Namjae Jeon.

I also appreciate you carrying the overlapping bounds-checking series.

I'll address both comments in v4 and send it as a new thread:

1) smb2_parse_lease_buf() and smb3_parse_lease_buf() will copy the
   lease context from DataOffset, as the QFid handler does for
   DiskFileId.  Agreed this is not a security fix; it just keeps
   LeaseState correct when DataOffset is non-canonical.

2) DataLength will be required to equal sizeof(struct lease_context)
   or sizeof(struct lease_context_v2) for the corresponding parser,
   rather than a minimum.  A mismatch skips lease parsing and does
   not fail the open.

Thanks,
Zihan
