Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF1E20126C
	for <linux-cifs@vger.kernel.org>; Fri,  8 Nov 2024 15:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731079262; cv=fail; b=ZxF/dXmNzeL3puEeRAGaFUYRGw0HRv5wm+oyy14wrcg6dYHz8nlD1+yqg065R88pQmOZy9+XZJZ02CHWSEzqfUD+Ny9JxBee/sKYcYVW0flyMTsqKXC7n1hB6dxhrUJBKDu73LA2sU9xjBe2Xy6vRVg0UMj43ayXTIJzH//LIdw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731079262; c=relaxed/simple;
	bh=bu7O9Sx69QSr3/GQGEzzI9rbtBGaP0kXXRuMdkxq4pk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=RaUBejEwrOCxsqAcYhMP3xTzpuL+nmMKCT89UDlpspzfaQS3lxMXsxe17RXuan1Apqf1zIWexm1H4+qhmlzi7L48HgMQBrTNS7HtIKgWk/IcCkcF1zoX+WnDlzKGzwv5MRnOqAsJ3trUgxlWYZs9Smp2rKdKF44GaOLSneubJgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=sbQxbx9w; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="sbQxbx9w"
Message-ID: <cc06137a94a01901ff5cd9de6a223675@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731079258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tONUFKxJF+dCjmAV+rDz2KJ3/3gZ2Fn37DrUjvVW9Z0=;
	b=sbQxbx9w+ZVuL/dU9wvYDUHdHhSs2EnirshbLTYDeUbQg4QR19oeg/fb/Ivd9aYBobW1C/
	5aPVZlABhAAIXnNUj1m/+bvz3BVgqHwSHthJ/xabDpU2+CGb9fs2yXpJ5bFuhjD27Dknd8
	s2vX/mptgGDKoXgvGs2z2oF+LKPWgWCDlFfVdQCRM2spD6nHzbClKFp5LlZe7/eBcdh1qF
	K5sQKminbyye4AXhAzAVwKLX/jdQs+3Fw/hlMDCMtS/0dfi2pJt6/e1r+jwgRxaplC849d
	d5xS81MPaZfAlvzb/EZf8ky7E1VuCVdh9N8PX6rHTpU1DAK1DmbjIhiwkQ4bIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731079258; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tONUFKxJF+dCjmAV+rDz2KJ3/3gZ2Fn37DrUjvVW9Z0=;
	b=DnWDxnqWjNkFi2ZahpfEYTQ+lQN0qMdIOBHa9fTIQStqLcDNs1umI6nDjt+O7MTs6Jp8GA
	LsRi0k2ugkYtiwC2QTSrUNOZ4FiCQ+9fw0BwsWxYuk71wbfAC6Rnr60zeTVIpuVE0Eiv74
	dLNQm7ICqtKDVX20uoNGZHfkiWUhGMR+tRPfMG4qbRRvD26Y1xOcHwlUOCrjx6HzbUiAA4
	DUJNxid9mohktow2jMF5K7FD2u+dC1CDPuSh/02YkU6nBk+CGfsETQX2YoWAP19+ZLJEdA
	oA25k2c8x0VWj8zsrM5zyMpNBhYsRFLVZPvPYzLz7J0sUEZkIMHRCxOQHBniuw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731079258; a=rsa-sha256;
	cv=none;
	b=gO6yyqctncbhYxv1vy2nT+NBnzr6Eui82sVO6TAqq8aWy+OvmMEmlgpoHnYm2ITlDGyLNb
	uHK39a/mKQTgHUnVGWPC4zReKhK8TqCyukrvCUMsT3A+gur6ovCY0LiaqVOiNe7ppsKUBC
	YYrzdGalTowpesFItSboqFWItfdTfEsLH1EmBgI8CJJk2qrdn7f9tn923yZ0UrOEY08NkZ
	nnczs6U9BsUG9LyUqB+xe6YAOM532i2ffdzlan9g0aujDP7a1t1kL3Ahd9CeLtaCeLvUP3
	D+2LKeDrJCA3TfWaeI7rugc5ePKnHy9Ktu9KQslLqeDc4f9y8K/hVRcQWKmPmg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org,
 lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
 linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, Meetakshi Setiya
 <msetiya@microsoft.com>
Subject: Re: [PATCH 2/2] cifs: support mounting with alternate password to
 allow password rotation
In-Reply-To: <CANT5p=qJ+zAU_0bMx=5uhsD1a5BR4Nj8Uv0KvNPOBNt9AtPs6w@mail.gmail.com>
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <20241030142829.234828-2-meetakshisetiyaoss@gmail.com>
 <0282479bc2f446bcb34c53a30bb53bda@manguebit.com>
 <CANT5p=qJ+zAU_0bMx=5uhsD1a5BR4Nj8Uv0KvNPOBNt9AtPs6w@mail.gmail.com>
Date: Fri, 08 Nov 2024 12:20:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Fri, Nov 8, 2024 at 12:35=E2=80=AFAM Paulo Alcantara <pc@manguebit.com=
> wrote:
>>
>> meetakshisetiyaoss@gmail.com writes:
>>
>> > @@ -2245,6 +2269,7 @@ struct cifs_ses *
>> >  cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_conte=
xt *ctx)
>> >  {
>> >       int rc =3D 0;
>> > +     int retries =3D 0;
>> >       unsigned int xid;
>> >       struct cifs_ses *ses;
>> >       struct sockaddr_in *addr =3D (struct sockaddr_in *)&server->dsta=
ddr;
>> > @@ -2263,6 +2288,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server,=
 struct smb3_fs_context *ctx)
>> >                       cifs_dbg(FYI, "Session needs reconnect\n");
>> >
>> >                       mutex_lock(&ses->session_mutex);
>> > +
>> > +retry_old_session:
>> >                       rc =3D cifs_negotiate_protocol(xid, ses, server);
>> >                       if (rc) {
>> >                               mutex_unlock(&ses->session_mutex);
>> > @@ -2275,6 +2302,13 @@ cifs_get_smb_ses(struct TCP_Server_Info *server=
, struct smb3_fs_context *ctx)
>> >                       rc =3D cifs_setup_session(xid, ses, server,
>> >                                               ctx->local_nls);
>> >                       if (rc) {
>> > +                             if (((rc =3D=3D -EACCES) || (rc =3D=3D -=
EKEYEXPIRED) ||
>> > +                                     (rc =3D=3D -EKEYREVOKED)) && !re=
tries && ses->password2) {
>> > +                                     retries++;
>> > +                                     cifs_info("Session reconnect fai=
led, retrying with alternate password\n");
>>
>> Please don't add more noisy messages over reconnect.  Remember that if
>> SMB session doesn't get re-established, there will be flood enough on
>> dmesg with "Send error in SessSetup =3D ..." messages on every 2s that
>> already pisses off users and customers.
>>
> Perhaps we could do a cifs_dbg instead of cifs_info.

Yep, with FYI.

> But Paulo, the problem here is that we retry every 2s. I think we
> should address that instead.
> One way is to do an exponential backoff every time we retry.

Agreed, but that doesn't mean we should add more noisy messages.

> I'd also want to understand why we need the reconnect work?

I see it as an optimisation to allow next IOs to not take longer because
it needs to reconnect SMB session.  If there was no prior filesystem
activity, why don't allow the client itself to reconnect the session?

Besides, SMB2_IOCTL currently doesn't call smb2_reconnect(), so
reconnect worker would be required to reconnect the session and then
allow SMB2_IOCTL to work.  We'd need to change that because with recent
special file support, we need to avoid failures when creating or parsing
reparse points because the SMB session isn't re-established yet.

> Why not always do smb2_reconnect when someone does filesystem calls on
> the mount point?

We already do for most operations.  SMB2_IOCTL and SMB2_TREE_CONNECT,
for instance, can't call smb2_reconnect() as they would deadlock.
