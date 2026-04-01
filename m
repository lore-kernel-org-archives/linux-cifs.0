Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9161EB19B
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 00:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775005115; cv=none; b=hmgMGvVJdmAy/YEzJzbW9QC7uLx2tdG/o6//tpSzlrk95X7uOBdhlETKRRGe2RBNUp/YSzEMharn49zIvf27Pv7Y/q9WeWYQ24eicsOsUS+5j9iauyBVm0t9I9awDqn0w9HcQrdX/6nTgeNAiI/65gOSXPAmbVlP9VsLOnVqXvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775005115; c=relaxed/simple;
	bh=T2LlsgVVfPIx2czYsFGZCHDZmbf9Lgooxf/w/S3hkFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aatmzcSrfeJVh41jiB7Ye1CwCGnTKLxIujYAcydnxcOjI4YhT+Dk86dF2/Dd2ENTn7PfArCxFT6P7dNOsO+ZFRPo772oAsBTdR5vvEnHQmsvmuycqOqk3tCXqfxhhBQE3pmKhlBZRhcxHUBtPkntVB+Zy4AXKImdDwb1L9EdI4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=T2fqGr1B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T5+9Dx7R; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=T2fqGr1B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=T5+9Dx7R; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="T2fqGr1B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T5+9Dx7R";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="T2fqGr1B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="T5+9Dx7R"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D9CE4D2AD;
	Wed,  1 Apr 2026 00:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775005112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2b/c16+AiQSV2G+Sf2iy46TVO0mIRDCbyfLR5aAcAo=;
	b=T2fqGr1BZ0r3G2fxMWBAScUXFXpg+umyrq/RU6mjItJq6031bAzFoOEnkHeB6uoYu0Gpbb
	bah7io4w+aXG6fXtTEYob5Pa4AfYao2bQUDVVpJtvmf0OBp9MSUnXZgI5TVqgLfFuO+oNV
	zLaummSazMN3kNAJmQax1ZtejqX21DQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775005112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2b/c16+AiQSV2G+Sf2iy46TVO0mIRDCbyfLR5aAcAo=;
	b=T5+9Dx7R3gBEnO+d0niilBbctmQfUsyN0qbNSQeZqQ4tJME9eeBbeG/p2ldgSXYJf9fCqq
	8SVqFUTeD6noz4Ag==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775005112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2b/c16+AiQSV2G+Sf2iy46TVO0mIRDCbyfLR5aAcAo=;
	b=T2fqGr1BZ0r3G2fxMWBAScUXFXpg+umyrq/RU6mjItJq6031bAzFoOEnkHeB6uoYu0Gpbb
	bah7io4w+aXG6fXtTEYob5Pa4AfYao2bQUDVVpJtvmf0OBp9MSUnXZgI5TVqgLfFuO+oNV
	zLaummSazMN3kNAJmQax1ZtejqX21DQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775005112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D2b/c16+AiQSV2G+Sf2iy46TVO0mIRDCbyfLR5aAcAo=;
	b=T5+9Dx7R3gBEnO+d0niilBbctmQfUsyN0qbNSQeZqQ4tJME9eeBbeG/p2ldgSXYJf9fCqq
	8SVqFUTeD6noz4Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF0424A0B0;
	Wed,  1 Apr 2026 00:58:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OTrEGLZtzGkEGwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Wed, 01 Apr 2026 00:58:30 +0000
Date: Wed, 1 Apr 2026 11:58:24 +1100
From: David Disseldorp <ddiss@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, Bruno Bierbaumer <bruno@bierbaumer.net>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
Message-ID: <20260401115824.447004b8.ddiss@suse.de>
In-Reply-To: <CAH2r5mu56K0Ew8XHaVEsGK9KgxHv34WN5EkXTKUvFtxydFp9zQ@mail.gmail.com>
References: <20260331000911.16062-1-ddiss@suse.de>
	<CAH2r5mu56K0Ew8XHaVEsGK9KgxHv34WN5EkXTKUvFtxydFp9zQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[bierbaumer.net:email,suse.com:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,samba.org:url];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Tue, 31 Mar 2026 18:56:05 -0500, Steve French wrote:

> added RB from Henrique and updated
> git.samba.org/data/git/cifs-utils.git and
> https://github.com/smfrench/smb3-utils for-next

Thanks Steve. FWIW, the reviewed-by tag has an incorrect email address:
  Reviewed-by: Henrique Carvalho <[2]henrique.carvalho@suse.com>
Should be
  Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

I'll close the corresponding PR at
https://github.com/smfrench/smb3-utils/pull/16

Cheers, David

> On Mon, Mar 30, 2026 at 7:10=E2=80=AFPM David Disseldorp <ddiss@suse.de> =
wrote:
> >
> > The existing (j > pass_length) check is insufficient to avoid dst buffer
> > overrun into the start of the adjacent struct parsed_mount_info field.
> > Check for overrun before writing to dst, and account for comma-expansion
> > and null-termination.
> >
> > Bug: https://bugzilla.samba.org/show_bug.cgi?id=3D16044
> >
> > Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >  mount.cifs.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index 1923913..d41ca6a 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_inf=
o, const char *src,
> >         unsigned int i =3D 0, j =3D 0;
> >
> >         while (src[i]) {
> > -               if (src[i] =3D=3D ',')
> > -                       dst[j++] =3D ',';
> > -               dst[j++] =3D src[i++];
> > -               if (j > pass_length) {
> > +               if (j + 2 >=3D pass_length) {
> >                         fprintf(stderr, "Converted password too long!\n=
");
> >                         return EX_USAGE;
> >                 }
> > +               if (src[i] =3D=3D ',')
> > +                       dst[j++] =3D ',';
> > +               dst[j++] =3D src[i++];
> >         }
> >         dst[j] =3D '\0';
> >         if (is_pass2)
> > --
> > 2.51.0
> > =20
>=20
>=20

